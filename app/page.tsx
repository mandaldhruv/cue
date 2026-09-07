import Link from "next/link";
import { Footer, Navigation, SubjectCard } from "./components";
import CountUpStats from "./CountUpStats";
import { createInsForgeServerClient } from "./lib/insforge/server";
import type { Subject } from "./data";

export const dynamic = "force-dynamic";

const accents: Record<string, Subject["accent"]> = { "#E8665B": "coral", "#315DE6": "blue", "#7459E9": "violet", "#299B7D": "mint", "#D58B2A": "amber", "#CF538F": "rose" };

export default async function Home() {
  const client = await createInsForgeServerClient();
  const [{ data: subjectRows }, { data: contentRows }, { data: semesterRows }] = await Promise.all([
    client.database.from("subjects").select("name,slug,short_code,description,accent_color").eq("course_code", "BMS").eq("is_published", true).order("semester_number", { ascending: true }).order("sort_order", { ascending: true }),
    client.database.from("content_items").select("id,subject_id,content_type,title,description,body,is_published").eq("is_published", true),
    client.database.from("semesters").select("id,status").eq("course_code", "BMS").eq("status", "published"),
  ]);
  const subjects: Subject[] = (subjectRows ?? []).map((item: { name: string; slug: string; short_code: string; description: string; accent_color: string }) => ({ slug: item.slug, code: item.short_code, name: item.name, shortName: item.name, description: item.description, accent: accents[item.accent_color.toUpperCase()] ?? "blue", units: [], notes: 0, papers: 0 }));
  const topics = (contentRows ?? []).filter((item: { content_type: string }) => item.content_type === "important_topic").slice(0, 4) as { id: string; title: string; description: string; body: string }[];
  return <>
    <Navigation />
    <main>
      <section className="new-hero">
        <div className="hero-wash" />
        <div className="container hero-grid">
          <div className="hero-copy">
            <span className="bms-hero-badge"><i>✦</i><span><small>BUILT EXCLUSIVELY FOR</small><b>BMS STUDENTS</b></span></span>
            <h1>Your complete<br /><em>BMS study space.</em></h1>
            <p>Semester-wise notes, PYQs, flashcards and exam insights—created around what BMS students actually need.</p>
            <CountUpStats subjects={subjects.length} resources={contentRows?.length ?? 0} semesters={semesterRows?.length ?? 0}/>
          </div>
          <div className="hero-study-panel">
            <div className="hero-panel-head"><span>START STUDYING</span><small>BMS · SEMESTER 3</small></div>
            <div className="hero-study-tabs">
              <Link href="/subjects"><i>01</i><div><b>Choose a subject</b><small>Open syllabus, notes and important topics</small></div><span>→</span></Link>
              <Link href="/pyqs"><i>02</i><div><b>Practice PYQs</b><small>Browse real papers by subject and year</small></div><span>→</span></Link>
              <Link href="/flashcards"><i>03</i><div><b>Flashcards</b><small>Revise key concepts with active recall</small></div><span>→</span></Link>
            </div>
            <div className="hero-panel-foot"><span><i/> Semester 3 available</span><Link href="/subjects">View all material ↗</Link></div>
          </div>
        </div>
      </section>

      <section className="home-section subjects-home">
        <div className="container"><div className="focused-subject-head"><span>{String(subjects.length).padStart(2, "0")}</span><h2>{subjects.length} focused subjects</h2></div>
          <div className="subject-grid">{subjects.map((subject, i) => <SubjectCard subject={subject} index={i} key={subject.slug} />)}</div>
        </div>
      </section>

      <section className="home-section flashcards-spotlight"><div className="container"><div className="flashcards-spotlight-copy"><span className="eyebrow">CORE CUE FEATURE</span><h2>Study the notes.<br/><em>Recall the ideas.</em></h2><p>Cue flashcards are built around the same study material you find here—so revision stays connected to what you are learning.</p><Link className="primary-button" href="/flashcards">Open Flashcards <span>→</span></Link></div><div className="flashcards-spotlight-card" aria-label="Flashcards in Cue"><span>ACTIVE RECALL</span><div><i>01</i><b>Study notes</b><small>Understand the topic</small></div><strong>↓</strong><div><i>02</i><b>Cue flashcards</b><small>Revisit key concepts</small></div></div></div></section>

      {topics.length > 0 && <section className="home-section focus-section"><div className="container focus-grid"><div className="focus-copy"><span className="eyebrow">PUBLISHED EXAM FOCUS</span><h2>Know what deserves<br/><em>your attention.</em></h2><p>These topics come directly from the material reviewed and published by the Cue team—no invented scores or placeholder predictions.</p><Link className="primary-button" href="/subjects">Open your subject <span>→</span></Link></div><div className="focus-board real-focus-board"><div className="focus-header"><div><span>✦</span><b>Important topics</b></div><small>Live from Cue</small></div>{topics.map((item, index) => <article key={item.id}><b>{String(index + 1).padStart(2, "0")}</b><div><span>{item.title}</span>{(item.description || item.body) && <small>{item.description || item.body}</small>}</div></article>)}</div></div></section>}

    </main>
    <Footer />
  </>;
}
