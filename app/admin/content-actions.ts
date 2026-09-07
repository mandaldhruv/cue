"use server";

import { revalidatePath } from "next/cache";
import { getAdminSession } from "../lib/insforge/server";
import type { AdminActionResult, EditableContentType, SemesterStatus } from "./types";

function textValue(formData: FormData, key: string) { return String(formData.get(key) ?? "").trim(); }
function numberValue(formData: FormData, key: string) { return Number(formData.get(key) ?? 0); }
function fail(message: string): AdminActionResult { return { ok: false, message }; }

async function context() {
  const session = await getAdminSession();
  if (!session.user || !session.isAdmin) return null;
  return session;
}

async function logAction(client: Awaited<ReturnType<typeof getAdminSession>>["client"], action: string, entityType: string, entityId: string | null, summary: string) {
  await client.database.from("admin_activity").insert([{ action, entity_type: entityType, entity_id: entityId, summary }]);
}

function refreshContent() {
  revalidatePath("/admin");
  revalidatePath("/admin/semesters");
  revalidatePath("/admin/subjects");
  revalidatePath("/subjects");
  revalidatePath("/flashcards");
  revalidatePath("/");
}

export async function saveSemester(formData: FormData): Promise<AdminActionResult> {
  const session = await context();
  if (!session) return fail("Your admin session has expired. Please sign in again.");
  const id = textValue(formData, "id");
  const semesterNumber = numberValue(formData, "semester_number");
  const title = textValue(formData, "title");
  const status = textValue(formData, "status") as SemesterStatus;
  const sortOrder = numberValue(formData, "sort_order");
  if (!Number.isInteger(semesterNumber) || semesterNumber < 1 || semesterNumber > 8) return fail("Semester number must be between 1 and 8.");
  if (!title) return fail("Add a semester title.");
  if (!["draft", "coming_soon", "published", "archived"].includes(status)) return fail("Choose a valid status.");
  const payload = { course_code: "BMS", semester_number: semesterNumber, title, status, sort_order: sortOrder };
  const query = id
    ? session.client.database.from("semesters").update(payload).eq("id", id).select("id")
    : session.client.database.from("semesters").insert([payload]).select("id");
  const { data, error } = await query;
  if (error) return fail(error.message?.includes("unique") ? "That semester already exists." : error.message ?? "Could not save the semester.");
  const entityId = id || data?.[0]?.id || null;
  await logAction(session.client, id ? "update" : "create", "semester", entityId, `${title} · ${status}`);
  refreshContent();
  return { ok: true, message: id ? "Semester updated." : "Semester created." };
}

export async function setSemesterStatus(id: string, status: SemesterStatus): Promise<AdminActionResult> {
  const session = await context();
  if (!session) return fail("Your admin session has expired.");
  const { error } = await session.client.database.from("semesters").update({ status }).eq("id", id);
  if (error) return fail(error.message ?? "Could not change semester status.");
  await logAction(session.client, "status", "semester", id, `Status changed to ${status}`);
  refreshContent();
  return { ok: true, message: `Semester is now ${status.replace("_", " ")}.` };
}

export async function moveSemester(id: string, direction: "up" | "down"): Promise<AdminActionResult> {
  const session = await context();
  if (!session) return fail("Your admin session has expired.");
  const { data, error } = await session.client.database.from("semesters").select("id,sort_order").eq("course_code", "BMS").order("sort_order", { ascending: true });
  if (error || !data) return fail(error?.message ?? "Could not load semester order.");
  const index = data.findIndex((item: { id: string }) => item.id === id);
  const other = data[index + (direction === "up" ? -1 : 1)];
  if (index < 0 || !other) return { ok: true, message: "Semester is already at the edge." };
  const current = data[index];
  const first = await session.client.database.from("semesters").update({ sort_order: other.sort_order }).eq("id", current.id);
  const second = await session.client.database.from("semesters").update({ sort_order: current.sort_order }).eq("id", other.id);
  if (first.error || second.error) return fail(first.error?.message ?? second.error?.message ?? "Could not reorder semesters.");
  await logAction(session.client, "reorder", "semester", id, `Moved ${direction}`);
  refreshContent();
  return { ok: true, message: "Semester order updated." };
}

