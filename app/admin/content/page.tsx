import { redirect } from "next/navigation";
import { getAdminSession } from "../../lib/insforge/server";
import AdminShell from "../AdminShell";
import type { ContentRecord, SubjectRecord } from "../types";
import ContentManager from "./ContentManager";

export const dynamic = "force-dynamic";

export default async function AdminContentPage() {
  const { user, isAdmin, client } = await getAdminSession();
  if (!user || !isAdmin) redirect("/admin/login");
  const [{ data: subjects, error: subjectError }, { data: content, error: contentError }] = await Promise.all([
    client.database.from("subjects").select("id,name,slug,short_code,course_code,semester_number,description,accent_color,units_count,resources_count,sort_order,is_published").eq("course_code", "BMS").order("semester_number", { ascending: true }).order("sort_order", { ascending: true }),
    client.database.from("content_items").select("id,subject_id,content_type,title,description,body,academic_year,file_url,file_key,sort_order,is_published").in("content_type", ["syllabus_unit", "note", "important_topic", "recommended_resource"]).order("sort_order", { ascending: true }),
  ]);
  const error = subjectError ?? contentError;
  return <AdminShell active="/admin/content" email={user.email ?? "Admin"} eyebrow="STUDY LIBRARY" title="Content management">
    <div className="admin-page-intro"><p>Build every subject’s syllabus, notes, priority topics and recommended resources.</p><span>Draft safely, then publish when ready.</span></div>
    {error ? <div className="admin-notice error">{error.message ?? "Could not load study content."}</div> : <ContentManager subjects={(subjects ?? []) as SubjectRecord[]} content={(content ?? []) as ContentRecord[]}/>} 
  </AdminShell>;
}
