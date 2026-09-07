import { redirect } from "next/navigation";
import { getAdminSession } from "../../lib/insforge/server";
import AdminShell from "../AdminShell";
import type { PyqRecord, SubjectRecord } from "../types";
import PyqManager from "./PyqManager";

export const dynamic = "force-dynamic";

export default async function AdminPyqsPage() {
  const { user, isAdmin, client } = await getAdminSession();
  if (!user || !isAdmin) redirect("/admin/login");
  const [{ data: subjects, error: subjectError }, { data: papers, error: paperError }] = await Promise.all([
    client.database.from("subjects").select("id,name,slug,short_code,course_code,semester_number,description,accent_color,units_count,resources_count,sort_order,is_published").eq("course_code", "BMS").order("semester_number", { ascending: true }).order("sort_order", { ascending: true }),
    client.database.from("content_items").select("id,subject_id,content_type,title,description,body,academic_year,exam_type,file_url,file_key,file_name,file_size_bytes,sort_order,is_published").eq("content_type", "pyq").order("academic_year", { ascending: false }).order("sort_order", { ascending: true }),
  ]);
  const error = subjectError ?? paperError;
  return <AdminShell active="/admin/pyqs" email={user.email ?? "Admin"} eyebrow="EXAM ARCHIVE" title="PYQ & PDF management">
    <div className="admin-page-intro"><p>Upload, organise and publish real previous-year papers for every BMS subject.</p><span>Private drafts. Controlled public downloads.</span></div>
    {error ? <div className="admin-notice error">{error.message ?? "Could not load the paper library."}</div> : <PyqManager subjects={(subjects ?? []) as SubjectRecord[]} papers={(papers ?? []) as PyqRecord[]}/>} 
  </AdminShell>;
}
