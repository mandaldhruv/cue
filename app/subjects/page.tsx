import { Footer, Navigation, PageIntro } from "../components";
import { getPublishedSemesters, getPublishedSubjects } from "../lib/public-content";
import SubjectsExplorer, { type ExplorerSemester, type ExplorerSubject } from "./SubjectsExplorer";

export const dynamic = "force-dynamic";

export default async function SubjectsPage() {
  const [{ semesters, error: semesterError }, { subjects, error: subjectError }] = await Promise.all([
    getPublishedSemesters(),
    getPublishedSubjects(),
  ]);
  return (
    <>
      <Navigation />
      <main>
        <PageIntro
          eyebrow="BMS SUBJECT LIBRARY"
          title="Choose your subject."
          description="Switch semesters anytime. Published material appears automatically."
        />
        <SubjectsExplorer
          semesters={(semesters ?? []) as ExplorerSemester[]}
          subjects={(subjects ?? []) as ExplorerSubject[]}
          loadError={Boolean(semesterError || subjectError)}
        />
      </main>
      <Footer />
    </>
  );
}
