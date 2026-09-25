import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs/promises";
import path from "node:path";

async function source(relPath) {
  return fs.readFile(path.join(process.cwd(), relPath), "utf8");
}

test("Admin Notifications Schema: table, deduplication, indexes, RLS, and RPC functions", async () => {
  const migration = await source("migrations/20260925072418_admin-notifications.sql");

  // Required columns in admin_notifications
  assert.match(migration, /CREATE TABLE IF NOT EXISTS public\.admin_notifications/);
  assert.match(migration, /id uuid PRIMARY KEY/);
  assert.match(migration, /type text NOT NULL/);
  assert.match(migration, /title text NOT NULL/);
  assert.match(migration, /message text NOT NULL/);
  assert.match(migration, /category text NOT NULL/);
  assert.match(migration, /priority text NOT NULL DEFAULT 'normal'/);
  assert.match(migration, /link text NOT NULL/);
  assert.match(migration, /related_id uuid/);
  assert.match(migration, /is_read boolean NOT NULL DEFAULT false/);
  assert.match(migration, /read_at timestamptz/);
  assert.match(migration, /read_by uuid REFERENCES auth\.users/);
  assert.match(migration, /created_at timestamptz NOT NULL DEFAULT now\(\)/);

  // Deduplication index preventing duplicate notifications for same event
  assert.match(migration, /CREATE UNIQUE INDEX IF NOT EXISTS admin_notifications_dedup_idx/);

  // Row Level Security and admin authorization policies
  assert.match(migration, /ALTER TABLE public\.admin_notifications ENABLE ROW LEVEL SECURITY/);
  assert.match(migration, /REVOKE ALL ON TABLE public\.admin_notifications FROM anon, authenticated/);
  assert.match(migration, /GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public\.admin_notifications TO authenticated/);
  assert.match(migration, /public\.is_cue_admin\(\)/);

  // RPC helper functions
  assert.match(migration, /FUNCTION public\.record_admin_notification/);
  assert.match(migration, /FUNCTION public\.get_admin_notification_counts/);
  assert.match(migration, /FUNCTION public\.get_admin_notifications/);
  assert.match(migration, /FUNCTION public\.mark_admin_notification_read/);
  assert.match(migration, /FUNCTION public\.mark_all_admin_notifications_read/);
  assert.match(migration, /FUNCTION public\.mark_category_admin_notifications_read/);
});

test("Admin Notification Triggers & Handlers: new member, new feedback, content issue, testimonial, pyq, study content", async () => {
  const [migration, contentActions] = await Promise.all([
    source("migrations/20260925072418_admin-notifications.sql"),
    source("app/admin/content-actions.ts"),
  ]);

  // A. New Member Trigger: triggers when student joins, skips admin accounts
  assert.match(migration, /FUNCTION public\.notify_on_new_user\(\)/);
  assert.match(migration, /'new_member'/);
  assert.match(migration, /v_name \|\| ' joined as a Student'/);
  assert.match(migration, /'members'/);
  assert.match(migration, /trg_notify_new_user/);

  // B. New Feedback Trigger: standard student feedback
  assert.match(migration, /FUNCTION public\.notify_on_new_feedback\(\)/);
  assert.match(migration, /'new_feedback'/);
  assert.match(migration, /submitted new feedback as a/);
  assert.match(migration, /'feedback'/);

  // C. Content Issue Reported: high priority flag
  assert.match(migration, /NEW\.is_content_issue IS TRUE/);
  assert.match(migration, /'content_issue'/);
  assert.match(migration, /'Content issue reported'/);
  assert.match(migration, /reported an incorrect or outdated content issue/);
  assert.match(migration, /'high'/);

  // D. Testimonial Published: triggers on publication
  assert.match(migration, /FUNCTION public\.notify_on_testimonial_published\(\)/);
  assert.match(migration, /'testimonial_published'/);
  assert.match(migration, /Feedback from.*was published as a testimonial/);

  // E. PYQs: recorded on save and publish
  assert.match(contentActions, /p_type:\s*"pyq_updated"/);
  assert.match(contentActions, /p_category:\s*"pyqs"/);
  assert.match(contentActions, /p_link:\s*"\/admin\/pyqs"/);

  // F. Study Content: recorded on syllabus/flashcard save and publish
  assert.match(contentActions, /p_type:\s*"content_updated"/);
  assert.match(contentActions, /p_category:\s*"content"/);
});

