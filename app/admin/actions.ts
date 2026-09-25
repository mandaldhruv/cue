"use server";

import { cookies } from "next/headers";
import { redirect } from "next/navigation";
import { createAuthActions, createServerClient } from "@insforge/sdk/ssr";
import { isAuthorizedAdminEmail } from "../lib/insforge/server";

export type AdminAuthState = { error: string; email: string };

async function confirmAdmin(cookieStore: Awaited<ReturnType<typeof cookies>>, email: string) {
  if (!isAuthorizedAdminEmail(email)) return false;
  const client = createServerClient({ cookies: cookieStore });
  const { data, error } = await client.database.rpc("is_cue_admin");
  return !error && data === true;
}

export async function adminAuthAction(_: AdminAuthState, formData: FormData): Promise<AdminAuthState> {
  const email = String(formData.get("email") || "").trim().toLowerCase();
  const password = String(formData.get("password") || "");
  const cookieStore = await cookies();
  const auth = createAuthActions({ cookies: cookieStore });

  if (!email || !password) return { error: "Enter your email and password.", email };

  if (!isAuthorizedAdminEmail(email)) {
    return { error: "This account is not authorized for Cue administration.", email };
  }

  const { data, error } = await auth.signInWithPassword({ email, password });
  if (error || !data?.user) return { error: "Email or password is incorrect.", email };

  const authenticatedEmail = (data.user.email ?? email).trim().toLowerCase();
  if (!isAuthorizedAdminEmail(authenticatedEmail) || !(await confirmAdmin(cookieStore, authenticatedEmail))) {
    await auth.signOut();
    return { error: "This account is not authorized for Cue administration.", email };
  }

  redirect("/admin");
}

export async function adminSignOut() {
  const auth = createAuthActions({ cookies: await cookies() });
  await auth.signOut();
  redirect("/admin/login");
}
