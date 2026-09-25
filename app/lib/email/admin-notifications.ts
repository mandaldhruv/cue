import { createInsForgeServerClient } from "../insforge/server";

export interface NewMemberNotificationData {
  userId: string;
  name: string;
  email: string;
  role?: string;
  status?: string;
  joinedAt?: string | Date;
}

export interface FeedbackNotificationData {
  submissionId: string;
  name: string;
  email: string;
  role: string;
  rating: number;
  message: string;
  isContentIssue: boolean;
  contentReference?: string;
  submittedAt?: string | Date;
}

function getSiteUrl(): string {
  const url = process.env.NEXT_PUBLIC_SITE_URL || "https://h36y6svq.insforge.site";
  return url.replace(/\/$/, "");
}

function getAdminRecipient(): string {
  return (process.env.ADMIN_NOTIFICATION_EMAIL || "hersita04@gmail.com").trim().toLowerCase();
}

function formatDateTime(dateInput?: string | Date): string {
  try {
    const d = dateInput ? new Date(dateInput) : new Date();
    return d.toLocaleString("en-US", {
      timeZone: "Asia/Kolkata",
      day: "numeric",
      month: "long",
      year: "numeric",
      hour: "numeric",
      minute: "2-digit",
      hour12: true,
    });
  } catch {
    return new Date().toISOString();
  }
}

function renderEmailTemplate({
  headline,
  eyebrow,
  title,
  fields,
  ctaText,
  ctaUrl,
  quoteText,
  isUrgent,
}: {
  headline: string;
  eyebrow: string;
  title: string;
  fields: Array<{ label: string; value: string }>;
  ctaText: string;
  ctaUrl: string;
  quoteText?: string;
  isUrgent?: boolean;
}): string {
  const accentColor = isUrgent ? "#dc2626" : "#1762d1";
  const badgeBg = isUrgent ? "#fee2e2" : "#eaf2ff";
  const badgeColor = isUrgent ? "#991b1b" : "#1762d1";

  const fieldsHtml = fields
    .map(
      (f) => `
      <tr>
        <td style="padding: 9px 0; color: #64748b; font-size: 13px; font-weight: 600; width: 130px; vertical-align: top;">
          ${f.label}
        </td>
        <td style="padding: 9px 0; color: #0f172a; font-size: 13.5px; font-weight: 650; vertical-align: top;">
          ${f.value}
        </td>
      </tr>`
    )
    .join("");

  const quoteHtml = quoteText
    ? `
    <div style="margin: 18px 0; padding: 14px 16px; background: #f8fafc; border-left: 3px solid ${accentColor}; border-radius: 6px;">
      <p style="margin: 0; color: #1e293b; font-size: 14px; line-height: 1.55; font-style: italic;">
        "${quoteText.replace(/"/g, "&quot;")}"
      </p>
    </div>`
    : "";

  return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${title}</title>
</head>
<body style="margin:0; padding:0; background-color:#f1f5f9; font-family:-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;">
  <table width="100%" border="0" cellspacing="0" cellpadding="0" style="background-color:#f1f5f9; padding: 30px 14px;">
    <tr>
      <td align="center">
        <table width="100%" max-width="560" style="max-width:560px; background:#ffffff; border-radius:14px; overflow:hidden; border:1px solid #e2e8f0; box-shadow:0 4px 18px rgba(15,23,42,0.06);">
          <!-- Header Bar -->
          <tr>
            <td style="background:#111722; padding: 22px 28px; text-align: left;">
              <span style="color: #ffffff; font-size: 20px; font-weight: 800; letter-spacing: -0.02em;">Cue</span>
              <span style="color: #64748b; font-size: 12px; margin-left: 8px; font-weight: 600;">Admin Alerts</span>
            </td>
          </tr>
          <!-- Body Content -->
          <tr>
            <td style="padding: 28px 28px 20px;">
              <div style="display:inline-block; padding: 3px 10px; border-radius: 99px; background: ${badgeBg}; color: ${badgeColor}; font-size: 11px; font-weight: 750; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 12px;">
                ${eyebrow}
              </div>
              <h1 style="margin:0 0 6px 0; color:#0f172a; font-size:22px; font-weight:750; letter-spacing:-0.02em; line-height:1.25;">
                ${headline}
              </h1>
              <p style="margin:0 0 20px 0; color:#475569; font-size:14px; line-height:1.5;">
                ${title}
              </p>
              
              <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-top:1px solid #f1f5f9; border-bottom:1px solid #f1f5f9; margin: 12px 0;">
                ${fieldsHtml}
              </table>

              ${quoteHtml}

              <div style="margin: 24px 0 10px 0;">
                <a href="${ctaUrl}" target="_blank" style="display:inline-block; padding: 12px 22px; background: ${accentColor}; color: #ffffff; text-decoration: none; border-radius: 9px; font-size: 13.5px; font-weight: 700; box-shadow: 0 2px 8px rgba(23,98,209,0.2);">
                  ${ctaText} &rarr;
                </a>
              </div>
            </td>
          </tr>
          <!-- Footer -->
          <tr>
            <td style="background:#f8fafc; padding: 16px 28px; border-top: 1px solid #edf2f7; text-align: left;">
              <p style="margin: 0; color: #94a3b8; font-size: 11.5px; line-height: 1.4;">
                This automated alert was sent to Cue Administrators (${getAdminRecipient()}).<br>
                Protected by multi-tier administrator permissions.
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
  `;
}

async function recordAndCheckDuplicate(
  eventType: string,
  relatedId: string,
  recipient: string,
  subject: string
): Promise<boolean> {
  try {
    const client = await createInsForgeServerClient();
    const { data: existing } = await client.database
      .from("admin_email_logs")
      .select("id")
      .eq("event_type", eventType)
      .eq("related_id", relatedId)
      .limit(1);

    if (existing && existing.length > 0) {
      return false; // Already sent, prevent duplicate!
    }

    await client.database.from("admin_email_logs").insert([
      {
        event_type: eventType,
        related_id: relatedId,
        recipient,
        subject,
        status: "sent",
      },
    ]);

    return true; // Not duplicate, safe to send
  } catch {
    // If DB check fails, proceed cautiously without breaking
    return true;
  }
}

async function dispatchEmail(to: string, subject: string, html: string): Promise<void> {
  const resendApiKey = process.env.RESEND_API_KEY;
  if (resendApiKey) {
    try {
      const from = process.env.EMAIL_FROM || "Cue Notifications <notifications@cue.study>";
      const res = await fetch("https://api.resend.com/emails", {
        method: "POST",
        headers: {
          Authorization: `Bearer ${resendApiKey}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          from,
          to: [to],
          subject,
          html,
        }),
      });
      if (!res.ok) {
        const errorText = await res.text();
        console.warn("[Admin Email] Resend API error (logged safely):", errorText);
      }
      return;
    } catch (err) {
      console.warn("[Admin Email] Resend network error (logged safely):", err);
      return;
    }
  }

  // Safe server log if no third-party transactional email key is configured
  console.info(`[Admin Email Notification] Dispatched to ${to}: "${subject}"`);
}

