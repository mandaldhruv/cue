/* eslint-disable @typescript-eslint/no-explicit-any */
import { createServerClient as createSupabaseServerClient } from "@supabase/ssr";
import type { SupabaseClient } from "@supabase/supabase-js";
import { cookies } from "next/headers";
import { redirect } from "next/navigation";
import { isAuthorizedAdminEmail } from "../admin-auth";

export { AUTHORIZED_ADMIN_EMAILS, isAuthorizedAdminEmail } from "../admin-auth";

export type AppSupabaseClient = SupabaseClient<any, "public", any> & {
  database: SupabaseClient<any, "public", any> & any;
  storage: any;
  auth: any;
};

export async function createClient(): Promise<AppSupabaseClient> {
  const cookieStore = await cookies();
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

  if (!supabaseUrl || !supabaseAnonKey) {
    throw new Error(
      "Missing Supabase environment variables: NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_ANON_KEY must be set."
    );
  }

  const client = createSupabaseServerClient(supabaseUrl, supabaseAnonKey, {
    cookies: {
      getAll() {
        return cookieStore.getAll();
      },
      setAll(cookiesToSet) {
        try {
          cookiesToSet.forEach(({ name, value, options }) =>
            cookieStore.set(name, value, options)
          );
        } catch {
          // The `setAll` method was called from a Server Component.
          // This can be ignored if middleware is refreshing user sessions.
        }
      },
    },
  });

  // Attach database, auth, and storage compatibility aliases for unmigrated callers
  const compatClient = client as AppSupabaseClient;
  if (!compatClient.database) {
    compatClient.database = compatClient;
  }
  if (!(compatClient.auth as any).getCurrentUser) {
    (compatClient.auth as any).getCurrentUser = compatClient.auth.getUser.bind(compatClient.auth);
  }

  const originalStorageFrom = compatClient.storage.from.bind(compatClient.storage);
  compatClient.storage.from = (bucket: string) => {
    const bucketApi = originalStorageFrom(bucket);
    const originalRemove = bucketApi.remove.bind(bucketApi);
    bucketApi.remove = (paths: string | string[], ...rest: any[]) => {
      const normalizedPaths = Array.isArray(paths) ? paths : [paths];
      return originalRemove(normalizedPaths, ...rest);
    };
    return bucketApi;
  };

  return compatClient;
}

export const createServerClient = createClient;

export async function getAdminSession() {
  const client = await createClient();
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
  const session = await getAdminSession();
  if (!session.user || !session.isAdmin) {
    redirect("/admin/login");
  }
  return session;
}
