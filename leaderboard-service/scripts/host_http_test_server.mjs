import http from "node:http";
import worker from "../worker/index.js";

class TestDB {
  players = new Map();
  submissions = new Map();
  scores = new Map();
  replays = new Map();
  reports = new Map();
  attempts = [];
  failNextScore = true;

  prepare(sql) { return new Statement(this, sql.replace(/\s+/g, " ").trim()); }
  async batch(statements) { return Promise.all(statements.map((statement) => statement.run())); }
}

class Statement {
  constructor(db, sql) { this.db = db; this.sql = sql; this.args = []; }
  bind(...args) { this.args = args; return this; }
  async run() {
    const d = this.db, s = this.sql, a = this.args;
    if (s.startsWith("INSERT INTO auth_attempts")) { d.attempts.push({ ip: a[0], at: a[1] }); return changed(); }
    if (s.startsWith("DELETE FROM auth_attempts")) { d.attempts = d.attempts.filter((x) => x.at >= a[0]); return changed(); }
    if (s.startsWith("INSERT INTO players")) { d.players.set(a[0], { installation_id:a[0], secret_hash:a[1], nickname:a[2], created_at:a[3], deleted_at:null }); return changed(); }
    if (s.startsWith("UPDATE players SET nickname=? WHERE")) { const p=d.players.get(a[1]); if(p&&!p.deleted_at)p.nickname=a[0]; return changed(p&&!p.deleted_at); }
    if (s.startsWith("UPDATE scores SET nickname=? WHERE")) { const score=d.scores.get(a[1]); if(score)score.nickname=a[0]; return changed(!!score); }
    if (s.startsWith("INSERT OR IGNORE INTO submissions")) {
      if (d.failNextScore) { d.failNextScore = false; throw new Error("temporary D1 fault"); }
      if (d.submissions.has(a[0])) return changed(false);
      const player=d.players.get(a[1]); if(!player||player.deleted_at)throw new Error("missing player");
      const submission={run_id:a[0],installation_id:a[1],nickname:a[2],wave:a[3],received_at:a[4]}; d.submissions.set(a[0],submission);
      const old=d.scores.get(a[1]);
      if(!old||submission.wave>old.wave){
        if(old){const previous=d.replays.get(old.best_run_id);if(previous)previous.status=previous.uploaded_at?"previous":"missing";}
        d.scores.set(a[1],{installation_id:a[1],nickname:a[2],wave:a[3],best_run_id:a[0],received_at:a[4],hidden:0,name_hidden:0});
        d.replays.set(a[0],{run_id:a[0],installation_id:a[1],object_key:`replays/${a[0]}`,status:"pending",size_bytes:0});
      } else d.replays.set(a[0],{run_id:a[0],installation_id:a[1],object_key:`replays/${a[0]}`,status:"previous",size_bytes:0});
      return changed();
    }
    if (s.startsWith("UPDATE replays SET status='uploading'")) { const r=d.replays.get(a[3]); if(!r||!d.players.has(a[6])||r.status!=="pending")return changed(false); Object.assign(r,{status:"uploading",payload_sha256:a[0],upload_token:a[1],upload_started_at:a[2]});return changed(); }
    if (s.startsWith("UPDATE replays SET status=CASE WHEN (SELECT best_run_id")) { const r=d.replays.get(a[4]),score=d.scores.get(a[0]);if(!r||r.status!=="uploading"||r.upload_token!==a[6])return changed(false);Object.assign(r,{status:score?.best_run_id===a[1]?"ready":"previous",size_bytes:a[2],uploaded_at:a[3],upload_token:null,upload_started_at:null});return changed(); }
    if (s.startsWith("UPDATE reports SET status")) { const r=d.reports.get(a[1]);if(r)r.status=a[0];return changed(!!r); }
    if (s.startsWith("INSERT INTO reports")) { if([...d.reports.values()].some(r=>r.request_id===a[1]))throw new Error("duplicate report");d.reports.set(a[0],{report_id:a[0],request_id:a[1],installation_id:a[2],run_id:a[3],category:a[4],object_key:a[5],status:"open",created_at:a[6]});return changed(); }
    if (s.startsWith("UPDATE scores SET hidden")) { const r=d.scores.get(a[1]);if(r)r.hidden=a[0];return changed(!!r); }
    if (s.startsWith("UPDATE scores SET name_hidden=1")) { const r=d.scores.get(a[0]);if(r)r.name_hidden=1;return changed(!!r); }
    if (s.startsWith("UPDATE scores SET nickname=?,name_hidden=0")) { const r=d.scores.get(a[1]);if(r){r.nickname=a[0];r.name_hidden=0;}return changed(!!r); }
    if (s.startsWith("DELETE FROM reports WHERE installation_id")) { for(const[id,r]of d.reports)if(r.installation_id===a[0])d.reports.delete(id);return changed(); }
    console.error("UNHANDLED RUN SQL", s, a); throw new Error(`Unimplemented test SQL run: ${s}`);
  }
  async first() {
    const d=this.db,s=this.sql,a=this.args;
    if(s.startsWith("SELECT COUNT(*) AS n FROM auth_attempts"))return{n:d.attempts.filter(x=>x.ip===a[0]&&x.at>a[1]).length};
    if(s.startsWith("SELECT secret_hash")){const p=d.players.get(a[0]);return p&&!p.deleted_at?{secret_hash:p.secret_hash,deleted_at:p.deleted_at}:null;}
    if(s.startsWith("SELECT nickname FROM players")){const p=d.players.get(a[0]);return p&&!p.deleted_at?{nickname:p.nickname}:null;}
    if(s.startsWith("SELECT 1 AS active FROM players")){const p=d.players.get(a[0]);return p&&!p.deleted_at?{active:1}:null;}
    if(s.startsWith("SELECT installation_id,nickname,wave FROM submissions")){const r=d.submissions.get(a[0]);return r?{installation_id:r.installation_id,nickname:r.nickname,wave:r.wave}:null;}
    if(s.startsWith("SELECT report_id,category,status,created_at FROM reports")){const r=[...d.reports.values()].find(x=>x.request_id===a[0]);return r?{report_id:r.report_id,category:r.category,status:r.status,created_at:r.created_at}:null;}
    if(s.startsWith("SELECT wave,best_run_id,received_at FROM scores"))return d.scores.get(a[0])||null;
    if(s.startsWith("SELECT installation_id,status,object_key,payload_sha256,upload_token,upload_started_at FROM replays")){const r=d.replays.get(a[0]);return r||null;}
    if(s.startsWith("SELECT status FROM replays WHERE run_id=? AND installation_id=?")){const r=d.replays.get(a[0]);return r?{status:r.status}:null;}
    if(s.startsWith("SELECT rank FROM (SELECT installation_id")){const list=ranked(d);const index=list.findIndex(x=>x.installation_id===a[0]);return index<0?null:{rank:index+1};}
    if(s.startsWith("SELECT installation_id FROM players")){const p=d.players.get(a[0]);return p&&!p.deleted_at?{installation_id:p.installation_id}:null;}
    if(s.startsWith("SELECT report_id,status FROM reports")){const r=[...d.reports.values()].find(x=>x.request_id===a[0]);return r?{report_id:r.report_id,status:r.status}:null;}
    if(s.startsWith("SELECT installation_id FROM reports")){const r=d.reports.get(a[0]);return r?{installation_id:r.installation_id}:null;}
    console.error("UNHANDLED FIRST SQL", s, a); throw new Error(`Unimplemented test SQL first: ${s}`);
  }
  async all() {
    const d=this.db,s=this.sql,a=this.args;
    if(s.startsWith("SELECT ranked.rank")){const list=ranked(d).map((x,i)=>({...x,rank:i+1,entry_id:x.installation_id,run_id:x.best_run_id,replay_status:d.replays.get(x.best_run_id)?.status||null,verification_status:"unverified",moderation_required:true}));const q=String(a[0]||"").toLowerCase();return{results:list.filter(x=>!q||(x.name_hidden?"anonymous":x.nickname.toLowerCase()).includes(q)).slice(0,a[2])};}
    if(s.startsWith("SELECT r.report_id,r.installation_id AS entry_id"))return{results:[...d.reports.values()].map(r=>{const score=d.scores.get(r.installation_id),player=d.players.get(r.installation_id);return{...r,entry_id:r.installation_id,details_key:r.object_key,score_wave:score?.wave??null,score_hidden:score?.hidden??null,name_hidden:score?.name_hidden??null,nickname:score?.name_hidden?"Anonymous":score?.nickname??null,player_nickname:player?.nickname??null,best_run_id:score?.best_run_id??null,replay_status:d.replays.get(score?.best_run_id)?.status??null,reported_replay_status:d.replays.get(r.run_id)?.status??null,verification_status:"unverified",moderation_required:1};})};
    console.error("UNHANDLED ALL SQL", s, a); throw new Error(`Unimplemented test SQL all: ${s}`);
  }
}
function changed(yes=true){return{meta:{changes:yes?1:0}};}
function ranked(db){return[...db.scores.values()].filter(x=>!x.hidden).sort((a,b)=>b.wave-a.wave||a.received_at.localeCompare(b.received_at)||a.installation_id.localeCompare(b.installation_id));}

