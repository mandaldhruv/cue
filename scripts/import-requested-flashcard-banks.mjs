import assert from "node:assert/strict";
import fs from "node:fs/promises";
import path from "node:path";
import process from "node:process";
import { createAdminClient } from "@insforge/sdk";

const apply = process.argv.includes("--apply");
const sourcePaths = process.argv.slice(2).filter((value) => value !== "--apply");

if (sourcePaths.length !== 5) {
  throw new Error("Pass exactly five source files: AMD Unit 1, AMD Unit 2, EDM Unit 4, POE Module 1 and POE Module 2.");
}

const AMD2_TOPICS = {
  FA: "Financial Statement Analysis",
  RA: "Ratio Analysis",
  CR: "Current Ratio",
  LR: "Liquid Ratio (Quick Ratio / Acid Test Ratio)",
  SW: "Stock Working Capital Ratio",
  PR: "Proprietary Ratio",
  DE: "Debt Equity Ratio",
  CG: "Capital Gearing Ratio",
  GP: "Gross Profit Ratio",
  EX: "Expenses Ratio",
  OP: "Operating Ratio",
  NP: "Net Profit Ratio",
  NO: "Net Operating Profit Ratio",
  ST: "Stock Turnover Ratio",
  RC: "Return on Capital Employed (ROCE)",
  RP: "Return on Proprietor's Fund",
};

const AMD2_FORMULAS = {
  CR: "Current Ratio = Current Assets ÷ Current Liabilities",
  LR: "Liquid Ratio = Liquid Assets ÷ Current Liabilities",
  SW: "Stock Working Capital Ratio = (Stock ÷ Working Capital) × 100",
  PR: "Proprietary Ratio = (Proprietors' Fund ÷ Total Assets) × 100",
  DE: "Debt-Equity Ratio = Long-term Debt ÷ Shareholders' Equity",
  CG: "Capital Gearing Ratio = Fixed-Interest-Bearing Capital ÷ Equity Shareholders' Funds",
  GP: "Gross Profit Ratio = (Gross Profit ÷ Net Sales) × 100",
  EX: "Expense Ratio = (Specific Operating Expense ÷ Net Sales) × 100",
  OP: "Operating Ratio = (Operating Cost ÷ Net Sales) × 100",
  NP: "Net Profit Ratio = (Net Profit After Tax ÷ Net Sales) × 100",
  NO: "Net Operating Profit Ratio = (Operating Profit ÷ Net Sales) × 100",
  ST: "Stock Turnover Ratio = Cost of Goods Sold ÷ Average Stock",
  RC: "ROCE = (EBIT ÷ Capital Employed) × 100",
  RP: "Return on Proprietor's Fund = (Net Profit Available to Shareholders ÷ Proprietors' Fund) × 100",
};

function clean(value) {
  return value
    .replace(/!\[([^\]]*)\]\([^)]+\)/g, "$1")
    .replace(/\[([^\]]+)\]\([^)]+\)/g, "$1")
    .replace(/\\\[(\d+)\\\]/g, "")
    .replace(/\\([\\|*_`+&=.-])/g, "$1")
    .replace(/\*\*/g, "")
    .replace(/__/g, "")
    .replace(/~~/g, "")
    .replace(/`/g, "")
    .replace(/(^|\s)[*_]([^*_]+)[*_](?=\s|[.,;:!?)]|$)/g, "$1$2")
    .replace(/\s+/g, " ")
    .trim();
}

function tableCells(line) {
  return line.trim().replace(/^\||\|$/g, "").split("|").map(clean);
}

function isDivider(cells) {
  return cells.length > 0 && cells.every((cell) => /^:?-{3,}:?$/.test(cell.replace(/\s/g, "")));
}

function inlineNumberedItems(line) {
  const matches = [...line.matchAll(/(?:^|\s)(\d+)\\?\.\s+/g)];
  if (matches.length < 2) return null;
  return matches.map((match, index) => clean(line.slice(match.index + (match[0].startsWith(" ") ? 1 : 0) + match[0].trimStart().length, matches[index + 1]?.index ?? line.length)));
}

function inlineRomanItems(line) {
  const matches = [...line.matchAll(/(?:^|[;:]\s*)\(([ivx]+)\)\s+/gi)];
  if (matches.length < 2) return null;
  return matches.map((match, index) => clean(line.slice((match.index ?? 0) + match[0].length, matches[index + 1]?.index ?? line.length).replace(/;\s*$/, "")));
}

