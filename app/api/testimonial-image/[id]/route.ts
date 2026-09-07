import { createInsForgeServerClient } from "../../../lib/insforge/server";

export async function GET(_: Request, { params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const client = await createInsForgeServerClient();
  const { data, error } = await client.database.from("testimonials").select("headshot_key").eq("id", id).eq("is_published", true).limit(1);
  const key = data?.[0]?.headshot_key;
  if (error || !key) return new Response("Not found", { status: 404 });
  const { data: image, error: imageError } = await client.storage.from("cue-testimonials").download(key);
  if (imageError || !image) return new Response("Not found", { status: 404 });
  return new Response(image, { headers: { "Content-Type": image.type || "image/jpeg", "Cache-Control": "public, max-age=3600, stale-while-revalidate=86400" } });
}
