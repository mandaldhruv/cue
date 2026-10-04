import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs/promises";
import path from "node:path";

async function source(relPath) {
  return fs.readFile(path.join(process.cwd(), relPath), "utf8");
}

test("Admin Sidebar Redesign: Clean, modern outline SVG icon system mapped to all 8 admin destinations", async () => {
  const sidebarNav = await source("app/admin/AdminSidebarNav.tsx");

  // Every admin route has its dedicated outline SVG icon
  const routes = [
    "/admin",
    "/admin/semesters",
    "/admin/subjects",
    "/admin/syllabus",
    "/admin/flashcards",
    "/admin/pyqs",
    "/admin/members",
    "/admin/feedback",
  ];

  for (const route of routes) {
    assert.match(
      sidebarNav,
      new RegExp(`case\\s+"${route.replace(/\//g, "\\/")}"`),
      `Route ${route} must have a dedicated SVG icon case in AdminSidebarNav`
    );
  }

  // Consistent outline icon characteristics: 18x18, strokeWidth 1.8, stroke currentColor
  assert.match(sidebarNav, /width="18"\s+height="18"/);
  assert.match(sidebarNav, /strokeWidth="1\.8"/);
  assert.match(sidebarNav, /stroke="currentColor"/);
  assert.match(sidebarNav, /fill="none"/);

  // Dashboard specifically uses outline Home icon
  assert.match(sidebarNav, /case\s+"\/admin":[\s\S]*?<path\s+d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"\s*\/>/);

  // No heavy letter badges (DB, SE, etc.) rendered as text inside nav icons
  assert.doesNotMatch(sidebarNav, /admin-nav-fallback-code/);
  assert.doesNotMatch(sidebarNav, /admin-sidebar-badge/);
});

test("Admin Sidebar Redesign: Navigation labels sit directly on navy background with no grey pills", async () => {
  const [globals, enhancements] = await Promise.all([
    source("app/globals.css"),
    source("app/enhancements.css"),
  ]);

  // globals.css does not apply grey background to nav spans
  assert.doesNotMatch(globals, /\.admin-sidebar nav a>span\{[^}]*background:#1d2533/);

  // enhancements.css guarantees transparent background for all nav label spans
  assert.match(enhancements, /\.admin-sidebar-label[\s\S]*?background:\s*transparent\s*!important/);
  assert.match(enhancements, /\.admin-sidebar-label[\s\S]*?border-radius:\s*0\s*!important/);
});

test("Admin Sidebar Redesign: Top branding area displays intentional layout with ADMIN CONSOLE badge", async () => {
  const [adminShell, enhancements] = await Promise.all([
    source("app/admin/AdminShell.tsx"),
    source("app/enhancements.css"),
  ]);

  // Logo in fixed head
  assert.match(adminShell, /<div className="admin-sidebar-head"><Logo\s*\/?><\/div>/);

  // CSS presents ADMIN CONSOLE badge with uppercase mono typography and subtle Cue blue tint
  assert.match(enhancements, /\.admin-sidebar-head::after\s*\{[^}]*content:\s*"ADMIN CONSOLE"/);
  assert.match(enhancements, /\.admin-sidebar-head::after\s*\{[^}]*font-family:\s*var\(--font-mono/);
  assert.match(enhancements, /\.admin-sidebar-head::after\s*\{[^}]*letter-spacing:\s*(?:0\.12em|\.12em)/);
  assert.match(enhancements, /\.admin-sidebar-head\s*\{[^}]*border-bottom:\s*1px solid rgba\(255,\s*255,\s*255,\s*0\.06\)/);
});

test("Admin Sidebar Redesign: Refined navigation rows, subtle active state, and restrained hover state", async () => {
  const enhancements = await source("app/enhancements.css");

  // Navigation rows are clean rows without bulky solid buttons
  assert.match(enhancements, /\.admin-nav-link\s*\{[^}]*background:\s*transparent/);
  assert.match(enhancements, /\.admin-nav-link\s*\{[^}]*border-radius:\s*8px/);

  // Section labels use small uppercase typography with medium contrast
  assert.match(enhancements, /\.admin-nav-section-label\s*\{[^}]*text-transform:\s*uppercase/);
  assert.match(enhancements, /\.admin-nav-section-label\s*\{[^}]*font-size:\s*10px/);

  // Active state uses subtle Cue blue tint and left accent bar (no giant solid gradient button or harsh shadow)
  assert.match(enhancements, /\.admin-nav-link\.active\s*\{[^}]*background:\s*rgba\(37,\s*99,\s*235,\s*0\.14\)/);
  assert.match(enhancements, /\.admin-nav-link\.active\s*\{[^}]*box-shadow:\s*none/);
  assert.match(enhancements, /\.admin-nav-link\.active::before\s*\{[^}]*background:\s*#3b82f6/);

  // Hover state uses fast, subtle tint
  assert.match(enhancements, /\.admin-nav-link:hover\s*\{[^}]*background:\s*rgba\(255,\s*255,\s*255,\s*0\.05\)/);
});

test("Admin Sidebar Redesign: Compact, premium profile and user section at bottom", async () => {
  const [adminShell, enhancements] = await Promise.all([
    source("app/admin/AdminShell.tsx"),
    source("app/enhancements.css"),
  ]);

  // Profile contains user avatar, role label, SIGNED IN AS, email and sign out
  assert.match(adminShell, /<div className="admin-user-profile">/);
  assert.match(adminShell, /<div className="admin-user-avatar"/);
  assert.match(adminShell, /<span className="admin-user-role">Admin<\/span>/);
  assert.match(adminShell, /<small>SIGNED IN AS<\/small>/);
  assert.match(adminShell, /<b>\{email\}<\/b>/);
  assert.match(adminShell, /<button type="submit">Sign out<\/button>/);

  // Bottom foot styling: dark navy surface, subtle border, accessible logout with outline icon
  assert.match(enhancements, /\.admin-sidebar-foot\s*\{[^}]*margin-top:\s*auto/);
  assert.match(enhancements, /\.admin-sidebar-foot\s*\{[^}]*border-radius:\s*12px/);
  assert.match(enhancements, /\.admin-sidebar-foot button::before[\s\S]*?background:\s*url\(/);
});

test("Admin Sidebar Redesign: Responsive drawer and desktop sidebar across all requested viewports", async () => {
  const enhancements = await source("app/enhancements.css");

  // Breakpoints: desktop permanent sidebar (min-width: 1201px), drawer on tablets, mobile & all iPads (<=1200px)
  assert.match(enhancements, /@media\(min-width:\s*(?:1025px|1201px)\)[\s\S]*?\.admin-sidebar\s*\{[\s\S]*?width:\s*260px/);
  assert.match(enhancements, /@media\(max-width:\s*(?:1024px|1200px)[\s\S]*?\.admin-sidebar\s*\{[\s\S]*?display:\s*none/);
  assert.match(enhancements, /\.admin-mobile-drawer\s*\{[^}]*width:\s*min\(300px,\s*84vw\)/);
  assert.match(enhancements, /\.admin-mobile-drawer\.open\s*\{[^}]*transform:\s*translateX\(0\)/);
});
