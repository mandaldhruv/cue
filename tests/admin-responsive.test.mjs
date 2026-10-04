import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs/promises";
import path from "node:path";

async function source(relPath) {
  return fs.readFile(path.join(process.cwd(), relPath), "utf8");
}

test("Admin Sidebar: independent scroll, fixed logo, and reachable account/logout", async () => {
  const [adminShell, enhancements, globals] = await Promise.all([
    source("app/admin/AdminShell.tsx"),
    source("app/enhancements.css"),
    source("app/globals.css"),
  ]);

  // Shell structure separates fixed header logo from scrollable body
  assert.match(adminShell, /<div className="admin-sidebar-head"><Logo\s*\/?><\/div>/);
  assert.match(adminShell, /<div className="admin-sidebar-scroll">/);
  assert.match(adminShell, /<div className="admin-sidebar-foot">/);
  assert.match(adminShell, /<small>SIGNED IN AS<\/small>/);
  assert.match(adminShell, /<button type="submit">Sign out<\/button>/);

  // CSS guarantees independent scroll with overscroll containment and thin custom scrollbar
  assert.match(enhancements, /\.admin-sidebar\s*\{[^}]*position:\s*sticky/);
  assert.match(enhancements, /\.admin-sidebar\s*\{[^}]*overflow:\s*hidden/);
  assert.match(enhancements, /\.admin-sidebar-head\s*\{[^}]*flex-shrink:\s*0/);
  assert.match(enhancements, /\.admin-sidebar-scroll\s*\{[^}]*overflow-y:\s*auto/);
  assert.match(enhancements, /\.admin-sidebar-scroll\s*\{[^}]*overscroll-behavior:\s*contain/);
  assert.match(enhancements, /\.admin-sidebar-foot\s*\{[^}]*margin-top:\s*auto/);

  // Sidebar labels and foot are not collapsed to font-size 0 on tablet
  assert.doesNotMatch(globals, /\.admin-sidebar nav a:not\(\.active\)\{font-size:0\}/);
  assert.doesNotMatch(globals, /\.admin-sidebar-foot small,\.admin-sidebar-foot b\{display:none\}/);
});

test("Admin Dashboard: balanced 6-card grid across desktop (6), tablet (3+3), and mobile (2+2+2)", async () => {
  const [page, enhancements] = await Promise.all([
    source("app/admin/page.tsx"),
    source("app/enhancements.css"),
  ]);

  // Page renders all 6 summary cards
  assert.match(page, /PUBLISHED SUBJECTS/);
  assert.match(page, /LIVE MATERIAL/);
  assert.match(page, /NEW FEEDBACK/);
  assert.match(page, /TOTAL MEMBERS/);
  assert.match(page, /AVAILABLE SEMESTERS/);
  assert.match(page, /STUDY TIME THIS WEEK/);

  // CSS enforces desktop 6-card row, tablet 3+3, and mobile 2+2+2
  assert.match(enhancements, /\.admin-stat-grid\s*\{[^}]*grid-template-columns:\s*repeat\(6,\s*minmax\(0,\s*1fr\)\)/);
  assert.match(enhancements, /@media\s*\(max-width:\s*1200px\)[^}]*grid-template-columns:\s*repeat\(3,\s*minmax\(0,\s*1fr\)\)\s*!important/);
  assert.match(enhancements, /@media\s*\(max-width:\s*680px\)[^}]*grid-template-columns:\s*repeat\(2,\s*minmax\(0,\s*1fr\)\)\s*!important/);

  // Mobile never stacks all cards into 1 column
  assert.doesNotMatch(enhancements, /@media\(max-width:\s*390px\)\s*\{[^}]*\.admin-stat-grid\s*\{[^}]*grid-template-columns:\s*1fr/);
});

test("Members & Users: clearly labelled Registration Date and Last Active on mobile/tablet", async () => {
  const [membersManager, enhancements] = await Promise.all([
    source("app/admin/members/MembersManager.tsx"),
    source("app/enhancements.css"),
  ]);

  // Manager provides explicit mobile labels for both dates
  assert.match(membersManager, /<span className="members-mobile-label">REGISTRATION DATE<\/span>/);
  assert.match(membersManager, /<span className="members-mobile-label">LAST ACTIVE<\/span>/);
  assert.match(membersManager, /className="members-dates-grid"/);

  // Desktop hides mobile labels and preserves grid layout via display: contents
  assert.match(enhancements, /\.members-mobile-label\s*\{\s*display:\s*none;\s*\}/);
  assert.match(enhancements, /\.members-dates-grid\s*\{\s*display:\s*contents;\s*\}/);

  // Mobile table view displays uppercase labels and 2-column side-by-side date container
  assert.match(enhancements, /\.members-mobile-label\s*\{[^}]*display:\s*block/);
  assert.match(enhancements, /\.members-dates-grid\s*\{[^}]*grid-template-columns:\s*1fr 1fr/);
});

