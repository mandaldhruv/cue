"use server";

import { cookies } from "next/headers";
import { redirect } from "next/navigation";
import { createServerClient } from "../lib/supabase/server";
import { notifyAdminNewMember } from "../lib/email/admin-notifications";

export type LoginState = {
  status: "idle" | "error" | "verify" | "success";
  message: string;
  email: string;
};

function friendlyError(message?: string) {
  const text = (message || "").toLowerCase();
  if (text.includes("invalid") || text.includes("password") || text.includes("credentials")) {
    return "That email and password do not match. Please try again.";
  }
  if (text.includes("verify") || text.includes("confirm")) {
    return "Please verify your email before signing in.";
  }
  if (text.includes("already") || text.includes("exists")) {
    return "An account with this email already exists. Try signing in instead.";
  }
  return "We could not complete that request. Please try again.";
}

export async function signInAction(_: LoginState, formData: FormData): Promise<LoginState> {
  const email = String(formData.get("email") || "").trim().toLowerCase();
  const password = String(formData.get("password") || "");
  if (!email || !password) return { status: "error", message: "Enter your email and password.", email };
  try {
    const supabase = await createServerClient();
    const { data, error } = await supabase.auth.signInWithPassword({ email, password });
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
    const supabase = await createServerClient();
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: { name },
      },
    });
    if (error || !data?.user) return { status: "error", message: friendlyError(error?.message), email };
    if (data.user.confirmed_at || data.user.email_confirmed_at) {
      void notifyAdminNewMember({
        userId: data.user.id,
        name: name || "Student",
        email,
        role: "Student",
        status: "Verified",
        joinedAt: new Date(),
      });
      return { status: "success", message: "Your Cue account is ready.", email };
    }
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
    const supabase = await createServerClient();
    // verifyEmail using Supabase verifyOtp
    let { data, error } = await supabase.auth.verifyOtp({ email, token: otp, type: "signup" });
    if (error) {
      const fallback = await supabase.auth.verifyOtp({ email, token: otp, type: "email" });
      if (!fallback.error && fallback.data?.user) {
        data = fallback.data;
        error = null;
      }
    }
    if (error || !data?.user) {
      return { status: "verify", message: error?.message || "That code is incorrect or has expired.", email };
    }
    const userName =
      (data.user.user_metadata?.name as string | undefined) ||
      (data.user.user_metadata?.full_name as string | undefined) ||
      email.split("@")[0] ||
      "Student";
    void notifyAdminNewMember({
      userId: data.user.id,
      name: userName,
      email,
      role: "Student",
      status: "Verified",
      joinedAt: new Date(),
    });
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
  const supabase = await createServerClient();
  const siteUrl = (process.env.NEXT_PUBLIC_SITE_URL || "http://localhost:3000").replace(/\/$/, "");
  const next = safeNext(String(formData.get("next") || "/"));

  cookieStore.set("cue_auth_return", next, {
    httpOnly: true,
    sameSite: "lax",
    secure: siteUrl.startsWith("https"),
    path: "/",
    maxAge: 600,
  });

  const { data, error } = await supabase.auth.signInWithOAuth({
    provider: "google",
    options: {
      redirectTo: `${siteUrl}/api/auth/callback`,
      queryParams: { prompt: "select_account" },
    },
  });

  if (error || !data?.url) {
    redirect(`/login?error=google&next=${encodeURIComponent(next)}`);
  }

  redirect(data.url);
}

export async function signOutAction() {
  const supabase = await createServerClient();
  await supabase.auth.signOut();
}
