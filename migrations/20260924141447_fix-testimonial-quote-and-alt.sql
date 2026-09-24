-- Adjust quote constraint to allow 10 characters and set default for image_alt
ALTER TABLE public.testimonials DROP CONSTRAINT IF EXISTS testimonials_quote_check;
ALTER TABLE public.testimonials ADD CONSTRAINT testimonials_quote_check CHECK (char_length(quote) >= 10 AND char_length(quote) <= 1200);

ALTER TABLE public.testimonials ALTER COLUMN image_alt SET DEFAULT '';
