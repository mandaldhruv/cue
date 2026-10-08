import {
  createClient as createSupabaseServerClient,
  requireAdminSession as requireSupabaseAdminSession,
  AUTHORIZED_ADMIN_EMAILS,
  isAuthorizedAdminEmail,
} from "../supabase/server";

export { AUTHORIZED_ADMIN_EMAILS, isAuthorizedAdminEmail };

export async function createInsForgeServerClient() {
  return createSupabaseServerClient();
}

export const getServerClient = createSupabaseServerClient;

export async function getAdminSession() {
  const client = await createInsForgeServerClient();
  const { data, error } = await client.auth.getUser();
  const user = error ? null : data?.user ?? null;
  if (!user) return { user: null, isAdmin: false, client };

  const email = (user.email ?? "").trim().toLowerCase();
  if (!isAuthorizedAdminEmail(email)) {
    return { user, isAdmin: false, client };
  }

  const { data: allowed, error: roleError } = await client.rpc("is_cue_admin");
  return { user, isAdmin: !roleError && allowed === true, client };
}

export async function requireAdminSession() {
  return requireSupabaseAdminSession();
}
