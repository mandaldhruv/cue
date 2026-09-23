"use client";

import { useMemo, useState, useTransition } from "react";
import AdminScopePicker from "../AdminScopePicker";
import { deleteContentItem, moveContentItem, saveContentItem, setContentPublished } from "../content-actions";
import type { AdminActionResult, ContentRecord, SubjectRecord } from "../types";

const blank = (subjectId: string, order: number): ContentRecord => ({
  id: "",
  subject_id: subjectId,
  content_type: "syllabus_unit",
  title: "",
  description: "",
  body: "",
  academic_year: null,
  file_url: null,
  file_key: null,
  sort_order: order,
  is_published: false,
});

export default function SyllabusManager({ subjects, syllabus }: { subjects: SubjectRecord[]; syllabus: ContentRecord[] }) {
  const [semester, setSemester] = useState(subjects[0]?.semester_number ?? 3);
  const [subjectId, setSubjectId] = useState(subjects[0]?.id ?? "");
  const [editing, setEditing] = useState<ContentRecord | null>(null);
  const [creating, setCreating] = useState(false);
  const [notice, setNotice] = useState<AdminActionResult | null>(null);
  const [pending, startTransition] = useTransition();

  const selectedSubject = subjects.find((item) => item.id === subjectId);
  const units = useMemo(() => syllabus.filter((item) => item.subject_id === subjectId && item.content_type === "syllabus_unit"), [syllabus, subjectId]);
  const active = editing ?? (creating ? blank(subjectId, units.length + 1) : null);

  function run(action: () => Promise<AdminActionResult>, close = false) {
    startTransition(async () => {
      const result = await action();
      setNotice(result);
      if (result.ok && close) {
        setEditing(null);
        setCreating(false);
      }
    });
  }

  if (!subjects.length) {
    return (
      <div className="admin-empty content-empty">
        <b>Create a subject first</b>
        <p>Syllabus units need a subject to belong to.</p>
        <a href="/admin/subjects">Open Subject Management →</a>
      </div>
    );
  }

  return (
    <>
      <AdminScopePicker
        subjects={subjects}
        semester={semester}
        subjectId={subjectId}
        context="Syllabus"
        detail={`${selectedSubject?.name ?? "Select a subject"} → Student syllabus workspace`}
        onSemesterChange={(nextSemester, firstSubjectId) => {
          setSemester(nextSemester);
          setSubjectId(firstSubjectId);
          setEditing(null);
          setCreating(false);
          setNotice(null);
        }}
        onSubjectChange={(nextSubjectId) => {
          setSubjectId(nextSubjectId);
          setEditing(null);
          setCreating(false);
          setNotice(null);
        }}
      />
      <div className="admin-selection-summary">
        <div>
          <span>{selectedSubject?.is_published ? "LIVE SUBJECT" : "DRAFT SUBJECT"}</span>
          <b>{selectedSubject?.name}</b>
        </div>
        <div>
          <b>{syllabus.filter((item) => item.subject_id === subjectId && item.is_published).length}</b>
          <span>PUBLISHED UNITS</span>
        </div>
        <a href={selectedSubject ? `/subjects/${selectedSubject.slug}` : "/subjects"} target="_blank" rel="noreferrer">
          Preview student page ↗
        </a>
      </div>
      <div className="admin-toolbar content-toolbar">
        <div>
          <b>Syllabus Units</b>
          <span>Course units and module coverage for {selectedSubject?.name}</span>
        </div>
        <button onClick={() => { setCreating(true); setEditing(null); }}>+ Add unit</button>
      </div>
      {notice && (
        <div className={`admin-notice ${notice.ok ? "success" : "error"}`}>
          {notice.message}
          <button onClick={() => setNotice(null)}>×</button>
        </div>
      )}
      <div className="content-list">
        {units.length ? (
          units.map((item, index) => (
            <article key={item.id}>
              <div className="content-order">
                <button
                  disabled={pending || index === 0}
                  onClick={() => run(() => moveContentItem(item.id, subjectId, "syllabus_unit", "up"))}
                  aria-label="Move unit up"
                >
                  ↑
                </button>
                <span>{String(index + 1).padStart(2, "0")}</span>
                <button
                  disabled={pending || index === units.length - 1}
                  onClick={() => run(() => moveContentItem(item.id, subjectId, "syllabus_unit", "down"))}
                  aria-label="Move unit down"
                >
                  ↓
                </button>
              </div>
              <div className="content-item-copy">
                <div>
                  <b>{item.title}</b>
                  <span className={item.is_published ? "live" : "draft"}>
                    {item.is_published ? "Published" : "Draft"}
                  </span>
                </div>
                <p>{item.description || item.body || "No supporting details added yet."}</p>
                {item.file_url && (
                  <a href={item.file_url} target="_blank" rel="noreferrer">
                    Open attached syllabus link ↗
                  </a>
                )}
              </div>
              <div className="content-item-actions">
                <button
                  className={`admin-publish-toggle ${item.is_published ? "live" : "draft"}`}
                  disabled={pending}
                  onClick={() => run(() => setContentPublished(item.id, !item.is_published))}
                >
                  <i />
                  {item.is_published ? "Live" : "Draft"}
                </button>
                <button onClick={() => { setEditing(item); setCreating(false); }}>Edit</button>
                <button
                  className="danger"
                  onClick={() => {
                    if (window.confirm(`Delete “${item.title}”?`)) run(() => deleteContentItem(item.id));
                  }}
                >
                  Delete
                </button>
              </div>
            </article>
          ))
        ) : (
          <div className="admin-empty">
            <div className="content-empty-mark">01</div>
            <b>No syllabus units yet</b>
            <p>Add the first syllabus unit for {selectedSubject?.name}.</p>
            <button onClick={() => setCreating(true)}>Create unit →</button>
          </div>
        )}
      </div>
      {active && (
        <div className="admin-drawer-backdrop" onMouseDown={() => { setEditing(null); setCreating(false); }}>
          <aside className="admin-drawer wide" onMouseDown={(event) => event.stopPropagation()}>
            <div className="admin-drawer-head">
              <div>
                <span>{active.id ? "EDIT" : "CREATE"} SYLLABUS UNIT</span>
                <h2>{active.id ? active.title : "Add syllabus unit"}</h2>
              </div>
              <button onClick={() => { setEditing(null); setCreating(false); }}>×</button>
            </div>
            <form action={(formData) => run(() => saveContentItem(formData), true)}>
              <input type="hidden" name="id" value={active.id} />
              <input type="hidden" name="subject_id" value={subjectId} />
              <input type="hidden" name="content_type" value="syllabus_unit" />
              <label>
                <span>Unit title</span>
                <input
                  name="title"
                  defaultValue={active.title}
                  placeholder="e.g. Unit 1: Introduction to Marketing"
                  required
                />
              </label>
              <label>
                <span>Short description</span>
                <textarea
                  name="description"
                  defaultValue={active.description}
                  rows={3}
                  placeholder="What will students learn in this unit?"
                />
              </label>
              <label>
                <span>Topics / detailed coverage</span>
                <textarea
                  name="body"
                  defaultValue={active.body}
                  rows={6}
                  placeholder="Add unit topics and detailed syllabus coverage..."
                />
              </label>
              <label>
                <span>Syllabus link (optional)</span>
                <input
                  name="file_url"
                  type="url"
                  defaultValue={active.file_url ?? ""}
                  placeholder="https://…"
                />
              </label>
              <div className="admin-form-grid">
                <label>
                  <span>Display order</span>
                  <input name="sort_order" type="number" min="0" defaultValue={active.sort_order} />
                </label>
                <label>
                  <span>Visibility</span>
                  <select name="is_published" defaultValue={String(active.is_published)}>
                    <option value="true">Published</option>
                    <option value="false">Draft</option>
                  </select>
                </label>
              </div>
              <div className="admin-form-actions">
                <button
                  type="button"
                  onClick={() => { setEditing(null); setCreating(false); }}
                >
                  Cancel
                </button>
                <button className="primary" disabled={pending}>
                  {pending ? "Saving…" : "Save unit"}
                </button>
              </div>
            </form>
          </aside>
        </div>
      )}
    </>
  );
}
