import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs/promises";
import path from "node:path";

async function source(relPath) {
  return fs.readFile(path.join(process.cwd(), relPath), "utf8");
}

test("Admin Feedback Redesign: Page header starts directly with title without COMMUNITY eyebrow", async () => {
  const page = await source("app/admin/feedback/page.tsx");
  assert.doesNotMatch(page, /eyebrow="COMMUNITY"/);
  assert.match(page, /title="Feedback & testimonials"/);
});

test("Admin Feedback Redesign: Top statistics cards follow left-icon / right-content horizontal layout", async () => {
  const [manager, css] = await Promise.all([
    source("app/admin/feedback/FeedbackManager.tsx"),
    source("app/enhancements.css"),
  ]);

  // 1. Stat grid container
  assert.match(manager, /className="feedback-stat-grid"/);

  // 2. 3 Stat cards with icons and labels
  assert.match(manager, /feedback-stat-icon-wrap icon-blue[\s\S]*NEW FEEDBACK/);
  assert.match(manager, /feedback-stat-icon-wrap icon-amber[\s\S]*AVERAGE RATING/);
  assert.match(manager, /feedback-stat-icon-wrap icon-green[\s\S]*LIVE TESTIMONIALS/);

  // 3. Compact "+ Add testimonial" CTA card in the stat row
  assert.match(manager, /className="feedback-cta-card"/);
  assert.match(manager, /\+ Add testimonial/);
  assert.match(manager, /Create curated quote/);

  // 4. CSS horizontal alignment and 4-column layout
  assert.match(css, /\.feedback-stat-grid\s*\{[^}]*grid-template-columns:\s*repeat\(4,\s*minmax\(0,\s*1fr\)\)/);
  assert.match(css, /\.feedback-stat-card\s*\{[^}]*flex-direction:\s*row/);
  assert.match(css, /\.feedback-stat-icon-wrap\.icon-blue/);
  assert.match(css, /\.feedback-stat-icon-wrap\.icon-amber/);
  assert.match(css, /\.feedback-stat-icon-wrap\.icon-green/);
  assert.match(css, /\.feedback-cta-card/);
});

test("Admin Feedback Redesign: Segmented navigation control with clean count indicators", async () => {
  const [manager, css] = await Promise.all([
    source("app/admin/feedback/FeedbackManager.tsx"),
    source("app/enhancements.css"),
  ]);

  // 1. Segmented tabs in JSX
  assert.match(manager, /className="feedback-segmented-tabs"/);
  assert.match(manager, /User Feedback[\s\S]*feedback-tab-count/);
  assert.match(manager, /Public Testimonials[\s\S]*feedback-tab-count/);

  // 2. CSS segmented tabs styling
  assert.match(css, /\.feedback-segmented-tabs\s*\{/);
  assert.match(css, /\.feedback-tab-btn\.active/);
  assert.match(css, /\.feedback-tab-count/);
});

test("Admin Feedback Redesign: Management header with responsive filters", async () => {
  const [manager, css] = await Promise.all([
    source("app/admin/feedback/FeedbackManager.tsx"),
    source("app/enhancements.css"),
  ]);

  // 1. Header with title & subtitle
  assert.match(manager, /User Feedback Management/);
  assert.match(manager, /Review feedback from authenticated students/);

  // 2. Filters
  assert.match(manager, /className="feedback-management-filters"/);
  assert.match(manager, /VISIBILITY/);
  assert.match(manager, /STATUS/);

  // 3. CSS management header styling
  assert.match(css, /\.feedback-management-section/);
  assert.match(css, /\.feedback-management-header/);
  assert.match(css, /\.feedback-management-filters select/);
});

test("Admin Feedback Redesign: Feedback item cards with clear hierarchy, quote block, and actions", async () => {
  const [manager, css] = await Promise.all([
    source("app/admin/feedback/FeedbackManager.tsx"),
    source("app/enhancements.css"),
  ]);

  // 1. Structure in JSX
  assert.match(manager, /feedback-item-card/);
  assert.match(manager, /feedback-item-avatar/);
  assert.match(manager, /feedback-item-name/);
  assert.match(manager, /feedback-item-email/);
  assert.match(manager, /feedback-role-pill/);
  assert.match(manager, /feedback-pub-pill/);
  assert.match(manager, /feedback-status-pill/);
  assert.match(manager, /feedback-item-rating/);
  assert.match(manager, /feedback-item-quote/);
  assert.match(manager, /feedback-item-date/);

  // 2. Preserved actions: Publish, Review, Delete
  assert.match(manager, /className="btn-publish"/);
  assert.match(manager, /className="btn-review"/);
  assert.match(manager, /className="btn-delete"/);

  // 3. CSS styling
  assert.match(css, /\.feedback-item-card\s*\{/);
  assert.match(css, /\.feedback-item-card\.is-public\s*\{[^}]*border-left:/);
  assert.match(css, /\.feedback-item-quote\s*\{[^}]*border-left:/);
});

test("Admin Feedback Redesign: Responsive rules for tablet/iPad and mobile viewports", async () => {
  const css = await source("app/enhancements.css");

  // 1. Tablet/iPad (<= 1180px or <= 768px): 2-column stat grid
  assert.match(css, /@media\s*\(max-width:\s*1180px\)[\s\S]*?\.feedback-stat-grid\s*\{[^}]*grid-template-columns:\s*repeat\(2/);

  // 2. Mobile (<= 480px): 1-column stat grid and full-width segmented tabs
  assert.match(css, /@media\s*\(max-width:\s*480px\)[\s\S]*?\.feedback-stat-grid\s*\{[^}]*grid-template-columns:\s*1fr/);
  assert.match(css, /@media\s*\(max-width:\s*480px\)[\s\S]*?\.feedback-segmented-tabs\s*\{[^}]*width:\s*100%/);
});
