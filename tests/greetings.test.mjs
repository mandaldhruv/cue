import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";

const messages = JSON.parse(await readFile(new URL("../app/greetings/greeting-messages.generated.json", import.meta.url), "utf8"));
const migration = await readFile(new URL("../migrations/20260920130439_add-personalized-greeting-progress.sql", import.meta.url), "utf8");
const correction = await readFile(new URL("../migrations/20260920133040_fix-greeting-reservation.sql", import.meta.url), "utf8");

test("the approved greeting library keeps every ordered message", () => {
  assert.deepEqual(Object.keys(messages), ["admin", "student"]);
  for (const audience of ["admin", "student"]) {
    assert.equal(messages[audience].length, 8);
    for (const block of messages[audience]) assert.equal(block.length, 100);
  }
  assert.equal(messages.admin.flat().length + messages.student.flat().length, 1600);
});

test("student messages retain the dynamic name placeholder", () => {
  assert.ok(messages.student.flat().every((message) => message.includes("[Name]")));
  assert.ok(messages.admin.flat().every((message) => !message.includes("[Name]")));
});

test("the reservation migration enforces IST blocks, rollover and idempotency", () => {
  assert.match(migration, /Asia\/Kolkata/u);
  assert.match(migration, /% 100/u);
  assert.match(migration, /PRIMARY KEY \(user_id, event_id\)/u);
  assert.match(migration, /pg_advisory_xact_lock/u);
  assert.match(correction, /ON CONFLICT ON CONSTRAINT greeting_progress_pkey/u);
  assert.doesNotMatch(correction, /not shown to administrators/u);
});
