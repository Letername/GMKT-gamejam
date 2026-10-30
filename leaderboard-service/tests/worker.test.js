import test from "node:test";
import assert from "node:assert/strict";
import worker from "../worker/index.js";

class FakeDB {
  constructor() { this.players = new Map(); this.submissions = new Map(); this.scores = new Map(); this.replays = new Map(); this.reports = new Map(); this.deletionObjects = new Map(); this.attempts = []; }
  prepare(sql) { return new Statement(this, sql); }
  async batch(statements) { const results=[];for(const statement of statements)results.push(await statement.run());return results; }
}
class Statement {
  constructor(db, sql) { this.db = db; this.sql = sql.replace(/\s+/g, " ").trim(); this.args = []; }
  bind(...args) { this.args = args; return this; }
  async run() {
    const d = this.db, s = this.sql, a = this.args;
    if (d.beforeRun) await d.beforeRun(s, a);
    if (s.startsWith("INSERT INTO auth_attempts")) { d.attempts.push({ ip: a[0], at: a[1] }); return { meta: { changes: 1 } }; }
    if (s.startsWith("DELETE FROM auth_attempts")) { d.attempts = d.attempts.filter(x => x.at >= a[0]); return { meta: { changes: 1 } }; }
    if (s.startsWith("INSERT OR IGNORE INTO player_deletion_objects")) { const p=d.players.get(a[2]);if(p?.deleted_at){d.deletionObjects.set(`${a[0]}|${a[1]}`,{installation_id:a[0],object_key:a[1]});return{meta:{changes:1}};}return{meta:{changes:0}}; }
    if (s.startsWith("INSERT INTO players")) { d.players.set(a[0], { installation_id:a[0], secret_hash:a[1], nickname:a[2], created_at:a[3], deleted_at:null }); return { meta: { changes: 1 } }; }
    if (s.startsWith("UPDATE players SET nickname")) { const x=d.players.get(a[1]);if(x&&!x.deleted_at)x.nickname=a[0];return{meta:{changes:x&&!x.deleted_at?1:0}}; }
    if (s.startsWith("UPDATE scores SET nickname=?,name_hidden=0")) { const x=d.scores.get(a[1]);if(x){x.nickname=a[0];x.name_hidden=0;}return{meta:{changes:x?1:0}}; }
    if (s.startsWith("UPDATE scores SET nickname=? WHERE installation_id=? AND EXISTS")) { const x=d.scores.get(a[1]),p=d.players.get(a[2]);if(x&&p&&!p.deleted_at)x.nickname=a[0];return{meta:{changes:x&&p&&!p.deleted_at?1:0}}; }
    if (s.startsWith("UPDATE scores SET nickname")) { const x=d.scores.get(a[1]);if(x)x.nickname=a[0];return{meta:{changes:x?1:0}}; }
    if (s.startsWith("INSERT OR IGNORE INTO submissions")) {
      if (d.submissions.has(a[0])) return { meta: { changes: 0 } };
      const player = d.players.get(a[1]);
      if (!player || player.deleted_at) throw new Error("player deleted");
      const sub = { run_id:a[0], installation_id:a[1], nickname:a[2], wave:a[3], received_at:a[4] };
      d.submissions.set(a[0], sub);
      const old = d.scores.get(a[1]);
      if (!old || sub.wave > old.wave) {
        if (old) { const prev = d.replays.get(old.best_run_id); if (prev && ["ready","pending"].includes(prev.status)) prev.status = prev.uploaded_at ? "previous" : "missing"; }
      d.scores.set(a[1], { installation_id:a[1], nickname:a[2], wave:a[3], best_run_id:a[0], received_at:a[4], hidden:0, name_hidden:0 });
        d.replays.set(a[0], { run_id:a[0], installation_id:a[1], object_key:`replays/${a[0]}`, status:"pending", size_bytes:0 });
      } else d.replays.set(a[0], { run_id:a[0], installation_id:a[1], object_key:`replays/${a[0]}`, status:"previous", size_bytes:0 });
      return { meta: { changes: 1 } };
    }
    if (s.startsWith("UPDATE replays SET status='uploading'")) {
      const row=d.replays.get(a[3]), player=d.players.get(a[6]);
      if(row&&player&&!player.deleted_at&&["pending","missing"].includes(row.status)&&(!row.payload_sha256||row.payload_sha256===a[5])){row.status="uploading";row.payload_sha256=row.payload_sha256||a[0];row.upload_token=a[1];row.upload_started_at=a[2];return{meta:{changes:1}};}
      return{meta:{changes:0}};
    }
    if (s.startsWith("UPDATE replays SET upload_token=")) {
      const row=d.replays.get(a[2]), player=d.players.get(a[7]);
      if(row&&player&&!player.deleted_at&&row.status==="uploading"&&row.upload_token===a[4]&&row.upload_started_at<a[5]&&row.payload_sha256===a[6]){row.upload_token=a[0];row.upload_started_at=a[1];return{meta:{changes:1}};}
      return{meta:{changes:0}};
    }
    if (s.startsWith("UPDATE replays SET status=CASE WHEN (SELECT best_run_id") && s.includes("size_bytes=?")) {
      const row=d.replays.get(a[4]), player=d.players.get(a[8]), score=d.scores.get(a[0]);
      if(row&&player&&!player.deleted_at&&row.status==="uploading"&&row.upload_token===a[6]&&row.payload_sha256===a[7]){row.status=score?.best_run_id===a[1]?"ready":"previous";row.size_bytes=a[2];row.uploaded_at=a[3];row.upload_token=null;row.upload_started_at=null;return{meta:{changes:1}};}
      return{meta:{changes:0}};
    }
    if (s.startsWith("UPDATE replays SET status=CASE WHEN")) {
      const row=d.replays.get(a[1]), player=d.players.get(a[4]), score=d.scores.get(a[0]);
      if(row&&player&&!player.deleted_at&&row.status==="uploading"&&row.upload_token===a[3]){row.status=score?.best_run_id===row.run_id?"pending":"missing";row.upload_token=null;row.upload_started_at=null;return{meta:{changes:1}};}
      return{meta:{changes:0}};
    }
    if (s.startsWith("UPDATE replays SET status='missing'")) { const row=d.replays.get(a[0]);if(row)row.status="missing";return{meta:{changes:row?1:0}}; }
    if (s.startsWith("UPDATE players SET deleted_at")) { const row=d.players.get(a[1]),changed=!!row&&!row.deleted_at;if(changed){row.deleted_at=a[0];for(const x of d.replays.values())if(x.installation_id===a[1])d.deletionObjects.set(`${a[1]}|${x.object_key}`,{installation_id:a[1],object_key:x.object_key});for(const x of d.reports.values())if(x.installation_id===a[1])d.deletionObjects.set(`${a[1]}|${x.object_key}`,{installation_id:a[1],object_key:x.object_key});d.scores.delete(a[1]); for(const [id,x] of d.submissions)if(x.installation_id===a[1])d.submissions.delete(id);for(const [id,x] of d.replays)if(x.installation_id===a[1])d.replays.delete(id);for(const [id,x] of d.reports)if(x.installation_id===a[1])d.reports.delete(id);} return {meta:{changes:changed?1:0}}; }
    if (s.startsWith("INSERT INTO reports")) { if([...d.reports.values()].some(x=>x.request_id===a[1])) throw new Error("unique");const player=a[2]&&d.players.get(a[2]);if(player?.deleted_at)throw new Error("player deleted");d.reports.set(a[0],{report_id:a[0],request_id:a[1],installation_id:a[2],run_id:a[3],category:a[4],object_key:a[5],status:"open",created_at:a[6]});return{meta:{changes:1}}; }
    if (s.startsWith("UPDATE reports SET status")) { const row=d.reports.get(a[1]); if(row)row.status=a[0];return{meta:{changes:row?1:0}}; }
    if (s.startsWith("UPDATE scores SET hidden")) { const row=d.scores.get(a[1]); if(row)row.hidden=a[0];return{meta:{changes:row?1:0}}; }
    if (s.startsWith("UPDATE scores SET name_hidden=1")) { const row=d.scores.get(a[0]);if(row)row.name_hidden=1;return{meta:{changes:row?1:0}}; }
    if (s.startsWith("UPDATE scores SET name_hidden=0")) { const row=d.scores.get(a[0]);if(row)row.name_hidden=0;return{meta:{changes:row?1:0}}; }
    if (s.startsWith("UPDATE scores SET nickname=?,name_hidden=0")) { const row=d.scores.get(a[1]);if(row){row.nickname=a[0];row.name_hidden=0;}return{meta:{changes:row?1:0}}; }
    if (s.startsWith("DELETE FROM reports WHERE installation_id")) { for(const [id,x] of d.reports)if(x.installation_id===a[0])d.reports.delete(id);return{meta:{changes:1}}; }
    if (s.startsWith("DELETE FROM player_deletion_objects WHERE installation_id")) { let n=0;for(const [id,x] of d.deletionObjects)if(x.installation_id===a[0]&&(a[1]==null||x.object_key===a[1])){d.deletionObjects.delete(id);n++;}return{meta:{changes:n}}; }
    throw new Error(`Unhandled run SQL: ${s}`);
  }
  async first() {
    const d=this.db,s=this.sql,a=this.args;
    if(s.startsWith("SELECT COUNT(*)")) return {n:d.attempts.filter(x=>x.ip===a[0]&&x.at>a[1]).length};
    if(s.startsWith("SELECT rank FROM (SELECT installation_id")) {const list=[...d.scores.values()].filter(x=>!x.hidden).sort((x,y)=>y.wave-x.wave||x.received_at.localeCompare(y.received_at)||x.installation_id.localeCompare(y.installation_id));const i=list.findIndex(x=>x.installation_id===a[0]);return i<0?null:{rank:i+1};}
    if(s.includes("FROM players WHERE installation_id=?")) {const p=d.players.get(a[0]);return p&&(s.includes("deleted_at IS NULL")&&p.deleted_at)?null:p||null;}
    if(s.startsWith("SELECT installation_id,nickname,wave FROM submissions")) {const x=d.submissions.get(a[0]);return x?{installation_id:x.installation_id,nickname:x.nickname,wave:x.wave}:null;}
    if(s.startsWith("SELECT wave,best_run_id,received_at FROM scores")) return d.scores.get(a[0]) || null;
    if(s.startsWith("SELECT installation_id,status,object_key")) return d.replays.get(a[0]) || null;
    if(s.startsWith("SELECT object_key,status,size_bytes FROM replays")) {const x=d.replays.get(a[0]);return x?{object_key:x.object_key,status:x.status,size_bytes:x.size_bytes}:null;}
    if(s.startsWith("SELECT r.object_key,r.status,r.size_bytes")) {const x=d.replays.get(a[0]),score=x&&d.scores.get(x.installation_id);return x?{object_key:x.object_key,status:x.status,size_bytes:x.size_bytes,score_hidden:score?.hidden||0}:null;}
    if(s.startsWith("SELECT status,payload_sha256 FROM replays")) {const x=d.replays.get(a[0]);return x?{status:x.status,payload_sha256:x.payload_sha256}:null;}
    if(s.startsWith("SELECT status,upload_token,payload_sha256 FROM replays")) {const x=d.replays.get(a[0]);return x?{status:x.status,upload_token:x.upload_token,payload_sha256:x.payload_sha256}:null;}
    if(s.startsWith("SELECT status FROM replays")) {const x=d.replays.get(a[0]);return x?{status:x.status}:null;}
    if(s.startsWith("SELECT best_run_id FROM scores")) {const x=d.scores.get(a[0]);return x?{best_run_id:x.best_run_id}:null;}
    if(s.startsWith("SELECT report_id,category,status,created_at FROM reports")) {const x=[...d.reports.values()].find(x=>x.request_id===a[0]);return x||null;}
    if(s.startsWith("SELECT installation_id FROM reports")) {const x=d.reports.get(a[0]);return x?{installation_id:x.installation_id}:null;}
    if(s.startsWith("SELECT report_id,status FROM reports")) {const x=[...d.reports.values()].find(x=>x.request_id===a[0]);return x?{report_id:x.report_id,status:x.status}:null;}
    throw new Error(`Unhandled first SQL: ${s}`);
  }
  async all() {
    const d=this.db,s=this.sql,a=this.args;
    if(s.startsWith("SELECT ranked.rank")) {const ranked=[...d.scores.values()].filter(x=>!x.hidden).sort((x,y)=>y.wave-x.wave||x.received_at.localeCompare(y.received_at)||x.installation_id.localeCompare(y.installation_id)).map((x,i)=>({...x,rank:i+1,entry_id:x.installation_id,run_id:x.best_run_id,replay_status:d.replays.get(x.best_run_id)?.status||null,verification_status:"unverified",moderation_required:true}));return{results:ranked.filter(x=>!a[0]||(x.name_hidden?"anonymous":x.nickname.toLowerCase()).includes(a[1].toLowerCase())).slice(0,a[2])};}
    if(s.startsWith("SELECT object_key FROM replays WHERE")) return {results:[...d.replays.values()].filter(x=>x.installation_id===a[0]).map(x=>({object_key:x.object_key}))};
    if(s.startsWith("SELECT object_key FROM player_deletion_objects")) return {results:[...d.deletionObjects.values()].filter(x=>x.installation_id===a[0]).map(x=>({object_key:x.object_key}))};
    if(s.startsWith("SELECT r.report_id,r.installation_id AS entry_id")) return {results:[...d.reports.values()].map(r=>{const score=d.scores.get(r.installation_id);return{...r,entry_id:r.installation_id,details_key:r.object_key,score_wave:score?.wave??null,score_hidden:score?.hidden??null,name_hidden:score?.name_hidden??null,nickname:score?.name_hidden?"Anonymous":score?.nickname??null,player_nickname:d.players.get(r.installation_id)?.nickname??null,best_run_id:score?.best_run_id??null,replay_status:d.replays.get(score?.best_run_id)?.status??null,reported_replay_status:d.replays.get(r.run_id)?.status??null,verification_status:"unverified",moderation_required:1};})};
    throw new Error(`Unhandled all SQL: ${s}`);
  }
}
class FakeBucket {
  constructor(){this.objects=new Map();}
  async put(key,value){if(this.beforePut)await this.beforePut(key,value);this.objects.set(key,Buffer.from(value));}
  async get(key){const value=this.objects.get(key);return value?{body:value}:null;}
  async delete(key){if(this.beforeDelete)await this.beforeDelete(key);if(this.failDelete)throw new Error("simulated R2 outage");this.objects.delete(key);}
}
const make = (method,path,body,secret,extra={}) => new Request(`https://test.invalid${path}`,{method,headers:{...(body instanceof Uint8Array?{}:{"content-type":"application/json"}),...(secret?{authorization:`Bearer ${secret}`}:{ }),"cf-connecting-ip":"203.0.113.7",...extra},body:method==="GET"||method==="DELETE"?undefined:body instanceof Uint8Array?body:JSON.stringify(body)});
const call = async (env, ...args) => {const r=await worker.fetch(make(...args),env);return {response:r,data:r.headers.get("content-type")?.includes("json")?await r.json():new Uint8Array(await r.arrayBuffer())};};
function deferred() { let resolve; const promise=new Promise(r=>resolve=r); return {promise,resolve}; }

