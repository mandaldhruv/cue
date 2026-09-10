import fs from "node:fs/promises";
import path from "node:path";
import process from "node:process";
import { createAdminClient } from "@insforge/sdk";

const sourcePath = process.argv[2];
const subjectSlug = process.argv[3];

if (!sourcePath || !subjectSlug) {
  throw new Error("Usage: node scripts/import-flashcards-from-markdown.mjs <markdown-file> <subject-slug>");
}

const projectConfig = JSON.parse(
  await fs.readFile(path.resolve(".insforge/project.json"), "utf8"),
);
const baseUrl = projectConfig.oss_host || `https://${projectConfig.appkey}.${projectConfig.region}.insforge.app`;
const client = createAdminClient({ baseUrl, apiKey: projectConfig.api_key });

function plainText(value) {
  return value
    .replace(/\*\*/g, "")
    .replace(/`/g, "")
    .replace(/\*([^*]+)\*/g, "$1")
    .trim();
}

function answerDocument(markdown, cardNumber) {
  const lines = markdown.replace(/\r/g, "").trim().split("\n");
  const blocks = [];
  let index = 0;
  let blockNumber = 0;
  const id = () => `edm-u1-${cardNumber}-a-${++blockNumber}`;

  while (index < lines.length) {
    const line = lines[index].trim();
    if (!line) {
      index += 1;
      continue;
    }

    if (line.startsWith("|")) {
      const tableLines = [];
      while (index < lines.length && lines[index].trim().startsWith("|")) {
        tableLines.push(lines[index].trim());
        index += 1;
      }
      const rows = tableLines
        .filter((tableLine) => !/^\|?[\s:|-]+\|?$/.test(tableLine))
        .map((tableLine) =>
          tableLine
            .replace(/^\||\|$/g, "")
            .split("|")
            .map((cell) => plainText(cell)),
        );
      blocks.push({ id: id(), type: "table", rows });
      continue;
    }

    if (/^-\s+/.test(line)) {
      const items = [];
      while (index < lines.length && /^-\s+/.test(lines[index].trim())) {
        items.push(plainText(lines[index].trim().replace(/^-\s+/, "")));
        index += 1;
      }
      blocks.push({ id: id(), type: "bulletList", items });
      continue;
    }

    if (/^\d+\.\s+/.test(line)) {
      const items = [];
      while (index < lines.length && /^\d+\.\s+/.test(lines[index].trim())) {
        items.push(plainText(lines[index].trim().replace(/^\d+\.\s+/, "")));
        index += 1;
      }
      blocks.push({ id: id(), type: "numberList", items });
      continue;
    }

    const paragraph = [];
    while (
      index < lines.length &&
      lines[index].trim() &&
      !lines[index].trim().startsWith("|") &&
      !/^-\s+/.test(lines[index].trim()) &&
      !/^\d+\.\s+/.test(lines[index].trim())
    ) {
      paragraph.push(lines[index].trim());
      index += 1;
    }
    const original = paragraph.join(" ");
    blocks.push({
      id: id(),
      type: "text",
      style: "paragraph",
      text: plainText(original),
      ...(original.startsWith("**Exam Tip:**") || original.startsWith("**Common Trap:**")
        ? { bold: true }
        : {}),
    });
  }

  return { version: 1, blocks };
}

function parseSource(markdown) {
  const topicMatches = [...markdown.matchAll(/^# TOPIC (\d+)\s*$/gm)];
  const topics = topicMatches.map((match, topicIndex) => {
    const start = match.index;
    const end = topicMatches[topicIndex + 1]?.index ?? markdown.length;
    const section = markdown.slice(start, end);
    const heading = section.match(/^## (.+)$/m)?.[1];
    if (!heading) throw new Error(`Topic ${match[1]} is missing its title.`);
    const title = heading.replace(/\s+`\[[^\]]+\]`.*$/, "").trim();
    const cardPattern = /### Flashcard\s+(\d+)\s*\n\*\*Question:\*\*\s*(.+?)\s*\n\*\*Answer:\*\*\s*\n([\s\S]*?)(?=\n-{3,}\s*\n|\n### Flashcard|\s*$)/g;
    const cards = [...section.matchAll(cardPattern)].map((card) => ({
      number: Number(card[1]),
      question: plainText(card[2]),
      answerMarkdown: card[3].trim(),
    }));
    return { number: Number(match[1]), title, cards };
  });

  const cards = topics.flatMap((topic) => topic.cards);
  if (topics.length !== 10 || cards.length !== 48) {
    throw new Error(`Expected 10 topics and 48 flashcards; parsed ${topics.length} topics and ${cards.length} flashcards.`);
  }
  for (let expected = 1; expected <= cards.length; expected += 1) {
    if (cards[expected - 1].number !== expected) {
      throw new Error(`Flashcard sequence error: expected ${expected}, found ${cards[expected - 1].number}.`);
    }
  }
  return topics;
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

const markdown = (await fs.readFile(path.resolve(sourcePath), "utf8")).replace(/\r/g, "");
const topics = parseSource(markdown);
const unitTitle = "Unit 1: Introduction to Financial Market";
let createdUnitId = null;
let createdTopicIds = [];

try {
  const { data: subjects, error: subjectError } = await client.database
    .from("subjects")
    .select("id,name")
    .eq("slug", subjectSlug)
    .limit(1);
  if (subjectError) throw subjectError;
  const subject = subjects?.[0];
  if (!subject) throw new Error(`Subject not found: ${subjectSlug}`);

  const { data: existingUnits, error: existingError } = await client.database
    .from("flashcard_units")
    .select("id,title")
    .eq("subject_id", subject.id);
  if (existingError) throw existingError;
  if (existingUnits?.some((unit) => unit.title.toLowerCase().startsWith("unit 1"))) {
    throw new Error("Unit 1 already exists for this subject. Import stopped to prevent duplicate content.");
  }

  const { data: unitRows, error: unitError } = await client.database
    .from("flashcard_units")
    .insert([{ subject_id: subject.id, title: unitTitle, sort_order: 1, is_published: true }])
    .select("id");
  if (unitError) throw unitError;
  createdUnitId = unitRows?.[0]?.id;
  if (!createdUnitId) throw new Error("Unit creation did not return an id.");

  const { data: topicRows, error: topicError } = await client.database
    .from("flashcard_topics")
    .insert(
      topics.map((topic) => ({
        subject_id: subject.id,
        unit_id: createdUnitId,
        title: topic.title,
        sort_order: topic.number,
        is_published: true,
      })),
    )
    .select("id,title,sort_order");
  if (topicError) throw topicError;
  createdTopicIds = (topicRows ?? []).map((topic) => topic.id);
  if (createdTopicIds.length !== topics.length) {
    throw new Error(`Created ${createdTopicIds.length} of ${topics.length} topics.`);
  }
  const topicIdByOrder = new Map(topicRows.map((topic) => [topic.sort_order, topic.id]));

  const cardPayload = topics.flatMap((topic) =>
    topic.cards.map((card) => {
      const questionDocument = {
        version: 1,
        blocks: [{ id: `edm-u1-${card.number}-q-1`, type: "text", style: "paragraph", text: card.question }],
      };
      const answer = answerDocument(card.answerMarkdown, card.number);
      return {
        subject_id: subject.id,
        content_type: "flashcard",
        flashcard_unit_id: createdUnitId,
        flashcard_topic_id: topicIdByOrder.get(topic.number),
        title: card.question,
        description: "",
        body: documentText(answer),
        question_document: questionDocument,
        answer_document: answer,
        sort_order: card.number,
        is_published: true,
        file_url: null,
        file_key: null,
      };
    }),
  );

  const { data: cardRows, error: cardError } = await client.database
    .from("content_items")
    .insert(cardPayload)
    .select("id");
  if (cardError) throw cardError;
  if (cardRows?.length !== 48) throw new Error(`Created ${cardRows?.length ?? 0} of 48 flashcards.`);

  console.log(JSON.stringify({ subject: subject.name, unit: unitTitle, topics: topics.length, flashcards: cardRows.length, published: true }));
} catch (error) {
  if (createdUnitId) {
    await client.database.from("content_items").delete().eq("flashcard_unit_id", createdUnitId);
    await client.database.from("flashcard_topics").delete().eq("unit_id", createdUnitId);
    await client.database.from("flashcard_units").delete().eq("id", createdUnitId);
  }
  throw error;
}
