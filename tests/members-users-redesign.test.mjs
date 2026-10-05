import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs/promises";
import path from "node:path";

async function source(relPath) {
  return fs.readFile(path.join(process.cwd(), relPath), "utf8");
}

test("Members & Users: Page header starts directly with Members & Users and Authentication Directory is removed", async () => {
  const page = await source("app/admin/members/page.tsx");

  // 1. Page Header starts directly with Members & Users title without COMMUNITY eyebrow
  assert.doesNotMatch(page, /eyebrow="COMMUNITY"/);
  assert.match(page, /title="Members & Users"/);

  // 2. Authentication Directory is completely removed
  assert.doesNotMatch(page, /Authentication Directory/);
  assert.doesNotMatch(page, /members-directory-strip/);
});

test("Members & Users Redesign: 4 Stat Cards with pastel icon containers and clickable Study Time", async () => {
  const [membersManager, enhancements] = await Promise.all([
    source("app/admin/members/MembersManager.tsx"),
    source("app/enhancements.css"),
  ]);

  // 1. Exactly 4 top statistic cards
  assert.match(membersManager, /<span>TOTAL MEMBERS<\/span>/);
  assert.match(membersManager, /<span>NEW TODAY<\/span>/);
  assert.match(membersManager, /<span>ACTIVE THIS WEEK<\/span>/);
  assert.match(membersManager, /<span>STUDY TIME THIS WEEK<\/span>/);

  // 2. Pastel icon containers for each stat card
  assert.match(membersManager, /className="members-stat-icon-wrap icon-blue"/);
  assert.match(membersManager, /className="members-stat-icon-wrap icon-green"/);
  assert.match(membersManager, /className="members-stat-icon-wrap icon-purple"/);
  assert.match(membersManager, /className="members-stat-icon-wrap icon-amber"/);

  // 3. Verified accounts & activity subtexts
  assert.match(membersManager, /<p>\{verifiedCount\} verified accounts<\/p>/);
  assert.match(membersManager, /<p>Confirmed student activity<\/p>/);
  assert.match(membersManager, /<p>Across all students<\/p>/);

  // 4. Study Time card is clickable and opens modal
  assert.match(membersManager, /className="members-stat-card clickable"/);
  assert.match(membersManager, /onClick=\{\(\) => setShowStudyStatsModal\(true\)\}/);

  // 5. CSS pastel containers defined
  assert.match(enhancements, /\.members-stat-icon-wrap\.icon-blue\s*\{/);
  assert.match(enhancements, /\.members-stat-icon-wrap\.icon-green\s*\{/);
  assert.match(enhancements, /\.members-stat-icon-wrap\.icon-purple\s*\{/);
  assert.match(enhancements, /\.members-stat-icon-wrap\.icon-amber\s*\{/);
});

test("Members & Users: New Members banner completely removed and layout collapses naturally", async () => {
  const membersManager = await source("app/admin/members/MembersManager.tsx");

  // 1. New members banner is completely removed
  assert.doesNotMatch(membersManager, /className="members-new-banner"/);
  assert.doesNotMatch(membersManager, /joined this week/);
});

test("Members & Users Redesign: Default filter values (Role: Students, Sort: Recently active)", async () => {
  const membersManager = await source("app/admin/members/MembersManager.tsx");

  // 1. Role filter default state is "student"
  assert.match(membersManager, /const\s*\[roleFilter,\s*setRoleFilter\]\s*=\s*useState<string>\("student"\);/);

  // 2. Role filter options: All Roles, Students, Administrators
  assert.match(membersManager, /<option value="all">All Roles<\/option>/);
  assert.match(membersManager, /<option value="student">Students<\/option>/);
  assert.match(membersManager, /<option value="admin">Administrators<\/option>/);

  // 3. Sort filter default state is "active" (Recently active)
  assert.match(membersManager, /const\s*\[sortKey,\s*setSortKey\]\s*=\s*useState<[^>]*>\("active"\);/);

  // 4. Sort filter options preserved
  assert.match(membersManager, /<option value="newest">Newest first<\/option>/);
  assert.match(membersManager, /<option value="active">Recently active<\/option>/);
  assert.match(membersManager, /<option value="study_time">Most study time<\/option>/);
  assert.match(membersManager, /<option value="name">Name A-Z<\/option>/);
  assert.match(membersManager, /<option value="oldest">Oldest first<\/option>/);
});

test("Members & Users Redesign: Data table structure and column hierarchy", async () => {
  const [membersManager, enhancements] = await Promise.all([
    source("app/admin/members/MembersManager.tsx"),
    source("app/enhancements.css"),
  ]);

  // 1. 6 table columns
  assert.match(membersManager, /<span>MEMBER<\/span>/);
  assert.match(membersManager, /<span>EMAIL<\/span>/);
  assert.match(membersManager, /<span>ROLE<\/span>/);
  assert.match(membersManager, /<span>STUDY TIME<\/span>/);
  assert.match(membersManager, /<span>REGISTRATION DATE<\/span>/);
  assert.match(membersManager, /<span>LAST ACTIVE<\/span>/);

  // 2. Member initials, badges, and roles
  assert.match(membersManager, /className=\{`members-avatar \$\{isAdmin \? "avatar-admin" : ""\}`\}/);
  assert.match(membersManager, /className="members-new-pill today">NEW TODAY<\/span>/);
  assert.match(membersManager, /className="members-new-pill week">NEW THIS WEEK<\/span>/);
  assert.match(membersManager, /className=\{`members-role-badge \$\{isAdmin \? "badge-admin" : "badge-student"\}`\}/);

  // 3. Study time pill with clock icon
  assert.match(membersManager, /className=\{`members-study-pill \$\{studySeconds > 0 \? "has-time" : "zero-time"\}`\}/);

  // 4. Registration date & Last Active timestamps with relative secondary text
  assert.match(membersManager, /<b>\{formatIst\(member\.created_at\)\}<\/b>/);
  assert.match(membersManager, /<small>\{timeAgo\(member\.created_at\)\}<\/small>/);
  assert.match(membersManager, /<b>\{formatIst\(lastActiveTime\)\}<\/b>/);
  assert.match(membersManager, /<small>\{timeAgo\(lastActiveTime\)\}<\/small>/);

  // 5. Empty state minimal markup
  assert.match(membersManager, /className="members-empty-state"/);
  assert.match(membersManager, /<b>No members found<\/b>/);
  assert.match(membersManager, /className="members-empty-reset"/);
});
