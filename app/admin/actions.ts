"use server";

import { redirect } from "next/navigation";
import { createServerClient } from "../lib/supabase/server";
import { isAuthorizedAdminEmail } from "../lib/admin-auth";

export type AdminAuthState = { error: string; email: string };

async function confirmAdmin(email: string) {
  if (!isAuthorizedAdminEmail(email)) return false;
  const client = await createServerClient();
  const { data, error } = await client.rpc("is_cue_admin");
  return !error && data === true;
}

export async function adminAuthAction(_: AdminAuthState, formData: FormData): Promise<AdminAuthState> {
  const email = String(formData.get("email") || "").trim().toLowerCase();
  const password = String(formData.get("password") || "");

  if (!email || !password) return { error: "Enter your email and password.", email };

  if (!isAuthorizedAdminEmail(email)) {
    return { error: "This account is not authorized for Cue administration.", email };
  }

  const supabase = await createServerClient();
  const { data, error } = await supabase.auth.signInWithPassword({ email, password });
  if (error || !data?.user) return { error: "Email or password is incorrect.", email };

  const authenticatedEmail = (data.user.email ?? email).trim().toLowerCase();
  if (!isAuthorizedAdminEmail(authenticatedEmail) || !(await confirmAdmin(authenticatedEmail))) {
    await supabase.auth.signOut();
    return { error: "This account is not authorized for Cue administration.", email };
  }

  redirect("/admin");
}

export async function adminSignOut() {
  const supabase = await createServerClient();
  await supabase.auth.signOut();
  redirect("/admin/login");
}
