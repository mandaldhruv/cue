"use server";

import { createInsForgeServerClient } from "../lib/insforge/server";

export type FeedbackSubmitResult = { ok: boolean; message: string };

const categories = ["Overall experience", "Study content", "Design & usability", "Feature request", "Something else"];
const years = ["First year", "Second year", "Third year", "Other"];

export async function submitFeedback(formData: FormData): Promise<FeedbackSubmitResult> {
  const rating = Number(formData.get("rating"));
  const category = String(formData.get("category") ?? "").trim();
  const message = String(formData.get("message") ?? "").trim();
  const studentYear = String(formData.get("student_year") ?? "").trim();
  const email = String(formData.get("email") ?? "").trim().toLowerCase();
  const submissionId = String(formData.get("submission_id") ?? "").trim();
  if (!submissionId || !Number.isInteger(rating) || rating < 1 || rating > 5) return { ok: false, message: "Choose a valid rating and try again." };
  if (!categories.includes(category) || !years.includes(studentYear)) return { ok: false, message: "Complete the feedback topic and study year." };
  if (message.length < 10 || message.length > 1000) return { ok: false, message: "Write between 10 and 1,000 characters." };
  if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) return { ok: false, message: "Enter a valid email address or leave it blank." };

  const client = await createInsForgeServerClient();
  const { error } = await client.database.from("feedback_submissions").insert([{
    submission_id: submissionId,
    rating,
    category,
    message,
    student_year: studentYear,
    email: email || null,
    is_content_issue: formData.get("is_content_issue") === "on",
  }]);
  if (error) {
    if (error.message?.toLowerCase().includes("unique")) return { ok: true, message: "Your feedback was already received." };
    return { ok: false, message: error.message ?? "Feedback could not be sent right now." };
  }
  return { ok: true, message: "Feedback received." };
}
