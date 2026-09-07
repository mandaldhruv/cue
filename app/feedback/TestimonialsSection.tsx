import { createInsForgeServerClient } from "../lib/insforge/server";
import TestimonialCarousel, { type PublicTestimonial } from "./TestimonialCarousel";

type TestimonialWithDisplay = PublicTestimonial & { is_featured: boolean };

export default async function TestimonialsSection() {
  const client = await createInsForgeServerClient();
  const { data, error } = await client.database.from("testimonials").select("id,person_name,designation,institution,quote,headshot_key,image_alt,rating,is_featured").eq("is_published", true).order("is_featured", { ascending: false }).order("sort_order", { ascending: true });
  if (error || !data?.length) return null;
  const testimonials = data as TestimonialWithDisplay[];
  return <section className="public-testimonials public-testimonials-clean"><div className="container">
    <header><div><span className="eyebrow">TRUSTED VOICES</span><h2>What educators think about Cue.</h2></div></header>
    <TestimonialCarousel testimonials={testimonials} />
  </div></section>;
}
