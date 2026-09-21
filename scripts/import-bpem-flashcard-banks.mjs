import assert from "node:assert/strict";
import fs from "node:fs/promises";
import path from "node:path";
import process from "node:process";
import { createAdminClient } from "@insforge/sdk";

const apply = process.argv.includes("--apply");
const sourcePaths = process.argv.slice(2).filter((argument) => argument !== "--apply");
const subjectSlug = "business-planning-and-entrepreneurial-management";

if (!sourcePaths.length) {
  throw new Error("Usage: node scripts/import-bpem-flashcard-banks.mjs [--apply] <markdown-file> [markdown-file...]");
}

function plainText(value) {
  return value
    .replace(/!\[([^\]]*)\]\([^)]+\)/g, "$1")
    .replace(/\[([^\]]+)\]\([^)]+\)/g, "$1")
    .replace(/\\([\\|*_`])/g, "$1")
    .replace(/\*\*/g, "")
    .replace(/__/g, "")
    .replace(/~~/g, "")
    .replace(/`/g, "")
    .replace(/(^|\s)[*_]([^*_]+)[*_](?=\s|[.,;:!?)]|$)/g, "$1$2")
    .trim();
}

function tableCells(line) {
  return line.trim().replace(/^\||\|$/g, "").split("|").map((cell) => plainText(cell));
}

function isTableDivider(cells) {
  return cells.length > 0 && cells.every((cell) => /^:?-{3,}:?$/.test(cell.replace(/\s/g, "")));
}

function answerDocument(markdown, unitNumber, cardNumber) {
  const lines = markdown.replace(/\r/g, "").trim().split("\n");
  const blocks = [];
  let index = 0;
  let blockNumber = 0;
  const id = () => `bpem-u${unitNumber}-c${cardNumber}-a-${++blockNumber}`;

  while (index < lines.length) {
    const line = lines[index].trim();
    if (!line || /^-{3,}$/.test(line)) {
      index += 1;
      continue;
    }

    if (line.startsWith("|")) {
      const rows = [];
      while (index < lines.length && lines[index].trim().startsWith("|")) {
        const cells = tableCells(lines[index]);
        if (!isTableDivider(cells)) rows.push(cells);
        index += 1;
      }
      assert.ok(rows.length > 0, `Unit ${unitNumber}, Card ${cardNumber}: empty table.`);
      const width = rows[0].length;
      assert.ok(width > 0 && rows.every((row) => row.length === width), `Unit ${unitNumber}, Card ${cardNumber}: inconsistent table width.`);
      blocks.push({ id: id(), type: "table", rows });
      continue;
    }

    if (/^\s*[-*+]\s+/.test(lines[index])) {
      const items = [];
      while (index < lines.length && /^\s*[-*+]\s+/.test(lines[index])) {
        items.push(plainText(lines[index].replace(/^\s*[-*+]\s+/, "")));
        index += 1;
      }
      blocks.push({ id: id(), type: "bulletList", items });
      continue;
    }

    if (/^\s*\d+[.)]\s+/.test(lines[index])) {
      const items = [];
      while (index < lines.length && /^\s*\d+[.)]\s+/.test(lines[index])) {
        items.push(plainText(lines[index].replace(/^\s*\d+[.)]\s+/, "")));
        index += 1;
      }
      blocks.push({ id: id(), type: "numberList", items });
      continue;
    }

    const heading = line.match(/^#{1,6}\s+(.+)$/)?.[1] ?? line.match(/^\*\*(.+)\*\*$/)?.[1];
    if (heading) {
      blocks.push({ id: id(), type: "text", style: "heading", text: plainText(heading), bold: true });
      index += 1;
      continue;
    }

    const paragraph = [];
    while (
      index < lines.length && lines[index].trim() && !/^-{3,}$/.test(lines[index].trim()) &&
      !lines[index].trim().startsWith("|") && !/^\s*[-*+]\s+/.test(lines[index]) &&
      !/^\s*\d+[.)]\s+/.test(lines[index]) && !/^#{1,6}\s+/.test(lines[index].trim()) &&
      !/^\*\*.+\*\*$/.test(lines[index].trim())
    ) {
      paragraph.push(lines[index].trim());
      index += 1;
    }
    const original = paragraph.join(" ");
    const italicOnly = /^\*[^*].*\*$/.test(original);
    blocks.push({ id: id(), type: "text", style: "paragraph", text: plainText(original), ...(italicOnly ? { italic: true } : {}) });
  }

  assert.ok(blocks.length > 0, `Unit ${unitNumber}, Card ${cardNumber}: answer is empty.`);
  assert.ok(blocks.length <= 100, `Unit ${unitNumber}, Card ${cardNumber}: answer exceeds 100 rich-content blocks.`);
  for (const block of blocks) {
    if (block.type === "bulletList" || block.type === "numberList") {
      assert.ok(block.items.length <= 100 && block.items.every(Boolean), `Unit ${unitNumber}, Card ${cardNumber}: invalid list block.`);
    }
    if (block.type === "table") {
      assert.ok(block.rows.length <= 50 && block.rows.every((row) => row.length <= 20), `Unit ${unitNumber}, Card ${cardNumber}: table exceeds rich-content limits.`);
    }
  }
  return { version: 1, blocks };
}