test("registration, per-installation auth, best-wave idempotency and server tie ordering", async () => {
  const env={DB:new FakeDB(),BUCKET:new FakeBucket()};
  const reg=(await call(env,"POST","/api/player",{nickname:"Bob"}));
  assert.equal(reg.response.status,201); const {installation_id:id,installation_secret:secret}=reg.data;
  const run1=crypto.randomUUID();
  const post=(run_id,wave,nickname="Bob",auth=secret)=>call(env,"POST","/api/scores",{installation_id:id,run_id,wave,nickname},auth);
  assert.equal((await post(run1,10,"Bob","wrong-secret-which-is-long-enough-000000000000000000")).response.status,401);
  const a=await post(run1,10); assert.equal(a.data.is_best,true); assert.equal(a.data.replayed,false);
  const retry=await post(run1,10); assert.equal(retry.data.replayed,true);
  assert.equal((await post(run1,11)).response.status,409);
  const tie=await post(crypto.randomUUID(),10,"Different name"); assert.equal(tie.data.is_best,false);
  const better=await post(crypto.randomUUID(),11); assert.equal(better.data.is_best,true);
  const board=await call(env,"GET","/api/leaderboard");
  assert.equal(board.data.scores.length,1); assert.equal(board.data.scores[0].wave,11);
  assert.equal(board.data.scores[0].run_id,better.data.best_run_id);
  assert.equal(board.data.scores[0].entry_id,id);
  assert.equal((await call(env,"GET",`/api/players/${id}/rank`)).data.rank,1);
  const renamed=await call(env,"PATCH","/api/player",{installation_id:id,nickname:"Updated"},secret);
  assert.equal(renamed.data.nickname,"Updated");
  const another=await call(env,"POST","/api/player",{nickname:"Updated"});
  const duplicateNameBoard=await call(env,"GET","/api/leaderboard?nickname=updated");
  assert.equal(duplicateNameBoard.data.scores.length,1);
  const secondEntry=await call(env,"POST","/api/scores",{installation_id:another.data.installation_id,run_id:crypto.randomUUID(),wave:12,nickname:"Updated"},another.data.installation_secret);
  assert.equal(secondEntry.data.is_best,true);
  const top=await call(env,"POST","/api/player",{nickname:"Top"});
  await call(env,"POST","/api/scores",{installation_id:top.data.installation_id,run_id:crypto.randomUUID(),wave:15,nickname:"Top"},top.data.installation_secret);
  const filtered=(await call(env,"GET","/api/leaderboard?nickname=updated")).data.scores;
  assert.equal(filtered.length,2); assert.deepEqual(filtered.map(x=>x.rank),[2,3]);
  assert.equal(filtered[0].verification_status,"unverified"); assert.equal(filtered[0].moderation_required,true);
});