function looksLikeFormula(text) {
  if (text.length > 320) return false;
  return /(?:=|÷|×|√|\bper share\b)/i.test(text) && /(?:\d|[A-Za-z])/.test(text) && /(?:÷|×|=|\+|−|\/)/.test(text);
}

function richDocument(markdown, idPrefix, prependFormula = "") {
  const lines = markdown.replace(/\r/g, "").split("\n");
  const blocks = [];
  let index = 0;
  let serial = 0;
  const id = () => `${idPrefix}-${++serial}`;
  if (prependFormula) blocks.push({ id: id(), type: "formula", expression: prependFormula });

  while (index < lines.length) {
    let raw = lines[index];
    let line = raw.trim();
    if (!line || /^-{3,}$/.test(line)) { index += 1; continue; }
    if (line === "```") {
      const code = [];
      index += 1;
      while (index < lines.length && lines[index].trim() !== "```") code.push(lines[index++].replace(/\s+$/, ""));
      index += 1;
      if (code.length) blocks.push({ id: id(), type: "formula", expression: code.join("\n") });
      continue;
    }
    if (line.startsWith("|")) {
      const rows = [];
      while (index < lines.length && lines[index].trim().startsWith("|")) {
        const cells = tableCells(lines[index]);
        if (!isDivider(cells)) rows.push(cells);
        index += 1;
      }
      if (rows.length) {
        const width = Math.max(...rows.map((row) => row.length));
        blocks.push({ id: id(), type: "table", rows: rows.map((row) => [...row, ...Array(width - row.length).fill("")]) });
      }
      continue;
    }
    if (/^[-*+]\s+/.test(line)) {
      const items = [];
      while (index < lines.length && /^\s*[-*+]\s+/.test(lines[index])) items.push(clean(lines[index++].replace(/^\s*[-*+]\s+/, "")));
      blocks.push({ id: id(), type: "bulletList", items: items.filter(Boolean) });
      continue;
    }
    if (/^\d+\\?[.)]\s+/.test(line)) {
      const items = [];
      while (index < lines.length && /^\s*\d+\\?[.)]\s+/.test(lines[index])) items.push(clean(lines[index++].replace(/^\s*\d+\\?[.)]\s+/, "")));
      blocks.push({ id: id(), type: "numberList", items: items.filter(Boolean) });
      continue;
    }
    const numbered = inlineNumberedItems(line);
    if (numbered) { blocks.push({ id: id(), type: "numberList", items: numbered.filter(Boolean) }); index += 1; continue; }
    const roman = inlineRomanItems(line);
    if (roman) { blocks.push({ id: id(), type: "numberList", items: roman.filter(Boolean) }); index += 1; continue; }

    const label = line.match(/^\*\*([^*]+?):\*\*\s*(.*)$/);
    if (label) {
      const heading = clean(label[1]);
      blocks.push({ id: id(), type: "text", style: "heading", text: heading, bold: true });
      line = label[2].trim();
      if (!line) { index += 1; continue; }
      raw = line;
    }
    const heading = line.match(/^#{1,6}\s+(.+)$/)?.[1];
    if (heading) { blocks.push({ id: id(), type: "text", style: "heading", text: clean(heading), bold: true }); index += 1; continue; }
    const text = clean(raw);
    if (text) blocks.push(looksLikeFormula(text)
      ? { id: id(), type: "formula", expression: text }
      : { id: id(), type: "text", style: "paragraph", text });
    index += 1;
  }

  assert.ok(blocks.length, `${idPrefix}: empty answer.`);
  assert.ok(blocks.length <= 100, `${idPrefix}: more than 100 rich-content blocks.`);
  for (const block of blocks) {
    if (block.type === "table") assert.ok(block.rows.length <= 50 && block.rows.every((row) => row.length <= 20), `${idPrefix}: table exceeds limits.`);
    if (block.type === "bulletList" || block.type === "numberList") assert.ok(block.items.length && block.items.length <= 100, `${idPrefix}: invalid list.`);
  }
  return { version: 1, blocks };
}

function documentText(document) {
  return document.blocks.map((block) => {
    if (block.type === "text") return block.text;
    if (block.type === "formula") return block.expression;
    if (block.type === "table") return block.rows.map((row) => row.join(" | ")).join("\n");
    if (block.type === "image") return block.alt || block.caption || "Image";
    return block.items.join("\n");
  }).join("\n\n");
}