export async function deleteSemester(id: string, semesterNumber: number): Promise<AdminActionResult> {
  const session = await context();
  if (!session) return fail("Your admin session has expired.");
  const { data: subjects, error: countError } = await session.client.database.from("subjects").select("id").eq("course_code", "BMS").eq("semester_number", semesterNumber).limit(1);
  if (countError) return fail(countError.message ?? "Could not check semester usage.");
  if (subjects?.length) return fail("Move or delete this semester’s subjects first.");
  const { error } = await session.client.database.from("semesters").delete().eq("id", id);
  if (error) return fail(error.message ?? "Could not delete the semester.");
  await logAction(session.client, "delete", "semester", id, `Deleted Semester ${semesterNumber}`);
  refreshContent();
  return { ok: true, message: "Semester deleted." };
}

export async function saveSubject(formData: FormData): Promise<AdminActionResult> {
  const session = await context();
  if (!session) return fail("Your admin session has expired. Please sign in again.");
  const id = textValue(formData, "id");
  const name = textValue(formData, "name");
  const slug = textValue(formData, "slug").toLowerCase().replace(/[^a-z0-9-]/g, "-").replace(/-+/g, "-").replace(/^-|-$/g, "");
  const shortCode = textValue(formData, "short_code").toUpperCase();
  const semesterNumber = numberValue(formData, "semester_number");
  if (!name || !slug || !shortCode) return fail("Name, slug and short code are required.");
  if (!Number.isInteger(semesterNumber) || semesterNumber < 1 || semesterNumber > 8) return fail("Choose a valid semester.");
  const payload = {
    name, slug, short_code: shortCode, course_code: "BMS", semester_number: semesterNumber,
    description: textValue(formData, "description"), accent_color: textValue(formData, "accent_color") || "#315DE6",
    sort_order: numberValue(formData, "sort_order"), is_published: formData.get("is_published") === "true",
  };
  const query = id
    ? session.client.database.from("subjects").update(payload).eq("id", id).select("id")
    : session.client.database.from("subjects").insert([payload]).select("id");
  const { data, error } = await query;
  if (error) return fail(error.message?.includes("unique") ? "This slug is already used in that semester." : error.message ?? "Could not save the subject.");
  const entityId = id || data?.[0]?.id || null;
  await logAction(session.client, id ? "update" : "create", "subject", entityId, `${name} · Semester ${semesterNumber}`);
  refreshContent();
  return { ok: true, message: id ? "Subject updated." : "Subject created." };
}

export async function setSubjectPublished(id: string, isPublished: boolean): Promise<AdminActionResult> {
  const session = await context();
  if (!session) return fail("Your admin session has expired.");
  const { error } = await session.client.database.from("subjects").update({ is_published: isPublished }).eq("id", id);
  if (error) return fail(error.message ?? "Could not change subject visibility.");
  await logAction(session.client, "visibility", "subject", id, isPublished ? "Published" : "Moved to draft");
  refreshContent();
  return { ok: true, message: isPublished ? "Subject published." : "Subject moved to draft." };
}

export async function moveSubject(id: string, semesterNumber: number, direction: "up" | "down"): Promise<AdminActionResult> {
  const session = await context();
  if (!session) return fail("Your admin session has expired.");
  const { data, error } = await session.client.database.from("subjects").select("id,sort_order").eq("course_code", "BMS").eq("semester_number", semesterNumber).order("sort_order", { ascending: true });
  if (error || !data) return fail(error?.message ?? "Could not load subject order.");
  const index = data.findIndex((item: { id: string }) => item.id === id);
  const other = data[index + (direction === "up" ? -1 : 1)];
  if (index < 0 || !other) return { ok: true, message: "Subject is already at the edge." };
  const current = data[index];
  const first = await session.client.database.from("subjects").update({ sort_order: other.sort_order }).eq("id", current.id);
  const second = await session.client.database.from("subjects").update({ sort_order: current.sort_order }).eq("id", other.id);
  if (first.error || second.error) return fail(first.error?.message ?? second.error?.message ?? "Could not reorder subjects.");
  await logAction(session.client, "reorder", "subject", id, `Moved ${direction}`);
  refreshContent();
  return { ok: true, message: "Subject order updated." };
}

