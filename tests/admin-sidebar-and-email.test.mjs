import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs/promises";
import path from "node:path";

async function source(relPath) {
  return fs.readFile(path.join(process.cwd(), relPath), "utf8");
}

test("Admin Sidebar: original elegant structure and clean navigation hierarchy", async () => {
  const [adminShell, sidebarNav] = await Promise.all([
    source("app/admin/AdminShell.tsx"),
    source("app/admin/notifications/AdminSidebarNav.tsx"),
  ]);

  // Original groups preserved
  assert.match(adminShell, /label:\s*"WORKSPACE"/);
  assert.match(adminShell, /label:\s*"ACADEMIC"/);
  assert.match(adminShell, /label:\s*"CONTENT"/);
  assert.match(adminShell, /label:\s*"COMMUNITY"/);

  // Exact items under each group
  assert.match(adminShell, /\["\/admin",\s*"DB",\s*"Dashboard"\]/);
  assert.match(adminShell, /\["\/admin\/semesters",\s*"SE",\s*"Semesters"\]/);
  assert.match(adminShell, /\["\/admin\/subjects",\s*"SU",\s*"Subjects"\]/);
  assert.match(adminShell, /\["\/admin\/syllabus",\s*"SY",\s*"Syllabus"\]/);
  assert.match(adminShell, /\["\/admin\/flashcards",\s*"FC",\s*"Flashcards"\]/);
  assert.match(adminShell, /\["\/admin\/pyqs",\s*"PQ",\s*"PYQs & PDFs"\]/);
  assert.match(adminShell, /\["\/admin\/members",\s*"MB",\s*"Members & Users"\]/);
  assert.match(adminShell, /\["\/admin\/feedback",\s*"VO",\s*"Feedback & Testimonials"\]/);

  // Sidebar navigation does not have pill badges, counts or red dots
  assert.doesNotMatch(sidebarNav, /admin-sidebar-badge/);
  assert.doesNotMatch(sidebarNav, /admin-dot/);
  assert.doesNotMatch(sidebarNav, /\{count/);
});

test("Responsive Breakpoints & Drawer: Desktop fixed sidebar, Tablet/Mobile full-width with drawer", async () => {
  const [enhancements, mobileNav] = await Promise.all([
    source("app/enhancements.css"),
    source("app/admin/AdminMobileNav.tsx"),
  ]);

  // Desktop (min-width: 1025px): fixed sidebar and 260px grid
  assert.match(enhancements, /@media\(min-width:\s*1025px\)[\s\S]*?\.admin-dashboard\s*\{[\s\S]*?grid-template-columns:\s*260px/);
  assert.match(enhancements, /@media\(min-width:\s*1025px\)[\s\S]*?\.admin-sidebar\s*\{[\s\S]*?display:\s*flex/);
  assert.match(enhancements, /@media\(min-width:\s*1025px\)[\s\S]*?\.admin-mobile-header\s*\{[\s\S]*?display:\s*none/);

  // Tablet & Mobile (max-width: 1024px): sidebar hidden, full-width workspace, mobile header visible
  assert.match(enhancements, /@media\(max-width:\s*1024px\)[\s\S]*?\.admin-sidebar\s*\{[\s\S]*?display:\s*none/);
  assert.match(enhancements, /@media\(max-width:\s*1024px\)[\s\S]*?\.admin-dashboard\s*\{[\s\S]*?display:\s*block/);
  assert.match(enhancements, /@media\(max-width:\s*1024px\)[\s\S]*?\.admin-workspace\s*\{[\s\S]*?width:\s*100%/);
  assert.match(enhancements, /@media\(max-width:\s*1024px\)[\s\S]*?\.admin-mobile-header\s*\{[\s\S]*?display:\s*flex/);

  // Drawer slide-out from LEFT with backdrop
  assert.match(enhancements, /\.admin-drawer-backdrop\s*\{[^}]*position:\s*fixed/);
  assert.match(enhancements, /\.admin-mobile-drawer\s*\{[^}]*transform:\s*translateX\(-100%\)/);
  assert.match(enhancements, /\.admin-mobile-drawer\.open\s*\{[^}]*transform:\s*translateX\(0\)/);

  // Mobile nav interactions: ESC key, body scroll lock, close drawer on navigation
  assert.match(mobileNav, /document\.body\.style\.overflow\s*=\s*"hidden"/);
  assert.match(mobileNav, /e\.key === "Escape"/);
  assert.match(mobileNav, /onClick=\{closeDrawer\}/);
  assert.match(mobileNav, /onNavigate=\{closeDrawer\}/);
});

test("Admin Email Notifications: New Member, Feedback, and Content Issue alerts with deduplication", async () => {
  const [emailModule, migration, feedbackActions, loginActions, authCallback] = await Promise.all([
    source("app/lib/email/admin-notifications.ts"),
    source("migrations/20260925083000_admin-email-logs.sql"),
    source("app/feedback/actions.ts"),
    source("app/login/actions.ts"),
    source("app/api/auth/callback/route.ts"),
  ]);

  // Dedicated recipient hersita04@gmail.com with env override
  assert.match(emailModule, /hersita04@gmail\.com/);
  assert.match(emailModule, /ADMIN_NOTIFICATION_EMAIL/);

  // New Member email function & subject
  assert.match(emailModule, /export async function notifyAdminNewMember/);
  assert.match(emailModule, /New Cue Member Joined —/);
  assert.match(emailModule, /View Member/);
  assert.match(emailModule, /\/admin\/members/);

  // New Feedback & High-Priority Content Issue emails
  assert.match(emailModule, /export async function notifyAdminFeedback/);
  assert.match(emailModule, /New Cue Feedback —/);
  assert.match(emailModule, /⚠️ Cue Content Issue Reported — Action Required/);
  assert.match(emailModule, /Review Feedback/);
  assert.match(emailModule, /Review Issue/);
  assert.match(emailModule, /\/admin\/feedback/);

  // Deduplication via admin_email_logs table
  assert.match(migration, /CREATE TABLE IF NOT EXISTS public\.admin_email_logs/);
  assert.match(migration, /CREATE UNIQUE INDEX IF NOT EXISTS admin_email_logs_dedup_idx/);
  assert.match(emailModule, /recordAndCheckDuplicate/);

  // Safe non-blocking integration in feedback submission
  assert.match(feedbackActions, /notifyAdminFeedback\(\{/);
  assert.match(feedbackActions, /isContentIssue:\s*formData\.get\("is_content_issue"\) === "on"/);

  // Safe non-blocking integration in user registration & email verification
  assert.match(loginActions, /notifyAdminNewMember\(\{/);
  assert.match(authCallback, /notifyAdminNewMember\(\{/);
});

test("Admin Authorization & Protection: strict enforcement of authorized admins", async () => {
  const [authHelper, rlsMigration] = await Promise.all([
    source("app/lib/admin-auth.ts"),
    source("migrations/20260925054234_secure-admin-authorization.sql"),
  ]);

  // Authorized emails are strictly hersita04@gmail.com and harshita301doc@gmail.com
  assert.match(authHelper, /hersita04@gmail\.com/);
  assert.match(authHelper, /harshita301doc@gmail\.com/);
  assert.match(rlsMigration, /hersita04@gmail\.com/);
  assert.match(rlsMigration, /harshita301doc@gmail\.com/);
});