function metadata(chunk) {
  const priority = clean(chunk.match(/\*\*Priority:\*\*\s*([^\n]+)/)?.[1] ?? chunk.match(/^Priority:\s*([^\n]+)/m)?.[1] ?? "");
  const pyq = clean(chunk.match(/\*\*PYQ Connection:\*\*\s*([^\n]+)/)?.[1] ?? chunk.match(/^PYQ Connection:\s*([^\n]+)/m)?.[1] ?? "");
  return [priority && `Priority: ${priority}`, pyq && `PYQ Connection: ${pyq}`].filter(Boolean).join(" | ") || null;
}

function trimAnswer(markdown) {
  return markdown
    .replace(/^\*\*Priority:\*\*[\s\S]*$/m, "")
    .replace(/^Priority:\s*[\s\S]*$/m, "")
    .replace(/^\*\*PYQ Connection:\*\*[\s\S]*$/m, "")
    .replace(/^PYQ Connection:\s*[\s\S]*$/m, "")
    .replace(/^\*\*Exam Tip:\*\*[\s\S]*$/m, (match) => match)
    .trim();
}

function groupTopics(cards) {
  const topics = [];
  for (const card of cards) {
    let topic = topics.find((item) => item.title === card.topic);
    if (!topic) { topic = { title: card.topic, cards: [], number: topics.length + 1 }; topics.push(topic); }
    topic.cards.push(card);
  }
  return topics;
}

