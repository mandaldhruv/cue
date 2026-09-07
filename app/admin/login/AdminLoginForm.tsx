"use client";

import { useActionState } from "react";
import { adminAuthAction, type AdminAuthState } from "../actions";

const initialAdminAuthState: AdminAuthState = { error: "", email: "" };

export default function AdminLoginForm() {
  const [state, action, pending] = useActionState(adminAuthAction, initialAdminAuthState);
  return <form className="login-card admin-auth-card" action={action}>
    <div><span>PRIVATE ACCESS</span><h2>Welcome back</h2><p>Sign in with an authorized Cue administrator account.</p></div>
    <label>Email<input name="email" type="email" defaultValue={state.email} placeholder="Enter your email" required autoComplete="username" autoFocus/></label>
    <label>Password<input name="password" type="password" placeholder="Enter your password" minLength={6} required autoComplete="current-password"/></label>
    {state.error && <div className="admin-auth-error" role="alert">{state.error}</div>}
    <button className="admin-auth-submit" type="submit" disabled={pending}>{pending ? "Signing in…" : "Enter dashboard"}<span>→</span></button>
    <small>Protected by verified InsForge sessions and database-level administrator permissions.</small>
  </form>;
}
