import { redirect } from "next/navigation";
import { getAdminSession } from "../../lib/insforge/server";
import AdminShell from "../AdminShell";
import type { SemesterRecord } from "../types";
import SemesterManager from "./SemesterManager";

export const dynamic = "force-dynamic";

export default async function AdminSemestersPage() {
  const { user, isAdmin, client } = await getAdminSession();
  if (!user || !isAdmin) redirect("/admin/login");
  const { data, error } = await client.database.from("semesters").select("id,course_code,semester_number,title,status,sort_order").eq("course_code", "BMS").order("sort_order", { ascending: true });
  return <AdminShell active="/admin/semesters" email={user.email ?? "Admin"} eyebrow="PROGRAM STRUCTURE" title="Semester management">
    <div className="admin-page-intro"><p>Set the BMS semester hierarchy, availability and student-facing Coming Soon states.</p><span>Changes appear automatically on Subjects.</span></div>
    {error ? <div className="admin-notice error">{error.message ?? "Could not load semesters."}</div> : <SemesterManager semesters={(data ?? []) as SemesterRecord[]}/>} 
  </AdminShell>;
}
