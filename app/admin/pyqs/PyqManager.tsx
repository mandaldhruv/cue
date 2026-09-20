"use client";

import { createBrowserClient } from "@insforge/sdk/ssr";
import { useMemo, useRef, useState, useTransition } from "react";
import AdminScopePicker from "../AdminScopePicker";
import { deletePyq, savePyq, setPyqPublished } from "../content-actions";
import type { AdminActionResult, PyqRecord, SubjectRecord } from "../types";

const emptyPaper = (subjectId: string, order: number): PyqRecord => ({ id: "", subject_id: subjectId, content_type: "pyq", title: "", description: "", body: "", academic_year: new Date().getFullYear(), exam_type: "University Exam", file_url: "", file_key: "", file_name: null, file_size_bytes: null, sort_order: order, is_published: false });
function bytes(value: number | null) { if (!value) return "PDF"; return value > 1024 * 1024 ? `${(value / 1024 / 1024).toFixed(1)} MB` : `${Math.ceil(value / 1024)} KB`; }
function safeName(name: string) { return name.toLowerCase().replace(/[^a-z0-9.-]+/g, "-").replace(/-+/g, "-"); }
function withTimeout<T>(promise: Promise<T>, milliseconds: number, message: string) {
  return Promise.race<T>([promise, new Promise<T>((_, reject) => window.setTimeout(() => reject(new Error(message)), milliseconds))]);
}

