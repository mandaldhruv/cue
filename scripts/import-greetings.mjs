import { readFile, writeFile } from "node:fs/promises";
import path from "node:path";

const sourcePath = process.argv[2];
const outputPath = process.argv[3] ?? "app/greetings/greeting-messages.generated.json";

if (!sourcePath) {
  throw new Error("Usage: node scripts/import-greetings.mjs <source.md> [output.json]");
}

const source = await readFile(sourcePath, "utf8");
const result = { admin: [], student: [] };
let audience = null;
let block = null;

for (const rawLine of source.split(/\r?\n/u)) {
  const line = rawLine.trim();
  if (line === "## Admin Messages") {
    audience = "admin";
    block = null;
    continue;
  }
  if (line === "# Student Messages" || line === "## Student Messages") {
    audience = "student";
    block = null;
    continue;
  }
  if (line.startsWith("### ")) {
    if (!audience) throw new Error(`Time block found before audience: ${line}`);
    block = [];
    result[audience].push(block);
    continue;
  }
  const match = line.match(/^(\d+)\.\s+(.+)$/u);
  if (!match) continue;
  if (!audience || !block) throw new Error(`Message found outside a time block: ${line}`);
  const expectedNumber = block.length + 1;
  if (Number(match[1]) !== expectedNumber) {
    throw new Error(`Expected message ${expectedNumber}, found ${match[1]}`);
  }
  block.push(match[2]);
}

for (const audienceName of ["admin", "student"]) {
  if (result[audienceName].length !== 8) {
    throw new Error(`${audienceName} must have 8 time blocks; found ${result[audienceName].length}`);
  }
  result[audienceName].forEach((messages, index) => {
    if (messages.length !== 100) {
      throw new Error(`${audienceName} block ${index + 1} must have 100 messages; found ${messages.length}`);
    }
  });
}

await writeFile(path.resolve(outputPath), `${JSON.stringify(result, null, 2)}\n`, "utf8");
console.log(`Imported 1,600 greetings into ${outputPath}`);
