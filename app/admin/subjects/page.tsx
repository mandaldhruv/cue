import { redirect } from "next/navigation";
import { getAdminSession } from "../../lib/insforge/server";
import AdminShell from "../AdminShell";
import type { SemesterRecord, SubjectRecord } from "../types";
import SubjectManager from "./SubjectManager";

export const dynamic = "force-dynamic";

export default async function AdminSubjectsPage() {
  const { user, isAdmin, client } = await getAdminSession();
  if (!user || !isAdmin) redirect("/admin/login");
  const [{ data: subjects, error }, { data: semesters }] = await Promise.all([
    client.database.from("subjects").select("id,name,slug,short_code,course_code,semester_number,description,accent_color,units_count,resources_count,sort_order,is_published").eq("course_code", "BMS").order("sort_order", { ascending: true }),
    client.database.from("semesters").select("id,course_code,semester_number,title,status,sort_order").eq("course_code", "BMS").order("sort_order", { ascending: true }),
  ]);
  return <AdminShell active="/admin/subjects" email={user.email ?? "Admin"} eyebrow="CONTENT CATALOGUE" title="Subject management">
    <div className="admin-page-intro"><p>Create, organise and publish every BMS subject without touching the codebase.</p><span>Draft subjects remain hidden from students.</span></div>
    {error ? <div className="admin-notice error">{error.message ?? "Could not load subjects."}</div> : <SubjectManager subjects={(subjects ?? []) as SubjectRecord[]} semesters={(semesters ?? []) as SemesterRecord[]}/>} 
  </AdminShell>;
}
