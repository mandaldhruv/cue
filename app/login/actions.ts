"use server";

import { createAuthActions } from "@insforge/sdk/ssr";
import { cookies } from "next/headers";
import { redirect } from "next/navigation";

export type LoginState = {
  status: "idle" | "error" | "verify" | "success";
  message: string;
  email: string;
};

function friendlyError(message?: string) {
  const text = (message || "").toLowerCase();
  if (text.includes("invalid") || text.includes("password")) return "That email and password do not match. Please try again.";
  if (text.includes("verify")) return "Please verify your email before signing in.";
  if (text.includes("already")) return "An account with this email already exists. Try signing in instead.";
  return "We could not complete that request. Please try again.";
}

export async function signInAction(_: LoginState, formData: FormData): Promise<LoginState> {
  const email = String(formData.get("email") || "").trim().toLowerCase();
  const password = String(formData.get("password") || "");
  if (!email || !password) return { status: "error", message: "Enter your email and password.", email };
  try {
    const auth = createAuthActions({ cookies: await cookies() });
    const { data, error } = await auth.signInWithPassword({ email, password });
    if (error || !data?.user) return { status: "error", message: friendlyError(error?.message), email };
    return { status: "success", message: "Welcome back to Cue.", email };
  } catch {
    return { status: "error", message: "Cue could not connect right now. Please try again in a moment.", email };
  }
}

export async function signUpAction(_: LoginState, formData: FormData): Promise<LoginState> {
  const name = String(formData.get("name") || "").trim();
  const email = String(formData.get("email") || "").trim().toLowerCase();
  const password = String(formData.get("password") || "");
  if (!name || !email || !password) return { status: "error", message: "Enter your name, email and password.", email };
  if (password.length < 6) return { status: "error", message: "Use at least 6 characters for your password.", email };
  try {
    const auth = createAuthActions({ cookies: await cookies() });
    const { data, error } = await auth.signUp({ name, email, password });
    if (error || !data) return { status: "error", message: friendlyError(error?.message), email };
    if (data.user?.emailVerified) return { status: "success", message: "Your Cue account is ready.", email };
    return { status: "verify", message: "We sent a 6-digit verification code to your email.", email };
  } catch {
    return { status: "error", message: "Cue could not connect right now. Please try again in a moment.", email };
  }
}

export async function verifyEmailAction(_: LoginState, formData: FormData): Promise<LoginState> {
  const email = String(formData.get("email") || "").trim().toLowerCase();
  const otp = String(formData.get("otp") || "").replace(/\D/g, "").slice(0, 6);
  if (otp.length !== 6) return { status: "verify", message: "Enter the complete 6-digit code.", email };
  try {
    const auth = createAuthActions({ cookies: await cookies() });
    const { data, error } = await auth.verifyEmail({ email, otp });
    if (error || !data?.user) return { status: "verify", message: error?.message || "That code is incorrect or has expired.", email };
    return { status: "success", message: "Email verified. Welcome to Cue.", email };
  } catch {
    return { status: "verify", message: "Cue could not verify that code right now. Please try again.", email };
  }
}

function safeNext(value: string) {
  return value.startsWith("/") && !value.startsWith("//") ? value : "/";
}

export async function googleSignInAction(formData: FormData) {
  const cookieStore = await cookies();
  const auth = createAuthActions({ cookies: cookieStore });
  const siteUrl = (process.env.NEXT_PUBLIC_SITE_URL || "http://localhost:3000").replace(/\/$/, "");
  const next = safeNext(String(formData.get("next") || "/"));
  const { data, error } = await auth.signInWithOAuth("google", {
    redirectTo: `${siteUrl}/api/auth/callback`,
    skipBrowserRedirect: true,
    additionalParams: { prompt: "select_account" },
  });
  if (error || !data?.url || !data.codeVerifier) redirect(`/login?error=google&next=${encodeURIComponent(next)}`);
  cookieStore.set("insforge_code_verifier", data.codeVerifier, { httpOnly: true, sameSite: "lax", secure: siteUrl.startsWith("https"), path: "/", maxAge: 600 });
  cookieStore.set("cue_auth_return", next, { httpOnly: true, sameSite: "lax", secure: siteUrl.startsWith("https"), path: "/", maxAge: 600 });
  redirect(data.url);
}

export async function signOutAction() {
  const auth = createAuthActions({ cookies: await cookies() });
  await auth.signOut();
}
