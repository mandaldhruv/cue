"use client";

import { useMemo, useState, useTransition } from "react";
import { deleteSubject, moveSubject, saveSubject, setSubjectPublished } from "../content-actions";
import type { AdminActionResult, SemesterRecord, SubjectRecord } from "../types";

const accents = ["#E8665B", "#315DE6", "#7459E9", "#299B7D", "#D58B2A", "#CF538F"];
function slugify(value: string) { return value.toLowerCase().trim().replace(/[^a-z0-9]+/g, "-").replace(/^-|-$/g, ""); }

export default function SubjectManager({ subjects, semesters }: { subjects: SubjectRecord[]; semesters: SemesterRecord[] }) {
  const [semester, setSemester] = useState(3);
  const [editing, setEditing] = useState<SubjectRecord | null>(null);
  const [creating, setCreating] = useState(false);
  const [notice, setNotice] = useState<AdminActionResult | null>(null);
  const [pending, startTransition] = useTransition();
  const visible = useMemo(() => subjects.filter((item) => item.semester_number === semester), [subjects, semester]);
  const active = editing ?? (creating ? { id: "", name: "", slug: "", short_code: "", course_code: "BMS", semester_number: semester, description: "", accent_color: "#315DE6", units_count: 0, resources_count: 0, sort_order: visible.length + 1, is_published: false } : null);

  function run(action: () => Promise<AdminActionResult>, close = false) { startTransition(async () => { const result = await action(); setNotice(result); if (result.ok && close) { setEditing(null); setCreating(false); } }); }

  return <>
    <div className="admin-toolbar subject-toolbar"><div><b>{subjects.length} subjects</b><span>{subjects.filter((item) => item.is_published).length} currently published.</span></div><label><span>Semester</span><select value={semester} onChange={(event) => setSemester(Number(event.target.value))}>{semesters.map((item) => <option key={item.id} value={item.semester_number}>{item.title}</option>)}</select></label><button onClick={() => { setCreating(true); setEditing(null); }}>+ Add subject</button></div>
    {notice && <div className={`admin-notice ${notice.ok ? "success" : "error"}`}>{notice.message}<button onClick={() => setNotice(null)}>×</button></div>}
    <div className="admin-table-card"><div className="admin-table-head subject"><span>ORDER</span><span>SUBJECT</span><span>SEMESTER</span><span>VISIBILITY</span><span>ACTIONS</span></div>
      {visible.length ? visible.map((subject, index) => <div className="admin-table-row subject" key={subject.id}>
        <div className="admin-order"><button disabled={pending || index === 0} onClick={() => run(() => moveSubject(subject.id, semester, "up"))}>↑</button><button disabled={pending || index === visible.length - 1} onClick={() => run(() => moveSubject(subject.id, semester, "down"))}>↓</button></div>
        <div className="admin-entity"><i style={{ background: `${subject.accent_color}18`, color: subject.accent_color }}>{subject.short_code.slice(0, 3)}</i><div><b>{subject.name}</b><small>/{subject.slug}</small></div></div>
        <span className="admin-table-muted">Semester {subject.semester_number}</span>
        <button className={`admin-publish-toggle ${subject.is_published ? "live" : "draft"}`} disabled={pending} onClick={() => run(() => setSubjectPublished(subject.id, !subject.is_published))}><i/>{subject.is_published ? "Published" : "Draft"}</button>
        <div className="admin-row-actions"><button onClick={() => { setEditing(subject); setCreating(false); }}>Edit</button><button className="danger" onClick={() => { if (window.confirm(`Delete ${subject.name}? This only works when it has no content.`)) run(() => deleteSubject(subject.id)); }}>Delete</button></div>
      </div>) : <div className="admin-empty"><b>No subjects in Semester {semester}</b><p>Add the first subject or select another semester.</p></div>}
    </div>
    {active && <div className="admin-drawer-backdrop" onMouseDown={() => { setEditing(null); setCreating(false); }}><aside className="admin-drawer wide" onMouseDown={(event) => event.stopPropagation()}><div className="admin-drawer-head"><div><span>{active.id ? "EDIT SUBJECT" : "NEW SUBJECT"}</span><h2>{active.id ? active.name : "Add subject"}</h2></div><button onClick={() => { setEditing(null); setCreating(false); }}>×</button></div><form action={(formData) => run(() => saveSubject(formData), true)}>
      <input type="hidden" name="id" value={active.id}/><div className="admin-form-grid"><label><span>Subject name</span><input name="name" defaultValue={active.name} required onChange={(event) => { if (!active.id) { const slug = event.currentTarget.form?.elements.namedItem("slug") as HTMLInputElement | null; if (slug) slug.value = slugify(event.target.value); } }}/></label><label><span>Short code</span><input name="short_code" defaultValue={active.short_code} maxLength={12} required/></label><label><span>URL slug</span><input name="slug" defaultValue={active.slug} required/></label><label><span>Semester</span><select name="semester_number" defaultValue={active.semester_number}>{semesters.map((item) => <option key={item.id} value={item.semester_number}>{item.title}</option>)}</select></label></div><label><span>Student-facing description</span><textarea name="description" defaultValue={active.description} rows={3}/></label><div className="admin-form-grid"><label><span>Display order</span><input name="sort_order" type="number" min="0" defaultValue={active.sort_order}/></label><label><span>Visibility</span><select name="is_published" defaultValue={String(active.is_published)}><option value="true">Published</option><option value="false">Draft</option></select></label></div><p className="admin-derived-note">Material counts are calculated automatically from published syllabus units, notes, PYQs, resources and flashcards.</p><fieldset className="admin-accent"><legend>Accent colour</legend>{accents.map((color) => <label key={color} style={{ background: color }}><input type="radio" name="accent_color" value={color} defaultChecked={active.accent_color.toUpperCase() === color}/><span>✓</span></label>)}</fieldset><div className="admin-form-actions"><button type="button" onClick={() => { setEditing(null); setCreating(false); }}>Cancel</button><button className="primary" disabled={pending}>{pending ? "Saving…" : "Save subject"}</button></div>
    </form></aside></div>}
  </>;
}