export default function PyqManager({ subjects, papers }: { subjects: SubjectRecord[]; papers: PyqRecord[] }) {
  const [semester, setSemester] = useState(subjects[0]?.semester_number ?? 3);
  const [subjectId, setSubjectId] = useState(subjects[0]?.id ?? "");
  const [year, setYear] = useState<number | "all">("all");
  const [editing, setEditing] = useState<PyqRecord | null>(null);
  const [creating, setCreating] = useState(false);
  const [notice, setNotice] = useState<AdminActionResult | null>(null);
  const [uploading, setUploading] = useState(false);
  const [uploadStage, setUploadStage] = useState<"idle" | "uploading" | "saving">("idle");
  const [submissionId, setSubmissionId] = useState("");
  const [selectedFileName, setSelectedFileName] = useState("");
  const submittingRef = useRef(false);
  const [pending, startTransition] = useTransition();
  const subjectPapers = useMemo(() => papers.filter((paper) => paper.subject_id === subjectId), [papers, subjectId]);
  const years = useMemo(() => [...new Set(subjectPapers.map((paper) => paper.academic_year))].sort((a, b) => b - a), [subjectPapers]);
  const visible = year === "all" ? subjectPapers : subjectPapers.filter((paper) => paper.academic_year === year);
  const active = editing ?? (creating ? emptyPaper(subjectId, subjectPapers.length + 1) : null);
  const selectedSubject = subjects.find((subject) => subject.id === subjectId);

  function run(action: () => Promise<AdminActionResult>, close = false) { startTransition(async () => { const result = await action(); setNotice(result); if (result.ok && close) { setEditing(null); setCreating(false); } }); }
  function openCreator() { setSubmissionId(crypto.randomUUID()); setSelectedFileName(""); setCreating(true); setEditing(null); setNotice(null); }
  function closeEditor() { if (!uploading) { setSelectedFileName(""); setEditing(null); setCreating(false); } }

  async function submit(formData: FormData) {
    if (submittingRef.current) return;
    submittingRef.current = true;
    setUploading(true);
    setUploadStage("uploading");
    setNotice(null);
    let uploadedKey = "";
    try {
      const file = formData.get("pdf") as File | null;
      const stableSubmissionId = String(formData.get("submission_id") || crypto.randomUUID());
      formData.set("submission_id", stableSubmissionId);
      setSubmissionId(stableSubmissionId);
      if (file?.size) {
        if (file.type !== "application/pdf" && !file.name.toLowerCase().endsWith(".pdf")) throw new Error("Please choose a PDF file.");
        if (file.size > 25 * 1024 * 1024) throw new Error("Keep each PDF under 25 MB.");
        const key = `${subjectId}/${formData.get("academic_year")}/${stableSubmissionId}-${safeName(file.name)}`;
        const client = createBrowserClient();
        const { data, error } = await withTimeout(client.storage.from("cue-pyqs").upload(key, file), 90_000, "The PDF upload timed out. Check your connection and try again. The same paper will not be duplicated.");
        if (error || !data) throw new Error(error?.message ?? "PDF upload failed. Please try again.");
        uploadedKey = data.key;
        formData.set("file_url", data.url);
        formData.set("file_key", data.key);
        formData.set("file_name", file.name);
        formData.set("file_size_bytes", String(file.size));
      }
      // The PDF is already stored directly in InsForge. Never send its binary
      // through the Next.js server action as that can exceed the action body
      // limit and turn an otherwise successful upload into a 500 response.
      formData.delete("pdf");
      setUploadStage("saving");
      const result = await withTimeout(savePyq(formData), 30_000, "The PDF uploaded, but saving took too long. Please try once more; the retry is duplicate-safe.");
      if (!result.ok && uploadedKey) await withTimeout(createBrowserClient().storage.from("cue-pyqs").remove(uploadedKey), 15_000, "").catch(() => undefined);
      setNotice(result.ok ? { ok: true, message: `✓ ${active?.id ? "Paper updated successfully." : "PDF uploaded and saved successfully."}` } : result);
      if (result.ok) { setSelectedFileName(""); setEditing(null); setCreating(false); setSubmissionId(""); }
    } catch (error) {
      setNotice({ ok: false, message: error instanceof Error && error.message ? error.message : "The PDF could not be uploaded. Please try again." });
    } finally {
      setUploadStage("idle");
      setUploading(false);
      submittingRef.current = false;
    }
  }

  if (!subjects.length) return <div className="admin-empty content-empty"><b>Create a subject first</b><p>Every paper must belong to a BMS subject.</p><a href="/admin/subjects">Open Subject Management →</a></div>;

  return <>
    <AdminScopePicker subjects={subjects} semester={semester} subjectId={subjectId} context="PYQs & PDFs" detail={`${selectedSubject?.name ?? "Select a subject"} → PYQs`} onSemesterChange={(nextSemester, firstSubjectId) => { setSemester(nextSemester); setSubjectId(firstSubjectId); setYear("all"); setEditing(null); setCreating(false); setNotice(null); }} onSubjectChange={(nextSubjectId) => { setSubjectId(nextSubjectId); setYear("all"); setEditing(null); setCreating(false); setNotice(null); }}/>
    <div className="pyq-admin-controls"><label><span>ACADEMIC YEAR</span><select value={year} onChange={(event) => setYear(event.target.value === "all" ? "all" : Number(event.target.value))}><option value="all">All years</option>{years.map((item) => <option key={item} value={item}>{item}</option>)}</select></label><button onClick={openCreator}>+ Upload paper</button></div>
    <div className="pyq-admin-summary"><div><span>PDF LIBRARY</span><b>{selectedSubject?.name}</b></div><div><b>{subjectPapers.length}</b><span>TOTAL PAPERS</span></div><div><b>{subjectPapers.filter((paper) => paper.is_published).length}</b><span>PUBLISHED</span></div><div><b>{years.length}</b><span>YEARS</span></div></div>
    {notice && <div className={`admin-notice ${notice.ok ? "success" : "error"}`}>{notice.message}<button onClick={() => setNotice(null)}>×</button></div>}
    <div className="pyq-admin-list">{visible.length ? visible.map((paper) => <article key={paper.id}><div className="pyq-file-icon"><span>PDF</span><b>{paper.academic_year}</b></div><div className="pyq-file-copy"><div><h3>{paper.title}</h3><span className={paper.is_published ? "live" : "draft"}>{paper.is_published ? "Published" : "Draft"}</span></div><p>{paper.exam_type} · {bytes(paper.file_size_bytes)} · {paper.file_name ?? "Uploaded PDF"}</p><small>{paper.description || "No description added."}</small></div><div className="pyq-file-actions"><button className={`admin-publish-toggle ${paper.is_published ? "live" : "draft"}`} disabled={pending} onClick={() => run(() => setPyqPublished(paper.id, !paper.is_published))}><i/>{paper.is_published ? "Live" : "Draft"}</button><button onClick={() => { setSelectedFileName(""); setEditing(paper); setCreating(false); }}>Edit / replace</button><button className="danger" onClick={() => { if (window.confirm(`Delete “${paper.title}” and its PDF permanently?`)) run(() => deletePyq(paper.id, paper.file_key)); }}>Delete</button></div></article>) : <div className="admin-empty"><div className="content-empty-mark">PDF</div><b>No papers here yet</b><p>Upload the first previous-year paper for {selectedSubject?.name}.</p><button onClick={openCreator}>Upload a paper →</button></div>}</div>
    {active && <div className="admin-drawer-backdrop" onMouseDown={closeEditor}><aside className="admin-drawer wide" onMouseDown={(event) => event.stopPropagation()}><div className="admin-drawer-head"><div><span>{active.id ? "EDIT / REPLACE PAPER" : "UPLOAD NEW PAPER"}</span><h2>{active.id ? active.title : "Add PYQ PDF"}</h2></div><button type="button" disabled={uploading} onClick={closeEditor}>×</button></div><form action={submit}>
      <input type="hidden" name="id" value={active.id}/><input type="hidden" name="submission_id" value={submissionId}/><input type="hidden" name="subject_id" value={active.subject_id}/><input type="hidden" name="file_url" value={active.file_url}/><input type="hidden" name="file_key" value={active.file_key}/><input type="hidden" name="old_file_key" value={active.file_key}/><input type="hidden" name="file_name" value={active.file_name ?? ""}/><input type="hidden" name="file_size_bytes" value={active.file_size_bytes ?? ""}/><label><span>Paper title</span><input name="title" defaultValue={active.title} placeholder="e.g. Advertising, April 2025 Paper" required disabled={uploading}/></label><div className="admin-form-grid"><label><span>Academic year</span><input name="academic_year" type="number" min="2000" max="2100" defaultValue={active.academic_year} required disabled={uploading}/></label><label><span>Exam type</span><select name="exam_type" defaultValue={active.exam_type} disabled={uploading}><option>University Exam</option><option>Regular Examination</option><option>ATKT Examination</option><option>Internal Assessment</option><option>Model Paper</option></select></label></div><label><span>Description</span><textarea name="description" defaultValue={active.description} rows={3} placeholder="Optional context for students" disabled={uploading}/></label><div className={`pdf-upload-field ${selectedFileName ? "has-file" : ""}`}><span>{active.file_key ? "Replace PDF (optional)" : "PDF file"}</span><input id="pyq-pdf-file" className="sr-only" name="pdf" type="file" accept="application/pdf,.pdf" required={!active.file_key} disabled={uploading} onChange={(event) => setSelectedFileName(event.target.files?.[0]?.name ?? "")}/><label className="pdf-file-picker" htmlFor="pyq-pdf-file"><i>PDF</i><span><b>{selectedFileName || (active.file_key ? "Choose a replacement PDF" : "Choose a PDF file")}</b><small>{selectedFileName ? "PDF selected and ready to upload" : "PDF only · maximum 25 MB"}</small></span><em>{selectedFileName ? "Change" : "Browse"}</em></label>{!selectedFileName && active.file_name && <small>Current: {active.file_name} · {bytes(active.file_size_bytes)}</small>}</div><div className="admin-form-grid"><label><span>Display order</span><input name="sort_order" type="number" min="0" defaultValue={active.sort_order} disabled={uploading}/></label><label><span>Visibility</span><select name="is_published" defaultValue={String(active.is_published)} disabled={uploading}><option value="true">Published</option><option value="false">Draft</option></select></label></div>{uploadStage !== "idle" && <div className="pdf-upload-progress" role="status" aria-live="polite"><i/><div><b>{uploadStage === "uploading" ? "Uploading PDF…" : "Saving paper…"}</b><small>{uploadStage === "uploading" ? "Keep this window open. Only one upload is being processed." : "Upload complete. Finishing the library entry."}</small></div></div>}<div className="admin-form-actions"><button type="button" disabled={uploading} onClick={closeEditor}>Cancel</button><button className="primary" disabled={pending || uploading}>{uploadStage === "uploading" ? "Uploading PDF…" : uploadStage === "saving" ? "Saving paper…" : pending ? "Saving…" : active.id ? "Save changes" : "Upload paper"}</button></div>
    </form></aside></div>}
  </>;
}
