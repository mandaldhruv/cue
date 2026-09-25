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

test("Admin Dashboard: compact 2-column grid on mobile/tablet with balanced fifth card", async () => {
  const [page, enhancements] = await Promise.all([
    source("app/admin/page.tsx"),
    source("app/enhancements.css"),
  ]);

  // Page renders exactly 5 summary cards
  assert.match(page, /PUBLISHED SUBJECTS/);
  assert.match(page, /LIVE MATERIAL/);
  assert.match(page, /NEW FEEDBACK/);
  assert.match(page, /TOTAL MEMBERS/);
  assert.match(page, /AVAILABLE SEMESTERS/);

  // Tablet & Mobile CSS enforces 2-column grid and balanced 5th card
  assert.match(enhancements, /\.admin-stat-grid\s*\{[^}]*grid-template-columns:\s*repeat\(2,\s*minmax\(0,\s*1fr\)\)/);
  assert.match(enhancements, /\.admin-stat-grid article:nth-child\(5\)\s*\{[^}]*grid-column:\s*1\s*\/\s*-1/);

  // Mobile never stacks all 5 cards into 1 column
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
