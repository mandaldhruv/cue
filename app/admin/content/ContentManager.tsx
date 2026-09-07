"use client";

import { useMemo, useState, useTransition } from "react";
import AdminScopePicker from "../AdminScopePicker";
import { deleteContentItem, moveContentItem, saveContentItem, setContentPublished } from "../content-actions";
import type { AdminActionResult, ContentRecord, EditableContentType, SubjectRecord } from "../types";

const tabs: { value: EditableContentType; label: string; singular: string; hint: string; icon: string }[] = [
  { value: "syllabus_unit", label: "Syllabus", singular: "unit", hint: "Course units and module coverage", icon: "01" },
  { value: "note", label: "Notes", singular: "note", hint: "Revision notes and useful links", icon: "02" },
  { value: "important_topic", label: "Exam Focus", singular: "topic", hint: "Important topics shown above Notes", icon: "03" },
  { value: "recommended_resource", label: "Resources", singular: "resource", hint: "Books, videos and external learning", icon: "04" },
];

const blank = (subjectId: string, contentType: EditableContentType, order: number): ContentRecord => ({ id: "", subject_id: subjectId, content_type: contentType, title: "", description: "", body: "", academic_year: null, file_url: null, file_key: null, sort_order: order, is_published: false });

export default function ContentManager({ subjects, content }: { subjects: SubjectRecord[]; content: ContentRecord[] }) {
  const [semester, setSemester] = useState(subjects[0]?.semester_number ?? 3);
  const [subjectId, setSubjectId] = useState(subjects[0]?.id ?? "");
  const [type, setType] = useState<EditableContentType>("syllabus_unit");
  const [editing, setEditing] = useState<ContentRecord | null>(null);
  const [creating, setCreating] = useState(false);
  const [notice, setNotice] = useState<AdminActionResult | null>(null);
  const [pending, startTransition] = useTransition();
  const selectedSubject = subjects.find((item) => item.id === subjectId);
  const items = useMemo(() => content.filter((item) => item.subject_id === subjectId && item.content_type === type), [content, subjectId, type]);
  const currentTab = tabs.find((tab) => tab.value === type)!;
  const active = editing ?? (creating ? blank(subjectId, type, items.length + 1) : null);

  function run(action: () => Promise<AdminActionResult>, close = false) {
    startTransition(async () => { const result = await action(); setNotice(result); if (result.ok && close) { setEditing(null); setCreating(false); } });
  }

  function switchType(next: EditableContentType) { setType(next); setEditing(null); setCreating(false); setNotice(null); }

  if (!subjects.length) return <div className="admin-empty content-empty"><b>Create a subject first</b><p>Study content needs a subject to belong to.</p><a href="/admin/subjects">Open Subject Management →</a></div>;

  return <>
    <AdminScopePicker subjects={subjects} semester={semester} subjectId={subjectId} context="Study content" detail={`${selectedSubject?.name ?? "Select a subject"} → Student subject workspace`} onSemesterChange={(nextSemester, firstSubjectId) => { setSemester(nextSemester); setSubjectId(firstSubjectId); setEditing(null); setCreating(false); setNotice(null); }} onSubjectChange={(nextSubjectId) => { setSubjectId(nextSubjectId); setEditing(null); setCreating(false); setNotice(null); }}/>
    <div className="admin-selection-summary"><div><span>{selectedSubject?.is_published ? "LIVE SUBJECT" : "DRAFT SUBJECT"}</span><b>{selectedSubject?.name}</b></div><div><b>{content.filter((item) => item.subject_id === subjectId && item.is_published).length}</b><span>PUBLISHED ITEMS</span></div><a href={selectedSubject ? `/subjects/${selectedSubject.slug}` : "/subjects"} target="_blank" rel="noreferrer">Preview student page ↗</a></div>
    <div className="content-type-tabs" role="tablist">{tabs.map((tab) => { const count = content.filter((item) => item.subject_id === subjectId && item.content_type === tab.value).length; return <button key={tab.value} className={type === tab.value ? "active" : ""} onClick={() => switchType(tab.value)} role="tab" aria-selected={type === tab.value}><i>{tab.icon}</i><span><b>{tab.label}</b><small>{count} {count === 1 ? "item" : "items"}</small></span></button>; })}</div>
    <div className="admin-toolbar content-toolbar"><div><b>{currentTab.label}</b><span>{currentTab.hint}</span></div><button onClick={() => { setCreating(true); setEditing(null); }}>+ Add {currentTab.singular}</button></div>
    {notice && <div className={`admin-notice ${notice.ok ? "success" : "error"}`}>{notice.message}<button onClick={() => setNotice(null)}>×</button></div>}
    <div className="content-list">
      {items.length ? items.map((item, index) => <article key={item.id}>
        <div className="content-order"><button disabled={pending || index === 0} onClick={() => run(() => moveContentItem(item.id, subjectId, type, "up"))}>↑</button><span>{String(index + 1).padStart(2, "0")}</span><button disabled={pending || index === items.length - 1} onClick={() => run(() => moveContentItem(item.id, subjectId, type, "down"))}>↓</button></div>
        <div className="content-item-copy"><div><b>{item.title}</b><span className={item.is_published ? "live" : "draft"}>{item.is_published ? "Published" : "Draft"}</span></div><p>{item.description || item.body || "No supporting details added yet."}</p>{item.file_url && <a href={item.file_url} target="_blank" rel="noreferrer">Open attached link ↗</a>}</div>
        <div className="content-item-actions"><button className={`admin-publish-toggle ${item.is_published ? "live" : "draft"}`} disabled={pending} onClick={() => run(() => setContentPublished(item.id, !item.is_published))}><i/>{item.is_published ? "Live" : "Draft"}</button><button onClick={() => { setEditing(item); setCreating(false); }}>Edit</button><button className="danger" onClick={() => { if (window.confirm(`Delete “${item.title}”?`)) run(() => deleteContentItem(item.id)); }}>Delete</button></div>
      </article>) : <div className="admin-empty"><div className="content-empty-mark">{currentTab.icon}</div><b>No {currentTab.label.toLowerCase()} yet</b><p>Add the first {currentTab.singular} for {selectedSubject?.name}.</p><button onClick={() => setCreating(true)}>Create {currentTab.singular} →</button></div>}
    </div>
    {active && <div className="admin-drawer-backdrop" onMouseDown={() => { setEditing(null); setCreating(false); }}><aside className="admin-drawer wide" onMouseDown={(event) => event.stopPropagation()}><div className="admin-drawer-head"><div><span>{active.id ? "EDIT" : "CREATE"} {currentTab.label.toUpperCase()}</span><h2>{active.id ? active.title : `Add ${currentTab.singular}`}</h2></div><button onClick={() => { setEditing(null); setCreating(false); }}>×</button></div><form action={(formData) => run(() => saveContentItem(formData), true)}>
      <input type="hidden" name="id" value={active.id}/><input type="hidden" name="subject_id" value={subjectId}/><input type="hidden" name="content_type" value={type}/><label><span>Title</span><input name="title" defaultValue={active.title} placeholder={type === "syllabus_unit" ? "e.g. Unit 1 — Introduction to Marketing" : `Name this ${currentTab.singular}`} required/></label><label><span>Short description</span><textarea name="description" defaultValue={active.description} rows={3} placeholder="What will students find here?"/></label><label><span>{type === "syllabus_unit" ? "Topics / detailed coverage" : "Content / guidance"}</span><textarea name="body" defaultValue={active.body} rows={6} placeholder={type === "important_topic" ? "Why it matters, expected questions, revision guidance…" : "Add structured details students can use…"}/></label>{type !== "important_topic" && <label><span>Resource link (optional)</span><input name="file_url" type="url" defaultValue={active.file_url ?? ""} placeholder="https://…"/></label>}<div className="admin-form-grid"><label><span>Display order</span><input name="sort_order" type="number" min="0" defaultValue={active.sort_order}/></label><label><span>Visibility</span><select name="is_published" defaultValue={String(active.is_published)}><option value="true">Published</option><option value="false">Draft</option></select></label></div><div className="admin-form-actions"><button type="button" onClick={() => { setEditing(null); setCreating(false); }}>Cancel</button><button className="primary" disabled={pending}>{pending ? "Saving…" : `Save ${currentTab.singular}`}</button></div>
    </form></aside></div>}
  </>;
}
