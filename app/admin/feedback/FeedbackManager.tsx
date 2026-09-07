"use client";

import { createBrowserClient } from "@insforge/sdk/ssr";
import { useMemo, useRef, useState, useTransition } from "react";
import type { AdminActionResult, FeedbackRecord, FeedbackStatus, TestimonialRecord } from "../types";
import { deleteTestimonial, saveTestimonial, updateFeedback } from "./actions";

const emptyTestimonial: TestimonialRecord = { id: "", person_name: "", designation: "", institution: "", quote: "", headshot_url: null, headshot_key: null, image_alt: "", rating: 5, is_featured: false, is_published: false, consent_confirmed: false, consent_note: "", sort_order: 1, created_at: "" };
const statuses: FeedbackStatus[] = ["new", "reviewed", "resolved", "archived"];
const safeName = (value: string) => value.toLowerCase().replace(/[^a-z0-9.-]+/g, "-").replace(/-+/g, "-");
const initials = (name: string) => name.split(/\s+/).map((part) => part[0]).join("").slice(0, 2).toUpperCase();

export default function FeedbackManager({ feedback, testimonials }: { feedback: FeedbackRecord[]; testimonials: TestimonialRecord[] }) {
  const [tab, setTab] = useState<"feedback" | "testimonials">("feedback");
  const [filter, setFilter] = useState<FeedbackStatus | "all">("all");
  const [selectedFeedback, setSelectedFeedback] = useState<FeedbackRecord | null>(null);
  const [editing, setEditing] = useState<TestimonialRecord | null>(null);
  const [creating, setCreating] = useState(false);
  const [notice, setNotice] = useState<AdminActionResult | null>(null);
  const [uploading, setUploading] = useState(false);
  const submittingRef = useRef(false);
  const [pending, startTransition] = useTransition();
  const visibleFeedback = useMemo(() => filter === "all" ? feedback : feedback.filter((item) => item.status === filter), [feedback, filter]);
  const activeTestimonial = editing ?? (creating ? { ...emptyTestimonial, sort_order: testimonials.length + 1 } : null);

  function run(action: () => Promise<AdminActionResult>, close = false) {
    startTransition(async () => { const result = await action(); setNotice(result); if (result.ok && close) { setSelectedFeedback(null); setEditing(null); setCreating(false); } });
  }

  async function submitTestimonial(formData: FormData) {
    if (submittingRef.current) return;
    submittingRef.current = true;
    setUploading(true);
    const file = formData.get("headshot") as File | null;
    let uploadedKey = "";
    if (file?.size) {
      if (!file.type.startsWith("image/")) { setNotice({ ok: false, message: "Choose a JPG, PNG or WebP headshot." }); setUploading(false); submittingRef.current = false; return; }
      if (file.size > 5 * 1024 * 1024) { setNotice({ ok: false, message: "Keep the headshot under 5 MB." }); setUploading(false); submittingRef.current = false; return; }
      const key = `${formData.get("id") || crypto.randomUUID()}/${crypto.randomUUID()}-${safeName(file.name)}`;
      const { data, error } = await createBrowserClient().storage.from("cue-testimonials").upload(key, file);
      if (error || !data) { setNotice({ ok: false, message: error?.message ?? "Headshot upload failed." }); setUploading(false); submittingRef.current = false; return; }
      uploadedKey = data.key;
      formData.set("headshot_url", data.url);
      formData.set("headshot_key", data.key);
    }
    const result = await saveTestimonial(formData);
    if (!result.ok && uploadedKey) await createBrowserClient().storage.from("cue-testimonials").remove(uploadedKey);
    setNotice(result);
    if (result.ok) { setEditing(null); setCreating(false); }
    setUploading(false);
    submittingRef.current = false;
  }

  return <>
    <div className="community-overview">
      <div><span>NEW FEEDBACK</span><b>{feedback.filter((item) => item.status === "new").length}</b><small>Waiting for review</small></div>
      <div><span>AVERAGE RATING</span><b>{feedback.length ? (feedback.reduce((sum, item) => sum + item.rating, 0) / feedback.length).toFixed(1) : "—"}</b><small>Student experience</small></div>
      <div><span>LIVE TESTIMONIALS</span><b>{testimonials.filter((item) => item.is_published).length}</b><small>Visible publicly</small></div>
      <button onClick={() => { setTab("testimonials"); setCreating(true); setEditing(null); }}>+ Add testimonial</button>
    </div>
    <div className="community-tabs"><button className={tab === "feedback" ? "active" : ""} onClick={() => setTab("feedback")}><span>Student feedback</span><b>{feedback.length}</b></button><button className={tab === "testimonials" ? "active" : ""} onClick={() => setTab("testimonials")}><span>Testimonials</span><b>{testimonials.length}</b></button></div>
    {notice && <div className={`admin-notice ${notice.ok ? "success" : "error"}`}>{notice.message}<button onClick={() => setNotice(null)}>×</button></div>}

    {tab === "feedback" ? <section className="feedback-inbox">
      <div className="feedback-inbox-bar"><div><b>Student inbox</b><span>Private responses—never shown publicly.</span></div><label><span>STATUS</span><select value={filter} onChange={(event) => setFilter(event.target.value as FeedbackStatus | "all")}><option value="all">All feedback</option>{statuses.map((status) => <option key={status} value={status}>{status[0].toUpperCase() + status.slice(1)}</option>)}</select></label></div>
      <div className="feedback-inbox-list">{visibleFeedback.length ? visibleFeedback.map((item) => <button key={item.id} onClick={() => setSelectedFeedback(item)}><span className={`feedback-rating rating-${item.rating}`}>{"★".repeat(item.rating)}</span><div><span>{item.category} · {item.student_year}</span><b>{item.message}</b><small>{new Date(item.created_at).toLocaleDateString("en-IN", { day: "numeric", month: "short", year: "numeric" })}{item.is_content_issue ? " · Content issue" : ""}</small></div><i className={`feedback-status ${item.status}`}>{item.status}</i><strong>→</strong></button>) : <div className="admin-empty"><b>No feedback in this view</b><p>New student responses will appear here automatically.</p></div>}</div>
    </section> : <section className="testimonial-admin-list">
      <div className="admin-toolbar"><div><b>Curated voices</b><span>Only consented, published testimonials appear on the student Feedback page.</span></div><button onClick={() => { setCreating(true); setEditing(null); }}>+ Add testimonial</button></div>
      {testimonials.length ? <div className="testimonial-admin-grid">{testimonials.map((item) => <article key={item.id} className={item.is_featured ? "featured" : ""}><div className="testimonial-admin-person"><span>{initials(item.person_name)}</span><div><b>{item.person_name}</b><small>{item.designation}{item.institution ? ` · ${item.institution}` : ""}</small></div></div><blockquote>“{item.quote}”</blockquote><footer><span className={item.is_published ? "live" : "draft"}>{item.is_published ? "Published" : "Draft"}</span>{item.is_featured && <span className="featured">Featured</span>}<button onClick={() => { setEditing(item); setCreating(false); }}>Edit</button><button className="danger" onClick={() => { if (window.confirm(`Delete ${item.person_name}’s testimonial?`)) run(() => deleteTestimonial(item.id, item.headshot_key ?? "")); }}>Delete</button></footer></article>)}</div> : <div className="admin-empty testimonial-empty"><b>No testimonials yet</b><p>Add an honest, consented quote from a principal, HOD or teacher.</p><button onClick={() => setCreating(true)}>Create the first testimonial →</button></div>}
    </section>}

    {selectedFeedback && <div className="admin-drawer-backdrop" onMouseDown={() => setSelectedFeedback(null)}><aside className="admin-drawer" onMouseDown={(event) => event.stopPropagation()}><div className="admin-drawer-head"><div><span>STUDENT FEEDBACK</span><h2>{selectedFeedback.rating}/5 experience</h2></div><button onClick={() => setSelectedFeedback(null)}>×</button></div><div className="feedback-detail-card"><span>{selectedFeedback.category} · {selectedFeedback.student_year}</span><blockquote>“{selectedFeedback.message}”</blockquote>{selectedFeedback.email && <small>Reply email: {selectedFeedback.email}</small>}{selectedFeedback.is_content_issue && <b>⚑ Incorrect or outdated content reported</b>}</div><form action={(formData) => run(() => updateFeedback(formData), true)}><input type="hidden" name="id" value={selectedFeedback.id}/><label><span>Status</span><select name="status" defaultValue={selectedFeedback.status}>{statuses.map((status) => <option key={status} value={status}>{status[0].toUpperCase() + status.slice(1)}</option>)}</select></label><label><span>Private admin note</span><textarea name="admin_note" defaultValue={selectedFeedback.admin_note} rows={6} placeholder="Record what was checked or changed…"/></label><div className="admin-form-actions"><button type="button" onClick={() => setSelectedFeedback(null)}>Cancel</button><button className="primary" disabled={pending}>{pending ? "Saving…" : "Save review"}</button></div></form></aside></div>}

    {activeTestimonial && <div className="admin-drawer-backdrop" onMouseDown={() => { setEditing(null); setCreating(false); }}><aside className="admin-drawer wide" onMouseDown={(event) => event.stopPropagation()}><div className="admin-drawer-head"><div><span>{activeTestimonial.id ? "EDIT TESTIMONIAL" : "NEW TESTIMONIAL"}</span><h2>{activeTestimonial.id ? activeTestimonial.person_name : "Add a trusted voice"}</h2></div><button onClick={() => { setEditing(null); setCreating(false); }}>×</button></div><form action={submitTestimonial}><input type="hidden" name="id" value={activeTestimonial.id}/><input type="hidden" name="headshot_url" value={activeTestimonial.headshot_url ?? ""}/><input type="hidden" name="headshot_key" value={activeTestimonial.headshot_key ?? ""}/><input type="hidden" name="old_headshot_key" value={activeTestimonial.headshot_key ?? ""}/><div className="admin-form-grid"><label><span>Name</span><input name="person_name" defaultValue={activeTestimonial.person_name} placeholder="Dr. Asha Sharma" required/></label><label><span>Designation</span><input name="designation" defaultValue={activeTestimonial.designation} placeholder="Principal / HOD / Professor" required/></label></div><label><span>Institution</span><input name="institution" defaultValue={activeTestimonial.institution} placeholder="College or department name"/></label><label><span>Testimonial</span><textarea name="quote" minLength={20} maxLength={1200} defaultValue={activeTestimonial.quote} rows={7} placeholder="Write the honest feedback exactly as it was shared…" required/></label><label className="pdf-upload-field"><span>{activeTestimonial.headshot_key ? "Replace headshot (optional)" : "Headshot (optional)"}</span><input name="headshot" type="file" accept="image/jpeg,image/png,image/webp"/><small>Professional square portrait · JPG, PNG or WebP · up to 5 MB</small></label><label><span>Image description</span><input name="image_alt" defaultValue={activeTestimonial.image_alt} placeholder="Portrait of Dr. Asha Sharma"/></label><div className="admin-form-grid"><label><span>Rating</span><select name="rating" defaultValue={activeTestimonial.rating}>{[5,4,3,2,1].map((rating) => <option key={rating} value={rating}>{rating} stars</option>)}</select></label><label><span>Display order</span><input name="sort_order" type="number" min="0" defaultValue={activeTestimonial.sort_order}/></label><label><span>Visibility</span><select name="is_published" defaultValue={String(activeTestimonial.is_published)}><option value="false">Draft</option><option value="true">Published</option></select></label></div><div className="testimonial-switches"><label><input name="is_featured" type="checkbox" defaultChecked={activeTestimonial.is_featured}/><span><b>Feature this testimonial</b><small>Give it the leading card on the public page.</small></span></label><label className="consent"><input name="consent_confirmed" type="checkbox" defaultChecked={activeTestimonial.consent_confirmed}/><span><b>Permission confirmed</b><small>I have permission to publish this person’s name, quote and photo.</small></span></label></div><label><span>Consent/source note</span><textarea name="consent_note" defaultValue={activeTestimonial.consent_note} rows={3} placeholder="When and how permission was received (private admin record)"/></label><div className="admin-form-actions"><button type="button" onClick={() => { setEditing(null); setCreating(false); }}>Cancel</button><button className="primary" disabled={uploading}>{uploading ? "Uploading and saving…" : "Save testimonial"}</button></div></form></aside></div>}
  </>;
}