class TestBucket {
  objects = new Map();
  async put(key,value){this.objects.set(key,Buffer.from(value));}
  async get(key){const body=this.objects.get(key);return body?{body}:null;}
  async delete(key){this.objects.delete(key);}
}

const env={DB:new TestDB(),BUCKET:new TestBucket(),MODERATION_SECRET:"local-e2e-moderator-secret-0123456789abcdef"};
const server=http.createServer(async(req,res)=>{
  if(req.url==="/__test__/health"){res.writeHead(200,{"content-type":"application/json"});res.end(JSON.stringify({ok:true}));return;}
  const chunks=[];for await(const chunk of req)chunks.push(chunk);
  const headers=new Headers(req.headers);headers.set("cf-connecting-ip","127.0.0.1");
  const method=req.method||"GET";
  const body=method==="GET"||method==="DELETE"?undefined:Buffer.concat(chunks);
  const request=new Request(new URL(req.url,"http://127.0.0.1:38893"),{method,headers,body,duplex:body?"half":undefined});
  const response=await worker.fetch(request,env);
  process.stdout.write(`${method} ${req.url} -> ${response.status} auth_attempts=${env.DB.attempts.length}\n`);
  const responseBody=Buffer.from(await response.arrayBuffer());
  res.writeHead(response.status,Object.fromEntries(response.headers));res.end(responseBody);
});
server.listen(38893,"127.0.0.1",()=>process.stdout.write("LOCAL_WORKER_E2E_READY\n"));
process.on("SIGTERM",()=>server.close(()=>process.exit(0)));