export async function deleteSubject(id: string): Promise<AdminActionResult> {
  const session = await context();
  if (!session) return fail("Your admin session has expired.");
  const { data: content, error: countError } = await session.client.database.from("content_items").select("id").eq("subject_id", id).limit(1);
  if (countError) return fail(countError.message ?? "Could not check subject content.");
  if (content?.length) return fail("Remove this subject’s study content first. Nothing was deleted.");
  const { error } = await session.client.database.from("subjects").delete().eq("id", id);
  if (error) return fail(error.message ?? "Could not delete the subject.");
  await logAction(session.client, "delete", "subject", id, "Deleted empty subject");
  refreshContent();
  return { ok: true, message: "Subject deleted." };
}

const editableContentTypes = ["syllabus_unit", "note", "important_topic", "recommended_resource", "flashcard"];

export async function saveContentItem(formData: FormData): Promise<AdminActionResult> {
  const session = await context();
  if (!session) return fail("Your admin session has expired. Please sign in again.");
  const id = textValue(formData, "id");
  const subjectId = textValue(formData, "subject_id");
  const contentType = textValue(formData, "content_type") as EditableContentType;
  const title = textValue(formData, "title");
  if (!subjectId || !title) return fail("Subject and title are required.");
  if (!editableContentTypes.includes(contentType)) return fail("Choose a valid content type.");
  const payload = {
    subject_id: subjectId,
    content_type: contentType,
    title,
    description: textValue(formData, "description"),
    body: textValue(formData, "body"),
    file_url: textValue(formData, "file_url") || null,
    file_key: null,
    sort_order: Math.max(0, numberValue(formData, "sort_order")),
    is_published: formData.get("is_published") === "true",
  };
  const query = id
    ? session.client.database.from("content_items").update(payload).eq("id", id).select("id")
    : session.client.database.from("content_items").insert([payload]).select("id");
  const { data, error } = await query;
  if (error) return fail(error.message ?? "Could not save this content item.");
  const entityId = id || data?.[0]?.id || null;
  await logAction(session.client, id ? "update" : "create", "content_item", entityId, `${contentType}: ${title}`);
  refreshContent();
  revalidatePath("/admin/content");
  revalidatePath("/admin/flashcards");
  return { ok: true, message: id ? "Content updated." : "Content created." };
}

export async function setContentPublished(id: string, isPublished: boolean): Promise<AdminActionResult> {
  const session = await context();
  if (!session) return fail("Your admin session has expired.");
  const { error } = await session.client.database.from("content_items").update({ is_published: isPublished }).eq("id", id);
  if (error) return fail(error.message ?? "Could not change content visibility.");
  await logAction(session.client, "visibility", "content_item", id, isPublished ? "Published" : "Moved to draft");
  refreshContent();
  revalidatePath("/admin/content");
  revalidatePath("/admin/flashcards");
  return { ok: true, message: isPublished ? "Content published." : "Content moved to draft." };
}

export async function moveContentItem(id: string, subjectId: string, contentType: EditableContentType, direction: "up" | "down"): Promise<AdminActionResult> {
  const session = await context();
  if (!session) return fail("Your admin session has expired.");
  const { data, error } = await session.client.database.from("content_items").select("id,sort_order").eq("subject_id", subjectId).eq("content_type", contentType).order("sort_order", { ascending: true });
  if (error || !data) return fail(error?.message ?? "Could not load content order.");
  const index = data.findIndex((item: { id: string }) => item.id === id);
  const other = data[index + (direction === "up" ? -1 : 1)];
  if (index < 0 || !other) return { ok: true, message: "Item is already at the edge." };
  const current = data[index];
  const first = await session.client.database.from("content_items").update({ sort_order: other.sort_order }).eq("id", current.id);
  const second = await session.client.database.from("content_items").update({ sort_order: current.sort_order }).eq("id", other.id);
  if (first.error || second.error) return fail(first.error?.message ?? second.error?.message ?? "Could not reorder content.");
  await logAction(session.client, "reorder", "content_item", id, `Moved ${direction}`);
  refreshContent();
  revalidatePath("/admin/content");
  revalidatePath("/admin/flashcards");
  return { ok: true, message: "Content order updated." };
}

