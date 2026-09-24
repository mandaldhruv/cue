"use client";

import { useRef, useState, type FormEvent } from "react";
import { useAuth } from "../auth/AuthProvider";
import { submitFeedback } from "./actions";

const labels = ["Very poor", "Not great", "It helps", "Really useful", "Excellent"];

export default function FeedbackForm() {
  const { user, loading, requireLogin } = useAuth();
  const [rating, setRating] = useState(5);
  const [role, setRole] = useState<"Student" | "Professor / Teacher" | "Professor / Educator" | "">("");
  const [message, setMessage] = useState("");
  const [sent, setSent] = useState(false);
  const [sending, setSending] = useState(false);
  const [error, setError] = useState("");
  const submittingRef = useRef(false);

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (submittingRef.current) return;
    if (!user) {
      const loggedIn = await requireLogin();
      if (!loggedIn) return;
    }
    if (!role) {
      setError("Please select whether you are submitting as a Student or Professor / Teacher.");
      return;
    }
    submittingRef.current = true;
    setSending(true);
    setError("");
    const formData = new FormData(event.currentTarget);
    formData.set("submission_id", crypto.randomUUID());
    formData.set("role", role);
    const result = await submitFeedback(formData);
    if (result.ok) setSent(true); else setError(result.message);
    setSending(false);
    submittingRef.current = false;
  }

  if (sent) {
    return (
      <div className="feedback-success feedback-clean-success" aria-live="polite">
        <span className="feedback-clean-icon">✓</span>
        <span className="eyebrow">RESPONSE RECEIVED</span>
        <h2>Thank you for helping Cue grow.</h2>
        <p>Your feedback stays private and helps make Cue more useful for BMS students.</p>
        <button type="button" onClick={() => { setSent(false); setMessage(""); setRole(""); }}>
          Share another thought →
        </button>
      </div>
    );
  }

  if (!loading && !user) {
    return (
      <div className="feedback-form feedback-form-clean">
        <header className="feedback-clean-head">
          <span className="feedback-clean-icon feedback-message-icon" aria-hidden="true">
            <svg viewBox="0 0 24 24" fill="none">
              <path d="M5.5 5.75h13a2 2 0 0 1 2 2v7.5a2 2 0 0 1-2 2h-7.2l-4.8 3v-3h-1a2 2 0 0 1-2-2v-7.5a2 2 0 0 1 2-2Z"/>
              <path d="M7.5 9.5h9M7.5 13.25h6"/>
            </svg>
          </span>
          <div>
            <h2>Share your feedback</h2>
            <p>Please sign in to share your thoughts with the Cue community.</p>
          </div>
        </header>
        <div className="feedback-auth-notice">
          <span className="feedback-auth-eyebrow">CUE ACCOUNT REQUIRED</span>
          <h3>Sign in to submit feedback</h3>
          <p>Feedback is linked directly to your authenticated account so our team can follow up and review your suggestions.</p>
          <button type="button" className="feedback-auth-cta" onClick={() => requireLogin()}>
            Sign in or create account <i>→</i>
          </button>
        </div>
      </div>
    );
  }

  const displayName = user?.profile?.name || user?.email?.split("@")[0] || "Cue Student";

  return (
    <form className="feedback-form feedback-form-clean" onSubmit={submit}>
      <header className="feedback-clean-head">
        <span className="feedback-clean-icon feedback-message-icon" aria-hidden="true">
          <svg viewBox="0 0 24 24" fill="none">
            <path d="M5.5 5.75h13a2 2 0 0 1 2 2v7.5a2 2 0 0 1-2 2h-7.2l-4.8 3v-3h-1a2 2 0 0 1-2-2v-7.5a2 2 0 0 1 2-2Z"/>
            <path d="M7.5 9.5h9M7.5 13.25h6"/>
          </svg>
        </span>
        <div>
          <h2>Share your feedback</h2>
          <p>It only takes a minute and helps us improve Cue for you.</p>
        </div>
      </header>

      {user && (
        <div className="feedback-account-bar">
          <div className="feedback-account-info">
            <span className="feedback-account-pill">Submitting as</span>
            <b className="feedback-account-name">{displayName}</b>
            <small className="feedback-account-email">({user.email})</small>
          </div>
        </div>
      )}

      <section className="feedback-clean-rating">
        <label>How would you rate your experience with Cue?</label>
        <div className="feedback-clean-stars" role="radiogroup" aria-label="Overall experience rating">
          {[1, 2, 3, 4, 5].map((star) => (
            <label key={star} className={star <= rating ? "selected" : ""}>
              <input
                type="radio"
                name="rating"
                value={star}
                checked={rating === star}
                onChange={() => setRating(star)}
              />
              <span aria-hidden="true">★</span>
              <small>{star === 1 ? labels[0] : star === 5 ? labels[4] : ""}</small>
            </label>
          ))}
        </div>
      </section>

      <div className="feedback-role-group">
        <label className="feedback-role-legend">Writing this feedback as:</label>
        <div className="feedback-role-clean-options" role="radiogroup" aria-label="Writing this feedback as">
          <label className={`feedback-role-option ${role === "Student" ? "active" : ""}`}>
            <input
              type="radio"
              name="role"
              value="Student"
              checked={role === "Student"}
              onChange={() => { setRole("Student"); setError(""); }}
            />
            <span className="feedback-role-box" aria-hidden="true">
              <svg viewBox="0 0 16 16" fill="none">
                <path d="M3.5 8.5L6.5 11.5L12.5 4.5" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round"/>
              </svg>
            </span>
            <span className="feedback-role-text">Student</span>
          </label>
          <label className={`feedback-role-option ${role === "Professor / Teacher" ? "active" : ""}`}>
            <input
              type="radio"
              name="role"
              value="Professor / Teacher"
              checked={role === "Professor / Teacher"}
              onChange={() => { setRole("Professor / Teacher"); setError(""); }}
            />
            <span className="feedback-role-box" aria-hidden="true">
              <svg viewBox="0 0 16 16" fill="none">
                <path d="M3.5 8.5L6.5 11.5L12.5 4.5" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round"/>
              </svg>
            </span>
            <span className="feedback-role-text">Professor / Teacher</span>
          </label>
        </div>
      </div>

      <div className="feedback-message-wrap">
        <label className="feedback-clean-message feedback-clean-message-prominent">
          <span>Your feedback</span>
          <textarea
            name="message"
            required
            minLength={10}
            maxLength={1000}
            rows={6}
            value={message}
            onChange={(event) => setMessage(event.target.value)}
            placeholder="What did you like or not like? What can we improve on Cue?"
          />
          <small>{message.length} / 1000</small>
        </label>
      </div>

      <footer className="feedback-clean-foot">
        <label className="feedback-content-issue-label">
          <input
            name="is_content_issue"
            type="checkbox"
            className="feedback-content-issue-checkbox"
          />
          <span className="feedback-content-issue-text">
            <b>I found incorrect or outdated content</b>
            <small>Help us keep Cue accurate by reporting issues.</small>
          </span>
        </label>
        <div>
          {error && <p className="feedback-submit-error" role="alert">{error}</p>}
          <button className="feedback-submit" type="submit" disabled={sending}>
            {sending ? "Sending…" : "Send feedback"} <span>↗</span>
          </button>
        </div>
      </footer>
    </form>
  );
}