test("replays transition pending to ready then previous and can be downloaded", async () => {
  const env={DB:new FakeDB(),BUCKET:new FakeBucket()};
  const {data:p}=await call(env,"POST","/api/player",{nickname:"Replay"});
  const first=crypto.randomUUID(); await call(env,"POST","/api/scores",{installation_id:p.installation_id,run_id:first,wave:2,nickname:p.nickname},p.installation_secret);
  const put=await call(env,"PUT",`/api/replays/${first}?installation_id=${p.installation_id}`,new Uint8Array([1,2,3]),p.installation_secret);
  assert.equal(put.response.status,201); assert.equal(put.data.status,"ready");
  const download=await call(env,"GET",`/api/replays/${first}`); assert.deepEqual([...download.data],[1,2,3]);
  const second=crypto.randomUUID(); await call(env,"POST","/api/scores",{installation_id:p.installation_id,run_id:second,wave:3,nickname:p.nickname},p.installation_secret);
  assert.equal(env.DB.replays.get(first).status,"previous");
  const uploaded=await call(env,"PUT",`/api/replays/${second}?installation_id=${p.installation_id}`,new Uint8Array([0,255,13]),p.installation_secret);
  assert.equal(uploaded.data.status,"ready"); assert.equal(uploaded.data.verification_status,"unverified");
  assert.equal((await call(env,"GET",`/api/replays/${second}`)).response.headers.get("x-replay-verification"),"unverified");
  env.BUCKET.objects.delete(`replays/${first}`);
  assert.equal((await call(env,"GET",`/api/replays/${first}`)).response.status,404);
  assert.equal(env.DB.replays.get(first).status,"missing");
});

