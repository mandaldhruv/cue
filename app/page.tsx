import Link from "next/link";
import { Footer, Navigation, SubjectCard } from "./components";
import CountUpStats from "./CountUpStats";
import { HomeHeroHeading } from "./greetings/GreetingDisplay";
import greetingMessages from "./greetings/greeting-messages.generated.json";
import { createServerClient } from "./lib/supabase/server";
import { getPublishedSubjects } from "./lib/public-content";
import type { Subject } from "./data";

export const dynamic = "force-dynamic";

const accents: Record<string, Subject["accent"]> = { "#E8665B": "coral", "#315DE6": "blue", "#7459E9": "violet", "#299B7D": "mint", "#D58B2A": "amber", "#CF538F": "rose" };

export default async function Home() {
  const client = await createServerClient();
  const [subjectsResult, { count: contentCount, data: contentRows }, { data: semesterRows }, userResult] = await Promise.all([
    getPublishedSubjects(),
    client.from("content_items").select("id", { count: "exact" }).in("content_type", ["syllabus_unit", "pyq", "flashcard"]).eq("is_published", true),
    client.from("semesters").select("id").eq("course_code", "BMS").eq("status", "published"),
    client.auth.getUser(),
  ]);
  const user = userResult.data?.user ?? null;
  const rawInitialName = user?.user_metadata?.name?.trim().split(/\s+/u)[0]
    ?? user?.user_metadata?.full_name?.trim().split(/\s+/u)[0]
    ?? user?.email?.split("@")[0]?.replace(/[._-]+/gu, " ").trim().split(/\s+/u)[0]
    ?? null;
  const initialName = rawInitialName
    ? rawInitialName.charAt(0).toUpperCase() + rawInitialName.slice(1)
    : null;
  const initialUserId = user?.id ?? null;
  let initialGreeting: string | null = null;
  let initialGreetingTimeBlock: number | null = null;

  // Fully deterministic, local greeting determination — zero DB writes, locks, or RPCs
  if (initialUserId && initialName) {
    const currentHourIst = new Date(
      new Date().toLocaleString("en-US", { timeZone: "Asia/Kolkata" })
    ).getHours();
    const blockIndex = Math.min(7, Math.max(0, Math.floor(currentHourIst / 3)));
    initialGreetingTimeBlock = blockIndex + 1;
    const messages = greetingMessages.student[blockIndex];
    if (messages && messages.length > 0) {
      let hash = 0;
      const seed = initialUserId + "_" + new Date().toISOString().slice(0, 10);
      for (let i = 0; i < seed.length; i++) {
        hash = (hash << 5) - hash + seed.charCodeAt(i);
        hash |= 0;
      }
      const messageIndex = Math.abs(hash) % messages.length;
      const sourceMessage = messages[messageIndex] ?? messages[0];
      initialGreeting = sourceMessage.replaceAll("[Name]", initialName);
    }
  }

  const subjects: Subject[] = (subjectsResult.subjects ?? []).map((item) => ({
    slug: item.slug,
    code: item.short_code,
    name: item.name,
    shortName: item.name,
    description: item.description,
    accent: accents[item.accent_color.toUpperCase()] ?? "blue",
    units: [],
    papers: 0,
  }));

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
            <CountUpStats subjects={subjects.length} resources={contentCount ?? contentRows?.length ?? 0} semesters={semesterRows?.length ?? 0}/>
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
