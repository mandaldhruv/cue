"use client";

import Link from "next/link";
import { useMemo, useState } from "react";
import type { PublicContentRecord, PublicSubjectRecord } from "../../lib/public-content";
import PyqLibrary from "../../pyqs/PyqLibrary";

type WorkspaceTab = "syllabus_unit" | "pyq";

const tabConfig = [
  { id: "syllabus_unit" as const, label: "Syllabus" },
  { id: "pyq" as const, label: "PYQs" },
  { id: "flashcard" as const, label: "Flashcards" },
];

function EmptyState({ type, subjectName }: { type: WorkspaceTab; subjectName: string }) {
  const copy: Record<WorkspaceTab, [string, string]> = {
    syllabus_unit: ["No syllabus published yet.", `The ${subjectName} syllabus will appear here after it is verified and published.`],
    pyq: ["No previous papers published yet.", `The ${subjectName} paper archive is being prepared.`],
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
    pyq: content.filter((item) => item.content_type === "pyq"),
    flashcard: content.filter((item) => item.content_type === "flashcard"),
  }), [content]);
  const tabCount = (key: "syllabus_unit" | "pyq" | "flashcard") => groups[key].length;
  const initial = (["syllabus_unit", "pyq"] as WorkspaceTab[]).find((key) => tabCount(key) > 0) ?? "syllabus_unit";
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
        {tabConfig.map((tab) => {
          if (tab.id === "flashcard") {
            return (
              <Link
                key={tab.id}
                href={`/flashcards/${subject.slug}`}
                className="workspace-tab"
                role="tab"
                aria-selected={false}
              >
                <span>{tab.label}</span>
                <small>{tabCount(tab.id)}</small>
              </Link>
            );
          }
          return (
            <button
              key={tab.id}
              type="button"
              className={`workspace-tab ${active === tab.id ? "active" : ""}`}
              onClick={() => setActive(tab.id)}
              role="tab"
              aria-selected={active === tab.id}
            >
              <span>{tab.label}</span>
              <small>{tabCount(tab.id)}</small>
            </button>
          );
        })}
      </div>
      {loadError ? <div className="study-empty error"><span>CONNECTION ISSUE</span><h3>Study material could not be loaded.</h3><p>Please refresh the page in a moment.</p></div> : <div className="workspace-panel" role="tabpanel">
        <header className="workspace-panel-head"><div><span>{subject.short_code} STUDY MATERIAL</span><h2>{tabConfig.find((tab) => tab.id === active)?.label}</h2></div><small>{tabCount(active)} {tabCount(active) === 1 ? "item" : "items"}</small></header>

        {active === "syllabus_unit" && (groups.syllabus_unit.length ? <div className="workspace-syllabus">{groups.syllabus_unit.map((item, index) => <article key={item.id}><span>{String(index + 1).padStart(2, "0")}</span><div><h3>{item.title}</h3>{item.description && <p>{item.description}</p>}{item.body && <div className="workspace-body">{item.body}</div>}</div><ExternalLink href={item.file_url}>Open syllabus</ExternalLink></article>)}</div> : <EmptyState type={active} subjectName={subject.name}/>) }

        {active === "pyq" && <PyqLibrary subjectSlug={subject.slug} compact/>}
      </div>}
      {!loadError && total === 0 && <p className="workspace-honesty-note">Nothing has been published for this subject yet. No placeholder material is shown.</p>}
    </div></section>
  </>;
}