test("R2 reports are idempotent and moderation can hide the reported installation", async () => {
  const env={DB:new FakeDB(),BUCKET:new FakeBucket(),MODERATION_SECRET:"moderation-test-secret-with-at-least-32-characters"};
  const {data:p}=await call(env,"POST","/api/player",{nickname:"Report"});
  const run=crypto.randomUUID(); await call(env,"POST","/api/scores",{installation_id:p.installation_id,run_id:run,wave:9,nickname:p.nickname},p.installation_secret);
  await call(env,"PUT",`/api/replays/${run}?installation_id=${p.installation_id}`,new Uint8Array([3,2,1]),p.installation_secret);
  const request_id=crypto.randomUUID();
  const report=await call(env,"POST","/api/reports",{request_id,installation_id:p.installation_id,run_id:run,category:"cheating",details:"Please review this run."});
  assert.equal(report.response.status,201); assert.equal(env.BUCKET.objects.size,2);
  assert.equal((await call(env,"POST","/api/reports",{request_id,installation_id:p.installation_id,run_id:run,category:"cheating",details:"Please review this run."})).data.replayed,true);
  const unauth=await call(env,"GET","/api/moderation/reports"); assert.equal(unauth.response.status,401);
  const listed=await call(env,"GET","/api/moderation/reports",undefined,env.MODERATION_SECRET);
  assert.equal(listed.data.reports.length,1); assert.equal(listed.data.reports[0].details,"Please review this run.");
  const hidden=await call(env,"PATCH",`/api/moderation/reports/${report.data.report_id}`,{status:"reviewed",hide_score:true},env.MODERATION_SECRET);
  assert.equal(hidden.data.score_hidden,true);
  assert.equal((await call(env,"GET","/api/leaderboard")).data.scores.length,0);
  assert.equal((await call(env,"GET",`/api/replays/${run}`)).response.status,404);
  const hideName=await call(env,"PATCH",`/api/moderation/reports/${report.data.report_id}`,{status:"reviewed",hide_name:true},env.MODERATION_SECRET);
  assert.equal(hideName.data.name_hidden,true);
  const modList=await call(env,"GET","/api/moderation/reports",undefined,env.MODERATION_SECRET);
  assert.equal(modList.data.reports[0].score_wave,9); assert.equal(modList.data.reports[0].name_hidden,1);
  assert.equal(modList.data.reports[0].verification_status,"unverified");
  const unhideName=await call(env,"PATCH",`/api/moderation/reports/${report.data.report_id}`,{status:"reviewed",hide_name:false},env.MODERATION_SECRET);
  assert.equal(unhideName.data.name_hidden,false);
  const renamed=await call(env,"PATCH",`/api/moderation/reports/${report.data.report_id}`,{status:"reviewed",hide_score:false,nickname_override:"Filtered"},env.MODERATION_SECRET);
  assert.equal(renamed.data.nickname,"Filtered");
  const restored=await call(env,"PATCH",`/api/moderation/reports/${report.data.report_id}`,{status:"reviewed",restore_nickname:true},env.MODERATION_SECRET);
  assert.equal(restored.data.nickname,"Report");
  assert.equal((await call(env,"GET","/api/leaderboard")).data.scores[0].nickname,"Report");
  assert.equal((await call(env,"GET",`/api/replays/${run}`)).response.status,200);
  const noDetails=await call(env,"POST","/api/reports",{request_id:crypto.randomUUID(),category:"other"},undefined,{"cf-connecting-ip":"198.51.100.2"});
  assert.equal(noDetails.response.status,201);
});

