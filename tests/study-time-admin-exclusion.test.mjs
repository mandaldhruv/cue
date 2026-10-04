import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs/promises";
import path from "node:path";
import { isAdminRoute, isStudyRoute } from "../app/lib/study-tracking.ts";

async function source(relPath) {
  return fs.readFile(path.join(process.cwd(), relPath), "utf8");
}

test("Study Time Classification: Route helpers strictly differentiate Admin vs Student routes", () => {
  const adminRoutes = [
    "/admin",
    "/admin/",
    "/admin/dashboard",
    "/admin/members",
    "/admin/subjects",
    "/admin/syllabus",
    "/admin/flashcards",
    "/admin/pyqs",
    "/admin/feedback",
    "/admin/login",
    "/admin/semesters",
    "/admin/content",
    "/admin?tab=overview",
  ];

  for (const route of adminRoutes) {
    assert.strictEqual(
      isAdminRoute(route),
      true,
      `Expected ${route} to be identified as an admin route`
    );
    assert.strictEqual(
      isStudyRoute(route),
      false,
      `Expected ${route} NOT to be identified as a study route`
    );
  }

  const studentRoutes = [
    "/",
    "/subjects",
    "/subjects/equity-and-debt-markets",
    "/subjects/hindi-i",
    "/flashcards",
    "/flashcards/equity-and-debt-markets",
    "/pyqs",
    "/about",
    "/feedback",
    "/help",
    "/login",
  ];

  for (const route of studentRoutes) {
    assert.strictEqual(
      isAdminRoute(route),
      false,
      `Expected ${route} NOT to be an admin route`
    );
    assert.strictEqual(
      isStudyRoute(route),
      true,
      `Expected ${route} to be identified as a student study route`
    );
  }
});

test("Scenario 1 — Admin Activity: Admin spends 30m inside Admin Panel -> 0m Study Time", () => {
  // Simulate active ticker ticks while navigating Admin Panel
  let studySeconds = 0;
  const adminPagesVisited = [
    "/admin",
    "/admin/syllabus",
    "/admin/members",
    "/admin/pyqs",
    "/admin/flashcards",
    "/admin/feedback",
  ];

  for (const page of adminPagesVisited) {
    // 5 minutes (300 seconds) on each admin page
    for (let sec = 0; sec < 300; sec++) {
      if (!isAdminRoute(page)) {
        studySeconds += 1;
      }
    }
  }

  assert.strictEqual(studySeconds, 0, "Admin activity must contribute 0 seconds to Study Time");
});

test("Scenario 2 — Admin Uses Student Website: Same admin spends 25m on student site -> 25m Study Time", () => {
  // Admin with admin role visiting student study pages
  let studySeconds = 0;
  const studentPagesVisited = [
    "/subjects/equity-and-debt-markets",
    "/flashcards/equity-and-debt-markets",
    "/pyqs",
  ];

  // Total 25 minutes = 1500 seconds
  const secondsPerPage = 1500 / studentPagesVisited.length;
  for (const page of studentPagesVisited) {
    for (let sec = 0; sec < secondsPerPage; sec++) {
      if (isStudyRoute(page)) {
        studySeconds += 1;
      }
    }
  }

  assert.strictEqual(studySeconds, 1500, "Student-facing activity by admin must accumulate 1500s (25m)");
});

test("Scenario 3 — Mixed Session: 20m in Admin Panel + 35m in student site -> 35m Study Time (NOT 55m)", () => {
  let studySeconds = 0;

  // 1. 20m in Admin Panel = 1200 seconds
  const adminPage = "/admin/members";
  for (let sec = 0; sec < 1200; sec++) {
    if (isStudyRoute(adminPage)) {
      studySeconds += 1;
    }
  }

  // 2. 35m in Student-facing website = 2100 seconds
  const studentPage = "/subjects/hindi-i";
  for (let sec = 0; sec < 2100; sec++) {
    if (isStudyRoute(studentPage)) {
      studySeconds += 1;
    }
  }

  assert.strictEqual(studySeconds, 2100, "Mixed session must yield exactly 35m (2100s), NOT 55m (3300s)");
});

test("Scenario 4 — Normal Student: Student spends 40m on student-facing website -> 40m Study Time", () => {
  let studySeconds = 0;
  const studentPage = "/flashcards/principles-of-economics-ii";

  // 40m = 2400 seconds
  for (let sec = 0; sec < 2400; sec++) {
    if (isStudyRoute(studentPage)) {
      studySeconds += 1;
    }
  }

  assert.strictEqual(studySeconds, 2400, "Student must accumulate full 40m (2400s) on student pages");
});

test("Codebase Verification: ActivityTracker, AdminLayout, Heartbeat Route, and Migration Integrity", async () => {
  const [tracker, adminLayout, heartbeatRoute, migration] = await Promise.all([
    source("app/auth/ActivityTracker.tsx"),
    source("app/admin/layout.tsx"),
    source("app/api/activity/heartbeat/route.ts"),
    source("migrations/20261004120000_exclude-admin-pages-from-study-time.sql"),
  ]);

  // 1. ActivityTracker imports isAdminRoute and guards interval ticker and heartbeat flush
  assert.match(tracker, /import\s*\{\s*isAdminRoute\s*\}\s*from\s*"\.\.\/lib\/study-tracking"/);
  assert.match(tracker, /function isInAdminContext/);
  assert.match(tracker, /if\s*\(isInAdminContext\(currentPath\)\)\s*\{\s*accumulatedSecondsRef\.current\s*=\s*0;\s*return;\s*\}/);

  // 2. AdminLayout sets data-admin-context="true"
  assert.match(adminLayout, /data-admin-context="true"/);

  // 3. Heartbeat route forces deltaSeconds = 0 and rejects admin heartbeat deltas
  assert.match(heartbeatRoute, /import\s*\{\s*isAdminRoute\s*\}\s*from\s*"\.\.\/\.\.\/\.\.\/lib\/study-tracking"/);
  assert.match(heartbeatRoute, /if\s*\(isAdmin\s*&&\s*!isClosing\)\s*\{\s*return\s+NextResponse\.json/);
  assert.match(heartbeatRoute, /deltaSeconds\s*=\s*isAdmin\s*\?\s*0\s*:/);

  // 4. Database migration zeroes historical admin rows and filters all study time queries
  assert.match(migration, /UPDATE public\.user_study_sessions\s+SET duration_seconds = 0\s+WHERE page_path IS NOT NULL AND/);
  assert.match(migration, /CREATE OR REPLACE FUNCTION public\.record_cue_study_heartbeat/);
  assert.match(migration, /v_valid_delta\s*:=\s*0/);
  assert.match(migration, /CREATE OR REPLACE FUNCTION public\.get_cue_study_time_summary/);
  assert.match(migration, /lower\(trim\(s\.page_path\)\)\s*<>\s*'\/admin'/);
  assert.match(migration, /CREATE OR REPLACE FUNCTION public\.get_cue_members/);
  assert.match(migration, /CREATE OR REPLACE FUNCTION public\.get_cue_member_sessions/);
});
