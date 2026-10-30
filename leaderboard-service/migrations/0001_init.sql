CREATE TABLE players (
  installation_id TEXT PRIMARY KEY,
  secret_hash TEXT NOT NULL,
  nickname TEXT NOT NULL,
  created_at TEXT NOT NULL,
  deleted_at TEXT
);

CREATE TABLE submissions (
  run_id TEXT PRIMARY KEY,
  installation_id TEXT NOT NULL REFERENCES players(installation_id),
  nickname TEXT NOT NULL,
  wave INTEGER NOT NULL CHECK(wave BETWEEN 1 AND 1000000),
  received_at TEXT NOT NULL
);

CREATE TABLE scores (
  installation_id TEXT PRIMARY KEY REFERENCES players(installation_id),
  nickname TEXT NOT NULL,
  wave INTEGER NOT NULL,
  best_run_id TEXT NOT NULL REFERENCES submissions(run_id),
  received_at TEXT NOT NULL,
  hidden INTEGER NOT NULL DEFAULT 0 CHECK(hidden IN (0,1)),
  name_hidden INTEGER NOT NULL DEFAULT 0 CHECK(name_hidden IN (0,1))
);

CREATE TABLE replays (
  run_id TEXT PRIMARY KEY REFERENCES submissions(run_id),
  installation_id TEXT NOT NULL REFERENCES players(installation_id),
  object_key TEXT NOT NULL UNIQUE,
  status TEXT NOT NULL CHECK(status IN ('pending','uploading','ready','previous','missing')),
  size_bytes INTEGER NOT NULL DEFAULT 0,
  uploaded_at TEXT,
  payload_sha256 TEXT,
  upload_token TEXT,
  upload_started_at INTEGER
);

CREATE TABLE reports (
  report_id TEXT PRIMARY KEY,
  request_id TEXT NOT NULL UNIQUE,
  installation_id TEXT,
  run_id TEXT,
  category TEXT NOT NULL,
  object_key TEXT NOT NULL UNIQUE,
  status TEXT NOT NULL DEFAULT 'open' CHECK(status IN ('open','reviewed','dismissed')),
  created_at TEXT NOT NULL,
  FOREIGN KEY(installation_id) REFERENCES players(installation_id)
);

CREATE TABLE auth_attempts (
  ip_hash TEXT NOT NULL,
  occurred_at INTEGER NOT NULL
);
CREATE TABLE player_deletion_objects (
  installation_id TEXT NOT NULL,
  object_key TEXT NOT NULL,
  PRIMARY KEY(installation_id, object_key)
);
CREATE INDEX auth_attempts_time ON auth_attempts(ip_hash, occurred_at);
CREATE INDEX scores_rank ON scores(hidden, wave DESC, received_at ASC, installation_id ASC);
CREATE INDEX reports_status ON reports(status, created_at DESC);
CREATE INDEX replays_upload_claim ON replays(status, upload_started_at);

CREATE TRIGGER submissions_require_active_player BEFORE INSERT ON submissions
WHEN (SELECT deleted_at FROM players WHERE installation_id=NEW.installation_id) IS NOT NULL
BEGIN
  SELECT RAISE(ABORT, 'player deleted');
END;

CREATE TRIGGER reports_require_active_player BEFORE INSERT ON reports
WHEN NEW.installation_id IS NOT NULL AND
  (SELECT deleted_at FROM players WHERE installation_id=NEW.installation_id) IS NOT NULL
BEGIN
  SELECT RAISE(ABORT, 'player deleted');
END;

CREATE TRIGGER submission_updates_best AFTER INSERT ON submissions
BEGIN
  UPDATE replays SET status=CASE WHEN uploaded_at IS NULL THEN 'missing' ELSE 'previous' END
    WHERE installation_id=NEW.installation_id AND status IN ('ready','pending')
      AND run_id=(SELECT best_run_id FROM scores WHERE installation_id=NEW.installation_id)
      AND NEW.wave > (SELECT wave FROM scores WHERE installation_id=NEW.installation_id);
  INSERT INTO scores(installation_id,nickname,wave,best_run_id,received_at)
  VALUES(NEW.installation_id,NEW.nickname,NEW.wave,NEW.run_id,NEW.received_at)
  ON CONFLICT(installation_id) DO UPDATE SET
    nickname=excluded.nickname, wave=excluded.wave,
    best_run_id=excluded.best_run_id, received_at=excluded.received_at
  WHERE excluded.wave > scores.wave;
  INSERT OR IGNORE INTO replays(run_id,installation_id,object_key,status)
    SELECT NEW.run_id,NEW.installation_id,'replays/'||NEW.run_id,
      CASE WHEN (SELECT best_run_id FROM scores WHERE installation_id=NEW.installation_id)=NEW.run_id THEN 'pending' ELSE 'previous' END;
END;

CREATE TRIGGER player_delete_cleans_data BEFORE UPDATE OF deleted_at ON players
WHEN NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL
BEGIN
  INSERT OR IGNORE INTO player_deletion_objects(installation_id,object_key)
    SELECT OLD.installation_id,object_key FROM replays WHERE installation_id=OLD.installation_id;
  INSERT OR IGNORE INTO player_deletion_objects(installation_id,object_key)
    SELECT OLD.installation_id,object_key FROM reports WHERE installation_id=OLD.installation_id;
  DELETE FROM scores WHERE installation_id=OLD.installation_id;
  DELETE FROM replays WHERE installation_id=OLD.installation_id;
  DELETE FROM submissions WHERE installation_id=OLD.installation_id;
  DELETE FROM reports WHERE installation_id=OLD.installation_id;
END;