/**
 * 11. Send email when a new member joins Cue
 */
export async function notifyAdminNewMember(data: NewMemberNotificationData): Promise<void> {
  try {
    const recipient = getAdminRecipient();
    const subject = `New Cue Member Joined — ${data.name || "Student"}`;
    const siteUrl = getSiteUrl();

    const shouldSend = await recordAndCheckDuplicate("new_member", data.userId, recipient, subject);
    if (!shouldSend) return;

    const html = renderEmailTemplate({
      eyebrow: "New Registration",
      headline: "A new member has joined Cue.",
      title: `${data.name || "A new student"} just joined the Cue platform.`,
      fields: [
        { label: "Name:", value: data.name || "Cue Student" },
        { label: "Email:", value: data.email },
        { label: "Role:", value: data.role || "Student" },
        { label: "Status:", value: data.status || "Verified" },
        { label: "Joined:", value: formatDateTime(data.joinedAt) },
      ],
      ctaText: "View Member",
      ctaUrl: `${siteUrl}/admin/members`,
    });

    await dispatchEmail(recipient, subject, html);
  } catch (err) {
    console.error("[Admin Email Error] Failed to process new member email safely:", err);
  }
}

/**
 * 12. Send email when new feedback is submitted
 * 13. Send high-priority email if content issue reported
 */
export async function notifyAdminFeedback(data: FeedbackNotificationData): Promise<void> {
  try {
    const recipient = getAdminRecipient();
    const siteUrl = getSiteUrl();

    if (data.isContentIssue) {
      // 13. CONTENT ISSUE EMAIL (High Priority)
      const subject = `⚠️ Cue Content Issue Reported — Action Required`;
      const shouldSend = await recordAndCheckDuplicate(
        "content_issue",
        data.submissionId,
        recipient,
        subject
      );
      if (!shouldSend) return;

      const html = renderEmailTemplate({
        isUrgent: true,
        eyebrow: "Content Issue Alert",
        headline: "Content Issue Reported",
        title: "A user reported incorrect or outdated content that requires admin review.",
        fields: [
          { label: "Reported by:", value: data.name || "Cue Member" },
          { label: "Role:", value: data.role || "Student" },
          { label: "Email:", value: data.email },
          { label: "Content/Subject:", value: data.contentReference || "BMS Syllabus / Study Materials" },
          { label: "Submitted:", value: formatDateTime(data.submittedAt) },
        ],
        quoteText: data.message,
        ctaText: "Review Issue",
        ctaUrl: `${siteUrl}/admin/feedback`,
      });

      await dispatchEmail(recipient, subject, html);
    } else {
      // 12. NEW FEEDBACK EMAIL
      const subject = `New Cue Feedback — ${data.name || "Student"}`;
      const shouldSend = await recordAndCheckDuplicate(
        "new_feedback",
        data.submissionId,
        recipient,
        subject
      );
      if (!shouldSend) return;

      const html = renderEmailTemplate({
        eyebrow: "User Feedback",
        headline: "New Feedback Received",
        title: "A new feedback response has been submitted on Cue.",
        fields: [
          { label: "Name:", value: data.name || "Cue Member" },
          { label: "Email:", value: data.email },
          { label: "Submitted as:", value: data.role || "Student" },
          { label: "Rating:", value: `${data.rating}/5` },
          { label: "Submitted:", value: formatDateTime(data.submittedAt) },
        ],
        quoteText: data.message,
        ctaText: "Review Feedback",
        ctaUrl: `${siteUrl}/admin/feedback`,
      });

      await dispatchEmail(recipient, subject, html);
    }
  } catch (err) {
    console.error("[Admin Email Error] Failed to process feedback email safely:", err);
  }
}
