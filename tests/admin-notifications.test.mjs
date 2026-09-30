import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs/promises";
import path from "node:path";

async function source(relPath) {
  return fs.readFile(path.join(process.cwd(), relPath), "utf8");
}

async function fileExists(relPath) {
  try {
    await fs.access(path.join(process.cwd(), relPath));
    return true;
  } catch {
    return false;
  }
}

test("Admin Notifications Removal: bell, badges, panels, triggers and routes completely removed", async () => {
  const [adminShell, enhancements, contentActions] = await Promise.all([
    source("app/admin/AdminShell.tsx"),
    source("app/enhancements.css"),
    source("app/admin/content-actions.ts"),
  ]);

  // 1. AdminShell does not import or render notification components or providers
  assert.doesNotMatch(adminShell, /AdminNotificationBell/);
  assert.doesNotMatch(adminShell, /AdminNotificationProvider/);
  assert.doesNotMatch(adminShell, /getAdminNotificationDataAction/);
  assert.doesNotMatch(adminShell, /admin-mobile-bell/);

  // 2. Mobile and desktop headers have clean "Live site ↗" actions without bells
  assert.match(adminShell, /<div className="admin-mobile-actions">\s*<Link href="\/" target="_blank" aria-label="View live website">\s*Live site ↗\s*<\/Link>\s*<AdminMobileNav/s);
  assert.match(adminShell, /<div className="admin-header-actions">\s*<Link href="\/" target="_blank" className="admin-live-link">\s*View live site ↗\s*<\/Link>\s*<\/div>/s);

  // 3. Removed notification components, context, and API routes
  assert.equal(await fileExists("app/admin/notifications/AdminNotificationBell.tsx"), false);
  assert.equal(await fileExists("app/admin/notifications/AdminNotificationContext.tsx"), false);
  assert.equal(await fileExists("app/admin/notifications/actions.ts"), false);
  assert.equal(await fileExists("app/admin/notifications/types.ts"), false);
  assert.equal(await fileExists("app/api/admin/notifications/route.ts"), false);

  // 4. Content actions do not fire in-app notification RPCs
  assert.doesNotMatch(contentActions, /record_admin_notification/);

  // 5. CSS completely removed notification bells, badges, panels, and animations
  assert.doesNotMatch(enhancements, /\.admin-notif-container/);
  assert.doesNotMatch(enhancements, /\.admin-notif-trigger/);
  assert.doesNotMatch(enhancements, /\.admin-notif-badge/);
  assert.doesNotMatch(enhancements, /\.admin-notif-panel/);
  assert.doesNotMatch(enhancements, /@keyframes adminBellGentleRing/);
  assert.doesNotMatch(enhancements, /@keyframes cueBadgePop/);
  assert.doesNotMatch(enhancements, /@keyframes cueNotifPanelSlide/);
  assert.doesNotMatch(enhancements, /\.admin-mobile-bell/);
});

