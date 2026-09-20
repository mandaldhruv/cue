"use server";

import { revalidatePath } from "next/cache";
import { getAdminSession } from "../../lib/insforge/server";
import type { AdminActionResult, FeedbackStatus } from "../types";

const text = (formData: FormData, key: string) => String(formData.get(key) ?? "").trim();

async function adminContext() {
  const session = await getAdminSession();
  return session.user && session.isAdmin ? session : null;
}

async function recordActivity(client: NonNullable<Awaited<ReturnType<typeof adminContext>>>["client"], action: string, entityType: string, entityId: string | null, summary: string) {
  const { error } = await client.database.from("admin_activity").insert([{ action, entity_type: entityType, entity_id: entityId, summary }]);
  if (error) console.error("Could not record admin activity", { action, entityType, entityId, message: error.message });
}

export async function updateFeedback(formData: FormData): Promise<AdminActionResult> {
  const session = await adminContext();
  if (!session) return { ok: false, message: "Your admin session has expired." };
  const id = text(formData, "id");
  const status = text(formData, "status") as FeedbackStatus;
  if (!id || !["new", "reviewed", "resolved", "archived"].includes(status)) return { ok: false, message: "Choose a valid feedback status." };
  const { error } = await session.client.database.from("feedback_submissions").update({ status, admin_note: text(formData, "admin_note") }).eq("id", id);
  if (error) return { ok: false, message: error.message ?? "Feedback could not be updated." };
  await recordActivity(session.client, "status", "feedback", id, `Feedback marked ${status}`);
  revalidatePath("/admin");
  revalidatePath("/admin/feedback");
  return { ok: true, message: "Feedback updated." };
}

export async function saveTestimonial(formData: FormData): Promise<AdminActionResult> {
  const session = await adminContext();
  if (!session) return { ok: false, message: "Your admin session has expired." };
  const id = text(formData, "id");
  const personName = text(formData, "person_name");
  const designation = text(formData, "designation");
  const quote = text(formData, "quote");
  const isPublished = formData.get("is_published") === "true";
  const consentConfirmed = formData.get("consent_confirmed") === "on";
  if (!personName || !designation || quote.length < 20) return { ok: false, message: "Add the person, designation and a complete testimonial." };
  if (isPublished && !consentConfirmed) return { ok: false, message: "Confirm permission before publishing this testimonial." };
  const payload = {
    person_name: personName,
    designation,
    institution: text(formData, "institution"),
    quote,
    headshot_url: text(formData, "headshot_url") || null,
    headshot_key: text(formData, "headshot_key") || null,
    image_alt: text(formData, "image_alt"),
    rating: Math.min(5, Math.max(1, Number(formData.get("rating") ?? 5))),
    is_featured: formData.get("is_featured") === "on",
    is_published: isPublished,
    consent_confirmed: consentConfirmed,
    consent_note: text(formData, "consent_note"),
    sort_order: Math.max(0, Number(formData.get("sort_order") ?? 0)),
  };
  const query = id ? session.client.database.from("testimonials").update(payload).eq("id", id).select("id") : session.client.database.from("testimonials").insert([payload]).select("id");
  const { data, error } = await query;
  if (error) return { ok: false, message: error.message ?? "Testimonial could not be saved." };
  const entityId = id || data?.[0]?.id || null;
  const oldHeadshotKey = text(formData, "old_headshot_key");
  if (oldHeadshotKey && oldHeadshotKey !== payload.headshot_key) await session.client.storage.from("cue-testimonials").remove(oldHeadshotKey);
  await recordActivity(session.client, id ? "update" : "create", "testimonial", entityId, `${personName} · ${isPublished ? "published" : "draft"}`);
  revalidatePath("/admin");
  revalidatePath("/admin/feedback");
  revalidatePath("/feedback");
  return { ok: true, message: id ? "Testimonial updated." : "Testimonial created." };
}

export async function deleteTestimonial(id: string, headshotKey: string): Promise<AdminActionResult> {
  const session = await adminContext();
  if (!session) return { ok: false, message: "Your admin session has expired." };
  const { data: testimonial } = await session.client.database.from("testimonials").select("person_name").eq("id", id).limit(1);
  const { error } = await session.client.database.from("testimonials").delete().eq("id", id);
  if (error) return { ok: false, message: error.message ?? "Testimonial could not be deleted." };
  if (headshotKey) await session.client.storage.from("cue-testimonials").remove(headshotKey);
  await recordActivity(session.client, "delete", "testimonial", id, testimonial?.[0]?.person_name ?? "Deleted testimonial");
  revalidatePath("/admin");
  revalidatePath("/admin/feedback");
  revalidatePath("/feedback");
  return { ok: true, message: "Testimonial deleted." };
}
