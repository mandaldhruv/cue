import { cookies } from "next/headers";
import { createServerClient } from "@insforge/sdk/ssr";

export async function createInsForgeServerClient() {
  return createServerClient({ cookies: await cookies() });
}

export async function getAdminSession() {
  const client = await createInsForgeServerClient();
  const { data, error } = await client.auth.getCurrentUser();
  const user = error ? null : data?.user ?? null;
  if (!user) return { user: null, isAdmin: false, client };
  const { data: allowed, error: roleError } = await client.database.rpc("is_cue_admin");
  return { user, isAdmin: !roleError && allowed === true, client };
}
