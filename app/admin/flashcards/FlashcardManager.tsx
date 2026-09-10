"use client";

import { useState, useTransition } from "react";
import { useRouter } from "next/navigation";
import AdminScopePicker from "../AdminScopePicker";
import { deleteContentItem, deleteFlashcardTopic, deleteFlashcardUnit, moveFlashcard, moveFlashcardTopic, saveFlashcard, saveFlashcardTopic, saveFlashcardUnit, setContentPublished } from "../content-actions";
import type { AdminActionResult, ContentRecord, FlashcardTopicRecord, FlashcardUnitRecord, SubjectRecord } from "../types";
import { richDocumentText } from "../../flashcards/rich-content";
import RichContentEditor from "./RichContentEditor";

const blankCard = (subjectId: string, unitId: string, topicId: string, order: number): ContentRecord => ({
  id: "", subject_id: subjectId, content_type: "flashcard", title: "", description: "", body: "",
  academic_year: null, file_url: null, file_key: null, sort_order: order, is_published: false,
  flashcard_unit_id: unitId, flashcard_topic_id: topicId, question_document: null, answer_document: null,
});

type StructureEditor = { kind: "unit" | "topic"; record?: FlashcardUnitRecord | FlashcardTopicRecord } | null;

export default function FlashcardManager({ subjects, cards, units, topics }: { subjects: SubjectRecord[]; cards: ContentRecord[]; units: FlashcardUnitRecord[]; topics: FlashcardTopicRecord[] }) {
  const router = useRouter();
  const [semester, setSemester] = useState(subjects[0]?.semester_number ?? 3);
  const [subjectId, setSubjectId] = useState(subjects[0]?.id ?? "");
  const [unitId, setUnitId] = useState("");
  const [topicId, setTopicId] = useState("");
  const [topicQuery, setTopicQuery] = useState("");
  const [topicOpen, setTopicOpen] = useState(false);
  const [editing, setEditing] = useState<ContentRecord | null>(null);
  const [creating, setCreating] = useState(false);
  const [structureEditor, setStructureEditor] = useState<StructureEditor>(null);
  const [manageStructure, setManageStructure] = useState(false);
  const [notice, setNotice] = useState<AdminActionResult | null>(null);
  const [pending, startTransition] = useTransition();

  const subject = subjects.find((item) => item.id === subjectId);
  const subjectUnits = units.filter((item) => item.subject_id === subjectId);
  const selectedUnitId = unitId === "__unassigned__" || subjectUnits.some((item) => item.id === unitId) ? unitId : subjectUnits[0]?.id ?? "";
  const unitTopics = topics.filter((item) => item.unit_id === selectedUnitId);
  const selectedTopicId = unitTopics.some((item) => item.id === topicId) ? topicId : "";
  const unit = subjectUnits.find((item) => item.id === selectedUnitId);
  const topic = unitTopics.find((item) => item.id === selectedTopicId);
  const unassigned = selectedUnitId === "__unassigned__";
  const visible = cards.filter((card) => card.subject_id === subjectId && (unassigned ? !card.flashcard_unit_id || !card.flashcard_topic_id : card.flashcard_topic_id === selectedTopicId));
  const active = editing ?? (creating ? blankCard(subjectId, selectedUnitId, selectedTopicId, visible.length + 1) : null);
  const filteredTopics = unitTopics.filter((item) => item.title.toLowerCase().includes(topicQuery.trim().toLowerCase()));
  const legacyCount = cards.filter((card) => card.subject_id === subjectId && (!card.flashcard_unit_id || !card.flashcard_topic_id)).length;

  function closeEditors() { setEditing(null); setCreating(false); setStructureEditor(null); }
  function run(action: () => Promise<AdminActionResult>, close = false) {
    startTransition(async () => {
      const result = await action(); setNotice(result);
      if (result.ok) { if (close) closeEditors(); router.refresh(); }
    });
  }
  function chooseTopic(next: FlashcardTopicRecord) { setTopicId(next.id); setTopicQuery(next.title); setTopicOpen(false); }
  function toggleTopic(next: FlashcardTopicRecord) {
    if (selectedTopicId === next.id) {
      setTopicId("");
      setTopicQuery("");
      setTopicOpen(false);
      closeEditors();
      return;
    }
    chooseTopic(next);
    closeEditors();
  }

  if (!subjects.length) return <div className="admin-empty content-empty"><b>Create a subject first</b><p>Every flashcard deck belongs to a subject.</p><a href="/admin/subjects">Open Subject Management →</a></div>;

  return <>
    <AdminScopePicker subjects={subjects} semester={semester} subjectId={subjectId} context="Flashcard library" detail={`${subject?.name ?? "Select a subject"} → Units → Topics`} onSemesterChange={(nextSemester, firstSubjectId) => { setSemester(nextSemester); setSubjectId(firstSubjectId); setUnitId(""); setTopicId(""); setTopicQuery(""); closeEditors(); setNotice(null); }} onSubjectChange={(nextSubjectId) => { setSubjectId(nextSubjectId); setUnitId(""); setTopicId(""); setTopicQuery(""); closeEditors(); setNotice(null); }}/>

    <section className="flashcard-structure-picker">
      <div><span>03</span><label><b>Unit</b><select value={selectedUnitId} onChange={(event) => { setUnitId(event.target.value); setTopicId(""); setTopicQuery(""); closeEditors(); }}><option value="" disabled>{subjectUnits.length ? "Choose a unit" : "No units created"}</option>{subjectUnits.map((item) => <option key={item.id} value={item.id}>{item.title}{item.is_published ? "" : " · Draft"}</option>)}{legacyCount > 0 && <option value="__unassigned__">Needs organisation ({legacyCount})</option>}</select></label><button type="button" onClick={() => setStructureEditor({ kind: "unit" })}>+ New unit</button></div>
      <div><span>04</span><label><b>Topic</b><div className="topic-combobox"><input value={unassigned ? "Needs organisation" : topicQuery || topic?.title || ""} disabled={!selectedUnitId || unassigned} onFocus={() => setTopicOpen(true)} onChange={(event) => { setTopicOpen(true); setTopicQuery(event.target.value); const exact = unitTopics.find((item) => item.title.toLowerCase() === event.target.value.trim().toLowerCase()); setTopicId(exact?.id ?? ""); }} placeholder={selectedUnitId ? "Search or select a topic" : "Choose a unit first"}/>{topicOpen && selectedUnitId && !unassigned && <div>{filteredTopics.length ? filteredTopics.map((item) => <button type="button" key={item.id} onClick={() => chooseTopic(item)}><span>{item.title}</span><small>{item.is_published ? "Published" : "Draft"}</small></button>) : <p>No matching topic. Create it once, then reuse it.</p>}</div>}</div></label><button type="button" disabled={!selectedUnitId || unassigned} onClick={() => { setTopicOpen(false); setStructureEditor({ kind: "topic" }); }}>+ New topic</button></div>
      <button className="manage-structure" type="button" onClick={() => setManageStructure((value) => !value)}>{manageStructure ? "Close organiser" : "Manage units & topics"}</button>
    </section>

    {manageStructure && <section className="flashcard-structure-manager"><div><header><span>UNITS</span><b>{subject?.name}</b></header>{subjectUnits.length ? subjectUnits.map((item) => <article key={item.id}><div><b>{item.title}</b><small>{topics.filter((entry) => entry.unit_id === item.id).length} topics · {item.is_published ? "Published" : "Draft"}</small></div><button onClick={() => setStructureEditor({ kind: "unit", record: item })}>Edit</button><button className="danger" onClick={() => { if (confirm("Delete this empty unit?")) run(() => deleteFlashcardUnit(item.id)); }}>Delete</button></article>) : <p>No units created for this subject.</p>}</div><div><header><span>TOPICS</span><b>{unit?.title ?? "Choose a unit"}</b></header>{unitTopics.length ? unitTopics.map((item) => <article key={item.id}><div><b>{item.title}</b><small>{cards.filter((entry) => entry.flashcard_topic_id === item.id).length} cards · {item.is_published ? "Published" : "Draft"}</small></div><button onClick={() => setStructureEditor({ kind: "topic", record: item })}>Edit</button><button className="danger" onClick={() => { if (confirm("Delete this empty topic?")) run(() => deleteFlashcardTopic(item.id)); }}>Delete</button></article>) : <p>{unit ? "No topics created in this unit." : "Select a unit to manage its topics."}</p>}</div></section>}

    <div className="admin-selection-summary"><div><span>{subject?.is_published ? "LIVE SUBJECT" : "DRAFT SUBJECT"}</span><b>{subject?.name}</b><small>{unassigned ? "Older cards awaiting a unit and topic" : unit && topic ? `${unit.title} → ${topic.title}` : "Choose a unit and topic"}</small></div><div><b>{visible.filter((card) => card.is_published).length}</b><span>PUBLISHED CARDS</span></div><a href={subject ? `/flashcards/${subject.slug}` : "/flashcards"} target="_blank" rel="noreferrer">Preview student view ↗</a></div>
    {notice && <div className={`admin-notice ${notice.ok ? "success" : "error"}`}>{notice.message}<button onClick={() => setNotice(null)}>×</button></div>}
    {!unassigned && selectedUnitId && <section className="flashcard-topic-accordion" aria-label={`Topics in ${unit?.title ?? "selected unit"}`}>
      {unitTopics.map((item, topicIndex) => {
        const topicCards = cards.filter((card) => card.subject_id === subjectId && card.flashcard_topic_id === item.id);
        const isOpen = item.id === selectedTopicId;
        return <article key={item.id} className={isOpen ? "open" : ""}>
          <div className="flashcard-topic-row">
            <div className="topic-order-controls" aria-label={`Reorder ${item.title}`}>
              <button type="button" aria-label={`Move ${item.title} up`} disabled={pending || topicIndex === 0} onClick={(event) => { event.stopPropagation(); run(() => moveFlashcardTopic(item.id, selectedUnitId, "up")); }}>↑</button>
              <span>{String(topicIndex + 1).padStart(2, "0")}</span>
              <button type="button" aria-label={`Move ${item.title} down`} disabled={pending || topicIndex === unitTopics.length - 1} onClick={(event) => { event.stopPropagation(); run(() => moveFlashcardTopic(item.id, selectedUnitId, "down")); }}>↓</button>
            </div>
            <button type="button" className="flashcard-topic-trigger" aria-expanded={isOpen} aria-controls={`admin-topic-${item.id}`} onClick={() => toggleTopic(item)}>
              <span><b>{item.title}</b><small>{topicCards.length} {topicCards.length === 1 ? "flashcard" : "flashcards"} · {item.is_published ? "Published" : "Draft"}</small></span>
              <strong>{isOpen ? "−" : "+"}</strong>
            </button>
          </div>
          {isOpen && <div id={`admin-topic-${item.id}`} className="flashcard-topic-panel">
            <div className="admin-toolbar content-toolbar"><div><b>{item.title}</b><span>Questions and solutions in this topic</span></div><button onClick={() => { setCreating(true); setEditing(null); }}>+ Add flashcard</button></div>
            <div className="content-list flashcard-admin-list">{topicCards.length ? topicCards.map((card, index) => <article key={card.id}>
              <div className="content-order"><button disabled={pending || index === 0} onClick={() => run(() => moveFlashcard(card.id, item.id, "up"))}>↑</button><span>{String(index + 1).padStart(2, "0")}</span><button disabled={pending || index === topicCards.length - 1} onClick={() => run(() => moveFlashcard(card.id, item.id, "down"))}>↓</button></div>
              <div className="content-item-copy"><div><b>{card.question_document ? richDocumentText(card.question_document) : card.title}</b><span className={card.is_published ? "live" : "draft"}>{card.is_published ? "Published" : "Draft"}</span></div><p>{card.description || "No hint added."}</p></div>
              <div className="content-item-actions"><button className={`admin-publish-toggle ${card.is_published ? "live" : "draft"}`} disabled={pending} onClick={() => run(() => setContentPublished(card.id, !card.is_published))}><i/>{card.is_published ? "Live" : "Draft"}</button><button onClick={() => { setEditing(card); setCreating(false); setUnitId(card.flashcard_unit_id ?? ""); setTopicId(item.id); setTopicQuery(item.title); }}>Edit</button><button className="danger" onClick={() => { if (confirm("Delete this flashcard?")) run(() => deleteContentItem(card.id)); }}>Delete</button></div>
            </article>) : <div className="admin-empty"><div className="content-empty-mark">Q/A</div><b>No flashcards in this topic</b><p>Create the first admin-owned card for this topic.</p><button onClick={() => setCreating(true)}>Create flashcard →</button></div>}</div>
          </div>}
        </article>;
      })}
      {!unitTopics.length && <div className="admin-empty"><div className="content-empty-mark">TOPIC</div><b>No topics in this unit</b><p>Create a topic above, then add its flashcards.</p></div>}
    </section>}
    {unassigned && <><div className="admin-toolbar content-toolbar"><div><b>Needs organisation</b><span>Assign these older cards to a unit and topic</span></div></div><div className="content-list flashcard-admin-list">{visible.map((card, index) => <article key={card.id}><div className="content-order"><span>{String(index + 1).padStart(2, "0")}</span></div><div className="content-item-copy"><div><b>{card.question_document ? richDocumentText(card.question_document) : card.title}</b><span className={card.is_published ? "live" : "draft"}>{card.is_published ? "Published" : "Draft"}</span></div><p>Assign a unit and topic before publishing future updates.</p></div><div className="content-item-actions"><button onClick={() => { setEditing(card); setCreating(false); }}>Edit</button><button className="danger" onClick={() => { if (confirm("Delete this flashcard?")) run(() => deleteContentItem(card.id)); }}>Delete</button></div></article>)}</div></>}

    {structureEditor && <div className="admin-drawer-backdrop" onMouseDown={() => setStructureEditor(null)}><aside className="admin-drawer" onMouseDown={(event) => event.stopPropagation()}><div className="admin-drawer-head"><div><span>{structureEditor.record ? "EDIT" : "CREATE"} {structureEditor.kind.toUpperCase()}</span><h2>{structureEditor.kind === "unit" ? "Organise the deck" : `Topic in ${unit?.title ?? "unit"}`}</h2></div><button onClick={() => setStructureEditor(null)}>×</button></div><form action={(formData) => run(() => structureEditor.kind === "unit" ? saveFlashcardUnit(formData) : saveFlashcardTopic(formData), true)}><input type="hidden" name="id" value={structureEditor.record?.id ?? ""}/><input type="hidden" name="subject_id" value={subjectId}/>{structureEditor.kind === "topic" && <input type="hidden" name="unit_id" value={selectedUnitId}/>}<label><span>{structureEditor.kind === "unit" ? "Unit name" : "Topic name"}</span><input name="title" defaultValue={structureEditor.record?.title ?? (structureEditor.kind === "topic" && !filteredTopics.length ? topicQuery : "")} autoFocus required/></label><div className="admin-form-grid"><label><span>Display order</span><input name="sort_order" type="number" min="0" defaultValue={structureEditor.record?.sort_order ?? (structureEditor.kind === "unit" ? subjectUnits.length + 1 : unitTopics.length + 1)}/></label><label><span>Visibility</span><select name="is_published" defaultValue={String(structureEditor.record?.is_published ?? true)}><option value="true">Published</option><option value="false">Draft</option></select></label></div><div className="admin-form-actions"><button type="button" onClick={() => setStructureEditor(null)}>Cancel</button><button className="primary" disabled={pending}>{pending ? "Saving…" : `Save ${structureEditor.kind}`}</button></div></form></aside></div>}

    {active && <div className="admin-drawer-backdrop" onMouseDown={closeEditors}><aside className="admin-drawer wide flashcard-editor-drawer" onMouseDown={(event) => event.stopPropagation()}><div className="admin-drawer-head"><div><span>{active.id ? "EDIT FLASHCARD" : "CREATE FLASHCARD"}</span><h2>{topic?.title ?? "Organise card"}</h2><small>{subject?.name} · {unit?.title}</small></div><button onClick={closeEditors}>×</button></div><form action={(formData) => run(() => saveFlashcard(formData), true)}>
      <input type="hidden" name="id" value={active.id}/><input type="hidden" name="subject_id" value={subjectId}/><label><span>Unit</span><select name="flashcard_unit_id" value={selectedUnitId} onChange={(event) => { setUnitId(event.target.value); setTopicId(""); setTopicQuery(""); }} required>{subjectUnits.map((item) => <option key={item.id} value={item.id}>{item.title}</option>)}</select></label><label><span>Topic</span><select name="flashcard_topic_id" value={selectedTopicId} onChange={(event) => { const next = unitTopics.find((item) => item.id === event.target.value); if (next) chooseTopic(next); }} required><option value="" disabled>Choose a topic</option>{unitTopics.map((item) => <option key={item.id} value={item.id}>{item.title}</option>)}</select></label>
      <RichContentEditor name="question_document" label="Question" initial={active.question_document} fallback={active.title} required/>
      <label><span>Optional hint</span><input name="description" defaultValue={active.description} placeholder="A short clue shown before the solution"/></label>
      <RichContentEditor name="answer_document" label="Answer / solution" initial={active.answer_document} fallback={active.body} required/>
      <div className="admin-form-grid"><label><span>Display order</span><input name="sort_order" type="number" min="0" defaultValue={active.sort_order}/></label><label><span>Visibility</span><select name="is_published" defaultValue={String(active.is_published)}><option value="true">Published</option><option value="false">Draft</option></select></label></div><div className="admin-form-actions"><button type="button" onClick={closeEditors}>Cancel</button><button className="primary" disabled={pending}>{pending ? "Saving…" : "Save flashcard"}</button></div>
    </form></aside></div>}
  </>;
}
