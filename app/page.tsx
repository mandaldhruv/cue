import Link from "next/link";
import { randomUUID } from "node:crypto";
import { Footer, Navigation, SubjectCard } from "./components";
import CountUpStats from "./CountUpStats";
import { HomeHeroHeading } from "./greetings/GreetingDisplay";
import greetingMessages from "./greetings/greeting-messages.generated.json";
import { createInsForgeServerClient } from "./lib/insforge/server";
import type { Subject } from "./data";

export const dynamic = "force-dynamic";

const accents: Record<string, Subject["accent"]> = { "#E8665B": "coral", "#315DE6": "blue", "#7459E9": "violet", "#299B7D": "mint", "#D58B2A": "amber", "#CF538F": "rose" };
type GreetingReservation = { time_block: number; message_index: number };

export default async function Home() {
  const client = await createInsForgeServerClient();
  const [{ data: subjectRows }, { data: contentRows }, { data: semesterRows }, { data: currentUserData }] = await Promise.all([
    client.database.from("subjects").select("name,slug,short_code,description,accent_color").eq("course_code", "BMS").eq("is_published", true).order("semester_number", { ascending: true }).order("sort_order", { ascending: true }),
    client.database.from("content_items").select("id,subject_id,content_type,title,description,body,is_published").in("content_type", ["syllabus_unit", "pyq", "flashcard"]).eq("is_published", true),
    client.database.from("semesters").select("id,status").eq("course_code", "BMS").eq("status", "published"),
    client.auth.getCurrentUser(),
  ]);
  const rawInitialName = currentUserData?.user?.profile?.name?.trim().split(/\s+/u)[0]
    ?? currentUserData?.user?.email?.split("@")[0]?.replace(/[._-]+/gu, " ").trim().split(/\s+/u)[0]
    ?? null;
  const initialName = rawInitialName
    ? rawInitialName.charAt(0).toUpperCase() + rawInitialName.slice(1)
    : null;
  const initialUserId = currentUserData?.user?.id ?? null;
  let initialGreeting: string | null = null;
  let initialGreetingTimeBlock: number | null = null;

  if (initialUserId && initialName) {
    const { data: greetingData } = await client.database.rpc("reserve_cue_greeting", {
      p_audience: "student",
      p_event_id: randomUUID(),
    });
    const reservation = (Array.isArray(greetingData) ? greetingData[0] : greetingData) as GreetingReservation | null;
    const blockIndex = Number(reservation?.time_block) - 1;
    const messageIndex = Number(reservation?.message_index);
    const sourceMessage = greetingMessages.student[blockIndex]?.[messageIndex];

    if (sourceMessage) {
      initialGreeting = sourceMessage.replaceAll("[Name]", initialName);
      initialGreetingTimeBlock = blockIndex + 1;
    }
  }
  const subjects: Subject[] = (subjectRows ?? []).map((item: { name: string; slug: string; short_code: string; description: string; accent_color: string }) => ({ slug: item.slug, code: item.short_code, name: item.name, shortName: item.name, description: item.description, accent: accents[item.accent_color.toUpperCase()] ?? "blue", units: [], papers: 0 }));
  return <>
    <Navigation />
    <main>
      <section className="new-hero">
        <div className="hero-wash" />
        <div className="container hero-grid">
          <div className="hero-copy">
            <span className="bms-hero-badge"><i aria-hidden="true"><svg viewBox="0 0 24 24" role="img"><rect x="5" y="4" width="12" height="15" rx="2"/><path d="M9 8h8a2 2 0 0 1 2 2v10H9a2 2 0 0 1-2-2V6"/><path d="M11 12h5M11 15h4"/></svg></i><span><small>BUILT EXCLUSIVELY FOR</small><b>BMS STUDENTS</b></span></span>
            <HomeHeroHeading
              initialUserId={initialUserId}
              initialName={initialName}
              initialMessage={initialGreeting}
              initialTimeBlock={initialGreetingTimeBlock}
            />
            <p>Semester-wise syllabus, PYQs and flashcards, created around what BMS students actually need.</p>
            <CountUpStats subjects={subjects.length} resources={contentRows?.length ?? 0} semesters={semesterRows?.length ?? 0}/>
          </div>
          <div className="hero-study-panel">
            <div className="hero-panel-head"><span>START STUDYING</span><small>BMS · SEMESTER 3</small></div>
            <div className="hero-study-tabs">
              <Link href="/subjects"><i>01</i><div><b>Choose a subject</b><small>Open syllabus coverage and module breakdowns</small></div><span>→</span></Link>
              <Link href="/pyqs"><i>02</i><div><b>Practice PYQs</b><small>Browse real papers by subject and year</small></div><span>→</span></Link>
              <Link className="primary-study-action" href="/flashcards"><i>03</i><div><b>Flashcards</b><small>Revise key concepts with active recall</small></div><span>→</span></Link>
            </div>
            <div className="hero-panel-foot"><span><i/> Semester 3 available</span></div>
          </div>
        </div>
      </section>

      <section className="home-section subjects-home">
        <div className="container"><div className="focused-subject-head"><span>{String(subjects.length).padStart(2, "0")}</span><h2>{subjects.length} focused subjects</h2></div>
          <div className="subject-grid">{subjects.map((subject, i) => <SubjectCard subject={subject} index={i} key={subject.slug} />)}</div>
        </div>
      </section>

      <section className="home-section flashcards-spotlight"><div className="container"><div className="flashcards-spotlight-copy"><span className="eyebrow">CORE CUE FEATURE</span><h2>Master the syllabus.<br/><em>Recall the ideas.</em></h2><p>Cue flashcards turn your syllabus into quick, focused revision, helping you recall key ideas faster.</p><Link className="primary-button" href="/flashcards">Open Flashcards <span>→</span></Link></div><div className="flashcards-spotlight-card retention-card" aria-label="Active recall benefit"><span>ACTIVE RECALL</span><strong>2× better retention</strong><p>Retrieving information strengthens long-term memory.</p></div></div></section>

    </main>
    <Footer />
  </>;
}