test("player deletion removes score and replay storage; report route input is bounded", async () => {
  const env={DB:new FakeDB(),BUCKET:new FakeBucket()};
  const {data:p}=await call(env,"POST","/api/player",{nickname:"Delete"});
  const run=crypto.randomUUID(); await call(env,"POST","/api/scores",{installation_id:p.installation_id,run_id:run,wave:1,nickname:p.nickname},p.installation_secret);
  const result=await call(env,"DELETE",`/api/player?installation_id=${p.installation_id}`,undefined,p.installation_secret);
  assert.equal(result.data.deleted,true); assert.equal((await call(env,"GET","/api/leaderboard")).data.scores.length,0);
  assert.equal((await call(env,"POST","/api/reports",{request_id:crypto.randomUUID(),category:"x",details:""})).response.status,201);
});

test("basic all-ages nickname filtering applies at registration, update and score submission", async () => {
  const env={DB:new FakeDB(),BUCKET:new FakeBucket()};
  assert.equal((await call(env,"POST","/api/player",{nickname:"f.u.c.k"})).response.status,400);
  assert.equal((await call(env,"POST","/api/player",{nickname:"classy"})).response.status,201);
  const {data:p}=await call(env,"POST","/api/player",{nickname:"Clean"});
  assert.equal((await call(env,"PATCH","/api/player",{installation_id:p.installation_id,nickname:"b.i.t.c.h"},p.installation_secret)).response.status,400);
  assert.equal((await call(env,"POST","/api/scores",{installation_id:p.installation_id,run_id:crypto.randomUUID(),nickname:"dick",wave:1},p.installation_secret)).response.status,400);
});

