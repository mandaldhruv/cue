import { cookies } from "next/headers";
import { redirect } from "next/navigation";
import { createServerClient } from "@insforge/sdk/ssr";
import { isAuthorizedAdminEmail } from "../admin-auth";

export { AUTHORIZED_ADMIN_EMAILS, isAuthorizedAdminEmail } from "../admin-auth";

export async function createInsForgeServerClient() {
  return createServerClient({ cookies: await cookies() });
}

export async function getAdminSession() {
  const client = await createInsForgeServerClient();
  const { data, error } = await client.auth.getCurrentUser();
  const user = error ? null : data?.user ?? null;
  if (!user) return { user: null, isAdmin: false, client };

  const email = (user.email ?? "").trim().toLowerCase();
  if (!isAuthorizedAdminEmail(email)) {
    return { user, isAdmin: false, client };
  }

  const { data: allowed, error: roleError } = await client.database.rpc("is_cue_admin");
  return { user, isAdmin: !roleError && allowed === true, client };
}

export async function requireAdminSession() {
  const session = await getAdminSession();
  if (!session.user || !session.isAdmin) {
    redirect("/admin/login");
  }
  return session;
}

