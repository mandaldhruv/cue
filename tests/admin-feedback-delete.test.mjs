import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs/promises";
import path from "node:path";

async function source(relPath) {
  return fs.readFile(path.join(process.cwd(), relPath), "utf8");
}

test("Admin Feedback: Page header starts directly with title without COMMUNITY eyebrow", async () => {
  const page = await source("app/admin/feedback/page.tsx");
  assert.doesNotMatch(page, /eyebrow="COMMUNITY"/);
  assert.match(page, /title="Feedback & testimonials"/);
});

test("Admin Feedback: Delete action is present on feedback cards and in review drawer", async () => {
  const manager = await source("app/admin/feedback/FeedbackManager.tsx");

  // 1. Delete button exists in feedback action group alongside Publish and Review
  assert.match(manager, /className="btn-delete"/);
  assert.match(manager, /Delete/);
  assert.match(manager, /setConfirmDeleteItem\(item\)/);

  // 2. Both existing actions preserved
  assert.match(manager, /className="btn-publish"/);
  assert.match(manager, /className="btn-review"/);
});

test("Admin Feedback: Confirmation modal is required and permanent deletion occurs only after confirmation", async () => {
  const manager = await source("app/admin/feedback/FeedbackManager.tsx");

  // 1. Modal dialog rendered conditionally on confirmDeleteItem
  assert.match(manager, /confirmDeleteItem && \(/);
  assert.match(manager, /Delete feedback\?/);
  assert.match(manager, /Are you sure you want to permanently delete this feedback/);
  assert.match(manager, /This action cannot be undone\./);

  // 2. Cancel and Delete buttons in modal
  assert.match(manager, /className="admin-confirm-btn-cancel"/);
  assert.match(manager, /className="admin-confirm-btn-delete"/);
  assert.match(manager, /onClick=\{handleConfirmDelete\}/);

  // 3. Duplicate prevention and disabled state during deletion
  assert.match(manager, /disabled=\{deleting\}/);
  assert.match(manager, /Feedback deleted successfully\./);
});

test("Admin Feedback: Secure server-side delete operation verifies admin session and cleans up records", async () => {
  const actions = await source("app/admin/feedback/actions.ts");

  // 1. Exported deleteFeedback action
  assert.match(actions, /export async function deleteFeedback\(id: string\)/);

  // 2. Requires admin authorization
  assert.match(actions, /const session = await adminContext\(\)/);
  assert.match(actions, /Your admin session has expired\./);

  // 3. Cascades/cleans up associated testimonials if any
  assert.match(actions, /\.from\("testimonials"\)\.delete\(\)\.eq\("id", t\.id\)/);

  // 4. Performs permanent database delete
  assert.match(actions, /\.from\("feedback_submissions"\)[\s\S]*\.delete\(\)[\s\S]*\.eq\("id", id\)/);

  // 5. Records admin activity and revalidates paths
  assert.match(actions, /recordActivity\([\s\S]*"delete",\s*"feedback"/);
  assert.match(actions, /revalidatePath\("\/admin\/feedback"\)/);
});

test("Admin Feedback: Styling includes subtle destructive action and responsive button wrapping", async () => {
  const css = await source("app/enhancements.css");

  // 1. Subtle, non-overpowering delete button styling
  assert.match(css, /\.btn-delete\s*\{/);
  assert.match(css, /\.btn-delete:hover:not\(:disabled\)/);

  // 2. Destructive confirmation modal button and icon
  assert.match(css, /\.admin-confirm-icon-wrap\.delete-icon/);
  assert.match(css, /\.admin-confirm-btn-delete/);

  // 3. Responsive flex-wrap for action buttons
  assert.match(css, /\.feedback-actions-group\s*\{[^}]*flex-wrap:\s*wrap/);
});