function documentText(document) {
  return document.blocks.map((block) => {
    if (block.type === "text") return block.text;
    if (block.type === "table") return block.rows.map((row) => row.join(" | ")).join("\n");
    return block.items.join("\n");
  }).join("\n\n");
}

function canonical(value) {
  return value.replace(/\s+/g, " ").trim();
}

function sourceAnswerText(markdown) {
  return markdown.replace(/\r/g, "").split("\n").flatMap((sourceLine) => {
    const line = sourceLine.trim();
    if (!line || /^-{3,}$/.test(line)) return [];
    if (line.startsWith("|")) {
      const cells = tableCells(line);
      return isTableDivider(cells) ? [] : [cells.join(" | ")];
    }
    return [plainText(line.replace(/^#{1,6}\s+/, "").replace(/^[-*+]\s+/, "").replace(/^\d+[.)]\s+/, ""))];
  }).join(" ");
}

function cleanTopicTitle(value) {
  return value.replace(/^SECTION\s+[A-Z0-9]+\s*[—:-]\s*/i, "").trim();
}

function parseSource(markdown, sourcePath) {
  const normalized = markdown.replace(/\r/g, "");
  const unitMatch = normalized.match(/^## Unit\s+(\d+)\s+—\s+(.+)$/mi);
  if (!unitMatch) throw new Error(`${sourcePath}: unit title was not found.`);
  const unitNumber = Number(unitMatch[1]);
  const unitTitle = `Unit ${unitNumber}: ${unitMatch[2].trim()}`;
  const quickRevisionIndex = normalized.search(/^## QUICK-REVISION/m);
  const studyPart = quickRevisionIndex >= 0 ? normalized.slice(0, quickRevisionIndex) : normalized;
  const sectionMatches = [...studyPart.matchAll(/^## (SECTION\s+[A-Z0-9]+\s*[—:-]\s*.+)$/gmi)].map((match) => ({
    index: match.index,
    sourceTitle: match[1].trim(),
    title: cleanTopicTitle(match[1]),
  }));
  if (!sectionMatches.length) throw new Error(`${sourcePath}: no topic sections were found.`);
  const questionMatches = [...studyPart.matchAll(/^\*\*Q:\s*(.+)\*\*\s*$/gm)];
  if (!questionMatches.length) throw new Error(`${sourcePath}: no flashcards were found.`);

  const cards = questionMatches.map((questionMatch, index) => {
    const nextQuestionIndex = questionMatches[index + 1]?.index ?? studyPart.length;
    const nextSectionIndex = sectionMatches.find((section) => section.index > questionMatch.index)?.index ?? studyPart.length;
    const chunk = studyPart.slice(questionMatch.index, Math.min(nextQuestionIndex, nextSectionIndex)).trim();
    const answerMarker = chunk.match(/^A:\s*(.*)$/m);
    const priority = chunk.match(/^\*\*Priority:\*\*\s*(.+)$/m);
    const pyq = chunk.match(/^\*\*PYQ Connection:\*\*\s*(.+)$/m);
    const number = index + 1;
    if (!answerMarker || answerMarker.index === undefined) throw new Error(`Unit ${unitNumber}, Card ${number}: answer marker is missing.`);
    if (!priority || priority.index === undefined) throw new Error(`Unit ${unitNumber}, Card ${number}: priority metadata is missing.`);
    if (!pyq) throw new Error(`Unit ${unitNumber}, Card ${number}: PYQ metadata is missing.`);
    const inlineAnswer = answerMarker[1]?.trim();
    const followingAnswer = chunk.slice(answerMarker.index + answerMarker[0].length, priority.index).trim();
    const answerMarkdown = [inlineAnswer, followingAnswer].filter(Boolean).join("\n");
    const answer = answerDocument(answerMarkdown, unitNumber, number);
    assert.equal(canonical(documentText(answer)), canonical(sourceAnswerText(answerMarkdown)), `Unit ${unitNumber}, Card ${number}: rich-content conversion changed answer text.`);
    const topic = [...sectionMatches].reverse().find((section) => section.index < questionMatch.index);
    if (!topic) throw new Error(`Unit ${unitNumber}, Card ${number}: topic mapping is missing.`);
    return {
      number,
      question: plainText(questionMatch[1]),
      description: `Priority: ${plainText(priority[1])} | PYQ Connection: ${plainText(pyq[1])}`,
      answer,
      topicTitle: topic.title,
      topicSourceTitle: topic.sourceTitle,
    };
  });

  const topicTitles = [...new Set(cards.map((card) => card.topicTitle))];
  const topics = topicTitles.map((title, index) => ({
    number: index + 1,
    title,
    sourceTitle: cards.find((card) => card.topicTitle === title).topicSourceTitle,
    cards: cards.filter((card) => card.topicTitle === title),
  }));
  assert.equal(cards.length, normalized.match(/^\*\*Q:/gm)?.length ?? 0, `${sourcePath}: not every question was parsed.`);
  assert.equal(cards.length, normalized.match(/^A:/gm)?.length ?? 0, `${sourcePath}: not every answer was parsed.`);
  return { sourcePath, unitNumber, unitTitle, topics, cards };
}

function questionDocument(unitNumber, card) {
  return { version: 1, blocks: [{ id: `bpem-u${unitNumber}-c${card.number}-q-1`, type: "text", style: "paragraph", text: card.question }] };
}

function payloadFor(unit, subjectId, unitId, topicIdByTitle) {
  return unit.cards.map((card) => ({
    subject_id: subjectId,
    content_type: "flashcard",
    flashcard_unit_id: unitId,
    flashcard_topic_id: topicIdByTitle.get(card.topicTitle),
    title: card.question,
    description: card.description,
    body: documentText(card.answer),
    question_document: questionDocument(unit.unitNumber, card),
    answer_document: card.answer,
    sort_order: card.number,
    is_published: true,
    file_url: null,
    file_key: null,
  }));
}

const units = [];
for (const sourcePath of sourcePaths) units.push(parseSource(await fs.readFile(path.resolve(sourcePath), "utf8"), sourcePath));
assert.equal(new Set(units.map((unit) => unit.unitNumber)).size, units.length, "Each source file must describe a different unit.");
units.sort((left, right) => left.unitNumber - right.unitNumber);

const audit = units.map((unit) => ({
  source: unit.sourcePath,
  unit: unit.unitTitle,
  topics: unit.topics.map((topic) => ({ title: topic.title, cards: topic.cards.length })),
  flashcards: unit.cards.length,
  richBlocks: unit.cards.reduce((sum, card) => sum + card.answer.blocks.length, 0),
  tables: unit.cards.reduce((sum, card) => sum + card.answer.blocks.filter((block) => block.type === "table").length, 0),
  bulletLists: unit.cards.reduce((sum, card) => sum + card.answer.blocks.filter((block) => block.type === "bulletList").length, 0),
  numberedLists: unit.cards.reduce((sum, card) => sum + card.answer.blocks.filter((block) => block.type === "numberList").length, 0),
}));

if (!apply) {
  console.log(JSON.stringify({ mode: "dry-run", subjectSlug, totalFlashcards: units.reduce((sum, unit) => sum + unit.cards.length, 0), units: audit }, null, 2));
  process.exit(0);
}

const config = JSON.parse(await fs.readFile(path.resolve(".insforge/project.json"), "utf8"));
const baseUrl = config.oss_host || `https://${config.appkey}.${config.region}.insforge.app`;
const client = createAdminClient({ baseUrl, apiKey: config.api_key });
const createdUnitIds = [];

try {
  const { data: subjects, error: subjectError } = await client.database.from("subjects").select("id,name,slug,semester_number").eq("slug", subjectSlug).limit(1);
  if (subjectError) throw subjectError;
  const subject = subjects?.[0];
  if (!subject) throw new Error(`Subject not found: ${subjectSlug}`);
  const { data: existingUnits, error: existingError } = await client.database.from("flashcard_units").select("id,title,sort_order").eq("subject_id", subject.id);
  if (existingError) throw existingError;
  for (const unit of units) {
    const duplicate = existingUnits?.find((existing) => existing.sort_order === unit.unitNumber || existing.title.toLowerCase() === unit.unitTitle.toLowerCase());
    if (duplicate) throw new Error(`${unit.unitTitle} already exists as “${duplicate.title}”. Import stopped to prevent duplicate content.`);
  }

  const verification = [];
  for (const unit of units) {
    const { data: unitRows, error: unitError } = await client.database.from("flashcard_units").insert([{ subject_id: subject.id, title: unit.unitTitle, sort_order: unit.unitNumber, is_published: true }]).select("id,title,sort_order,is_published");
    if (unitError) throw unitError;
    const unitRow = unitRows?.[0];
    if (!unitRow?.id) throw new Error(`${unit.unitTitle}: unit creation did not return an id.`);
    createdUnitIds.push(unitRow.id);

    const { data: topicRows, error: topicError } = await client.database.from("flashcard_topics").insert(unit.topics.map((topic) => ({ subject_id: subject.id, unit_id: unitRow.id, title: topic.title, sort_order: topic.number, is_published: true }))).select("id,title,sort_order,is_published");
    if (topicError) throw topicError;
    assert.equal(topicRows?.length, unit.topics.length, `${unit.unitTitle}: not all topics were created.`);
    const topicIdByTitle = new Map(topicRows.map((topic) => [topic.title, topic.id]));
    const payload = payloadFor(unit, subject.id, unitRow.id, topicIdByTitle);
    const { data: inserted, error: insertError } = await client.database.from("content_items").insert(payload).select("id");
    if (insertError) throw insertError;
    assert.equal(inserted?.length, payload.length, `${unit.unitTitle}: not all flashcards were created.`);

    const { data: storedTopics, error: storedTopicError } = await client.database.from("flashcard_topics").select("id,title,sort_order,is_published").eq("unit_id", unitRow.id).order("sort_order", { ascending: true });
    if (storedTopicError) throw storedTopicError;
    assert.deepEqual(storedTopics.map(({ title, sort_order, is_published }) => ({ title, sort_order, is_published })), unit.topics.map((topic) => ({ title: topic.title, sort_order: topic.number, is_published: true })), `${unit.unitTitle}: stored topic structure changed.`);
    const { data: storedCards, error: storedCardError } = await client.database.from("content_items").select("flashcard_topic_id,title,description,body,sort_order,is_published,question_document,answer_document").eq("flashcard_unit_id", unitRow.id).eq("content_type", "flashcard").order("sort_order", { ascending: true });
    if (storedCardError) throw storedCardError;
    assert.equal(storedCards.length, payload.length, `${unit.unitTitle}: stored card count changed.`);
    for (let index = 0; index < payload.length; index += 1) {
      const expected = payload[index];
      const actual = storedCards[index];
      assert.equal(actual.flashcard_topic_id, expected.flashcard_topic_id, `${unit.unitTitle}, Card ${index + 1}: topic changed.`);
      assert.equal(actual.title, expected.title, `${unit.unitTitle}, Card ${index + 1}: question changed.`);
      assert.equal(actual.description, expected.description, `${unit.unitTitle}, Card ${index + 1}: metadata changed.`);
      assert.equal(actual.body, expected.body, `${unit.unitTitle}, Card ${index + 1}: fallback answer changed.`);
      assert.equal(actual.sort_order, expected.sort_order, `${unit.unitTitle}, Card ${index + 1}: order changed.`);
      assert.equal(actual.is_published, true, `${unit.unitTitle}, Card ${index + 1}: not published.`);
      assert.deepEqual(actual.question_document, expected.question_document, `${unit.unitTitle}, Card ${index + 1}: rich question changed.`);
      assert.deepEqual(actual.answer_document, expected.answer_document, `${unit.unitTitle}, Card ${index + 1}: rich answer changed.`);
    }
    verification.push({ unit: unit.unitTitle, topics: storedTopics.length, flashcards: storedCards.length, verified: true });
  }
  console.log(JSON.stringify({ mode: "applied", subject: subject.name, semester: subject.semester_number, totalFlashcards: units.reduce((sum, unit) => sum + unit.cards.length, 0), units: audit, verification }, null, 2));
} catch (error) {
  for (const unitId of createdUnitIds.reverse()) await client.database.from("flashcard_units").delete().eq("id", unitId);
  throw error;
}
