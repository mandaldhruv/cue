"use client";

import { createClient } from "@insforge/sdk";
import { useEffect, useMemo, useRef, useState } from "react";

type PublicSubject = { id: string; name: string; slug: string; short_code: string; semester_number: number; accent_color: string };
type PublicPaper = { id: string; subject_id: string; title: string; description: string; academic_year: number; exam_type: string; file_key: string; file_name: string | null; file_size_bytes: number | null };
function sizeLabel(value: number | null) { if (!value) return "PDF"; return value > 1024 * 1024 ? `${(value / 1024 / 1024).toFixed(1)} MB` : `${Math.ceil(value / 1024)} KB`; }

export default function PyqLibrary({ subjectSlug, compact = false }: { subjectSlug?: string; compact?: boolean }) {
  const isConfigured = Boolean(process.env.NEXT_PUBLIC_INSFORGE_URL && process.env.NEXT_PUBLIC_INSFORGE_ANON_KEY);
  const [subjects, setSubjects] = useState<PublicSubject[]>([]);
  const [papers, setPapers] = useState<PublicPaper[]>([]);
  const [subjectId, setSubjectId] = useState("all");
  const [year, setYear] = useState<number | "all">("all");
  const [loading, setLoading] = useState(isConfigured);
  const [workingId, setWorkingId] = useState("");
  const [preview, setPreview] = useState<{ url: string; paper: PublicPaper } | null>(null);
  const previewUrlRef = useRef("");
  const [error, setError] = useState("");

  useEffect(() => {
    const baseUrl = process.env.NEXT_PUBLIC_INSFORGE_URL;
    const anonKey = process.env.NEXT_PUBLIC_INSFORGE_ANON_KEY;
    if (!baseUrl || !anonKey) return;
    const client = createClient({ baseUrl, anonKey });
    let active = true;
    async function load() {
      const { data: subjectData, error: subjectError } = await client.database.from("subjects").select("id,name,slug,short_code,semester_number,accent_color").eq("course_code", "BMS").eq("is_published", true).order("semester_number", { ascending: true }).order("sort_order", { ascending: true });
      if (!active) return;
      if (subjectError) { setError("The paper library could not be loaded right now."); setLoading(false); return; }
      const availableSubjects = (subjectData ?? []) as PublicSubject[];
      setSubjects(availableSubjects);
      const matched = subjectSlug ? availableSubjects.find((item) => item.slug === subjectSlug) : null;
      if (matched) setSubjectId(matched.id);
      const query = client.database.from("content_items").select("id,subject_id,title,description,academic_year,exam_type,file_key,file_name,file_size_bytes").eq("content_type", "pyq").eq("is_published", true).order("academic_year", { ascending: false }).order("sort_order", { ascending: true });
      const { data: paperData, error: paperError } = matched ? await query.eq("subject_id", matched.id) : await query;
      if (!active) return;
      if (paperError) setError("Published papers could not be loaded right now.");
      else setPapers((paperData ?? []) as PublicPaper[]);
      setLoading(false);
    }
    load();
    return () => { active = false; };
  }, [subjectSlug]);

  useEffect(() => () => {
    if (previewUrlRef.current) URL.revokeObjectURL(previewUrlRef.current);
  }, []);

  const years = useMemo(() => [...new Set(papers.map((paper) => paper.academic_year))].sort((a, b) => b - a), [papers]);
  const visible = useMemo(() => papers.filter((paper) => (subjectId === "all" || paper.subject_id === subjectId) && (year === "all" || paper.academic_year === year)), [papers, subjectId, year]);
  const byYear = useMemo(() => visible.reduce<Record<number, PublicPaper[]>>((groups, paper) => { (groups[paper.academic_year] ??= []).push(paper); return groups; }, {}), [visible]);

  async function getBlob(paper: PublicPaper) {
    const baseUrl = process.env.NEXT_PUBLIC_INSFORGE_URL;
    const anonKey = process.env.NEXT_PUBLIC_INSFORGE_ANON_KEY;
    if (!baseUrl || !anonKey) throw new Error("Storage is not configured.");
    const { data, error: downloadError } = await createClient({ baseUrl, anonKey }).storage.from("cue-pyqs").download(paper.file_key);
    if (downloadError || !data) throw new Error(downloadError?.message ?? "Download failed.");
    return data;
  }

  async function openPreview(paper: PublicPaper) {
    setWorkingId(paper.id); setError("");
    try {
      const blob = await getBlob(paper);
      if (previewUrlRef.current) URL.revokeObjectURL(previewUrlRef.current);
      const url = URL.createObjectURL(blob);
      previewUrlRef.current = url;
      setPreview({ paper, url });
    }
    catch { setError("This PDF could not be opened. Please try again."); }
    finally { setWorkingId(""); }
  }

  async function download(paper: PublicPaper) {
    setWorkingId(paper.id); setError("");
    try { const blob = await getBlob(paper); const url = URL.createObjectURL(blob); const anchor = document.createElement("a"); anchor.href = url; anchor.download = paper.file_name || `${paper.title}.pdf`; anchor.click(); setTimeout(() => URL.revokeObjectURL(url), 1000); }
    catch { setError("This PDF could not be downloaded. Please try again."); }
    finally { setWorkingId(""); }
  }

  return <div className={`public-pyq-library ${compact ? "compact" : ""}`}>
    {!compact && <div className="public-pyq-filters"><label><span>SUBJECT</span><select value={subjectId} onChange={(event) => setSubjectId(event.target.value)}><option value="all">All BMS subjects</option>{subjects.map((subject) => <option key={subject.id} value={subject.id}>Sem {subject.semester_number} · {subject.short_code} — {subject.name}</option>)}</select></label><label><span>YEAR</span><select value={year} onChange={(event) => setYear(event.target.value === "all" ? "all" : Number(event.target.value))}><option value="all">All years</option>{years.map((item) => <option key={item} value={item}>{item}</option>)}</select></label><div><b>{visible.length}</b><span>{visible.length === 1 ? "paper ready" : "papers ready"}</span></div></div>}
    {error && <div className="public-pyq-error">{error}</div>}
    {loading ? <div className="public-pyq-loading"><i/><i/><i/></div> : visible.length ? Object.entries(byYear).sort(([a], [b]) => Number(b) - Number(a)).map(([paperYear, yearPapers]) => <section className="public-pyq-year" key={paperYear}><header><span>{paperYear}</span><div><b>{yearPapers.length} {yearPapers.length === 1 ? "paper" : "papers"}</b><small>Previous-year archive</small></div></header><div>{yearPapers.map((paper) => { const subject = subjects.find((item) => item.id === paper.subject_id); return <article key={paper.id}><div className="public-pdf-mark" style={{ "--paper-accent": subject?.accent_color ?? "#315DE6" } as React.CSSProperties}><span>PDF</span><b>{subject?.short_code ?? "BMS"}</b></div><div className="public-paper-copy"><span>{paper.exam_type}</span><h3>{paper.title}</h3><p>{paper.description || `${paper.academic_year} examination paper for focused practice.`}</p><small>{sizeLabel(paper.file_size_bytes)} · Ready to preview</small></div><div className="public-paper-actions"><button disabled={workingId === paper.id} onClick={() => openPreview(paper)}>{workingId === paper.id ? "Opening…" : "Preview"}</button><button className="download" disabled={workingId === paper.id} onClick={() => download(paper)}>Download ↓</button></div></article>})}</div></section>) : <div className="public-pyq-empty"><div>PDF</div><h3>No published papers yet.</h3><p>We’re organising this archive. Check another subject or year soon.</p></div>}
    {preview && <div className="pdf-preview-modal" role="dialog" aria-modal="true" aria-label={`Preview ${preview.paper.title}`}><div><header><span><b>{preview.paper.title}</b><small>{preview.paper.academic_year} · {preview.paper.exam_type}</small></span><button onClick={() => { URL.revokeObjectURL(preview.url); previewUrlRef.current = ""; setPreview(null); }} aria-label="Close PDF preview">×</button></header><iframe src={preview.url} title={preview.paper.title}/><footer><button onClick={() => download(preview.paper)}>Download PDF ↓</button></footer></div></div>}
  </div>;
}
