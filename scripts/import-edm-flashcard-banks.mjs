import assert from "node:assert/strict";
import fs from "node:fs/promises";
import path from "node:path";
import process from "node:process";
import { createAdminClient } from "@insforge/sdk";

const apply = process.argv.includes("--apply");
const sourcePaths = process.argv.slice(2).filter((argument) => argument !== "--apply");
const subjectSlug = "equity-and-debt-markets";

if (!sourcePaths.length) {
  throw new Error("Usage: node scripts/import-edm-flashcard-banks.mjs [--apply] <markdown-file> [markdown-file...]");
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
  return line
    .trim()
    .replace(/^\||\|$/g, "")
    .split("|")
    .map((cell) => plainText(cell));
}

function isTableDivider(cells) {
  return cells.length > 0 && cells.every((cell) => /^:?-{3,}:?$/.test(cell.replace(/\s/g, "")));
}

function answerDocument(markdown, unitNumber, cardNumber) {
  const lines = markdown.replace(/\r/g, "").trim().split("\n");
  const blocks = [];
  let index = 0;
  let blockNumber = 0;
  const id = () => `edm-u${unitNumber}-c${cardNumber}-a-${++blockNumber}`;

  while (index < lines.length) {
    const line = lines[index].trim();
    if (!line) {
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
      index < lines.length &&
      lines[index].trim() &&
      !lines[index].trim().startsWith("|") &&
      !/^\s*[-*+]\s+/.test(lines[index]) &&
      !/^\s*\d+[.)]\s+/.test(lines[index]) &&
      !/^#{1,6}\s+/.test(lines[index].trim()) &&
      !/^\*\*.+\*\*$/.test(lines[index].trim())
    ) {
      paragraph.push(lines[index].trim());
      index += 1;
    }
    const original = paragraph.join(" ");
    const italicOnly = /^\*[^*].*\*$/.test(original);
    blocks.push({
      id: id(),
      type: "text",
      style: "paragraph",
      text: plainText(original),
      ...(italicOnly ? { italic: true } : {}),
    });
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
  return document.blocks
    .map((block) => {
      if (block.type === "text") return block.text;
      if (block.type === "table") return block.rows.map((row) => row.join(" | ")).join("\n");
      return block.items.join("\n");
    })
    .join("\n\n");
}

function canonical(value) {
  return value.replace(/\s+/g, " ").trim();
}

