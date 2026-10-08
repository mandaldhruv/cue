import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';

// Supabase project config
const PROJECT_REF = 'yxuxwcaldluhmteupzhp';
const SUPABASE_URL = `https://${PROJECT_REF}.supabase.co`;

const APPROVED_ASSETS = [
  {
    name: 'Harshita Singh Headshot',
    bucket: 'cue-testimonials',
    fileKey: '2a816127-3a7d-4d66-a2fe-c2d9ceabadf2/20232fce-f7d8-46d1-8dbc-95126d1e3e18-a65db50f-c0aa-4c56-97a3-d514d6135321.jpeg',
    mimeType: 'image/jpeg',
    expectedSize: 274148,
    expectedSha256: '519cfceffd0eb5d8e1df032d27d0756b3f9168880afbaf130d837959c6f33a4b',
    localRelPath: 'cue-testimonials/2a816127-3a7d-4d66-a2fe-c2d9ceabadf2/20232fce-f7d8-46d1-8dbc-95126d1e3e18-a65db50f-c0aa-4c56-97a3-d514d6135321.jpeg'
  },
  {
    name: 'Rupal Shroff Headshot',
    bucket: 'cue-testimonials',
    fileKey: 'a8cd6602-5e4a-4a27-a068-3ff4e4023472/4f2284a9-b1ff-48ba-88c9-d227fecf2081-1000012038.jpg',
    mimeType: 'image/jpeg',
    expectedSize: 241650,
    expectedSha256: '038ec533c2b3423ebdf852a3542785bf6a45654608ab01b353a0ce206471b5a1',
    localRelPath: 'cue-testimonials/a8cd6602-5e4a-4a27-a068-3ff4e4023472/4f2284a9-b1ff-48ba-88c9-d227fecf2081-1000012038.jpg'
  },
  {
    name: 'Elementary Hindi — Oct 2025',
    bucket: 'cue-pyqs',
    fileKey: 'd585435a-10fa-4be9-91af-5303a4204ef8/2025/a3d40074-6d7d-4814-b472-729b40020dea-elementary-hindi-2025.pdf',
    mimeType: 'application/pdf',
    expectedSize: 29133,
    expectedSha256: '498155ccede87a5bc22092b00ca8263683caafabaf4d3a3b94d1f33a915bed7d',
    localRelPath: 'cue-pyqs/d585435a-10fa-4be9-91af-5303a4204ef8/2025/a3d40074-6d7d-4814-b472-729b40020dea-elementary-hindi-2025.pdf'
  },
  {
    name: 'Hindi — Oct 2024',
    bucket: 'cue-pyqs',
    fileKey: 'd585435a-10fa-4be9-91af-5303a4204ef8/2024/60b1d853-d433-44fc-a32f-9e24da32368d-hindi-october-2024-1-.pdf',
    mimeType: 'application/pdf',
    expectedSize: 2526652,
    expectedSha256: '9e6cd81aec3dce1ed61104fb315ecc82116edebc810ea0222f45f4404ae7eae4',
    localRelPath: 'cue-pyqs/d585435a-10fa-4be9-91af-5303a4204ef8/2024/60b1d853-d433-44fc-a32f-9e24da32368d-hindi-october-2024-1-.pdf'
  },
  {
    name: 'Principles of Economics II — Oct 2024',
    bucket: 'cue-pyqs',
    fileKey: '5c93c785-bc3e-4489-969c-9ec5f21c174a/2024/5b08ca41-bfde-4c9c-b868-47645752f4e5-principles-of-economics-ii-oct2024.pdf',
    mimeType: 'application/pdf',
    expectedSize: 3557715,
    expectedSha256: '813d90b906274a606cd1cd7bea95f81c5d39d58a782e72880ad7d9d89c93b63d',
    localRelPath: 'cue-pyqs/5c93c785-bc3e-4489-969c-9ec5f21c174a/2024/5b08ca41-bfde-4c9c-b868-47645752f4e5-principles-of-economics-ii-oct2024.pdf'
  },
  {
    name: 'BPEM — Oct 2024',
    bucket: 'cue-pyqs',
    fileKey: '1ba3fabc-a2c8-4c58-a388-cb07c2a4d70d/2024/17f11253-9a68-4903-abe7-70c1a288dbc7-business-planning-and-entrepreneurship-management-oct2024.pdf',
    mimeType: 'application/pdf',
    expectedSize: 6515354,
    expectedSha256: 'c4db494fd9ed818d86fe87e33d2d97afad49b3f5ce2951a89cd3b23380362f3d',
    localRelPath: 'cue-pyqs/1ba3fabc-a2c8-4c58-a388-cb07c2a4d70d/2024/17f11253-9a68-4903-abe7-70c1a288dbc7-business-planning-and-entrepreneurship-management-oct2024.pdf'
  },
  {
    name: 'Equity and Debt Markets — Oct 2024',
    bucket: 'cue-pyqs',
    fileKey: '4942b243-3eda-4100-9200-942a29e98d11/2024/d6749521-e7ca-476a-9bec-45fd90d26a33-equity-and-debt-markets-oct2024.pdf',
    mimeType: 'application/pdf',
    expectedSize: 4430616,
    expectedSha256: '734d00d8659ad27f6cc73c2a4738389a67401bdebdbe72cf78cfff257bf5f244',
    localRelPath: 'cue-pyqs/4942b243-3eda-4100-9200-942a29e98d11/2024/d6749521-e7ca-476a-9bec-45fd90d26a33-equity-and-debt-markets-oct2024.pdf'
  }
];

