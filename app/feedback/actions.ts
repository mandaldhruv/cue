"use server";

import { createInsForgeServerClient } from "../lib/insforge/server";
import { notifyAdminFeedback } from "../lib/email/admin-notifications";

export type FeedbackSubmitResult = { ok: boolean; message: string };

const allowedRoles = ["Professor / Educator", "Student", "Professor / Teacher"];

export async function submitFeedback(formData: FormData): Promise<FeedbackSubmitResult> {
  const rating = Number(formData.get("rating"));
  const role = String(formData.get("role") ?? "Student").trim();
  const message = String(formData.get("message") ?? "").trim();
  const submissionId = String(formData.get("submission_id") ?? "").trim();

  if (!submissionId || !Number.isInteger(rating) || rating < 1 || rating > 5) {
    return { ok: false, message: "Choose a valid rating and try again." };
  }
  if (!allowedRoles.includes(role)) {
    return { ok: false, message: "Please select whether you are submitting as a Professor / Educator or Student." };
  }
  if (message.length < 10 || message.length > 1000) {
    return { ok: false, message: "Write between 10 and 1,000 characters." };
  }

  const client = await createInsForgeServerClient();
  const { data: authData, error: authError } = await client.auth.getCurrentUser();
  const user = authError ? null : authData?.user ?? null;

  if (!user) {
    return { ok: false, message: "Please sign in to your Cue account to submit feedback." };
  }

  const userEmail = (user.email || "").trim().toLowerCase();
  const userName = (user.profile?.name || "").trim() || userEmail.split("@")[0] || "Cue Member";

  const { error } = await client.database.from("feedback_submissions").insert([{
    submission_id: submissionId,
    rating,
    category: "Overall experience",
    message,
    student_year: role,
    email: userEmail || null,
    user_id: user.id,
    user_name: userName,
    role: role,
    is_content_issue: formData.get("is_content_issue") === "on",
    status: "new",
    admin_note: "",
    is_published: false,
  }]);

  if (error) {
    if (error.message?.toLowerCase().includes("unique")) {
      return { ok: true, message: "Your feedback was already received." };
    }
    return { ok: false, message: error.message ?? "Feedback could not be sent right now." };
  }

  // Trigger admin email notification safely (never blocking/breaking user flow)
  void notifyAdminFeedback({
    submissionId,
    name: userName,
    email: userEmail,
    role,
    rating,
    message,
    isContentIssue: formData.get("is_content_issue") === "on",
    contentReference: "Cue BMS Study Resources",
    submittedAt: new Date(),
  });

  return { ok: true, message: "Feedback received." };
}
