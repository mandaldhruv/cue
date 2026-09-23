import { redirect } from "next/navigation";
import { getAdminSession } from "../../lib/insforge/server";
import AdminShell from "../AdminShell";
import type { ContentRecord, SubjectRecord } from "../types";
import SyllabusManager from "./SyllabusManager";

export const dynamic = "force-dynamic";

export default async function AdminSyllabusPage() {
  const { user, isAdmin, client } = await getAdminSession();
  if (!user || !isAdmin) redirect("/admin/login");

  const [{ data: subjects, error: subjectError }, { data: syllabus, error: syllabusError }] = await Promise.all([
    client.database
      .from("subjects")
      .select("id,name,slug,short_code,course_code,semester_number,description,accent_color,units_count,resources_count,sort_order,is_published")
      .eq("course_code", "BMS")
      .order("semester_number", { ascending: true })
      .order("sort_order", { ascending: true }),
    client.database
      .from("content_items")
      .select("id,subject_id,content_type,title,description,body,academic_year,file_url,file_key,sort_order,is_published")
      .eq("content_type", "syllabus_unit")
      .order("sort_order", { ascending: true }),
  ]);

  const error = subjectError ?? syllabusError;

  return (
    <AdminShell active="/admin/syllabus" email={user.email ?? "Admin"} eyebrow="STUDY LIBRARY" title="Syllabus management">
      <div className="admin-page-intro">
        <p>Build and organize every subject’s syllabus units and detailed topic coverage.</p>
        <span>Draft safely, then publish when ready.</span>
      </div>
      {error ? (
        <div className="admin-notice error">{error.message ?? "Could not load syllabus."}</div>
      ) : (
        <SyllabusManager
          subjects={(subjects ?? []) as SubjectRecord[]}
          syllabus={(syllabus ?? []) as ContentRecord[]}
        />
      )}
    </AdminShell>
  );
}
