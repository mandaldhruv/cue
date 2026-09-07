import { Footer, Navigation, PageIntro } from "../components";
import { createInsForgeServerClient } from "../lib/insforge/server";
import SubjectsExplorer, { type ExplorerSemester, type ExplorerSubject } from "./SubjectsExplorer";

export const dynamic = "force-dynamic";

export default async function SubjectsPage() {
  const client = await createInsForgeServerClient();
  const [{ data: semesters, error: semesterError }, { data: subjects, error: subjectError }] = await Promise.all([
    client.database.from("semesters").select("semester_number,title,status").eq("course_code", "BMS").order("sort_order", { ascending: true }),
    client.database.from("subjects").select("name,slug,short_code,description,semester_number,accent_color").eq("course_code", "BMS").eq("is_published", true).order("semester_number", { ascending: true }).order("sort_order", { ascending: true }),
  ]);
  return <><Navigation /><main><PageIntro eyebrow="BMS SUBJECT LIBRARY" title="Choose your subject." description="Switch semesters anytime. Published material appears automatically." /><SubjectsExplorer semesters={(semesters ?? []) as ExplorerSemester[]} subjects={(subjects ?? []) as ExplorerSubject[]} loadError={Boolean(semesterError || subjectError)}/></main><Footer /></>;
}
