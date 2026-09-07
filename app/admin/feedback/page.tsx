import { redirect } from "next/navigation";
import { getAdminSession } from "../../lib/insforge/server";
import AdminShell from "../AdminShell";
import type { FeedbackRecord, TestimonialRecord } from "../types";
import FeedbackManager from "./FeedbackManager";

export const dynamic = "force-dynamic";

export default async function AdminFeedbackPage() {
  const { user, isAdmin, client } = await getAdminSession();
  if (!user || !isAdmin) redirect("/admin/login");
  const [{ data: feedback, error: feedbackError }, { data: testimonials, error: testimonialError }] = await Promise.all([
    client.database.from("feedback_submissions").select("id,rating,category,message,student_year,email,is_content_issue,status,admin_note,created_at").order("created_at", { ascending: false }),
    client.database.from("testimonials").select("id,person_name,designation,institution,quote,headshot_url,headshot_key,image_alt,rating,is_featured,is_published,consent_confirmed,consent_note,sort_order,created_at").order("is_featured", { ascending: false }).order("sort_order", { ascending: true }),
  ]);
  const error = feedbackError ?? testimonialError;
  return <AdminShell active="/admin/feedback" email={user.email ?? "Admin"} eyebrow="COMMUNITY" title="Feedback & testimonials">
    {error ? <div className="admin-notice error">{error.message ?? "Community content could not be loaded."}</div> : <FeedbackManager feedback={(feedback ?? []) as FeedbackRecord[]} testimonials={(testimonials ?? []) as TestimonialRecord[]}/>} 
  </AdminShell>;
}