test("a score authorized just before deletion cannot recreate deleted player data", async () => {
  const env={DB:new FakeDB(),BUCKET:new FakeBucket()};
  const {data:p}=await call(env,"POST","/api/player",{nickname:"Delete race"});
  let deleted;
  env.DB.beforeRun=async sql=>{
    if(sql.startsWith("INSERT OR IGNORE INTO submissions")){
      env.DB.beforeRun=null;
      deleted=await call(env,"DELETE",`/api/player?installation_id=${p.installation_id}`,undefined,p.installation_secret);
    }
  };
  const submission=await call(env,"POST","/api/scores",{installation_id:p.installation_id,run_id:crypto.randomUUID(),nickname:p.nickname,wave:4},p.installation_secret);
  assert.equal(deleted.data.deleted,true);
  assert.equal(submission.response.status,410);
  assert.equal(env.DB.scores.size,0); assert.equal(env.DB.submissions.size,0);
});

test("concurrent replay upload is serialized and a changed retry cannot overwrite the first bytes", async () => {
  const env={DB:new FakeDB(),BUCKET:new FakeBucket()};
  const {data:p}=await call(env,"POST","/api/player",{nickname:"Replay race"});
  const run=crypto.randomUUID(); await call(env,"POST","/api/scores",{installation_id:p.installation_id,run_id:run,nickname:p.nickname,wave:2},p.installation_secret);
  const gate=deferred(), entered=deferred();
  env.BUCKET.beforePut=async()=>{env.BUCKET.beforePut=null;entered.resolve();await gate.promise;};
  const first=call(env,"PUT",`/api/replays/${run}?installation_id=${p.installation_id}`,new Uint8Array([1,2,3]),p.installation_secret);
  await entered.promise;
  const conflict=await call(env,"PUT",`/api/replays/${run}?installation_id=${p.installation_id}`,new Uint8Array([9,9,9]),p.installation_secret);
  assert.equal(conflict.response.status,409);
  gate.resolve();
  const uploaded=await first; assert.equal(uploaded.response.status,201);
  assert.deepEqual([...env.BUCKET.objects.get(`replays/${run}`)],[1,2,3]);
  const retry=await call(env,"PUT",`/api/replays/${run}?installation_id=${p.installation_id}`,new Uint8Array([1,2,3]),p.installation_secret);
  assert.equal(retry.data.replayed,true);
});