function parseAmd1(markdown, sourcePath) {
  const body = markdown.replace(/\r/g, "").match(/# PART A[\s\S]*?(?=\n# PART C)/)?.[0];
  assert.ok(body, "AMD Unit 1: card bank not found.");
  const headings = [...body.matchAll(/^(#{1,3})\s+(.+)$/gm)];
  let topic = "Introduction to Management Accounting";
  const cards = [];
  for (let i = 0; i < headings.length; i += 1) {
    const [, hashes, title] = headings[i];
    if (hashes.length <= 2) {
      if (/^PART A/.test(title)) topic = "Introduction to Management Accounting";
      else if (/^PART B/.test(title)) topic = "Analysis and Interpretation of Accounts";
      else topic = clean(title.replace(/^B-[IVX]+\.\s*/, ""));
      continue;
    }
    const start = headings[i].index + headings[i][0].length;
    const end = headings[i + 1]?.index ?? body.length;
    const chunk = body.slice(start, end).trim();
    const q = chunk.match(/^\*\*Q:\*\*\s*([^\n]+)/m);
    if (!q) continue;
    const question = clean(q[1]);
    const qEnd = q.index + q[0].length;
    const answerMarker = chunk.slice(qEnd).match(/^\s*\*\*A:\*\*\s*/);
    const number = cards.length + 1;
    let questionExtra = "";
    let answer = "";
    if (answerMarker) {
      answer = trimAnswer(chunk.slice(qEnd + answerMarker[0].length));
    } else {
      const remainder = chunk.slice(qEnd).trim();
      const solutionStart = remainder.search(/^\*\*(?:Concept|Solution|Answer|Working|Formula):\*\*/m);
      assert.ok(solutionStart >= 0, `AMD Unit 1 card ${number}: could not separate question data from its solution.`);
      questionExtra = remainder.slice(0, solutionStart).trim();
      answer = trimAnswer(remainder.slice(solutionStart));
    }
    const questionBlocks = [{ id: `amd-u1-c${number}-q-1`, type: "text", style: "paragraph", text: question }];
    if (questionExtra) questionBlocks.push(...richDocument(questionExtra, `amd-u1-c${number}-q-extra`).blocks);
    cards.push({ number, topic, question, questionDocument: { version: 1, blocks: questionBlocks }, description: metadata(chunk), answer: richDocument(answer, `amd-u1-c${number}`) });
  }
  assert.equal(cards.length, 47, "AMD Unit 1: expected 47 cards.");
  return { sourcePath, subjectSlug: "accounting-for-managerial-decisions", unitNumber: 1, unitTitle: "Unit 1: Introduction to Management Accounting and Analysis of Financial Statements", cards, topics: groupTopics(cards) };
}

function parseAmd2(markdown, sourcePath) {
  const normalized = markdown.replace(/\r/g, "");
  const start = normalized.indexOf("UNIT 2 — FINANCIAL STATEMENT ANALYSIS: RATIO ANALYSIS", 850);
  assert.ok(start >= 0, "AMD Unit 2: card bank not found.");
  const body = normalized.slice(start);
  const markers = [...body.matchAll(/^Flashcard\s+([A-Z]+)-?([A-Z0-9]+):\s*([^\n]*)/gm)];
  const cards = markers.map((marker, index) => {
    const chunk = body.slice(marker.index, markers[index + 1]?.index ?? body.length).trim();
    const code = marker[1];
    assert.ok(AMD2_TOPICS[code], `AMD Unit 2: unknown topic code ${code}.`);
    const qStart = chunk.search(/(?:^|\s)Q:\s*/m);
    const aStart = qStart >= 0 ? chunk.slice(qStart).search(/(?:^|\s)A:\s*/m) : -1;
    assert.ok(qStart >= 0 && aStart > 0, `AMD Unit 2 ${marker[1]}-${marker[2]}: Q/A markers missing.`);
    const qSection = chunk.slice(qStart).slice(0, aStart);
    const question = clean(qSection.replace(/^(?:\s*)Q:\s*/, ""));
    const answerRaw = chunk.slice(qStart + aStart).replace(/^(?:\s*)A:\s*/, "");
    const number = index + 1;
    const prependFormula = /Formula/i.test(marker[3]) ? AMD2_FORMULAS[code] ?? "" : "";
    return { number, topic: AMD2_TOPICS[code], question, description: null, answer: richDocument(trimAnswer(answerRaw), `amd-u2-c${number}`, prependFormula) };
  });
  assert.equal(cards.length, 115, "AMD Unit 2: expected 115 cards in the actual Unit 2 bank (the earlier eight lines are a template preview, not cards). ");
  return { sourcePath, subjectSlug: "accounting-for-managerial-decisions", unitNumber: 2, unitTitle: "Unit 2: Financial Statement Analysis: Ratio Analysis", cards, topics: groupTopics(cards) };
}

function parseEdm4(markdown, sourcePath) {
  const normalized = markdown.replace(/\r/g, "");
  const part = normalized.match(/## Part 2: Flashcards\s*\n([\s\S]*?)(?=\n## Part 3:)/)?.[1];
  assert.ok(part, "EDM Unit 4: Part 2 not found.");
  const sections = [...part.matchAll(/^### SECTION\s+[A-Z]+:\s*(.+)$/gm)];
  const cards = [];
  for (let s = 0; s < sections.length; s += 1) {
    const section = part.slice(sections[s].index, sections[s + 1]?.index ?? part.length);
    const topic = clean(sections[s][1]);
    const markers = [...section.matchAll(/^\*\*Card\s+(\d+):\s*(.+)\*\*\s*$/gm)];
    for (let i = 0; i < markers.length; i += 1) {
      const chunk = section.slice(markers[i].index, markers[i + 1]?.index ?? section.length).trim();
      const priorityEnd = chunk.match(/^\*\*Priority:\*\*[^\n]*\n?/m);
      const aMarker = chunk.match(/^\*\*A(?:\s*\([^)]*\))?:\*\*\s*/m);
      const start = aMarker ? aMarker.index + aMarker[0].length : priorityEnd ? priorityEnd.index + priorityEnd[0].length : markers[i][0].length;
      const number = Number(markers[i][1]);
      cards.push({ number, topic, question: clean(markers[i][2]), description: metadata(chunk), answer: richDocument(trimAnswer(chunk.slice(start)), `edm-u4-c${number}`) });
    }
  }
  assert.equal(cards.length, 43, "EDM Unit 4: expected 43 cards.");
  cards.forEach((card, index) => assert.equal(card.number, index + 1, `EDM Unit 4 card order changed at ${index + 1}.`));
  return { sourcePath, subjectSlug: "equity-and-debt-markets", unitNumber: 4, unitTitle: "Unit 4: Valuation of Equity and Bonds", cards, topics: groupTopics(cards) };
}

function parsePoe(markdown, sourcePath, unitNumber) {
  const normalized = markdown.replace(/\r/g, "");
  const sections = [...normalized.matchAll(/^# SECTION\s+[A-Z]+\s+[—-]\s+(.+)$/gm)];
  const cards = [];
  for (let s = 0; s < sections.length; s += 1) {
    const section = normalized.slice(sections[s].index, sections[s + 1]?.index ?? normalized.length);
    const topic = clean(sections[s][1]);
    const questions = [...section.matchAll(/^\*\*Question:\*\*\s*(.+)$/gm)];
    for (let i = 0; i < questions.length; i += 1) {
      const chunk = section.slice(questions[i].index, questions[i + 1]?.index ?? section.length).trim();
      const afterQuestion = chunk.slice(questions[i][0].length).trim();
      const answer = afterQuestion.replace(/^\*\*Answer:\*\*\s*/, "");
      const number = cards.length + 1;
      cards.push({ number, topic, question: clean(questions[i][1]), description: metadata(chunk), answer: richDocument(trimAnswer(answer), `poe-u${unitNumber}-c${number}`) });
    }
  }
  const expected = unitNumber === 1 ? 38 : 29;
  assert.equal(cards.length, expected, `POE Unit ${unitNumber}: expected ${expected} cards.`);
  const unitTitle = unitNumber === 1 ? "Unit 1: Macro Economics Issues and Framework" : "Unit 2: Macroeconomic Policies";
  return { sourcePath, subjectSlug: "principles-of-economics-ii", unitNumber, unitTitle, cards, topics: groupTopics(cards) };
}

function questionDocument(unit, card) {
  if (card.questionDocument) return card.questionDocument;
  return { version: 1, blocks: [{ id: `${unit.subjectSlug}-u${unit.unitNumber}-c${card.number}-q`, type: "text", style: "paragraph", text: card.question }] };
}

function auditUnit(unit) {
  const allBlocks = unit.cards.flatMap((card) => card.answer.blocks);
  return {
    source: unit.sourcePath,
    subject: unit.subjectSlug,
    unit: unit.unitTitle,
    topics: unit.topics.map((topic) => ({ title: topic.title, cards: topic.cards.length })),
    flashcards: unit.cards.length,
    blocks: allBlocks.length,
    tables: allBlocks.filter((block) => block.type === "table").length,
    bulletLists: allBlocks.filter((block) => block.type === "bulletList").length,
    numberedLists: allBlocks.filter((block) => block.type === "numberList").length,
    formulas: allBlocks.filter((block) => block.type === "formula").length,
  };
}

const sources = await Promise.all(sourcePaths.map(async (sourcePath) => ({ sourcePath, markdown: await fs.readFile(path.resolve(sourcePath), "utf8") })));
const find = (fragment) => sources.find(({ sourcePath }) => sourcePath.toLowerCase().includes(fragment));
const units = [
  parseAmd1(find("amd_unit1")?.markdown ?? "", find("amd_unit1")?.sourcePath),
  parseAmd2(find("accounting for managerial")?.markdown ?? "", find("accounting for managerial")?.sourcePath),
  parseEdm4(find("equity_debt_markets_unit4")?.markdown ?? "", find("equity_debt_markets_unit4")?.sourcePath),
  parsePoe(find("module1_macro")?.markdown ?? "", find("module1_macro")?.sourcePath, 1),
  parsePoe(find("module2_macro")?.markdown ?? "", find("module2_macro")?.sourcePath, 2),
];

for (const unit of units) {
  assert.ok(unit.sourcePath, `${unit.unitTitle}: source file was not matched.`);
  assert.equal(new Set(unit.cards.map((card) => card.question)).size, unit.cards.length, `${unit.unitTitle}: duplicate questions detected.`);
  unit.cards.forEach((card) => assert.ok(card.question && documentText(card.answer), `${unit.unitTitle}, card ${card.number}: empty content.`));
}

const audit = units.map(auditUnit);
if (!apply) {
  console.log(JSON.stringify({ mode: "dry-run", totals: { units: units.length, topics: units.reduce((n, unit) => n + unit.topics.length, 0), flashcards: units.reduce((n, unit) => n + unit.cards.length, 0) }, units: audit }, null, 2));
  process.exit(0);
}

const project = JSON.parse(await fs.readFile(path.resolve(".insforge/project.json"), "utf8"));
const baseUrl = project.oss_host || `https://${project.appkey}.${project.region}.insforge.app`;
const client = createAdminClient({ baseUrl, apiKey: project.api_key });
const createdUnitIds = [];

try {
  const verification = [];
  for (const unit of units) {
    const { data: subjects, error: subjectError } = await client.database.from("subjects").select("id,name,slug").eq("slug", unit.subjectSlug).limit(1);
    if (subjectError) throw subjectError;
    const subject = subjects?.[0];
    if (!subject) throw new Error(`Subject not found: ${unit.subjectSlug}`);
    const { data: existing, error: existingError } = await client.database.from("flashcard_units").select("id,title,sort_order").eq("subject_id", subject.id);
    if (existingError) throw existingError;
    const duplicate = existing?.find((row) => row.sort_order === unit.unitNumber || row.title.toLowerCase() === unit.unitTitle.toLowerCase());
    if (duplicate) throw new Error(`${unit.unitTitle} already exists as “${duplicate.title}”; stopped to prevent duplicates.`);

    const { data: unitRows, error: unitError } = await client.database.from("flashcard_units").insert([{ subject_id: subject.id, title: unit.unitTitle, sort_order: unit.unitNumber, is_published: true }]).select("id,title,sort_order");
    if (unitError) throw unitError;
    const unitRow = unitRows?.[0];
    if (!unitRow?.id) throw new Error(`${unit.unitTitle}: no unit id returned.`);
    createdUnitIds.push(unitRow.id);

    const { data: topics, error: topicError } = await client.database.from("flashcard_topics").insert(unit.topics.map((topic) => ({ subject_id: subject.id, unit_id: unitRow.id, title: topic.title, sort_order: topic.number, is_published: true }))).select("id,title,sort_order");
    if (topicError) throw topicError;
    assert.equal(topics?.length, unit.topics.length, `${unit.unitTitle}: topic insert count mismatch.`);
    const topicIds = new Map(topics.map((topic) => [topic.sort_order, topic.id]));
    const payload = unit.topics.flatMap((topic) => topic.cards.map((card) => ({
      subject_id: subject.id,
      content_type: "flashcard",
      flashcard_unit_id: unitRow.id,
      flashcard_topic_id: topicIds.get(topic.number),
      title: card.question,
      description: card.description ?? "",
      body: documentText(card.answer),
      question_document: questionDocument(unit, card),
      answer_document: card.answer,
      sort_order: card.number,
      is_published: true,
      file_url: null,
      file_key: null,
    })));
    const { data: inserted, error: cardError } = await client.database.from("content_items").insert(payload).select("id");
    if (cardError) throw cardError;
    assert.equal(inserted?.length, payload.length, `${unit.unitTitle}: card insert count mismatch.`);

    const { data: stored, error: storedError } = await client.database.from("content_items").select("title,body,sort_order,flashcard_topic_id,question_document,answer_document,is_published").eq("flashcard_unit_id", unitRow.id).eq("content_type", "flashcard").order("sort_order", { ascending: true });
    if (storedError) throw storedError;
    assert.equal(stored.length, payload.length, `${unit.unitTitle}: stored card count mismatch.`);
    stored.forEach((row, index) => {
      assert.equal(row.title, payload[index].title, `${unit.unitTitle}, card ${index + 1}: question changed.`);
      assert.equal(row.body, payload[index].body, `${unit.unitTitle}, card ${index + 1}: answer changed.`);
      assert.equal(row.flashcard_topic_id, payload[index].flashcard_topic_id, `${unit.unitTitle}, card ${index + 1}: topic changed.`);
      assert.deepEqual(row.question_document, payload[index].question_document, `${unit.unitTitle}, card ${index + 1}: question document changed.`);
      assert.deepEqual(row.answer_document, payload[index].answer_document, `${unit.unitTitle}, card ${index + 1}: answer document changed.`);
      assert.equal(row.is_published, true, `${unit.unitTitle}, card ${index + 1}: not published.`);
    });
    verification.push({ subject: subject.name, unit: unit.unitTitle, topics: topics.length, flashcards: stored.length, verified: true });
  }
  console.log(JSON.stringify({ mode: "applied", units: audit, verification }, null, 2));
} catch (error) {
  for (const unitId of createdUnitIds.reverse()) {
    await client.database.from("content_items").delete().eq("flashcard_unit_id", unitId);
    await client.database.from("flashcard_topics").delete().eq("unit_id", unitId);
    await client.database.from("flashcard_units").delete().eq("id", unitId);
  }
  throw error;
}
