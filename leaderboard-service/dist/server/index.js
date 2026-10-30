const JSON_HEADERS = { "content-type": "application/json; charset=utf-8", "cache-control": "no-store" };
const MAX_REPLAY_BYTES = 5 * 1024 * 1024;
const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

function response(data, status = 200, headers = {}) {
  return new Response(JSON.stringify(data), { status, headers: { ...JSON_HEADERS, ...headers } });
}
function fail(status, error) { return response({ error }, status); }
function validId(value) { return typeof value === "string" && UUID_RE.test(value); }
function cleanNickname(value) {
  if (typeof value !== "string") return null;
  const name = value.normalize("NFKC").replace(/[<>\u0000-\u001f\u007f]/g, "").trim();
  if (name.length < 1 || [...name].length > 24 || hasInappropriateNickname(name)) return null;
  return name;
}
function hasInappropriateNickname(value) {
  const ascii = value.normalize("NFKD").replace(/[\u0300-\u036f]/g, "").toLowerCase();
  const separator = "[^a-z0-9]*";
  const words = [
    `f${separator}u${separator}c${separator}k(?:${separator}(?:s|ed|ing))?`,
    `s${separator}h${separator}i${separator}t(?:${separator}(?:s|ty|ting))?`,
    `b${separator}i${separator}t${separator}c${separator}h(?:${separator}(?:es|ed))?`,
    `a${separator}s${separator}s${separator}h${separator}o${separator}l${separator}e`,
    `b${separator}a${separator}s${separator}t${separator}a${separator}r${separator}d`,
    `d${separator}i${separator}c${separator}k`, `c${separator}u${separator}n${separator}t`,
    `c${separator}o${separator}c${separator}k`, `p${separator}i${separator}s${separator}s`,
    `n${separator}i${separator}g${separator}g${separator}e${separator}r`,
    `n${separator}i${separator}g${separator}g${separator}a`,
    `f${separator}a${separator}g${separator}g${separator}o${separator}t`,
  ];
  return words.some((pattern) => new RegExp(`(^|[^a-z0-9])${pattern}([^a-z0-9]|$)`, "i").test(ascii));
}
function constantTimeEqual(a, b) {
  if (typeof a !== "string" || typeof b !== "string") return false;
  let diff = a.length ^ b.length;
  const max = Math.max(a.length, b.length);
  for (let i = 0; i < max; i++) diff |= (a.charCodeAt(i) || 0) ^ (b.charCodeAt(i) || 0);
  return diff === 0;
}
async function sha256(value) {
  const digest = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(value));
  return [...new Uint8Array(digest)].map((b) => b.toString(16).padStart(2, "0")).join("");
}
async function sha256Bytes(value) {
  const digest = await crypto.subtle.digest("SHA-256", value);
  return [...new Uint8Array(digest)].map((b) => b.toString(16).padStart(2, "0")).join("");
}
async function bodyJson(request) {
  try {
    const bytes = await readLimitedBody(request, 16 * 1024);
    return JSON.parse(new TextDecoder().decode(bytes));
  } catch { return null; }
}
async function readLimitedBody(request, maxBytes) {
  const advertised = Number(request.headers.get("Content-Length") || 0);
  if (advertised > maxBytes) throw new RangeError("body too large");
  const reader = request.body?.getReader();
  if (!reader) return new Uint8Array();
  const chunks = [];
  let total = 0;
  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    total += value.byteLength;
    if (total > maxBytes) { await reader.cancel(); throw new RangeError("body too large"); }
    chunks.push(value);
  }
  const output = new Uint8Array(total);
  let offset = 0;
  for (const chunk of chunks) { output.set(chunk, offset); offset += chunk.byteLength; }
  return output;
}
function requireBindings(env) {
  if (!env?.DB || !env?.BUCKET) throw new Error("Missing DB or BUCKET binding");
}
async function deleteObjectOrQueue(env, installationId, objectKey) {
  try {
    await env.BUCKET.delete(objectKey);
  } catch (error) {
    if (installationId) {
      await env.DB.prepare(`INSERT OR IGNORE INTO player_deletion_objects(installation_id,object_key)
        SELECT ?,? WHERE EXISTS (SELECT 1 FROM players WHERE installation_id=? AND deleted_at IS NOT NULL)`)
        .bind(installationId, objectKey, installationId).run();
    }
    throw error;
  }
}
async function rateLimit(request, env, bucket) {
  const ip = request.headers.get("CF-Connecting-IP") || "unknown";
  const ipHash = await sha256(ip);
  const now = Math.floor(Date.now() / 1000);
  await env.DB.prepare("INSERT INTO auth_attempts(ip_hash,occurred_at) VALUES(?,?)").bind(ipHash, now).run();
  if (Math.random() < 0.02) await env.DB.prepare("DELETE FROM auth_attempts WHERE occurred_at<?").bind(now - 3600).run();
  const result = await env.DB.prepare("SELECT COUNT(*) AS n FROM auth_attempts WHERE ip_hash=? AND occurred_at>?")
    .bind(ipHash, now - 600).first();
  if ((result?.n || 0) > bucket) return false;
  return true;
}
function bearer(request) {
  const value = request.headers.get("Authorization") || "";
  const match = /^Bearer ([A-Za-z0-9_-]{32,128})$/.exec(value);
  return match?.[1] || null;
}
async function authorizedPlayer(request, env, installationId, allowDeleted = false) {
  if (!validId(installationId)) return null;
  if (!(await rateLimit(request, env, 40))) return "limited";
  const secret = bearer(request);
  if (!secret) return null;
  const row = await env.DB.prepare("SELECT secret_hash,deleted_at FROM players WHERE installation_id=?")
    .bind(installationId).first();
  if (!row || (!allowDeleted && row.deleted_at) || !constantTimeEqual(await sha256(secret), row.secret_hash)) return null;
  return true;
}
async function handle(request, env) {
  const url = new URL(request.url);
  const path = url.pathname;
  if (request.method === "OPTIONS") return new Response(null, { status: 204 });

  if (path === "/api/health" && request.method === "GET") return response({ ok: true });

  if (path === "/api/player" && request.method === "POST") {
    if (!(await rateLimit(request, env, 12))) return fail(429, "too many registrations");
    const body = await bodyJson(request);
    const nickname = cleanNickname(body?.nickname);
    if (!nickname) return fail(400, "nickname must contain 1–24 characters");
    const installationId = crypto.randomUUID();
    const installationSecret = `${crypto.randomUUID()}${crypto.randomUUID()}`;
    const now = new Date().toISOString();
    await env.DB.prepare("INSERT INTO players(installation_id,secret_hash,nickname,created_at) VALUES(?,?,?,?)")
      .bind(installationId, await sha256(installationSecret), nickname, now).run();
    return response({ installation_id: installationId, installation_secret: installationSecret, nickname }, 201);
  }

  if (path === "/api/player" && request.method === "PATCH") {
    const body = await bodyJson(request);
    if (!validId(body?.installation_id)) return fail(400, "installation_id must be a UUID");
    const nickname = cleanNickname(body?.nickname);
    if (!nickname) return fail(400, "nickname must contain 1–24 characters");
    const auth = await authorizedPlayer(request, env, body.installation_id);
    if (auth === "limited") return fail(429, "too many authorization attempts");
    if (!auth) return fail(401, "invalid installation credentials");
    const results = await env.DB.batch([
      env.DB.prepare("UPDATE players SET nickname=? WHERE installation_id=? AND deleted_at IS NULL").bind(nickname, body.installation_id),
      env.DB.prepare("UPDATE scores SET nickname=? WHERE installation_id=? AND EXISTS (SELECT 1 FROM players WHERE installation_id=? AND deleted_at IS NULL)").bind(nickname, body.installation_id, body.installation_id),
    ]);
    if (!(results?.[0]?.meta?.changes > 0)) return fail(410, "player was deleted");
    return response({ updated: true, nickname });
  }

  if (path === "/api/scores" && request.method === "POST") {
    const body = await bodyJson(request);
    if (!validId(body?.installation_id) || !validId(body?.run_id)) return fail(400, "installation_id and run_id must be UUIDs");
    const nickname = cleanNickname(body?.nickname);
    const wave = Number(body?.wave);
    if (!nickname || !Number.isSafeInteger(wave) || wave < 1 || wave > 1000000) return fail(400, "invalid nickname or wave");
    const auth = await authorizedPlayer(request, env, body.installation_id);
    if (auth === "limited") return fail(429, "too many authorization attempts");
    if (!auth) return fail(401, "invalid installation credentials");
    const receivedAt = new Date().toISOString();
    let inserted;
    try {
      inserted = await env.DB.prepare("INSERT OR IGNORE INTO submissions(run_id,installation_id,nickname,wave,received_at) VALUES(?,?,?,?,?)")
        .bind(body.run_id, body.installation_id, nickname, wave, receivedAt).run();
    } catch (error) {
      const active = await env.DB.prepare("SELECT 1 AS active FROM players WHERE installation_id=? AND deleted_at IS NULL").bind(body.installation_id).first();
      if (!active) return fail(410, "player was deleted");
      throw error;
    }
    const prior = await env.DB.prepare("SELECT installation_id,nickname,wave FROM submissions WHERE run_id=?").bind(body.run_id).first();
    if (!prior || prior.installation_id !== body.installation_id || prior.nickname !== nickname || prior.wave !== wave) return fail(409, "run_id already used with different submission data");
    const score = await env.DB.prepare("SELECT wave,best_run_id,received_at FROM scores WHERE installation_id=?")
      .bind(body.installation_id).first();
    return response({ accepted: true, replayed: !(inserted?.meta?.changes > 0), is_best: score?.best_run_id === body.run_id,
      best_wave: score?.wave ?? null, best_run_id: score?.best_run_id ?? null, received_at: prior.received_at,
      verification_status: "unverified", moderation_required: true }, 200);
  }

  if (path === "/api/leaderboard" && request.method === "GET") {
    const limit = Math.min(100, Math.max(1, Number.parseInt(url.searchParams.get("limit") || "100", 10) || 100));
    const nickname = (url.searchParams.get("nickname") || "").trim().slice(0, 24);
    const rows = await env.DB.prepare(`SELECT ranked.rank,ranked.installation_id AS entry_id,
      CASE WHEN ranked.name_hidden=1 THEN 'Anonymous' ELSE ranked.nickname END AS nickname,
      ranked.wave,ranked.best_run_id AS run_id,ranked.received_at,r.status AS replay_status
      FROM (SELECT s.installation_id,s.nickname,s.name_hidden,s.wave,s.best_run_id,s.received_at,
        ROW_NUMBER() OVER (ORDER BY s.wave DESC,s.received_at ASC,s.installation_id ASC) AS rank
        FROM scores s WHERE s.hidden=0) ranked LEFT JOIN replays r ON r.run_id=ranked.best_run_id
      WHERE (?='' OR lower(CASE WHEN ranked.name_hidden=1 THEN 'Anonymous' ELSE ranked.nickname END) LIKE '%'||lower(?)||'%')
      ORDER BY ranked.rank LIMIT ?`).bind(nickname,nickname,limit).all();
    return response({ scores: (rows.results || []).map(row => ({ ...row, verification_status: "unverified", moderation_required: true })) });
  }

  const rankMatch = /^\/api\/players\/([^/]+)\/rank$/.exec(path);
  if (rankMatch && request.method === "GET") {
    if (!validId(rankMatch[1])) return fail(400, "invalid entry_id");
    const row = await env.DB.prepare(`SELECT rank FROM (SELECT installation_id,
      ROW_NUMBER() OVER (ORDER BY wave DESC,received_at ASC,installation_id ASC) AS rank
      FROM scores WHERE hidden=0) WHERE installation_id=?`).bind(rankMatch[1]).first();
    return row ? response({ entry_id: rankMatch[1], rank: row.rank }) : fail(404, "entry not found");
  }

  const replayMatch = /^\/api\/replays\/([^/]+)$/.exec(path);
  if (replayMatch && request.method === "PUT") {
    const runId = replayMatch[1];
    const installationId = url.searchParams.get("installation_id");
    if (!validId(runId) || !validId(installationId)) return fail(400, "valid run_id and installation_id required");
    const auth = await authorizedPlayer(request, env, installationId);
    if (auth === "limited") return fail(429, "too many authorization attempts");
    if (!auth) return fail(401, "invalid installation credentials");
    const meta = await env.DB.prepare("SELECT installation_id,status,object_key,payload_sha256,upload_token,upload_started_at FROM replays WHERE run_id=?").bind(runId).first();
    if (!meta || meta.installation_id !== installationId) return fail(404, "replay upload slot not found");
    let bytes;
    try { bytes = await readLimitedBody(request, MAX_REPLAY_BYTES); }
    catch { return fail(413, "replay must be 1 byte to 5 MiB"); }
    if (bytes.byteLength < 1) return fail(413, "replay must be 1 byte to 5 MiB");
    const digest = await sha256Bytes(bytes);
    if (meta.payload_sha256 && meta.payload_sha256 !== digest) return fail(409, "run replay bytes differ from its first upload attempt");
    if (meta.status === "ready") return response({ uploaded: true, replayed: true, status: "ready",
      verification_status: "unverified", moderation_required: true });
    const now = Math.floor(Date.now() / 1000);
    const token = crypto.randomUUID();
    let claimed;
    if (meta.status === "uploading") {
      if (now - (meta.upload_started_at || 0) < 120) return response({ uploaded: false, status: "pending", retry_after_seconds: 2 }, 202);
      claimed = await env.DB.prepare(`UPDATE replays SET upload_token=?,upload_started_at=?
        WHERE run_id=? AND installation_id=? AND status='uploading' AND upload_token=? AND upload_started_at<?
          AND payload_sha256=? AND EXISTS (SELECT 1 FROM players WHERE installation_id=? AND deleted_at IS NULL)`)
        .bind(token, now, runId, installationId, meta.upload_token, now - 120, digest, installationId).run();
    } else if (["pending", "missing"].includes(meta.status)) {
      claimed = await env.DB.prepare(`UPDATE replays SET status='uploading',payload_sha256=COALESCE(payload_sha256,?),upload_token=?,upload_started_at=?
        WHERE run_id=? AND installation_id=? AND status IN ('pending','missing') AND (payload_sha256 IS NULL OR payload_sha256=?)
          AND EXISTS (SELECT 1 FROM players WHERE installation_id=? AND deleted_at IS NULL)`)
        .bind(digest, token, now, runId, installationId, digest, installationId).run();
    } else {
      return fail(409, "replay is not uploadable in its current state");
    }
    if (!(claimed?.meta?.changes > 0)) {
      const current = await env.DB.prepare("SELECT status,payload_sha256 FROM replays WHERE run_id=? AND installation_id=?").bind(runId, installationId).first();
      const active = await env.DB.prepare("SELECT 1 AS active FROM players WHERE installation_id=? AND deleted_at IS NULL").bind(installationId).first();
      if (!active) return fail(410, "player was deleted");
      if (current?.status === "ready" && current.payload_sha256 === digest) return response({ uploaded: true, replayed: true, status: "ready", verification_status: "unverified", moderation_required: true });
      return fail(409, "another replay upload is in progress or the run is unavailable");
    }
    try {
      await env.BUCKET.put(meta.object_key, bytes, { httpMetadata: { contentType: "application/octet-stream" } });
    } catch (error) {
      await env.DB.prepare(`UPDATE replays SET status=CASE WHEN (SELECT best_run_id FROM scores WHERE installation_id=?)=run_id THEN 'pending' ELSE 'missing' END,
        upload_token=NULL,upload_started_at=NULL WHERE run_id=? AND installation_id=? AND status='uploading' AND upload_token=?
          AND EXISTS (SELECT 1 FROM players WHERE installation_id=? AND deleted_at IS NULL)`)
        .bind(installationId, runId, installationId, token, installationId).run();
      throw error;
    }
    const finished = await env.DB.prepare(`UPDATE replays SET
        status=CASE WHEN (SELECT best_run_id FROM scores WHERE installation_id=?)=? THEN 'ready' ELSE 'previous' END,
        size_bytes=?,uploaded_at=?,upload_token=NULL,upload_started_at=NULL
      WHERE run_id=? AND installation_id=? AND status='uploading' AND upload_token=? AND payload_sha256=?
        AND EXISTS (SELECT 1 FROM players WHERE installation_id=? AND deleted_at IS NULL)`)
      .bind(installationId, runId, bytes.byteLength, new Date().toISOString(), runId, installationId, token, digest, installationId).run();
    if (!(finished?.meta?.changes > 0)) {
      const current = await env.DB.prepare("SELECT status,upload_token,payload_sha256 FROM replays WHERE run_id=? AND installation_id=?").bind(runId, installationId).first();
      const active = await env.DB.prepare("SELECT 1 AS active FROM players WHERE installation_id=? AND deleted_at IS NULL").bind(installationId).first();
      if (!current || !active) {
        await deleteObjectOrQueue(env, installationId, meta.object_key);
        return fail(410, "player or replay was deleted");
      }
      if (current.status === "ready" && current.payload_sha256 === digest) return response({ uploaded: true, replayed: true, status: "ready", verification_status: "unverified", moderation_required: true });
      return response({ uploaded: false, status: current.status, retry_after_seconds: 2 }, 202);
    }
    const replay = await env.DB.prepare("SELECT status FROM replays WHERE run_id=? AND installation_id=?").bind(runId, installationId).first();
    return response({ uploaded: true, replayed: false, status: replay?.status || "missing", size_bytes: bytes.byteLength,
      verification_status: "unverified", moderation_required: true }, 201);
  }
  if (replayMatch && request.method === "GET") {
    const runId = replayMatch[1];
    if (!validId(runId)) return fail(400, "invalid run_id");
    const meta = await env.DB.prepare(`SELECT r.object_key,r.status,r.size_bytes,COALESCE(s.hidden,0) AS score_hidden
      FROM replays r LEFT JOIN scores s ON s.installation_id=r.installation_id WHERE r.run_id=?`).bind(runId).first();
    if (!meta || !["ready", "previous", "missing"].includes(meta.status)) return fail(404, "replay not available");
    if (meta.score_hidden) return fail(404, "replay not available");
    const object = await env.BUCKET.get(meta.object_key);
    if (!object) {
      await env.DB.prepare("UPDATE replays SET status='missing' WHERE run_id=?").bind(runId).run();
      return fail(404, "replay object missing");
    }
    return new Response(object.body, { headers: { "content-type": "application/octet-stream", "content-length": String(meta.size_bytes),
      "cache-control": "public, max-age=31536000, immutable", "x-replay-verification": "unverified" } });
  }

  if (path === "/api/player" && request.method === "DELETE") {
    const installationId = url.searchParams.get("installation_id");
    const auth = await authorizedPlayer(request, env, installationId, true);
    if (auth === "limited") return fail(429, "too many authorization attempts");
    if (!auth) return fail(401, "invalid installation credentials");
    await env.DB.prepare("UPDATE players SET deleted_at=? WHERE installation_id=? AND deleted_at IS NULL")
      .bind(new Date().toISOString(), installationId).run();
    const objects = await env.DB.prepare("SELECT object_key FROM player_deletion_objects WHERE installation_id=?")
      .bind(installationId).all();
    for (const row of objects.results || []) {
      await env.BUCKET.delete(row.object_key);
      await env.DB.prepare("DELETE FROM player_deletion_objects WHERE installation_id=? AND object_key=?")
        .bind(installationId, row.object_key).run();
    }
    return response({ deleted: true });
  }

  if (path === "/api/reports" && request.method === "POST") {
    if (!(await rateLimit(request, env, 12))) return fail(429, "too many report submissions");
    const body = await bodyJson(request);
    if (!validId(body?.request_id)) return fail(400, "request_id must be a UUID");
    if (body.installation_id != null && !validId(body.installation_id)) return fail(400, "invalid installation_id");
    if (body.run_id != null && !validId(body.run_id)) return fail(400, "invalid run_id");
    if (body.installation_id) {
      const reportedPlayer = await env.DB.prepare("SELECT installation_id FROM players WHERE installation_id=? AND deleted_at IS NULL").bind(body.installation_id).first();
      if (!reportedPlayer) return fail(404, "reported entry not found");
    }
    const category = typeof body.category === "string" ? body.category.trim().slice(0, 40) : "";
    const details = typeof body.details === "string" ? body.details.trim() : "";
    if (!category || details.length > 4000) return fail(400, "category required; details may contain up to 4000 characters");
    const prior = await env.DB.prepare("SELECT report_id,category,status,created_at FROM reports WHERE request_id=?").bind(body.request_id).first();
    if (prior) return response({ report_id: prior.report_id, status: prior.status, replayed: true });
    const reportId = crypto.randomUUID();
    const objectKey = `reports/${reportId}.txt`;
    const createdAt = new Date().toISOString();
    await env.BUCKET.put(objectKey, details, { httpMetadata: { contentType: "text/plain; charset=utf-8" } });
    try {
      await env.DB.prepare("INSERT INTO reports(report_id,request_id,installation_id,run_id,category,object_key,created_at) VALUES(?,?,?,?,?,?,?)")
        .bind(reportId, body.request_id, body.installation_id || null, body.run_id || null, category, objectKey, createdAt).run();
    } catch (error) {
      await deleteObjectOrQueue(env, body.installation_id || null, objectKey);
      const existing = await env.DB.prepare("SELECT report_id,status FROM reports WHERE request_id=?").bind(body.request_id).first();
      if (existing) return response({ report_id: existing.report_id, status: existing.status, replayed: true });
      if (body.installation_id) {
        const active = await env.DB.prepare("SELECT 1 AS active FROM players WHERE installation_id=? AND deleted_at IS NULL").bind(body.installation_id).first();
        if (!active) return fail(410, "reported player was deleted");
      }
      throw error;
    }
    return response({ report_id: reportId, status: "open", replayed: false }, 201);
  }

  if (path.startsWith("/api/moderation/")) {
    if (!env.MODERATION_SECRET) return fail(503, "moderation is not configured");
    if (!(await rateLimit(request, env, 20))) return fail(429, "too many moderation requests");
    const supplied = bearer(request);
    if (!supplied || !constantTimeEqual(await sha256(supplied), await sha256(env.MODERATION_SECRET))) return fail(401, "unauthorized");
    if (path === "/api/moderation/reports" && request.method === "GET") {
      const rows = await env.DB.prepare(`SELECT r.report_id,r.installation_id AS entry_id,r.run_id,r.category,r.status,r.created_at,
        s.wave AS score_wave,s.hidden AS score_hidden,s.name_hidden AS name_hidden,
        'unverified' AS verification_status,1 AS moderation_required,
        s.best_run_id AS best_run_id,br.status AS replay_status,rr.status AS reported_replay_status,
        r.object_key AS details_key,CASE WHEN s.name_hidden=1 THEN 'Anonymous' ELSE s.nickname END AS nickname,
        p.nickname AS player_nickname
        FROM reports r LEFT JOIN scores s ON s.installation_id=r.installation_id
        LEFT JOIN players p ON p.installation_id=r.installation_id
        LEFT JOIN replays br ON br.run_id=s.best_run_id
        LEFT JOIN replays rr ON rr.run_id=r.run_id
        ORDER BY r.created_at DESC LIMIT 100`).all();
      const reports = await Promise.all((rows.results || []).map(async (row) => {
        const { details_key, ...report } = row;
        const object = details_key ? await env.BUCKET.get(details_key) : null;
        return { ...report, details: object ? await new Response(object.body).text() : null };
      }));
      return response({ reports });
    }
    const reportMatch = /^\/api\/moderation\/reports\/([^/]+)$/.exec(path);
    if (reportMatch && request.method === "PATCH") {
      const body = await bodyJson(request);
      if (!body || !["reviewed", "dismissed"].includes(body.status) || (body.hide_score != null && typeof body.hide_score !== "boolean") ||
        (body.hide_name != null && typeof body.hide_name !== "boolean") ||
        (body.restore_nickname != null && typeof body.restore_nickname !== "boolean") ||
        (body.nickname_override != null && !cleanNickname(body.nickname_override)) ||
        [body.hide_name != null, body.restore_nickname === true, body.nickname_override != null].filter(Boolean).length > 1) return fail(400, "invalid moderation update");
      const report = await env.DB.prepare("SELECT installation_id FROM reports WHERE report_id=?").bind(reportMatch[1]).first();
      if (!report) return fail(404, "report not found");
      const statements = [env.DB.prepare("UPDATE reports SET status=? WHERE report_id=?").bind(body.status, reportMatch[1])];
      if (body.hide_score != null && report.installation_id) statements.push(env.DB.prepare("UPDATE scores SET hidden=? WHERE installation_id=?").bind(body.hide_score ? 1 : 0, report.installation_id));
      let resultingNickname = null;
      let resultingNameHidden = null;
      if (body.hide_name === true && report.installation_id) {
        statements.push(env.DB.prepare("UPDATE scores SET name_hidden=1 WHERE installation_id=?").bind(report.installation_id));
        resultingNickname = "Anonymous";
        resultingNameHidden = true;
      } else if (body.hide_name === false && report.installation_id) {
        const player = await env.DB.prepare("SELECT nickname FROM players WHERE installation_id=? AND deleted_at IS NULL").bind(report.installation_id).first();
        if (player) {
          resultingNickname = player.nickname;
          statements.push(env.DB.prepare("UPDATE scores SET nickname=?,name_hidden=0 WHERE installation_id=?").bind(resultingNickname, report.installation_id));
        }
        resultingNameHidden = false;
      } else if (body.nickname_override != null && report.installation_id) {
        resultingNickname = cleanNickname(body.nickname_override);
        statements.push(env.DB.prepare("UPDATE scores SET nickname=?,name_hidden=0 WHERE installation_id=?").bind(resultingNickname, report.installation_id));
        resultingNameHidden = false;
      } else if (body.restore_nickname && report.installation_id) {
        const player = await env.DB.prepare("SELECT nickname FROM players WHERE installation_id=? AND deleted_at IS NULL").bind(report.installation_id).first();
        if (player) {
          resultingNickname = player.nickname;
          statements.push(env.DB.prepare("UPDATE scores SET nickname=?,name_hidden=0 WHERE installation_id=?").bind(resultingNickname, report.installation_id));
          resultingNameHidden = false;
        }
      }
      const results = await env.DB.batch(statements);
      if (!(results?.[0]?.meta?.changes > 0)) return fail(404, "report not found");
      return response({ updated: true, status: body.status, score_hidden: body.hide_score ?? null, name_hidden: resultingNameHidden, nickname: resultingNickname });
    }
    return fail(404, "moderation route not found");
  }

  return fail(404, "not found");
}

export default {
  async fetch(request, env) {
    try {
      requireBindings(env);
      const result = await handle(request, env);
      return new Response(result.body, { status: result.status, statusText: result.statusText, headers: {
        ...Object.fromEntries(result.headers),
        "access-control-allow-origin": "*",
        "access-control-allow-methods": "GET,POST,PUT,PATCH,DELETE,OPTIONS",
        "access-control-allow-headers": "Content-Type,Authorization",
      } });
    } catch (error) {
      return fail(500, "internal service error");
    }
  },
};
