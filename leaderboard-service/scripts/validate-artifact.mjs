import { readFile } from "node:fs/promises";
import assert from "node:assert/strict";
const manifest = JSON.parse(await readFile(new URL("../dist/.openai/hosting.json", import.meta.url), "utf8"));
const worker = await readFile(new URL("../dist/server/index.js", import.meta.url), "utf8");
assert.equal(manifest.d1, "DB");
assert.equal(manifest.r2, "BUCKET");
assert.match(worker, /export default/);
console.log("WORKER_ARTIFACT_VALID");
