"use client";

import Link from "next/link";
import { useActionState, useEffect, useState } from "react";
import { useAuth } from "../auth/AuthContext";
import { googleSignInAction, signInAction, signUpAction, verifyEmailAction, type LoginState } from "./actions";

const initialLoginState: LoginState = { status: "idle", message: "", email: "" };

export default function LoginPanel({ next, googleError, modal = false }: { next: string; googleError: boolean; modal?: boolean }) {
  const [mode, setMode] = useState<"signin" | "signup">("signin");
  const [signInState, signInFormAction, signingIn] = useActionState(signInAction, initialLoginState);
  const [signUpState, signUpFormAction, signingUp] = useActionState(signUpAction, initialLoginState);
  const [verifyState, verifyFormAction, verifying] = useActionState(verifyEmailAction, initialLoginState);
  const { user } = useAuth();
  const activeState = signUpState.status === "verify" ? verifyState.status === "idle" ? signUpState : verifyState : mode === "signin" ? signInState : signUpState;

  useEffect(() => {
    if (!user) return;
    window.location.replace(next);
  }, [next, user]);

  useEffect(() => {
    if (activeState.status !== "success") return;
    window.location.replace(next);
  }, [activeState.status, next]);

  const showVerify = signUpState.status === "verify" && verifyState.status !== "success";
  return <section className={`cue-login-card ${modal ? "cue-login-card-modal" : ""}`}>
    <div className="cue-login-brand"><span>CUE LOGIN</span><h1 id={modal ? "cue-auth-modal-title" : undefined}>{showVerify ? "Check your email." : modal ? "Continue with Cue." : "Your study space, saved."}</h1><p>{showVerify ? `Enter the code sent to ${signUpState.email}.` : "Sign in to download resources and reveal flashcard solutions."}</p></div>
    {!showVerify && <>
      <form action={googleSignInAction}><input type="hidden" name="next" value={next}/><button className="google-auth-button" type="submit"><svg viewBox="0 0 24 24" aria-hidden="true"><path fill="#4285F4" d="M21.6 12.2c0-.7-.1-1.4-.2-2H12v3.9h5.4a4.7 4.7 0 0 1-2 3v2.6h3.3c1.9-1.8 2.9-4.4 2.9-7.5Z"/><path fill="#34A853" d="M12 22c2.7 0 5-.9 6.7-2.3l-3.3-2.6c-.9.6-2.1 1-3.4 1a5.9 5.9 0 0 1-5.5-4.1H3.1v2.7A10 10 0 0 0 12 22Z"/><path fill="#FBBC05" d="M6.5 14a6 6 0 0 1 0-3.9V7.4H3.1a10 10 0 0 0 0 9.3L6.5 14Z"/><path fill="#EA4335" d="M12 5.9c1.5 0 2.8.5 3.9 1.5l2.9-2.9A9.8 9.8 0 0 0 3.1 7.4l3.4 2.7A5.9 5.9 0 0 1 12 5.9Z"/></svg>Continue with Google</button></form>
      <div className="auth-divider"><span>or continue with email</span></div>
      <div className="auth-mode-tabs"><button type="button" className={mode === "signin" ? "active" : ""} onClick={() => setMode("signin")}>Sign in</button><button type="button" className={mode === "signup" ? "active" : ""} onClick={() => setMode("signup")}>Create account</button></div>
      <form className="email-auth-form" action={mode === "signin" ? signInFormAction : signUpFormAction}>
        {mode === "signup" && <label><span>Your name</span><input name="name" autoComplete="name" placeholder="What should we call you?" required/></label>}
        <label><span>Email address</span><input type="email" name="email" autoComplete="email" placeholder="you@example.com" defaultValue={activeState.email} required/></label>
        <label><span>Password</span><input type="password" name="password" autoComplete={mode === "signin" ? "current-password" : "new-password"} placeholder={mode === "signup" ? "At least 6 characters" : "Enter your password"} minLength={mode === "signup" ? 6 : undefined} required/></label>
        {(googleError || activeState.status === "error") && <p className="auth-message error" role="alert">{googleError ? "Google sign-in could not be completed. Please try again." : activeState.message}</p>}
        <button className="email-auth-submit" disabled={signingIn || signingUp}>{signingIn || signingUp ? "Please wait…" : mode === "signin" ? "Sign in to Cue" : "Create my Cue account"}<span>→</span></button>
      </form>
    </>}
    {showVerify && <form className="email-auth-form verify-form" action={verifyFormAction}><input type="hidden" name="email" value={signUpState.email}/><label><span>6-digit verification code</span><input className="otp-input" name="otp" inputMode="numeric" autoComplete="one-time-code" pattern="[0-9]{6}" maxLength={6} placeholder="000000" required/></label><p className={`auth-message ${verifyState.message && verifyState.status !== "idle" ? "error" : ""}`}>{verifyState.message || signUpState.message}</p><button className="email-auth-submit" disabled={verifying}>{verifying ? "Verifying…" : "Verify and continue"}<span>→</span></button><button className="auth-text-button" type="button" onClick={() => { setMode("signup"); window.location.reload(); }}>Use a different email</button></form>}
    <p className="auth-terms">By continuing, you agree to Cue’s <Link href="/terms">Terms</Link> and <Link href="/privacy">Privacy Policy</Link>.</p>
  </section>;
}
