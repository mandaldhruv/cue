import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";

const root = new URL("../", import.meta.url);
const source = (path) => readFile(new URL(path, root), "utf8");

test("ships Cue metadata and the intended public routes", async () => {
  const [layout, home, subjects, flashcards, pyqs, feedback] = await Promise.all([
    source("app/layout.tsx"),
    source("app/page.tsx"),
    source("app/subjects/page.tsx"),
    source("app/flashcards/page.tsx"),
    source("app/pyqs/page.tsx"),
    source("app/feedback/page.tsx"),
  ]);

  assert.match(layout, /Cue — Study smarter\. Stress less\./);
  assert.match(layout, /cue-favicon-original\.png/);
  assert.match(home, /BMS STUDENTS/);
  assert.doesNotMatch(home, />Explore subjects</i);
  assert.doesNotMatch(home, /home-action-hub/);
  assert.match(home, /hero-study-tabs/);
  assert.match(home, /<b>Flashcards<\/b>/);
  assert.ok(home.indexOf('className="how-cue-works"') > home.indexOf('className="focus-section"'));
  assert.match(subjects, /SubjectsExplorer/);
  assert.match(flashcards, /getPublishedContent\(undefined, "flashcard"\)/);
  assert.match(pyqs, /PyqLibrary/);
  assert.match(feedback, /FeedbackForm/);
  assert.match(feedback, /TestimonialsSection/);
});

test("keeps admin access private and checks database membership", async () => {
  const [loginPage, loginForm, actions, server, config] = await Promise.all([
    source("app/admin/login/page.tsx"),
    source("app/admin/login/AdminLoginForm.tsx"),
    source("app/admin/actions.ts"),
    source("app/lib/insforge/server.ts"),
    source("insforge.toml"),
  ]);

  assert.match(loginPage, /AdminLoginForm/);
  assert.match(loginForm, /authorized Cue administrator account/);
  assert.doesNotMatch(`${loginPage}\n${loginForm}`, /first[- ]time setup|sign up/i);
  assert.match(actions, /signInWithPassword/);
  assert.match(server, /rpc\("is_cue_admin"\)/);
  assert.match(config, /disable_signup\s*=\s*true/);
});

test("protects admin writes and prevents duplicate PYQ submissions", async () => {
  const [contentActions, pyqManager, migration] = await Promise.all([
    source("app/admin/content-actions.ts"),
    source("app/admin/pyqs/PyqManager.tsx"),
    source("migrations/20260830170457_improve-admin-feedback-and-pyq-integrity.sql"),
  ]);

  assert.match(contentActions, /session\.user\s*\|\|\s*!session\.isAdmin/);
  assert.match(pyqManager, /submittingRef\.current/);
  assert.match(pyqManager, /submission_id/);
  assert.match(migration, /content_items_pyq_submission_unique/);
  assert.match(migration, /WHERE content_type = 'pyq'/);
});

test("keeps feedback private while publishing only approved testimonials", async () => {
  const [feedbackAction, testimonialAction, imageRoute, migration] = await Promise.all([
    source("app/feedback/actions.ts"),
    source("app/admin/feedback/actions.ts"),
    source("app/api/testimonial-image/[id]/route.ts"),
    source("migrations/20260830170457_improve-admin-feedback-and-pyq-integrity.sql"),
  ]);

  assert.match(feedbackAction, /feedback_submissions/);
  assert.match(testimonialAction, /consentConfirmed/);
  assert.match(imageRoute, /eq\("is_published", true\)/);
  assert.match(migration, /students can submit private feedback/);
  assert.match(migration, /admins can read feedback/);
  assert.match(migration, /published testimonials are publicly readable/);
  assert.match(migration, /NOT is_published OR consent_confirmed/);
});
