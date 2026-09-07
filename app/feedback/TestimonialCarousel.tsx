"use client";

import Image from "next/image";
import { useEffect, useState } from "react";

export type PublicTestimonial = { id: string; person_name: string; designation: string; institution: string; quote: string; headshot_key: string | null; image_alt: string; rating: number };

const initials = (name: string) => name.split(/\s+/).map((part) => part[0]).join("").slice(0, 2).toUpperCase();

function Portrait({ testimonial }: { testimonial: PublicTestimonial }) {
  return testimonial.headshot_key ? <Image src={`/api/testimonial-image/${testimonial.id}`} alt={testimonial.image_alt || `Portrait of ${testimonial.person_name}`} width={96} height={96} unoptimized /> : <span>{initials(testimonial.person_name)}</span>;
}

function TestimonialIdentity({ testimonial }: { testimonial: PublicTestimonial }) {
  return <div className="testimonial-clean-person"><div className="testimonial-portrait"><Portrait testimonial={testimonial} /></div><div><b>{testimonial.person_name}</b><span>{testimonial.designation}</span>{testimonial.institution && <small>{testimonial.institution}</small>}</div></div>;
}

export default function TestimonialCarousel({ testimonials }: { testimonials: PublicTestimonial[] }) {
  const [start, setStart] = useState(0);
  const [visibleCount, setVisibleCount] = useState(3);
  const [active, setActive] = useState<PublicTestimonial | null>(null);

  useEffect(() => {
    const tablet = window.matchMedia("(max-width: 1060px)");
    const mobile = window.matchMedia("(max-width: 700px)");
    const sync = () => setVisibleCount(mobile.matches ? 1 : tablet.matches ? 2 : 3);
    sync();
    tablet.addEventListener("change", sync);
    mobile.addEventListener("change", sync);
    return () => { tablet.removeEventListener("change", sync); mobile.removeEventListener("change", sync); };
  }, []);

  useEffect(() => {
    const closeOnEscape = (event: KeyboardEvent) => { if (event.key === "Escape") setActive(null); };
    window.addEventListener("keydown", closeOnEscape);
    return () => window.removeEventListener("keydown", closeOnEscape);
  }, []);

  const maxStart = Math.max(0, testimonials.length - visibleCount);
  const visible = testimonials.slice(start, start + visibleCount);
  const move = (direction: -1 | 1) => setStart((current) => Math.max(0, Math.min(maxStart, current + direction * visibleCount)));

  return <>
    <div className="testimonial-carousel testimonial-clean-carousel" aria-label="Educator testimonials">
      <div className="testimonial-carousel-track">
        {visible.map((testimonial) => {
          const longQuote = testimonial.quote.length > 180;
          return <article className="testimonial-clean-card" key={testimonial.id}>
            <button type="button" className="testimonial-clean-open" onClick={() => setActive(testimonial)} aria-haspopup="dialog" aria-label={`Read ${testimonial.person_name}'s testimonial`}>
              <span className="testimonial-clean-mark" aria-hidden="true">“</span>
              <blockquote>{testimonial.quote}</blockquote>
              {longQuote && <span className="testimonial-more">… more</span>}
              <TestimonialIdentity testimonial={testimonial} />
            </button>
          </article>;
        })}
      </div>
      {testimonials.length > visibleCount && <div className="testimonial-carousel-controls testimonial-clean-controls"><span>{start + 1}–{Math.min(start + visibleCount, testimonials.length)} of {testimonials.length}</span><div><button type="button" onClick={() => move(-1)} disabled={start === 0} aria-label="Show previous testimonials">←</button><button type="button" onClick={() => move(1)} disabled={start >= maxStart} aria-label="Show next testimonials">→</button></div></div>}
    </div>
    {active && <div className="testimonial-dialog-backdrop" role="presentation" onMouseDown={() => setActive(null)}>
      <section className="testimonial-dialog" role="dialog" aria-modal="true" aria-label={`${active.person_name}'s testimonial`} onMouseDown={(event) => event.stopPropagation()}>
        <button type="button" className="testimonial-dialog-close" onClick={() => setActive(null)} aria-label="Close testimonial">×</button>
        <span className="testimonial-dialog-mark" aria-hidden="true">“</span>
        <blockquote>{active.quote}</blockquote>
        <TestimonialIdentity testimonial={active} />
      </section>
    </div>}
  </>;
}