test("Dashboard Notification Button: positioned beside View Live Site with clean badge behavior", async () => {
  const [adminShell, bell] = await Promise.all([
    source("app/admin/AdminShell.tsx"),
    source("app/admin/notifications/AdminNotificationBell.tsx"),
  ]);

  // Placed beside "View live site ↗" in workspace header
  assert.match(adminShell, /<div className="admin-header-actions">\s*<AdminNotificationBell \/>\s*<Link href="\/" target="_blank" className="admin-live-link">\s*View live site ↗/s);

  // Placed beside "Live site ↗" in mobile header
  assert.match(adminShell, /<div className="admin-mobile-actions">\s*<AdminNotificationBell className="admin-mobile-bell" \/>\s*<Link href="\/" target="_blank" aria-label="View live website">\s*Live site ↗/s);

  // Zero count rule: Badge must NOT render 0, must hide completely when zero
  assert.match(bell, /\{unreadCount > 0 && \(\s*<span className="admin-notif-badge"/);
  assert.match(bell, /unreadCount > 99 \? "99\+" : unreadCount/);
});

test("Notification Panel & Empty State: header, mark-all-read, item layout, and empty state", async () => {
  const bell = await source("app/admin/notifications/AdminNotificationBell.tsx");

  // Panel title & counter
  assert.match(bell, /<h3>Notifications<\/h3>/);
  assert.match(bell, /Mark all as read/);

  // Empty state copy
  assert.match(bell, /You(&apos;|')re all caught up\./);
  assert.match(bell, /No new notifications right now\./);

  // Relative time formatter
  assert.match(bell, /function formatRelativeTime/);
  assert.match(bell, /"Just now"/);

  // Priority and Category Icons
  assert.match(bell, /function NotificationIcon/);
  assert.match(bell, /priority-high/);
  assert.match(bell, /type-member/);
  assert.match(bell, /type-feedback/);
  assert.match(bell, /type-testimonial/);
  assert.match(bell, /type-pyq/);
  assert.match(bell, /type-content/);
});

test("Sidebar Category Badges: dynamic badges, omit on zero, and section auto-read", async () => {
  const [sidebarNav, context] = await Promise.all([
    source("app/admin/notifications/AdminSidebarNav.tsx"),
    source("app/admin/notifications/AdminNotificationContext.tsx"),
  ]);

  // Sidebar renders badge only when count > 0, never renders [0]
  assert.match(sidebarNav, /\{count > 0 && \(\s*<span className="admin-sidebar-badge">\{count > 99 \? "99\+" : count\}<\/span>\s*\)\}/);

  // Maps categories to routes
  assert.match(sidebarNav, /href === "\/admin\/members"/);
  assert.match(sidebarNav, /href === "\/admin\/feedback"/);
  assert.match(sidebarNav, /href === "\/admin\/pyqs"/);
  assert.match(sidebarNav, /href === "\/admin\/syllabus" \|\| href === "\/admin\/flashcards"/);

  // Context auto-marks category notifications as read when opening section
  assert.match(context, /function routeToCategory/);
  assert.match(context, /if \(category && counts\[category\] > 0\) \{\s*markCategoryRead\(category\);/);
});

test("Security & Authorization: API route and actions strictly protect admin notifications", async () => {
  const [apiRoute, actions] = await Promise.all([
    source("app/api/admin/notifications/route.ts"),
    source("app/admin/notifications/actions.ts"),
  ]);

  // API route requires getAdminSession
  assert.match(apiRoute, /getAdminSession\(\)/);
  assert.match(apiRoute, /if \(!session\.user \|\| !session\.isAdmin\)/);
  assert.match(apiRoute, /status: 401/);

  // Server actions require admin context
  assert.match(actions, /async function adminContext\(\)/);
  assert.match(actions, /const session = await getAdminSession\(\);/);
  assert.match(actions, /if \(!session\.user \|\| !session\.isAdmin\) return null;/);
});

test("Responsive Styling & Animation: CSS guarantees fit inside viewport without horizontal overflow", async () => {
  const enhancements = await source("app/enhancements.css");

  // Notification container and button
  assert.match(enhancements, /\.admin-notif-container/);
  assert.match(enhancements, /\.admin-notif-trigger/);

  // Badge pop animation
  assert.match(enhancements, /\.admin-notif-badge/);
  assert.match(enhancements, /@keyframes cueBadgePop/);

  // Sidebar badge styling
  assert.match(enhancements, /\.admin-sidebar-badge/);

  // Popover panel animation & containment
  assert.match(enhancements, /\.admin-notif-panel/);
  assert.match(enhancements, /@keyframes cueNotifPanelSlide/);

  // Mobile / tablet safe margins
  assert.match(enhancements, /@media\s*\(max-width:\s*760px\)\s*\{[^}]*\.admin-notif-panel\s*\{[^}]*position:\s*fixed/);
  assert.match(enhancements, /@media\s*\(max-width:\s*760px\)\s*\{[^}]*\.admin-notif-panel\s*\{[^}]*left:\s*14px/);
  assert.match(enhancements, /@media\s*\(max-width:\s*760px\)\s*\{[^}]*\.admin-notif-panel\s*\{[^}]*right:\s*14px/);
});
