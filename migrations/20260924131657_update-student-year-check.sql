-- Allow Student, Professor / Educator in feedback_submissions student_year
ALTER TABLE public.feedback_submissions DROP CONSTRAINT IF EXISTS feedback_submissions_student_year_check;
ALTER TABLE public.feedback_submissions ADD CONSTRAINT feedback_submissions_student_year_check 
  CHECK (student_year = ANY (ARRAY[
    'First year'::text, 
    'Second year'::text, 
    'Third year'::text, 
    'Other'::text, 
    'Student'::text, 
    'Professor / Educator'::text, 
    'Professor / Teacher'::text
  ]));
