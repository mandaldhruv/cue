import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs/promises";
import { isAuthorizedAdminEmail, AUTHORIZED_ADMIN_EMAILS } from "../app/lib/admin-auth.ts";

async function source(path) {
  return fs.readFile(new URL(`../${path}`, import.meta.url), "utf8");
}

test("Test 1-5: authorized admin emails are strictly enforced", () => {
  // Exactly the two authorized admin emails
  assert.deepEqual([...AUTHORIZED_ADMIN_EMAILS].sort(), [
    "harshita301doc@gmail.com",
    "hersita04@gmail.com",
  ]);

  // Test 4: hersita04@gmail.com authenticated
  assert.equal(isAuthorizedAdminEmail("hersita04@gmail.com"), true);
  assert.equal(isAuthorizedAdminEmail("HERSITA04@GMAIL.COM"), true);
  assert.equal(isAuthorizedAdminEmail(" hersita04@gmail.com "), true);

  // Test 5: harshita301doc@gmail.com authenticated
  assert.equal(isAuthorizedAdminEmail("harshita301doc@gmail.com"), true);
  assert.equal(isAuthorizedAdminEmail("HARSHITA301DOC@GMAIL.COM"), true);
  assert.equal(isAuthorizedAdminEmail(" harshita301doc@gmail.com "), true);

  // Test 2 & 3: Student account / random email / other emails denied
  assert.equal(isAuthorizedAdminEmail("student@gmail.com"), false);
  assert.equal(isAuthorizedAdminEmail("random@gmail.com"), false);
  assert.equal(isAuthorizedAdminEmail("test@gmail.com"), false);
  assert.equal(isAuthorizedAdminEmail("harsyng14@gmail.com"), false);
  assert.equal(isAuthorizedAdminEmail("mandal.dhruv@dypic.in"), false);
  assert.equal(isAuthorizedAdminEmail("admin@cue.study"), false);
  assert.equal(isAuthorizedAdminEmail(""), false);
  assert.equal(isAuthorizedAdminEmail(null), false);
  assert.equal(isAuthorizedAdminEmail(undefined), false);
});

test("Test 1 & 7: all admin pages enforce requireAdminSession with server-side redirect", async () => {
  const adminPages = [
    "app/admin/page.tsx",
    "app/admin/syllabus/page.tsx",
    "app/admin/members/page.tsx",
    "app/admin/flashcards/page.tsx",
    "app/admin/feedback/page.tsx",
    "app/admin/semesters/page.tsx",
    "app/admin/subjects/page.tsx",
    "app/admin/pyqs/page.tsx",
    "app/admin/content/page.tsx",
  ];

  for (const pagePath of adminPages) {
    const content = await source(pagePath);
    assert.match(
      content,
      /requireAdminSession\(\)/,
      `Admin page ${pagePath} must call requireAdminSession() before rendering or fetching data`
    );
  }
});

test("Test 2 & UX: admin login page presents access-denied state to authenticated students", async () => {
  const [loginPage, loginForm] = await Promise.all([
    source("app/admin/login/page.tsx"),
    source("app/admin/login/AdminLoginForm.tsx"),
  ]);

  // Page passes whether an unauthorized student is logged in
  assert.match(loginPage, /isUnauthorizedStudent=\{Boolean\(user && !isAdmin\)\}/);

  // Login form displays Admin access required message
  assert.match(loginForm, /Admin access required/);
  assert.match(loginForm, /The current session does not have administrator privileges/);

  // Form enforces password authentication and doesn't reveal dashboard content
  assert.doesNotMatch(loginPage, /admin-stat-grid|admin-sidebar|admin-workspace/);
  assert.doesNotMatch(loginForm, /admin-stat-grid|admin-sidebar|admin-workspace/);
});

test("Test 6: server actions and API routes reject unauthorized users", async () => {
  const [actions, contentActions, feedbackActions, greetingsRoute, serverLib] = await Promise.all([
    source("app/admin/actions.ts"),
    source("app/admin/content-actions.ts"),
    source("app/admin/feedback/actions.ts"),
    source("app/api/greetings/route.ts"),
    source("app/lib/insforge/server.ts"),
  ]);

  // adminAuthAction checks isAuthorizedAdminEmail before and after sign-in
  assert.match(actions, /isAuthorizedAdminEmail\(email\)/);
  assert.match(actions, /isAuthorizedAdminEmail\(authenticatedEmail\)/);

  // content actions check session with getAdminSession
  assert.match(contentActions, /const session = await getAdminSession\(\)/);
  assert.match(contentActions, /if \(!session\.user \|\| !session\.isAdmin\) return null/);

  // feedback actions check session with getAdminSession
  assert.match(feedbackActions, /const session = await getAdminSession\(\)/);
  assert.match(feedbackActions, /return session\.user && session\.isAdmin \? session : null/);

  // greetings route forbids non-admin users from admin audience
  assert.match(greetingsRoute, /if \(audience === "admin"\)/);
  assert.match(greetingsRoute, /isAuthorizedAdminEmail\(email\)/);
  assert.match(greetingsRoute, /status: 403/);

  // getAdminSession verifies isAuthorizedAdminEmail before calling DB RPC
  assert.match(serverLib, /if \(!isAuthorizedAdminEmail\(email\)\)/);
  assert.match(serverLib, /return \{ user, isAdmin: false, client \}/);
});

test("Database migration strictly protects is_cue_admin and get_cue_members", async () => {
  const migration = await source("migrations/20260925054234_secure-admin-authorization.sql");

  // Does not use current_user = 'project_admin'
  assert.doesNotMatch(migration, /current_user\s*=\s*'project_admin'/);

  // Checks both authorized emails explicitly
  assert.match(migration, /'hersita04@gmail\.com'/);
  assert.match(migration, /'harshita301doc@gmail\.com'/);

  // Validates auth.uid()
  assert.match(migration, /v_uid := auth\.uid\(\)/);
  assert.match(migration, /IF v_uid IS NULL THEN\s*RETURN false;/);

  // get_cue_members raises exception when not admin
  assert.match(migration, /IF NOT public\.is_cue_admin\(\) THEN\s*RAISE EXCEPTION 'Admin authorization required';/);
});

test("Test 8: Student portal authentication and features remain completely unaffected", async () => {
  const [studentActions, feedbackSubmit] = await Promise.all([
    source("app/login/actions.ts"),
    source("app/feedback/actions.ts"),
  ]);

  // Normal student auth actions exist without requiring admin rights
  assert.match(studentActions, /export async function signInAction/);
  assert.match(studentActions, /export async function signUpAction/);
  assert.match(studentActions, /export async function verifyEmailAction/);
  assert.match(studentActions, /export async function googleSignInAction/);

  // Student feedback submission works without admin rights
  assert.match(feedbackSubmit, /export async function submitFeedback/);
  assert.doesNotMatch(feedbackSubmit, /is_cue_admin/);
});