test("deletion during replay upload removes the late R2 object", async () => {
  const env={DB:new FakeDB(),BUCKET:new FakeBucket()};
  const {data:p}=await call(env,"POST","/api/player",{nickname:"Delete upload"});
  const run=crypto.randomUUID(); await call(env,"POST","/api/scores",{installation_id:p.installation_id,run_id:run,nickname:p.nickname,wave:2},p.installation_secret);
  const gate=deferred(), entered=deferred();
  env.BUCKET.beforePut=async()=>{env.BUCKET.beforePut=null;entered.resolve();await gate.promise;};
  const upload=call(env,"PUT",`/api/replays/${run}?installation_id=${p.installation_id}`,new Uint8Array([4,5,6]),p.installation_secret);
  await entered.promise;
  const deleted=await call(env,"DELETE",`/api/player?installation_id=${p.installation_id}`,undefined,p.installation_secret);
  assert.equal(deleted.data.deleted,true);
  env.BUCKET.failDelete=true;
  gate.resolve();
  const result=await upload;
  assert.equal(result.response.status,500);
  assert.equal(env.BUCKET.objects.has(`replays/${run}`),true);
  assert.equal(env.DB.deletionObjects.size,1);
  env.BUCKET.failDelete=false;
  const cleanup=await call(env,"DELETE",`/api/player?installation_id=${p.installation_id}`,undefined,p.installation_secret);
  assert.equal(cleanup.response.status,200);
  assert.equal(env.DB.deletionObjects.size,0); assert.equal(env.BUCKET.objects.has(`replays/${run}`),false);
  assert.equal(env.DB.replays.has(run),false);
});

test("higher score during an upload makes the completed older replay previous", async () => {
  const env={DB:new FakeDB(),BUCKET:new FakeBucket()};
  const {data:p}=await call(env,"POST","/api/player",{nickname:"Wave race"});
  const oldRun=crypto.randomUUID(); await call(env,"POST","/api/scores",{installation_id:p.installation_id,run_id:oldRun,nickname:p.nickname,wave:2},p.installation_secret);
  const gate=deferred(), entered=deferred();
  env.BUCKET.beforePut=async()=>{env.BUCKET.beforePut=null;entered.resolve();await gate.promise;};
  const upload=call(env,"PUT",`/api/replays/${oldRun}?installation_id=${p.installation_id}`,new Uint8Array([7,8]),p.installation_secret);
  await entered.promise;
  const bestRun=crypto.randomUUID();
  await call(env,"POST","/api/scores",{installation_id:p.installation_id,run_id:bestRun,nickname:p.nickname,wave:3},p.installation_secret);
  gate.resolve();
  const completed=await upload;
  assert.equal(completed.data.status,"previous");
  assert.equal(env.DB.replays.get(oldRun).status,"previous");
  assert.equal(env.DB.scores.get(p.installation_id).best_run_id,bestRun);
});

