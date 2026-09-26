import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";

const root = new URL("../", import.meta.url);
const source = (path) => readFile(new URL(path, root), "utf8");

test("ships Cue metadata and the intended public routes", async () => {
  const [layout, adminLayout, home, subjects, flashcards, pyqs, feedback] = await Promise.all([
    source("app/layout.tsx"),
    source("app/admin/layout.tsx"),
    source("app/page.tsx"),
    source("app/subjects/page.tsx"),
    source("app/flashcards/page.tsx"),
    source("app/pyqs/page.tsx"),
    source("app/feedback/page.tsx"),
  ]);

  assert.match(layout, /Cue \| Study smarter\. Stress less\./);
  assert.match(adminLayout, /title: "Cue Admin"/);
  assert.match(layout, /Favicon\.png/);
  assert.match(home, /BMS STUDENTS/);
  assert.doesNotMatch(home, />Explore subjects</i);
  assert.doesNotMatch(home, /home-action-hub/);
  assert.match(home, /hero-study-tabs/);
  assert.match(home, /<b>Flashcards<\/b>/);
  assert.doesNotMatch(home, /className="how-cue-works"/);
  assert.match(subjects, /SubjectsExplorer/);
  assert.match(flashcards, /getPublishedContent\(undefined, "flashcard"\)/);
  assert.match(pyqs, /PyqLibrary/);
  assert.match(feedback, /FeedbackForm/);
  assert.match(feedback, /TestimonialsSection/);
});

test("ships structured, admin-owned flashcards without seeded examples", async () => {
  const [manager, actions, deck, migration, cascadeMigration] = await Promise.all([
    source("app/admin/flashcards/FlashcardManager.tsx"),
    source("app/admin/content-actions.ts"),
    source("app/flashcards/FlashcardDeck.tsx"),
    source("migrations/20260908174946_build-flashcard-learning-system.sql"),
    source("migrations/20260920175005_cascade-flashcard-deletions.sql"),
  ]);

  assert.match(manager, /saveFlashcardUnit/);
  assert.match(manager, /RichContentEditor/);
  assert.match(deck, /View solution/);
  assert.match(migration, /CREATE TABLE public\.flashcard_units/);
  assert.match(migration, /CREATE TABLE public\.flashcard_topics/);
  assert.doesNotMatch(migration, /INSERT INTO public\.(flashcard_units|flashcard_topics|content_items)/);
  assert.doesNotMatch(actions, /Move or delete this (unit|topic)/);
  assert.match(actions, /\.delete\(\)\.eq\("id", id\)\.select\("id"\)/);
  assert.match(manager, /unitDeleteMessage/);
  assert.match(manager, /topicDeleteMessage/);
  assert.match(cascadeMigration, /content_items_flashcard_unit_subject_fkey[\s\S]*ON DELETE CASCADE/);
  assert.match(cascadeMigration, /content_items_flashcard_topic_scope_fkey[\s\S]*ON DELETE CASCADE/);
});

test("keeps admin access private, checks membership and renders fresh IST activity", async () => {
  const [loginPage, loginForm, actions, server, dashboard, dashboardRefresh, config] = await Promise.all([
    source("app/admin/login/page.tsx"),
    source("app/admin/login/AdminLoginForm.tsx"),
    source("app/admin/actions.ts"),
    source("app/lib/insforge/server.ts"),
    source("app/admin/page.tsx"),
    source("app/admin/AdminDashboardRefresh.tsx"),
    source("insforge.toml"),
  ]);

  assert.match(loginPage, /AdminLoginForm/);
  assert.match(loginForm, /authorized Cue administrator account/);
  assert.doesNotMatch(`${loginPage}\n${loginForm}`, /first[- ]time setup|sign up/i);
  assert.match(actions, /signInWithPassword/);
  assert.match(server, /rpc\("is_cue_admin"\)/);
  assert.match(dashboard, /timeZone: "Asia\/Kolkata"/);
  assert.match(dashboard, /select\("id,action,summary,entity_type,created_at"\)/);
  assert.match(dashboardRefresh, /30_000/);
  assert.match(dashboardRefresh, /visibilitychange/);
  assert.match(config, /disable_signup\s*=\s*false/);
});

