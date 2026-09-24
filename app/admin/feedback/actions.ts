"use server";

import { revalidatePath } from "next/cache";
import { getAdminSession } from "../../lib/insforge/server";
import type { AdminActionResult, FeedbackStatus } from "../types";

const text = (formData: FormData, key: string) => String(formData.get(key) ?? "").trim();

async function adminContext() {
  const session = await getAdminSession();
  return session.user && session.isAdmin ? session : null;
}

async function recordActivity(client: NonNullable<Awaited<ReturnType<typeof adminContext>>>["client"], adminUserId: string, action: string, entityType: string, entityId: string | null, summary: string) {
  const { error } = await client.database.from("admin_activity").insert([{
    admin_user_id: adminUserId,
    action,
    entity_type: entityType,
    entity_id: entityId,
    summary,
  }]);
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
  await recordActivity(session.client, session.user.id, "status", "feedback", id, `Feedback marked ${status}`);
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
  await recordActivity(session.client, session.user.id, id ? "update" : "create", "testimonial", entityId, `${personName} · ${isPublished ? "published" : "draft"}`);
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
  await recordActivity(session.client, session.user.id, "delete", "testimonial", id, testimonial?.[0]?.person_name ?? "Deleted testimonial");
  revalidatePath("/admin");
  revalidatePath("/admin/feedback");
  revalidatePath("/feedback");
  return { ok: true, message: "Testimonial deleted." };
}

export async function toggleFeedbackPublication(id: string, publish: boolean): Promise<AdminActionResult> {
  const session = await adminContext();
  if (!session) return { ok: false, message: "Your admin session has expired." };
  if (!id) return { ok: false, message: "Choose a valid feedback submission." };

  const { data: feedbackItem, error: fetchErr } = await session.client.database
    .from("feedback_submissions")
    .select("id,rating,category,message,email,user_name,role,student_year")
    .eq("id", id)
    .maybeSingle();

  if (fetchErr || !feedbackItem) {
    return { ok: false, message: "Feedback submission could not be found." };
  }

  const name = (feedbackItem.user_name || "").trim() || (feedbackItem.email ? feedbackItem.email.split("@")[0] : "Cue Student");
  const role = (feedbackItem.role || feedbackItem.student_year || "Student").trim();

  if (publish) {
    const { data: existingTestimonial } = await session.client.database
      .from("testimonials")
      .select("id")
      .eq("feedback_id", id)
      .maybeSingle();

    if (existingTestimonial) {
      const { error: updateError } = await session.client.database
        .from("testimonials")
        .update({
          person_name: name,
          designation: role,
          quote: feedbackItem.message,
          image_alt: `Portrait of ${name}`,
          rating: feedbackItem.rating,
          is_published: true,
          consent_confirmed: true,
          consent_note: "Published via Admin Feedback Management",
        })
        .eq("id", existingTestimonial.id);

      if (updateError) {
        return { ok: false, message: updateError.message ?? "Could not publish testimonial." };
      }
    } else {
      const { count } = await session.client.database
        .from("testimonials")
        .select("*", { count: "exact", head: true });

      const { error: insertError } = await session.client.database.from("testimonials").insert([{
        feedback_id: id,
        person_name: name,
        designation: role,
        institution: "",
        quote: feedbackItem.message,
        image_alt: `Portrait of ${name}`,
        rating: feedbackItem.rating,
        is_featured: false,
        is_published: true,
        consent_confirmed: true,
        consent_note: "Published via Admin Feedback Management",
        sort_order: (count || 0) + 1,
      }]);

      if (insertError) {
        return { ok: false, message: insertError.message ?? "Could not publish testimonial." };
      }
    }

    await session.client.database
      .from("feedback_submissions")
      .update({ is_published: true, status: "reviewed" })
      .eq("id", id);

    await recordActivity(session.client, session.user.id, "visibility", "feedback", id, `Published ${name}’s feedback as testimonial`);
  } else {
    await session.client.database
      .from("feedback_submissions")
      .update({ is_published: false })
      .eq("id", id);

    await session.client.database
      .from("testimonials")
      .update({ is_published: false })
      .eq("feedback_id", id);

    await recordActivity(session.client, session.user.id, "visibility", "feedback", id, `Removed ${name}’s testimonial from public`);
  }

  revalidatePath("/admin");
  revalidatePath("/admin/feedback");
  revalidatePath("/feedback");
  return { ok: true, message: publish ? "Feedback published as testimonial." : "Testimonial removed from public." };
}
