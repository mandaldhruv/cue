"use client";

import { useRef, useState, type FormEvent } from "react";
import { submitFeedback } from "./actions";

const labels = ["Very poor", "Not great", "It helps", "Really useful", "Excellent"];

export default function FeedbackForm() {
  const [rating, setRating] = useState(5);
  const [message, setMessage] = useState("");
  const [sent, setSent] = useState(false);
  const [sending, setSending] = useState(false);
  const [error, setError] = useState("");
  const submittingRef = useRef(false);

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (submittingRef.current) return;
    submittingRef.current = true;
    setSending(true);
    setError("");
    const formData = new FormData(event.currentTarget);
    formData.set("submission_id", crypto.randomUUID());
    const result = await submitFeedback(formData);
    if (result.ok) setSent(true); else setError(result.message);
    setSending(false);
    submittingRef.current = false;
  }

  if (sent) return <div className="feedback-success feedback-clean-success" aria-live="polite"><span className="feedback-clean-icon">✓</span><span className="eyebrow">RESPONSE RECEIVED</span><h2>Thank you for helping Cue grow.</h2><p>Your feedback stays private and helps make Cue more useful for BMS students.</p><button type="button" onClick={() => setSent(false)}>Share another thought →</button></div>;

  return <form className="feedback-form feedback-form-clean" onSubmit={submit}>
    <input type="hidden" name="category" value="Overall experience" />
    <input type="hidden" name="student_year" value="Other" />
    <header className="feedback-clean-head"><span className="feedback-clean-icon" aria-hidden="true">✦</span><div><h2>Share your feedback</h2><p>It only takes a minute and helps us improve Cue for you.</p></div></header>
    <section className="feedback-clean-rating"><label>How would you rate your experience with Cue?</label><div className="feedback-clean-stars" role="radiogroup" aria-label="Overall experience rating">{[1, 2, 3, 4, 5].map((star) => <label key={star} className={star <= rating ? "selected" : ""}><input type="radio" name="rating" value={star} checked={rating === star} onChange={() => setRating(star)} /><span aria-hidden="true">★</span><small>{star === 1 ? labels[0] : star === 5 ? labels[4] : ""}</small></label>)}</div></section>
    <div className="feedback-clean-fields feedback-clean-fields-no-year"><div className="feedback-clean-left"><label><span>Email <small>optional</small></span><input name="email" type="email" placeholder="you@example.com" /><small>Only if you’d like us to follow up.</small></label></div><label className="feedback-clean-message"><span>Your feedback</span><textarea name="message" required minLength={10} maxLength={400} rows={5} value={message} onChange={(event) => setMessage(event.target.value)} placeholder="What did you like or not like? What can we improve?" /><small>{message.length} / 400</small></label></div>
    <footer className="feedback-clean-foot"><label className="feedback-clean-check"><input name="is_content_issue" type="checkbox" /><span><b>I found incorrect or outdated content</b><small>Help us keep Cue accurate by reporting issues.</small></span></label><div>{error && <p className="feedback-submit-error" role="alert">{error}</p>}<button className="feedback-submit" type="submit" disabled={sending}>{sending ? "Sending…" : "Send feedback"} <span>↗</span></button></div></footer>
  </form>;
}