test("report created after its owner is deleted is rejected and its R2 details are cleaned up", async () => {
  const env={DB:new FakeDB(),BUCKET:new FakeBucket()};
  const {data:p}=await call(env,"POST","/api/player",{nickname:"Report race"});
  env.DB.beforeRun=async sql=>{
    if(sql.startsWith("INSERT INTO reports")){
      env.DB.beforeRun=null;
      await call(env,"DELETE",`/api/player?installation_id=${p.installation_id}`,undefined,p.installation_secret);
    }
  };
  const report=await call(env,"POST","/api/reports",{request_id:crypto.randomUUID(),installation_id:p.installation_id,category:"abuse",details:"Race test"});
  assert.equal(report.response.status,410);
  assert.equal(env.DB.reports.size,0); assert.equal(env.BUCKET.objects.size,0);
});

test("player deletion keeps a retryable R2 cleanup outbox after a storage failure", async () => {
  const env={DB:new FakeDB(),BUCKET:new FakeBucket()};
  const {data:p}=await call(env,"POST","/api/player",{nickname:"Cleanup retry"});
  const run=crypto.randomUUID(); await call(env,"POST","/api/scores",{installation_id:p.installation_id,run_id:run,nickname:p.nickname,wave:2},p.installation_secret);
  await call(env,"PUT",`/api/replays/${run}?installation_id=${p.installation_id}`,new Uint8Array([1,2]),p.installation_secret);
  const report=await call(env,"POST","/api/reports",{request_id:crypto.randomUUID(),installation_id:p.installation_id,category:"other",details:"Stored evidence"});
  assert.equal(report.response.status,201); assert.equal(env.BUCKET.objects.size,2);
  env.BUCKET.failDelete=true;
  const first=await call(env,"DELETE",`/api/player?installation_id=${p.installation_id}`,undefined,p.installation_secret);
  assert.equal(first.response.status,500); assert.equal(env.DB.deletionObjects.size,2);
  env.BUCKET.failDelete=false;
  const retry=await call(env,"DELETE",`/api/player?installation_id=${p.installation_id}`,undefined,p.installation_secret);
  assert.equal(retry.response.status,200); assert.equal(env.DB.deletionObjects.size,0); assert.equal(env.BUCKET.objects.size,0);
});

test("deletion cleanup does not erase outbox keys enqueued during its drain", async () => {
  const env={DB:new FakeDB(),BUCKET:new FakeBucket()};
  const {data:p}=await call(env,"POST","/api/player",{nickname:"Outbox race"});
  const run=crypto.randomUUID(); await call(env,"POST","/api/scores",{installation_id:p.installation_id,run_id:run,nickname:p.nickname,wave:2},p.installation_secret);
  await call(env,"PUT",`/api/replays/${run}?installation_id=${p.installation_id}`,new Uint8Array([1,2]),p.installation_secret);
  const lateKey=`replays/${crypto.randomUUID()}`;
  env.BUCKET.objects.set(lateKey,Buffer.from([3]));
  env.BUCKET.beforeDelete=async()=>{
    env.BUCKET.beforeDelete=null;
    env.DB.deletionObjects.set(`${p.installation_id}|${lateKey}`,{installation_id:p.installation_id,object_key:lateKey});
  };
  const first=await call(env,"DELETE",`/api/player?installation_id=${p.installation_id}`,undefined,p.installation_secret);
  assert.equal(first.response.status,200);
  assert.equal(env.DB.deletionObjects.size,1); assert.equal(env.BUCKET.objects.has(lateKey),true);
  const retry=await call(env,"DELETE",`/api/player?installation_id=${p.installation_id}`,undefined,p.installation_secret);
  assert.equal(retry.response.status,200);
  assert.equal(env.DB.deletionObjects.size,0); assert.equal(env.BUCKET.objects.has(lateKey),false);
});
