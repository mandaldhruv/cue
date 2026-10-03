import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs/promises";
import path from "node:path";

async function source(relPath) {
  return fs.readFile(path.join(process.cwd(), relPath), "utf8");
}

test("Members & Users: Study Time replaces Account Status across table, mobile labels, and types", async () => {
  const [membersManager, enhancements, types] = await Promise.all([
    source("app/admin/members/MembersManager.tsx"),
    source("app/enhancements.css"),
    source("app/admin/types.ts"),
  ]);

  // 1. Table header replaces ACCOUNT STATUS with STUDY TIME
  assert.match(membersManager, /<span>STUDY TIME<\/span>/);
  assert.doesNotMatch(membersManager, /<span>ACCOUNT STATUS<\/span>/);

  // 2. Table row renders study time column with mobile label and pill
  assert.match(membersManager, /className="members-col-study-time"/);
  assert.match(membersManager, /<span className="members-mobile-label">STUDY TIME<\/span>/);
  assert.match(membersManager, /formatStudyTime\(studySeconds\)/);

  // 3. Types include total_study_seconds and session_count on MemberRecord
  assert.match(types, /total_study_seconds\?:/);
  assert.match(types, /session_count\?:/);
  assert.match(types, /export type UserSessionRecord/);

  // 4. CSS contains styling for members-col-study-time and members-study-pill
  assert.match(enhancements, /\.members-col-study-time\s*\{/);
  assert.match(enhancements, /\.members-study-pill\s*\{/);
  assert.match(enhancements, /\.members-study-pill\.has-time\s*\{/);
  assert.match(enhancements, /\.members-study-pill\.zero-time\s*\{/);
});

test("Activity Tracking: Client ActivityTracker handles lifecycle, inactivity, tab switching, and leaving", async () => {
  const [tracker, authProvider] = await Promise.all([
    source("app/auth/ActivityTracker.tsx"),
    source("app/auth/AuthProvider.tsx"),
  ]);

  // 1. ActivityTracker mounted inside AuthProvider
  assert.match(authProvider, /<ActivityTracker\s*\/>/);

  // 2. Storage keys and configurable thresholds defined
  assert.match(tracker, /INACTIVITY_THRESHOLD_MS\s*=\s*120_000/); // 2 minutes idle threshold
  assert.match(tracker, /HEARTBEAT_INTERVAL_SECONDS\s*=\s*25/); // 25 seconds heartbeat
  assert.match(tracker, /SESSION_TIMEOUT_MS\s*=\s*15\s*\*\s*60\s*\*\s*1000/); // 15 mins session window

  // 3. Browser lifecycle listeners
  assert.match(tracker, /document\.addEventListener\("visibilitychange"/);
  assert.match(tracker, /window\.addEventListener\("pagehide"/);
  assert.match(tracker, /window\.addEventListener\("beforeunload"/);

  // 4. Inactivity detection: user interaction resets timer
  assert.match(tracker, /mousedown.*keydown.*touchstart.*scroll.*mousemove/);

  // 5. Leaving detection: sendBeacon with keepalive fallback
  assert.match(tracker, /navigator\.sendBeacon/);
  assert.match(tracker, /keepalive:\s*isClosing/);

  // 6. Session continuity across navigation and page refresh
  assert.match(tracker, /sessionStorage\.getItem/);
  assert.match(tracker, /localStorage\.getItem/);

  // 7. Resource analytics readiness: categorizes subjects, flashcards, pyqs
  assert.match(tracker, /getResourceType/);
  assert.match(tracker, /getResourceId/);
});

test("Activity Backend: Heartbeat route, member sessions API, and database migration integrity", async () => {
  const [heartbeatRoute, activityRoute, migration] = await Promise.all([
    source("app/api/activity/heartbeat/route.ts"),
    source("app/api/admin/members/[id]/activity/route.ts"),
    source("migrations/20261003120000_user-study-sessions-and-activity.sql"),
  ]);

  // 1. Heartbeat route validates auth and calls atomic RPC
  assert.match(heartbeatRoute, /client\.auth\.getCurrentUser\(\)/);
  assert.match(heartbeatRoute, /record_cue_study_heartbeat/);
  assert.match(heartbeatRoute, /deltaSeconds/);

  // 2. Admin activity route protects member sessions
  assert.match(activityRoute, /requireAdminSession\(\)/);
  assert.match(activityRoute, /get_cue_member_sessions/);

  // 3. Database migration creates table with RLS and cascade
  assert.match(migration, /CREATE TABLE IF NOT EXISTS public\.user_study_sessions/);
  assert.match(migration, /REFERENCES auth\.users\(id\)\s+ON DELETE CASCADE/);
  assert.match(migration, /ALTER TABLE public\.user_study_sessions ENABLE ROW LEVEL SECURITY/);

  // 4. Migration creates atomic RPC with bounds checking
  assert.match(migration, /CREATE OR REPLACE FUNCTION public\.record_cue_study_heartbeat/);
  assert.match(migration, /GREATEST\(0,\s*LEAST\(COALESCE\(p_delta_seconds,\s*0\),\s*120\)\)/);

  // 5. Migration updates get_cue_members with true last active and accumulated study time
  assert.match(migration, /CREATE OR REPLACE FUNCTION public\.get_cue_members\(\)/);
  assert.match(migration, /total_study_seconds bigint/);
  assert.match(migration, /session_count bigint/);
  assert.match(migration, /COALESCE\(ss\.last_session_activity,\s*gs\.last_greeting_at/);
});

test("Member Activity Detail Modal: provides rich session drilldown for administrators", async () => {
  const [membersManager, enhancements] = await Promise.all([
    source("app/admin/members/MembersManager.tsx"),
    source("app/enhancements.css"),
  ]);

  // 1. Modal markup present in MembersManager
  assert.match(membersManager, /className="member-detail-backdrop"/);
  assert.match(membersManager, /TOTAL STUDY TIME/);
  assert.match(membersManager, /TOTAL SESSIONS/);
  assert.match(membersManager, /AVG\. SESSION/);
  assert.match(membersManager, /LAST CONFIRMED ACTIVE/);
  assert.match(membersManager, /Recent Study Sessions/);

  // 2. Responsive modal styles defined in enhancements.css
  assert.match(enhancements, /\.member-detail-backdrop\s*\{/);
  assert.match(enhancements, /\.member-detail-card\s*\{/);
  assert.match(enhancements, /\.member-detail-stats\s*\{/);
  assert.match(enhancements, /\.member-sessions-list\s*\{/);
});