function sourceAnswerText(markdown) {
  return markdown
    .replace(/\r/g, "")
    .split("\n")
    .flatMap((sourceLine) => {
      const line = sourceLine.trim();
      if (!line) return [];
      if (line.startsWith("|")) {
        const cells = tableCells(line);
        return isTableDivider(cells) ? [] : [cells.join(" | ")];
      }
      return [plainText(line.replace(/^#{1,6}\s+/, "").replace(/^[-*+]\s+/, "").replace(/^\d+[.)]\s+/, ""))];
    })
    .join(" ");
}

function parseSource(markdown, sourcePath) {
  const normalized = markdown.replace(/\r/g, "");
  const title = normalized.match(/^# Equity & Debt Markets: Unit (\d+) Flashcard Bank — (.+)$/m);
  if (!title) throw new Error(`${sourcePath}: expected Equity & Debt Markets unit title was not found.`);
  const unitNumber = Number(title[1]);
  const unitTitle = `Unit ${unitNumber}: ${title[2].trim()}`;
  const part = normalized.match(/## Part 2: Flashcards\s*\n([\s\S]*?)(?=\n## Part 3:)/)?.[1];
  if (!part) throw new Error(`${sourcePath}: Part 2 flashcards section was not found.`);

  const sectionMatches = [...part.matchAll(/^### (SECTION\s+[A-Z]+:\s*.+)$/gm)];
  if (!sectionMatches.length) throw new Error(`${sourcePath}: no topic sections were found.`);
  const topics = sectionMatches.map((sectionMatch, topicIndex) => {
    const start = sectionMatch.index;
    const end = sectionMatches[topicIndex + 1]?.index ?? part.length;
    const section = part.slice(start, end);
    const sourceTitle = sectionMatch[1].trim();
    const topicTitle = sourceTitle.replace(/^SECTION\s+[A-Z]+:\s*/, "");
    const cardMatches = [...section.matchAll(/^\*\*Card\s+(\d+):\s*(.+)\*\*\s*$/gm)];
    const cards = cardMatches.map((cardMatch, cardIndex) => {
      const cardStart = cardMatch.index;
      const cardEnd = cardMatches[cardIndex + 1]?.index ?? section.length;
      const chunk = section.slice(cardStart, cardEnd).replace(/\n-{3,}\s*$/, "").trim();
      const number = Number(cardMatch[1]);
      const question = plainText(cardMatch[2]);
      const metadataLine = chunk.match(/^\*\*Priority:\*\*\s*(.+)$/m)?.[0];
      if (!metadataLine) throw new Error(`Unit ${unitNumber}, Card ${number}: priority metadata is missing.`);
      const answerMarker = chunk.match(/^\*\*A:\*\*\s*$/m);
      if (!answerMarker || answerMarker.index === undefined) throw new Error(`Unit ${unitNumber}, Card ${number}: answer marker is missing.`);
      const answerMarkdown = chunk.slice(answerMarker.index + answerMarker[0].length).trim();
      const answer = answerDocument(answerMarkdown, unitNumber, number);
      assert.equal(
        canonical(documentText(answer)),
        canonical(sourceAnswerText(answerMarkdown)),
        `Unit ${unitNumber}, Card ${number}: rich-content conversion changed answer text.`,
      );
      return {
        number,
        question,
        description: plainText(metadataLine),
        answer,
      };
    });
    return { number: topicIndex + 1, sourceTitle, title: topicTitle, cards };
  });

  const cards = topics.flatMap((topic) => topic.cards);
  assert.ok(cards.length > 0, `${sourcePath}: no flashcards were found.`);
  for (let index = 0; index < cards.length; index += 1) {
    assert.equal(cards[index].number, index + 1, `${sourcePath}: expected Card ${index + 1}, found Card ${cards[index].number}.`);
    assert.ok(cards[index].question, `${sourcePath}: Card ${cards[index].number} has an empty question.`);
  }

  return { sourcePath, unitNumber, unitTitle, topics, cards };
}

function questionDocument(unitNumber, card) {
  return {
    version: 1,
    blocks: [{ id: `edm-u${unitNumber}-c${card.number}-q-1`, type: "text", style: "paragraph", text: card.question }],
  };
}

function payloadFor(unit, subjectId, unitId, topicIdByOrder) {
  return unit.topics.flatMap((topic) => topic.cards.map((card) => ({
    subject_id: subjectId,
    content_type: "flashcard",
    flashcard_unit_id: unitId,
    flashcard_topic_id: topicIdByOrder.get(topic.number),
    title: card.question,
    description: card.description,
    body: documentText(card.answer),
    question_document: questionDocument(unit.unitNumber, card),
    answer_document: card.answer,
    sort_order: card.number,
    is_published: true,
    file_url: null,
    file_key: null,
  })));
}

const units = [];
for (const sourcePath of sourcePaths) {
  units.push(parseSource(await fs.readFile(path.resolve(sourcePath), "utf8"), sourcePath));
}
assert.equal(new Set(units.map((unit) => unit.unitNumber)).size, units.length, "Each source file must describe a different unit.");

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
  console.log(JSON.stringify({ mode: "dry-run", subjectSlug, units: audit }, null, 2));
  process.exit(0);
}

const projectConfig = JSON.parse(await fs.readFile(path.resolve(".insforge/project.json"), "utf8"));
const baseUrl = projectConfig.oss_host || `https://${projectConfig.appkey}.${projectConfig.region}.insforge.app`;
const client = createAdminClient({ baseUrl, apiKey: projectConfig.api_key });
const createdUnitIds = [];

try {
  const { data: subjects, error: subjectError } = await client.database
    .from("subjects")
    .select("id,name,slug,semester_number")
    .eq("slug", subjectSlug)
    .limit(1);
  if (subjectError) throw subjectError;
  const subject = subjects?.[0];
  if (!subject) throw new Error(`Subject not found: ${subjectSlug}`);

  const { data: existingUnits, error: existingError } = await client.database
    .from("flashcard_units")
    .select("id,title,sort_order")
    .eq("subject_id", subject.id);
  if (existingError) throw existingError;
  for (const unit of units) {
    const duplicate = existingUnits?.find((existing) => existing.sort_order === unit.unitNumber || existing.title.toLowerCase() === unit.unitTitle.toLowerCase());
    if (duplicate) throw new Error(`${unit.unitTitle} already exists as “${duplicate.title}”. Import stopped to prevent duplicate content.`);
  }

  const verification = [];
  for (const unit of units.sort((left, right) => left.unitNumber - right.unitNumber)) {
    const { data: unitRows, error: unitError } = await client.database
      .from("flashcard_units")
      .insert([{ subject_id: subject.id, title: unit.unitTitle, sort_order: unit.unitNumber, is_published: true }])
      .select("id,title,sort_order,is_published");
    if (unitError) throw unitError;
    const unitRow = unitRows?.[0];
    if (!unitRow?.id) throw new Error(`${unit.unitTitle}: unit creation did not return an id.`);
    createdUnitIds.push(unitRow.id);

    const { data: topicRows, error: topicError } = await client.database
      .from("flashcard_topics")
      .insert(unit.topics.map((topic) => ({
        subject_id: subject.id,
        unit_id: unitRow.id,
        title: topic.title,
        sort_order: topic.number,
        is_published: true,
      })))
      .select("id,title,sort_order,is_published");
    if (topicError) throw topicError;
    assert.equal(topicRows?.length, unit.topics.length, `${unit.unitTitle}: not all topics were created.`);
    const topicIdByOrder = new Map(topicRows.map((topic) => [topic.sort_order, topic.id]));
    const cardPayload = payloadFor(unit, subject.id, unitRow.id, topicIdByOrder);

    const { data: cardRows, error: cardError } = await client.database
      .from("content_items")
      .insert(cardPayload)
      .select("id");
    if (cardError) throw cardError;
    assert.equal(cardRows?.length, unit.cards.length, `${unit.unitTitle}: not all flashcards were created.`);

    const { data: storedTopics, error: storedTopicError } = await client.database
      .from("flashcard_topics")
      .select("id,title,sort_order,is_published")
      .eq("unit_id", unitRow.id)
      .order("sort_order", { ascending: true });
    if (storedTopicError) throw storedTopicError;
    assert.deepEqual(
      storedTopics.map(({ title, sort_order, is_published }) => ({ title, sort_order, is_published })),
      unit.topics.map((topic) => ({ title: topic.title, sort_order: topic.number, is_published: true })),
      `${unit.unitTitle}: stored topic structure does not match the source.`,
    );

    const { data: storedCards, error: storedCardError } = await client.database
      .from("content_items")
      .select("flashcard_topic_id,title,description,body,sort_order,is_published,question_document,answer_document")
      .eq("flashcard_unit_id", unitRow.id)
      .eq("content_type", "flashcard")
      .order("sort_order", { ascending: true });
    if (storedCardError) throw storedCardError;
    assert.equal(storedCards.length, cardPayload.length, `${unit.unitTitle}: stored card count does not match the source.`);
    for (let index = 0; index < cardPayload.length; index += 1) {
      const expected = cardPayload[index];
      const actual = storedCards[index];
      assert.equal(actual.flashcard_topic_id, expected.flashcard_topic_id, `${unit.unitTitle}, Card ${index + 1}: topic mapping changed.`);
      assert.equal(actual.title, expected.title, `${unit.unitTitle}, Card ${index + 1}: question changed.`);
      assert.equal(actual.description, expected.description, `${unit.unitTitle}, Card ${index + 1}: metadata changed.`);
      assert.equal(actual.body, expected.body, `${unit.unitTitle}, Card ${index + 1}: fallback answer changed.`);
      assert.equal(actual.sort_order, expected.sort_order, `${unit.unitTitle}, Card ${index + 1}: order changed.`);
      assert.equal(actual.is_published, true, `${unit.unitTitle}, Card ${index + 1}: card is not published.`);
      assert.deepEqual(actual.question_document, expected.question_document, `${unit.unitTitle}, Card ${index + 1}: rich question changed.`);
      assert.deepEqual(actual.answer_document, expected.answer_document, `${unit.unitTitle}, Card ${index + 1}: rich answer changed.`);
    }

    verification.push({ unit: unit.unitTitle, topics: storedTopics.length, flashcards: storedCards.length, verified: true });
  }

  console.log(JSON.stringify({ mode: "applied", subject: subject.name, semester: subject.semester_number, units: audit, verification }, null, 2));
} catch (error) {
  for (const unitId of createdUnitIds.reverse()) {
    await client.database.from("flashcard_units").delete().eq("id", unitId);
  }
  throw error;
}
