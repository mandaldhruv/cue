import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs/promises";
import path from "node:path";

async function source(relPath) {
  return fs.readFile(path.join(process.cwd(), relPath), "utf8");
}

test("Admin Dashboard Redesign: Top Greeting Hero with dynamic greeting, removed extra desc, and visible books visual", async () => {
  const [dashboardPage, enhancements] = await Promise.all([
    source("app/admin/page.tsx"),
    source("app/enhancements.css"),
  ]);

  // Preserves dynamic greeting system
  assert.match(dashboardPage, /<AdminGreeting fallback="Your publishing dashboard" \/>/);
  assert.match(dashboardPage, /Cue Admin Workspace/);
  assert.match(dashboardPage, /<StudyBooksVisual/);

  // Stacked academic books vector illustration in Cue palette
  assert.match(dashboardPage, /admin-hero-illustration/);
  assert.match(dashboardPage, /#2563eb/); // Cue blue book
  assert.match(dashboardPage, /#1e293b/); // Navy book
  assert.match(dashboardPage, /#f59e0b/); // Amber book

  // Hero banner CSS: rounded container, soft horizontal gradient, generous padding
  assert.match(enhancements, /\.admin-greeting-hero\s*\{[^}]*border-radius:\s*20px/);
  assert.match(enhancements, /\.admin-greeting-hero\s*\{[^}]*background:\s*linear-gradient/);
  assert.match(enhancements, /\.admin-greeting-tag\s*\{[^}]*border-radius:\s*9999px/);

  // Extra hero description completely removed
  assert.doesNotMatch(dashboardPage, /Monitor academic curriculum, track published resources/);

  // Illustration is never hidden on mobile/tablet
  assert.doesNotMatch(enhancements, /\.admin-greeting-hero-visual\s*\{[^}]*display:\s*none/);
});

test("Admin Dashboard Redesign: Consistent invisible grid alignment across all major sections", async () => {
  const [dashboardPage, enhancements] = await Promise.all([
    source("app/admin/page.tsx"),
    source("app/enhancements.css"),
  ]);

  // All major sections are inside admin-dashboard-flow
  assert.match(dashboardPage, /<div className="admin-dashboard-flow">/);
  assert.match(dashboardPage, /admin-greeting-hero/);
  assert.match(dashboardPage, /admin-stat-grid actionable/);
  assert.match(dashboardPage, /admin-dashboard-grid practical/);
  assert.match(dashboardPage, /recent-admin-activity/);

  // CSS enforces unified 100% width and margin resets so boundaries strictly align
  assert.match(
    enhancements,
    /\.admin-greeting-hero,\s*\.admin-stat-grid,\s*\.admin-dashboard-grid\.practical,\s*\.recent-admin-activity\s*\{[^}]*width:\s*100%\s*!important/
  );
});

test("Admin Dashboard Redesign: 5 Statistics cards with minimal icons, restrained colors and subtle backgrounds", async () => {
  const [dashboardPage, enhancements] = await Promise.all([
    source("app/admin/page.tsx"),
    source("app/enhancements.css"),
  ]);

  // Exactly 5 stat cards with icons and labels
  assert.match(dashboardPage, /stat-card-subjects[\s\S]*PUBLISHED SUBJECTS/);
  assert.match(dashboardPage, /stat-card-content[\s\S]*LIVE MATERIAL/);
  assert.match(dashboardPage, /stat-card-feedback[\s\S]*NEW FEEDBACK/);
  assert.match(dashboardPage, /stat-card-members[\s\S]*TOTAL MEMBERS/);
  assert.match(dashboardPage, /stat-card-semesters[\s\S]*AVAILABLE SEMESTERS/);

  // Restrained accent colors for icons
  assert.match(enhancements, /\.admin-stat-icon-wrap\.icon-blue\s*\{[^}]*background:\s*#eff6ff/);
  assert.match(enhancements, /\.admin-stat-icon-wrap\.icon-green\s*\{[^}]*background:\s*#ecfdf5/);
  assert.match(enhancements, /\.admin-stat-icon-wrap\.icon-purple\s*\{[^}]*background:\s*#f5f3ff/);
  assert.match(enhancements, /\.admin-stat-icon-wrap\.icon-amber\s*\{[^}]*background:\s*#fffbeb/);
  assert.match(enhancements, /\.admin-stat-icon-wrap\.icon-rose\s*\{[^}]*background:\s*#fff1f2/);

  // Subtle individual card backgrounds
  assert.match(enhancements, /\.stat-card-subjects\s*\{[^}]*background:\s*linear-gradient/);
  assert.match(enhancements, /\.stat-card-content\s*\{[^}]*background:\s*linear-gradient/);
  assert.match(enhancements, /\.stat-card-feedback\s*\{[^}]*background:\s*linear-gradient/);
  assert.match(enhancements, /\.stat-card-members\s*\{[^}]*background:\s*linear-gradient/);
  assert.match(enhancements, /\.stat-card-semesters\s*\{[^}]*background:\s*linear-gradient/);
});

test("Admin Dashboard Redesign: Quick Access clean title, removed numbers/arrows, and 5 essential actions", async () => {
  const [dashboardPage, enhancements] = await Promise.all([
    source("app/admin/page.tsx"),
    source("app/enhancements.css"),
  ]);

  // Section has clean Quick Access title without QUICK ACTIONS eyebrow
  assert.match(dashboardPage, /<h2>Quick Access<\/h2>/);
  assert.doesNotMatch(dashboardPage, /QUICK ACTIONS/);
  assert.doesNotMatch(dashboardPage, /What do you want to update\?/);

  // Removed numbers (01-05) and arrow indicators in rendered cards
  assert.doesNotMatch(dashboardPage, /admin-quick-num/);
  assert.doesNotMatch(dashboardPage, /admin-quick-arrow/);

  // Contains all 5 essential actions
  assert.match(dashboardPage, /\["01",\s*"Syllabus"/);
  assert.match(dashboardPage, /\["02",\s*"PYQs & PDFs"/);
  assert.match(dashboardPage, /\["03",\s*"Flashcards"/);
  assert.match(dashboardPage, /\["04",\s*"Feedback & Testimonials"/);
  assert.match(dashboardPage, /\["05",\s*"Members & Users"/);
});

test("Admin Dashboard Redesign: Content Overview panel replaces Published but Incomplete with real metrics", async () => {
  const [dashboardPage, enhancements] = await Promise.all([
    source("app/admin/page.tsx"),
    source("app/enhancements.css"),
  ]);

  // Completely removed "Published but incomplete" and "NEEDS ATTENTION"
  assert.doesNotMatch(dashboardPage, /Published but incomplete/);
  assert.doesNotMatch(dashboardPage, /NEEDS ATTENTION/);

  // Renders Content Overview panel with real data
  assert.match(dashboardPage, /<h2>Content Overview<\/h2>/);
  assert.match(dashboardPage, /content-overview-panel/);
  assert.match(dashboardPage, /admin-overview-card/);
  assert.match(dashboardPage, /admin-overview-badge/);

  // Balanced 2-column layout in desktop CSS
  assert.match(enhancements, /\.admin-dashboard-grid\.practical\s*\{[^}]*grid-template-columns:\s*1fr\s*1fr\s*!important/);
});

test("Admin Dashboard Redesign: Latest Changes activity grid with contextual icons and IST timestamps", async () => {
  const [dashboardPage, enhancements] = await Promise.all([
    source("app/admin/page.tsx"),
    source("app/enhancements.css"),
  ]);

  // Header and elements
  assert.match(dashboardPage, /<h2>Latest Changes<\/h2>/);
  assert.match(dashboardPage, /admin-activity-grid/);
  assert.match(dashboardPage, /admin-activity-card/);
  assert.match(dashboardPage, /admin-activity-icon-wrap/);
  assert.match(dashboardPage, /activity-context/);
  assert.match(dashboardPage, /activity-time/);

  // Contextual icon mapper
  assert.match(dashboardPage, /function ActivityIcon/);
  assert.match(dashboardPage, /function activityColorClass/);

  // IST timestamp format
  assert.match(dashboardPage, /timeZone: "Asia\/Kolkata"/);

  // 4-column desktop grid
  assert.match(enhancements, /\.admin-activity-grid\s*\{[^}]*grid-template-columns:\s*repeat\(4,\s*minmax\(0,\s*1fr\)\)\s*!important/);
});
