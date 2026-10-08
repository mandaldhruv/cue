import { getPublishedTestimonials } from "../lib/public-content";
import TestimonialCarousel, { type PublicTestimonial } from "./TestimonialCarousel";

type TestimonialWithDisplay = PublicTestimonial & { is_featured: boolean };

export default async function TestimonialsSection() {
  const { testimonials, error } = await getPublishedTestimonials();
  if (error || !testimonials?.length) return null;
  return (
    <section className="public-testimonials public-testimonials-clean">
      <div className="container">
        <header>
          <div>
            <span className="eyebrow">TRUSTED VOICES</span>
            <h2>What educators think about Cue.</h2>
          </div>
        </header>
        <TestimonialCarousel testimonials={testimonials as TestimonialWithDisplay[]} />
      </div>
    </section>
  );
}