test("Admin Responsive Drawer & Hamburger: tablet/iPad breakpoints (768px, 820px, 834px, 912px, 1024px, landscape)", async () => {
  const [enhancements, mobileNav] = await Promise.all([
    source("app/enhancements.css"),
    source("app/admin/AdminMobileNav.tsx"),
  ]);

  // Desktop (>1200px): Fixed sidebar, hidden mobile header and hidden drawer
  assert.match(enhancements, /@media\(min-width:\s*(?:1025px|1201px)\)[\s\S]*?\.admin-sidebar\s*\{[\s\S]*?display:\s*flex/);
  assert.match(enhancements, /@media\(min-width:\s*(?:1025px|1201px)\)[\s\S]*?\.admin-mobile-header\s*\{[\s\S]*?display:\s*none/);
  assert.match(enhancements, /@media\(min-width:\s*(?:1025px|1201px)\)[\s\S]*?\.admin-mobile-drawer\s*\{[\s\S]*?display:\s*none/);

  // Tablet & iPad Breakpoints (<=1200px or touch screens up to 1400px):
  // Covers 768px, 820px, 834px, 912px, 1024px, and iPad landscape (1080px, 1180px, 1194px, 1366px)
  assert.match(enhancements, /@media\(max-width:\s*(?:1024px|1200px)[\s\S]*?\.admin-sidebar\s*\{[\s\S]*?display:\s*none/);
  assert.match(enhancements, /@media\(max-width:\s*(?:1024px|1200px)[\s\S]*?\.admin-mobile-header\s*\{[\s\S]*?display:\s*flex/);
  assert.match(enhancements, /@media\(max-width:\s*(?:1024px|1200px)[\s\S]*?\.admin-workspace\s*\{[\s\S]*?width:\s*100%/);
  assert.match(enhancements, /@media\(max-width:\s*(?:1024px|1200px)[\s\S]*?\.admin-mobile-drawer\s*\{[\s\S]*?display:\s*flex/);
  assert.match(enhancements, /@media\(max-width:\s*(?:1024px|1200px)[\s\S]*?\.admin-drawer-backdrop\s*\{[\s\S]*?display:\s*block/);

  // Hamburger button: clickable, touch-friendly, touch-action manipulation
  assert.match(enhancements, /\.admin-mobile-hamburger\s*\{[^}]*touch-action:\s*manipulation/);
  assert.match(enhancements, /\.admin-mobile-hamburger\s*\{[^}]*cursor:\s*pointer/);

  // Drawer slide-out animation and closing isolation (does not block main page interactions)
  assert.match(enhancements, /\.admin-mobile-drawer\s*\{[^}]*transform:\s*translateX\(-100%\)/);
  assert.match(enhancements, /\.admin-mobile-drawer\s*\{[^}]*visibility:\s*hidden/);
  assert.match(enhancements, /\.admin-mobile-drawer\s*\{[^}]*pointer-events:\s*none/);
  assert.match(enhancements, /\.admin-mobile-drawer\.open\s*\{[^}]*transform:\s*translateX\(0\)/);
  assert.match(enhancements, /\.admin-mobile-drawer\.open\s*\{[^}]*visibility:\s*visible/);
  assert.match(enhancements, /\.admin-mobile-drawer\.open\s*\{[^}]*pointer-events:\s*auto/);

  // Drawer scrollable with touch gesture support
  assert.match(enhancements, /\.admin-drawer-scroll\s*\{[^}]*overflow-y:\s*auto/);
  assert.match(enhancements, /\.admin-drawer-scroll\s*\{[^}]*overscroll-behavior:\s*contain/);
  assert.match(enhancements, /\.admin-drawer-scroll\s*\{[^}]*-webkit-overflow-scrolling:\s*touch/);
  assert.match(enhancements, /\.admin-drawer-scroll\s*\{[^}]*touch-action:\s*pan-y/);

  // Drawer backdrop: fixed overlay with backdrop click dismissal
  assert.match(enhancements, /\.admin-drawer-backdrop\s*\{[^}]*position:\s*fixed/);
  assert.match(mobileNav, /onClick=\{closeDrawer\}/);
  assert.match(mobileNav, /document\.body\.style\.overflow\s*=\s*""/);
});

test("Admin Features Preservation: members, feedback, authentication, and access control intact", async () => {
  const [adminShell, membersPage, feedbackPage, authLib] = await Promise.all([
    source("app/admin/AdminShell.tsx"),
    source("app/admin/members/page.tsx"),
    source("app/admin/feedback/page.tsx"),
    source("app/lib/admin-auth.ts"),
  ]);

  // Preserves Members & Users and Feedback navigation
  assert.match(adminShell, /\["\/admin\/members",\s*"MB",\s*"Members & Users"\]/);
  assert.match(adminShell, /\["\/admin\/feedback",\s*"VO",\s*"Feedback & Testimonials"\]/);

  // Pages enforce admin authorization
  assert.match(membersPage, /requireAdminSession\(\)/);
  assert.match(feedbackPage, /requireAdminSession\(\)/);

  // Auth enforcement remains strict
  assert.match(authLib, /AUTHORIZED_ADMIN_EMAILS/);
  assert.match(authLib, /isAuthorizedAdminEmail/);
});
