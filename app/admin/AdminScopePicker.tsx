"use client";

import type { SubjectRecord } from "./types";

export default function AdminScopePicker({
  subjects,
  semester,
  subjectId,
  onSemesterChange,
  onSubjectChange,
  context,
  detail,
}: {
  subjects: SubjectRecord[];
  semester: number;
  subjectId: string;
  onSemesterChange: (semester: number, firstSubjectId: string) => void;
  onSubjectChange: (subjectId: string) => void;
  context: string;
  detail: string;
}) {
  const semesters = [...new Set(subjects.map((subject) => subject.semester_number))].sort((a, b) => a - b);
  const scopedSubjects = subjects.filter((subject) => subject.semester_number === semester);

  return <section className="admin-scope-picker" aria-label="Choose the academic scope">
    <div className="admin-scope-heading"><span>WORKING ON</span><b>{context}</b></div>
    <label><span>SEMESTER</span><select value={semester} onChange={(event) => {
      const nextSemester = Number(event.target.value);
      const firstSubjectId = subjects.find((subject) => subject.semester_number === nextSemester)?.id ?? "";
      onSemesterChange(nextSemester, firstSubjectId);
    }}>{semesters.map((item) => <option key={item} value={item}>Semester {item}</option>)}</select></label>
    <span className="admin-scope-arrow">→</span>
    <label><span>SUBJECT</span><select value={subjectId} disabled={!scopedSubjects.length} onChange={(event) => onSubjectChange(event.target.value)}>{scopedSubjects.length ? scopedSubjects.map((subject) => <option key={subject.id} value={subject.id}>{subject.short_code} — {subject.name}</option>) : <option>No subjects available</option>}</select></label>
    <div className="admin-scope-detail"><span>PUBLIC PLACEMENT</span><b>{detail}</b></div>
  </section>;
}
