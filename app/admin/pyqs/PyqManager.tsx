"use client";

import { createBrowserClient } from "@insforge/sdk/ssr";
import { useMemo, useRef, useState, useTransition } from "react";
import AdminScopePicker from "../AdminScopePicker";
import { deletePyq, savePyq, setPyqPublished } from "../content-actions";
import type { AdminActionResult, PyqRecord, SubjectRecord } from "../types";

const emptyPaper = (subjectId: string, order: number): PyqRecord => ({ id: "", subject_id: subjectId, content_type: "pyq", title: "", description: "", body: "", academic_year: new Date().getFullYear(), exam_type: "University Exam", file_url: "", file_key: "", file_name: null, file_size_bytes: null, sort_order: order, is_published: false });
function bytes(value: number | null) { if (!value) return "PDF"; return value > 1024 * 1024 ? `${(value / 1024 / 1024).toFixed(1)} MB` : `${Math.ceil(value / 1024)} KB`; }
function safeName(name: string) { return name.toLowerCase().replace(/[^a-z0-9.-]+/g, "-").replace(/-+/g, "-"); }

export default function PyqManager({ subjects, papers }: { subjects: SubjectRecord[]; papers: PyqRecord[] }) {
  const [semester, setSemester] = useState(subjects[0]?.semester_number ?? 3);
  const [subjectId, setSubjectId] = useState(subjects[0]?.id ?? "");
  const [year, setYear] = useState<number | "all">("all");
  const [editing, setEditing] = useState<PyqRecord | null>(null);
  const [creating, setCreating] = useState(false);
  const [notice, setNotice] = useState<AdminActionResult | null>(null);
  const [uploading, setUploading] = useState(false);
  const [submissionId, setSubmissionId] = useState("");
  const submittingRef = useRef(false);
  const [pending, startTransition] = useTransition();
  const subjectPapers = useMemo(() => papers.filter((paper) => paper.subject_id === subjectId), [papers, subjectId]);
  const years = useMemo(() => [...new Set(subjectPapers.map((paper) => paper.academic_year))].sort((a, b) => b - a), [subjectPapers]);
  const visible = year === "all" ? subjectPapers : subjectPapers.filter((paper) => paper.academic_year === year);
  const active = editing ?? (creating ? emptyPaper(subjectId, subjectPapers.length + 1) : null);
  const selectedSubject = subjects.find((subject) => subject.id === subjectId);

  function run(action: () => Promise<AdminActionResult>, close = false) { startTransition(async () => { const result = await action(); setNotice(result); if (result.ok && close) { setEditing(null); setCreating(false); } }); }

  async function submit(formData: FormData) {
    if (submittingRef.current) return;
    submittingRef.current = true;
    setUploading(true);
    const file = formData.get("pdf") as File | null;
    let uploadedKey = "";
    if (file?.size) {
      if (file.type !== "application/pdf" && !file.name.toLowerCase().endsWith(".pdf")) { setNotice({ ok: false, message: "Please choose a PDF file." }); setUploading(false); submittingRef.current = false; return; }
      if (file.size > 25 * 1024 * 1024) { setNotice({ ok: false, message: "Keep each PDF under 25 MB." }); setUploading(false); submittingRef.current = false; return; }
      const stableSubmissionId = String(formData.get("submission_id") || crypto.randomUUID());
      formData.set("submission_id", stableSubmissionId);
      const key = `${subjectId}/${formData.get("academic_year")}/${stableSubmissionId}-${safeName(file.name)}`;
      const client = createBrowserClient();
      const { data, error } = await client.storage.from("cue-pyqs").upload(key, file);
      if (error || !data) { setNotice({ ok: false, message: error?.message ?? "PDF upload failed." }); setUploading(false); submittingRef.current = false; return; }
      uploadedKey = data.key;
      formData.set("file_url", data.url);
      formData.set("file_key", data.key);
      formData.set("file_name", file.name);
      formData.set("file_size_bytes", String(file.size));
    }
    const result = await savePyq(formData);
    if (!result.ok && uploadedKey) await createBrowserClient().storage.from("cue-pyqs").remove(uploadedKey);
    setNotice(result);
    if (result.ok) { setEditing(null); setCreating(false); }
    setUploading(false);
    submittingRef.current = false;
  }

  if (!subjects.length) return <div className="admin-empty content-empty"><b>Create a subject first</b><p>Every paper must belong to a BMS subject.</p><a href="/admin/subjects">Open Subject Management →</a></div>;

  return <>
    <AdminScopePicker subjects={subjects} semester={semester} subjectId={subjectId} context="PYQs & PDFs" detail={`${selectedSubject?.name ?? "Select a subject"} → PYQs`} onSemesterChange={(nextSemester, firstSubjectId) => { setSemester(nextSemester); setSubjectId(firstSubjectId); setYear("all"); setEditing(null); setCreating(false); setNotice(null); }} onSubjectChange={(nextSubjectId) => { setSubjectId(nextSubjectId); setYear("all"); setEditing(null); setCreating(false); setNotice(null); }}/>
    <div className="pyq-admin-controls"><label><span>ACADEMIC YEAR</span><select value={year} onChange={(event) => setYear(event.target.value === "all" ? "all" : Number(event.target.value))}><option value="all">All years</option>{years.map((item) => <option key={item} value={item}>{item}</option>)}</select></label><button onClick={() => { setSubmissionId(crypto.randomUUID()); setCreating(true); setEditing(null); }}>+ Upload paper</button></div>
    <div className="pyq-admin-summary"><div><span>PDF LIBRARY</span><b>{selectedSubject?.name}</b></div><div><b>{subjectPapers.length}</b><span>TOTAL PAPERS</span></div><div><b>{subjectPapers.filter((paper) => paper.is_published).length}</b><span>PUBLISHED</span></div><div><b>{years.length}</b><span>YEARS</span></div></div>
    {notice && <div className={`admin-notice ${notice.ok ? "success" : "error"}`}>{notice.message}<button onClick={() => setNotice(null)}>×</button></div>}
    <div className="pyq-admin-list">{visible.length ? visible.map((paper) => <article key={paper.id}><div className="pyq-file-icon"><span>PDF</span><b>{paper.academic_year}</b></div><div className="pyq-file-copy"><div><h3>{paper.title}</h3><span className={paper.is_published ? "live" : "draft"}>{paper.is_published ? "Published" : "Draft"}</span></div><p>{paper.exam_type} · {bytes(paper.file_size_bytes)} · {paper.file_name ?? "Uploaded PDF"}</p><small>{paper.description || "No description added."}</small></div><div className="pyq-file-actions"><button className={`admin-publish-toggle ${paper.is_published ? "live" : "draft"}`} disabled={pending} onClick={() => run(() => setPyqPublished(paper.id, !paper.is_published))}><i/>{paper.is_published ? "Live" : "Draft"}</button><button onClick={() => { setEditing(paper); setCreating(false); }}>Edit / replace</button><button className="danger" onClick={() => { if (window.confirm(`Delete “${paper.title}” and its PDF permanently?`)) run(() => deletePyq(paper.id, paper.file_key)); }}>Delete</button></div></article>) : <div className="admin-empty"><div className="content-empty-mark">PDF</div><b>No papers here yet</b><p>Upload the first previous-year paper for {selectedSubject?.name}.</p><button onClick={() => setCreating(true)}>Upload a paper →</button></div>}</div>
    {active && <div className="admin-drawer-backdrop" onMouseDown={() => { setEditing(null); setCreating(false); }}><aside className="admin-drawer wide" onMouseDown={(event) => event.stopPropagation()}><div className="admin-drawer-head"><div><span>{active.id ? "EDIT / REPLACE PAPER" : "UPLOAD NEW PAPER"}</span><h2>{active.id ? active.title : "Add PYQ PDF"}</h2></div><button onClick={() => { setEditing(null); setCreating(false); }}>×</button></div><form action={submit}>
      <input type="hidden" name="id" value={active.id}/><input type="hidden" name="submission_id" value={submissionId}/><input type="hidden" name="subject_id" value={active.subject_id}/><input type="hidden" name="file_url" value={active.file_url}/><input type="hidden" name="file_key" value={active.file_key}/><input type="hidden" name="old_file_key" value={active.file_key}/><input type="hidden" name="file_name" value={active.file_name ?? ""}/><input type="hidden" name="file_size_bytes" value={active.file_size_bytes ?? ""}/><label><span>Paper title</span><input name="title" defaultValue={active.title} placeholder="e.g. Advertising — April 2025 Paper" required/></label><div className="admin-form-grid"><label><span>Academic year</span><input name="academic_year" type="number" min="2000" max="2100" defaultValue={active.academic_year} required/></label><label><span>Exam type</span><select name="exam_type" defaultValue={active.exam_type}><option>University Exam</option><option>Regular Examination</option><option>ATKT Examination</option><option>Internal Assessment</option><option>Model Paper</option></select></label></div><label><span>Description</span><textarea name="description" defaultValue={active.description} rows={3} placeholder="Optional context for students"/></label><label className="pdf-upload-field"><span>{active.file_key ? "Replace PDF (optional)" : "PDF file"}</span><input name="pdf" type="file" accept="application/pdf,.pdf" required={!active.file_key}/>{active.file_name && <small>Current: {active.file_name} · {bytes(active.file_size_bytes)}</small>}</label><div className="admin-form-grid"><label><span>Display order</span><input name="sort_order" type="number" min="0" defaultValue={active.sort_order}/></label><label><span>Visibility</span><select name="is_published" defaultValue={String(active.is_published)}><option value="true">Published</option><option value="false">Draft</option></select></label></div><div className="admin-form-actions"><button type="button" onClick={() => { setEditing(null); setCreating(false); }}>Cancel</button><button className="primary" disabled={pending || uploading}>{uploading ? "Uploading and saving…" : pending ? "Saving…" : active.id ? "Save changes" : "Upload paper"}</button></div>
    </form></aside></div>}
  </>;
}
