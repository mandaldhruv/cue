"use client";

import { useMemo, useState } from "react";
import Link from "next/link";
import { SubjectCard } from "../components";
import type { Subject } from "../data";

export type ExplorerSemester = { semester_number: number; title: string; status: "published" | "coming_soon" | "draft" | "archived" };
export type ExplorerSubject = { name: string; slug: string; short_code: string; description: string; semester_number: number; accent_color: string };

const accentMap: Record<string, Subject["accent"]> = { "#E8665B": "coral", "#315DE6": "blue", "#7459E9": "violet", "#299B7D": "mint", "#D58B2A": "amber", "#CF538F": "rose" };
const toCard = (item: ExplorerSubject): Subject => ({ slug: item.slug, code: item.short_code, name: item.name, shortName: item.name, description: item.description, accent: accentMap[item.accent_color.toUpperCase()] ?? "blue", units: [], notes: 0, papers: 0 });

export default function SubjectsExplorer({ semesters, subjects, loadError }: { semesters: ExplorerSemester[]; subjects: ExplorerSubject[]; loadError: boolean }) {
  const defaultSemester = semesters.find((item) => item.status === "published")?.semester_number ?? semesters[0]?.semester_number ?? 3;
  const [selectedSemester, setSelectedSemester] = useState(defaultSemester);
  const currentSemester = useMemo(() => semesters.find((semester) => semester.semester_number === selectedSemester), [semesters, selectedSemester]);
  const visible = useMemo(() => subjects.filter((subject) => subject.semester_number === selectedSemester).map(toCard), [subjects, selectedSemester]);
  const isAvailable = currentSemester?.status === "published";

  return <section className="page-section subjects-explorer"><div className="container">
    <div className="semester-toolbar"><div><span>BMS PROGRAM</span><b>{currentSemester?.title ?? `Semester ${selectedSemester}`}</b></div><label className="semester-select"><span>Semester</span><select value={selectedSemester} onChange={(event) => setSelectedSemester(Number(event.target.value))} aria-label="Choose semester">{semesters.map((semester) => <option key={semester.semester_number} value={semester.semester_number}>{semester.title}{semester.status === "coming_soon" ? " · Coming soon" : ""}</option>)}</select><i>⌄</i></label><div className={`semester-status ${isAvailable ? "live" : "soon"}`}><i/>{isAvailable ? `${visible.length} subjects available` : "Content coming soon"}</div></div>
    {loadError ? <div className="semester-coming-soon"><span className="eyebrow">CONNECTION ISSUE</span><h2>Subjects could not be loaded.</h2><p>Please refresh the page in a moment. Cue never replaces real material with placeholder content.</p></div> : isAvailable && visible.length ? <div className="subject-grid full">{visible.map((subject, index) => <SubjectCard subject={subject} index={index} key={subject.slug}/>)}</div> : <div className="semester-coming-soon"><div className="coming-orbit"><span>{selectedSemester}</span><i/><i/></div><span className="eyebrow">SEMESTER {selectedSemester}</span><h2>Good things are being <em>organised.</em></h2><p>No material has been published for this semester yet. Choose an available semester or request this one.</p>{semesters.some((item) => item.status === "published") && <button type="button" onClick={() => setSelectedSemester(defaultSemester)}>Explore Semester {defaultSemester} <span>→</span></button>}<Link href="/feedback">Request this semester</Link></div>}
  </div></section>;
}