test("supports public browsing with persistent student sessions and modal login gates", async () => {
  const [login, actions, navigation, pyqs, flashcards, authProvider, sessionRoute, config] = await Promise.all([
    source("app/login/LoginPanel.tsx"),
    source("app/login/actions.ts"),
    source("app/components.tsx"),
    source("app/pyqs/PyqLibrary.tsx"),
    source("app/flashcards/FlashcardDeck.tsx"),
    source("app/auth/AuthProvider.tsx"),
    source("app/api/auth/session/route.ts"),
    source("insforge.toml"),
  ]);

  assert.match(login, /Continue with Google/);
  assert.match(login, /Create account/);
  assert.match(actions, /signInWithPassword/);
  assert.match(actions, /verifyEmail/);
  assert.match(navigation, /Sign in \/ Sign up/);
  assert.match(pyqs, /await requireLogin\(\)/);
  assert.match(flashcards, /await requireLogin\(\)/);
  assert.match(authProvider, /cue-auth-modal-backdrop/);
  assert.match(authProvider, /fetch\("\/api\/auth\/session"/);
  assert.doesNotMatch(authProvider, /createBrowserClient/);
  assert.match(sessionRoute, /getCurrentUser\(\)/);
  assert.match(sessionRoute, /no-store/);
  assert.match(config, /cue-study\.insforge\.site\/api\/auth\/callback/);
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
  assert.match(pyqManager, /formData\.delete\("pdf"\)/);
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

test("enforces exactly 3 study features (Syllabus, PYQs, Flashcards) for students and admin", async () => {
  const [adminShell, adminPage, syllabusPage, syllabusManager, subjectWorkspace, publicContent, home] = await Promise.all([
    source("app/admin/AdminShell.tsx"),
    source("app/admin/page.tsx"),
    source("app/admin/syllabus/page.tsx"),
    source("app/admin/syllabus/SyllabusManager.tsx"),
    source("app/subjects/[slug]/SubjectWorkspace.tsx"),
    source("app/lib/public-content.ts"),
    source("app/page.tsx"),
  ]);

  // Admin sidebar matches exact required items and labels
  assert.match(adminShell, /\["\/admin\/syllabus",\s*"SY",\s*"Syllabus"\]/);
  assert.doesNotMatch(adminShell, /Study Content/);

  // Admin Syllabus management page exists and manages syllabus units
  assert.match(syllabusPage, /SyllabusManager/);
  assert.match(syllabusManager, /Syllabus Units/);
  assert.match(syllabusManager, /syllabus_unit/);
  assert.doesNotMatch(syllabusManager, /Notes|Exam Focus|recommended_resource/);

  // Admin Dashboard references Syllabus
  assert.match(adminPage, /\["01",\s*"Syllabus"/);
  assert.doesNotMatch(adminPage, /Study content/);

  // Student Workspace has strictly Syllabus, PYQs, Flashcards
  assert.match(subjectWorkspace, /label:\s*"Syllabus"/);
  assert.match(subjectWorkspace, /label:\s*"PYQs"/);
  assert.match(subjectWorkspace, /label:\s*"Flashcards"/);
  assert.match(subjectWorkspace, /href=\{`\/flashcards\/\$\{subject\.slug\}`\}/);
  assert.doesNotMatch(subjectWorkspace, /FlashcardPlayer/);
  assert.doesNotMatch(subjectWorkspace, /"note"|"recommended_resource"|exam-focus/);

  // Public content type excludes obsolete types
  assert.match(publicContent, /content_type: "syllabus_unit" \| "flashcard" \| "pyq"/);
  assert.doesNotMatch(publicContent, /"note"|"important_topic"|"recommended_resource"/);

  // Home page does not render obsolete exam-focus section
  assert.doesNotMatch(home, /focus-section|important_topic/);
});

test("subject workspace redirects flashcards tab directly to main flashcard deck", async () => {
  const [subjectWorkspace, subjectPage] = await Promise.all([
    source("app/subjects/[slug]/SubjectWorkspace.tsx"),
    source("app/subjects/[slug]/page.tsx"),
  ]);

  // Flashcards option is preserved as a link to the main flashcard section
  assert.match(subjectWorkspace, /href=\{`\/flashcards\/\$\{subject\.slug\}`\}/);
  assert.match(subjectWorkspace, /label:\s*"Flashcards"/);

  // Subject page no longer embeds old FlashcardPlayer
  assert.doesNotMatch(subjectWorkspace, /FlashcardPlayer/);

  // Direct tab navigation query redirects to /flashcards/[slug]
  assert.match(subjectPage, /redirect\(`\/flashcards\/\$\{slug\}`\)/);
});

test("About page applies cohesive, premium green theme", async () => {
  const [aboutPage, enhancements] = await Promise.all([
    source("app/about/page.tsx"),
    source("app/enhancements.css"),
  ]);

  assert.match(aboutPage, /className="about-intro"/);
  assert.match(enhancements, /\.about-intro\s*\{[\s\S]*background:\s*linear-gradient\(145deg,\s*#f7fbf9,\s*#edf5f1\)/);
  assert.match(enhancements, /\.about-intro \.eyebrow\s*\{[\s\S]*color:\s*#1e594d/);
  assert.match(enhancements, /\.about-page \.mission-card h2 em\s*\{[\s\S]*color:\s*#1e594d/);
});

test("PYQ paper title typography uses clean, readable medium weight without heavy bold", async () => {
  const [globals, enhancements, pyqLibrary] = await Promise.all([
    source("app/globals.css"),
    source("app/enhancements.css"),
    source("app/pyqs/PyqLibrary.tsx"),
  ]);

  // Paper card markup includes the exam type tag, h3 title, and preview/download actions
  assert.match(pyqLibrary, /className="public-paper-copy"/);
  assert.match(pyqLibrary, /<h3>\{paper\.title\}<\/h3>/);
  assert.match(pyqLibrary, /<span>\{paper\.exam_type\}<\/span>/);

  // Paper titles use clean medium weight (600) instead of heavy bold (750)
  assert.match(globals, /\.public-paper-copy h3\{font-size:16px;font-weight:600/);
  assert.doesNotMatch(globals, /\.public-paper-copy h3\{font-size:16px;font-weight:750/);
  assert.match(enhancements, /\.public-paper-copy h3\s*\{[\s\S]*font-weight:\s*600\s*!important/);

  // Mobile media query preserves clean 600 weight
  assert.match(globals, /\.public-paper-copy h3\{font-size:15px;font-weight:600\}/);
  assert.match(enhancements, /@media\s*\(max-width:\s*650px\)\s*\{[\s\S]*\.public-paper-copy h3\s*\{[\s\S]*font-weight:\s*600\s*!important/);

  // Preview modal header title also uses consistent 600 weight
  assert.match(globals, /\.pdf-preview-modal header b\{font-size:15px;font-weight:600/);
  assert.match(enhancements, /\.pdf-preview-modal header b\s*\{[\s\S]*font-weight:\s*600\s*!important/);
});

test("Subjects and Flashcards typography uses clean, normalized medium/normal weight without heavy bold", async () => {
  const [globals, enhancements] = await Promise.all([
    source("app/globals.css"),
    source("app/enhancements.css"),
  ]);

  // Subject card headings use clean medium/normal weight (500)
  assert.match(globals, /\.subject-card h3\{font-size:18px;letter-spacing:-.03em;margin-bottom:9px;font-weight:500\}/);
  assert.doesNotMatch(globals, /\.subject-card h3\{font-size:18px;letter-spacing:-.03em;margin-bottom:9px;font-weight:750\}/);
  assert.match(enhancements, /\.subjects-explorer \.subject-card h3\s*\{[^}]*font-weight:\s*500/);
  assert.doesNotMatch(enhancements, /\.subjects-explorer \.subject-card h3\s*\{[^}]*font-weight:\s*750/);

  // Deck titles and metadata use clean 500 weight instead of heavy 750
  assert.match(globals, /\.real-deck-grid h2\{margin:50px 0 9px;font-size:22px;line-height:1.2;font-weight:500\}/);
  assert.doesNotMatch(globals, /\.real-deck-grid h2\{margin:50px 0 9px;font-size:22px;line-height:1.2;font-weight:750\}/);
  assert.match(enhancements, /\.real-deck-grid h2\s*\{[^}]*font-weight:\s*500/);
  assert.doesNotMatch(enhancements, /\.real-deck-grid h2\s*\{[^}]*font-weight:\s*750/);

  // Flashcard unit navigation and question list items use clean 500 weight
  assert.match(enhancements, /\.flashcard-unit-nav nav b\s*\{[^}]*font-weight:\s*500/);
  assert.match(enhancements, /\.flashcard-question-list>button b\s*\{[^}]*font-weight:\s*500/);
  assert.match(enhancements, /\.flashcard-topic-tabs button\s*\{[^}]*font-weight:\s*500/);

  // Responsive mobile media queries maintain clean 500 weight
  assert.match(enhancements, /@media\s*\(max-width:\s*760px\)\s*\{[\s\S]*\.subjects-explorer \.subject-card h3\s*\{[^}]*font-weight:\s*500/);
  assert.match(enhancements, /@media\s*\(max-width:\s*768px\)\s*\{[\s\S]*\.subjects-explorer \.subject-card h3,\s*[\s\S]*\.real-deck-grid h2,\s*[\s\S]*font-weight:\s*500\s*!important/);
});

test("Flashcards login gating and mobile scrolling integrity", async () => {
  const [flashcardDeck, page, authProvider, globals, enhancements] = await Promise.all([
    source("app/flashcards/FlashcardDeck.tsx"),
    source("app/flashcards/[slug]/page.tsx"),
    source("app/auth/AuthProvider.tsx"),
    source("app/globals.css"),
    source("app/enhancements.css"),
  ]);

  // View Solution checks login before entering Flashcard Mode
  assert.match(flashcardDeck, /handleQuestionClick/);
  assert.match(flashcardDeck, /await requireLogin\(/);
  assert.match(flashcardDeck, /search\.set\("open",\s*"1"\)/);

  // Search parameters forwarded from page to FlashcardDeck
  assert.match(page, /searchParams\?: Promise<\{/);
  assert.match(page, /initialUnitId=\{resolvedSearchParams\.unit\}/);
  assert.match(page, /initialTopicId=\{resolvedSearchParams\.topic\}/);
  assert.match(page, /initialCardId=\{resolvedSearchParams\.card\}/);
  assert.match(page, /initialAutoOpen=\{resolvedSearchParams\.open === "1"\}/);

  // Return path customization supported in AuthProvider
  assert.match(authProvider, /customReturnPath\?: string/);
  assert.match(authProvider, /setReturnPath\(customReturnPath \|\|/);

  // Login modal z-index guarantees overlay above fullscreen flashcard mode
  assert.match(globals, /\.cue-auth-modal-backdrop\{[^}]*z-index:\s*1000000/);
  assert.match(globals, /\.cue-auth-modal-dialog\{[^}]*z-index:\s*1000001/);

  // Mobile / tablet scrolling enabled without height or overflow locks
  assert.match(enhancements, /@media\(max-width:1024px\)\{[\s\S]*\.deck-player-section\{[^}]*overflow:visible!important/);
  assert.match(enhancements, /@media\(max-width:900px\)\{[\s\S]*\.deck-player-section\{[^}]*overflow:visible!important/);
  assert.match(enhancements, /\.flashcard-mobile-step-topics\{[^}]*overflow:visible!important/);
  assert.match(enhancements, /\.flashcard-mobile-step-cards\{[^}]*overflow:visible!important/);
});



