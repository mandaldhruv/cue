import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs/promises";
import path from "node:path";

async function source(relPath) {
  return fs.readFile(path.join(process.cwd(), relPath), "utf8");
}

test("Members & Users Stat Cards: Desktop/Laptop preserves 4-column layout and vertical card styling", async () => {
  const css = await source("app/enhancements.css");

  // 1. Desktop grid: 4 columns
  assert.match(
    css,
    /\.members-stat-grid\s*\{[^}]*grid-template-columns:\s*repeat\(4,\s*minmax\(0,\s*1fr\)\)/
  );

  // 2. Desktop card layout: flex-direction column, min-height 144px
  assert.match(
    css,
    /\.members-stat-card\s*\{[^}]*flex-direction:\s*column/
  );
  assert.match(
    css,
    /\.members-stat-card\s*\{[^}]*min-height:\s*144px/
  );
});

test("Members & Users Stat Cards: Tablet/iPad matches Dashboard stat cards in 2-column compact sizing", async () => {
  const css = await source("app/enhancements.css");

  // 1. Tablet media query: 2-column grid
  assert.match(
    css,
    /@media\s*\(max-width:\s*1200px\)[\s\S]*?\.members-stat-grid\s*\{[^}]*grid-template-columns:\s*repeat\(2,\s*minmax\(0,\s*1fr\)\)/
  );

  // 2. Tablet card: horizontal grid layout matching Dashboard
  assert.match(
    css,
    /@media\s*\(max-width:\s*1200px\)[\s\S]*?\.members-stat-card\s*\{[^}]*grid-template-areas:\s*"icon title"\s*"icon number"\s*"icon desc"/
  );
  assert.match(
    css,
    /@media\s*\(max-width:\s*1200px\)[\s\S]*?\.members-stat-card\s*\{[^}]*min-height:\s*84px/
  );
  assert.match(
    css,
    /@media\s*\(max-width:\s*1200px\)[\s\S]*?\.members-stat-card\s*\{[^}]*padding:\s*14px 16px/
  );

  // 3. Tablet icon wrap: 42px x 42px (matching Dashboard)
  assert.match(
    css,
    /@media\s*\(max-width:\s*1200px\)[\s\S]*?\.members-stat-icon-wrap\s*\{[^}]*width:\s*42px/
  );

  // 4. Tablet typography: span 10px, b 24px, p 11px
  assert.match(
    css,
    /@media\s*\(max-width:\s*1200px\)[\s\S]*?\.members-stat-card > span\s*\{[^}]*font-size:\s*10px|font:\s*750 10px/
  );
  assert.match(
    css,
    /@media\s*\(max-width:\s*1200px\)[\s\S]*?\.members-stat-card > b\s*\{[^}]*font-size:\s*24px/
  );
  assert.match(
    css,
    /@media\s*\(max-width:\s*1200px\)[\s\S]*?\.members-stat-card > p\s*\{[^}]*font-size:\s*11px/
  );
});

test("Members & Users Stat Cards: Mobile matches Dashboard stat cards in compact 72px 2-column sizing", async () => {
  const css = await source("app/enhancements.css");

  // 1. Mobile media query: 2-column grid
  assert.match(
    css,
    /@media\s*\(max-width:\s*680px\)[\s\S]*?\.members-stat-grid\s*\{[^}]*grid-template-columns:\s*repeat\(2,\s*minmax\(0,\s*1fr\)\)/
  );

  // 2. Mobile card: min-height 72px, padding 10px 12px, gap 10px (matching Dashboard)
  assert.match(
    css,
    /@media\s*\(max-width:\s*680px\)[\s\S]*?\.members-stat-card\s*\{[^}]*min-height:\s*72px/
  );
  assert.match(
    css,
    /@media\s*\(max-width:\s*680px\)[\s\S]*?\.members-stat-card\s*\{[^}]*padding:\s*10px 12px/
  );
  assert.match(
    css,
    /@media\s*\(max-width:\s*680px\)[\s\S]*?\.members-stat-card\s*\{[^}]*column-gap:\s*10px/
  );

  // 3. Mobile icon wrap: 36px x 36px (matching Dashboard)
  assert.match(
    css,
    /@media\s*\(max-width:\s*680px\)[\s\S]*?\.members-stat-icon-wrap\s*\{[^}]*width:\s*36px/
  );

  // 4. Mobile typography: span 8.5px, b 20px, p 10px (matching Dashboard)
  assert.match(
    css,
    /@media\s*\(max-width:\s*680px\)[\s\S]*?\.members-stat-card > span\s*\{[^}]*font-size:\s*8\.5px/
  );
  assert.match(
    css,
    /@media\s*\(max-width:\s*680px\)[\s\S]*?\.members-stat-card > b\s*\{[^}]*font-size:\s*20px/
  );
  assert.match(
    css,
    /@media\s*\(max-width:\s*680px\)[\s\S]*?\.members-stat-card > p\s*\{[^}]*font-size:\s*10px/
  );
});

test("Members & Users Stat Cards: Small mobile (<= 360px) matches Dashboard stat cards in 66px sizing", async () => {
  const css = await source("app/enhancements.css");

  // 1. Small mobile card: min-height 66px, padding 8px 10px, gap 8px (matching Dashboard)
  assert.match(
    css,
    /@media\s*\(max-width:\s*360px\)[\s\S]*?\.members-stat-card\s*\{[^}]*min-height:\s*66px/
  );
  assert.match(
    css,
    /@media\s*\(max-width:\s*360px\)[\s\S]*?\.members-stat-card\s*\{[^}]*padding:\s*8px 10px/
  );
  assert.match(
    css,
    /@media\s*\(max-width:\s*360px\)[\s\S]*?\.members-stat-card\s*\{[^}]*column-gap:\s*8px/
  );

  // 2. Small mobile icon wrap: 32px x 32px (matching Dashboard)
  assert.match(
    css,
    /@media\s*\(max-width:\s*360px\)[\s\S]*?\.members-stat-icon-wrap\s*\{[^}]*width:\s*32px/
  );

  // 3. Small mobile typography: span 8px, b 18px, p 9.5px (matching Dashboard)
  assert.match(
    css,
    /@media\s*\(max-width:\s*360px\)[\s\S]*?\.members-stat-card > span\s*\{[^}]*font-size:\s*8px/
  );
  assert.match(
    css,
    /@media\s*\(max-width:\s*360px\)[\s\S]*?\.members-stat-card > b\s*\{[^}]*font-size:\s*18px/
  );
  assert.match(
    css,
    /@media\s*\(max-width:\s*360px\)[\s\S]*?\.members-stat-card > p\s*\{[^}]*font-size:\s*9\.5px/
  );
});

test("Members & Users Stat Cards: JSX card content, icons, and click handlers are completely preserved", async () => {
  const manager = await source("app/admin/members/MembersManager.tsx");

  assert.match(manager, /TOTAL MEMBERS/);
  assert.match(manager, /NEW TODAY/);
  assert.match(manager, /ACTIVE THIS WEEK/);
  assert.match(manager, /STUDY TIME THIS WEEK/);
  assert.match(manager, /className="members-stat-card clickable"/);
  assert.match(manager, /setShowStudyStatsModal\(true\)/);
});
