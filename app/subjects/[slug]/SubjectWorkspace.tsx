"use client";

import Link from "next/link";
import { useMemo, useState } from "react";
import FlashcardPlayer from "../../flashcards/FlashcardPlayer";
import type { PublicContentRecord, PublicSubjectRecord } from "../../lib/public-content";
import PyqLibrary from "../../pyqs/PyqLibrary";

type WorkspaceTab = "syllabus_unit" | "note" | "pyq" | "flashcard" | "recommended_resource";

const tabConfig: { id: WorkspaceTab; label: string }[] = [
  { id: "syllabus_unit", label: "Syllabus" },
  { id: "note", label: "Notes" },
  { id: "pyq", label: "PYQs" },
  { id: "flashcard", label: "Flashcards" },
  { id: "recommended_resource", label: "Resources" },
];

function EmptyState({ type, subjectName }: { type: WorkspaceTab; subjectName: string }) {
  const copy: Record<WorkspaceTab, [string, string]> = {
    syllabus_unit: ["No syllabus published yet.", `The ${subjectName} syllabus will appear here after it is verified and published.`],
    note: ["No notes published yet.", `Notes and revision material for ${subjectName} are still being organised.`],
    pyq: ["No previous papers published yet.", `The ${subjectName} paper archive is being prepared.`],
    flashcard: ["No flashcards published yet.", `The ${subjectName} revision deck will appear here when it is ready.`],
    recommended_resource: ["No resources published yet.", `Verified videos, PDFs and useful links for ${subjectName} will appear here.`],
  };
  return <div className="study-empty"><span>NOT PUBLISHED YET</span><h3>{copy[type][0]}</h3><p>{copy[type][1]}</p></div>;
}

function ExternalLink({ href, children }: { href: string | null; children: React.ReactNode }) {
  if (!href) return null;
  return <a className="workspace-resource-link" href={href} target="_blank" rel="noreferrer">{children} <span>↗</span></a>;
}

export default function SubjectWorkspace({ subject, content, loadError }: { subject: PublicSubjectRecord; content: PublicContentRecord[]; loadError: boolean }) {
  const groups = useMemo(() => ({
    syllabus_unit: content.filter((item) => item.content_type === "syllabus_unit"),
    note: content.filter((item) => item.content_type === "note"),
    pyq: content.filter((item) => item.content_type === "pyq"),
    flashcard: content.filter((item) => item.content_type === "flashcard"),
    recommended_resource: content.filter((item) => item.content_type === "recommended_resource"),
    important_topic: content.filter((item) => item.content_type === "important_topic"),
  }), [content]);
  const tabCount = (key: WorkspaceTab) => key === "note" ? groups.note.length + groups.important_topic.length : groups[key].length;
  const initial = (["note", "syllabus_unit", "pyq", "flashcard", "recommended_resource"] as WorkspaceTab[]).find((key) => tabCount(key) > 0) ?? "syllabus_unit";
  const [active, setActive] = useState<WorkspaceTab>(initial);
  const total = content.length;

  return <>
    <section className="compact-subject-head" style={{ "--subject-accent": subject.accent_color || "#315DE6" } as React.CSSProperties}>
      <div className="container">
        <Link href="/subjects" className="subject-breadcrumb">← Subjects <span>/</span> Semester {subject.semester_number}</Link>
        <div className="compact-subject-title"><div><span>{subject.short_code} · BMS SEM {subject.semester_number}</span><h1>{subject.name}</h1></div>{subject.description && <p>{subject.description}</p>}</div>
      </div>
    </section>
    <section className="subject-workspace"><div className="container">
      <div className="workspace-tabs" role="tablist" aria-label={`${subject.name} study material`}>
        {tabConfig.map((tab) => <button key={tab.id} className={active === tab.id ? "active" : ""} onClick={() => setActive(tab.id)} role="tab" aria-selected={active === tab.id}><span>{tab.label}</span><small>{tabCount(tab.id)}</small></button>)}
      </div>
      {loadError ? <div className="study-empty error"><span>CONNECTION ISSUE</span><h3>Study material could not be loaded.</h3><p>Please refresh the page in a moment.</p></div> : <div className="workspace-panel" role="tabpanel">
        <header className="workspace-panel-head"><div><span>{subject.short_code} STUDY MATERIAL</span><h2>{tabConfig.find((tab) => tab.id === active)?.label}</h2></div><small>{tabCount(active)} {tabCount(active) === 1 ? "item" : "items"}</small></header>

        {active === "syllabus_unit" && (groups.syllabus_unit.length ? <div className="workspace-syllabus">{groups.syllabus_unit.map((item, index) => <article key={item.id}><span>{String(index + 1).padStart(2, "0")}</span><div><h3>{item.title}</h3>{item.description && <p>{item.description}</p>}{item.body && <div className="workspace-body">{item.body}</div>}</div><ExternalLink href={item.file_url}>Open syllabus</ExternalLink></article>)}</div> : <EmptyState type={active} subjectName={subject.name}/>) }

        {active === "note" && <>{groups.important_topic.length > 0 && <section className="exam-focus"><span>EXAM FOCUS</span><div>{groups.important_topic.map((item) => <article key={item.id}><b>{item.title}</b>{(item.description || item.body) && <p>{item.description || item.body}</p>}</article>)}</div></section>}{groups.note.length ? <div className="workspace-card-grid">{groups.note.map((item) => <article key={item.id}><span>NOTE</span><h3>{item.title}</h3>{item.description && <p>{item.description}</p>}{item.body && <div className="workspace-body">{item.body}</div>}<ExternalLink href={item.file_url}>Open resource</ExternalLink></article>)}</div> : <EmptyState type={active} subjectName={subject.name}/>}</>}

        {active === "pyq" && <PyqLibrary subjectSlug={subject.slug} compact/>}
        {active === "flashcard" && <FlashcardPlayer cards={groups.flashcard.map(({ id, title, description, body }) => ({ id, title, description, body }))} subjectName={subject.name}/>} 
        {active === "recommended_resource" && (groups.recommended_resource.length ? <div className="workspace-resource-list">{groups.recommended_resource.map((item, index) => <article key={item.id}><span>{String(index + 1).padStart(2, "0")}</span><div><h3>{item.title}</h3>{item.description && <p>{item.description}</p>}{item.body && <div className="workspace-body">{item.body}</div>}</div><ExternalLink href={item.file_url}>Open resource</ExternalLink></article>)}</div> : <EmptyState type={active} subjectName={subject.name}/>) }
      </div>}
      {!loadError && total === 0 && <p className="workspace-honesty-note">Nothing has been published for this subject yet—no placeholder material is shown.</p>}
    </div></section>
  </>;
}