export async function deleteContentItem(id: string): Promise<AdminActionResult> {
  const session = await context();
  if (!session) return fail("Your admin session has expired.");
  const { error } = await session.client.database.from("content_items").delete().eq("id", id);
  if (error) return fail(error.message ?? "Could not delete this content item.");
  await logAction(session.client, "delete", "content_item", id, "Deleted content item");
  refreshContent();
  revalidatePath("/admin/content");
  revalidatePath("/admin/flashcards");
  return { ok: true, message: "Content item deleted." };
}

export async function savePyq(formData: FormData): Promise<AdminActionResult> {
  const session = await context();
  if (!session) return fail("Your admin session has expired. Please sign in again.");
  const id = textValue(formData, "id");
  const subjectId = textValue(formData, "subject_id");
  const title = textValue(formData, "title");
  const year = numberValue(formData, "academic_year");
  const fileUrl = textValue(formData, "file_url");
  const fileKey = textValue(formData, "file_key");
  const oldFileKey = textValue(formData, "old_file_key");
  const submissionId = textValue(formData, "submission_id");
  if (!subjectId || !title || !fileUrl || !fileKey) return fail("Subject, title and PDF file are required.");
  if (!id && !submissionId) return fail("This upload could not be verified. Reopen the form and try again.");
  if (!Number.isInteger(year) || year < 2000 || year > 2100) return fail("Enter a valid academic year.");
  const payload = {
    subject_id: subjectId,
    content_type: "pyq",
    title,
    description: textValue(formData, "description"),
    body: "",
    academic_year: year,
    exam_type: textValue(formData, "exam_type") || "University Exam",
    file_url: fileUrl,
    file_key: fileKey,
    file_name: textValue(formData, "file_name") || null,
    file_size_bytes: Math.max(0, numberValue(formData, "file_size_bytes")) || null,
    sort_order: Math.max(0, numberValue(formData, "sort_order")),
    is_published: formData.get("is_published") === "true",
    ...(!id ? { submission_id: submissionId } : {}),
  };
  const query = id
    ? session.client.database.from("content_items").update(payload).eq("id", id).select("id")
    : session.client.database.from("content_items").insert([payload]).select("id");
  const { data, error } = await query;
  if (error) {
    if (!id && error.message?.toLowerCase().includes("unique")) return { ok: true, message: "This paper was already uploaded. No duplicate was created." };
    return fail(error.message ?? "Could not save the paper.");
  }
  if (oldFileKey && oldFileKey !== fileKey) await session.client.storage.from("cue-pyqs").remove(oldFileKey);
  const entityId = id || data?.[0]?.id || null;
  await logAction(session.client, id ? "update" : "create", "pyq", entityId, `${title} · ${year}`);
  refreshContent();
  revalidatePath("/admin/pyqs");
  revalidatePath("/pyqs");
  return { ok: true, message: id ? "Paper updated." : "Paper uploaded." };
}

export async function setPyqPublished(id: string, isPublished: boolean): Promise<AdminActionResult> {
  const session = await context();
  if (!session) return fail("Your admin session has expired.");
  const { error } = await session.client.database.from("content_items").update({ is_published: isPublished }).eq("id", id).eq("content_type", "pyq");
  if (error) return fail(error.message ?? "Could not change paper visibility.");
  await logAction(session.client, "visibility", "pyq", id, isPublished ? "Published" : "Moved to draft");
  revalidatePath("/admin/pyqs");
  revalidatePath("/pyqs");
  return { ok: true, message: isPublished ? "Paper published." : "Paper moved to draft." };
}

export async function deletePyq(id: string, fileKey: string): Promise<AdminActionResult> {
  const session = await context();
  if (!session) return fail("Your admin session has expired.");
  const { error } = await session.client.database.from("content_items").delete().eq("id", id).eq("content_type", "pyq");
  if (error) return fail(error.message ?? "Could not delete this paper.");
  if (fileKey) await session.client.storage.from("cue-pyqs").remove(fileKey);
  await logAction(session.client, "delete", "pyq", id, "Deleted paper and stored PDF");
  refreshContent();
  revalidatePath("/admin/pyqs");
  revalidatePath("/pyqs");
  return { ok: true, message: "Paper and PDF deleted." };
}
