export type SemesterStatus = "draft" | "coming_soon" | "published" | "archived";

export type SemesterRecord = {
  id: string;
  course_code: string;
  semester_number: number;
  title: string;
  status: SemesterStatus;
  sort_order: number;
};

export type SubjectRecord = {
  id: string;
  name: string;
  slug: string;
  short_code: string;
  course_code: string;
  semester_number: number;
  description: string;
  accent_color: string;
  units_count: number;
  resources_count: number;
  sort_order: number;
  is_published: boolean;
};

export type AdminActionResult = { ok: boolean; message: string };

export type EditableContentType = "syllabus_unit" | "note" | "important_topic" | "recommended_resource" | "flashcard";

export type ContentRecord = {
  id: string;
  subject_id: string;
  content_type: EditableContentType;
  title: string;
  description: string;
  body: string;
  academic_year: number | null;
  file_url: string | null;
  file_key: string | null;
  sort_order: number;
  is_published: boolean;
};

export type PyqRecord = {
  id: string;
  subject_id: string;
  content_type: "pyq";
  title: string;
  description: string;
  body: string;
  academic_year: number;
  exam_type: string;
  file_url: string;
  file_key: string;
  file_name: string | null;
  file_size_bytes: number | null;
  sort_order: number;
  is_published: boolean;
};

export type FeedbackStatus = "new" | "reviewed" | "resolved" | "archived";

export type FeedbackRecord = {
  id: string;
  rating: number;
  category: string;
  message: string;
  student_year: string;
  email: string | null;
  is_content_issue: boolean;
  status: FeedbackStatus;
  admin_note: string;
  created_at: string;
};

export type TestimonialRecord = {
  id: string;
  person_name: string;
  designation: string;
  institution: string;
  quote: string;
  headshot_url: string | null;
  headshot_key: string | null;
  image_alt: string;
  rating: number;
  is_featured: boolean;
  is_published: boolean;
  consent_confirmed: boolean;
  consent_note: string;
  sort_order: number;
  created_at: string;
};