async function getSecretKey() {
  if (process.argv[2] && process.argv[2] !== '-') {
    return process.argv[2].trim();
  }
  if (process.env.SUPABASE_SERVICE_ROLE_KEY) {
    return process.env.SUPABASE_SERVICE_ROLE_KEY.trim();
  }
  return new Promise((resolve) => {
    let input = '';
    process.stdin.on('data', chunk => { input += chunk; });
    process.stdin.on('end', () => { resolve(input.trim()); });
  });
}

async function main() {
  const secretKey = await getSecretKey();
  if (!secretKey) {
    console.error('ERROR: Missing Supabase Service Role Key.');
    process.exit(1);
  }

  const baseDir = path.resolve('migration/supabase/storage-assets');
  console.log('======================================================================');
  console.log('STAGE 3C: SUPABASE STORAGE UPLOADER');
  console.log(`Target Host: ${SUPABASE_URL}`);
  console.log(`Total Approved Assets to Upload: ${APPROVED_ASSETS.length}`);
  console.log('======================================================================\n');

  let successCount = 0;
  const results = [];

  for (let i = 0; i < APPROVED_ASSETS.length; i++) {
    const item = APPROVED_ASSETS[i];
    const fullPath = path.join(baseDir, item.localRelPath);

    console.log(`[${i + 1}/${APPROVED_ASSETS.length}] PRE-UPLOAD CHECK: ${item.name}`);
    console.log(`  Bucket: ${item.bucket}`);
    console.log(`  Target Key: ${item.fileKey}`);

    if (!fs.existsSync(fullPath)) {
      console.error(`  FAIL: Local staged file missing at ${fullPath}`);
      results.push({ name: item.name, status: 'FAILED_MISSING_LOCAL' });
      continue;
    }

    const fileBuf = fs.readFileSync(fullPath);
    const actualSize = fileBuf.length;
    const actualSha256 = crypto.createHash('sha256').update(fileBuf).digest('hex');

    console.log(`  Local Size Check: ${actualSize} B (Expected: ${item.expectedSize} B) -> ${actualSize === item.expectedSize ? 'PASS' : 'FAIL'}`);
    console.log(`  SHA-256 Check: ${actualSha256} -> ${actualSha256 === item.expectedSha256 ? 'PASS' : 'FAIL'}`);
    console.log(`  MIME Type: ${item.mimeType}`);

    if (actualSize !== item.expectedSize || actualSha256 !== item.expectedSha256) {
      console.error(`  FAIL: Integrity check failed! Aborting upload for this item.`);
      results.push({ name: item.name, status: 'FAILED_INTEGRITY' });
      continue;
    }

    // Supabase Storage REST API: POST /storage/v1/object/<bucket>/<path>
    const url = `${SUPABASE_URL}/storage/v1/object/${item.bucket}/${encodeURIComponent(item.fileKey).replace(/%2F/g, '/')}`;

    try {
      const res = await fetch(url, {
        method: 'POST',
        headers: {
          'apikey': secretKey,
          'Authorization': `Bearer ${secretKey}`,
          'Content-Type': item.mimeType,
          'x-upsert': 'true'
        },
        body: fileBuf
      });

      if (!res.ok) {
        const errText = await res.text();
        console.error(`  UPLOAD HTTP ERROR: ${res.status} ${res.statusText} - ${errText}`);
        results.push({ name: item.name, status: `HTTP_${res.status}`, error: errText });
      } else {
        const json = await res.json().catch(() => ({}));
        console.log(`  UPLOAD STATUS: HTTP ${res.status} OK`);
        console.log(`  UPLOAD RESPONSE:`, JSON.stringify(json));
        successCount++;
        results.push({
          name: item.name,
          bucket: item.bucket,
          fileKey: item.fileKey,
          size: actualSize,
          sha256: actualSha256,
          mime: item.mimeType,
          status: 'UPLOAD_SUCCESS'
        });
      }
    } catch (err) {
      console.error(`  UPLOAD NETWORK ERROR: ${err.message}`);
      results.push({ name: item.name, status: 'NETWORK_ERROR', error: err.message });
    }
    console.log('');
  }

  console.log('======================================================================');
  console.log(`STAGE 3C UPLOAD COMPLETED: ${successCount} / ${APPROVED_ASSETS.length} SUCCESSFUL`);
  console.log('======================================================================\n');
}

main().catch(err => {
  console.error('Fatal error during execution:', err.message);
  process.exit(1);
});
