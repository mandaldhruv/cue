"use client";

import { useMemo, useState, useTransition } from "react";
import AdminScopePicker from "../AdminScopePicker";
import { deleteContentItem, moveContentItem, saveContentItem, setContentPublished } from "../content-actions";
import type { AdminActionResult, ContentRecord, SubjectRecord } from "../types";

const blank = (subjectId: string, order: number): ContentRecord => ({ id: "", subject_id: subjectId, content_type: "flashcard", title: "", description: "", body: "", academic_year: null, file_url: null, file_key: null, sort_order: order, is_published: false });

export default function FlashcardManager({ subjects, cards }: { subjects: SubjectRecord[]; cards: ContentRecord[] }) {
  const [semester, setSemester] = useState(subjects[0]?.semester_number ?? 3);
  const [subjectId, setSubjectId] = useState(subjects[0]?.id ?? "");
  const [editing, setEditing] = useState<ContentRecord | null>(null);
  const [creating, setCreating] = useState(false);
  const [notice, setNotice] = useState<AdminActionResult | null>(null);
  const [pending, startTransition] = useTransition();
  const visible = useMemo(() => cards.filter((card) => card.subject_id === subjectId), [cards, subjectId]);
  const subject = subjects.find((item) => item.id === subjectId);
  const active = editing ?? (creating ? blank(subjectId, visible.length + 1) : null);

  function run(action: () => Promise<AdminActionResult>, close = false) {
    startTransition(async () => { const result = await action(); setNotice(result); if (result.ok && close) { setEditing(null); setCreating(false); } });
  }

  if (!subjects.length) return <div className="admin-empty content-empty"><b>Create a subject first</b><p>Every flashcard deck belongs to a subject.</p><a href="/admin/subjects">Open Subject Management →</a></div>;

  return <>
    <AdminScopePicker subjects={subjects} semester={semester} subjectId={subjectId} context="Flashcard deck" detail={`${subject?.name ?? "Select a subject"} → Flashcards`} onSemesterChange={(nextSemester, firstSubjectId) => { setSemester(nextSemester); setSubjectId(firstSubjectId); setEditing(null); setCreating(false); setNotice(null); }} onSubjectChange={(nextSubjectId) => { setSubjectId(nextSubjectId); setEditing(null); setCreating(false); setNotice(null); }}/>
    <div className="admin-selection-summary"><div><span>{subject?.is_published ? "LIVE SUBJECT" : "DRAFT SUBJECT"}</span><b>{subject?.name}</b></div><div><b>{visible.filter((card) => card.is_published).length}</b><span>PUBLISHED CARDS</span></div><a href={subject ? `/subjects/${subject.slug}` : "/flashcards"} target="_blank" rel="noreferrer">Preview deck ↗</a></div>
    <div className="admin-toolbar content-toolbar"><div><b>{subject?.name} deck</b><span>Question on the front, answer on the back</span></div><button onClick={() => { setCreating(true); setEditing(null); }}>+ Add flashcard</button></div>
    {notice && <div className={`admin-notice ${notice.ok ? "success" : "error"}`}>{notice.message}<button onClick={() => setNotice(null)}>×</button></div>}
    <div className="content-list flashcard-admin-list">{visible.length ? visible.map((card, index) => <article key={card.id}>
      <div className="content-order"><button disabled={pending || index === 0} onClick={() => run(() => moveContentItem(card.id, subjectId, "flashcard", "up"))}>↑</button><span>{String(index + 1).padStart(2, "0")}</span><button disabled={pending || index === visible.length - 1} onClick={() => run(() => moveContentItem(card.id, subjectId, "flashcard", "down"))}>↓</button></div>
      <div className="content-item-copy"><div><b>{card.title}</b><span className={card.is_published ? "live" : "draft"}>{card.is_published ? "Published" : "Draft"}</span></div><p>{card.body || "No answer added yet."}</p></div>
      <div className="content-item-actions"><button className={`admin-publish-toggle ${card.is_published ? "live" : "draft"}`} disabled={pending} onClick={() => run(() => setContentPublished(card.id, !card.is_published))}><i/>{card.is_published ? "Live" : "Draft"}</button><button onClick={() => { setEditing(card); setCreating(false); }}>Edit</button><button className="danger" onClick={() => { if (window.confirm(`Delete this flashcard?`)) run(() => deleteContentItem(card.id)); }}>Delete</button></div>
    </article>) : <div className="admin-empty"><div className="content-empty-mark">Q/A</div><b>No flashcards yet</b><p>Create the first card for {subject?.name}.</p><button onClick={() => setCreating(true)}>Create flashcard →</button></div>}</div>
    {active && <div className="admin-drawer-backdrop" onMouseDown={() => { setEditing(null); setCreating(false); }}><aside className="admin-drawer wide" onMouseDown={(event) => event.stopPropagation()}><div className="admin-drawer-head"><div><span>{active.id ? "EDIT FLASHCARD" : "CREATE FLASHCARD"}</span><h2>{active.id ? active.title : `Add to ${subject?.short_code}`}</h2></div><button onClick={() => { setEditing(null); setCreating(false); }}>×</button></div><form action={(formData) => run(() => saveContentItem(formData), true)}>
      <input type="hidden" name="id" value={active.id}/><input type="hidden" name="subject_id" value={subjectId}/><input type="hidden" name="content_type" value="flashcard"/><input type="hidden" name="file_url" value=""/><label><span>Question / prompt</span><textarea name="title" defaultValue={active.title} rows={3} placeholder="e.g. What is advertising?" required/></label><label><span>Optional hint</span><input name="description" defaultValue={active.description} placeholder="A short clue students can use before revealing the answer"/></label><label><span>Answer</span><textarea name="body" defaultValue={active.body} rows={7} placeholder="Write the concise, exam-ready answer…" required/></label><div className="admin-form-grid"><label><span>Display order</span><input name="sort_order" type="number" min="0" defaultValue={active.sort_order}/></label><label><span>Visibility</span><select name="is_published" defaultValue={String(active.is_published)}><option value="true">Published</option><option value="false">Draft</option></select></label></div><div className="admin-form-actions"><button type="button" onClick={() => { setEditing(null); setCreating(false); }}>Cancel</button><button className="primary" disabled={pending}>{pending ? "Saving…" : "Save flashcard"}</button></div>
    </form></aside></div>}
  </>;
}
