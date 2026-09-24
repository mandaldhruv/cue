"use client";

import { createBrowserClient } from "@insforge/sdk/ssr";
import Image from "next/image";
import { useRouter } from "next/navigation";
import { useEffect, useMemo, useRef, useState, useTransition } from "react";
import type { AdminActionResult, FeedbackRecord, FeedbackStatus, TestimonialRecord } from "../types";
import { deleteTestimonial, saveTestimonial, updateFeedback, toggleFeedbackPublication } from "./actions";

const emptyTestimonial: TestimonialRecord = {
  id: "",
  feedback_id: null,
  person_name: "",
  designation: "",
  institution: "",
  quote: "",
  headshot_url: null,
  headshot_key: null,
  image_alt: "",
  rating: 5,
  is_featured: false,
  is_published: false,
  consent_confirmed: false,
  consent_note: "",
  sort_order: 1,
  created_at: "",
};

const statuses: FeedbackStatus[] = ["new", "reviewed", "resolved", "archived"];
const safeName = (value: string) => value.toLowerCase().replace(/[^a-z0-9.-]+/g, "-").replace(/-+/g, "-");
const initials = (name: string) => name.split(/\s+/).map((part) => part[0]).join("").slice(0, 2).toUpperCase();

export default function FeedbackManager({ feedback, testimonials }: { feedback: FeedbackRecord[]; testimonials: TestimonialRecord[] }) {
  const router = useRouter();
  const [tab, setTab] = useState<"feedback" | "testimonials">("feedback");
  const [filter, setFilter] = useState<FeedbackStatus | "all">("all");
  const [pubFilter, setPubFilter] = useState<"all" | "public" | "private">("all");
  const [selectedFeedback, setSelectedFeedback] = useState<FeedbackRecord | null>(null);
  const [editing, setEditing] = useState<TestimonialRecord | null>(null);
  const [creating, setCreating] = useState(false);
  const [notice, setNotice] = useState<AdminActionResult | null>(null);
  const [uploading, setUploading] = useState(false);
  const submittingRef = useRef(false);
  const [pending, startTransition] = useTransition();

  const [localFeedback, setLocalFeedback] = useState<FeedbackRecord[]>(feedback);
  const [confirmPublishItem, setConfirmPublishItem] = useState<FeedbackRecord | null>(null);
  const [publishing, setPublishing] = useState(false);
  const [justPublishedId, setJustPublishedId] = useState<string | null>(null);

  useEffect(() => {
    setLocalFeedback(feedback);
  }, [feedback]);

  const visibleFeedback = useMemo(() => {
    return localFeedback.filter((item) => {
      if (filter !== "all" && item.status !== filter) return false;
      if (pubFilter === "public" && !item.is_published) return false;
      if (pubFilter === "private" && item.is_published) return false;
      return true;
    });
  }, [localFeedback, filter, pubFilter]);

  const activeTestimonial = editing ?? (creating ? { ...emptyTestimonial, sort_order: testimonials.length + 1 } : null);

  async function handleConfirmPublish() {
    if (!confirmPublishItem) return;
    const target = confirmPublishItem;
    setPublishing(true);
    try {
      const result = await toggleFeedbackPublication(target.id, true);
      if (result.ok) {
        setLocalFeedback((prev) =>
          prev.map((item) =>
            item.id === target.id
              ? { ...item, is_published: true, status: "reviewed" }
              : item
          )
        );
        if (selectedFeedback?.id === target.id) {
          setSelectedFeedback((prev) =>
            prev ? { ...prev, is_published: true, status: "reviewed" } : null
          );
        }
        setJustPublishedId(target.id);
        setNotice({
          ok: true,
          message: `✓ Testimonial successfully published! “${target.user_name || "Member"}’s” quote is now live on the public Feedback page.`,
        });
        setConfirmPublishItem(null);
        router.refresh();
      } else {
        setNotice(result);
        setConfirmPublishItem(null);
      }
    } catch (err) {
      setNotice({ ok: false, message: (err as Error).message || "Could not publish testimonial." });
      setConfirmPublishItem(null);
    } finally {
      setPublishing(false);
    }
  }

  async function handleUnpublish(itemId: string) {
    setPublishing(true);
    try {
      const result = await toggleFeedbackPublication(itemId, false);
      if (result.ok) {
        setLocalFeedback((prev) =>
          prev.map((item) =>
            item.id === itemId
              ? { ...item, is_published: false }
              : item
          )
        );
        if (selectedFeedback?.id === itemId) {
          setSelectedFeedback((prev) =>
            prev ? { ...prev, is_published: false } : null
          );
        }
        if (justPublishedId === itemId) setJustPublishedId(null);
        setNotice({ ok: true, message: "Testimonial removed from public." });
        router.refresh();
      } else {
        setNotice(result);
      }
    } catch (err) {
      setNotice({ ok: false, message: (err as Error).message || "Could not unpublish testimonial." });
    } finally {
      setPublishing(false);
    }
  }

  function run(action: () => Promise<AdminActionResult>, close = false) {
    startTransition(async () => {
      const result = await action();
      setNotice(result);
      if (result.ok && close) {
        setSelectedFeedback(null);
        setEditing(null);
        setCreating(false);
      }
    });
  }

  async function submitTestimonial(formData: FormData) {
    if (submittingRef.current) return;
    submittingRef.current = true;
    setUploading(true);
    const file = formData.get("headshot") as File | null;
    let uploadedKey = "";
    if (file?.size) {
      if (!file.type.startsWith("image/")) {
        setNotice({ ok: false, message: "Choose a JPG, PNG or WebP headshot." });
        setUploading(false);
        submittingRef.current = false;
        return;
      }
      if (file.size > 5 * 1024 * 1024) {
        setNotice({ ok: false, message: "Keep the headshot under 5 MB." });
        setUploading(false);
        submittingRef.current = false;
        return;
      }
      const key = `${formData.get("id") || crypto.randomUUID()}/${crypto.randomUUID()}-${safeName(file.name)}`;
      const { data, error } = await createBrowserClient().storage.from("cue-testimonials").upload(key, file);
      if (error || !data) {
        setNotice({ ok: false, message: error?.message ?? "Headshot upload failed." });
        setUploading(false);
        submittingRef.current = false;
        return;
      }
      uploadedKey = data.key;
      formData.set("headshot_url", data.url);
      formData.set("headshot_key", data.key);
    }
    const result = await saveTestimonial(formData);
    if (!result.ok && uploadedKey) {
      await createBrowserClient().storage.from("cue-testimonials").remove(uploadedKey);
    }
    setNotice(result);
    if (result.ok) {
      setEditing(null);
      setCreating(false);
    }
    setUploading(false);
    submittingRef.current = false;
  }

  return (
    <>
      <div className="community-overview">
        <div>
          <span>NEW FEEDBACK</span>
          <b>{localFeedback.filter((item) => item.status === "new").length}</b>
          <small>Waiting for review</small>
        </div>
        <div>
          <span>AVERAGE RATING</span>
          <b>{localFeedback.length ? (localFeedback.reduce((sum, item) => sum + item.rating, 0) / localFeedback.length).toFixed(1) : "N/A"}</b>
          <small>Student experience</small>
        </div>
        <div>
          <span>LIVE TESTIMONIALS</span>
          <b>{testimonials.filter((item) => item.is_published).length}</b>
          <small>Visible publicly</small>
        </div>
        <button onClick={() => { setTab("testimonials"); setCreating(true); setEditing(null); }}>
          + Add testimonial
        </button>
      </div>

      <div className="community-tabs">
        <button className={tab === "feedback" ? "active" : ""} onClick={() => setTab("feedback")}>
          <span>User Feedback</span>
          <b>{localFeedback.length}</b>
        </button>
        <button className={tab === "testimonials" ? "active" : ""} onClick={() => setTab("testimonials")}>
          <span>Public Testimonials</span>
          <b>{testimonials.length}</b>
        </button>
      </div>

      {notice && (
        <div className={`admin-notice ${notice.ok ? "success" : "error"}`}>
          {notice.message}
          <button onClick={() => setNotice(null)}>×</button>
        </div>
      )}

      {tab === "feedback" ? (
        <section className="feedback-inbox">
          <div className="feedback-inbox-bar">
            <div>
              <b>User Feedback Management</b>
              <span>Review feedback from authenticated students & educators. Publish any entry as a public testimonial.</span>
            </div>
            <div style={{ display: "flex", gap: "10px", flexWrap: "wrap" }}>
              <label>
                <span>VISIBILITY</span>
                <select value={pubFilter} onChange={(event) => setPubFilter(event.target.value as "all" | "public" | "private")}>
                  <option value="all">All ({localFeedback.length})</option>
                  <option value="public">Published ({localFeedback.filter((i) => i.is_published).length})</option>
                  <option value="private">Not Published ({localFeedback.filter((i) => !i.is_published).length})</option>
                </select>
              </label>
              <label>
                <span>STATUS</span>
                <select value={filter} onChange={(event) => setFilter(event.target.value as FeedbackStatus | "all")}>
                  <option value="all">All feedback</option>
                  {statuses.map((status) => (
                    <option key={status} value={status}>
                      {status[0].toUpperCase() + status.slice(1)}
                    </option>
                  ))}
                </select>
              </label>
            </div>
          </div>

          <div style={{ display: "grid", gap: "14px", marginTop: "14px" }}>
            {visibleFeedback.length ? (
              visibleFeedback.map((item) => {
                const name = item.user_name || (item.email ? item.email.split("@")[0] : "Cue Member");
                const role = item.role || item.student_year || "Student";
                return (
                  <article key={item.id} className={`feedback-admin-card ${item.is_published ? "is-public" : "is-private"}`}>
                    <header className="feedback-card-top">
                      <div className="feedback-author">
                        <div className="feedback-author-avatar">
                          {initials(name)}
                        </div>
                        <div className="feedback-author-meta">
                          <b className="feedback-author-name">{name}</b>
                          <span className="feedback-author-email">{item.email || "No email available"}</span>
                          <div className="feedback-author-tags">
                            <span className="feedback-role-badge">{role}</span>
                            <span className={`feedback-pub-badge ${item.is_published ? "pub-live" : "pub-private"}`}>
                              {item.is_published ? "✓ Published" : "○ Not Published"}
                            </span>
                            {item.id === justPublishedId && (
                              <span className="feedback-just-published-tag">
                                ✓ Published Live!
                              </span>
                            )}
                            <span className={`feedback-status-pill ${item.status}`}>{item.status}</span>
                          </div>
                        </div>
                      </div>
                      <div className="feedback-rating-stars" aria-label={`${item.rating} stars`}>
                        {"★".repeat(item.rating)}{"☆".repeat(Math.max(0, 5 - item.rating))}
                      </div>
                    </header>

                    <blockquote className="feedback-quote">
                      “{item.message}”
                    </blockquote>

                    <footer className="feedback-card-foot">
                      <div className="feedback-date-info">
                        <span>
                          Submitted: {new Date(item.created_at).toLocaleDateString("en-IN", {
                            day: "numeric",
                            month: "short",
                            year: "numeric",
                          })}
                        </span>
                        {item.is_content_issue && <b className="content-flag">⚑ Content issue reported</b>}
                      </div>

                      <div className="feedback-actions-group">
                        {item.is_published ? (
                          <button
                            type="button"
                            className="btn-unpublish"
                            disabled={pending || publishing}
                            onClick={() => handleUnpublish(item.id)}
                          >
                            Remove from Public / Unpublish
                          </button>
                        ) : (
                          <button
                            type="button"
                            className="btn-publish"
                            disabled={pending || publishing}
                            onClick={() => setConfirmPublishItem(item)}
                          >
                            Publish as Testimonial
                          </button>
                        )}
                        <button
                          type="button"
                          className="btn-review"
                          onClick={() => setSelectedFeedback(item)}
                        >
                          Review details →
                        </button>
                      </div>
                    </footer>
                  </article>
                );
              })
            ) : (
              <div className="admin-empty">
                <b>No feedback in this view</b>
                <p>New responses will appear here automatically.</p>
              </div>
            )}
          </div>
        </section>
      ) : (
        <section className="testimonial-admin-list">
          <div className="admin-toolbar">
            <div>
              <b>Curated voices</b>
              <span>Only consented, published testimonials appear on the public Feedback page.</span>
            </div>
            <button onClick={() => { setCreating(true); setEditing(null); }}>
              + Add testimonial
            </button>
          </div>
          {testimonials.length ? (
            <div className="testimonial-admin-grid">
              {testimonials.map((item) => (
                <article key={item.id} className={item.is_featured ? "featured" : ""}>
                  <div className="testimonial-admin-person">
                    <span>
                      {item.headshot_key ? (
                        <Image
                          src={`/api/testimonial-image/${item.id}`}
                          alt={item.image_alt || `Portrait of ${item.person_name}`}
                          width={84}
                          height={84}
                          unoptimized
                        />
                      ) : (
                        initials(item.person_name)
                      )}
                    </span>
                    <div>
                      <b>{item.person_name}</b>
                      <small>{item.designation}{item.institution ? ` · ${item.institution}` : ""}</small>
                    </div>
                  </div>
                  <blockquote title={item.quote}>“{item.quote}”</blockquote>
                  <footer>
                    <div className="testimonial-admin-badges">
                      <span className={item.is_published ? "live" : "draft"}>
                        {item.is_published ? "Published" : "Draft"}
                      </span>
                      {item.is_featured && <span className="featured">Featured</span>}
                    </div>
                    <div className="testimonial-admin-actions">
                      <button type="button" onClick={() => { setEditing(item); setCreating(false); }}>
                        Edit
                      </button>
                      <button
                        type="button"
                        className="danger"
                        onClick={() => {
                          if (window.confirm(`Delete ${item.person_name}’s testimonial?`)) {
                            run(() => deleteTestimonial(item.id, item.headshot_key ?? ""));
                          }
                        }}
                      >
                        Delete
                      </button>
                    </div>
                  </footer>
                </article>
              ))}
            </div>
          ) : (
            <div className="admin-empty testimonial-empty">
              <b>No testimonials yet</b>
              <p>Add an honest, consented quote or publish user feedback as a testimonial.</p>
              <button onClick={() => setCreating(true)}>Create the first testimonial →</button>
            </div>
          )}
        </section>
      )}

      {selectedFeedback && (
        <div className="admin-drawer-backdrop" onMouseDown={() => setSelectedFeedback(null)}>
          <aside className="admin-drawer" onMouseDown={(event) => event.stopPropagation()}>
            <div className="admin-drawer-head">
              <div>
                <span>USER FEEDBACK</span>
                <h2>{selectedFeedback.rating}/5 experience</h2>
              </div>
              <button onClick={() => setSelectedFeedback(null)}>×</button>
            </div>

            <div className="feedback-detail-card">
              <span>{selectedFeedback.user_name || "Cue Member"} · {selectedFeedback.role || selectedFeedback.student_year || "Student"}</span>
              <blockquote>“{selectedFeedback.message}”</blockquote>
              {selectedFeedback.email && <small>Account email: {selectedFeedback.email}</small>}
              {selectedFeedback.is_content_issue && <b>⚑ Incorrect or outdated content reported</b>}
              <div style={{ marginTop: "12px", display: "flex", alignItems: "center", justifyContent: "space-between", flexWrap: "wrap", gap: "10px" }}>
                <div style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                  <span className={`feedback-pub-badge ${selectedFeedback.is_published ? "pub-live" : "pub-private"}`}>
                    Status: {selectedFeedback.is_published ? "✓ Published (Live on Testimonials)" : "○ Not Published (Private)"}
                  </span>
                  {selectedFeedback.id === justPublishedId && (
                    <span className="feedback-just-published-tag">✓ Live on Testimonials</span>
                  )}
                </div>
                <button
                  type="button"
                  className={selectedFeedback.is_published ? "btn-unpublish" : "btn-publish"}
                  disabled={pending || publishing}
                  onClick={() => {
                    if (selectedFeedback.is_published) {
                      handleUnpublish(selectedFeedback.id);
                    } else {
                      setConfirmPublishItem(selectedFeedback);
                    }
                  }}
                >
                  {selectedFeedback.is_published ? "Remove from Public / Unpublish" : "Publish as Testimonial"}
                </button>
              </div>
            </div>

            <form action={(formData) => run(() => updateFeedback(formData), true)}>
              <input type="hidden" name="id" value={selectedFeedback.id} />
              <label>
                <span>Workflow Status</span>
                <select name="status" defaultValue={selectedFeedback.status}>
                  {statuses.map((status) => (
                    <option key={status} value={status}>
                      {status[0].toUpperCase() + status.slice(1)}
                    </option>
                  ))}
                </select>
              </label>
              <label>
                <span>Private admin note</span>
                <textarea
                  name="admin_note"
                  defaultValue={selectedFeedback.admin_note}
                  rows={6}
                  placeholder="Record what was checked or changed…"
                />
              </label>
              <div className="admin-form-actions">
                <button type="button" onClick={() => setSelectedFeedback(null)}>Cancel</button>
                <button className="primary" disabled={pending}>
                  {pending ? "Saving…" : "Save review"}
                </button>
              </div>
            </form>
          </aside>
        </div>
      )}

      {activeTestimonial && (
        <div className="admin-drawer-backdrop" onMouseDown={() => { setEditing(null); setCreating(false); }}>
          <aside className="admin-drawer wide" onMouseDown={(event) => event.stopPropagation()}>
            <div className="admin-drawer-head">
              <div>
                <span>{activeTestimonial.id ? "EDIT TESTIMONIAL" : "NEW TESTIMONIAL"}</span>
                <h2>{activeTestimonial.id ? activeTestimonial.person_name : "Add a trusted voice"}</h2>
              </div>
              <button onClick={() => { setEditing(null); setCreating(false); }}>×</button>
            </div>
            <form action={submitTestimonial}>
              <input type="hidden" name="id" value={activeTestimonial.id} />
              <input type="hidden" name="headshot_url" value={activeTestimonial.headshot_url ?? ""} />
              <input type="hidden" name="headshot_key" value={activeTestimonial.headshot_key ?? ""} />
              <input type="hidden" name="old_headshot_key" value={activeTestimonial.headshot_key ?? ""} />
              <div className="admin-form-grid">
                <label>
                  <span>Name</span>
                  <input name="person_name" defaultValue={activeTestimonial.person_name} placeholder="Dr. Asha Sharma" required />
                </label>
                <label>
                  <span>Designation</span>
                  <input name="designation" defaultValue={activeTestimonial.designation} placeholder="Principal / HOD / Professor" required />
                </label>
              </div>
              <label>
                <span>Institution</span>
                <input name="institution" defaultValue={activeTestimonial.institution} placeholder="College or department name" />
              </label>
              <label>
                <span>Testimonial</span>
                <textarea
                  name="quote"
                  minLength={20}
                  maxLength={1200}
                  defaultValue={activeTestimonial.quote}
                  rows={7}
                  placeholder="Write the honest feedback exactly as it was shared…"
                  required
                />
              </label>
              <label className="pdf-upload-field">
                <span>{activeTestimonial.headshot_key ? "Replace headshot (optional)" : "Headshot (optional)"}</span>
                <input name="headshot" type="file" accept="image/jpeg,image/png,image/webp" />
                <small>Professional square portrait · JPG, PNG or WebP · up to 5 MB</small>
              </label>
              <label>
                <span>Image description</span>
                <input name="image_alt" defaultValue={activeTestimonial.image_alt} placeholder="Portrait of Dr. Asha Sharma" />
              </label>
              <div className="admin-form-grid">
                <label>
                  <span>Rating</span>
                  <select name="rating" defaultValue={activeTestimonial.rating}>
                    {[5, 4, 3, 2, 1].map((rating) => (
                      <option key={rating} value={rating}>{rating} stars</option>
                    ))}
                  </select>
                </label>
                <label>
                  <span>Display order</span>
                  <input name="sort_order" type="number" min="0" defaultValue={activeTestimonial.sort_order} />
                </label>
                <label>
                  <span>Visibility</span>
                  <select name="is_published" defaultValue={String(activeTestimonial.is_published)}>
                    <option value="false">Draft</option>
                    <option value="true">Published</option>
                  </select>
                </label>
              </div>
              <div className="testimonial-switches">
                <label>
                  <input name="is_featured" type="checkbox" defaultChecked={activeTestimonial.is_featured} />
                  <span>
                    <b>Feature this testimonial</b>
                    <small>Give it the leading card on the public page.</small>
                  </span>
                </label>
                <label className="consent">
                  <input name="consent_confirmed" type="checkbox" defaultChecked={activeTestimonial.consent_confirmed} />
                  <span>
                    <b>Permission confirmed</b>
                    <small>I have permission to publish this person’s name, quote and photo.</small>
                  </span>
                </label>
              </div>
              <label>
                <span>Consent/source note</span>
                <textarea
                  name="consent_note"
                  defaultValue={activeTestimonial.consent_note}
                  rows={3}
                  placeholder="When and how permission was received (private admin record)"
                />
              </label>
              <div className="admin-form-actions">
                <button type="button" onClick={() => { setEditing(null); setCreating(false); }}>Cancel</button>
                <button className="primary" disabled={uploading}>
                  {uploading ? "Uploading and saving…" : "Save testimonial"}
                </button>
              </div>
            </form>
          </aside>
        </div>
      )}

      {confirmPublishItem && (
        <div
          className="admin-modal-backdrop"
          onClick={() => {
            if (!publishing) setConfirmPublishItem(null);
          }}
        >
          <div
            className="admin-confirm-card"
            role="dialog"
            aria-modal="true"
            aria-labelledby="confirm-publish-title"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="admin-confirm-icon-wrap" aria-hidden="true">
              ✦
            </div>
            <div className="admin-confirm-header">
              <h3 id="confirm-publish-title">Do you want to publish this testimonial?</h3>
              <p>
                This will convert the user’s feedback into a public testimonial and make it immediately available on the public Feedback and Testimonials page.
              </p>
            </div>

            <div className="admin-confirm-quote-box">
              <div className="admin-confirm-author">
                <b>{confirmPublishItem.user_name || (confirmPublishItem.email ? confirmPublishItem.email.split("@")[0] : "Cue Member")}</b>
                <span>{confirmPublishItem.role || confirmPublishItem.student_year || "Student"}</span>
              </div>
              <blockquote>“{confirmPublishItem.message}”</blockquote>
            </div>

            <div className="admin-confirm-actions">
              <button
                type="button"
                className="admin-confirm-btn-cancel"
                disabled={publishing}
                onClick={() => setConfirmPublishItem(null)}
              >
                Cancel
              </button>
              <button
                type="button"
                className="admin-confirm-btn-publish"
                disabled={publishing}
                onClick={handleConfirmPublish}
              >
                {publishing ? "Publishing…" : "Publish"}
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}
