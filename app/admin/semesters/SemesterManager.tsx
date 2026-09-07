"use client";

import { useState, useTransition } from "react";
import { deleteSemester, moveSemester, saveSemester, setSemesterStatus } from "../content-actions";
import type { AdminActionResult, SemesterRecord, SemesterStatus } from "../types";

const blank: Omit<SemesterRecord, "id"> = { course_code: "BMS", semester_number: 1, title: "Semester 1", status: "coming_soon", sort_order: 1 };

export default function SemesterManager({ semesters }: { semesters: SemesterRecord[] }) {
  const [editing, setEditing] = useState<SemesterRecord | null>(null);
  const [creating, setCreating] = useState(false);
  const [notice, setNotice] = useState<AdminActionResult | null>(null);
  const [pending, startTransition] = useTransition();
  const active = editing ?? (creating ? { id: "", ...blank, semester_number: Math.min(8, semesters.length + 1), title: `Semester ${Math.min(8, semesters.length + 1)}`, sort_order: semesters.length + 1 } : null);

  function run(action: () => Promise<AdminActionResult>, close = false) {
    startTransition(async () => { const result = await action(); setNotice(result); if (result.ok && close) { setEditing(null); setCreating(false); } });
  }

  return <>
    <div className="admin-toolbar"><div><b>{semesters.length} semesters</b><span>Control what students can discover.</span></div><button onClick={() => { setCreating(true); setEditing(null); }}>+ Add semester</button></div>
    {notice && <div className={`admin-notice ${notice.ok ? "success" : "error"}`}>{notice.message}<button onClick={() => setNotice(null)}>×</button></div>}
    <div className="admin-table-card"><div className="admin-table-head"><span>ORDER</span><span>SEMESTER</span><span>STATUS</span><span>SUBJECTS</span><span>ACTIONS</span></div>
      {semesters.map((semester, index) => <div className="admin-table-row" key={semester.id}>
        <div className="admin-order"><button disabled={pending || index === 0} onClick={() => run(() => moveSemester(semester.id, "up"))}>↑</button><button disabled={pending || index === semesters.length - 1} onClick={() => run(() => moveSemester(semester.id, "down"))}>↓</button></div>
        <div className="admin-entity"><i>{semester.semester_number}</i><div><b>{semester.title}</b><small>BMS · position {semester.sort_order}</small></div></div>
        <select className={`admin-status-select ${semester.status}`} value={semester.status} disabled={pending} onChange={(event) => run(() => setSemesterStatus(semester.id, event.target.value as SemesterStatus))}><option value="published">Published</option><option value="coming_soon">Coming soon</option><option value="draft">Draft</option><option value="archived">Archived</option></select>
        <span className="admin-table-muted">Managed below</span>
        <div className="admin-row-actions"><button onClick={() => { setEditing(semester); setCreating(false); }}>Edit</button><button className="danger" onClick={() => { if (window.confirm(`Delete ${semester.title}? This only works when it has no subjects.`)) run(() => deleteSemester(semester.id, semester.semester_number)); }}>Delete</button></div>
      </div>)}
    </div>
    {active && <div className="admin-drawer-backdrop" onMouseDown={() => { setEditing(null); setCreating(false); }}><aside className="admin-drawer" onMouseDown={(event) => event.stopPropagation()}><div className="admin-drawer-head"><div><span>{active.id ? "EDIT SEMESTER" : "NEW SEMESTER"}</span><h2>{active.id ? active.title : "Add semester"}</h2></div><button onClick={() => { setEditing(null); setCreating(false); }}>×</button></div><form action={(formData) => run(() => saveSemester(formData), true)}>
      <input type="hidden" name="id" value={active.id}/><label><span>Semester number</span><input name="semester_number" type="number" min="1" max="8" defaultValue={active.semester_number} required/></label><label><span>Title</span><input name="title" defaultValue={active.title} required/></label><label><span>Visibility status</span><select name="status" defaultValue={active.status}><option value="published">Published</option><option value="coming_soon">Coming soon</option><option value="draft">Draft</option><option value="archived">Archived</option></select></label><label><span>Display order</span><input name="sort_order" type="number" min="0" defaultValue={active.sort_order}/></label><div className="admin-form-actions"><button type="button" onClick={() => { setEditing(null); setCreating(false); }}>Cancel</button><button className="primary" disabled={pending}>{pending ? "Saving…" : "Save semester"}</button></div>
    </form></aside></div>}
  </>;
}