test("Members & Users: summary cards use compact 2-column layout on mobile/tablet", async () => {
  const enhancements = await source("app/enhancements.css");

  // Summary cards stay 2-column on mobile and tablet without stacking into 1 column
  assert.match(enhancements, /\.members-stat-grid\s*\{[^}]*grid-template-columns:\s*repeat\(2,\s*minmax\(0,\s*1fr\)\)/);
  assert.doesNotMatch(enhancements, /@media\(max-width:\s*760px\)\s*\{[^}]*\.members-stat-grid\s*\{[^}]*grid-template-columns:\s*1fr/);
});

test("Admin Responsive Modes: Consistent drawer on Mobile & ALL iPads (Mini, Air, Pro 11, Pro 13), permanent sidebar on Desktop/Laptop", async () => {
  const enhancements = await source("app/enhancements.css");

  // Verify the exact tablet media query is declared in CSS
  assert.match(
    enhancements,
    /@media\s*\(\s*max-width:\s*1200px\s*\)\s*,\s*\(\s*max-width:\s*1366px\s*\)\s*and\s*\(\s*max-aspect-ratio:\s*145\/100\s*\)\s*,\s*\(\s*max-width:\s*1366px\s*\)\s*and\s*\(\s*min-height:\s*950px\s*\)/
  );

  const viewports = [
    // Mobile Viewports (Drawer)
    { name: "Mobile 320x568", w: 320, h: 568, expected: "drawer" },
    { name: "Mobile 375x812", w: 375, h: 812, expected: "drawer" },
    { name: "Mobile 390x844", w: 390, h: 844, expected: "drawer" },
    { name: "Mobile 414x896", w: 414, h: 896, expected: "drawer" },

    // iPad / Tablet Portrait Viewports (Drawer)
    { name: "iPad Mini Portrait 768x1024", w: 768, h: 1024, expected: "drawer" },
    { name: "iPad Air Portrait 820x1180", w: 820, h: 1180, expected: "drawer" },
    { name: "iPad Pro 11 Portrait 834x1194", w: 834, h: 1194, expected: "drawer" },
    { name: "iPad Pro 13 Portrait 1024x1366", w: 1024, h: 1366, expected: "drawer" },

    // iPad / Tablet Landscape Viewports (Drawer)
    { name: "iPad Mini Landscape 1024x768", w: 1024, h: 768, expected: "drawer" },
    { name: "iPad Air Landscape 1180x820", w: 1180, h: 820, expected: "drawer" },
    { name: "iPad Pro 11 Landscape 1194x834", w: 1194, h: 834, expected: "drawer" },
    { name: "iPad Pro 13 Landscape 1366x1024", w: 1366, h: 1024, expected: "drawer" },

    // Desktop / Laptop Viewports (Permanent sidebar)
    { name: "Desktop/Laptop 1280x720", w: 1280, h: 720, expected: "desktop" },
    { name: "Desktop/Laptop 1366x768", w: 1366, h: 768, expected: "desktop" },
    { name: "Desktop/Laptop 1440x900", w: 1440, h: 900, expected: "desktop" },
    { name: "Desktop/Laptop 1920x1080", w: 1920, h: 1080, expected: "desktop" },
  ];

  function evaluateMode(w, h, touch = false) {
    const isTabletOrMobile =
      w <= 1200 ||
      (w <= 1366 && w / h <= 1.45) ||
      (w <= 1366 && h >= 950) ||
      (touch && w <= 1400 && w / h <= 1.65);
    return isTabletOrMobile ? "drawer" : "desktop";
  }

  for (const vp of viewports) {
    const mode = evaluateMode(vp.w, vp.h);
    assert.equal(
      mode,
      vp.expected,
      `${vp.name} (${vp.w}x${vp.h}) should resolve to ${vp.expected} mode, got ${mode}`
    );
  }
});
