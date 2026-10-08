-- ==============================================================================
-- CUE BACKEND MIGRATION: STAGE 3 — CONTENT ITEMS (PART 4 OF 4: rows 526 to 698)
-- TARGET: Supabase PostgreSQL (Project ID: yxuxwcaldluhmteupzhp)
-- SAFE: Idempotent (ON CONFLICT DO NOTHING), Transaction-wrapped
-- ==============================================================================
BEGIN;

INSERT INTO public.content_items (
  id, subject_id, content_type, title, description, body, academic_year, file_url, file_key, sort_order, is_published, exam_type, file_name, file_size_bytes, submission_id, flashcard_unit_id, flashcard_topic_id, question_document, answer_document, created_at, updated_at
) VALUES
('81e43295-09e7-47b0-b151-cd650793cd36', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How should Capital Gearing Ratio be interpreted?', '', 'High Gearing (Ratio \> 1:1):

Positive: Higher return on equity (if company earns more than interest cost) Positive: Tax advantage (interest is tax-deductible)

Negative: High financial risk (fixed obligations regardless of profit) Negative: Difficulty in raising additional debt during downturns Low Gearing (Ratio \< 1:1):

Positive: Low financial risk, stable capital structure

Positive: Flexibility to raise debt when needed

Negative: Lower return on equity (no trading on equity)

Negative: Missing tax shield benefit of debt

2022 PYQ: Capital Gearing Ratio explicitly tested with interpretation.', NULL, NULL, NULL, 52, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '194c8938-6c54-46c2-863c-de7a9ad6387c', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c52-q", "text": "How should Capital Gearing Ratio be interpreted?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c52-1", "text": "High Gearing (Ratio \\> 1:1):", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c52-2", "text": "Positive: Higher return on equity (if company earns more than interest cost) Positive: Tax advantage (interest is tax-deductible)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c52-3", "text": "Negative: High financial risk (fixed obligations regardless of profit) Negative: Difficulty in raising additional debt during downturns Low Gearing (Ratio \\< 1:1):", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c52-4", "text": "Positive: Low financial risk, stable capital structure", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c52-5", "text": "Positive: Flexibility to raise debt when needed", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c52-6", "text": "Negative: Lower return on equity (no trading on equity)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c52-7", "text": "Negative: Missing tax shield benefit of debt", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c52-8", "text": "2022 PYQ: Capital Gearing Ratio explicitly tested with interpretation.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('7ee4c68c-73ed-44cb-bf88-ca4d74901efe', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'Calculate Capital Gearing Ratio: Liabilities: Equity Share Capital: ₹6,00,000 10% Preference Share Capital: ₹3,00,000 General Reserve: ₹2,00,000 P&L (Credit): ₹1,00,000 12% Debentures: ₹4,00,000 Long-term Bank Loan: ₹2,00,000 Creditors: ₹1,50,000', '', 'Solution:

Step 1: Calculate Fixed-Interest-Bearing Capital

10% Preference Share Capital: ₹3,00,000

12% Debentures: ₹4,00,000

Long-term Bank Loan: ₹2,00,000

Total Fixed-Interest Capital: ₹9,00,000

Step 2: Calculate Equity Shareholders'' Funds

Equity Share Capital: ₹6,00,000

General Reserve: ₹2,00,000

P&L (Credit): ₹1,00,000

Total Equity Shareholders'' Funds: ₹9,00,000

(Exclude Preference Capital - already in numerator)

Step 3: Apply Formula

Interpretation: The ratio of 1:1 indicates balanced gearing. Fixed-cost capital equals equity shareholders'' funds. The company has moderate financial leverage with balanced risk-return profile.', NULL, NULL, NULL, 53, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '194c8938-6c54-46c2-863c-de7a9ad6387c', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c53-q", "text": "Calculate Capital Gearing Ratio: Liabilities: Equity Share Capital: ₹6,00,000 10% Preference Share Capital: ₹3,00,000 General Reserve: ₹2,00,000 P&L (Credit): ₹1,00,000 12% Debentures: ₹4,00,000 Long-term Bank Loan: ₹2,00,000 Creditors: ₹1,50,000", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c53-1", "text": "Solution:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c53-2", "text": "Step 1: Calculate Fixed-Interest-Bearing Capital", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c53-3", "text": "10% Preference Share Capital: ₹3,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c53-4", "text": "12% Debentures: ₹4,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c53-5", "text": "Long-term Bank Loan: ₹2,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c53-6", "text": "Total Fixed-Interest Capital: ₹9,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c53-7", "text": "Step 2: Calculate Equity Shareholders'' Funds", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c53-8", "text": "Equity Share Capital: ₹6,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c53-9", "text": "General Reserve: ₹2,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c53-10", "text": "P&L (Credit): ₹1,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c53-11", "text": "Total Equity Shareholders'' Funds: ₹9,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c53-12", "text": "(Exclude Preference Capital - already in numerator)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c53-13", "text": "Step 3: Apply Formula", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c53-14", "text": "Interpretation: The ratio of 1:1 indicates balanced gearing. Fixed-cost capital equals equity shareholders'' funds. The company has moderate financial leverage with balanced risk-return profile.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('c3aab371-b700-4621-8b56-5fe8c2cfdaab', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What errors occur in Capital Gearing Ratio?', '', 'Common Errors:

Including Equity in Numerator — Adding Equity Share Capital to Fixed-Interest Capital

Including Preference in Denominator — Adding Preference Capital to Equity Shareholders'' Funds

Missing Long-term Loans — Forgetting Bank Loans, Public Deposits

Confusing with Debt-Equity — Different denominator (Total Equity vs. Equity Shareholders only)

Not Deducting Fictitious Assets — Including Preliminary Expenses in Equity Critical Distinction:

Numerator: Preference + Debt (fixed-cost capital)

Denominator: Equity Shareholders only (variable-return capital)', NULL, NULL, NULL, 54, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '194c8938-6c54-46c2-863c-de7a9ad6387c', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c54-q", "text": "What errors occur in Capital Gearing Ratio?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c54-1", "text": "Common Errors:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c54-2", "type": "numberList", "items": ["Including Equity in Numerator — Adding Equity Share Capital to Fixed-Interest Capital"]}, {"id": "amd-u2-c54-3", "type": "numberList", "items": ["Including Preference in Denominator — Adding Preference Capital to Equity Shareholders'' Funds"]}, {"id": "amd-u2-c54-4", "type": "numberList", "items": ["Missing Long-term Loans — Forgetting Bank Loans, Public Deposits"]}, {"id": "amd-u2-c54-5", "type": "numberList", "items": ["Confusing with Debt-Equity — Different denominator (Total Equity vs. Equity Shareholders only)"]}, {"id": "amd-u2-c54-6", "type": "numberList", "items": ["Not Deducting Fictitious Assets — Including Preliminary Expenses in Equity Critical Distinction:"]}, {"id": "amd-u2-c54-7", "text": "Numerator: Preference + Debt (fixed-cost capital)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c54-8", "text": "Denominator: Equity Shareholders only (variable-return capital)", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('32617589-5f94-477c-b581-7592eb6fc649', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How might Capital Gearing Ratio be tested?', '', 'Variations:

High/Low Gearing Classification: "State whether the company is highly or lowly geared" 2. Combined Question: Calculate with Debt-Equity Ratio, Proprietary Ratio 3. Interpretation: "Comment on the financial risk from capital structure"

Missing Figure: "Capital Gearing is 0.8:1, Equity Shareholders'' Funds ₹10,00,000. Find Fixed-Interest Capital"

Trend Analysis: Calculate for multiple years to show changing leverage

SECTION D: REVENUE STATEMENT RATIOS

Tier 1: Extremely High Priority (Strong PYQ Evidence)

GROSS PROFIT RATIO', NULL, NULL, NULL, 55, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '194c8938-6c54-46c2-863c-de7a9ad6387c', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c55-q", "text": "How might Capital Gearing Ratio be tested?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c55-1", "text": "Variations:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c55-2", "type": "numberList", "items": ["High/Low Gearing Classification: \"State whether the company is highly or lowly geared\" 2. Combined Question: Calculate with Debt-Equity Ratio, Proprietary Ratio 3. Interpretation: \"Comment on the financial risk from capital structure\""]}, {"id": "amd-u2-c55-3", "type": "numberList", "items": ["Missing Figure: \"Capital Gearing is 0.8:1, Equity Shareholders'' Funds ₹10,00,000. Find Fixed-Interest Capital\""]}, {"id": "amd-u2-c55-4", "type": "numberList", "items": ["Trend Analysis: Calculate for multiple years to show changing leverage"]}, {"id": "amd-u2-c55-5", "text": "SECTION D: REVENUE STATEMENT RATIOS", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c55-6", "text": "Tier 1: Extremely High Priority (Strong PYQ Evidence)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c55-7", "type": "numberList", "items": ["GROSS PROFIT RATIO"]}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('82b20972-cb84-45c9-9535-27249a283f84', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What is the Gross Profit Ratio?', '', 'The Gross Profit Ratio measures the relationship between Gross Profit and Net Sales. It indicates the profitability from core trading/manufacturing activities before considering

operating expenses.

Purpose: Assess basic profitability and pricing efficiency.', NULL, NULL, NULL, 56, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'd70a0235-1576-4bc4-91ec-7ccc71a97791', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c56-q", "text": "What is the Gross Profit Ratio?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c56-1", "text": "The Gross Profit Ratio measures the relationship between Gross Profit and Net Sales. It indicates the profitability from core trading/manufacturing activities before considering", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c56-2", "text": "operating expenses.", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c56-3", "text": "Purpose: Assess basic profitability and pricing efficiency.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('6313ca20-1c5f-491b-95b1-8b63b85f7f3d', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What is the formula for Gross Profit Ratio?', '', 'Gross Profit Ratio = (Gross Profit ÷ Net Sales) × 100

Where:

Gross Profit = Net Sales − Cost of Goods Sold Net Sales = Total Sales − Sales Returns

Expressed as: Percentage (%)

Alternative Calculation:

If Gross Profit not given: Calculate as Net Sales − Cost of Goods Sold If Cost of Goods Sold not given: Calculate from Trading Account items', NULL, NULL, NULL, 57, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'd70a0235-1576-4bc4-91ec-7ccc71a97791', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c57-q", "text": "What is the formula for Gross Profit Ratio?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c57-1", "type": "formula", "expression": "Gross Profit Ratio = (Gross Profit ÷ Net Sales) × 100"}, {"id": "amd-u2-c57-2", "text": "Where:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c57-3", "type": "formula", "expression": "Gross Profit = Net Sales − Cost of Goods Sold Net Sales = Total Sales − Sales Returns"}, {"id": "amd-u2-c57-4", "text": "Expressed as: Percentage (%)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c57-5", "text": "Alternative Calculation:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c57-6", "text": "If Gross Profit not given: Calculate as Net Sales − Cost of Goods Sold If Cost of Goods Sold not given: Calculate from Trading Account items", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('716aa732-ed60-403c-8aad-cfa386bc4c1f', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What do Gross Profit and Net Sales represent?', '', 'Gross Profit:

Profit after deducting direct costs (Cost of Goods Sold) from Sales Cost of Goods Sold includes:

Opening Stock

Purchases (less Purchase Returns)

Direct Expenses (Carriage Inward, Wages, Factory Expenses) Less: Closing Stock

Excludes: Operating expenses, interest, tax

Net Sales:

Total Sales (Cash + Credit)

Less: Sales Returns

Excludes: Non-operating income (Interest Received, Dividend Received) Key Point: Gross Profit reflects pricing policy and direct cost control.', NULL, NULL, NULL, 58, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'd70a0235-1576-4bc4-91ec-7ccc71a97791', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c58-q", "text": "What do Gross Profit and Net Sales represent?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c58-1", "text": "Gross Profit:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c58-2", "text": "Profit after deducting direct costs (Cost of Goods Sold) from Sales Cost of Goods Sold includes:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c58-3", "text": "Opening Stock", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c58-4", "text": "Purchases (less Purchase Returns)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c58-5", "text": "Direct Expenses (Carriage Inward, Wages, Factory Expenses) Less: Closing Stock", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c58-6", "text": "Excludes: Operating expenses, interest, tax", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c58-7", "text": "Net Sales:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c58-8", "text": "Total Sales (Cash + Credit)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c58-9", "text": "Less: Sales Returns", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c58-10", "text": "Excludes: Non-operating income (Interest Received, Dividend Received) Key Point: Gross Profit reflects pricing policy and direct cost control.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('3b4ef701-c996-48f1-8e61-2fad7ee51351', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How is Gross Profit Ratio calculated?', '', 'Method 1 (Direct from Revenue Statement):

Identify Gross Profit directly from statement

Identify Net Sales

Apply Formula = (Gross Profit ÷ Net Sales) × 100

Method 2 (Calculate Gross Profit):

Calculate Cost of Goods Sold:

Opening Stock

+ Purchases (net)

+ Direct Expenses

- Closing Stock

= Cost of Goods Sold

Calculate Gross Profit = Net Sales − Cost of Goods Sold

Apply Formula

Example:

Net Sales: ₹5,00,000

Cost of Goods Sold: ₹3,50,000

Gross Profit: ₹1,50,000

Gross Profit Ratio = (1,50,000 ÷ 5,00,000) × 100 = 30%', NULL, NULL, NULL, 59, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'd70a0235-1576-4bc4-91ec-7ccc71a97791', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c59-q", "text": "How is Gross Profit Ratio calculated?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c59-1", "text": "Method 1 (Direct from Revenue Statement):", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c59-2", "type": "numberList", "items": ["Identify Gross Profit directly from statement"]}, {"id": "amd-u2-c59-3", "type": "numberList", "items": ["Identify Net Sales"]}, {"id": "amd-u2-c59-4", "type": "numberList", "items": ["Apply Formula = (Gross Profit ÷ Net Sales) × 100"]}, {"id": "amd-u2-c59-5", "text": "Method 2 (Calculate Gross Profit):", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c59-6", "type": "numberList", "items": ["Calculate Cost of Goods Sold:"]}, {"id": "amd-u2-c59-7", "text": "Opening Stock", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c59-8", "text": "+ Purchases (net)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c59-9", "text": "+ Direct Expenses", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c59-10", "text": "- Closing Stock", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c59-11", "type": "formula", "expression": "= Cost of Goods Sold"}, {"id": "amd-u2-c59-12", "type": "numberList", "items": ["Calculate Gross Profit = Net Sales − Cost of Goods Sold"]}, {"id": "amd-u2-c59-13", "type": "numberList", "items": ["Apply Formula"]}, {"id": "amd-u2-c59-14", "text": "Example:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c59-15", "text": "Net Sales: ₹5,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c59-16", "text": "Cost of Goods Sold: ₹3,50,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c59-17", "text": "Gross Profit: ₹1,50,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c59-18", "type": "formula", "expression": "Gross Profit Ratio = (1,50,000 ÷ 5,00,000) × 100 = 30%"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('41a0221e-d2c8-4f97-927e-79d8106ef647', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How should Gross Profit Ratio be interpreted?', '', 'High Ratio:

Positive: Strong pricing power, efficient direct cost control Positive: Competitive advantage, premium pricing

Negative: May indicate underpricing of direct costs (if abnormally high) Low Ratio:

Positive: Competitive pricing strategy (volume-based)

Negative: Weak pricing power, high direct costs

Negative: Price competition, margin pressure

Trend Analysis:

Increasing trend → Improving profitability or cost control Decreasing trend → Margin pressure, cost escalation, price cuts Industry Context:

Manufacturing: Typically 20-40%

Retail/Trading: Lower (10-25%)

Service: Very high or not applicable

2022 & 2025 PYQ: Gross Profit Ratio frequently tested.', NULL, NULL, NULL, 60, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'd70a0235-1576-4bc4-91ec-7ccc71a97791', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c60-q", "text": "How should Gross Profit Ratio be interpreted?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c60-1", "text": "High Ratio:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c60-2", "text": "Positive: Strong pricing power, efficient direct cost control Positive: Competitive advantage, premium pricing", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c60-3", "text": "Negative: May indicate underpricing of direct costs (if abnormally high) Low Ratio:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c60-4", "text": "Positive: Competitive pricing strategy (volume-based)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c60-5", "text": "Negative: Weak pricing power, high direct costs", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c60-6", "text": "Negative: Price competition, margin pressure", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c60-7", "text": "Trend Analysis:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c60-8", "text": "Increasing trend → Improving profitability or cost control Decreasing trend → Margin pressure, cost escalation, price cuts Industry Context:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c60-9", "text": "Manufacturing: Typically 20-40%", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c60-10", "text": "Retail/Trading: Lower (10-25%)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c60-11", "text": "Service: Very high or not applicable", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c60-12", "text": "2022 & 2025 PYQ: Gross Profit Ratio frequently tested.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('c503216f-dfa0-4a5d-a0b3-823a02865f31', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Discuss the factors affecting Bond Valuation (Determinants of the Value of Bonds).', 'Priority: Tier 1 | PYQ Connection: Oct 2024 Q4B ("factors"); syllabus "Determinants of the Value of Bonds" | PYQ Connection: Oct 2024 Q4B ("factors"); syllabus "Determinants of the Value of Bonds"', 'Factor | Effect on bond value
Market interest rate / required yield | Higher yield → lower value (inverse)
Coupon rate | Higher coupon → higher value
Face/redemption value | Higher redemption → higher value
Time to maturity | Longer maturity → greater price sensitivity to rate changes. A discount bond''s price rises towards par as maturity approaches
Credit rating / default risk | Lower rating → higher required yield → lower value
Call and put features | Call option (issuer''s right) lowers value. Put option (investor''s right) raises value
Liquidity | Less liquid bonds carry a liquidity premium, so a lower value
Inflation expectations | Higher inflation → higher yields → lower value
Tax treatment | Tax-free or lower-taxed interest raises the after-tax value
Frequency of coupon payments | More frequent coupons slightly raise the value
Central bank policy and economic conditions | Rate hikes lower bond prices', NULL, NULL, NULL, 25, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'ad766610-0fb2-46eb-8d3e-79013b3ff5c7', '{"blocks": [{"id": "equity-and-debt-markets-u4-c25-q", "text": "Discuss the factors affecting Bond Valuation (Determinants of the Value of Bonds).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c25-1", "rows": [["Factor", "Effect on bond value"], ["Market interest rate / required yield", "Higher yield → lower value (inverse)"], ["Coupon rate", "Higher coupon → higher value"], ["Face/redemption value", "Higher redemption → higher value"], ["Time to maturity", "Longer maturity → greater price sensitivity to rate changes. A discount bond''s price rises towards par as maturity approaches"], ["Credit rating / default risk", "Lower rating → higher required yield → lower value"], ["Call and put features", "Call option (issuer''s right) lowers value. Put option (investor''s right) raises value"], ["Liquidity", "Less liquid bonds carry a liquidity premium, so a lower value"], ["Inflation expectations", "Higher inflation → higher yields → lower value"], ["Tax treatment", "Tax-free or lower-taxed interest raises the after-tax value"], ["Frequency of coupon payments", "More frequent coupons slightly raise the value"], ["Central bank policy and economic conditions", "Rate hikes lower bond prices"]], "type": "table"}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('f5a4bbc5-950b-4151-8391-97a7525a6991', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'Calculate Gross Profit Ratio: From Revenue Statement: Sales: ₹10,00,000 Sales Returns: ₹50,000 Opening Stock: ₹1,00,000 Purchases: ₹6,00,000 Purchase Returns: ₹30,000 Carriage Inward: ₹20,000 Closing Stock: ₹1,50,000', '', 'Solution:

Step 1: Calculate Net Sales

Sales: ₹10,00,000

Less: Sales Returns: ₹50,000

Net Sales: ₹9,50,000

Step 2: Calculate Cost of Goods Sold

Opening Stock: ₹1,00,000

+ Purchases: ₹6,00,000

Less: Purchase Returns: ₹30,000

Net Purchases: ₹5,70,000

+ Carriage Inward: ₹20,000

= Cost of Goods Available: ₹6,90,000

Less: Closing Stock: ₹1,50,000

Cost of Goods Sold: ₹5,40,000

Step 3: Calculate Gross Profit

Gross Profit = Net Sales − Cost of Goods Sold

= ₹9,50,000 − ₹5,40,000 = ₹4,10,000

Step 4: Apply Formula

Interpretation: The Gross Profit Ratio of 43.16% indicates strong profitability from core operations. The company maintains healthy margins after direct costs.', NULL, NULL, NULL, 61, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'd70a0235-1576-4bc4-91ec-7ccc71a97791', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c61-q", "text": "Calculate Gross Profit Ratio: From Revenue Statement: Sales: ₹10,00,000 Sales Returns: ₹50,000 Opening Stock: ₹1,00,000 Purchases: ₹6,00,000 Purchase Returns: ₹30,000 Carriage Inward: ₹20,000 Closing Stock: ₹1,50,000", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c61-1", "text": "Solution:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c61-2", "text": "Step 1: Calculate Net Sales", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c61-3", "text": "Sales: ₹10,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c61-4", "text": "Less: Sales Returns: ₹50,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c61-5", "text": "Net Sales: ₹9,50,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c61-6", "text": "Step 2: Calculate Cost of Goods Sold", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c61-7", "text": "Opening Stock: ₹1,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c61-8", "text": "+ Purchases: ₹6,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c61-9", "text": "Less: Purchase Returns: ₹30,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c61-10", "text": "Net Purchases: ₹5,70,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c61-11", "text": "+ Carriage Inward: ₹20,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c61-12", "type": "formula", "expression": "= Cost of Goods Available: ₹6,90,000"}, {"id": "amd-u2-c61-13", "text": "Less: Closing Stock: ₹1,50,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c61-14", "text": "Cost of Goods Sold: ₹5,40,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c61-15", "text": "Step 3: Calculate Gross Profit", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c61-16", "type": "formula", "expression": "Gross Profit = Net Sales − Cost of Goods Sold"}, {"id": "amd-u2-c61-17", "type": "formula", "expression": "= ₹9,50,000 − ₹5,40,000 = ₹4,10,000"}, {"id": "amd-u2-c61-18", "text": "Step 4: Apply Formula", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c61-19", "text": "Interpretation: The Gross Profit Ratio of 43.16% indicates strong profitability from core operations. The company maintains healthy margins after direct costs.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('a2549d9a-c957-48eb-ad44-00d6c95b7173', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What errors occur in Gross Profit Ratio?', '', 'Common Errors:

Using Gross Sales — Not deducting Sales Returns from Sales

Wrong Cost of Goods Sold — Including operating expenses (Office, Selling expenses) 3. Missing Direct Expenses — Forgetting Carriage Inward, Wages

Including Non-Operating Income — Adding Interest Received, Dividend to Gross Profit 5. Wrong Stock Treatment — Not adjusting Opening/Closing Stock correctly Critical Check: Gross Profit = Net Sales − Cost of Goods Sold (only direct costs).', NULL, NULL, NULL, 62, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'd70a0235-1576-4bc4-91ec-7ccc71a97791', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c62-q", "text": "What errors occur in Gross Profit Ratio?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c62-1", "text": "Common Errors:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c62-2", "type": "numberList", "items": ["Using Gross Sales — Not deducting Sales Returns from Sales"]}, {"id": "amd-u2-c62-3", "type": "numberList", "items": ["Wrong Cost of Goods Sold — Including operating expenses (Office, Selling expenses) 3. Missing Direct Expenses — Forgetting Carriage Inward, Wages"]}, {"id": "amd-u2-c62-4", "type": "numberList", "items": ["Including Non-Operating Income — Adding Interest Received, Dividend to Gross Profit 5. Wrong Stock Treatment — Not adjusting Opening/Closing Stock correctly Critical Check: Gross Profit = Net Sales − Cost of Goods Sold (only direct costs)."]}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('3958490e-bf37-42f6-8c1d-0bc85c42ad58', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How might Gross Profit Ratio be tested?', '', 'Variations:

Missing Figure: "Gross Profit Ratio is 25%, Net Sales ₹8,00,000. Find Gross Profit" 2. Combined Question: Calculate with Operating Ratio, Net Profit Ratio

Gross Profit Rate Given: "Gross Profit Rate is 25% on Sales" — use to find Gross Profit 4. Trading Account Format: Prepare Trading Account first, then calculate ratio 5. Trend Analysis: Calculate for 2-3 years from Comparative Revenue Statement

EXPENSES RATIO', NULL, NULL, NULL, 63, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'd70a0235-1576-4bc4-91ec-7ccc71a97791', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c63-q", "text": "How might Gross Profit Ratio be tested?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c63-1", "text": "Variations:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c63-2", "type": "numberList", "items": ["Missing Figure: \"Gross Profit Ratio is 25%, Net Sales ₹8,00,000. Find Gross Profit\" 2. Combined Question: Calculate with Operating Ratio, Net Profit Ratio"]}, {"id": "amd-u2-c63-3", "type": "numberList", "items": ["Gross Profit Rate Given: \"Gross Profit Rate is 25% on Sales\" — use to find Gross Profit 4. Trading Account Format: Prepare Trading Account first, then calculate ratio 5. Trend Analysis: Calculate for 2-3 years from Comparative Revenue Statement"]}, {"id": "amd-u2-c63-4", "type": "numberList", "items": ["EXPENSES RATIO"]}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('4a10d392-10d9-4f58-90c1-e83ce3ce0066', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What is the Expenses Ratio?', '', 'The Expenses Ratio (also called Operating Expenses Ratio or Individual Expense Ratio) measures the relationship between specific operating expenses and Net Sales. It indicates what

percentage of sales is consumed by each expense category.

Purpose: Analyse cost structure and identify areas for expense control.', NULL, NULL, NULL, 64, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'a8091604-7676-4990-bf92-70e431b264f0', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c64-q", "text": "What is the Expenses Ratio?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c64-1", "text": "The Expenses Ratio (also called Operating Expenses Ratio or Individual Expense Ratio) measures the relationship between specific operating expenses and Net Sales. It indicates what", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c64-2", "text": "percentage of sales is consumed by each expense category.", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c64-3", "text": "Purpose: Analyse cost structure and identify areas for expense control.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('368c1cbe-7bc6-4089-a125-fc75982f6c66', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'Calculate Office & Administration Expense Ratio and Selling & Distribution Expense Ratio: From Revenue Statement: Sales: ₹8,00,000 Sales Returns: ₹20,000 Office Salaries: ₹60,000 Office Rent: ₹30,000 Printing & Stationery: ₹10,000 Salesman Salary: ₹80,000 Advertising: ₹50,000 Commission: ₹20,000', '', 'Solution:

Step 1: Calculate Net Sales

Sales: ₹8,00,000

Less: Sales Returns: ₹20,000

Net Sales: ₹7,80,000

Step 2: Calculate Office & Administration Expenses

Office Salaries: ₹60,000

Office Rent: ₹30,000

Printing & Stationery: ₹10,000

Total Office Expenses: ₹1,00,000

Step 3: Calculate Selling & Distribution Expenses

Salesman Salary: ₹80,000

Advertising: ₹50,000

Commission: ₹20,000

Total Selling Expenses: ₹1,50,000

Step 4: Apply Formulas

Interpretation: Office expenses consume 12.82% of sales, while selling expenses consume 19.23%. Management should review selling expense efficiency (19.23% is relatively high).', NULL, NULL, NULL, 69, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'a8091604-7676-4990-bf92-70e431b264f0', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c69-q", "text": "Calculate Office & Administration Expense Ratio and Selling & Distribution Expense Ratio: From Revenue Statement: Sales: ₹8,00,000 Sales Returns: ₹20,000 Office Salaries: ₹60,000 Office Rent: ₹30,000 Printing & Stationery: ₹10,000 Salesman Salary: ₹80,000 Advertising: ₹50,000 Commission: ₹20,000", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c69-1", "text": "Solution:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c69-2", "text": "Step 1: Calculate Net Sales", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c69-3", "text": "Sales: ₹8,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c69-4", "text": "Less: Sales Returns: ₹20,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c69-5", "text": "Net Sales: ₹7,80,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c69-6", "text": "Step 2: Calculate Office & Administration Expenses", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c69-7", "text": "Office Salaries: ₹60,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c69-8", "text": "Office Rent: ₹30,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c69-9", "text": "Printing & Stationery: ₹10,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c69-10", "text": "Total Office Expenses: ₹1,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c69-11", "text": "Step 3: Calculate Selling & Distribution Expenses", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c69-12", "text": "Salesman Salary: ₹80,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c69-13", "text": "Advertising: ₹50,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c69-14", "text": "Commission: ₹20,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c69-15", "text": "Total Selling Expenses: ₹1,50,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c69-16", "text": "Step 4: Apply Formulas", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c69-17", "text": "Interpretation: Office expenses consume 12.82% of sales, while selling expenses consume 19.23%. Management should review selling expense efficiency (19.23% is relatively high).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('c84bc135-341a-43d0-8ec7-fa45427c5078', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What is the formula for Expenses Ratio?', '', 'Expense Ratio = (Specific Operating Expense ÷ Net Sales) × 100

Common Individual Expense Ratios:

Office & Administration Expense Ratio = (Office & Admin Expenses ÷ Net Sales) × 100 Selling & Distribution Expense Ratio = (Selling & Distribution Expenses ÷ Net Sales) × 100 Total Operating Expenses Ratio = (Total Operating Expenses ÷ Net Sales) × 100 Expressed as: Percentage (%)

Note: Sum of all individual expense ratios = Operating Ratio (approximately)', NULL, NULL, NULL, 65, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'a8091604-7676-4990-bf92-70e431b264f0', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c65-q", "text": "What is the formula for Expenses Ratio?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c65-1", "type": "formula", "expression": "Expense Ratio = (Specific Operating Expense ÷ Net Sales) × 100"}, {"id": "amd-u2-c65-2", "text": "Common Individual Expense Ratios:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c65-3", "type": "formula", "expression": "Office & Administration Expense Ratio = (Office & Admin Expenses ÷ Net Sales) × 100 Selling & Distribution Expense Ratio = (Selling & Distribution Expenses ÷ Net Sales) × 100 Total Operating Expenses Ratio = (Total Operating Expenses ÷ Net Sales) × 100 Expressed as: Percentage (%)"}, {"id": "amd-u2-c65-4", "type": "formula", "expression": "Note: Sum of all individual expense ratios = Operating Ratio (approximately)"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('78b43dc8-2b4c-4f0e-af29-ee3c2931472c', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What expenses are included in Expenses Ratio calculation?', '', 'Operating Expenses (included):

Office & Administration: Salaries, Office Rent, Printing, Stationery, Audit Fees Selling & Distribution: Salesman Salary, Advertising, Commission, Delivery Charges Factory/Production: Factory Rent, Power, Indirect Labour (if not in Cost of Goods Sold) Excluded:

Cost of Goods Sold (separate from operating expenses)

Non-Operating Expenses: Interest on Borrowings, Loss on Sale of Fixed Assets Non-Operating Income: Interest Received, Dividend Received

Financial Expenses: Interest (for Operating Ratio, but may appear in Net Profit Ratio context)

Key Distinction:

Expenses Ratio → Individual expense categories

Operating Ratio → Sum of Cost of Goods Sold + Operating Expenses', NULL, NULL, NULL, 66, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'a8091604-7676-4990-bf92-70e431b264f0', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c66-q", "text": "What expenses are included in Expenses Ratio calculation?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c66-1", "text": "Operating Expenses (included):", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c66-2", "text": "Office & Administration: Salaries, Office Rent, Printing, Stationery, Audit Fees Selling & Distribution: Salesman Salary, Advertising, Commission, Delivery Charges Factory/Production: Factory Rent, Power, Indirect Labour (if not in Cost of Goods Sold) Excluded:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c66-3", "text": "Cost of Goods Sold (separate from operating expenses)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c66-4", "text": "Non-Operating Expenses: Interest on Borrowings, Loss on Sale of Fixed Assets Non-Operating Income: Interest Received, Dividend Received", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c66-5", "text": "Financial Expenses: Interest (for Operating Ratio, but may appear in Net Profit Ratio context)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c66-6", "text": "Key Distinction:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c66-7", "text": "Expenses Ratio → Individual expense categories", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c66-8", "text": "Operating Ratio → Sum of Cost of Goods Sold + Operating Expenses", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('9766e8be-de7b-4c78-b850-a667ef709b60', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How is Expenses Ratio calculated?', '', 'Steps:

Identify Net Sales (Sales − Sales Returns)

Identify Specific Operating Expense (e.g., Office Expenses, Selling Expenses) 3. Apply Formula = (Expense ÷ Net Sales) × 100

Example:

Net Sales: ₹10,00,000

Office & Administration Expenses: ₹80,000

Selling & Distribution Expenses: ₹1,20,000

Office Expense Ratio = (80,000 ÷ 10,00,000) × 100 = 8%

Selling Expense Ratio = (1,20,000 ÷ 10,00,000) × 100 = 12% Total Operating Expense Ratio = 8% + 12% = 20%', NULL, NULL, NULL, 67, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'a8091604-7676-4990-bf92-70e431b264f0', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c67-q", "text": "How is Expenses Ratio calculated?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c67-1", "text": "Steps:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c67-2", "type": "numberList", "items": ["Identify Net Sales (Sales − Sales Returns)"]}, {"id": "amd-u2-c67-3", "type": "numberList", "items": ["Identify Specific Operating Expense (e.g., Office Expenses, Selling Expenses) 3. Apply Formula = (Expense ÷ Net Sales) × 100"]}, {"id": "amd-u2-c67-4", "text": "Example:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c67-5", "text": "Net Sales: ₹10,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c67-6", "text": "Office & Administration Expenses: ₹80,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c67-7", "text": "Selling & Distribution Expenses: ₹1,20,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c67-8", "type": "formula", "expression": "Office Expense Ratio = (80,000 ÷ 10,00,000) × 100 = 8%"}, {"id": "amd-u2-c67-9", "type": "formula", "expression": "Selling Expense Ratio = (1,20,000 ÷ 10,00,000) × 100 = 12% Total Operating Expense Ratio = 8% + 12% = 20%"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('69127c45-115a-421f-a39f-8cc0b944e955', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How should Expenses Ratio be interpreted?', '', 'High Ratio:

Negative: Inefficient cost control, excessive spending

Negative: Lower operating profit margin

Action: Investigate expense categories, implement cost reduction Low Ratio:

Positive: Efficient cost management

Positive: Higher operating profit margin

Caution: May indicate underinvestment in critical areas (e.g., advertising, R&D) Trend Analysis:

Decreasing trend → Improving cost efficiency

Increasing trend → Cost escalation, inefficiency

Benchmarking:

Compare with industry averages

Compare across time periods

Individual expense ratios help pinpoint problem areas

2022 & 2025 PYQ: Expenses Ratio (including Selling Expense Ratio) tested.', NULL, NULL, NULL, 68, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'a8091604-7676-4990-bf92-70e431b264f0', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c68-q", "text": "How should Expenses Ratio be interpreted?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c68-1", "text": "High Ratio:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c68-2", "text": "Negative: Inefficient cost control, excessive spending", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c68-3", "text": "Negative: Lower operating profit margin", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c68-4", "text": "Action: Investigate expense categories, implement cost reduction Low Ratio:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c68-5", "text": "Positive: Efficient cost management", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c68-6", "text": "Positive: Higher operating profit margin", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c68-7", "text": "Caution: May indicate underinvestment in critical areas (e.g., advertising, R&D) Trend Analysis:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c68-8", "text": "Decreasing trend → Improving cost efficiency", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c68-9", "text": "Increasing trend → Cost escalation, inefficiency", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c68-10", "text": "Benchmarking:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c68-11", "text": "Compare with industry averages", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c68-12", "text": "Compare across time periods", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c68-13", "text": "Individual expense ratios help pinpoint problem areas", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c68-14", "text": "2022 & 2025 PYQ: Expenses Ratio (including Selling Expense Ratio) tested.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('66ce0c3f-2ce0-41ce-a26a-e604b203131c', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What errors occur in Expenses Ratio?', '', 'Common Errors:

Using Gross Sales — Not deducting Sales Returns

Including Non-Operating Expenses — Adding Interest, Loss on Sale of Assets 3. Including Cost of Goods Sold — Mixing direct costs with operating expenses 4. Missing Expense Categories — Forgetting some operating expenses

Confusing with Operating Ratio — Expenses Ratio is for individual categories; Operating Ratio is aggregate

Critical Distinction:

Expenses Ratio → Individual expense (e.g., Office, Selling)

Operating Ratio → Cost of Goods Sold + All Operating Expenses', NULL, NULL, NULL, 70, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'a8091604-7676-4990-bf92-70e431b264f0', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c70-q", "text": "What errors occur in Expenses Ratio?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c70-1", "text": "Common Errors:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c70-2", "type": "numberList", "items": ["Using Gross Sales — Not deducting Sales Returns"]}, {"id": "amd-u2-c70-3", "type": "numberList", "items": ["Including Non-Operating Expenses — Adding Interest, Loss on Sale of Assets 3. Including Cost of Goods Sold — Mixing direct costs with operating expenses 4. Missing Expense Categories — Forgetting some operating expenses"]}, {"id": "amd-u2-c70-4", "type": "numberList", "items": ["Confusing with Operating Ratio — Expenses Ratio is for individual categories; Operating Ratio is aggregate"]}, {"id": "amd-u2-c70-5", "text": "Critical Distinction:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c70-6", "text": "Expenses Ratio → Individual expense (e.g., Office, Selling)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c70-7", "text": "Operating Ratio → Cost of Goods Sold + All Operating Expenses", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('96b42726-c67c-46b2-aff4-223d7cf2a494', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How might Expenses Ratio be tested?', '', 'Variations:

Multiple Expense Ratios: Calculate Office, Selling, Administrative ratios separately 2. Total Operating Expenses: Sum all individual expense ratios

Combined Question: Calculate with Operating Ratio, Net Profit Ratio 4. Trend Analysis: Compare expense ratios across 2-3 years

Missing Figure: "Selling Expense Ratio is 15%, Net Sales ₹6,00,000. Find Selling Expenses" 3. OPERATING RATIO', NULL, NULL, NULL, 71, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'a8091604-7676-4990-bf92-70e431b264f0', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c71-q", "text": "How might Expenses Ratio be tested?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c71-1", "text": "Variations:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c71-2", "type": "numberList", "items": ["Multiple Expense Ratios: Calculate Office, Selling, Administrative ratios separately 2. Total Operating Expenses: Sum all individual expense ratios"]}, {"id": "amd-u2-c71-3", "type": "numberList", "items": ["Combined Question: Calculate with Operating Ratio, Net Profit Ratio 4. Trend Analysis: Compare expense ratios across 2-3 years"]}, {"id": "amd-u2-c71-4", "type": "numberList", "items": ["Missing Figure: \"Selling Expense Ratio is 15%, Net Sales ₹6,00,000. Find Selling Expenses\" 3. OPERATING RATIO"]}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('6b2b1d4f-8487-4fe2-b9b0-9941bcde48a7', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What is the Operating Ratio?', '', 'The Operating Ratio measures the relationship between total operating costs (Cost of Goods Sold + Operating Expenses) and Net Sales. It indicates the efficiency of core business operations

before considering non-operating items.

Purpose: Assess overall operational efficiency and cost management.', NULL, NULL, NULL, 72, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'ca7b9b9a-e600-47ce-afd1-e9f2d9cc8642', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c72-q", "text": "What is the Operating Ratio?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c72-1", "text": "The Operating Ratio measures the relationship between total operating costs (Cost of Goods Sold + Operating Expenses) and Net Sales. It indicates the efficiency of core business operations", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c72-2", "text": "before considering non-operating items.", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c72-3", "text": "Purpose: Assess overall operational efficiency and cost management.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('105e0c77-1573-4ffd-8ff5-260cefb8b316', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What is the formula for Operating Ratio?', '', 'Operating Ratio = (Operating Cost ÷ Net Sales) × 100

Alternative Formula:

Where:

Operating Cost = Cost of Goods Sold + Office & Admin Expenses + Selling & Distribution Expenses

Relationship:

Expressed as: Percentage (%)

Ideal: Lower ratio indicates better efficiency (typically 70-85% is good)', NULL, NULL, NULL, 73, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'ca7b9b9a-e600-47ce-afd1-e9f2d9cc8642', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c73-q", "text": "What is the formula for Operating Ratio?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c73-1", "type": "formula", "expression": "Operating Ratio = (Operating Cost ÷ Net Sales) × 100"}, {"id": "amd-u2-c73-2", "text": "Alternative Formula:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c73-3", "text": "Where:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c73-4", "type": "formula", "expression": "Operating Cost = Cost of Goods Sold + Office & Admin Expenses + Selling & Distribution Expenses"}, {"id": "amd-u2-c73-5", "text": "Relationship:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c73-6", "text": "Expressed as: Percentage (%)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c73-7", "text": "Ideal: Lower ratio indicates better efficiency (typically 70-85% is good)", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('d7b1b785-f4bd-4bec-b98d-9102bf173f00', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What comprises Operating Cost?', '', 'Operating Cost Includes:

Cost of Goods Sold:

Opening Stock + Net Purchases + Direct Expenses − Closing Stock 2. Operating Expenses:

Office & Administration: Salaries, Rent, Printing, Audit Fees

Selling & Distribution: Advertising, Commission, Delivery, Salesman Salary Factory/Production: Factory overheads (if not in COGS)

Excludes:

Non-Operating Expenses: Interest on Borrowings, Loss on Sale of Fixed Assets Non-Operating Income: Interest Received, Dividend Received

Financial Items: Interest, Tax (these appear after Operating Profit) Key Distinction:

Operating Ratio → Only operating items

Net Profit Ratio → Includes non-operating items (interest, tax, extraordinary items)', NULL, NULL, NULL, 74, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'ca7b9b9a-e600-47ce-afd1-e9f2d9cc8642', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c74-q", "text": "What comprises Operating Cost?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c74-1", "text": "Operating Cost Includes:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c74-2", "type": "numberList", "items": ["Cost of Goods Sold:"]}, {"id": "amd-u2-c74-3", "text": "Opening Stock + Net Purchases + Direct Expenses − Closing Stock 2. Operating Expenses:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c74-4", "text": "Office & Administration: Salaries, Rent, Printing, Audit Fees", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c74-5", "text": "Selling & Distribution: Advertising, Commission, Delivery, Salesman Salary Factory/Production: Factory overheads (if not in COGS)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c74-6", "text": "Excludes:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c74-7", "text": "Non-Operating Expenses: Interest on Borrowings, Loss on Sale of Fixed Assets Non-Operating Income: Interest Received, Dividend Received", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c74-8", "text": "Financial Items: Interest, Tax (these appear after Operating Profit) Key Distinction:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c74-9", "text": "Operating Ratio → Only operating items", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c74-10", "text": "Net Profit Ratio → Includes non-operating items (interest, tax, extraordinary items)", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('151eda00-6880-4f11-bc1b-529587e3678a', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How is Operating Ratio calculated?', '', 'Steps:

Calculate Cost of Goods Sold (from Trading Account)

Identify Operating Expenses (Office + Selling + Distribution)

Calculate Operating Cost = COGS + Operating Expenses

Identify Net Sales (Sales − Sales Returns)

Apply Formula = (Operating Cost ÷ Net Sales) × 100

Example:

Net Sales: ₹10,00,000

Cost of Goods Sold: ₹6,00,000

Office Expenses: ₹1,00,000

Selling Expenses: ₹1,50,000

Operating Cost: ₹8,50,000

Operating Ratio = (8,50,000 ÷ 10,00,000) × 100 = 85%

Operating Profit Ratio = 100 - 85 = 15%', NULL, NULL, NULL, 75, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'ca7b9b9a-e600-47ce-afd1-e9f2d9cc8642', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c75-q", "text": "How is Operating Ratio calculated?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c75-1", "text": "Steps:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c75-2", "type": "numberList", "items": ["Calculate Cost of Goods Sold (from Trading Account)"]}, {"id": "amd-u2-c75-3", "type": "numberList", "items": ["Identify Operating Expenses (Office + Selling + Distribution)"]}, {"id": "amd-u2-c75-4", "type": "numberList", "items": ["Calculate Operating Cost = COGS + Operating Expenses"]}, {"id": "amd-u2-c75-5", "type": "numberList", "items": ["Identify Net Sales (Sales − Sales Returns)"]}, {"id": "amd-u2-c75-6", "type": "numberList", "items": ["Apply Formula = (Operating Cost ÷ Net Sales) × 100"]}, {"id": "amd-u2-c75-7", "text": "Example:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c75-8", "text": "Net Sales: ₹10,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c75-9", "text": "Cost of Goods Sold: ₹6,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c75-10", "text": "Office Expenses: ₹1,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c75-11", "text": "Selling Expenses: ₹1,50,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c75-12", "text": "Operating Cost: ₹8,50,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c75-13", "type": "formula", "expression": "Operating Ratio = (8,50,000 ÷ 10,00,000) × 100 = 85%"}, {"id": "amd-u2-c75-14", "type": "formula", "expression": "Operating Profit Ratio = 100 - 85 = 15%"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('72623e74-cd54-4239-bee5-9af15170d142', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How should Operating Ratio be interpreted?', '', 'High Ratio (\>85-90%):

Negative: Low operational efficiency, high operating costs

Negative: Thin operating profit margin

Action: Cost reduction, process improvement

Low Ratio (\<70-75%):

Positive: High operational efficiency, good cost control Positive: Strong operating profit margin

Positive: Competitive advantage

Relationship with Operating Profit Ratio:

Operating Ratio + Operating Profit Ratio = 100% If Operating Ratio = 80%, Operating Profit Ratio = 20% Trend Analysis:

Decreasing trend → Improving efficiency

Increasing trend → Rising costs, inefficiency 2022 & 2025 PYQ: Operating Ratio frequently tested.', NULL, NULL, NULL, 76, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'ca7b9b9a-e600-47ce-afd1-e9f2d9cc8642', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c76-q", "text": "How should Operating Ratio be interpreted?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c76-1", "text": "High Ratio (\\>85-90%):", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c76-2", "text": "Negative: Low operational efficiency, high operating costs", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c76-3", "text": "Negative: Thin operating profit margin", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c76-4", "text": "Action: Cost reduction, process improvement", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c76-5", "text": "Low Ratio (\\<70-75%):", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c76-6", "text": "Positive: High operational efficiency, good cost control Positive: Strong operating profit margin", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c76-7", "text": "Positive: Competitive advantage", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c76-8", "text": "Relationship with Operating Profit Ratio:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c76-9", "type": "formula", "expression": "Operating Ratio + Operating Profit Ratio = 100% If Operating Ratio = 80%, Operating Profit Ratio = 20% Trend Analysis:"}, {"id": "amd-u2-c76-10", "text": "Decreasing trend → Improving efficiency", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c76-11", "text": "Increasing trend → Rising costs, inefficiency 2022 & 2025 PYQ: Operating Ratio frequently tested.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('a5c04118-7940-4deb-aad8-8639843d3f20', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'Calculate Operating Ratio: From Revenue Statement: Sales: ₹12,00,000 Sales Returns: ₹40,000 Cost of Goods Sold: ₹7,20,000 Office Salaries: ₹80,000 Office Rent: ₹40,000 Advertising: ₹1,00,000 Sales Commission: ₹60,000 Interest on Borrowings: ₹50,000 (exclude)', '', 'Solution:

Step 1: Calculate Net Sales

Sales: ₹12,00,000

Less: Sales Returns: ₹40,000

Net Sales: ₹11,60,000

Step 2: Calculate Operating Expenses

Office Salaries: ₹80,000

Office Rent: ₹40,000

Advertising: ₹1,00,000

Sales Commission: ₹60,000

Total Operating Expenses: ₹2,80,000

(Exclude Interest - non-operating)

Step 3: Calculate Operating Cost

Cost of Goods Sold: ₹7,20,000

+ Operating Expenses: ₹2,80,000

Operating Cost: ₹10,00,000

Step 4: Apply Formula

Interpretation: Operating Ratio of 86.21% indicates moderate efficiency. Operating Profit Ratio = 100 - 86.21 = 13.79%. Management should focus on reducing operating costs to improve margin.', NULL, NULL, NULL, 77, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'ca7b9b9a-e600-47ce-afd1-e9f2d9cc8642', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c77-q", "text": "Calculate Operating Ratio: From Revenue Statement: Sales: ₹12,00,000 Sales Returns: ₹40,000 Cost of Goods Sold: ₹7,20,000 Office Salaries: ₹80,000 Office Rent: ₹40,000 Advertising: ₹1,00,000 Sales Commission: ₹60,000 Interest on Borrowings: ₹50,000 (exclude)", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c77-1", "text": "Solution:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c77-2", "text": "Step 1: Calculate Net Sales", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c77-3", "text": "Sales: ₹12,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c77-4", "text": "Less: Sales Returns: ₹40,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c77-5", "text": "Net Sales: ₹11,60,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c77-6", "text": "Step 2: Calculate Operating Expenses", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c77-7", "text": "Office Salaries: ₹80,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c77-8", "text": "Office Rent: ₹40,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c77-9", "text": "Advertising: ₹1,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c77-10", "text": "Sales Commission: ₹60,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c77-11", "text": "Total Operating Expenses: ₹2,80,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c77-12", "text": "(Exclude Interest - non-operating)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c77-13", "text": "Step 3: Calculate Operating Cost", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c77-14", "text": "Cost of Goods Sold: ₹7,20,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c77-15", "text": "+ Operating Expenses: ₹2,80,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c77-16", "text": "Operating Cost: ₹10,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c77-17", "text": "Step 4: Apply Formula", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c77-18", "type": "formula", "expression": "Interpretation: Operating Ratio of 86.21% indicates moderate efficiency. Operating Profit Ratio = 100 - 86.21 = 13.79%. Management should focus on reducing operating costs to improve margin."}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('8f9e79fa-23d3-4573-95aa-15b6a9b95954', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What errors occur in Operating Ratio?', '', 'Common Errors:

Including Non-Operating Expenses — Adding Interest, Loss on Sale of Assets 2. Missing Operating Expenses — Forgetting Office or Selling expenses

Using Gross Sales — Not deducting Sales Returns

Confusing with Net Profit Ratio — Operating Ratio excludes interest, tax 5. Wrong Cost of Goods Sold — Including operating expenses in COGS

Critical Distinction:

Operating Ratio → Operating items only (excludes interest, tax)

Net Profit Ratio → All items including non-operating', NULL, NULL, NULL, 78, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'ca7b9b9a-e600-47ce-afd1-e9f2d9cc8642', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c78-q", "text": "What errors occur in Operating Ratio?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c78-1", "text": "Common Errors:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c78-2", "type": "numberList", "items": ["Including Non-Operating Expenses — Adding Interest, Loss on Sale of Assets 2. Missing Operating Expenses — Forgetting Office or Selling expenses"]}, {"id": "amd-u2-c78-3", "type": "numberList", "items": ["Using Gross Sales — Not deducting Sales Returns"]}, {"id": "amd-u2-c78-4", "type": "numberList", "items": ["Confusing with Net Profit Ratio — Operating Ratio excludes interest, tax 5. Wrong Cost of Goods Sold — Including operating expenses in COGS"]}, {"id": "amd-u2-c78-5", "text": "Critical Distinction:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c78-6", "text": "Operating Ratio → Operating items only (excludes interest, tax)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c78-7", "text": "Net Profit Ratio → All items including non-operating", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('2ca1b4de-b023-4c5a-98f8-ffb1cb554e9e', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What is the Stock Turnover Ratio?', '', 'The Stock Turnover Ratio (also called Inventory Turnover Ratio) measures how many times stock is sold and replaced during a period. It indicates the efficiency of inventory management

and stock movement speed.

Purpose: Assess inventory efficiency and identify overstocking/understocking.', NULL, NULL, NULL, 96, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '888cf58a-fc5d-4a1e-8971-0b8c372b23fb', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c96-q", "text": "What is the Stock Turnover Ratio?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c96-1", "text": "The Stock Turnover Ratio (also called Inventory Turnover Ratio) measures how many times stock is sold and replaced during a period. It indicates the efficiency of inventory management", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c96-2", "text": "and stock movement speed.", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c96-3", "text": "Purpose: Assess inventory efficiency and identify overstocking/understocking.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('7cb05e35-9be1-462e-828f-fe4db0a6267a', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How might Operating Ratio be tested?', '', 'Variations:

Calculate Operating Profit Ratio: "Operating Ratio is 82%. Find Operating Profit Ratio" (Answer: 18%)
Combined Question: Calculate with Gross Profit Ratio, Net Profit Ratio 3. Missing Figure: "Operating Ratio is 75%, Net Sales ₹8,00,000. Find Operating Cost" 4. Revenue Statement Format: Prepare Revenue Statement first, then calculate ratio 5. Trend Analysis: Calculate for multiple years from Comparative Statement

NET PROFIT RATIO', NULL, NULL, NULL, 79, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'ca7b9b9a-e600-47ce-afd1-e9f2d9cc8642', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c79-q", "text": "How might Operating Ratio be tested?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c79-1", "text": "Variations:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c79-2", "type": "numberList", "items": ["Calculate Operating Profit Ratio: \"Operating Ratio is 82%. Find Operating Profit Ratio\" (Answer: 18%)", "Combined Question: Calculate with Gross Profit Ratio, Net Profit Ratio 3. Missing Figure: \"Operating Ratio is 75%, Net Sales ₹8,00,000. Find Operating Cost\" 4. Revenue Statement Format: Prepare Revenue Statement first, then calculate ratio 5. Trend Analysis: Calculate for multiple years from Comparative Statement"]}, {"id": "amd-u2-c79-3", "type": "numberList", "items": ["NET PROFIT RATIO"]}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('5cd33ab8-215a-40ac-a248-5d9f4327cd1d', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What is the Net Profit Ratio?', '', 'The Net Profit Ratio measures the relationship between Net Profit (after all expenses including interest and tax) and Net Sales. It indicates the overall profitability and efficiency of

the entire business.

Purpose: Assess final profitability after all costs and obligations.', NULL, NULL, NULL, 80, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'd55ea009-6d60-467e-8a3f-ecbc60a1752e', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c80-q", "text": "What is the Net Profit Ratio?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c80-1", "text": "The Net Profit Ratio measures the relationship between Net Profit (after all expenses including interest and tax) and Net Sales. It indicates the overall profitability and efficiency of", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c80-2", "text": "the entire business.", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c80-3", "text": "Purpose: Assess final profitability after all costs and obligations.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('ae0e690b-5b7a-456d-88ec-52751faa6703', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What is the formula for Net Profit Ratio?', '', 'Net Profit Ratio = (Net Profit After Tax ÷ Net Sales) × 100

Alternative (Net Profit Before Tax):

Where:

Net Profit After Tax = Operating Profit − Interest − Tax + Non-Operating Income Net Sales = Total Sales − Sales Returns

Expressed as: Percentage (%)

Note: 2025 PYQ specifically asks for "Net Profit Before Tax Ratio" — use appropriate numerator.', NULL, NULL, NULL, 81, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'd55ea009-6d60-467e-8a3f-ecbc60a1752e', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c81-q", "text": "What is the formula for Net Profit Ratio?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c81-1", "type": "formula", "expression": "Net Profit Ratio = (Net Profit After Tax ÷ Net Sales) × 100"}, {"id": "amd-u2-c81-2", "text": "Alternative (Net Profit Before Tax):", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c81-3", "text": "Where:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c81-4", "type": "formula", "expression": "Net Profit After Tax = Operating Profit − Interest − Tax + Non-Operating Income Net Sales = Total Sales − Sales Returns"}, {"id": "amd-u2-c81-5", "text": "Expressed as: Percentage (%)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c81-6", "text": "Note: 2025 PYQ specifically asks for \"Net Profit Before Tax Ratio\" — use appropriate numerator.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('c9e4a453-54ed-49f6-967c-7af78e1083b1', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What comprises Net Profit?', '', 'Net Profit After Tax Calculation:

Gross Profit

Less: Operating Expenses (Office, Selling, Admin)

= Operating Profit

Less: Non-Operating Expenses (Interest on Borrowings, Loss on Sale of Assets) Add: Non-Operating Income (Interest Received, Dividend Received) = Net Profit Before Tax

Less: Income Tax

= Net Profit After Tax

Net Sales:

Cash Sales + Credit Sales

Less: Sales Returns

Key Distinction:

Net Profit Ratio → Includes ALL items (operating + non-operating, interest, tax) Operating Ratio → Only operating items

Net Operating Profit Ratio → Operating Profit only (excludes non-operating)', NULL, NULL, NULL, 82, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'd55ea009-6d60-467e-8a3f-ecbc60a1752e', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c82-q", "text": "What comprises Net Profit?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c82-1", "text": "Net Profit After Tax Calculation:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c82-2", "text": "Gross Profit", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c82-3", "text": "Less: Operating Expenses (Office, Selling, Admin)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c82-4", "type": "formula", "expression": "= Operating Profit"}, {"id": "amd-u2-c82-5", "type": "formula", "expression": "Less: Non-Operating Expenses (Interest on Borrowings, Loss on Sale of Assets) Add: Non-Operating Income (Interest Received, Dividend Received) = Net Profit Before Tax"}, {"id": "amd-u2-c82-6", "text": "Less: Income Tax", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c82-7", "type": "formula", "expression": "= Net Profit After Tax"}, {"id": "amd-u2-c82-8", "text": "Net Sales:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c82-9", "text": "Cash Sales + Credit Sales", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c82-10", "text": "Less: Sales Returns", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c82-11", "text": "Key Distinction:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c82-12", "text": "Net Profit Ratio → Includes ALL items (operating + non-operating, interest, tax) Operating Ratio → Only operating items", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c82-13", "text": "Net Operating Profit Ratio → Operating Profit only (excludes non-operating)", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('1d630d74-5be0-425b-a566-6947261a9e39', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How is Net Profit Ratio calculated?', '', 'Steps:

Calculate Net Sales (Sales − Sales Returns)

Identify Net Profit After Tax (or Before Tax, as required)

Apply Formula = (Net Profit ÷ Net Sales) × 100

Example:

Net Sales: ₹10,00,000

Operating Profit: ₹2,00,000

Interest Paid: ₹50,000

Interest Received: ₹10,000

Net Profit Before Tax: ₹1,60,000

Tax: ₹60,000

Net Profit After Tax: ₹1,00,000

Net Profit Ratio = (1,00,000 ÷ 10,00,000) × 100 = 10%', NULL, NULL, NULL, 83, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'd55ea009-6d60-467e-8a3f-ecbc60a1752e', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c83-q", "text": "How is Net Profit Ratio calculated?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c83-1", "text": "Steps:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c83-2", "type": "numberList", "items": ["Calculate Net Sales (Sales − Sales Returns)"]}, {"id": "amd-u2-c83-3", "type": "numberList", "items": ["Identify Net Profit After Tax (or Before Tax, as required)"]}, {"id": "amd-u2-c83-4", "type": "numberList", "items": ["Apply Formula = (Net Profit ÷ Net Sales) × 100"]}, {"id": "amd-u2-c83-5", "text": "Example:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c83-6", "text": "Net Sales: ₹10,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c83-7", "text": "Operating Profit: ₹2,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c83-8", "text": "Interest Paid: ₹50,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c83-9", "text": "Interest Received: ₹10,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c83-10", "text": "Net Profit Before Tax: ₹1,60,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c83-11", "text": "Tax: ₹60,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c83-12", "text": "Net Profit After Tax: ₹1,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c83-13", "type": "formula", "expression": "Net Profit Ratio = (1,00,000 ÷ 10,00,000) × 100 = 10%"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('6d592918-d1d9-46a0-a084-b244768f1155', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How should Net Profit Ratio be interpreted?', '', 'High Ratio:

Positive: Strong overall profitability

Positive: Efficient cost management across all areas

Positive: Good pricing power and operational control

Low Ratio:

Negative: Weak profitability, high costs

Negative: May indicate pricing pressure or inefficiency

Action: Analyse components (Gross Profit, Operating Expenses, Interest, Tax) Comparison:

Net Profit Ratio \< Operating Profit Ratio → High interest/tax burden Net Profit Ratio \> Operating Profit Ratio → Significant non-operating income Trend Analysis:

Increasing trend → Improving overall profitability

Decreasing trend → Margin pressure, rising costs

Industry Context:

Varies significantly by industry

Compare with industry averages for meaningful interpretation', NULL, NULL, NULL, 84, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'd55ea009-6d60-467e-8a3f-ecbc60a1752e', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c84-q", "text": "How should Net Profit Ratio be interpreted?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c84-1", "text": "High Ratio:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c84-2", "text": "Positive: Strong overall profitability", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c84-3", "text": "Positive: Efficient cost management across all areas", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c84-4", "text": "Positive: Good pricing power and operational control", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c84-5", "text": "Low Ratio:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c84-6", "text": "Negative: Weak profitability, high costs", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c84-7", "text": "Negative: May indicate pricing pressure or inefficiency", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c84-8", "text": "Action: Analyse components (Gross Profit, Operating Expenses, Interest, Tax) Comparison:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c84-9", "text": "Net Profit Ratio \\< Operating Profit Ratio → High interest/tax burden Net Profit Ratio \\> Operating Profit Ratio → Significant non-operating income Trend Analysis:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c84-10", "text": "Increasing trend → Improving overall profitability", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c84-11", "text": "Decreasing trend → Margin pressure, rising costs", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c84-12", "text": "Industry Context:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c84-13", "text": "Varies significantly by industry", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c84-14", "text": "Compare with industry averages for meaningful interpretation", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('afcf07b9-894e-4905-84d8-b42ca5eb58ea', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'Calculate Net Profit Before Tax Ratio and Net Profit After Tax Ratio: From Revenue Statement: Sales: ₹15,00,000 Sales Returns: ₹50,000 Gross Profit: ₹6,00,000 Office Expenses: ₹1,50,000 Selling Expenses: ₹2,00,000 Interest on Borrowings: ₹80,000 Interest Received: ₹20,000 Income Tax: ₹1,00,000', '', 'Solution:

Step 1: Calculate Net Sales

Sales: ₹15,00,000

Less: Sales Returns: ₹50,000

Net Sales: ₹14,50,000

Step 2: Calculate Operating Profit

Gross Profit: ₹6,00,000

Less: Office Expenses: ₹1,50,000

Less: Selling Expenses: ₹2,00,000

Operating Profit: ₹2,50,000

Step 3: Calculate Net Profit Before Tax

Operating Profit: ₹2,50,000

Less: Interest Paid: ₹80,000

Add: Interest Received: ₹20,000

Net Profit Before Tax: ₹1,90,000

Step 4: Calculate Net Profit After Tax

Net Profit Before Tax: ₹1,90,000

Less: Income Tax: ₹1,00,000

Net Profit After Tax: ₹90,000

Step 5: Apply Formulas

Interpretation: Net Profit Before Tax Ratio (13.10%) shows decent operational profitability. After tax (6.21%), the margin reduces significantly. The 6.89% difference is due to tax burden.', NULL, NULL, NULL, 85, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'd55ea009-6d60-467e-8a3f-ecbc60a1752e', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c85-q", "text": "Calculate Net Profit Before Tax Ratio and Net Profit After Tax Ratio: From Revenue Statement: Sales: ₹15,00,000 Sales Returns: ₹50,000 Gross Profit: ₹6,00,000 Office Expenses: ₹1,50,000 Selling Expenses: ₹2,00,000 Interest on Borrowings: ₹80,000 Interest Received: ₹20,000 Income Tax: ₹1,00,000", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c85-1", "text": "Solution:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c85-2", "text": "Step 1: Calculate Net Sales", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c85-3", "text": "Sales: ₹15,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c85-4", "text": "Less: Sales Returns: ₹50,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c85-5", "text": "Net Sales: ₹14,50,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c85-6", "text": "Step 2: Calculate Operating Profit", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c85-7", "text": "Gross Profit: ₹6,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c85-8", "text": "Less: Office Expenses: ₹1,50,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c85-9", "text": "Less: Selling Expenses: ₹2,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c85-10", "text": "Operating Profit: ₹2,50,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c85-11", "text": "Step 3: Calculate Net Profit Before Tax", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c85-12", "text": "Operating Profit: ₹2,50,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c85-13", "text": "Less: Interest Paid: ₹80,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c85-14", "text": "Add: Interest Received: ₹20,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c85-15", "text": "Net Profit Before Tax: ₹1,90,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c85-16", "text": "Step 4: Calculate Net Profit After Tax", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c85-17", "text": "Net Profit Before Tax: ₹1,90,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c85-18", "text": "Less: Income Tax: ₹1,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c85-19", "text": "Net Profit After Tax: ₹90,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c85-20", "text": "Step 5: Apply Formulas", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c85-21", "text": "Interpretation: Net Profit Before Tax Ratio (13.10%) shows decent operational profitability. After tax (6.21%), the margin reduces significantly. The 6.89% difference is due to tax burden.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('046ffbd1-178f-4a37-9e12-aeda70cac0b5', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What errors occur in Net Profit Ratio?', '', 'Common Errors:

Using Operating Profit — Not deducting interest, tax
Using Gross Profit — Not deducting operating expenses

Using Gross Sales — Not deducting Sales Returns

Confusing with Operating Ratio — Net Profit includes non-operating items 5. Wrong Tax Treatment — Not deducting tax for Net Profit After Tax Ratio Critical Distinction:

Net Profit Ratio → Final profit after ALL expenses

Operating Profit Ratio → Before interest and tax', NULL, NULL, NULL, 86, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'd55ea009-6d60-467e-8a3f-ecbc60a1752e', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c86-q", "text": "What errors occur in Net Profit Ratio?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c86-1", "text": "Common Errors:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c86-2", "type": "numberList", "items": ["Using Operating Profit — Not deducting interest, tax", "Using Gross Profit — Not deducting operating expenses"]}, {"id": "amd-u2-c86-3", "type": "numberList", "items": ["Using Gross Sales — Not deducting Sales Returns"]}, {"id": "amd-u2-c86-4", "type": "numberList", "items": ["Confusing with Operating Ratio — Net Profit includes non-operating items 5. Wrong Tax Treatment — Not deducting tax for Net Profit After Tax Ratio Critical Distinction:"]}, {"id": "amd-u2-c86-5", "text": "Net Profit Ratio → Final profit after ALL expenses", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c86-6", "text": "Operating Profit Ratio → Before interest and tax", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('737ee0f0-16bf-4e97-bb27-dac89be7172d', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How might Net Profit Ratio be tested?', '', 'Variations:

Before Tax vs. After Tax: Specify which numerator to use

Combined Question: Calculate with Gross Profit Ratio, Operating Ratio 3. Missing Figure: "Net Profit Ratio is 8%, Net Sales ₹10,00,000. Find Net Profit" 4. Revenue Statement: Prepare full statement, then calculate multiple ratios 5. Trend Analysis: Compare across years from Comparative Statement

NET OPERATING PROFIT RATIO', NULL, NULL, NULL, 87, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', 'd55ea009-6d60-467e-8a3f-ecbc60a1752e', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c87-q", "text": "How might Net Profit Ratio be tested?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c87-1", "text": "Variations:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c87-2", "type": "numberList", "items": ["Before Tax vs. After Tax: Specify which numerator to use"]}, {"id": "amd-u2-c87-3", "type": "numberList", "items": ["Combined Question: Calculate with Gross Profit Ratio, Operating Ratio 3. Missing Figure: \"Net Profit Ratio is 8%, Net Sales ₹10,00,000. Find Net Profit\" 4. Revenue Statement: Prepare full statement, then calculate multiple ratios 5. Trend Analysis: Compare across years from Comparative Statement"]}, {"id": "amd-u2-c87-4", "type": "numberList", "items": ["NET OPERATING PROFIT RATIO"]}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('3c3e8e1e-5a14-4174-acc8-1be6e4e7ca51', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What is the formula for Stock Turnover Ratio?', '', 'Stock Turnover Ratio = Cost of Goods Sold ÷ Average Stock

Where:

Alternative (if Average Stock not available):

Expressed as: Number of times (e.g., 5 times means stock turns over 5 times per year) Related Ratio:', NULL, NULL, NULL, 97, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '888cf58a-fc5d-4a1e-8971-0b8c372b23fb', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c97-q", "text": "What is the formula for Stock Turnover Ratio?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c97-1", "type": "formula", "expression": "Stock Turnover Ratio = Cost of Goods Sold ÷ Average Stock"}, {"id": "amd-u2-c97-2", "text": "Where:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c97-3", "text": "Alternative (if Average Stock not available):", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c97-4", "text": "Expressed as: Number of times (e.g., 5 times means stock turns over 5 times per year) Related Ratio:", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('088baffe-952c-47da-963f-fdf3c036e6b8', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What is the Net Operating Profit Ratio?', '', 'The Net Operating Profit Ratio (also called Operating Profit Ratio or Return on Sales) measures the relationship between Operating Profit and Net Sales. It indicates profitability from core business operations before considering non-operating items (interest, tax,

extraordinary items).

Purpose: Assess operational efficiency independent of financing and tax decisions.', NULL, NULL, NULL, 88, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '7e6114d9-4bfb-4b62-b65f-3672e5a20f67', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c88-q", "text": "What is the Net Operating Profit Ratio?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c88-1", "text": "The Net Operating Profit Ratio (also called Operating Profit Ratio or Return on Sales) measures the relationship between Operating Profit and Net Sales. It indicates profitability from core business operations before considering non-operating items (interest, tax,", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c88-2", "text": "extraordinary items).", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c88-3", "text": "Purpose: Assess operational efficiency independent of financing and tax decisions.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('43daa7cd-a69a-450f-9f73-d915ea424c5b', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What is the formula for Net Operating Profit Ratio?', '', 'Net Operating Profit Ratio = (Operating Profit ÷ Net Sales) × 100

Alternative Calculation:

Where:

Operating Profit = Gross Profit − Operating Expenses

Operating Profit = Net Sales − Cost of Goods Sold − Operating Expenses Operating Profit = EBIT (Earnings Before Interest and Tax) in most cases Expressed as: Percentage (%)

Relationship: Operating Ratio + Operating Profit Ratio = 100%', NULL, NULL, NULL, 89, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '7e6114d9-4bfb-4b62-b65f-3672e5a20f67', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c89-q", "text": "What is the formula for Net Operating Profit Ratio?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c89-1", "type": "formula", "expression": "Net Operating Profit Ratio = (Operating Profit ÷ Net Sales) × 100"}, {"id": "amd-u2-c89-2", "text": "Alternative Calculation:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c89-3", "text": "Where:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c89-4", "type": "formula", "expression": "Operating Profit = Gross Profit − Operating Expenses"}, {"id": "amd-u2-c89-5", "type": "formula", "expression": "Operating Profit = Net Sales − Cost of Goods Sold − Operating Expenses Operating Profit = EBIT (Earnings Before Interest and Tax) in most cases Expressed as: Percentage (%)"}, {"id": "amd-u2-c89-6", "type": "formula", "expression": "Relationship: Operating Ratio + Operating Profit Ratio = 100%"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('02b773dd-f757-4dad-8aa2-e2102d9ea672', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What comprises Operating Profit?', '', 'Operating Profit Calculation:

Method 1:

Net Sales

Less: Cost of Goods Sold

= Gross Profit

Less: Operating Expenses (Office, Selling, Admin)

= Operating Profit

Method 2:

Gross Profit

Less: Operating Expenses

= Operating Profit

Method 3:

Net Profit Before Tax

Add: Non-Operating Expenses (Interest, Loss on Sale)

Less: Non-Operating Income (Interest Received, Dividend) = Operating Profit

Excludes:

Non-Operating Expenses: Interest on Borrowings, Loss on Sale of Fixed Assets Non-Operating Income: Interest Received, Dividend Received Tax: Income Tax

Extraordinary Items: Profit/Loss on sale of investments (if non-operating) Key Distinction:

Operating Profit → Core business operations only

Net Profit → Includes all items (operating + non-operating)', NULL, NULL, NULL, 90, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '7e6114d9-4bfb-4b62-b65f-3672e5a20f67', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c90-q", "text": "What comprises Operating Profit?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c90-1", "text": "Operating Profit Calculation:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c90-2", "text": "Method 1:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c90-3", "text": "Net Sales", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c90-4", "text": "Less: Cost of Goods Sold", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c90-5", "type": "formula", "expression": "= Gross Profit"}, {"id": "amd-u2-c90-6", "text": "Less: Operating Expenses (Office, Selling, Admin)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c90-7", "type": "formula", "expression": "= Operating Profit"}, {"id": "amd-u2-c90-8", "text": "Method 2:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c90-9", "text": "Gross Profit", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c90-10", "text": "Less: Operating Expenses", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c90-11", "type": "formula", "expression": "= Operating Profit"}, {"id": "amd-u2-c90-12", "text": "Method 3:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c90-13", "text": "Net Profit Before Tax", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c90-14", "text": "Add: Non-Operating Expenses (Interest, Loss on Sale)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c90-15", "type": "formula", "expression": "Less: Non-Operating Income (Interest Received, Dividend) = Operating Profit"}, {"id": "amd-u2-c90-16", "text": "Excludes:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c90-17", "text": "Non-Operating Expenses: Interest on Borrowings, Loss on Sale of Fixed Assets Non-Operating Income: Interest Received, Dividend Received Tax: Income Tax", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c90-18", "text": "Extraordinary Items: Profit/Loss on sale of investments (if non-operating) Key Distinction:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c90-19", "text": "Operating Profit → Core business operations only", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c90-20", "text": "Net Profit → Includes all items (operating + non-operating)", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('9de9bc90-32dc-4ad6-877f-cb6d4821557d', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How is Net Operating Profit Ratio calculated?', '', 'Steps:

Calculate Net Sales (Sales − Sales Returns)

Calculate Operating Profit (Gross Profit − Operating Expenses) 3. Apply Formula = (Operating Profit ÷ Net Sales) × 100

Alternative (from Operating Ratio):

Calculate Operating Ratio

Operating Profit Ratio = 100 − Operating Ratio

Example:

Net Sales: ₹10,00,000

Cost of Goods Sold: ₹6,00,000

Gross Profit: ₹4,00,000

Operating Expenses: ₹2,00,000

Operating Profit: ₹2,00,000

Operating Profit Ratio = (2,00,000 ÷ 10,00,000) × 100 = 20% (Or: Operating Ratio = 80%, so Operating Profit Ratio = 100 - 80 = 20%)', NULL, NULL, NULL, 91, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '7e6114d9-4bfb-4b62-b65f-3672e5a20f67', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c91-q", "text": "How is Net Operating Profit Ratio calculated?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c91-1", "text": "Steps:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c91-2", "type": "numberList", "items": ["Calculate Net Sales (Sales − Sales Returns)"]}, {"id": "amd-u2-c91-3", "type": "numberList", "items": ["Calculate Operating Profit (Gross Profit − Operating Expenses) 3. Apply Formula = (Operating Profit ÷ Net Sales) × 100"]}, {"id": "amd-u2-c91-4", "text": "Alternative (from Operating Ratio):", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c91-5", "type": "numberList", "items": ["Calculate Operating Ratio"]}, {"id": "amd-u2-c91-6", "type": "numberList", "items": ["Operating Profit Ratio = 100 − Operating Ratio"]}, {"id": "amd-u2-c91-7", "text": "Example:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c91-8", "text": "Net Sales: ₹10,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c91-9", "text": "Cost of Goods Sold: ₹6,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c91-10", "text": "Gross Profit: ₹4,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c91-11", "text": "Operating Expenses: ₹2,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c91-12", "text": "Operating Profit: ₹2,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c91-13", "type": "formula", "expression": "Operating Profit Ratio = (2,00,000 ÷ 10,00,000) × 100 = 20% (Or: Operating Ratio = 80%, so Operating Profit Ratio = 100 - 80 = 20%)"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('adb7a66d-2145-4060-863a-b9a66b8b42f1', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Explain the Book Value Method: procedure and formulas.', 'Priority: Tier 1 | PYQ Connection: 2025 Q4.3 ("Book Value Method of Balance Sheet Valuation") | PYQ Connection: 2025 Q4.3 ("Book Value Method of Balance Sheet Valuation")', 'Formula

Net worth (equity shareholders'' funds) = Equity share capital + Reserves and surplus − Accumulated losses − Fictitious assets (preliminary expenses, discount on issue, miscellaneous expenditure not written off)
Book value per share = Net worth ÷ Number of equity shares

Second route (asset side)

Net worth = Total assets (excluding fictitious assets) − Outside liabilities (debentures, loans, current liabilities) − Preference share capital

Procedure

Take the balance sheet and list all assets and liabilities.
Remove fictitious assets and accumulated losses from the asset side.
Deduct outside liabilities.
Deduct preference share capital (and its arrears).
The remainder is the equity value.
Divide by the number of equity shares (= equity share capital ÷ face value).
Compare with the market price (Price/Book = Market price ÷ Book value per share).

Variables

Outside liabilities = amounts owed to third parties. Fictitious assets = expenses shown as assets that have no realisable value.', NULL, NULL, NULL, 5, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'a6370687-af9d-43eb-9fe1-5cfd8e1ad30e', '{"blocks": [{"id": "equity-and-debt-markets-u4-c5-q", "text": "Explain the Book Value Method: procedure and formulas.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c5-1", "bold": true, "text": "Formula", "type": "text", "style": "heading"}, {"id": "edm-u4-c5-2", "type": "bulletList", "items": ["Net worth (equity shareholders'' funds) = Equity share capital + Reserves and surplus − Accumulated losses − Fictitious assets (preliminary expenses, discount on issue, miscellaneous expenditure not written off)", "Book value per share = Net worth ÷ Number of equity shares"]}, {"id": "edm-u4-c5-3", "bold": true, "text": "Second route (asset side)", "type": "text", "style": "heading"}, {"id": "edm-u4-c5-4", "type": "bulletList", "items": ["Net worth = Total assets (excluding fictitious assets) − Outside liabilities (debentures, loans, current liabilities) − Preference share capital"]}, {"id": "edm-u4-c5-5", "bold": true, "text": "Procedure", "type": "text", "style": "heading"}, {"id": "edm-u4-c5-6", "type": "numberList", "items": ["Take the balance sheet and list all assets and liabilities.", "Remove fictitious assets and accumulated losses from the asset side.", "Deduct outside liabilities.", "Deduct preference share capital (and its arrears).", "The remainder is the equity value.", "Divide by the number of equity shares (= equity share capital ÷ face value).", "Compare with the market price (Price/Book = Market price ÷ Book value per share)."]}, {"id": "edm-u4-c5-7", "bold": true, "text": "Variables", "type": "text", "style": "heading"}, {"id": "edm-u4-c5-8", "type": "formula", "expression": "Outside liabilities = amounts owed to third parties. Fictitious assets = expenses shown as assets that have no realisable value."}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('20fc35ba-e9ff-45ab-bebd-58c1ca0e71c3', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How should Net Operating Profit Ratio be interpreted?', '', 'High Ratio:

Positive: Strong operational efficiency

Positive: Good cost control in core business

Positive: Competitive advantage in operations

Low Ratio:

Negative: Weak operational performance

Negative: High operating costs relative to sales

Action: Review pricing, cost structure, operational efficiency Comparison with Net Profit Ratio:

Operating Profit Ratio \> Net Profit Ratio → High interest/tax burden Operating Profit Ratio \< Net Profit Ratio → Significant non-operating income (rare) Management Use:

Evaluates operational management performance

Independent of financing decisions (interest) and tax policies

Useful for comparing companies with different capital structures Industry Context:

Varies by industry (manufacturing vs. service vs. retail)

Compare with industry benchmarks', NULL, NULL, NULL, 92, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '7e6114d9-4bfb-4b62-b65f-3672e5a20f67', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c92-q", "text": "How should Net Operating Profit Ratio be interpreted?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c92-1", "text": "High Ratio:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c92-2", "text": "Positive: Strong operational efficiency", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c92-3", "text": "Positive: Good cost control in core business", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c92-4", "text": "Positive: Competitive advantage in operations", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c92-5", "text": "Low Ratio:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c92-6", "text": "Negative: Weak operational performance", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c92-7", "text": "Negative: High operating costs relative to sales", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c92-8", "text": "Action: Review pricing, cost structure, operational efficiency Comparison with Net Profit Ratio:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c92-9", "text": "Operating Profit Ratio \\> Net Profit Ratio → High interest/tax burden Operating Profit Ratio \\< Net Profit Ratio → Significant non-operating income (rare) Management Use:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c92-10", "text": "Evaluates operational management performance", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c92-11", "text": "Independent of financing decisions (interest) and tax policies", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c92-12", "text": "Useful for comparing companies with different capital structures Industry Context:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c92-13", "text": "Varies by industry (manufacturing vs. service vs. retail)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c92-14", "text": "Compare with industry benchmarks", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('743c59da-27da-4a98-9923-7fddf351cafc', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'Calculate Net Operating Profit Ratio: From Revenue Statement: Sales: ₹20,00,000 Sales Returns: ₹1,00,000 Cost of Goods Sold: ₹12,00,000 Office Expenses: ₹2,00,000 Selling Expenses: ₹2,50,000 Interest on Borrowings: ₹1,00,000 (exclude) Income Tax: ₹80,000 (exclude)', '', 'Solution:

Step 1: Calculate Net Sales

Sales: ₹20,00,000

Less: Sales Returns: ₹1,00,000

Net Sales: ₹19,00,000

Step 2: Calculate Gross Profit

Net Sales: ₹19,00,000

Less: Cost of Goods Sold: ₹12,00,000

Gross Profit: ₹7,00,000

Step 3: Calculate Operating Profit

Gross Profit: ₹7,00,000

Less: Office Expenses: ₹2,00,000

Less: Selling Expenses: ₹2,50,000

Operating Profit: ₹2,50,000

(Exclude Interest and Tax)

Step 4: Apply Formula

Interpretation: Operating Profit Ratio of 13.16% indicates moderate operational efficiency. For every ₹100 of sales, the company earns ₹13.16 from core operations before interest and tax.', NULL, NULL, NULL, 93, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '7e6114d9-4bfb-4b62-b65f-3672e5a20f67', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c93-q", "text": "Calculate Net Operating Profit Ratio: From Revenue Statement: Sales: ₹20,00,000 Sales Returns: ₹1,00,000 Cost of Goods Sold: ₹12,00,000 Office Expenses: ₹2,00,000 Selling Expenses: ₹2,50,000 Interest on Borrowings: ₹1,00,000 (exclude) Income Tax: ₹80,000 (exclude)", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c93-1", "text": "Solution:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c93-2", "text": "Step 1: Calculate Net Sales", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c93-3", "text": "Sales: ₹20,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c93-4", "text": "Less: Sales Returns: ₹1,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c93-5", "text": "Net Sales: ₹19,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c93-6", "text": "Step 2: Calculate Gross Profit", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c93-7", "text": "Net Sales: ₹19,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c93-8", "text": "Less: Cost of Goods Sold: ₹12,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c93-9", "text": "Gross Profit: ₹7,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c93-10", "text": "Step 3: Calculate Operating Profit", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c93-11", "text": "Gross Profit: ₹7,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c93-12", "text": "Less: Office Expenses: ₹2,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c93-13", "text": "Less: Selling Expenses: ₹2,50,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c93-14", "text": "Operating Profit: ₹2,50,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c93-15", "text": "(Exclude Interest and Tax)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c93-16", "text": "Step 4: Apply Formula", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c93-17", "text": "Interpretation: Operating Profit Ratio of 13.16% indicates moderate operational efficiency. For every ₹100 of sales, the company earns ₹13.16 from core operations before interest and tax.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('b7620ef2-7c4a-4e20-8bf0-7a1ccc9e708a', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What errors occur in Net Operating Profit Ratio?', '', 'Common Errors:

Including Non-Operating Items — Deducting Interest, Tax from Operating Profit 2. Using Net Profit — Confusing with Net Profit Ratio

Using Gross Profit — Not deducting Operating Expenses

Using Gross Sales — Not deducting Sales Returns

Confusing with Operating Ratio — Operating Ratio is cost-based; Operating Profit Ratio is profit-based

Critical Distinction:

Operating Profit Ratio = Operating Profit ÷ Net Sales

Operating Ratio = Operating Cost ÷ Net Sales

Operating Profit Ratio = 100 − Operating Ratio', NULL, NULL, NULL, 94, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '7e6114d9-4bfb-4b62-b65f-3672e5a20f67', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c94-q", "text": "What errors occur in Net Operating Profit Ratio?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c94-1", "text": "Common Errors:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c94-2", "type": "numberList", "items": ["Including Non-Operating Items — Deducting Interest, Tax from Operating Profit 2. Using Net Profit — Confusing with Net Profit Ratio"]}, {"id": "amd-u2-c94-3", "type": "numberList", "items": ["Using Gross Profit — Not deducting Operating Expenses"]}, {"id": "amd-u2-c94-4", "type": "numberList", "items": ["Using Gross Sales — Not deducting Sales Returns"]}, {"id": "amd-u2-c94-5", "type": "numberList", "items": ["Confusing with Operating Ratio — Operating Ratio is cost-based; Operating Profit Ratio is profit-based"]}, {"id": "amd-u2-c94-6", "text": "Critical Distinction:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c94-7", "type": "formula", "expression": "Operating Profit Ratio = Operating Profit ÷ Net Sales"}, {"id": "amd-u2-c94-8", "type": "formula", "expression": "Operating Ratio = Operating Cost ÷ Net Sales"}, {"id": "amd-u2-c94-9", "type": "formula", "expression": "Operating Profit Ratio = 100 − Operating Ratio"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('72523e5d-7745-49f6-b763-509b06eee401', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How might Net Operating Profit Ratio be tested?', '', 'Variations:

From Operating Ratio: "Operating Ratio is 78%. Find Operating Profit Ratio" (Answer: 22%) 2. Combined Question: Calculate with Gross Profit Ratio, Net Profit Ratio 3. Missing Figure: "Operating Profit Ratio is 15%, Net Sales ₹10,00,000. Find Operating Profit" 4. Revenue Statement: Prepare statement, calculate multiple ratios
Comparison: "Compare Operating Profit Ratio with Net Profit Ratio and explain difference"

STOCK TURNOVER RATIO', NULL, NULL, NULL, 95, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '7e6114d9-4bfb-4b62-b65f-3672e5a20f67', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c95-q", "text": "How might Net Operating Profit Ratio be tested?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c95-1", "text": "Variations:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c95-2", "type": "numberList", "items": ["From Operating Ratio: \"Operating Ratio is 78%. Find Operating Profit Ratio\" (Answer: 22%) 2. Combined Question: Calculate with Gross Profit Ratio, Net Profit Ratio 3. Missing Figure: \"Operating Profit Ratio is 15%, Net Sales ₹10,00,000. Find Operating Profit\" 4. Revenue Statement: Prepare statement, calculate multiple ratios", "Comparison: \"Compare Operating Profit Ratio with Net Profit Ratio and explain difference\""]}, {"id": "amd-u2-c95-3", "type": "numberList", "items": ["STOCK TURNOVER RATIO"]}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('bab31405-28f7-4151-ab43-e26a17c0d79e', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What comprises Cost of Goods Sold and Average Stock?', '', 'Cost of Goods Sold:

Opening Stock

+ Purchases (less Purchase Returns)

+ Direct Expenses (Carriage Inward, Wages, Factory Expenses)

- Closing Stock

= Cost of Goods Sold

Average Stock:

Opening Stock = Stock at beginning of period

Closing Stock = Stock at end of period

Average = (Opening + Closing) ÷ 2

If Opening Stock not given:

Use Closing Stock as denominator (less accurate)

Stock Includes:

Raw Materials

Work-in-Progress (WIP)

Finished Goods

Stock-in-Trade

2022 & 2025 PYQ: Stock Turnover Ratio frequently tested.', NULL, NULL, NULL, 98, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '888cf58a-fc5d-4a1e-8971-0b8c372b23fb', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c98-q", "text": "What comprises Cost of Goods Sold and Average Stock?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c98-1", "text": "Cost of Goods Sold:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c98-2", "text": "Opening Stock", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c98-3", "text": "+ Purchases (less Purchase Returns)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c98-4", "text": "+ Direct Expenses (Carriage Inward, Wages, Factory Expenses)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c98-5", "text": "- Closing Stock", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c98-6", "type": "formula", "expression": "= Cost of Goods Sold"}, {"id": "amd-u2-c98-7", "text": "Average Stock:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c98-8", "type": "formula", "expression": "Opening Stock = Stock at beginning of period"}, {"id": "amd-u2-c98-9", "type": "formula", "expression": "Closing Stock = Stock at end of period"}, {"id": "amd-u2-c98-10", "type": "formula", "expression": "Average = (Opening + Closing) ÷ 2"}, {"id": "amd-u2-c98-11", "text": "If Opening Stock not given:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c98-12", "text": "Use Closing Stock as denominator (less accurate)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c98-13", "text": "Stock Includes:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c98-14", "text": "Raw Materials", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c98-15", "text": "Work-in-Progress (WIP)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c98-16", "text": "Finished Goods", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c98-17", "text": "Stock-in-Trade", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c98-18", "text": "2022 & 2025 PYQ: Stock Turnover Ratio frequently tested.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('2610a9ed-8994-4b67-af65-c07365d58c20', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How is Stock Turnover Ratio calculated?', '', 'Steps:

Calculate Cost of Goods Sold (from Trading Account) 2. Calculate Average Stock = (Opening Stock + Closing Stock) ÷ 2 3. Apply Formula = Cost of Goods Sold ÷ Average Stock Example:

Opening Stock: ₹1,00,000

Closing Stock: ₹1,50,000

Average Stock: (1,00,000 + 1,50,000) ÷ 2 = ₹1,25,000 Cost of Goods Sold: ₹6,00,000

Stock Turnover Ratio = 6,00,000 ÷ 1,25,000 = 4.8 times Stock Holding Period:', NULL, NULL, NULL, 99, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '888cf58a-fc5d-4a1e-8971-0b8c372b23fb', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c99-q", "text": "How is Stock Turnover Ratio calculated?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c99-1", "text": "Steps:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c99-2", "type": "numberList", "items": ["Calculate Cost of Goods Sold (from Trading Account) 2. Calculate Average Stock = (Opening Stock + Closing Stock) ÷ 2 3. Apply Formula = Cost of Goods Sold ÷ Average Stock Example:"]}, {"id": "amd-u2-c99-3", "text": "Opening Stock: ₹1,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c99-4", "text": "Closing Stock: ₹1,50,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c99-5", "type": "formula", "expression": "Average Stock: (1,00,000 + 1,50,000) ÷ 2 = ₹1,25,000 Cost of Goods Sold: ₹6,00,000"}, {"id": "amd-u2-c99-6", "type": "formula", "expression": "Stock Turnover Ratio = 6,00,000 ÷ 1,25,000 = 4.8 times Stock Holding Period:"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('c1221ca2-b49c-4397-b6c7-27fb8ff28254', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How should Stock Turnover Ratio be interpreted?', '', 'High Ratio:

Positive: Fast stock movement, efficient inventory management Positive: Lower holding costs, reduced obsolescence risk

Negative: May indicate understocking, risk of stockouts

Low Ratio:

Positive: Adequate stock for smooth operations

Negative: Slow-moving stock, overstocking

Negative: High holding costs, obsolescence risk, blocked working capital Industry Context:

FMCG/Retail: High turnover (10-20 times)

Manufacturing: Moderate (4-8 times)

Durables: Lower (2-4 times)

Stock Holding Period:

Shorter period → Faster stock movement

Longer period → Slower movement, potential overstocking Trend Analysis:

Increasing trend → Improving inventory efficiency

Decreasing trend → Slowing sales or overstocking', NULL, NULL, NULL, 100, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '888cf58a-fc5d-4a1e-8971-0b8c372b23fb', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c100-q", "text": "How should Stock Turnover Ratio be interpreted?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c100-1", "text": "High Ratio:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c100-2", "text": "Positive: Fast stock movement, efficient inventory management Positive: Lower holding costs, reduced obsolescence risk", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c100-3", "text": "Negative: May indicate understocking, risk of stockouts", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c100-4", "text": "Low Ratio:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c100-5", "text": "Positive: Adequate stock for smooth operations", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c100-6", "text": "Negative: Slow-moving stock, overstocking", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c100-7", "text": "Negative: High holding costs, obsolescence risk, blocked working capital Industry Context:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c100-8", "text": "FMCG/Retail: High turnover (10-20 times)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c100-9", "text": "Manufacturing: Moderate (4-8 times)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c100-10", "text": "Durables: Lower (2-4 times)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c100-11", "text": "Stock Holding Period:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c100-12", "text": "Shorter period → Faster stock movement", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c100-13", "text": "Longer period → Slower movement, potential overstocking Trend Analysis:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c100-14", "text": "Increasing trend → Improving inventory efficiency", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c100-15", "text": "Decreasing trend → Slowing sales or overstocking", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('1997b8ff-1c7e-4cb5-843e-0f3b0c9f6232', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'Calculate Stock Turnover Ratio and Stock Holding Period: From Trading Information: Opening Stock: ₹1,20,000 Purchases: ₹8,00,000 Purchase Returns: ₹40,000 Carriage Inward: ₹30,000 Closing Stock: ₹1,80,000', '', 'Solution:

Step 1: Calculate Cost of Goods Sold

Opening Stock: ₹1,20,000

+ Purchases: ₹8,00,000

Less: Purchase Returns: ₹40,000

Net Purchases: ₹7,60,000

+ Carriage Inward: ₹30,000

Cost of Goods Available: ₹9,10,000

Less: Closing Stock: ₹1,80,000

Cost of Goods Sold: ₹7,30,000

Step 2: Calculate Average Stock

Average Stock = (1,20,000 + 1,80,000) ÷ 2 = ₹1,50,000

Step 3: Apply Formula

Step 4: Calculate Stock Holding Period

Interpretation: Stock turns over 4.87 times per year, meaning inventory is held for approximately 75 days on average. This indicates moderate inventory efficiency. Management should compare with industry benchmarks.', NULL, NULL, NULL, 101, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '888cf58a-fc5d-4a1e-8971-0b8c372b23fb', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c101-q", "text": "Calculate Stock Turnover Ratio and Stock Holding Period: From Trading Information: Opening Stock: ₹1,20,000 Purchases: ₹8,00,000 Purchase Returns: ₹40,000 Carriage Inward: ₹30,000 Closing Stock: ₹1,80,000", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c101-1", "text": "Solution:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c101-2", "text": "Step 1: Calculate Cost of Goods Sold", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c101-3", "text": "Opening Stock: ₹1,20,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c101-4", "text": "+ Purchases: ₹8,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c101-5", "text": "Less: Purchase Returns: ₹40,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c101-6", "text": "Net Purchases: ₹7,60,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c101-7", "text": "+ Carriage Inward: ₹30,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c101-8", "text": "Cost of Goods Available: ₹9,10,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c101-9", "text": "Less: Closing Stock: ₹1,80,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c101-10", "text": "Cost of Goods Sold: ₹7,30,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c101-11", "text": "Step 2: Calculate Average Stock", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c101-12", "type": "formula", "expression": "Average Stock = (1,20,000 + 1,80,000) ÷ 2 = ₹1,50,000"}, {"id": "amd-u2-c101-13", "text": "Step 3: Apply Formula", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c101-14", "text": "Step 4: Calculate Stock Holding Period", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c101-15", "text": "Interpretation: Stock turns over 4.87 times per year, meaning inventory is held for approximately 75 days on average. This indicates moderate inventory efficiency. Management should compare with industry benchmarks.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('2f21d706-6e83-4cb4-8544-27a3a21af7c6', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'What is Bond Valuation? Explain the methods of bond valuation.', 'Priority: Tier 1 | PYQ Connection: Oct 2024 Q4B (8m) | PYQ Connection: Oct 2024 Q4B (8m)', 'Meaning: Bond valuation is determining the fair (intrinsic) value of a bond as the present value of its expected cash flows (coupons plus redemption value), discounted at the required rate of return.

Methods

Present Value / Discounted Cash Flow method (basic method)

V = C × PVIFA(r, n) + M × PVIF(r, n)
This is the same as V = Σ [C ÷ (1+r)ᵗ] + M ÷ (1+r)ⁿ. Here C = annual coupon, M = redemption value, r = required yield, n = years.

Zero-coupon bond: V = M ÷ (1 + r)ⁿ.
Perpetual bond (irredeemable): V = C ÷ r.
Semi-annual coupons: use r ÷ 2, 2n periods and C ÷ 2.
Yield-based approach: the market price is compared with the value at the required yield. The YTM is the discount rate that makes the PV equal to the price (Card 27).
Current yield approach (approximate): Price ≈ Annual coupon ÷ Required current yield (used mainly for long-term or perpetual-like bonds).

Discount rate build-up: r = Risk-free rate (G-sec yield) + Credit/risk spread.
Steps: (1) List all cash flows. (2) Choose r. (3) Discount every cash flow. (4) Add. (5) Compare with the market price (V > price = buy).', NULL, NULL, NULL, 24, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'ad766610-0fb2-46eb-8d3e-79013b3ff5c7', '{"blocks": [{"id": "equity-and-debt-markets-u4-c24-q", "text": "What is Bond Valuation? Explain the methods of bond valuation.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c24-1", "type": "bulletList", "items": ["Meaning: Bond valuation is determining the fair (intrinsic) value of a bond as the present value of its expected cash flows (coupons plus redemption value), discounted at the required rate of return."]}, {"id": "edm-u4-c24-2", "bold": true, "text": "Methods", "type": "text", "style": "heading"}, {"id": "edm-u4-c24-3", "type": "numberList", "items": ["Present Value / Discounted Cash Flow method (basic method)"]}, {"id": "edm-u4-c24-4", "type": "bulletList", "items": ["V = C × PVIFA(r, n) + M × PVIF(r, n)", "This is the same as V = Σ [C ÷ (1+r)ᵗ] + M ÷ (1+r)ⁿ. Here C = annual coupon, M = redemption value, r = required yield, n = years."]}, {"id": "edm-u4-c24-5", "type": "numberList", "items": ["Zero-coupon bond: V = M ÷ (1 + r)ⁿ.", "Perpetual bond (irredeemable): V = C ÷ r.", "Semi-annual coupons: use r ÷ 2, 2n periods and C ÷ 2.", "Yield-based approach: the market price is compared with the value at the required yield. The YTM is the discount rate that makes the PV equal to the price (Card 27).", "Current yield approach (approximate): Price ≈ Annual coupon ÷ Required current yield (used mainly for long-term or perpetual-like bonds)."]}, {"id": "edm-u4-c24-6", "type": "bulletList", "items": ["Discount rate build-up: r = Risk-free rate (G-sec yield) + Credit/risk spread.", "Steps: (1) List all cash flows. (2) Choose r. (3) Discount every cash flow. (4) Add. (5) Compare with the market price (V > price = buy)."]}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('dead794a-726b-4bb2-8fb8-db992a1418e7', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What errors occur in Stock Turnover Ratio?', '', 'Common Errors:

Using Sales instead of COGS — Using Net Sales in numerator (wrong)

Using only Closing Stock — Not calculating Average Stock when Opening Stock is available 3. Wrong COGS Calculation — Missing Direct Expenses, Purchase Returns 4. Including Operating Expenses — Adding Office, Selling expenses to COGS

Wrong Stock Holding Period Formula — Using 365 × Stock Turnover instead of 365 ÷ Stock Turnover

Critical Check: Numerator must be Cost of Goods Sold, not Sales.', NULL, NULL, NULL, 102, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '888cf58a-fc5d-4a1e-8971-0b8c372b23fb', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c102-q", "text": "What errors occur in Stock Turnover Ratio?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c102-1", "text": "Common Errors:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c102-2", "type": "numberList", "items": ["Using Sales instead of COGS — Using Net Sales in numerator (wrong)"]}, {"id": "amd-u2-c102-3", "type": "numberList", "items": ["Using only Closing Stock — Not calculating Average Stock when Opening Stock is available 3. Wrong COGS Calculation — Missing Direct Expenses, Purchase Returns 4. Including Operating Expenses — Adding Office, Selling expenses to COGS"]}, {"id": "amd-u2-c102-4", "type": "numberList", "items": ["Wrong Stock Holding Period Formula — Using 365 × Stock Turnover instead of 365 ÷ Stock Turnover"]}, {"id": "amd-u2-c102-5", "text": "Critical Check: Numerator must be Cost of Goods Sold, not Sales.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('409cc5d4-b0a8-423e-b6eb-de6de1178b54', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How might Stock Turnover Ratio be tested?', '', 'Variations:

Stock Holding Period: Calculate days instead of times

Missing Figure: "Stock Turnover is 6 times, Average Stock ₹1,00,000. Find COGS" 3. Combined Question: Calculate with Current Ratio, Stock Working Capital Ratio 4. Trading Account: Prepare Trading Account first, then calculate ratio

Trend Analysis: Calculate for multiple years to show inventory efficiency trend

SECTION E: COMBINED RATIOS

Tier 1: Extremely High Priority (Strong PYQ Evidence)

RETURN ON CAPITAL EMPLOYED (ROCE)', NULL, NULL, NULL, 103, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '888cf58a-fc5d-4a1e-8971-0b8c372b23fb', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c103-q", "text": "How might Stock Turnover Ratio be tested?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c103-1", "text": "Variations:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c103-2", "type": "numberList", "items": ["Stock Holding Period: Calculate days instead of times"]}, {"id": "amd-u2-c103-3", "type": "numberList", "items": ["Missing Figure: \"Stock Turnover is 6 times, Average Stock ₹1,00,000. Find COGS\" 3. Combined Question: Calculate with Current Ratio, Stock Working Capital Ratio 4. Trading Account: Prepare Trading Account first, then calculate ratio"]}, {"id": "amd-u2-c103-4", "type": "numberList", "items": ["Trend Analysis: Calculate for multiple years to show inventory efficiency trend"]}, {"id": "amd-u2-c103-5", "text": "SECTION E: COMBINED RATIOS", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c103-6", "text": "Tier 1: Extremely High Priority (Strong PYQ Evidence)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c103-7", "type": "numberList", "items": ["RETURN ON CAPITAL EMPLOYED (ROCE)"]}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('a25f4f1d-0aa4-44e3-b549-3f05e9a268d0', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What is Return on Capital Employed (ROCE)?', '', 'Return on Capital Employed (ROCE) measures the profitability earned on the total long-term capital invested in the business (both equity and long-term debt). It indicates how efficiently

the company uses its capital to generate operating profits.

Purpose: Assess overall capital efficiency and compare performance across companies with different capital structures.', NULL, NULL, NULL, 104, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '50ce4d1f-e658-4822-8f07-57f2d5af9a08', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c104-q", "text": "What is Return on Capital Employed (ROCE)?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c104-1", "text": "Return on Capital Employed (ROCE) measures the profitability earned on the total long-term capital invested in the business (both equity and long-term debt). It indicates how efficiently", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c104-2", "text": "the company uses its capital to generate operating profits.", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c104-3", "text": "Purpose: Assess overall capital efficiency and compare performance across companies with different capital structures.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('c8c9ba2a-5489-4b64-8159-d9e7dd4fd90e', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What is the formula for ROCE?', '', 'ROCE = (EBIT ÷ Capital Employed) × 100

Where:

EBIT = Operating Profit (before interest and tax)

Capital Employed = Total Assets − Current Liabilities

Alternative: Capital Employed = Equity + Long-term Debt

Expressed as: Percentage (%)

Mumbai University Convention: Use EBIT (Operating Profit) as numerator; Capital Employed =

Total Assets − Current Liabilities (or Equity + Long-term Borrowings).', NULL, NULL, NULL, 105, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '50ce4d1f-e658-4822-8f07-57f2d5af9a08', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c105-q", "text": "What is the formula for ROCE?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c105-1", "type": "formula", "expression": "ROCE = (EBIT ÷ Capital Employed) × 100"}, {"id": "amd-u2-c105-2", "text": "Where:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c105-3", "type": "formula", "expression": "EBIT = Operating Profit (before interest and tax)"}, {"id": "amd-u2-c105-4", "type": "formula", "expression": "Capital Employed = Total Assets − Current Liabilities"}, {"id": "amd-u2-c105-5", "type": "formula", "expression": "Alternative: Capital Employed = Equity + Long-term Debt"}, {"id": "amd-u2-c105-6", "text": "Expressed as: Percentage (%)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c105-7", "type": "formula", "expression": "Mumbai University Convention: Use EBIT (Operating Profit) as numerator; Capital Employed ="}, {"id": "amd-u2-c105-8", "text": "Total Assets − Current Liabilities (or Equity + Long-term Borrowings).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('1c2623f9-29d9-4c63-8b45-c1ac2f2d958a', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What comprises EBIT and Capital Employed?', '', 'EBIT (Operating Profit):

Gross Profit

Less: Operating Expenses (Office, Selling, Admin) = Operating Profit (EBIT)

Or:

Net Profit Before Tax

Add: Interest on Borrowings

Less: Non-Operating Income

= Operating Profit (EBIT)

Capital Employed (Two Methods):

Method 1 (Asset Side):

Total Assets (Fixed + Current + Investments)

Less: Current Liabilities

= Capital Employed

Method 2 (Liability Side):

Equity Share Capital

+ Preference Share Capital

+ Reserves & Surplus

+ Long-term Debt (Debentures, Long-term Loans)

= Capital Employed

Note: Both methods should give same result (subject to fictitious assets treatment).', NULL, NULL, NULL, 106, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '50ce4d1f-e658-4822-8f07-57f2d5af9a08', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c106-q", "text": "What comprises EBIT and Capital Employed?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c106-1", "text": "EBIT (Operating Profit):", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c106-2", "text": "Gross Profit", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c106-3", "type": "formula", "expression": "Less: Operating Expenses (Office, Selling, Admin) = Operating Profit (EBIT)"}, {"id": "amd-u2-c106-4", "text": "Or:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c106-5", "text": "Net Profit Before Tax", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c106-6", "text": "Add: Interest on Borrowings", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c106-7", "text": "Less: Non-Operating Income", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c106-8", "type": "formula", "expression": "= Operating Profit (EBIT)"}, {"id": "amd-u2-c106-9", "text": "Capital Employed (Two Methods):", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c106-10", "text": "Method 1 (Asset Side):", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c106-11", "text": "Total Assets (Fixed + Current + Investments)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c106-12", "text": "Less: Current Liabilities", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c106-13", "type": "formula", "expression": "= Capital Employed"}, {"id": "amd-u2-c106-14", "text": "Method 2 (Liability Side):", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c106-15", "text": "Equity Share Capital", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c106-16", "text": "+ Preference Share Capital", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c106-17", "text": "+ Reserves & Surplus", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c106-18", "text": "+ Long-term Debt (Debentures, Long-term Loans)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c106-19", "type": "formula", "expression": "= Capital Employed"}, {"id": "amd-u2-c106-20", "text": "Note: Both methods should give same result (subject to fictitious assets treatment).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('1f3c8350-3b0b-4fd1-b462-d79bbeb4492d', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How is ROCE calculated?', '', 'Steps:

Calculate EBIT (Operating Profit) from Revenue Statement
Calculate Capital Employed from Balance Sheet

Apply Formula = (EBIT ÷ Capital Employed) × 100

Example:

EBIT (Operating Profit): ₹3,00,000

Capital Employed:

Fixed Assets: ₹10,00,000

Current Assets: ₹5,00,000

Total Assets: ₹15,00,000

Less: Current Liabilities: ₹3,00,000

Capital Employed: ₹12,00,000

ROCE = (3,00,000 ÷ 12,00,000) × 100 = 25%', NULL, NULL, NULL, 107, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '50ce4d1f-e658-4822-8f07-57f2d5af9a08', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c107-q", "text": "How is ROCE calculated?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c107-1", "text": "Steps:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c107-2", "type": "numberList", "items": ["Calculate EBIT (Operating Profit) from Revenue Statement", "Calculate Capital Employed from Balance Sheet"]}, {"id": "amd-u2-c107-3", "type": "numberList", "items": ["Apply Formula = (EBIT ÷ Capital Employed) × 100"]}, {"id": "amd-u2-c107-4", "text": "Example:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c107-5", "text": "EBIT (Operating Profit): ₹3,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c107-6", "text": "Capital Employed:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c107-7", "text": "Fixed Assets: ₹10,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c107-8", "text": "Current Assets: ₹5,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c107-9", "text": "Total Assets: ₹15,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c107-10", "text": "Less: Current Liabilities: ₹3,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c107-11", "text": "Capital Employed: ₹12,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c107-12", "type": "formula", "expression": "ROCE = (3,00,000 ÷ 12,00,000) × 100 = 25%"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('2de33c33-0f9f-41f5-ae32-8647755f2f92', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How should ROCE be interpreted?', '', 'High ROCE:

Positive: Efficient capital utilisation

Positive: Strong profitability relative to capital invested Positive: Competitive advantage

Low ROCE:

Negative: Inefficient capital use

Negative: Poor profitability

Action: Improve operations or reduce capital base

Benchmarking:

Compare with industry average

Compare with cost of capital (ROCE should exceed cost of capital) Compare across time periods

2025 PYQ: ROCE explicitly tested.', NULL, NULL, NULL, 108, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '50ce4d1f-e658-4822-8f07-57f2d5af9a08', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c108-q", "text": "How should ROCE be interpreted?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c108-1", "text": "High ROCE:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c108-2", "text": "Positive: Efficient capital utilisation", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c108-3", "text": "Positive: Strong profitability relative to capital invested Positive: Competitive advantage", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c108-4", "text": "Low ROCE:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c108-5", "text": "Negative: Inefficient capital use", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c108-6", "text": "Negative: Poor profitability", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c108-7", "text": "Action: Improve operations or reduce capital base", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c108-8", "text": "Benchmarking:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c108-9", "text": "Compare with industry average", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c108-10", "text": "Compare with cost of capital (ROCE should exceed cost of capital) Compare across time periods", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c108-11", "text": "2025 PYQ: ROCE explicitly tested.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('049306b5-63e8-4b67-b98d-579e900a2ac3', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'Calculate ROCE: From Revenue Statement: Gross Profit: ₹5,00,000 Office Expenses: ₹1,00,000 Selling Expenses: ₹1,50,000 Interest on Borrowings: ₹80,000 (exclude for EBIT) From Balance Sheet: Fixed Assets: ₹12,00,000 Current Assets: ₹6,00,000 Current Liabilities: ₹4,00,000 Long-term Debt: ₹8,00,000 Equity: ₹6,00,000', '', 'Solution:

Step 1: Calculate EBIT (Operating Profit)

Gross Profit: ₹5,00,000

Less: Office Expenses: ₹1,00,000

Less: Selling Expenses: ₹1,50,000

EBIT: ₹2,50,000

Step 2: Calculate Capital Employed (Method 1\)

Fixed Assets: ₹12,00,000

Current Assets: ₹6,00,000

Total Assets: ₹18,00,000

Less: Current Liabilities: ₹4,00,000

Capital Employed: ₹14,00,000

Step 3: Apply Formula

Interpretation: ROCE of 17.86% indicates the company earns ₹17.86 for every ₹100 of capital employed. This should be compared with industry average and cost of capital.', NULL, NULL, NULL, 109, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '50ce4d1f-e658-4822-8f07-57f2d5af9a08', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c109-q", "text": "Calculate ROCE: From Revenue Statement: Gross Profit: ₹5,00,000 Office Expenses: ₹1,00,000 Selling Expenses: ₹1,50,000 Interest on Borrowings: ₹80,000 (exclude for EBIT) From Balance Sheet: Fixed Assets: ₹12,00,000 Current Assets: ₹6,00,000 Current Liabilities: ₹4,00,000 Long-term Debt: ₹8,00,000 Equity: ₹6,00,000", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c109-1", "text": "Solution:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c109-2", "text": "Step 1: Calculate EBIT (Operating Profit)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c109-3", "text": "Gross Profit: ₹5,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c109-4", "text": "Less: Office Expenses: ₹1,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c109-5", "text": "Less: Selling Expenses: ₹1,50,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c109-6", "text": "EBIT: ₹2,50,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c109-7", "text": "Step 2: Calculate Capital Employed (Method 1\\)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c109-8", "text": "Fixed Assets: ₹12,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c109-9", "text": "Current Assets: ₹6,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c109-10", "text": "Total Assets: ₹18,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c109-11", "text": "Less: Current Liabilities: ₹4,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c109-12", "text": "Capital Employed: ₹14,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c109-13", "text": "Step 3: Apply Formula", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c109-14", "text": "Interpretation: ROCE of 17.86% indicates the company earns ₹17.86 for every ₹100 of capital employed. This should be compared with industry average and cost of capital.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('77f1d4d4-bc21-43d1-929c-ba8e796ea958', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What errors occur in ROCE?', '', 'Common Errors:

Using Net Profit — Not adding back Interest and Tax to get EBIT

Wrong Capital Employed — Including Current Liabilities in denominator
Using Only Equity — Forgetting Long-term Debt in Capital Employed

Using Gross Profit — Not deducting Operating Expenses

Inconsistent Treatment — Using EBIT with Equity-only denominator

Critical Check: Numerator = EBIT (before interest, tax); Denominator = Equity + Long-term Debt (or Total Assets − Current Liabilities)', NULL, NULL, NULL, 110, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '50ce4d1f-e658-4822-8f07-57f2d5af9a08', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c110-q", "text": "What errors occur in ROCE?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c110-1", "text": "Common Errors:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c110-2", "type": "numberList", "items": ["Using Net Profit — Not adding back Interest and Tax to get EBIT"]}, {"id": "amd-u2-c110-3", "type": "numberList", "items": ["Wrong Capital Employed — Including Current Liabilities in denominator", "Using Only Equity — Forgetting Long-term Debt in Capital Employed"]}, {"id": "amd-u2-c110-4", "type": "numberList", "items": ["Using Gross Profit — Not deducting Operating Expenses"]}, {"id": "amd-u2-c110-5", "type": "numberList", "items": ["Inconsistent Treatment — Using EBIT with Equity-only denominator"]}, {"id": "amd-u2-c110-6", "type": "formula", "expression": "Critical Check: Numerator = EBIT (before interest, tax); Denominator = Equity + Long-term Debt (or Total Assets − Current Liabilities)"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('c613038b-bb37-4cf0-adb8-b76118117db4', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How might ROCE be tested?', '', 'Variations:

Average Capital Employed: Use (Opening + Closing Capital Employed) ÷ 2 2. Combined Question: Calculate with Return on Equity, Return on Proprietors'' Fund 3. Missing Figure: "ROCE is 20%, Capital Employed ₹10,00,000. Find EBIT" 4. Trend Analysis: Calculate for multiple years

Comparison: Compare ROCE with Return on Equity to assess leverage effect

RETURN ON PROPRIETOR''S FUND', NULL, NULL, NULL, 111, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '50ce4d1f-e658-4822-8f07-57f2d5af9a08', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c111-q", "text": "How might ROCE be tested?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c111-1", "text": "Variations:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c111-2", "type": "numberList", "items": ["Average Capital Employed: Use (Opening + Closing Capital Employed) ÷ 2 2. Combined Question: Calculate with Return on Equity, Return on Proprietors'' Fund 3. Missing Figure: \"ROCE is 20%, Capital Employed ₹10,00,000. Find EBIT\" 4. Trend Analysis: Calculate for multiple years"]}, {"id": "amd-u2-c111-3", "type": "numberList", "items": ["Comparison: Compare ROCE with Return on Equity to assess leverage effect"]}, {"id": "amd-u2-c111-4", "type": "numberList", "items": ["RETURN ON PROPRIETOR''S FUND"]}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('2902c3fa-ae2d-45a6-833d-fc9ac6153561', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What is Return on Proprietor''s Fund?', '', 'Return on Proprietor''s Fund (also called Return on Shareholders'' Fund or Return on Net Worth) measures the profitability earned on the total funds invested by owners (shareholders).

It indicates the return generated on proprietors'' investment. Purpose: Assess profitability from owners'' perspective.', NULL, NULL, NULL, 112, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '3cbfe74c-ae54-410c-9753-dd7b3c3cfc28', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c112-q", "text": "What is Return on Proprietor''s Fund?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c112-1", "text": "Return on Proprietor''s Fund (also called Return on Shareholders'' Fund or Return on Net Worth) measures the profitability earned on the total funds invested by owners (shareholders).", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c112-2", "text": "It indicates the return generated on proprietors'' investment. Purpose: Assess profitability from owners'' perspective.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('0e484924-90aa-4367-866d-f2e945fde386', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What is the formula for Return on Proprietor''s Fund?', '', 'Return on Proprietor''s Fund = (Net Profit Available to Shareholders ÷ Proprietors'' Fund) × 100

Where:

Net Profit Available to Shareholders = Net Profit After Tax − Preference Dividend (if any)

Proprietors'' Fund = Equity Share Capital + Preference Share Capital + Reserves & Surplus − Fictitious Assets

Expressed as: Percentage (%)

Note: Syllabus specifies including both Shareholders'' Fund and Preference Capital in

denominator.', NULL, NULL, NULL, 113, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '3cbfe74c-ae54-410c-9753-dd7b3c3cfc28', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c113-q", "text": "What is the formula for Return on Proprietor''s Fund?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c113-1", "type": "formula", "expression": "Return on Proprietor''s Fund = (Net Profit Available to Shareholders ÷ Proprietors'' Fund) × 100"}, {"id": "amd-u2-c113-2", "text": "Where:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c113-3", "type": "formula", "expression": "Net Profit Available to Shareholders = Net Profit After Tax − Preference Dividend (if any)"}, {"id": "amd-u2-c113-4", "type": "formula", "expression": "Proprietors'' Fund = Equity Share Capital + Preference Share Capital + Reserves & Surplus − Fictitious Assets"}, {"id": "amd-u2-c113-5", "text": "Expressed as: Percentage (%)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c113-6", "text": "Note: Syllabus specifies including both Shareholders'' Fund and Preference Capital in", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c113-7", "text": "denominator.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('b6e973df-e0de-4a62-841b-9bfa686dfdd8', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'What comprises Net Profit Available and Proprietors'' Fund?', '', 'Net Profit Available to Shareholders:

Net Profit After Tax

Less: Preference Dividend (if Preference Capital exists)

= Net Profit Available to Shareholders

(If no Preference Capital, Net Profit After Tax = Net Profit Available) Proprietors'' Fund (Shareholders'' Fund):

Equity Share Capital

+ Preference Share Capital

+ Reserves & Surplus (General Reserve, Capital Reserve, Securities Premium) + Retained Earnings (P&L Credit Balance)

- Fictitious Assets (Preliminary Expenses, P&L Debit Balance) = Proprietors'' Fund

Key Point: Includes both Equity and Preference Capital (unlike Return on Equity Capital).', NULL, NULL, NULL, 114, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '3cbfe74c-ae54-410c-9753-dd7b3c3cfc28', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c114-q", "text": "What comprises Net Profit Available and Proprietors'' Fund?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c114-1", "text": "Net Profit Available to Shareholders:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c114-2", "text": "Net Profit After Tax", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c114-3", "text": "Less: Preference Dividend (if Preference Capital exists)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c114-4", "type": "formula", "expression": "= Net Profit Available to Shareholders"}, {"id": "amd-u2-c114-5", "type": "formula", "expression": "(If no Preference Capital, Net Profit After Tax = Net Profit Available) Proprietors'' Fund (Shareholders'' Fund):"}, {"id": "amd-u2-c114-6", "text": "Equity Share Capital", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c114-7", "text": "+ Preference Share Capital", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c114-8", "text": "+ Reserves & Surplus (General Reserve, Capital Reserve, Securities Premium) + Retained Earnings (P&L Credit Balance)", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c114-9", "type": "formula", "expression": "- Fictitious Assets (Preliminary Expenses, P&L Debit Balance) = Proprietors'' Fund"}, {"id": "amd-u2-c114-10", "text": "Key Point: Includes both Equity and Preference Capital (unlike Return on Equity Capital).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('930bd707-5b3b-48c3-b0f9-6efe224ff390', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Book Value Method: worked example (illustrate with example).', 'Priority: Tier 1 | PYQ Connection: 2025 Q4.3 | PYQ Connection: 2025 Q4.3', 'Problem

Alpha Ltd''s balance sheet is as follows. Find the book value per share, and the adjusted book value per share after the adjustments given.

Liabilities | ₹ | Assets | ₹
Equity share capital (₹10 each) | 10,00,000 | Fixed assets (net) | 14,00,000
12% Preference share capital | 2,00,000 | Goodwill | 1,00,000
Reserves and surplus | 4,00,000 | Investments | 2,00,000
12% Debentures | 5,00,000 | Current assets | 7,00,000
Current liabilities | 3,00,000 |  | 
Total | 24,00,000 | Total | 24,00,000

Adjustments: fixed assets are worth ₹16,00,000; investments have a market value of ₹2,50,000; a provision of ₹50,000 is needed for doubtful debts.

Concept/Formula

Book value per share = Net worth ÷ Number of equity shares.

Given

Equity capital ₹10,00,000; face value ₹10 → shares = 10,00,000 ÷ 10 = 1,00,000.

Solution

Step 1 (liability side): Net worth = 10,00,000 + 4,00,000 = ₹14,00,000.
Step 2 (check from asset side): Total assets 24,00,000 − Outside liabilities (5,00,000 + 3,00,000 = 8,00,000) − Preference capital 2,00,000 = ₹14,00,000 ✓.
Step 3: Book value per share = 14,00,000 ÷ 1,00,000 = ₹14.00.
Step 4 (tangible book value, excluding goodwill): 14,00,000 − 1,00,000 = 13,00,000 → ₹13.00 per share.
Step 5 (adjusted book value): 14,00,000 + 2,00,000 (fixed assets up) + 50,000 (investments up) − 50,000 (provision) = ₹16,00,000 → ₹16.00 per share.

Final Answer

Book value = ₹14 per share. Adjusted book value = ₹16 per share.

(If the market price is ₹25, Price/Book = 25 ÷ 14 = 1.79 times.)

Exam tip

Always show both routes (liability side and asset side). They must give the same net worth, and that check is worth marks. State clearly whether goodwill is included.', NULL, NULL, NULL, 6, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'a6370687-af9d-43eb-9fe1-5cfd8e1ad30e', '{"blocks": [{"id": "equity-and-debt-markets-u4-c6-q", "text": "Book Value Method: worked example (illustrate with example).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c6-1", "bold": true, "text": "Problem", "type": "text", "style": "heading"}, {"id": "edm-u4-c6-2", "text": "Alpha Ltd''s balance sheet is as follows. Find the book value per share, and the adjusted book value per share after the adjustments given.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c6-3", "rows": [["Liabilities", "₹", "Assets", "₹"], ["Equity share capital (₹10 each)", "10,00,000", "Fixed assets (net)", "14,00,000"], ["12% Preference share capital", "2,00,000", "Goodwill", "1,00,000"], ["Reserves and surplus", "4,00,000", "Investments", "2,00,000"], ["12% Debentures", "5,00,000", "Current assets", "7,00,000"], ["Current liabilities", "3,00,000", "", ""], ["Total", "24,00,000", "Total", "24,00,000"]], "type": "table"}, {"id": "edm-u4-c6-4", "text": "Adjustments: fixed assets are worth ₹16,00,000; investments have a market value of ₹2,50,000; a provision of ₹50,000 is needed for doubtful debts.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c6-5", "bold": true, "text": "Concept/Formula", "type": "text", "style": "heading"}, {"id": "edm-u4-c6-6", "type": "formula", "expression": "Book value per share = Net worth ÷ Number of equity shares."}, {"id": "edm-u4-c6-7", "bold": true, "text": "Given", "type": "text", "style": "heading"}, {"id": "edm-u4-c6-8", "type": "formula", "expression": "Equity capital ₹10,00,000; face value ₹10 → shares = 10,00,000 ÷ 10 = 1,00,000."}, {"id": "edm-u4-c6-9", "bold": true, "text": "Solution", "type": "text", "style": "heading"}, {"id": "edm-u4-c6-10", "type": "bulletList", "items": ["Step 1 (liability side): Net worth = 10,00,000 + 4,00,000 = ₹14,00,000.", "Step 2 (check from asset side): Total assets 24,00,000 − Outside liabilities (5,00,000 + 3,00,000 = 8,00,000) − Preference capital 2,00,000 = ₹14,00,000 ✓.", "Step 3: Book value per share = 14,00,000 ÷ 1,00,000 = ₹14.00.", "Step 4 (tangible book value, excluding goodwill): 14,00,000 − 1,00,000 = 13,00,000 → ₹13.00 per share.", "Step 5 (adjusted book value): 14,00,000 + 2,00,000 (fixed assets up) + 50,000 (investments up) − 50,000 (provision) = ₹16,00,000 → ₹16.00 per share."]}, {"id": "edm-u4-c6-11", "bold": true, "text": "Final Answer", "type": "text", "style": "heading"}, {"id": "edm-u4-c6-12", "type": "formula", "expression": "Book value = ₹14 per share. Adjusted book value = ₹16 per share."}, {"id": "edm-u4-c6-13", "type": "formula", "expression": "(If the market price is ₹25, Price/Book = 25 ÷ 14 = 1.79 times.)"}, {"id": "edm-u4-c6-14", "bold": true, "text": "Exam tip", "type": "text", "style": "heading"}, {"id": "edm-u4-c6-15", "text": "Always show both routes (liability side and asset side). They must give the same net worth, and that check is worth marks. State clearly whether goodwill is included.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('d3a49670-00a9-41fa-a86b-3c8ed9a05033', 'bc3c8201-a885-45ea-a1e2-009a0714427d', 'flashcard', 'How is Return on Proprietor''s Fund calculated?', '', 'Steps:

Calculate Net Profit After Tax from Revenue Statement

Deduct Preference Dividend (if Preference Capital exists)

Calculate Proprietors'' Fund from Balance Sheet

Apply Formula = (Net Profit Available ÷ Proprietors'' Fund) × 100

Example:

Net Profit After Tax: ₹2,00,000

Preference Dividend (10% on ₹5,00,000): ₹50,000

Net Profit Available: ₹1,50,000', NULL, NULL, NULL, 115, true, 'University Exam', NULL, NULL, NULL, '656387b2-9ca5-4391-9851-1afee0c37958', '3cbfe74c-ae54-410c-9753-dd7b3c3cfc28', '{"blocks": [{"id": "accounting-for-managerial-decisions-u2-c115-q", "text": "How is Return on Proprietor''s Fund calculated?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "amd-u2-c115-1", "text": "Steps:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c115-2", "type": "numberList", "items": ["Calculate Net Profit After Tax from Revenue Statement"]}, {"id": "amd-u2-c115-3", "type": "numberList", "items": ["Deduct Preference Dividend (if Preference Capital exists)"]}, {"id": "amd-u2-c115-4", "type": "numberList", "items": ["Calculate Proprietors'' Fund from Balance Sheet"]}, {"id": "amd-u2-c115-5", "type": "numberList", "items": ["Apply Formula = (Net Profit Available ÷ Proprietors'' Fund) × 100"]}, {"id": "amd-u2-c115-6", "text": "Example:", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c115-7", "text": "Net Profit After Tax: ₹2,00,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c115-8", "text": "Preference Dividend (10% on ₹5,00,000): ₹50,000", "type": "text", "style": "paragraph"}, {"id": "amd-u2-c115-9", "text": "Net Profit Available: ₹1,50,000", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:56:34.614107+00', '2026-09-21 16:56:34.614107+00'),
('02bf0893-4645-4d6f-89c8-037c310654d0', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'What is Equity Valuation? Explain its meaning and importance.', 'Priority: Tier 1 | PYQ Connection: Oct 2024 Q4Q (8m) | PYQ Connection: Oct 2024 Q4Q (8m)', 'Meaning: Equity valuation is the process of estimating the intrinsic (true) value of a company''s equity share, or of its total equity, using its assets, dividends or earnings, and comparing it with the market price.
Values to distinguish: Face value (nominal ₹10/₹100), book value (net worth per share), intrinsic value (estimated worth) and market price (traded price).
Decision rule: Intrinsic value > market price means undervalued (buy). Intrinsic value < market price means overvalued (sell/avoid).
Importance:

Investment decisions (buy/hold/sell).
Pricing IPOs, rights issues and ESOPs.
Mergers, acquisitions and buybacks.
Portfolio and fund performance evaluation.
Taxation, lending against shares and legal disputes.
Assessing management performance and shareholder wealth.', NULL, NULL, NULL, 1, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'a6370687-af9d-43eb-9fe1-5cfd8e1ad30e', '{"blocks": [{"id": "equity-and-debt-markets-u4-c1-q", "text": "What is Equity Valuation? Explain its meaning and importance.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c1-1", "type": "bulletList", "items": ["Meaning: Equity valuation is the process of estimating the intrinsic (true) value of a company''s equity share, or of its total equity, using its assets, dividends or earnings, and comparing it with the market price.", "Values to distinguish: Face value (nominal ₹10/₹100), book value (net worth per share), intrinsic value (estimated worth) and market price (traded price).", "Decision rule: Intrinsic value > market price means undervalued (buy). Intrinsic value < market price means overvalued (sell/avoid).", "Importance:"]}, {"id": "edm-u4-c1-2", "type": "numberList", "items": ["Investment decisions (buy/hold/sell).", "Pricing IPOs, rights issues and ESOPs.", "Mergers, acquisitions and buybacks.", "Portfolio and fund performance evaluation.", "Taxation, lending against shares and legal disputes.", "Assessing management performance and shareholder wealth."]}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('0e757637-f207-4e5f-93d2-29070c4cbcaa', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Explain the methods of Equity Valuation.', 'Priority: Tier 1 | PYQ Connection: Oct 2024 Q4Q ("methods"); 2025 Q4.1 and Q4.3 (individual methods) | PYQ Connection: Oct 2024 Q4Q ("methods"); 2025 Q4.1 and Q4.3 (individual methods)', 'Method | Basis | Core formula | Best used for
1. Balance Sheet (Book Value / NAV) | Assets minus liabilities | Book value per share = Net worth ÷ No. of equity shares | Asset-heavy or liquidating firms
2. Dividend Discount Model (DDM) | Present value of future dividends | Zero growth: P₀ = D ÷ k. Constant growth: P₀ = D₁ ÷ (k − g). Multiple growth: PV of dividends in the high-growth phase + PV of terminal value | Dividend-paying, stable firms
3. Price Earnings (P/E) Model | Earnings and a market multiple | Value = EPS × P/E. Earnings approach: Value = Earnings ÷ k | Profitable firms with peers to compare

Link to the PYQ wording

"Dividend approach" = zero-growth DDM. "Dividend growth approach" = constant-growth DDM. "Earnings approach" = earnings capitalisation (P/E with P/E = 1/k).

(Other methods such as P/B, EV/EBITDA and free cash flow to equity exist in finance textbooks but are not in the current syllabus.)', NULL, NULL, NULL, 2, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'a6370687-af9d-43eb-9fe1-5cfd8e1ad30e', '{"blocks": [{"id": "equity-and-debt-markets-u4-c2-q", "text": "Explain the methods of Equity Valuation.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c2-1", "rows": [["Method", "Basis", "Core formula", "Best used for"], ["1. Balance Sheet (Book Value / NAV)", "Assets minus liabilities", "Book value per share = Net worth ÷ No. of equity shares", "Asset-heavy or liquidating firms"], ["2. Dividend Discount Model (DDM)", "Present value of future dividends", "Zero growth: P₀ = D ÷ k. Constant growth: P₀ = D₁ ÷ (k − g). Multiple growth: PV of dividends in the high-growth phase + PV of terminal value", "Dividend-paying, stable firms"], ["3. Price Earnings (P/E) Model", "Earnings and a market multiple", "Value = EPS × P/E. Earnings approach: Value = Earnings ÷ k", "Profitable firms with peers to compare"]], "type": "table"}, {"id": "edm-u4-c2-2", "bold": true, "text": "Link to the PYQ wording", "type": "text", "style": "heading"}, {"id": "edm-u4-c2-3", "type": "formula", "expression": "\"Dividend approach\" = zero-growth DDM. \"Dividend growth approach\" = constant-growth DDM. \"Earnings approach\" = earnings capitalisation (P/E with P/E = 1/k)."}, {"id": "edm-u4-c2-4", "text": "(Other methods such as P/B, EV/EBITDA and free cash flow to equity exist in finance textbooks but are not in the current syllabus.)", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('2f15ec66-d1de-4428-8a06-d5c720f3da9a', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Discuss the factors affecting Equity Valuation.', 'Priority: Tier 1 | PYQ Connection: Oct 2024 Q4Q ("factors") | PYQ Connection: Oct 2024 Q4Q ("factors")', 'Company-specific factors

Earnings (EPS) and profitability: higher and more stable earnings raise value.
Dividend policy: amount, regularity and growth of dividends.
Growth prospects: expected growth in sales and earnings.
Quality of management and governance.
Capital structure: high debt raises financial risk.
Assets and net worth: book value and asset backing.
Business risk: competition and dependence on a few customers.

External factors

Required rate of return (k): a higher k lowers value. It depends on the risk-free rate and the risk premium.
Interest rates: higher rates make bonds more attractive and reduce equity values.
Economic conditions and inflation.
Industry outlook and regulations/government policy.
Market sentiment, liquidity and global cues.

Exam tip: For 8 marks, give 8–10 factors with one-line explanations, split into "internal" and "external".', NULL, NULL, NULL, 3, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'a6370687-af9d-43eb-9fe1-5cfd8e1ad30e', '{"blocks": [{"id": "equity-and-debt-markets-u4-c3-q", "text": "Discuss the factors affecting Equity Valuation.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c3-1", "text": "Company-specific factors", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c3-2", "type": "numberList", "items": ["Earnings (EPS) and profitability: higher and more stable earnings raise value.", "Dividend policy: amount, regularity and growth of dividends.", "Growth prospects: expected growth in sales and earnings.", "Quality of management and governance.", "Capital structure: high debt raises financial risk.", "Assets and net worth: book value and asset backing.", "Business risk: competition and dependence on a few customers."]}, {"id": "edm-u4-c3-3", "text": "External factors", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c3-4", "type": "numberList", "items": ["Required rate of return (k): a higher k lowers value. It depends on the risk-free rate and the risk premium.", "Interest rates: higher rates make bonds more attractive and reduce equity values.", "Economic conditions and inflation.", "Industry outlook and regulations/government policy.", "Market sentiment, liquidity and global cues."]}, {"id": "edm-u4-c3-5", "text": "Exam tip: For 8 marks, give 8–10 factors with one-line explanations, split into \"internal\" and \"external\".", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('9cb2bf05-7796-4594-9b58-22e4be20f70d', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'What is Balance Sheet Valuation? What are its variants?', 'Priority: Tier 1 | PYQ Connection: 2025 Q4.3 (7.5m) | PYQ Connection: 2025 Q4.3 (7.5m)', 'Meaning: A method that values equity from the balance sheet, treating the value of equity as what remains for shareholders after all outside liabilities and preference capital are met. It is asset-based.
Variants:

Book Value Method: uses figures exactly as in the balance sheet (historical cost).
Adjusted Book Value / Net Asset Value (NAV): assets are revalued to current values before deducting liabilities.
Liquidation Value: what shareholders would receive if assets were sold off and liabilities paid.
Replacement Cost Value: the cost of rebuilding the assets today.

Basic formula: Value of equity = Total (real) assets − Outside liabilities − Preference share capital.
Per share: ÷ number of equity shares.', NULL, NULL, NULL, 4, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'a6370687-af9d-43eb-9fe1-5cfd8e1ad30e', '{"blocks": [{"id": "equity-and-debt-markets-u4-c4-q", "text": "What is Balance Sheet Valuation? What are its variants?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c4-1", "type": "bulletList", "items": ["Meaning: A method that values equity from the balance sheet, treating the value of equity as what remains for shareholders after all outside liabilities and preference capital are met. It is asset-based.", "Variants:"]}, {"id": "edm-u4-c4-2", "type": "numberList", "items": ["Book Value Method: uses figures exactly as in the balance sheet (historical cost).", "Adjusted Book Value / Net Asset Value (NAV): assets are revalued to current values before deducting liabilities.", "Liquidation Value: what shareholders would receive if assets were sold off and liabilities paid.", "Replacement Cost Value: the cost of rebuilding the assets today."]}, {"id": "edm-u4-c4-3", "type": "bulletList", "items": ["Basic formula: Value of equity = Total (real) assets − Outside liabilities − Preference share capital.", "Per share: ÷ number of equity shares."]}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('91e427dc-60e1-41f7-a672-0440534ba7f7', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Merits and limitations of the Book Value Method.', 'Priority: Tier 2 | PYQ Connection: 2025 Q4.3 (usual add-on to "illustrate") | PYQ Connection: 2025 Q4.3 (usual add-on to "illustrate")', 'Merits: Simple and objective, since the data come from audited financials. Useful for asset-heavy firms (banks, real estate, manufacturing). Provides a floor value. Easy to compare across firms.
Limitations: Uses historical cost, so it ignores current market values. Ignores earning power, goodwill and growth. Intangibles (brands, patents) are missing or understated. Accounting policies (depreciation, inventory) distort it. Poor guide for service and technology firms.', NULL, NULL, NULL, 8, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'a6370687-af9d-43eb-9fe1-5cfd8e1ad30e', '{"blocks": [{"id": "equity-and-debt-markets-u4-c8-q", "text": "Merits and limitations of the Book Value Method.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c8-1", "type": "bulletList", "items": ["Merits: Simple and objective, since the data come from audited financials. Useful for asset-heavy firms (banks, real estate, manufacturing). Provides a floor value. Easy to compare across firms.", "Limitations: Uses historical cost, so it ignores current market values. Ignores earning power, goodwill and growth. Intangibles (brands, patents) are missing or understated. Accounting policies (depreciation, inventory) distort it. Poor guide for service and technology firms."]}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('02795cbc-4f62-40c4-bbc2-ed00e40e8747', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'What is the Dividend Discount Model (DDM)? Explain its concept and assumptions.', 'Priority: Tier 1 | PYQ Connection: Oct 2024 Q4A (Dividend and Dividend Growth approaches) | PYQ Connection: Oct 2024 Q4A (Dividend and Dividend Growth approaches)', 'Meaning: DDM values a share as the present value of all expected future dividends, discounted at the shareholder''s required rate of return.
General formula: P₀ = D₁/(1+k) + D₂/(1+k)² + D₃/(1+k)³ + … (to infinity)
Variables:
P₀ = intrinsic value today
D₀ = dividend just paid (last year''s dividend)
D₁ = dividend expected next year (D₁ = D₀ × (1 + g))
k = required rate of return (cost of equity)
g = expected dividend growth rate
Assumptions: Dividends are the only cash flow to shareholders. The company is a going concern. k is constant. Dividends can be forecast. k > g (for constant growth).
Three versions: Zero growth, constant growth and multiple growth (Cards 10–12).
When suitable: Regular dividend-paying, mature companies. Not suitable for companies that pay no dividends.', NULL, NULL, NULL, 9, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'a6370687-af9d-43eb-9fe1-5cfd8e1ad30e', '{"blocks": [{"id": "equity-and-debt-markets-u4-c9-q", "text": "What is the Dividend Discount Model (DDM)? Explain its concept and assumptions.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c9-1", "type": "bulletList", "items": ["Meaning: DDM values a share as the present value of all expected future dividends, discounted at the shareholder''s required rate of return.", "General formula: P₀ = D₁/(1+k) + D₂/(1+k)² + D₃/(1+k)³ + … (to infinity)", "Variables:", "P₀ = intrinsic value today", "D₀ = dividend just paid (last year''s dividend)", "D₁ = dividend expected next year (D₁ = D₀ × (1 + g))", "k = required rate of return (cost of equity)", "g = expected dividend growth rate", "Assumptions: Dividends are the only cash flow to shareholders. The company is a going concern. k is constant. Dividends can be forecast. k > g (for constant growth).", "Three versions: Zero growth, constant growth and multiple growth (Cards 10–12).", "When suitable: Regular dividend-paying, mature companies. Not suitable for companies that pay no dividends."]}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('fad6f1cc-6e7c-43e3-8630-6812bc312146', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Zero Growth Model (Dividend Approach): formula and use.', 'Priority: Tier 1 | PYQ Connection: Oct 2024 Q4A(a) "Dividend Approach" | PYQ Connection: Oct 2024 Q4A(a) "Dividend Approach"', 'Formula: P₀ = D ÷ k
Meaning: Dividends stay constant forever (g = 0), so the share is a perpetuity, like a preference share.
Use when: Dividends are stable and no growth is expected.
Steps: (1) Find the annual dividend (D = dividend % × paid-up capital, or DPS = % × face value). (2) Convert k to a decimal. (3) Divide.
Example: D = ₹6 per share, k = 12% → P₀ = 6 ÷ 0.12 = ₹50.
Reverse use: k = D ÷ P₀ (an implied return).
Limitations: Unrealistic, since most companies'' dividends change. It gives the lowest value of the three models when growth is positive.', NULL, NULL, NULL, 10, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'a6370687-af9d-43eb-9fe1-5cfd8e1ad30e', '{"blocks": [{"id": "equity-and-debt-markets-u4-c10-q", "text": "Zero Growth Model (Dividend Approach): formula and use.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c10-1", "type": "bulletList", "items": ["Formula: P₀ = D ÷ k", "Meaning: Dividends stay constant forever (g = 0), so the share is a perpetuity, like a preference share.", "Use when: Dividends are stable and no growth is expected.", "Steps: (1) Find the annual dividend (D = dividend % × paid-up capital, or DPS = % × face value). (2) Convert k to a decimal. (3) Divide.", "Example: D = ₹6 per share, k = 12% → P₀ = 6 ÷ 0.12 = ₹50.", "Reverse use: k = D ÷ P₀ (an implied return).", "Limitations: Unrealistic, since most companies'' dividends change. It gives the lowest value of the three models when growth is positive."]}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('b7faf953-f3b1-468c-a51b-119e2ce766da', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Constant Growth Model (Gordon Model / Dividend Growth Approach).', 'Priority: Tier 1 | PYQ Connection: Oct 2024 Q4A(b) "Dividend Growth Approach" | PYQ Connection: Oct 2024 Q4A(b) "Dividend Growth Approach"', 'Formula: P₀ = D₁ ÷ (k − g), where D₁ = D₀ × (1 + g)
Meaning: Dividends grow at a constant rate g forever.
Conditions: k must be greater than g. The company should be stable and mature.
Estimating g: g = Retention ratio (b) × Return on equity (ROE).
Implied return: k = (D₁ ÷ P₀) + g, that is, dividend yield + capital gains yield.
Steps: (1) Find D₀. (2) Compute D₁ = D₀(1+g). (3) Compute k − g. (4) Divide.
Example: D₀ = ₹4, g = 6%, k = 14%. D₁ = 4 × 1.06 = ₹4.24. P₀ = 4.24 ÷ (0.14 − 0.06) = 4.24 ÷ 0.08 = ₹53.
Check: Dividend yield 4.24 ÷ 53 = 8%. Adding g = 6% gives k = 14% ✓.
Big trap: If the question says the dividend was paid last year (D₀), you must first grow it to D₁. Using D₀ directly (4 ÷ 0.08 = ₹50) is wrong.', NULL, NULL, NULL, 11, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'a6370687-af9d-43eb-9fe1-5cfd8e1ad30e', '{"blocks": [{"id": "equity-and-debt-markets-u4-c11-q", "text": "Constant Growth Model (Gordon Model / Dividend Growth Approach).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c11-1", "type": "bulletList", "items": ["Formula: P₀ = D₁ ÷ (k − g), where D₁ = D₀ × (1 + g)", "Meaning: Dividends grow at a constant rate g forever.", "Conditions: k must be greater than g. The company should be stable and mature.", "Estimating g: g = Retention ratio (b) × Return on equity (ROE).", "Implied return: k = (D₁ ÷ P₀) + g, that is, dividend yield + capital gains yield.", "Steps: (1) Find D₀. (2) Compute D₁ = D₀(1+g). (3) Compute k − g. (4) Divide.", "Example: D₀ = ₹4, g = 6%, k = 14%. D₁ = 4 × 1.06 = ₹4.24. P₀ = 4.24 ÷ (0.14 − 0.06) = 4.24 ÷ 0.08 = ₹53.", "Check: Dividend yield 4.24 ÷ 53 = 8%. Adding g = 6% gives k = 14% ✓.", "Big trap: If the question says the dividend was paid last year (D₀), you must first grow it to D₁. Using D₀ directly (4 ÷ 0.08 = ₹50) is wrong."]}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('84fe9d09-4ee3-4bdb-9aa5-7ebe39d14c6b', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Multiple (Multi-stage) Growth Model.', 'Priority: Tier 3 | PYQ Connection: Syllabus only (not asked in the supplied papers) | PYQ Connection: Syllabus only (not asked in the supplied papers)', 'Meaning: Dividends grow at a high rate (g₁) for a limited period (n years), and then at a stable, lower rate (g₂) forever.
Formula:
P₀ = Σ [D₀(1+g₁)ᵗ ÷ (1+k)ᵗ] for t = 1 to n + [Pₙ ÷ (1+k)ⁿ]
where Pₙ = Dₙ₊₁ ÷ (k − g₂) and Dₙ₊₁ = Dₙ × (1 + g₂)
Use when: A firm has a period of supernormal growth followed by maturity.
Steps:

Forecast dividends for years 1 to n at g₁.
Compute Dₙ₊₁ = Dₙ × (1 + g₂).
Compute terminal value Pₙ = Dₙ₊₁ ÷ (k − g₂).
Discount each dividend and Pₙ back to today.
Add them up.

Numerical example: D₀ = ₹2. Growth = 20% for 3 years, then 6% forever. k = 12%.

Year | Dividend (₹) | PV factor at 12% | PV (₹)
1 | 2 × 1.20 = 2.400 | 0.8929 | 2.14
2 | 2.400 × 1.20 = 2.880 | 0.7972 | 2.30
3 | 2.880 × 1.20 = 3.456 | 0.7118 | 2.46
Terminal value P₃ | D₄ = 3.456 × 1.06 = 3.66336; P₃ = 3.66336 ÷ (0.12 − 0.06) = 61.056 | 0.7118 | 43.46
Total |  |  | ≈ ₹50.36

Final Answer

P₀ ≈ ₹50.36.

Exam tip

The terminal value is discounted using the factor for year n (here 3), not n + 1. Also remember k > g₂.', NULL, NULL, NULL, 12, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'a6370687-af9d-43eb-9fe1-5cfd8e1ad30e', '{"blocks": [{"id": "equity-and-debt-markets-u4-c12-q", "text": "Multiple (Multi-stage) Growth Model.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c12-1", "type": "bulletList", "items": ["Meaning: Dividends grow at a high rate (g₁) for a limited period (n years), and then at a stable, lower rate (g₂) forever.", "Formula:", "P₀ = Σ [D₀(1+g₁)ᵗ ÷ (1+k)ᵗ] for t = 1 to n + [Pₙ ÷ (1+k)ⁿ]", "where Pₙ = Dₙ₊₁ ÷ (k − g₂) and Dₙ₊₁ = Dₙ × (1 + g₂)", "Use when: A firm has a period of supernormal growth followed by maturity.", "Steps:"]}, {"id": "edm-u4-c12-2", "type": "numberList", "items": ["Forecast dividends for years 1 to n at g₁.", "Compute Dₙ₊₁ = Dₙ × (1 + g₂).", "Compute terminal value Pₙ = Dₙ₊₁ ÷ (k − g₂).", "Discount each dividend and Pₙ back to today.", "Add them up."]}, {"id": "edm-u4-c12-3", "type": "bulletList", "items": ["Numerical example: D₀ = ₹2. Growth = 20% for 3 years, then 6% forever. k = 12%."]}, {"id": "edm-u4-c12-4", "rows": [["Year", "Dividend (₹)", "PV factor at 12%", "PV (₹)"], ["1", "2 × 1.20 = 2.400", "0.8929", "2.14"], ["2", "2.400 × 1.20 = 2.880", "0.7972", "2.30"], ["3", "2.880 × 1.20 = 3.456", "0.7118", "2.46"], ["Terminal value P₃", "D₄ = 3.456 × 1.06 = 3.66336; P₃ = 3.66336 ÷ (0.12 − 0.06) = 61.056", "0.7118", "43.46"], ["Total", "", "", "≈ ₹50.36"]], "type": "table"}, {"id": "edm-u4-c12-5", "bold": true, "text": "Final Answer", "type": "text", "style": "heading"}, {"id": "edm-u4-c12-6", "text": "P₀ ≈ ₹50.36.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c12-7", "bold": true, "text": "Exam tip", "type": "text", "style": "heading"}, {"id": "edm-u4-c12-8", "text": "The terminal value is discounted using the factor for year n (here 3), not n + 1. Also remember k > g₂.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('7f448501-f4dd-4836-abfd-9edd6d072b27', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Compare the three Dividend Discount Models.', 'Priority: Tier 2 | PYQ Connection: Oct 2024 Q4A (three approaches compared) | PYQ Connection: Oct 2024 Q4A (three approaches compared)', 'Basis | Zero Growth | Constant Growth | Multiple Growth
Growth assumption | g = 0 | Constant g forever | High g for n years, then lower g
Formula | D ÷ k | D₁ ÷ (k − g) | PV of stage-1 dividends + PV of terminal value
Condition | None special | k > g | k > g₂
Suitable for | Preference-like, very stable payers | Mature, stable companies | Growing firms that will mature
Complexity | Very simple | Simple | Longer calculation
Weakness | Ignores growth | Very sensitive to k − g | Needs several forecasts', NULL, NULL, NULL, 13, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'a6370687-af9d-43eb-9fe1-5cfd8e1ad30e', '{"blocks": [{"id": "equity-and-debt-markets-u4-c13-q", "text": "Compare the three Dividend Discount Models.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c13-1", "rows": [["Basis", "Zero Growth", "Constant Growth", "Multiple Growth"], ["Growth assumption", "g = 0", "Constant g forever", "High g for n years, then lower g"], ["Formula", "D ÷ k", "D₁ ÷ (k − g)", "PV of stage-1 dividends + PV of terminal value"], ["Condition", "None special", "k > g", "k > g₂"], ["Suitable for", "Preference-like, very stable payers", "Mature, stable companies", "Growing firms that will mature"], ["Complexity", "Very simple", "Simple", "Longer calculation"], ["Weakness", "Ignores growth", "Very sensitive to k − g", "Needs several forecasts"]], "type": "table"}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('feaffed1-0825-45fb-ae1c-e867bf6a2408', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Numerical — Value of equity by Dividend, Dividend Growth and Earnings approach (Oct 2024 PYQ solved).', 'Priority: Tier 1 | PYQ Connection: Oct 2024 Q4A (10m) | PYQ Connection: Oct 2024 Q4A (10m)', 'Problem

ABC Ltd paid a dividend at 25% last year. Paid-up equity capital = ₹7,00,000. 12% preference share capital = ₹5,00,000. Net operating profit before interest and tax (EBIT) = ₹9,00,000. Tax rate = 25%. Expected growth = 5% p.a. Required rate of return = 10%. Calculate the value of equity by (a) Dividend approach, (b) Dividend growth approach, (c) Earnings approach.

Concept/Formula

(a) V = D ÷ k
(b) V = D₀(1 + g) ÷ (k − g)
(c) V = Earnings available to equity ÷ k, where Earnings = (EBIT − Interest) × (1 − t) − Preference dividend

Given

D% = 25% of paid-up capital ₹7,00,000. Preference capital ₹5,00,000 at 12%. EBIT ₹9,00,000. t = 25%. g = 5% = 0.05. k = 10% = 0.10. No debt or interest is mentioned.

Solution

(a) Dividend approach (zero growth)

Equity dividend (D₀) = 25% × 7,00,000 = ₹1,75,000
Value = 1,75,000 ÷ 0.10 = ₹17,50,000

(b) Dividend growth approach (constant growth)

D₁ = D₀ × (1 + g) = 1,75,000 × 1.05 = ₹1,83,750
k − g = 0.10 − 0.05 = 0.05
Value = 1,83,750 ÷ 0.05 = ₹36,75,000

(c) Earnings approach

EBIT = 9,00,000. Interest = nil, so EBT = 9,00,000
Tax at 25% = 2,25,000 → PAT = ₹6,75,000
Preference dividend = 12% × 5,00,000 = ₹60,000 (deducted after tax)
Earnings available to equity = 6,75,000 − 60,000 = ₹6,15,000
Value = 6,15,000 ÷ 0.10 = ₹61,50,000

Final Answer

(a) ₹17,50,000 (b) ₹36,75,000 (c) ₹61,50,000

Interpretation

The dividend approach gives the lowest value because it ignores growth and retained earnings. The dividend growth approach adds growth. The earnings approach gives the highest value because it capitalises all earnings available to equity, not just the dividend paid.

If face value is ₹10 (optional per-share values)

Shares = 7,00,000 ÷ 10 = 70,000. (a) 17,50,000 ÷ 70,000 = ₹25.00. (b) 36,75,000 ÷ 70,000 = ₹52.50. (c) 6,15,000 ÷ 70,000 = EPS ₹8.79; value = 61,50,000 ÷ 70,000 = ₹87.86.

Exam tip

The 5% growth in (b) applies to the dividend, so first find D₁. Do not use the 12% preference rate as the discount rate. Preference dividend is not tax-deductible, so it is subtracted after tax. State that you assume no debt because no interest is given.', NULL, NULL, NULL, 14, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'a6370687-af9d-43eb-9fe1-5cfd8e1ad30e', '{"blocks": [{"id": "equity-and-debt-markets-u4-c14-q", "text": "Numerical — Value of equity by Dividend, Dividend Growth and Earnings approach (Oct 2024 PYQ solved).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c14-1", "bold": true, "text": "Problem", "type": "text", "style": "heading"}, {"id": "edm-u4-c14-2", "text": "ABC Ltd paid a dividend at 25% last year. Paid-up equity capital = ₹7,00,000. 12% preference share capital = ₹5,00,000. Net operating profit before interest and tax (EBIT) = ₹9,00,000. Tax rate = 25%. Expected growth = 5% p.a. Required rate of return = 10%. Calculate the value of equity by (a) Dividend approach, (b) Dividend growth approach, (c) Earnings approach.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c14-3", "bold": true, "text": "Concept/Formula", "type": "text", "style": "heading"}, {"id": "edm-u4-c14-4", "type": "bulletList", "items": ["(a) V = D ÷ k", "(b) V = D₀(1 + g) ÷ (k − g)", "(c) V = Earnings available to equity ÷ k, where Earnings = (EBIT − Interest) × (1 − t) − Preference dividend"]}, {"id": "edm-u4-c14-5", "bold": true, "text": "Given", "type": "text", "style": "heading"}, {"id": "edm-u4-c14-6", "type": "formula", "expression": "D% = 25% of paid-up capital ₹7,00,000. Preference capital ₹5,00,000 at 12%. EBIT ₹9,00,000. t = 25%. g = 5% = 0.05. k = 10% = 0.10. No debt or interest is mentioned."}, {"id": "edm-u4-c14-7", "bold": true, "text": "Solution", "type": "text", "style": "heading"}, {"id": "edm-u4-c14-8", "text": "(a) Dividend approach (zero growth)", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c14-9", "type": "bulletList", "items": ["Equity dividend (D₀) = 25% × 7,00,000 = ₹1,75,000", "Value = 1,75,000 ÷ 0.10 = ₹17,50,000"]}, {"id": "edm-u4-c14-10", "text": "(b) Dividend growth approach (constant growth)", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c14-11", "type": "bulletList", "items": ["D₁ = D₀ × (1 + g) = 1,75,000 × 1.05 = ₹1,83,750", "k − g = 0.10 − 0.05 = 0.05", "Value = 1,83,750 ÷ 0.05 = ₹36,75,000"]}, {"id": "edm-u4-c14-12", "text": "(c) Earnings approach", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c14-13", "type": "bulletList", "items": ["EBIT = 9,00,000. Interest = nil, so EBT = 9,00,000", "Tax at 25% = 2,25,000 → PAT = ₹6,75,000", "Preference dividend = 12% × 5,00,000 = ₹60,000 (deducted after tax)", "Earnings available to equity = 6,75,000 − 60,000 = ₹6,15,000", "Value = 6,15,000 ÷ 0.10 = ₹61,50,000"]}, {"id": "edm-u4-c14-14", "bold": true, "text": "Final Answer", "type": "text", "style": "heading"}, {"id": "edm-u4-c14-15", "text": "(a) ₹17,50,000 (b) ₹36,75,000 (c) ₹61,50,000", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c14-16", "bold": true, "text": "Interpretation", "type": "text", "style": "heading"}, {"id": "edm-u4-c14-17", "text": "The dividend approach gives the lowest value because it ignores growth and retained earnings. The dividend growth approach adds growth. The earnings approach gives the highest value because it capitalises all earnings available to equity, not just the dividend paid.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c14-18", "bold": true, "text": "If face value is ₹10 (optional per-share values)", "type": "text", "style": "heading"}, {"id": "edm-u4-c14-19", "type": "formula", "expression": "Shares = 7,00,000 ÷ 10 = 70,000. (a) 17,50,000 ÷ 70,000 = ₹25.00. (b) 36,75,000 ÷ 70,000 = ₹52.50. (c) 6,15,000 ÷ 70,000 = EPS ₹8.79; value = 61,50,000 ÷ 70,000 = ₹87.86."}, {"id": "edm-u4-c14-20", "bold": true, "text": "Exam tip", "type": "text", "style": "heading"}, {"id": "edm-u4-c14-21", "text": "The 5% growth in (b) applies to the dividend, so first find D₁. Do not use the 12% preference rate as the discount rate. Preference dividend is not tax-deductible, so it is subtracted after tax. State that you assume no debt because no interest is given.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('d2159926-fe58-41b4-9144-c27a9df481b1', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'DDM numerical variations (how the same concept can be tested differently).', 'Priority: Tier 2 | PYQ Connection: Variations of Oct 2024 Q4A | PYQ Connection: Variations of Oct 2024 Q4A', 'Variation 1: implied required return. Share price ₹53, D₁ = ₹4.24, g = 6%. k = 4.24 ÷ 53 + 0.06 = 0.08 + 0.06 = 14%.

Variation 2: growth from retention. EPS = ₹10, payout = 60%, ROE = 15%, k = 14%.

D₀ = 0.60 × 10 = ₹6. Retention b = 40%. g = b × ROE = 0.40 × 0.15 = 6%.
D₁ = 6 × 1.06 = ₹6.36. P₀ = 6.36 ÷ (0.14 − 0.06) = 6.36 ÷ 0.08 = ₹79.50.

Variation 3: dividend given as a percentage of face value. Dividend 25% on FV ₹10 → DPS = ₹2.50. With k = 10%: zero growth value = 2.50 ÷ 0.10 = ₹25. With g = 5%: 2.50 × 1.05 ÷ 0.05 = ₹52.50.

Variation 4: "next year''s dividend" is given. If the problem says the dividend expected next year is ₹1,75,000, use it directly as D₁: 1,75,000 ÷ (0.10 − 0.05) = ₹35,00,000. No further growth step.

Variation 5: compare value and price. If the intrinsic value is ₹52.50 and the market price is ₹45, the share is undervalued (buy). If the market price is ₹60, it is overvalued.

Common errors

Using D₀ in place of D₁. Forgetting k > g. Mixing percentages and decimals (10 vs 0.10). Using the preference rate as k.', NULL, NULL, NULL, 15, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'a6370687-af9d-43eb-9fe1-5cfd8e1ad30e', '{"blocks": [{"id": "equity-and-debt-markets-u4-c15-q", "text": "DDM numerical variations (how the same concept can be tested differently).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c15-1", "type": "formula", "expression": "Variation 1: implied required return. Share price ₹53, D₁ = ₹4.24, g = 6%. k = 4.24 ÷ 53 + 0.06 = 0.08 + 0.06 = 14%."}, {"id": "edm-u4-c15-2", "type": "formula", "expression": "Variation 2: growth from retention. EPS = ₹10, payout = 60%, ROE = 15%, k = 14%."}, {"id": "edm-u4-c15-3", "type": "bulletList", "items": ["D₀ = 0.60 × 10 = ₹6. Retention b = 40%. g = b × ROE = 0.40 × 0.15 = 6%.", "D₁ = 6 × 1.06 = ₹6.36. P₀ = 6.36 ÷ (0.14 − 0.06) = 6.36 ÷ 0.08 = ₹79.50."]}, {"id": "edm-u4-c15-4", "type": "formula", "expression": "Variation 3: dividend given as a percentage of face value. Dividend 25% on FV ₹10 → DPS = ₹2.50. With k = 10%: zero growth value = 2.50 ÷ 0.10 = ₹25. With g = 5%: 2.50 × 1.05 ÷ 0.05 = ₹52.50."}, {"id": "edm-u4-c15-5", "type": "formula", "expression": "Variation 4: \"next year''s dividend\" is given. If the problem says the dividend expected next year is ₹1,75,000, use it directly as D₁: 1,75,000 ÷ (0.10 − 0.05) = ₹35,00,000. No further growth step."}, {"id": "edm-u4-c15-6", "text": "Variation 5: compare value and price. If the intrinsic value is ₹52.50 and the market price is ₹45, the share is undervalued (buy). If the market price is ₹60, it is overvalued.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c15-7", "bold": true, "text": "Common errors", "type": "text", "style": "heading"}, {"id": "edm-u4-c15-8", "text": "Using D₀ in place of D₁. Forgetting k > g. Mixing percentages and decimals (10 vs 0.10). Using the preference rate as k.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('cef37fac-3f80-4eef-b61c-c1a3d1f7140a', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'What is EPS? Explain its meaning, formula and interpretation.', 'Priority: Tier 2 | PYQ Connection: Syllabus "Simple Numerical on EPS"; feeds 2025 Q4.1 | PYQ Connection: Syllabus "Simple Numerical on EPS"; feeds 2025 Q4.1', 'Meaning: Earnings Per Share is the profit earned for each equity share.
Formula: EPS = (Net profit after tax − Preference dividend) ÷ Number of equity shares
Weighted average number of shares is used if shares were issued during the year.
Interpretation: A higher EPS means better profitability per share. A rising EPS over time signals growth. It should be compared with the same company''s history and with similar firms.
Types: Basic EPS and Diluted EPS (which includes convertible securities and options).
Limitations: Ignores the capital employed. Can be affected by accounting policies. Does not show cash flows or dividend payout.
Relation to P/E: P/E = Market price ÷ EPS, and Price = EPS × P/E (Card 21).', NULL, NULL, NULL, 16, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'a6370687-af9d-43eb-9fe1-5cfd8e1ad30e', '{"blocks": [{"id": "equity-and-debt-markets-u4-c16-q", "text": "What is EPS? Explain its meaning, formula and interpretation.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c16-1", "type": "bulletList", "items": ["Meaning: Earnings Per Share is the profit earned for each equity share.", "Formula: EPS = (Net profit after tax − Preference dividend) ÷ Number of equity shares", "Weighted average number of shares is used if shares were issued during the year.", "Interpretation: A higher EPS means better profitability per share. A rising EPS over time signals growth. It should be compared with the same company''s history and with similar firms.", "Types: Basic EPS and Diluted EPS (which includes convertible securities and options).", "Limitations: Ignores the capital employed. Can be affected by accounting policies. Does not show cash flows or dividend payout.", "Relation to P/E: P/E = Market price ÷ EPS, and Price = EPS × P/E (Card 21)."]}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('6aac9407-c6df-497d-890d-44e3c4ed4879', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'EPS numerical (simple and weighted-average).', 'Priority: Tier 2 | PYQ Connection: Syllabus "Simple Numerical on EPS and P/E Ratio" | PYQ Connection: Syllabus "Simple Numerical on EPS and P/E Ratio"', 'Problem 1

PAT = ₹9,00,000. Preference dividend = ₹1,00,000. Equity shares = 2,00,000. Market price = ₹60. Industry P/E = 18. Find EPS, P/E and the value based on the industry P/E.

Concept/Formula

EPS = (PAT − Pref. dividend) ÷ Shares. P/E = Price ÷ EPS. Value = EPS × Industry P/E.

Solution

Earnings for equity = 9,00,000 − 1,00,000 = ₹8,00,000
EPS = 8,00,000 ÷ 2,00,000 = ₹4
P/E = 60 ÷ 4 = 15 times
Earnings yield = 4 ÷ 60 = 6.67%
Value at industry P/E = 4 × 18 = ₹72. Since 72 > 60, the share appears undervalued.

Problem 2 (weighted shares)

A company had 1,00,000 equity shares on 1 April and issued 20,000 more on 1 January (financial year ending 31 March). Earnings available to equity = ₹10,50,000.

Weighted average shares = 1,00,000 + 20,000 × (3/12) = 1,05,000
EPS = 10,50,000 ÷ 1,05,000 = ₹10

Final Answer

Problem 1: EPS ₹4, P/E 15, value ₹72. Problem 2: EPS ₹10.

Exam tip

Deduct preference dividend before dividing. Use the number of shares, not the capital in rupees. For shares issued during the year, weight them by the fraction of the year outstanding.', NULL, NULL, NULL, 17, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'a6370687-af9d-43eb-9fe1-5cfd8e1ad30e', '{"blocks": [{"id": "equity-and-debt-markets-u4-c17-q", "text": "EPS numerical (simple and weighted-average).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c17-1", "bold": true, "text": "Problem 1", "type": "text", "style": "heading"}, {"id": "edm-u4-c17-2", "type": "formula", "expression": "PAT = ₹9,00,000. Preference dividend = ₹1,00,000. Equity shares = 2,00,000. Market price = ₹60. Industry P/E = 18. Find EPS, P/E and the value based on the industry P/E."}, {"id": "edm-u4-c17-3", "bold": true, "text": "Concept/Formula", "type": "text", "style": "heading"}, {"id": "edm-u4-c17-4", "type": "formula", "expression": "EPS = (PAT − Pref. dividend) ÷ Shares. P/E = Price ÷ EPS. Value = EPS × Industry P/E."}, {"id": "edm-u4-c17-5", "bold": true, "text": "Solution", "type": "text", "style": "heading"}, {"id": "edm-u4-c17-6", "type": "bulletList", "items": ["Earnings for equity = 9,00,000 − 1,00,000 = ₹8,00,000", "EPS = 8,00,000 ÷ 2,00,000 = ₹4", "P/E = 60 ÷ 4 = 15 times", "Earnings yield = 4 ÷ 60 = 6.67%", "Value at industry P/E = 4 × 18 = ₹72. Since 72 > 60, the share appears undervalued."]}, {"id": "edm-u4-c17-7", "bold": true, "text": "Problem 2 (weighted shares)", "type": "text", "style": "heading"}, {"id": "edm-u4-c17-8", "type": "formula", "expression": "A company had 1,00,000 equity shares on 1 April and issued 20,000 more on 1 January (financial year ending 31 March). Earnings available to equity = ₹10,50,000."}, {"id": "edm-u4-c17-9", "type": "bulletList", "items": ["Weighted average shares = 1,00,000 + 20,000 × (3/12) = 1,05,000", "EPS = 10,50,000 ÷ 1,05,000 = ₹10"]}, {"id": "edm-u4-c17-10", "bold": true, "text": "Final Answer", "type": "text", "style": "heading"}, {"id": "edm-u4-c17-11", "text": "Problem 1: EPS ₹4, P/E 15, value ₹72. Problem 2: EPS ₹10.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c17-12", "bold": true, "text": "Exam tip", "type": "text", "style": "heading"}, {"id": "edm-u4-c17-13", "text": "Deduct preference dividend before dividing. Use the number of shares, not the capital in rupees. For shares issued during the year, weight them by the fraction of the year outstanding.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('fa42c28d-0b9e-4a33-b720-3da0a4c17f9a', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'What is the P/E Ratio? Explain its meaning and interpretation.', 'Priority: Tier 1 | PYQ Connection: 2025 Q4.1 (7.5m) | PYQ Connection: 2025 Q4.1 (7.5m)', 'Meaning: The Price-Earnings ratio shows how many rupees investors are willing to pay for ₹1 of a company''s earnings.
Formula: P/E = Market price per share ÷ EPS (or Market capitalisation ÷ Net profit after tax).
Example: Price ₹150, EPS ₹10 → P/E = 15. Investors pay ₹15 for each ₹1 of earnings.
Types: Trailing P/E (uses the last 12 months'' EPS) and Forward P/E (uses expected EPS).
Interpretation:
High P/E: the market expects high growth, or the share may be overvalued.
Low P/E: may signal undervaluation, or low growth and high risk.
Earnings yield = EPS ÷ Price = 1 ÷ (P/E).
Caution: Compare P/E only within the same industry.', NULL, NULL, NULL, 18, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'a6370687-af9d-43eb-9fe1-5cfd8e1ad30e', '{"blocks": [{"id": "equity-and-debt-markets-u4-c18-q", "text": "What is the P/E Ratio? Explain its meaning and interpretation.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c18-1", "type": "bulletList", "items": ["Meaning: The Price-Earnings ratio shows how many rupees investors are willing to pay for ₹1 of a company''s earnings.", "Formula: P/E = Market price per share ÷ EPS (or Market capitalisation ÷ Net profit after tax).", "Example: Price ₹150, EPS ₹10 → P/E = 15. Investors pay ₹15 for each ₹1 of earnings.", "Types: Trailing P/E (uses the last 12 months'' EPS) and Forward P/E (uses expected EPS).", "Interpretation:", "High P/E: the market expects high growth, or the share may be overvalued.", "Low P/E: may signal undervaluation, or low growth and high risk.", "Earnings yield = EPS ÷ Price = 1 ÷ (P/E).", "Caution: Compare P/E only within the same industry."]}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('b47d4fdd-8536-4d03-818a-e6a06a3d2c8b', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Explain the P/E Ratio as a method of valuation of equity.', 'Priority: Tier 1 | PYQ Connection: 2025 Q4.1 (7.5m) | PYQ Connection: 2025 Q4.1 (7.5m)', 'Concept: Instead of estimating dividends, the value of a share is estimated by applying an appropriate P/E multiple to the company''s EPS.
Formula: Intrinsic value = EPS × Appropriate P/E multiple
Steps:

Compute EPS = (PAT − Preference dividend) ÷ Shares.
Choose the benchmark P/E (industry or peer average, the firm''s own historical P/E, or a forecast forward P/E).
Multiply EPS by the P/E to get the intrinsic value.
Compare with the market price: intrinsic > market = undervalued, intrinsic < market = overvalued.

Factors that determine the P/E multiple: Expected growth, risk, dividend payout, interest rates, quality and stability of earnings, industry and market sentiment.
Merits: Simple, quick and widely used. Based on earnings, which drive value. Easy comparison across firms.
Limitations: EPS can be manipulated by accounting policies. Meaningless for loss-making firms. Cyclical earnings distort the P/E. The right benchmark P/E is a matter of judgement. Ignores capital structure and cash flows.
Link to the earnings approach: With no growth, P/E = 1 ÷ k (Card 22).', NULL, NULL, NULL, 19, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'a6370687-af9d-43eb-9fe1-5cfd8e1ad30e', '{"blocks": [{"id": "equity-and-debt-markets-u4-c19-q", "text": "Explain the P/E Ratio as a method of valuation of equity.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c19-1", "type": "bulletList", "items": ["Concept: Instead of estimating dividends, the value of a share is estimated by applying an appropriate P/E multiple to the company''s EPS.", "Formula: Intrinsic value = EPS × Appropriate P/E multiple", "Steps:"]}, {"id": "edm-u4-c19-2", "type": "numberList", "items": ["Compute EPS = (PAT − Preference dividend) ÷ Shares.", "Choose the benchmark P/E (industry or peer average, the firm''s own historical P/E, or a forecast forward P/E).", "Multiply EPS by the P/E to get the intrinsic value.", "Compare with the market price: intrinsic > market = undervalued, intrinsic < market = overvalued."]}, {"id": "edm-u4-c19-3", "type": "bulletList", "items": ["Factors that determine the P/E multiple: Expected growth, risk, dividend payout, interest rates, quality and stability of earnings, industry and market sentiment.", "Merits: Simple, quick and widely used. Based on earnings, which drive value. Easy comparison across firms.", "Limitations: EPS can be manipulated by accounting policies. Meaningless for loss-making firms. Cyclical earnings distort the P/E. The right benchmark P/E is a matter of judgement. Ignores capital structure and cash flows.", "Link to the earnings approach: With no growth, P/E = 1 ÷ k (Card 22)."]}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('c95374de-c153-461f-bb51-5aad7f3cc827', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'P/E model numerical: valuation and variations.', 'Priority: Tier 2 | PYQ Connection: Syllabus; supports 2025 Q4.1 | PYQ Connection: Syllabus; supports 2025 Q4.1', 'Problem

PAT = ₹24,00,000. Preference dividend = ₹4,00,000. Equity shares = 4,00,000. Industry P/E = 16. Current market price = ₹95. Find the intrinsic value and comment on the valuation.

Concept/Formula

Value = EPS × Industry P/E.

Solution

Earnings for equity = 24,00,000 − 4,00,000 = ₹20,00,000
EPS = 20,00,000 ÷ 4,00,000 = ₹5
Intrinsic value = 5 × 16 = ₹80
The company''s own P/E = 95 ÷ 5 = 19 times. This is above the industry P/E of 16.

Final Answer

Intrinsic value = ₹80 per share. Market price ₹95 is higher, so the share appears overvalued.

Variations

Find EPS from price and P/E: Price ₹120, P/E 15 → EPS = 120 ÷ 15 = ₹8.
Target price with expected EPS: Expected EPS ₹6.50, P/E 16 → value = 6.5 × 16 = ₹104.
Total equity value: P/E 16 × Earnings for equity ₹20,00,000 = ₹3,20,00,000. Per share: 3,20,00,000 ÷ 4,00,000 = ₹80 ✓.
Find the required P/E: Price ₹75, EPS ₹5 → P/E = 15.

Exam tip

Always end with a one-line conclusion ("undervalued/overvalued"). The examiner looks for it.', NULL, NULL, NULL, 20, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'a6370687-af9d-43eb-9fe1-5cfd8e1ad30e', '{"blocks": [{"id": "equity-and-debt-markets-u4-c20-q", "text": "P/E model numerical: valuation and variations.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c20-1", "bold": true, "text": "Problem", "type": "text", "style": "heading"}, {"id": "edm-u4-c20-2", "type": "formula", "expression": "PAT = ₹24,00,000. Preference dividend = ₹4,00,000. Equity shares = 4,00,000. Industry P/E = 16. Current market price = ₹95. Find the intrinsic value and comment on the valuation."}, {"id": "edm-u4-c20-3", "bold": true, "text": "Concept/Formula", "type": "text", "style": "heading"}, {"id": "edm-u4-c20-4", "type": "formula", "expression": "Value = EPS × Industry P/E."}, {"id": "edm-u4-c20-5", "bold": true, "text": "Solution", "type": "text", "style": "heading"}, {"id": "edm-u4-c20-6", "type": "bulletList", "items": ["Earnings for equity = 24,00,000 − 4,00,000 = ₹20,00,000", "EPS = 20,00,000 ÷ 4,00,000 = ₹5", "Intrinsic value = 5 × 16 = ₹80", "The company''s own P/E = 95 ÷ 5 = 19 times. This is above the industry P/E of 16."]}, {"id": "edm-u4-c20-7", "bold": true, "text": "Final Answer", "type": "text", "style": "heading"}, {"id": "edm-u4-c20-8", "type": "formula", "expression": "Intrinsic value = ₹80 per share. Market price ₹95 is higher, so the share appears overvalued."}, {"id": "edm-u4-c20-9", "bold": true, "text": "Variations", "type": "text", "style": "heading"}, {"id": "edm-u4-c20-10", "type": "numberList", "items": ["Find EPS from price and P/E: Price ₹120, P/E 15 → EPS = 120 ÷ 15 = ₹8.", "Target price with expected EPS: Expected EPS ₹6.50, P/E 16 → value = 6.5 × 16 = ₹104.", "Total equity value: P/E 16 × Earnings for equity ₹20,00,000 = ₹3,20,00,000. Per share: 3,20,00,000 ÷ 4,00,000 = ₹80 ✓.", "Find the required P/E: Price ₹75, EPS ₹5 → P/E = 15."]}, {"id": "edm-u4-c20-11", "bold": true, "text": "Exam tip", "type": "text", "style": "heading"}, {"id": "edm-u4-c20-12", "text": "Always end with a one-line conclusion (\"undervalued/overvalued\"). The examiner looks for it.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('5b82536c-674d-400a-80bb-6675b31e449f', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Differentiate between EPS and P/E Ratio, and show how they are related.', 'Priority: Tier 2 | PYQ Connection: Syllabus "EPS" and "P/E Ratio"; 2025 Q4.1 | PYQ Connection: Syllabus "EPS" and "P/E Ratio"; 2025 Q4.1', 'Basis | EPS | P/E Ratio
Meaning | Profit per equity share | Price paid per ₹1 of EPS
Formula | (PAT − Pref. dividend) ÷ Shares | Market price ÷ EPS
Unit | ₹ per share | Times (a multiple)
Measures | Profitability | Market''s valuation and growth expectations
Depends on | Company''s earnings | Price (market sentiment) and EPS
Use | Assess performance | Judge whether a share is expensive or cheap

Relationships

Price = EPS × P/E, EPS = Price ÷ P/E and P/E = Price ÷ EPS.
Earnings yield = EPS ÷ Price = 1 ÷ (P/E).
Justified P/E (advanced): From the constant growth model, forward P/E = Payout ratio ÷ (k − g). Check: payout 60%, k = 14%, g = 6% → P/E = 0.6 ÷ 0.08 = 7.5. With D₁ = ₹6.36, E₁ = 10.6, and P₀ = ₹79.50, P₀ ÷ E₁ = 79.5 ÷ 10.6 = 7.5 ✓.', NULL, NULL, NULL, 21, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'a6370687-af9d-43eb-9fe1-5cfd8e1ad30e', '{"blocks": [{"id": "equity-and-debt-markets-u4-c21-q", "text": "Differentiate between EPS and P/E Ratio, and show how they are related.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c21-1", "rows": [["Basis", "EPS", "P/E Ratio"], ["Meaning", "Profit per equity share", "Price paid per ₹1 of EPS"], ["Formula", "(PAT − Pref. dividend) ÷ Shares", "Market price ÷ EPS"], ["Unit", "₹ per share", "Times (a multiple)"], ["Measures", "Profitability", "Market''s valuation and growth expectations"], ["Depends on", "Company''s earnings", "Price (market sentiment) and EPS"], ["Use", "Assess performance", "Judge whether a share is expensive or cheap"]], "type": "table"}, {"id": "edm-u4-c21-2", "bold": true, "text": "Relationships", "type": "text", "style": "heading"}, {"id": "edm-u4-c21-3", "type": "bulletList", "items": ["Price = EPS × P/E, EPS = Price ÷ P/E and P/E = Price ÷ EPS.", "Earnings yield = EPS ÷ Price = 1 ÷ (P/E).", "Justified P/E (advanced): From the constant growth model, forward P/E = Payout ratio ÷ (k − g). Check: payout 60%, k = 14%, g = 6% → P/E = 0.6 ÷ 0.08 = 7.5. With D₁ = ₹6.36, E₁ = 10.6, and P₀ = ₹79.50, P₀ ÷ E₁ = 79.5 ÷ 10.6 = 7.5 ✓."]}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('986822d3-ccdb-4e1b-ae79-b4b8ed795f74', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'What is the Earnings Approach (Earnings Capitalisation)? How is it related to P/E?', 'Priority: Tier 2 | PYQ Connection: Oct 2024 Q4A(c) "Earning Approach" | PYQ Connection: Oct 2024 Q4A(c) "Earning Approach"', 'Meaning: The value of equity is the capitalised value of the earnings available to equity shareholders, assuming those earnings stay constant.
Formula: Value of equity = Earnings available to equity ÷ k (per share: EPS ÷ k).
Link to P/E: Since P = EPS ÷ k, the implied P/E = 1 ÷ k. For k = 10%, P/E = 10.
Earnings available to equity: EBIT − Interest = EBT; EBT − Tax = PAT; PAT − Preference dividend = Earnings for equity.
When used: When earnings, rather than dividends, are the reliable basis (for example, a company with a low payout).

Numerical (with debt and interest)

EBIT ₹5,00,000. Interest ₹1,00,000. Tax rate 30%. Preference dividend ₹50,000. k = 12%.

EBT = 5,00,000 − 1,00,000 = 4,00,000
Tax = 30% × 4,00,000 = 1,20,000 → PAT = 2,80,000
Earnings for equity = 2,80,000 − 50,000 = ₹2,30,000
Value = 2,30,000 ÷ 0.12 = ₹19,16,667 (approx.)

Cross-check with Card 14, part (c), which had no interest: Earnings ₹6,15,000 ÷ 0.10 = ₹61,50,000.', NULL, NULL, NULL, 22, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'a6370687-af9d-43eb-9fe1-5cfd8e1ad30e', '{"blocks": [{"id": "equity-and-debt-markets-u4-c22-q", "text": "What is the Earnings Approach (Earnings Capitalisation)? How is it related to P/E?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c22-1", "type": "bulletList", "items": ["Meaning: The value of equity is the capitalised value of the earnings available to equity shareholders, assuming those earnings stay constant.", "Formula: Value of equity = Earnings available to equity ÷ k (per share: EPS ÷ k).", "Link to P/E: Since P = EPS ÷ k, the implied P/E = 1 ÷ k. For k = 10%, P/E = 10.", "Earnings available to equity: EBIT − Interest = EBT; EBT − Tax = PAT; PAT − Preference dividend = Earnings for equity.", "When used: When earnings, rather than dividends, are the reliable basis (for example, a company with a low payout)."]}, {"id": "edm-u4-c22-2", "bold": true, "text": "Numerical (with debt and interest)", "type": "text", "style": "heading"}, {"id": "edm-u4-c22-3", "type": "formula", "expression": "EBIT ₹5,00,000. Interest ₹1,00,000. Tax rate 30%. Preference dividend ₹50,000. k = 12%."}, {"id": "edm-u4-c22-4", "type": "bulletList", "items": ["EBT = 5,00,000 − 1,00,000 = 4,00,000", "Tax = 30% × 4,00,000 = 1,20,000 → PAT = 2,80,000", "Earnings for equity = 2,80,000 − 50,000 = ₹2,30,000", "Value = 2,30,000 ÷ 0.12 = ₹19,16,667 (approx.)"]}, {"id": "edm-u4-c22-5", "type": "formula", "expression": "Cross-check with Card 14, part (c), which had no interest: Earnings ₹6,15,000 ÷ 0.10 = ₹61,50,000."}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('f587c66f-5830-4c9d-bb8c-61e47466dc8d', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Numerical — Bond valuation (coupon, zero-coupon, perpetual, semi-annual).', 'Priority: Tier 2 | PYQ Connection: Supports Oct 2024 Q4B; syllabus "Determinants of the Value of Bonds" | PYQ Connection: Supports Oct 2024 Q4B; syllabus "Determinants of the Value of Bonds"', '(a) Coupon bond. Face value ₹1,000, coupon 10%, 5 years, required return 12%.

Formula: V = C × PVIFA(12%,5) + M × PVIF(12%,5)
C = 100. PVIFA(12%,5) = 3.6048. PVIF(12%,5) = 0.5674.
V = 100 × 3.6048 + 1,000 × 0.5674 = 360.48 + 567.40 = ₹927.88 ≈ ₹927.90
Year-wise check: 100 × (0.8929 + 0.7972 + 0.7118 + 0.6355 + 0.5674) = 360.48, plus 567.4 ✓. The bond sells at a discount because r (12%) > coupon (10%).

(b) Zero-coupon bond. Face value ₹1,000, 5 years, required return 10%.

V = 1,000 ÷ (1.10)⁵ = 1,000 × 0.6209 = ₹620.92

(c) Perpetual bond. Coupon ₹80 per year, required return 10%.

V = 80 ÷ 0.10 = ₹800

(d) Semi-annual coupons. Face value ₹1,000, 8% coupon paid half-yearly, 3 years, required return 10% p.a.

Per period: coupon = 40. Rate = 5%. Periods = 6.
PVIFA(5%,6) = 5.0757. PVIF(5%,6) = 0.7462.
V = 40 × 5.0757 + 1,000 × 0.7462 = 203.03 + 746.20 = ₹949.24 (approx.)

Exam tip

Check direction. When r > coupon rate, the value must be below face value. When r < coupon rate, it must be above. If your answer breaks this rule, you have made an error.', NULL, NULL, NULL, 26, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'ad766610-0fb2-46eb-8d3e-79013b3ff5c7', '{"blocks": [{"id": "equity-and-debt-markets-u4-c26-q", "text": "Numerical — Bond valuation (coupon, zero-coupon, perpetual, semi-annual).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c26-1", "text": "(a) Coupon bond. Face value ₹1,000, coupon 10%, 5 years, required return 12%.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c26-2", "type": "bulletList", "items": ["Formula: V = C × PVIFA(12%,5) + M × PVIF(12%,5)", "C = 100. PVIFA(12%,5) = 3.6048. PVIF(12%,5) = 0.5674.", "V = 100 × 3.6048 + 1,000 × 0.5674 = 360.48 + 567.40 = ₹927.88 ≈ ₹927.90", "Year-wise check: 100 × (0.8929 + 0.7972 + 0.7118 + 0.6355 + 0.5674) = 360.48, plus 567.4 ✓. The bond sells at a discount because r (12%) > coupon (10%)."]}, {"id": "edm-u4-c26-3", "text": "(b) Zero-coupon bond. Face value ₹1,000, 5 years, required return 10%.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c26-4", "type": "bulletList", "items": ["V = 1,000 ÷ (1.10)⁵ = 1,000 × 0.6209 = ₹620.92"]}, {"id": "edm-u4-c26-5", "text": "(c) Perpetual bond. Coupon ₹80 per year, required return 10%.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c26-6", "type": "bulletList", "items": ["V = 80 ÷ 0.10 = ₹800"]}, {"id": "edm-u4-c26-7", "text": "(d) Semi-annual coupons. Face value ₹1,000, 8% coupon paid half-yearly, 3 years, required return 10% p.a.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c26-8", "type": "bulletList", "items": ["Per period: coupon = 40. Rate = 5%. Periods = 6.", "PVIFA(5%,6) = 5.0757. PVIF(5%,6) = 0.7462.", "V = 40 × 5.0757 + 1,000 × 0.7462 = 203.03 + 746.20 = ₹949.24 (approx.)"]}, {"id": "edm-u4-c26-9", "bold": true, "text": "Exam tip", "type": "text", "style": "heading"}, {"id": "edm-u4-c26-10", "text": "Check direction. When r > coupon rate, the value must be below face value. When r < coupon rate, it must be above. If your answer breaks this rule, you have made an error.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('de2a9079-87db-45f0-9094-d66a41cd8608', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'What is Yield to Maturity (YTM)? Formula, method and interpretation.', 'Priority: Tier 1 | PYQ Connection: Oct 2024 Q4P-I (10m); 2025 Q4.2 | PYQ Connection: Oct 2024 Q4P-I (10m); 2025 Q4.2', 'Meaning: YTM is the annualised return an investor earns if the bond is bought at the current price, held till maturity, and all coupons and principal are received as promised (coupons reinvested at the YTM). It is the discount rate that equates the PV of all cash flows to the market price.
Exact formula: P = Σ [C ÷ (1+y)ᵗ] + F ÷ (1+y)ⁿ, solve for y.
Approximate formula: YTM ≈ [C + (F − P) ÷ n] ÷ [(F + P) ÷ 2]
C = annual coupon, F = face/redemption value, P = current price, n = years to maturity.
(Some textbooks use 0.4F + 0.6P as the denominator. Use whichever your class follows.)
Exact method (trial and error + interpolation):

Compute the approximate YTM as a starting point.
Choose two rates on either side (one gives a price above P, the other below).
Compute the bond price at each rate using PV tables.
Interpolate: YTM = r_low + [(P_low − P) ÷ (P_low − P_high)] × (r_high − r_low), where P_low is the price at the lower rate.

Interpretation:
Bond at discount → YTM > coupon rate.
Bond at premium → YTM < coupon rate.
Bond at par → YTM = coupon rate.
A higher YTM (for similar risk) means a better bond.
Limitations: Assumes no default, a hold-till-maturity approach and reinvestment at the same rate.', NULL, NULL, NULL, 27, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'ad766610-0fb2-46eb-8d3e-79013b3ff5c7', '{"blocks": [{"id": "equity-and-debt-markets-u4-c27-q", "text": "What is Yield to Maturity (YTM)? Formula, method and interpretation.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c27-1", "type": "bulletList", "items": ["Meaning: YTM is the annualised return an investor earns if the bond is bought at the current price, held till maturity, and all coupons and principal are received as promised (coupons reinvested at the YTM). It is the discount rate that equates the PV of all cash flows to the market price.", "Exact formula: P = Σ [C ÷ (1+y)ᵗ] + F ÷ (1+y)ⁿ, solve for y.", "Approximate formula: YTM ≈ [C + (F − P) ÷ n] ÷ [(F + P) ÷ 2]", "C = annual coupon, F = face/redemption value, P = current price, n = years to maturity.", "(Some textbooks use 0.4F + 0.6P as the denominator. Use whichever your class follows.)", "Exact method (trial and error + interpolation):"]}, {"id": "edm-u4-c27-2", "type": "numberList", "items": ["Compute the approximate YTM as a starting point.", "Choose two rates on either side (one gives a price above P, the other below).", "Compute the bond price at each rate using PV tables.", "Interpolate: YTM = r_low + [(P_low − P) ÷ (P_low − P_high)] × (r_high − r_low), where P_low is the price at the lower rate."]}, {"id": "edm-u4-c27-3", "type": "bulletList", "items": ["Interpretation:", "Bond at discount → YTM > coupon rate.", "Bond at premium → YTM < coupon rate.", "Bond at par → YTM = coupon rate.", "A higher YTM (for similar risk) means a better bond.", "Limitations: Assumes no default, a hold-till-maturity approach and reinvestment at the same rate."]}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('512b5d14-ae1a-4d33-aa36-306684166f4a', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Numerical — YTM of Bond A and Bond B (Oct 2024 PYQ solved).', 'Priority: Tier 1 | PYQ Connection: Oct 2024 Q4P-I (10m) | PYQ Connection: Oct 2024 Q4P-I (10m)', 'Problem

Face value ₹100. Bond A: coupon 12%, 10 years, price ₹88. Bond B: coupon 14%, 8 years, price ₹90. Calculate the YTM.

Concept/Formula

Approximate YTM = [C + (F − P)/n] ÷ [(F + P)/2]. Exact YTM by trial and error and interpolation.

Given

Bond A: C = 12, F = 100, P = 88, n = 10.
Bond B: C = 14, F = 100, P = 90, n = 8.

Solution — Bond A

Approximate YTM: Numerator = 12 + (100 − 88) ÷ 10 = 12 + 1.2 = 13.2. Denominator = (100 + 88) ÷ 2 = 94. YTM ≈ 13.2 ÷ 94 = 14.04%.
Exact YTM: try 14% and 15% (n = 10).
At 14%: PVIFA = 5.2161, PVIF = 0.2697. Price = 12 × 5.2161 + 100 × 0.2697 = 62.59 + 26.97 = 89.56 (above 88, so the rate is too low).
At 15%: PVIFA = 5.0188, PVIF = 0.2472. Price = 12 × 5.0188 + 100 × 0.2472 = 60.23 + 24.72 = 84.95 (below 88, so the rate is too high).
Interpolate: YTM = 14% + [(89.56 − 88) ÷ (89.56 − 84.95)] × 1% = 14% + (1.56 ÷ 4.61) × 1% = 14% + 0.34% = 14.34%.

Solution — Bond B

Approximate YTM: Numerator = 14 + (100 − 90) ÷ 8 = 14 + 1.25 = 15.25. Denominator = (100 + 90) ÷ 2 = 95. YTM ≈ 15.25 ÷ 95 = 16.05%.
Exact YTM: try 16% and 17% (n = 8).
At 16%: PVIFA = 4.3436, PVIF = 0.3050. Price = 14 × 4.3436 + 100 × 0.3050 = 60.81 + 30.50 = 91.31.
At 17%: PVIFA = 4.2072, PVIF = 0.2848. Price = 14 × 4.2072 + 100 × 0.2848 = 58.90 + 28.48 = 87.38.
Interpolate: YTM = 16% + [(91.31 − 90) ÷ (91.31 − 87.38)] × 1% = 16% + (1.31 ÷ 3.93) × 1% = 16% + 0.33% = 16.33%.

Final Answer

Bond | Approximate YTM | Exact YTM (interpolated)
A | 14.04% | ≈ 14.34%
B | 16.05% | ≈ 16.33%

Interpretation

Both bonds trade at a discount, so each YTM exceeds its coupon rate (14.34% > 12%, 16.33% > 14%) ✓. Bond B offers the higher yield, so (with similar credit risk) it is the better investment.

(If your class uses the 0.4F + 0.6P denominator: A = 13.2 ÷ 92.8 = 14.22%; B = 15.25 ÷ 94 = 16.22%.)

Exam tip

If the question says "calculate YTM" without asking for trial and error, the approximate formula is usually accepted. If PV tables are provided, show the interpolation for full marks.', NULL, NULL, NULL, 28, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'ad766610-0fb2-46eb-8d3e-79013b3ff5c7', '{"blocks": [{"id": "equity-and-debt-markets-u4-c28-q", "text": "Numerical — YTM of Bond A and Bond B (Oct 2024 PYQ solved).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c28-1", "bold": true, "text": "Problem", "type": "text", "style": "heading"}, {"id": "edm-u4-c28-2", "text": "Face value ₹100. Bond A: coupon 12%, 10 years, price ₹88. Bond B: coupon 14%, 8 years, price ₹90. Calculate the YTM.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c28-3", "bold": true, "text": "Concept/Formula", "type": "text", "style": "heading"}, {"id": "edm-u4-c28-4", "type": "formula", "expression": "Approximate YTM = [C + (F − P)/n] ÷ [(F + P)/2]. Exact YTM by trial and error and interpolation."}, {"id": "edm-u4-c28-5", "bold": true, "text": "Given", "type": "text", "style": "heading"}, {"id": "edm-u4-c28-6", "type": "bulletList", "items": ["Bond A: C = 12, F = 100, P = 88, n = 10.", "Bond B: C = 14, F = 100, P = 90, n = 8."]}, {"id": "edm-u4-c28-7", "text": "Solution — Bond A", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c28-8", "type": "bulletList", "items": ["Approximate YTM: Numerator = 12 + (100 − 88) ÷ 10 = 12 + 1.2 = 13.2. Denominator = (100 + 88) ÷ 2 = 94. YTM ≈ 13.2 ÷ 94 = 14.04%.", "Exact YTM: try 14% and 15% (n = 10).", "At 14%: PVIFA = 5.2161, PVIF = 0.2697. Price = 12 × 5.2161 + 100 × 0.2697 = 62.59 + 26.97 = 89.56 (above 88, so the rate is too low).", "At 15%: PVIFA = 5.0188, PVIF = 0.2472. Price = 12 × 5.0188 + 100 × 0.2472 = 60.23 + 24.72 = 84.95 (below 88, so the rate is too high).", "Interpolate: YTM = 14% + [(89.56 − 88) ÷ (89.56 − 84.95)] × 1% = 14% + (1.56 ÷ 4.61) × 1% = 14% + 0.34% = 14.34%."]}, {"id": "edm-u4-c28-9", "text": "Solution — Bond B", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c28-10", "type": "bulletList", "items": ["Approximate YTM: Numerator = 14 + (100 − 90) ÷ 8 = 14 + 1.25 = 15.25. Denominator = (100 + 90) ÷ 2 = 95. YTM ≈ 15.25 ÷ 95 = 16.05%.", "Exact YTM: try 16% and 17% (n = 8).", "At 16%: PVIFA = 4.3436, PVIF = 0.3050. Price = 14 × 4.3436 + 100 × 0.3050 = 60.81 + 30.50 = 91.31.", "At 17%: PVIFA = 4.2072, PVIF = 0.2848. Price = 14 × 4.2072 + 100 × 0.2848 = 58.90 + 28.48 = 87.38.", "Interpolate: YTM = 16% + [(91.31 − 90) ÷ (91.31 − 87.38)] × 1% = 16% + (1.31 ÷ 3.93) × 1% = 16% + 0.33% = 16.33%."]}, {"id": "edm-u4-c28-11", "bold": true, "text": "Final Answer", "type": "text", "style": "heading"}, {"id": "edm-u4-c28-12", "rows": [["Bond", "Approximate YTM", "Exact YTM (interpolated)"], ["A", "14.04%", "≈ 14.34%"], ["B", "16.05%", "≈ 16.33%"]], "type": "table"}, {"id": "edm-u4-c28-13", "bold": true, "text": "Interpretation", "type": "text", "style": "heading"}, {"id": "edm-u4-c28-14", "text": "Both bonds trade at a discount, so each YTM exceeds its coupon rate (14.34% > 12%, 16.33% > 14%) ✓. Bond B offers the higher yield, so (with similar credit risk) it is the better investment.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c28-15", "type": "formula", "expression": "(If your class uses the 0.4F + 0.6P denominator: A = 13.2 ÷ 92.8 = 14.22%; B = 15.25 ÷ 94 = 16.22%.)"}, {"id": "edm-u4-c28-16", "bold": true, "text": "Exam tip", "type": "text", "style": "heading"}, {"id": "edm-u4-c28-17", "text": "If the question says \"calculate YTM\" without asking for trial and error, the approximate formula is usually accepted. If PV tables are provided, show the interpolation for full marks.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('baca437d-737e-42dd-b7d5-4979d684d0b4', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Categorise the different variations of Yield to Maturity.', 'Priority: Tier 1 | PYQ Connection: 2025 Q4.2 (7.5m) | PYQ Connection: 2025 Q4.2 (7.5m)', '# | Variation | Meaning and formula
1 | Exact YTM (IRR of the bond) | The rate that equates PV of all cash flows to the price. Solved by trial and error/interpolation or calculator
2 | Approximate YTM | [C + (F − P)/n] ÷ [(F + P)/2]
3 | YTM of a zero-coupon bond | (F ÷ P)^(1/n) − 1
4 | YTM for semi-annual coupons | Semi-annual yield y_s from PV equation. Bond Equivalent Yield (BEY) = 2 × y_s. Effective Annual Yield (EAY) = (1 + y_s)² − 1
5 | Yield to Call (YTC) | Return if the bond is called at the call price on the first call date: P = Σ C/(1+y)ᵗ + Call price/(1+y)^n_call. Approx: [C + (CP − P)/n_c] ÷ [(CP + P)/2]
6 | Yield to Put (YTP) | Same logic, using the put price and put date
7 | Yield to Worst (YTW) | The lowest of YTM, YTC and YTP (the conservative yield)
8 | Realised (horizon) yield | Actual compound return when coupons are reinvested at a different rate and/or the bond is sold before maturity

Related but different

Current yield = Annual coupon ÷ Price (ignores capital gain/loss and time value; Card 31).

Exam tip: Present it as a classified table with one formula each, then one short line on when each is used.', NULL, NULL, NULL, 29, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'ad766610-0fb2-46eb-8d3e-79013b3ff5c7', '{"blocks": [{"id": "equity-and-debt-markets-u4-c29-q", "text": "Categorise the different variations of Yield to Maturity.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c29-1", "rows": [["#", "Variation", "Meaning and formula"], ["1", "Exact YTM (IRR of the bond)", "The rate that equates PV of all cash flows to the price. Solved by trial and error/interpolation or calculator"], ["2", "Approximate YTM", "[C + (F − P)/n] ÷ [(F + P)/2]"], ["3", "YTM of a zero-coupon bond", "(F ÷ P)^(1/n) − 1"], ["4", "YTM for semi-annual coupons", "Semi-annual yield y_s from PV equation. Bond Equivalent Yield (BEY) = 2 × y_s. Effective Annual Yield (EAY) = (1 + y_s)² − 1"], ["5", "Yield to Call (YTC)", "Return if the bond is called at the call price on the first call date: P = Σ C/(1+y)ᵗ + Call price/(1+y)^n_call. Approx: [C + (CP − P)/n_c] ÷ [(CP + P)/2]"], ["6", "Yield to Put (YTP)", "Same logic, using the put price and put date"], ["7", "Yield to Worst (YTW)", "The lowest of YTM, YTC and YTP (the conservative yield)"], ["8", "Realised (horizon) yield", "Actual compound return when coupons are reinvested at a different rate and/or the bond is sold before maturity"]], "type": "table"}, {"id": "edm-u4-c29-2", "bold": true, "text": "Related but different", "type": "text", "style": "heading"}, {"id": "edm-u4-c29-3", "type": "formula", "expression": "Current yield = Annual coupon ÷ Price (ignores capital gain/loss and time value; Card 31)."}, {"id": "edm-u4-c29-4", "text": "Exam tip: Present it as a classified table with one formula each, then one short line on when each is used.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('9ef91e84-5691-4b51-8336-383e7e0a64fb', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Numerical — YTM variations (zero-coupon, semi-annual, yield to call/worst).', 'Priority: Tier 2 | PYQ Connection: Supports 2025 Q4.2 | PYQ Connection: Supports 2025 Q4.2', '(a) Zero-coupon bond. Face value ₹1,000, price ₹600, 5 years.

YTM = (1,000 ÷ 600)^(1/5) − 1 = (1.6667)^0.2 − 1 = 1.1076 − 1 = 10.76%
Check: 1.1076⁵ ≈ 1.6669, and 600 × 1.6669 ≈ 1,000 ✓.

(b) Semi-annual yield conversion. Suppose the semi-annual YTM is 5%.

Bond Equivalent Yield = 2 × 5% = 10%
Effective Annual Yield = (1.05)² − 1 = 10.25%

(c) Yield to Call and Yield to Worst. Face value ₹1,000, coupon 10%, 10 years to maturity, callable after 5 years at ₹1,050, current price ₹1,100.

C = 100.
Approximate YTM = [100 + (1,000 − 1,100) ÷ 10] ÷ [(1,000 + 1,100) ÷ 2] = 90 ÷ 1,050 = 8.57%
Approximate YTC = [100 + (1,050 − 1,100) ÷ 5] ÷ [(1,050 + 1,100) ÷ 2] = 90 ÷ 1,075 = 8.37%
Yield to Worst = lower of the two = 8.37%

Final Answer

(a) 10.76% (b) BEY 10%, EAY 10.25% (c) YTM ≈ 8.57%, YTC ≈ 8.37%, YTW ≈ 8.37%.

Insight

A bond trading at a premium is likely to be called, so YTC < YTM, and the investor should look at the yield to worst.', NULL, NULL, NULL, 30, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'ad766610-0fb2-46eb-8d3e-79013b3ff5c7', '{"blocks": [{"id": "equity-and-debt-markets-u4-c30-q", "text": "Numerical — YTM variations (zero-coupon, semi-annual, yield to call/worst).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c30-1", "text": "(a) Zero-coupon bond. Face value ₹1,000, price ₹600, 5 years.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c30-2", "type": "bulletList", "items": ["YTM = (1,000 ÷ 600)^(1/5) − 1 = (1.6667)^0.2 − 1 = 1.1076 − 1 = 10.76%", "Check: 1.1076⁵ ≈ 1.6669, and 600 × 1.6669 ≈ 1,000 ✓."]}, {"id": "edm-u4-c30-3", "text": "(b) Semi-annual yield conversion. Suppose the semi-annual YTM is 5%.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c30-4", "type": "bulletList", "items": ["Bond Equivalent Yield = 2 × 5% = 10%", "Effective Annual Yield = (1.05)² − 1 = 10.25%"]}, {"id": "edm-u4-c30-5", "text": "(c) Yield to Call and Yield to Worst. Face value ₹1,000, coupon 10%, 10 years to maturity, callable after 5 years at ₹1,050, current price ₹1,100.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c30-6", "type": "bulletList", "items": ["C = 100.", "Approximate YTM = [100 + (1,000 − 1,100) ÷ 10] ÷ [(1,000 + 1,100) ÷ 2] = 90 ÷ 1,050 = 8.57%", "Approximate YTC = [100 + (1,050 − 1,100) ÷ 5] ÷ [(1,050 + 1,100) ÷ 2] = 90 ÷ 1,075 = 8.37%", "Yield to Worst = lower of the two = 8.37%"]}, {"id": "edm-u4-c30-7", "bold": true, "text": "Final Answer", "type": "text", "style": "heading"}, {"id": "edm-u4-c30-8", "text": "(a) 10.76% (b) BEY 10%, EAY 10.25% (c) YTM ≈ 8.57%, YTC ≈ 8.37%, YTW ≈ 8.37%.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c30-9", "bold": true, "text": "Insight", "type": "text", "style": "heading"}, {"id": "edm-u4-c30-10", "text": "A bond trading at a premium is likely to be called, so YTC < YTM, and the investor should look at the yield to worst.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('747217bb-a276-4a1e-bf69-1f5fd59ec7fd', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'What is Current Yield? Formula and interpretation.', 'Priority: Tier 2 | PYQ Connection: Syllabus "Current Yield of Bonds — Simple Numerical" | PYQ Connection: Syllabus "Current Yield of Bonds — Simple Numerical"', 'Meaning: Current yield is the annual coupon income as a percentage of the current market price. It measures the income return only.
Formula: Current Yield = (Annual coupon ÷ Current market price) × 100
Variables: Annual coupon = coupon rate × face value. Market price = today''s price (not the face value).
Interpretation: Shows the income an investor earns for the price paid. It ignores capital gain/loss on redemption and the time value of money.
When to use: A quick comparison of income across bonds. It is a good approximation for long-maturity or perpetual bonds.
Relationships:
Par bond: coupon rate = current yield = YTM.
Discount bond: coupon rate < current yield < YTM.
Premium bond: YTM < current yield < coupon rate.', NULL, NULL, NULL, 31, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'ad766610-0fb2-46eb-8d3e-79013b3ff5c7', '{"blocks": [{"id": "equity-and-debt-markets-u4-c31-q", "text": "What is Current Yield? Formula and interpretation.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c31-1", "type": "bulletList", "items": ["Meaning: Current yield is the annual coupon income as a percentage of the current market price. It measures the income return only.", "Formula: Current Yield = (Annual coupon ÷ Current market price) × 100", "Variables: Annual coupon = coupon rate × face value. Market price = today''s price (not the face value).", "Interpretation: Shows the income an investor earns for the price paid. It ignores capital gain/loss on redemption and the time value of money.", "When to use: A quick comparison of income across bonds. It is a good approximation for long-maturity or perpetual bonds.", "Relationships:", "Par bond: coupon rate = current yield = YTM.", "Discount bond: coupon rate < current yield < YTM.", "Premium bond: YTM < current yield < coupon rate."]}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('8550793e-bc45-467c-9ac7-99fe7d2511b8', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Numerical — Current Yield (and a typical variation).', 'Priority: Tier 2 | PYQ Connection: Syllabus; uses the Oct 2024 Q4P-I bonds | PYQ Connection: Syllabus; uses the Oct 2024 Q4P-I bonds', 'Problem 1

A ₹1,000 bond with a 9% coupon is trading at ₹900. Find the current yield.

Annual coupon = 9% × 1,000 = ₹90.
Current yield = 90 ÷ 900 × 100 = 10%.

Problem 2 (Oct 2024 bonds)

Face value ₹100.

Bond A: coupon ₹12, price ₹88 → CY = 12 ÷ 88 = 13.64%.
Bond B: coupon ₹14, price ₹90 → CY = 14 ÷ 90 = 15.56%.
Check of the ordering: A: 12% (coupon) < 13.64% (CY) < 14.34% (YTM) ✓. B: 14% < 15.56% < 16.33% ✓.

Problem 3 (reverse — find the price)

Coupon 9%, face value ₹1,000, required current yield 10%.

Price = Annual coupon ÷ CY = 90 ÷ 0.10 = ₹900.

Final Answer

10%; A 13.64% and B 15.56%; ₹900.

Common errors

Dividing by face value instead of market price. Using the coupon rate as the annual coupon in rupees. Mixing up current yield and YTM.', NULL, NULL, NULL, 32, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'ad766610-0fb2-46eb-8d3e-79013b3ff5c7', '{"blocks": [{"id": "equity-and-debt-markets-u4-c32-q", "text": "Numerical — Current Yield (and a typical variation).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c32-1", "bold": true, "text": "Problem 1", "type": "text", "style": "heading"}, {"id": "edm-u4-c32-2", "text": "A ₹1,000 bond with a 9% coupon is trading at ₹900. Find the current yield.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c32-3", "type": "bulletList", "items": ["Annual coupon = 9% × 1,000 = ₹90.", "Current yield = 90 ÷ 900 × 100 = 10%."]}, {"id": "edm-u4-c32-4", "bold": true, "text": "Problem 2 (Oct 2024 bonds)", "type": "text", "style": "heading"}, {"id": "edm-u4-c32-5", "text": "Face value ₹100.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c32-6", "type": "bulletList", "items": ["Bond A: coupon ₹12, price ₹88 → CY = 12 ÷ 88 = 13.64%.", "Bond B: coupon ₹14, price ₹90 → CY = 14 ÷ 90 = 15.56%.", "Check of the ordering: A: 12% (coupon) < 13.64% (CY) < 14.34% (YTM) ✓. B: 14% < 15.56% < 16.33% ✓."]}, {"id": "edm-u4-c32-7", "bold": true, "text": "Problem 3 (reverse — find the price)", "type": "text", "style": "heading"}, {"id": "edm-u4-c32-8", "text": "Coupon 9%, face value ₹1,000, required current yield 10%.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c32-9", "type": "bulletList", "items": ["Price = Annual coupon ÷ CY = 90 ÷ 0.10 = ₹900."]}, {"id": "edm-u4-c32-10", "bold": true, "text": "Final Answer", "type": "text", "style": "heading"}, {"id": "edm-u4-c32-11", "text": "10%; A 13.64% and B 15.56%; ₹900.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c32-12", "bold": true, "text": "Common errors", "type": "text", "style": "heading"}, {"id": "edm-u4-c32-13", "text": "Dividing by face value instead of market price. Using the coupon rate as the annual coupon in rupees. Mixing up current yield and YTM.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('270b3a89-5d59-480f-b6d4-1e1928bf015b', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Distinguish between Current Yield and Yield to Maturity.', 'Priority: Tier 2 | PYQ Connection: Syllabus (both listed); 2025 Q4.2 | PYQ Connection: Syllabus (both listed); 2025 Q4.2', 'Basis | Current Yield | Yield to Maturity
Meaning | Annual coupon ÷ current price | Total annualised return if held to maturity
Includes capital gain/loss | No | Yes (price to par at maturity)
Time value of money | Ignored | Considered
Maturity considered | No | Yes
Calculation | Very simple | Trial and error or approximate formula
Accuracy | Rough, income-only | More complete measure
Equality | Equals YTM only for a perpetual bond | —
Discount bond | CY < YTM | YTM highest
Premium bond | CY > YTM | YTM lowest', NULL, NULL, NULL, 33, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'ad766610-0fb2-46eb-8d3e-79013b3ff5c7', '{"blocks": [{"id": "equity-and-debt-markets-u4-c33-q", "text": "Distinguish between Current Yield and Yield to Maturity.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c33-1", "rows": [["Basis", "Current Yield", "Yield to Maturity"], ["Meaning", "Annual coupon ÷ current price", "Total annualised return if held to maturity"], ["Includes capital gain/loss", "No", "Yes (price to par at maturity)"], ["Time value of money", "Ignored", "Considered"], ["Maturity considered", "No", "Yes"], ["Calculation", "Very simple", "Trial and error or approximate formula"], ["Accuracy", "Rough, income-only", "More complete measure"], ["Equality", "Equals YTM only for a perpetual bond", "—"], ["Discount bond", "CY < YTM", "YTM highest"], ["Premium bond", "CY > YTM", "YTM lowest"]], "type": "table"}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('14de5400-02a2-4321-9d14-777173e58260', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'What is Interest Rate Risk? Explain its meaning, types and causes.', 'Priority: Tier 2 | PYQ Connection: Syllabus "Interest Rate Risk" | PYQ Connection: Syllabus "Interest Rate Risk"', 'Meaning: The risk that changes in market interest rates will change the value of a bond (or the return on reinvested coupons).
Two components:

Price risk: when rates rise, bond prices fall. An investor who sells before maturity may suffer a loss.
Reinvestment risk: when rates fall, coupons and maturity proceeds have to be reinvested at lower rates.

These two effects work in opposite directions.
Causes of rate changes:

Monetary policy (RBI''s repo rate changes).
Inflation expectations.
Government borrowing and the fiscal deficit.
Liquidity conditions.
Global interest-rate movements and capital flows.

Who is exposed most: Holders of long-maturity and low-coupon bonds who may need to sell before maturity.
Ways to manage: Shorter maturities, laddering (spreading maturities), floating-rate bonds, holding to maturity, and diversification.', NULL, NULL, NULL, 34, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'ad766610-0fb2-46eb-8d3e-79013b3ff5c7', '{"blocks": [{"id": "equity-and-debt-markets-u4-c34-q", "text": "What is Interest Rate Risk? Explain its meaning, types and causes.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c34-1", "type": "bulletList", "items": ["Meaning: The risk that changes in market interest rates will change the value of a bond (or the return on reinvested coupons).", "Two components:"]}, {"id": "edm-u4-c34-2", "type": "numberList", "items": ["Price risk: when rates rise, bond prices fall. An investor who sells before maturity may suffer a loss.", "Reinvestment risk: when rates fall, coupons and maturity proceeds have to be reinvested at lower rates."]}, {"id": "edm-u4-c34-3", "type": "bulletList", "items": ["These two effects work in opposite directions.", "Causes of rate changes:"]}, {"id": "edm-u4-c34-4", "type": "numberList", "items": ["Monetary policy (RBI''s repo rate changes).", "Inflation expectations.", "Government borrowing and the fiscal deficit.", "Liquidity conditions.", "Global interest-rate movements and capital flows."]}, {"id": "edm-u4-c34-5", "type": "bulletList", "items": ["Who is exposed most: Holders of long-maturity and low-coupon bonds who may need to sell before maturity.", "Ways to manage: Shorter maturities, laddering (spreading maturities), floating-rate bonds, holding to maturity, and diversification."]}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('ffb42cc4-dab5-4d9f-b8a6-33000ecc7ef6', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Explain the determinants of Interest Rate Risk.', 'Priority: Tier 2 | PYQ Connection: Syllabus "Determinants of Interest Rate Risk" | PYQ Connection: Syllabus "Determinants of Interest Rate Risk"', 'The price sensitivity of a bond to a given change in yield depends on:

Determinant | Effect | Reason
1. Time to maturity | Longer maturity → higher interest rate risk | Distant cash flows are discounted for more years, so a change in the rate compounds more
2. Coupon rate | Lower coupon → higher risk | More of the value comes from the distant principal; a zero-coupon bond is the most sensitive
3. Level of yields | Lower starting yields → higher sensitivity | The PV of far-off cash flows changes more when the base rate is low
4. Embedded options | Call feature limits price rise; put feature cushions falls | The option changes the effective life of the bond
5. Size of the rate change | Bigger change → bigger price move | Also asymmetric: a fall in rates raises prices more than an equal rise lowers them (convexity)
6. Ability to hold to maturity | Holding to maturity removes price risk | The face value is repaid regardless

Malkiel''s bond price theorems (a useful way to present this)

Bond prices move inversely with yields.
For a given yield change, longer-maturity bonds change more in price.
Sensitivity rises with maturity, but at a decreasing rate.
A yield fall raises the price more than an equal yield rise lowers it.
Lower-coupon bonds are more price-sensitive.

Numerical illustrations are in Card 37.', NULL, NULL, NULL, 35, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'ad766610-0fb2-46eb-8d3e-79013b3ff5c7', '{"blocks": [{"id": "equity-and-debt-markets-u4-c35-q", "text": "Explain the determinants of Interest Rate Risk.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c35-1", "text": "The price sensitivity of a bond to a given change in yield depends on:", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c35-2", "rows": [["Determinant", "Effect", "Reason"], ["1. Time to maturity", "Longer maturity → higher interest rate risk", "Distant cash flows are discounted for more years, so a change in the rate compounds more"], ["2. Coupon rate", "Lower coupon → higher risk", "More of the value comes from the distant principal; a zero-coupon bond is the most sensitive"], ["3. Level of yields", "Lower starting yields → higher sensitivity", "The PV of far-off cash flows changes more when the base rate is low"], ["4. Embedded options", "Call feature limits price rise; put feature cushions falls", "The option changes the effective life of the bond"], ["5. Size of the rate change", "Bigger change → bigger price move", "Also asymmetric: a fall in rates raises prices more than an equal rise lowers them (convexity)"], ["6. Ability to hold to maturity", "Holding to maturity removes price risk", "The face value is repaid regardless"]], "type": "table"}, {"id": "edm-u4-c35-3", "bold": true, "text": "Malkiel''s bond price theorems (a useful way to present this)", "type": "text", "style": "heading"}, {"id": "edm-u4-c35-4", "type": "numberList", "items": ["Bond prices move inversely with yields.", "For a given yield change, longer-maturity bonds change more in price.", "Sensitivity rises with maturity, but at a decreasing rate.", "A yield fall raises the price more than an equal yield rise lowers it.", "Lower-coupon bonds are more price-sensitive."]}, {"id": "edm-u4-c35-5", "text": "Numerical illustrations are in Card 37.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('1f77b90e-4ad7-4656-be95-0b39b6159892', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Explain the relationship between Bond Price and Interest Rate (with reasoning).', 'Priority: Tier 2 | PYQ Connection: Syllabus "Bond Price and Interest Rate Relationship" | PYQ Connection: Syllabus "Bond Price and Interest Rate Relationship"', 'The rule (inverse relationship)

When interest rates rise, bond prices fall.
When interest rates fall, bond prices rise.

Why (reasoning, not memorisation)

Fixed cash flows. An existing bond pays a fixed coupon and principal. Its cash flows do not change when market rates change.
Discounting. Bond price = PV of those cash flows at the market yield. If the discount rate rises, each rupee received in the future is worth less today, so the PV (price) falls. If the discount rate falls, the PV rises.
Competition from new bonds. Suppose you own a 8% bond and the market rate rises to 10%. New bonds pay 10%, so nobody will pay full price for your 8% bond. Its price must fall until the buyer''s return (YTM) reaches about 10%. If the market rate falls to 6%, your 8% bond is now attractive, and its price is bid up until the buyer''s return falls to about 6%.
Indian context: When the RBI raises the repo rate, G-sec yields tend to rise and bond prices fall. Rate cuts have the opposite effect.

Coupon rate vs yield and price status

Condition | Bond price | Status
Market yield (YTM) > coupon rate | Below face value | Discount
Market yield = coupon rate | Equal to face value | Par
Market yield < coupon rate | Above face value | Premium

Pull to par

Whatever the yield, the price converges to the face value as maturity nears, because the principal is repaid at par.

Quick numbers (5 years, 10% coupon, FV ₹1,000)

Yield 8% → price about ₹1,079.85. Yield 10% → ₹1,000. Yield 12% → about ₹927.90 (details in Card 37).', NULL, NULL, NULL, 36, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'ad766610-0fb2-46eb-8d3e-79013b3ff5c7', '{"blocks": [{"id": "equity-and-debt-markets-u4-c36-q", "text": "Explain the relationship between Bond Price and Interest Rate (with reasoning).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c36-1", "bold": true, "text": "The rule (inverse relationship)", "type": "text", "style": "heading"}, {"id": "edm-u4-c36-2", "type": "bulletList", "items": ["When interest rates rise, bond prices fall.", "When interest rates fall, bond prices rise."]}, {"id": "edm-u4-c36-3", "bold": true, "text": "Why (reasoning, not memorisation)", "type": "text", "style": "heading"}, {"id": "edm-u4-c36-4", "type": "numberList", "items": ["Fixed cash flows. An existing bond pays a fixed coupon and principal. Its cash flows do not change when market rates change.", "Discounting. Bond price = PV of those cash flows at the market yield. If the discount rate rises, each rupee received in the future is worth less today, so the PV (price) falls. If the discount rate falls, the PV rises.", "Competition from new bonds. Suppose you own a 8% bond and the market rate rises to 10%. New bonds pay 10%, so nobody will pay full price for your 8% bond. Its price must fall until the buyer''s return (YTM) reaches about 10%. If the market rate falls to 6%, your 8% bond is now attractive, and its price is bid up until the buyer''s return falls to about 6%.", "Indian context: When the RBI raises the repo rate, G-sec yields tend to rise and bond prices fall. Rate cuts have the opposite effect."]}, {"id": "edm-u4-c36-5", "bold": true, "text": "Coupon rate vs yield and price status", "type": "text", "style": "heading"}, {"id": "edm-u4-c36-6", "rows": [["Condition", "Bond price", "Status"], ["Market yield (YTM) > coupon rate", "Below face value", "Discount"], ["Market yield = coupon rate", "Equal to face value", "Par"], ["Market yield < coupon rate", "Above face value", "Premium"]], "type": "table"}, {"id": "edm-u4-c36-7", "bold": true, "text": "Pull to par", "type": "text", "style": "heading"}, {"id": "edm-u4-c36-8", "text": "Whatever the yield, the price converges to the face value as maturity nears, because the principal is repaid at par.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c36-9", "bold": true, "text": "Quick numbers (5 years, 10% coupon, FV ₹1,000)", "type": "text", "style": "heading"}, {"id": "edm-u4-c36-10", "text": "Yield 8% → price about ₹1,079.85. Yield 10% → ₹1,000. Yield 12% → about ₹927.90 (details in Card 37).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('23743eed-37f7-4b46-925d-9fdbd6c690a0', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Numerical — Bond price at different interest rates (maturity and coupon effects).', 'Priority: Tier 2 | PYQ Connection: Syllabus "Bond Price and Interest Rate Relationship" and "Determinants of Interest Rate Risk" | PYQ Connection: Syllabus "Bond Price and Interest Rate Relationship" and "Determinants of Interest Rate Risk"', 'Problem

A bond has face value ₹1,000 and a 10% coupon (₹100 per year). Show how its price changes when the market yield moves from 10% to 8% and 12%, for (a) 5 years, (b) 10 years to maturity. Then show the effect of the coupon rate.

Concept/Formula

Price = C × PVIFA(r,n) + M × PVIF(r,n).

Solution — (a) 5-year bond

At 10%: 100 × 3.7908 + 1,000 × 0.6209 = 379.08 + 620.92 = ₹1,000.00.
At 12%: 100 × 3.6048 + 1,000 × 0.5674 = 360.48 + 567.43 = ₹927.90. Change = −72.10 = −7.21%.
At 8%: 100 × 3.9927 + 1,000 × 0.6806 = 399.27 + 680.58 = ₹1,079.85. Change = +79.85 = +7.99%.

Solution — (b) 10-year bond

At 12%: 100 × 5.6502 + 1,000 × 0.3220 = 565.02 + 321.97 = ₹887.00. Change = −11.30%.
At 8%: 100 × 6.7101 + 1,000 × 0.4632 = 671.01 + 463.19 = ₹1,134.20. Change = +13.42%.

Solution — (c) coupon effect (5 years, yield rises from 10% to 12%)

Coupon | Price at 10% | Price at 12% | % change
4% | 40 × 3.7908 + 620.92 = ₹772.55 | 40 × 3.6048 + 567.43 = ₹711.62 | −7.89%
12% | 120 × 3.7908 + 620.92 = ₹1,075.82 | 120 × 3.6048 + 567.43 = ₹1,000.00 | −7.05%

Final Answer and interpretation

Inverse relationship: yield up → price down, yield down → price up.
Maturity effect: the 10-year bond moves by −11.30% and +13.42% against −7.21% and +7.99% for the 5-year bond. Longer maturity means higher interest rate risk.
Coupon effect: the 4% coupon bond falls by 7.89% against 7.05% for the 12% coupon bond. Lower coupon means higher interest rate risk.
Asymmetry (convexity): a fall in yield (+7.99%) raises the price more than an equal rise in yield (−7.21%) lowers it.

Exam tip

Always compare percentage changes, not rupee changes, when discussing risk.', NULL, NULL, NULL, 37, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'ad766610-0fb2-46eb-8d3e-79013b3ff5c7', '{"blocks": [{"id": "equity-and-debt-markets-u4-c37-q", "text": "Numerical — Bond price at different interest rates (maturity and coupon effects).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c37-1", "bold": true, "text": "Problem", "type": "text", "style": "heading"}, {"id": "edm-u4-c37-2", "text": "A bond has face value ₹1,000 and a 10% coupon (₹100 per year). Show how its price changes when the market yield moves from 10% to 8% and 12%, for (a) 5 years, (b) 10 years to maturity. Then show the effect of the coupon rate.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c37-3", "bold": true, "text": "Concept/Formula", "type": "text", "style": "heading"}, {"id": "edm-u4-c37-4", "type": "formula", "expression": "Price = C × PVIFA(r,n) + M × PVIF(r,n)."}, {"id": "edm-u4-c37-5", "text": "Solution — (a) 5-year bond", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c37-6", "type": "bulletList", "items": ["At 10%: 100 × 3.7908 + 1,000 × 0.6209 = 379.08 + 620.92 = ₹1,000.00.", "At 12%: 100 × 3.6048 + 1,000 × 0.5674 = 360.48 + 567.43 = ₹927.90. Change = −72.10 = −7.21%.", "At 8%: 100 × 3.9927 + 1,000 × 0.6806 = 399.27 + 680.58 = ₹1,079.85. Change = +79.85 = +7.99%."]}, {"id": "edm-u4-c37-7", "text": "Solution — (b) 10-year bond", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c37-8", "type": "bulletList", "items": ["At 12%: 100 × 5.6502 + 1,000 × 0.3220 = 565.02 + 321.97 = ₹887.00. Change = −11.30%.", "At 8%: 100 × 6.7101 + 1,000 × 0.4632 = 671.01 + 463.19 = ₹1,134.20. Change = +13.42%."]}, {"id": "edm-u4-c37-9", "text": "Solution — (c) coupon effect (5 years, yield rises from 10% to 12%)", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c37-10", "rows": [["Coupon", "Price at 10%", "Price at 12%", "% change"], ["4%", "40 × 3.7908 + 620.92 = ₹772.55", "40 × 3.6048 + 567.43 = ₹711.62", "−7.89%"], ["12%", "120 × 3.7908 + 620.92 = ₹1,075.82", "120 × 3.6048 + 567.43 = ₹1,000.00", "−7.05%"]], "type": "table"}, {"id": "edm-u4-c37-11", "bold": true, "text": "Final Answer and interpretation", "type": "text", "style": "heading"}, {"id": "edm-u4-c37-12", "type": "numberList", "items": ["Inverse relationship: yield up → price down, yield down → price up.", "Maturity effect: the 10-year bond moves by −11.30% and +13.42% against −7.21% and +7.99% for the 5-year bond. Longer maturity means higher interest rate risk.", "Coupon effect: the 4% coupon bond falls by 7.89% against 7.05% for the 12% coupon bond. Lower coupon means higher interest rate risk.", "Asymmetry (convexity): a fall in yield (+7.99%) raises the price more than an equal rise in yield (−7.21%) lowers it."]}, {"id": "edm-u4-c37-13", "bold": true, "text": "Exam tip", "type": "text", "style": "heading"}, {"id": "edm-u4-c37-14", "text": "Always compare percentage changes, not rupee changes, when discussing risk.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('8210dba7-22c5-4e48-80ae-09d4516aa521', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Bond Duration — HISTORICAL PYQ ONLY (not in the current Unit 4 syllabus).', 'Priority: Tier 4 (historical; do not treat as confirmed current syllabus) | PYQ Connection: Oct 2024 Q4P-II only | PYQ Connection: Oct 2024 Q4P-II only', 'Status

Duration appears in the older paper only and is not listed in the current Unit 4 syllabus. Interest Rate Risk and its determinants are listed, and duration is the standard single measure of that risk, so it can help you understand Cards 34–37. Prepare it only after Tiers 1–3, and check with your faculty whether it is still taught.

Meaning

Macaulay duration is the weighted average time (in years) to receive a bond''s cash flows, with weights equal to the present value of each cash flow. It measures price sensitivity to interest rate changes.

Formula

Duration = Σ [t × PV(CFₜ)] ÷ Σ PV(CFₜ), with PV taken at the given YTM.

(Modified duration = Macaulay duration ÷ (1 + y). Approx. % price change ≈ −Modified duration × Δy.)

Problem (Oct 2024 PYQ)

Face value ₹1,000. Market value ₹950. Coupon 12%. Maturity 7 years. YTM 10%. Redemption at par. Find the bond duration.

Given

Coupon = ₹120 per year. Final cash flow (year 7) = 120 + 1,000 = ₹1,120. y = 10%.

Solution

Year (t) | Cash flow (₹) | PV factor at 10% | PV (₹) | t × PV (₹)
1 | 120 | 0.9091 | 109.09 | 109.09
2 | 120 | 0.8264 | 99.17 | 198.35
3 | 120 | 0.7513 | 90.16 | 270.47
4 | 120 | 0.6830 | 81.96 | 327.85
5 | 120 | 0.6209 | 74.51 | 372.55
6 | 120 | 0.5645 | 67.74 | 406.42
7 | 1,120 | 0.5132 | 574.74 | 4,023.16
Total |  |  | 1,097.37 | 5,707.89

Duration = 5,707.89 ÷ 1,097.37 = 5.20 years
Modified duration = 5.20 ÷ 1.10 = 4.73. A 1% rise in yield lowers the price by about 4.73%.

Final Answer

Macaulay duration ≈ 5.20 years.

Data inconsistency in the PYQ

At a 10% YTM, this bond''s PV is ₹1,097.37, not ₹950. A price of ₹950 implies a YTM of about 13%. The weights must sum to 1, so divide by the PV of cash flows at the stated YTM. (Some solutions divide by ₹950 and get about 6.01 years. This is conceptually inconsistent, so state your assumption.)

Check with the closed-form formula

D = (1+y)/y − [(1+y) + n(c − y)] ÷ [c((1+y)ⁿ − 1) + y] = 11 − 1.24 ÷ 0.21385 = 11 − 5.7987 = 5.20 ✓.', NULL, NULL, NULL, 38, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', 'ad766610-0fb2-46eb-8d3e-79013b3ff5c7', '{"blocks": [{"id": "equity-and-debt-markets-u4-c38-q", "text": "Bond Duration — HISTORICAL PYQ ONLY (not in the current Unit 4 syllabus).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c38-1", "bold": true, "text": "Status", "type": "text", "style": "heading"}, {"id": "edm-u4-c38-2", "text": "Duration appears in the older paper only and is not listed in the current Unit 4 syllabus. Interest Rate Risk and its determinants are listed, and duration is the standard single measure of that risk, so it can help you understand Cards 34–37. Prepare it only after Tiers 1–3, and check with your faculty whether it is still taught.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c38-3", "bold": true, "text": "Meaning", "type": "text", "style": "heading"}, {"id": "edm-u4-c38-4", "text": "Macaulay duration is the weighted average time (in years) to receive a bond''s cash flows, with weights equal to the present value of each cash flow. It measures price sensitivity to interest rate changes.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c38-5", "bold": true, "text": "Formula", "type": "text", "style": "heading"}, {"id": "edm-u4-c38-6", "type": "formula", "expression": "Duration = Σ [t × PV(CFₜ)] ÷ Σ PV(CFₜ), with PV taken at the given YTM."}, {"id": "edm-u4-c38-7", "type": "formula", "expression": "(Modified duration = Macaulay duration ÷ (1 + y). Approx. % price change ≈ −Modified duration × Δy.)"}, {"id": "edm-u4-c38-8", "bold": true, "text": "Problem (Oct 2024 PYQ)", "type": "text", "style": "heading"}, {"id": "edm-u4-c38-9", "text": "Face value ₹1,000. Market value ₹950. Coupon 12%. Maturity 7 years. YTM 10%. Redemption at par. Find the bond duration.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c38-10", "bold": true, "text": "Given", "type": "text", "style": "heading"}, {"id": "edm-u4-c38-11", "type": "formula", "expression": "Coupon = ₹120 per year. Final cash flow (year 7) = 120 + 1,000 = ₹1,120. y = 10%."}, {"id": "edm-u4-c38-12", "bold": true, "text": "Solution", "type": "text", "style": "heading"}, {"id": "edm-u4-c38-13", "rows": [["Year (t)", "Cash flow (₹)", "PV factor at 10%", "PV (₹)", "t × PV (₹)"], ["1", "120", "0.9091", "109.09", "109.09"], ["2", "120", "0.8264", "99.17", "198.35"], ["3", "120", "0.7513", "90.16", "270.47"], ["4", "120", "0.6830", "81.96", "327.85"], ["5", "120", "0.6209", "74.51", "372.55"], ["6", "120", "0.5645", "67.74", "406.42"], ["7", "1,120", "0.5132", "574.74", "4,023.16"], ["Total", "", "", "1,097.37", "5,707.89"]], "type": "table"}, {"id": "edm-u4-c38-14", "type": "bulletList", "items": ["Duration = 5,707.89 ÷ 1,097.37 = 5.20 years", "Modified duration = 5.20 ÷ 1.10 = 4.73. A 1% rise in yield lowers the price by about 4.73%."]}, {"id": "edm-u4-c38-15", "bold": true, "text": "Final Answer", "type": "text", "style": "heading"}, {"id": "edm-u4-c38-16", "text": "Macaulay duration ≈ 5.20 years.", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c38-17", "bold": true, "text": "Data inconsistency in the PYQ", "type": "text", "style": "heading"}, {"id": "edm-u4-c38-18", "text": "At a 10% YTM, this bond''s PV is ₹1,097.37, not ₹950. A price of ₹950 implies a YTM of about 13%. The weights must sum to 1, so divide by the PV of cash flows at the stated YTM. (Some solutions divide by ₹950 and get about 6.01 years. This is conceptually inconsistent, so state your assumption.)", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c38-19", "bold": true, "text": "Check with the closed-form formula", "type": "text", "style": "heading"}, {"id": "edm-u4-c38-20", "type": "formula", "expression": "D = (1+y)/y − [(1+y) + n(c − y)] ÷ [c((1+y)ⁿ − 1) + y] = 11 − 1.24 ÷ 0.21385 = 11 − 5.7987 = 5.20 ✓."}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('c9881b36-059c-468e-b9c6-4b669fe55566', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Common errors in equity valuation numericals.', 'Priority: Tier 2 | PYQ Connection: Applies to Oct 2024 Q4A and 2025 Q4.1 and Q4.3 | PYQ Connection: Applies to Oct 2024 Q4A and 2025 Q4.1 and Q4.3', 'Using D₀ instead of D₁ in the constant growth model.
Forgetting the condition k > g.
Confusing percentages and decimals (10 vs 0.10).
In the earnings approach: deducting preference dividend before tax, not deducting it at all, or using EBIT instead of PAT.
Using the preference dividend rate as the discount rate.
In EPS: not deducting preference dividend, or using rupee share capital instead of the number of shares.
Not weighting new shares in EPS.
In book value: forgetting to deduct preference capital, including fictitious assets, or dividing by the wrong number of shares.
Discounting the terminal value with the wrong year in multi-stage DDM.
Not concluding "undervalued/overvalued" when the question asks for an interpretation.
Not stating assumptions (for example, "no debt as no interest is given").

Verification habits

Re-derive D₁ = D₀ × (1 + g). Check the implied k = D₁ ÷ P₀ + g. Check that net worth from both sides of the balance sheet agrees. Check that P/E × EPS returns the price.', NULL, NULL, NULL, 39, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', '93cf5196-ad2d-4a55-9ad1-650d0c374599', '{"blocks": [{"id": "equity-and-debt-markets-u4-c39-q", "text": "Common errors in equity valuation numericals.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c39-1", "type": "numberList", "items": ["Using D₀ instead of D₁ in the constant growth model.", "Forgetting the condition k > g.", "Confusing percentages and decimals (10 vs 0.10).", "In the earnings approach: deducting preference dividend before tax, not deducting it at all, or using EBIT instead of PAT.", "Using the preference dividend rate as the discount rate.", "In EPS: not deducting preference dividend, or using rupee share capital instead of the number of shares.", "Not weighting new shares in EPS.", "In book value: forgetting to deduct preference capital, including fictitious assets, or dividing by the wrong number of shares.", "Discounting the terminal value with the wrong year in multi-stage DDM.", "Not concluding \"undervalued/overvalued\" when the question asks for an interpretation.", "Not stating assumptions (for example, \"no debt as no interest is given\")."]}, {"id": "edm-u4-c39-2", "bold": true, "text": "Verification habits", "type": "text", "style": "heading"}, {"id": "edm-u4-c39-3", "type": "formula", "expression": "Re-derive D₁ = D₀ × (1 + g). Check the implied k = D₁ ÷ P₀ + g. Check that net worth from both sides of the balance sheet agrees. Check that P/E × EPS returns the price."}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('f61a59d1-2694-4d2f-862d-800552e1a13c', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Common errors in bond valuation numericals.', 'Priority: Tier 2 | PYQ Connection: Applies to Oct 2024 Q4P-I and Q4B | PYQ Connection: Applies to Oct 2024 Q4P-I and Q4B', 'Computing the coupon as a percentage of the market price instead of the face value.
Using the wrong PVIF/PVIFA (mixing n or r, or using PVIF for the coupons).
Forgetting to add the redemption value in the last year (or the PVIF term).
In YTM: choosing trial rates that do not straddle the price, or interpolating in the wrong direction.
Thinking a discount bond has YTM below its coupon rate. Discount bond: YTM > coupon rate.
Confusing current yield with YTM.
For semi-annual coupons, forgetting to halve the rate and double the periods.
Treating a bond price rise as an interest rate rise (it is the opposite).
In duration (historical): dividing by the wrong price and mixing up t.

Reasonableness checks

Value < face when r > coupon rate. Value > face when r < coupon rate. YTM is above the coupon rate for a discount bond. For any bond, the ordering is: discount → coupon < CY < YTM. Premium → YTM < CY < coupon.', NULL, NULL, NULL, 40, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', '93cf5196-ad2d-4a55-9ad1-650d0c374599', '{"blocks": [{"id": "equity-and-debt-markets-u4-c40-q", "text": "Common errors in bond valuation numericals.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c40-1", "type": "numberList", "items": ["Computing the coupon as a percentage of the market price instead of the face value.", "Using the wrong PVIF/PVIFA (mixing n or r, or using PVIF for the coupons).", "Forgetting to add the redemption value in the last year (or the PVIF term).", "In YTM: choosing trial rates that do not straddle the price, or interpolating in the wrong direction.", "Thinking a discount bond has YTM below its coupon rate. Discount bond: YTM > coupon rate.", "Confusing current yield with YTM.", "For semi-annual coupons, forgetting to halve the rate and double the periods.", "Treating a bond price rise as an interest rate rise (it is the opposite).", "In duration (historical): dividing by the wrong price and mixing up t."]}, {"id": "edm-u4-c40-2", "bold": true, "text": "Reasonableness checks", "type": "text", "style": "heading"}, {"id": "edm-u4-c40-3", "text": "Value < face when r > coupon rate. Value > face when r < coupon rate. YTM is above the coupon rate for a discount bond. For any bond, the ordering is: discount → coupon < CY < YTM. Premium → YTM < CY < coupon.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('8b7b3177-c714-4b82-a661-51aba21339fd', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Which formula do I use? (Problem-type identifier.)', 'Priority: Tier 2 | PYQ Connection: Covers all Unit 4 numerical patterns | PYQ Connection: Covers all Unit 4 numerical patterns', 'If the problem says... | Use | Card
"Dividend paid last year", growth rate given | Constant growth with D₁ = D₀(1 + g) | 11
"Dividend paid", no growth mentioned | Zero growth: D ÷ k | 10
Growth changes after some years | Multiple growth (terminal value) | 12
EBIT, tax, preference capital given, "earnings approach" | Earnings ÷ k | 14, 22
PAT, preference dividend, shares, P/E given | EPS × P/E | 17, 20
Balance sheet given | Book value per share | 6, 7
Bond with price, coupon, maturity; asks yield | YTM (approx. or exact) | 28
Bond, required return given; asks price | PV of coupons + principal | 26
Price and coupon; asks income return | Current yield | 32
Zero-coupon bond | F ÷ (1+r)ⁿ and (F/P)^(1/n) − 1 | 26, 30
Callable bond | Yield to call / worst | 30
"Price if the rate rises/falls" | Re-value at the new yield | 37', NULL, NULL, NULL, 41, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', '93cf5196-ad2d-4a55-9ad1-650d0c374599', '{"blocks": [{"id": "equity-and-debt-markets-u4-c41-q", "text": "Which formula do I use? (Problem-type identifier.)", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c41-1", "rows": [["If the problem says...", "Use", "Card"], ["\"Dividend paid last year\", growth rate given", "Constant growth with D₁ = D₀(1 + g)", "11"], ["\"Dividend paid\", no growth mentioned", "Zero growth: D ÷ k", "10"], ["Growth changes after some years", "Multiple growth (terminal value)", "12"], ["EBIT, tax, preference capital given, \"earnings approach\"", "Earnings ÷ k", "14, 22"], ["PAT, preference dividend, shares, P/E given", "EPS × P/E", "17, 20"], ["Balance sheet given", "Book value per share", "6, 7"], ["Bond with price, coupon, maturity; asks yield", "YTM (approx. or exact)", "28"], ["Bond, required return given; asks price", "PV of coupons + principal", "26"], ["Price and coupon; asks income return", "Current yield", "32"], ["Zero-coupon bond", "F ÷ (1+r)ⁿ and (F/P)^(1/n) − 1", "26, 30"], ["Callable bond", "Yield to call / worst", "30"], ["\"Price if the rate rises/falls\"", "Re-value at the new yield", "37"]], "type": "table"}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('c4a7e595-e726-4f16-bbc7-feb63afb9a14', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Formula sheet (Unit 4).', 'Priority: Tier 2 | PYQ Connection: Revision aid | PYQ Connection: Revision aid', 'Equity valuation

Topic | Formula
Net worth | Equity capital + Reserves − Accumulated losses − Fictitious assets
Book value per share | Net worth ÷ Number of equity shares
Zero growth DDM | P₀ = D ÷ k
Constant growth DDM | P₀ = D₁ ÷ (k − g), D₁ = D₀(1 + g)
Implied k | k = D₁ ÷ P₀ + g
Growth rate | g = Retention ratio × ROE
Multiple growth | P₀ = Σ D_t/(1+k)ᵗ + Pₙ/(1+k)ⁿ, Pₙ = Dₙ₊₁ ÷ (k − g₂)
EPS | (PAT − Pref. dividend) ÷ Equity shares
P/E | Market price ÷ EPS
P/E valuation | Value = EPS × P/E
Earnings approach | Value = Earnings for equity ÷ k
Earnings yield | EPS ÷ Price = 1 ÷ (P/E)

Bond valuation

Topic | Formula
Annual coupon | Coupon rate × Face value
Bond value | C × PVIFA(r,n) + M × PVIF(r,n)
Zero-coupon value | M ÷ (1 + r)ⁿ
Perpetual bond | C ÷ r
Semi-annual | r ÷ 2, 2n, C ÷ 2
Approx. YTM | [C + (F − P)/n] ÷ [(F + P)/2]
Exact YTM (interpolation) | r_low + [(P_low − P) ÷ (P_low − P_high)] × (r_high − r_low)
Zero-coupon YTM | (F ÷ P)^(1/n) − 1
BEY / EAY | 2 × y_s / (1 + y_s)² − 1
Current yield | Annual coupon ÷ Market price
Price status | y > coupon → discount; y = coupon → par; y < coupon → premium

Historical only (Tier 4)

Macaulay duration = Σ t × PV(CFₜ) ÷ Σ PV(CFₜ). Modified duration = Duration ÷ (1 + y).', NULL, NULL, NULL, 42, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', '93cf5196-ad2d-4a55-9ad1-650d0c374599', '{"blocks": [{"id": "equity-and-debt-markets-u4-c42-q", "text": "Formula sheet (Unit 4).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c42-1", "text": "Equity valuation", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c42-2", "rows": [["Topic", "Formula"], ["Net worth", "Equity capital + Reserves − Accumulated losses − Fictitious assets"], ["Book value per share", "Net worth ÷ Number of equity shares"], ["Zero growth DDM", "P₀ = D ÷ k"], ["Constant growth DDM", "P₀ = D₁ ÷ (k − g), D₁ = D₀(1 + g)"], ["Implied k", "k = D₁ ÷ P₀ + g"], ["Growth rate", "g = Retention ratio × ROE"], ["Multiple growth", "P₀ = Σ D_t/(1+k)ᵗ + Pₙ/(1+k)ⁿ, Pₙ = Dₙ₊₁ ÷ (k − g₂)"], ["EPS", "(PAT − Pref. dividend) ÷ Equity shares"], ["P/E", "Market price ÷ EPS"], ["P/E valuation", "Value = EPS × P/E"], ["Earnings approach", "Value = Earnings for equity ÷ k"], ["Earnings yield", "EPS ÷ Price = 1 ÷ (P/E)"]], "type": "table"}, {"id": "edm-u4-c42-3", "text": "Bond valuation", "type": "text", "style": "paragraph"}, {"id": "edm-u4-c42-4", "rows": [["Topic", "Formula"], ["Annual coupon", "Coupon rate × Face value"], ["Bond value", "C × PVIFA(r,n) + M × PVIF(r,n)"], ["Zero-coupon value", "M ÷ (1 + r)ⁿ"], ["Perpetual bond", "C ÷ r"], ["Semi-annual", "r ÷ 2, 2n, C ÷ 2"], ["Approx. YTM", "[C + (F − P)/n] ÷ [(F + P)/2]"], ["Exact YTM (interpolation)", "r_low + [(P_low − P) ÷ (P_low − P_high)] × (r_high − r_low)"], ["Zero-coupon YTM", "(F ÷ P)^(1/n) − 1"], ["BEY / EAY", "2 × y_s / (1 + y_s)² − 1"], ["Current yield", "Annual coupon ÷ Market price"], ["Price status", "y > coupon → discount; y = coupon → par; y < coupon → premium"]], "type": "table"}, {"id": "edm-u4-c42-5", "bold": true, "text": "Historical only (Tier 4)", "type": "text", "style": "heading"}, {"id": "edm-u4-c42-6", "type": "formula", "expression": "Macaulay duration = Σ t × PV(CFₜ) ÷ Σ PV(CFₜ). Modified duration = Duration ÷ (1 + y)."}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('e98d23a2-51aa-47b5-9881-a98ff157e635', '4942b243-3eda-4100-9200-942a29e98d11', 'flashcard', 'Rapid one-liners (confusables).', 'Priority: Tier 4 (supporting)', 'Intrinsic value is estimated worth. Market price is the traded price. Book value is net worth per share. Face value is nominal.
D₀ = last dividend paid. D₁ = next year''s dividend = D₀(1 + g).
Dividend approach = zero growth. Dividend growth approach = constant growth. Earnings approach = earnings ÷ k.
P/E is a multiple in "times". EPS is rupees per share.
Bond prices and yields move in opposite directions.
Discount bond → YTM > coupon rate. Premium bond → YTM < coupon rate.
Current yield ignores capital gain/loss. YTM includes it.
Longer maturity and lower coupon → higher interest rate risk.
Price risk and reinvestment risk offset each other.
Duration = historical PYQ only. Confirm before you spend time on it.', NULL, NULL, NULL, 43, true, 'University Exam', NULL, NULL, NULL, '36af92ff-aa78-49a6-b953-c816f8fa02f9', '93cf5196-ad2d-4a55-9ad1-650d0c374599', '{"blocks": [{"id": "equity-and-debt-markets-u4-c43-q", "text": "Rapid one-liners (confusables).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "edm-u4-c43-1", "type": "bulletList", "items": ["Intrinsic value is estimated worth. Market price is the traded price. Book value is net worth per share. Face value is nominal.", "D₀ = last dividend paid. D₁ = next year''s dividend = D₀(1 + g).", "Dividend approach = zero growth. Dividend growth approach = constant growth. Earnings approach = earnings ÷ k.", "P/E is a multiple in \"times\". EPS is rupees per share.", "Bond prices and yields move in opposite directions.", "Discount bond → YTM > coupon rate. Premium bond → YTM < coupon rate.", "Current yield ignores capital gain/loss. YTM includes it.", "Longer maturity and lower coupon → higher interest rate risk.", "Price risk and reinvestment risk offset each other.", "Duration = historical PYQ only. Confirm before you spend time on it."]}], "version": 1}'::jsonb, '2026-09-21 16:57:33.462562+00', '2026-09-21 16:57:33.462562+00'),
('b5473626-c7b3-4ec1-bca5-6e505ca85a00', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Define Macroeconomics. Discuss its scope and importance.', 'Priority: Tier 1 | PYQ Connection: Repeated PYQ — appeared as a direct 5-mark and a 7.5-mark question in both supplied papers.', 'Macroeconomics is the branch of economics that studies the economy as a whole — aggregates like national income, output, employment, price level, and growth — rather than individual units.

Scope covers: theory of income & employment, theory of general price level (inflation/deflation), theory of economic growth, theory of international trade & BOP, and public finance/fiscal policy.

Importance

(i) helps formulate economic policy (fiscal/monetary), (ii) explains business cycles and helps control them, (iii) useful in understanding inflation/deflation and their remedies, (iv) essential for understanding national income and growth, (v) guides international economic policy (exchange rate, trade), (vi) helps study poverty/unemployment at the aggregate level.', NULL, NULL, NULL, 1, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '107a2588-bf0d-4af8-86ec-58013bd7bf8f', '{"blocks": [{"id": "principles-of-economics-ii-u1-c1-q", "text": "Define Macroeconomics. Discuss its scope and importance.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c1-1", "text": "Macroeconomics is the branch of economics that studies the economy as a whole — aggregates like national income, output, employment, price level, and growth — rather than individual units.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c1-2", "text": "Scope covers: theory of income & employment, theory of general price level (inflation/deflation), theory of economic growth, theory of international trade & BOP, and public finance/fiscal policy.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c1-3", "bold": true, "text": "Importance", "type": "text", "style": "heading"}, {"id": "poe-u1-c1-4", "text": "(i) helps formulate economic policy (fiscal/monetary), (ii) explains business cycles and helps control them, (iii) useful in understanding inflation/deflation and their remedies, (iv) essential for understanding national income and growth, (v) guides international economic policy (exchange rate, trade), (vi) helps study poverty/unemployment at the aggregate level.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('954e2dd0-e947-4298-970b-a96e326ea87d', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'How does Macroeconomics differ from Microeconomics?', 'Priority: Tier 2 | PYQ Connection: Related PYQ pattern (Q2 T/F item 1 in Oct 2024 paper tested this distinction indirectly).', 'Microeconomics studies individual units (a firm, a household, a single price) — a "worm''s eye view." Macroeconomics studies the economy as a whole (aggregate output, income, price level) — a "bird''s eye view." Micro assumes full employment as given; macro treats employment level itself as a variable to be explained.', NULL, NULL, NULL, 2, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '107a2588-bf0d-4af8-86ec-58013bd7bf8f', '{"blocks": [{"id": "principles-of-economics-ii-u1-c2-q", "text": "How does Macroeconomics differ from Microeconomics?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c2-1", "text": "Microeconomics studies individual units (a firm, a household, a single price) — a \"worm''s eye view.\" Macroeconomics studies the economy as a whole (aggregate output, income, price level) — a \"bird''s eye view.\" Micro assumes full employment as given; macro treats employment level itself as a variable to be explained.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('bdd59e7f-93e8-4f2d-bdfd-ce52399b6db0', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the four central concerns of Macroeconomics.', 'Priority: Tier 2 | PYQ Connection: Current-syllabus topic not yet seen directly in supplied PYQs, but foundational — likely tested as 1-mark/definitional items.', 'Economic Growth — sustained increase in an economy''s productive capacity/real GDP over time.
Inflation — persistent rise in the general price level, eroding purchasing power.
Unemployment — the state where willing, able workers cannot find jobs; measured via unemployment rate.
Exchange Rate Stability — maintaining a stable value of the domestic currency against foreign currencies to support trade and investment.

Macroeconomic policy essentially tries to balance these four, since improving one can sometimes worsen another (e.g., Phillips Curve trade-off between inflation and unemployment).', NULL, NULL, NULL, 3, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '107a2588-bf0d-4af8-86ec-58013bd7bf8f', '{"blocks": [{"id": "principles-of-economics-ii-u1-c3-q", "text": "Explain the four central concerns of Macroeconomics.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c3-1", "type": "numberList", "items": ["Economic Growth — sustained increase in an economy''s productive capacity/real GDP over time.", "Inflation — persistent rise in the general price level, eroding purchasing power.", "Unemployment — the state where willing, able workers cannot find jobs; measured via unemployment rate.", "Exchange Rate Stability — maintaining a stable value of the domestic currency against foreign currencies to support trade and investment."]}, {"id": "poe-u1-c3-2", "text": "Macroeconomic policy essentially tries to balance these four, since improving one can sometimes worsen another (e.g., Phillips Curve trade-off between inflation and unemployment).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('811399c3-8a77-493a-a962-acfd7861462c', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Draw and explain the 2-Sector Circular Flow of Income (without savings/investment).', 'Priority: Tier 1 | PYQ Connection: Related PYQ pattern — Q1(3) in Oct 2024 paper tested max sectors in circular flow (MCQ), implying the college expects clear sector-model knowledge.', 'Diagram Title

Circular Flow in a Two-Sector Economy

Axes/Components

Two boxes — "Households" and "Firms" — connected by two circular loops.

What to draw

An outer loop showing the flow of factors of production (land, labour, capital, enterprise) from Households → Firms, and the flow of money income (rent, wages, interest, profit) from Firms → Households. An inner loop showing goods & services flowing from Firms → Households, and consumption expenditure flowing from Households → Firms.

What each part represents

The real flow (factors/goods) moves opposite to the money flow (income/expenditure), forming a closed loop with no leakages.

Direction/relationship shown

Money flow = real flow in reverse direction; total income = total expenditure = value of output (in a simple 2-sector model with no savings).

How to explain in exam

State the assumption (only households & firms, no government, no foreign sector, no savings), draw the two loops with arrows, label clearly, then state the equilibrium condition Y = C.

Common labelling mistakes

Students often forget to show BOTH the real flow and the money flow as separate loops, or mislabel which flow moves in which direction.', NULL, NULL, NULL, 4, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '4009544f-e398-4ec8-8e40-f8f277523392', '{"blocks": [{"id": "principles-of-economics-ii-u1-c4-q", "text": "Draw and explain the 2-Sector Circular Flow of Income (without savings/investment).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c4-1", "bold": true, "text": "Diagram Title", "type": "text", "style": "heading"}, {"id": "poe-u1-c4-2", "text": "Circular Flow in a Two-Sector Economy", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c4-3", "bold": true, "text": "Axes/Components", "type": "text", "style": "heading"}, {"id": "poe-u1-c4-4", "text": "Two boxes — \"Households\" and \"Firms\" — connected by two circular loops.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c4-5", "bold": true, "text": "What to draw", "type": "text", "style": "heading"}, {"id": "poe-u1-c4-6", "text": "An outer loop showing the flow of factors of production (land, labour, capital, enterprise) from Households → Firms, and the flow of money income (rent, wages, interest, profit) from Firms → Households. An inner loop showing goods & services flowing from Firms → Households, and consumption expenditure flowing from Households → Firms.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c4-7", "bold": true, "text": "What each part represents", "type": "text", "style": "heading"}, {"id": "poe-u1-c4-8", "text": "The real flow (factors/goods) moves opposite to the money flow (income/expenditure), forming a closed loop with no leakages.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c4-9", "bold": true, "text": "Direction/relationship shown", "type": "text", "style": "heading"}, {"id": "poe-u1-c4-10", "type": "formula", "expression": "Money flow = real flow in reverse direction; total income = total expenditure = value of output (in a simple 2-sector model with no savings)."}, {"id": "poe-u1-c4-11", "bold": true, "text": "How to explain in exam", "type": "text", "style": "heading"}, {"id": "poe-u1-c4-12", "type": "formula", "expression": "State the assumption (only households & firms, no government, no foreign sector, no savings), draw the two loops with arrows, label clearly, then state the equilibrium condition Y = C."}, {"id": "poe-u1-c4-13", "bold": true, "text": "Common labelling mistakes", "type": "text", "style": "heading"}, {"id": "poe-u1-c4-14", "text": "Students often forget to show BOTH the real flow and the money flow as separate loops, or mislabel which flow moves in which direction.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('962d73b1-7da1-4b1e-9d4b-dc530228984a', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the 2-Sector Model of Circular Flow with Savings and Investment.', 'Priority: Tier 1 | PYQ Connection: Current-syllabus topic, related to Q1(3) pattern — sector-count MCQs suggest examiners test structural understanding of each model.', 'Diagram Title

Circular Flow with Leakage (Savings) and Injection (Investment)

What to draw

Same Households–Firms loop as above, but add a financial market/institution box. Show Savings (S) as a leakage flowing from Households into the financial market, and Investment (I) as an injection flowing from the financial market into Firms.

What each part represents

Savings is income not spent on consumption (a "leakage" out of the flow); Investment is spending by firms on capital goods financed through that saved money (an "injection" back into the flow).

Direction/relationship shown

For equilibrium, planned Savings = planned Investment (S = I).

How to explain in exam

Introduce the concept of leakage and injection explicitly, and state that equilibrium national income occurs where S = I.

Common labelling mistakes

Forgetting to show the financial market as an intermediary box between the savings leakage and investment injection.', NULL, NULL, NULL, 5, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '4009544f-e398-4ec8-8e40-f8f277523392', '{"blocks": [{"id": "principles-of-economics-ii-u1-c5-q", "text": "Explain the 2-Sector Model of Circular Flow with Savings and Investment.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c5-1", "bold": true, "text": "Diagram Title", "type": "text", "style": "heading"}, {"id": "poe-u1-c5-2", "text": "Circular Flow with Leakage (Savings) and Injection (Investment)", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c5-3", "bold": true, "text": "What to draw", "type": "text", "style": "heading"}, {"id": "poe-u1-c5-4", "text": "Same Households–Firms loop as above, but add a financial market/institution box. Show Savings (S) as a leakage flowing from Households into the financial market, and Investment (I) as an injection flowing from the financial market into Firms.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c5-5", "bold": true, "text": "What each part represents", "type": "text", "style": "heading"}, {"id": "poe-u1-c5-6", "text": "Savings is income not spent on consumption (a \"leakage\" out of the flow); Investment is spending by firms on capital goods financed through that saved money (an \"injection\" back into the flow).", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c5-7", "bold": true, "text": "Direction/relationship shown", "type": "text", "style": "heading"}, {"id": "poe-u1-c5-8", "type": "formula", "expression": "For equilibrium, planned Savings = planned Investment (S = I)."}, {"id": "poe-u1-c5-9", "bold": true, "text": "How to explain in exam", "type": "text", "style": "heading"}, {"id": "poe-u1-c5-10", "type": "formula", "expression": "Introduce the concept of leakage and injection explicitly, and state that equilibrium national income occurs where S = I."}, {"id": "poe-u1-c5-11", "bold": true, "text": "Common labelling mistakes", "type": "text", "style": "heading"}, {"id": "poe-u1-c5-12", "text": "Forgetting to show the financial market as an intermediary box between the savings leakage and investment injection.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('44ca2092-861a-4998-b2d6-3f08ef4fb7d5', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the 3-Sector Circular Flow of Income (adding Government).', 'Priority: Tier 2 | PYQ Connection: Current-syllabus topic not yet seen in supplied PYQs; still core and diagram-testable.', 'Diagram Title

Circular Flow with Government Sector

What to draw

Add a "Government" box to the 2-sector diagram. Show Taxes (T) flowing from Households/Firms to Government (a leakage), and Government Expenditure (G) flowing from Government to Households/Firms (an injection).

What each part represents

Government collects taxes (leakage) and spends on goods, services, subsidies, transfer payments (injection), influencing the level of aggregate income.

Direction/relationship shown

Total leakages (S+T) must equal total injections (I+G) for equilibrium.

How to explain in exam

Build on the 2-sector-with-S&I model, then add government as the third leakage/injection pair.

Common labelling mistakes

Confusing taxes as an injection instead of a leakage, or omitting transfer payments from government expenditure.', NULL, NULL, NULL, 6, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '4009544f-e398-4ec8-8e40-f8f277523392', '{"blocks": [{"id": "principles-of-economics-ii-u1-c6-q", "text": "Explain the 3-Sector Circular Flow of Income (adding Government).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c6-1", "bold": true, "text": "Diagram Title", "type": "text", "style": "heading"}, {"id": "poe-u1-c6-2", "text": "Circular Flow with Government Sector", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c6-3", "bold": true, "text": "What to draw", "type": "text", "style": "heading"}, {"id": "poe-u1-c6-4", "text": "Add a \"Government\" box to the 2-sector diagram. Show Taxes (T) flowing from Households/Firms to Government (a leakage), and Government Expenditure (G) flowing from Government to Households/Firms (an injection).", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c6-5", "bold": true, "text": "What each part represents", "type": "text", "style": "heading"}, {"id": "poe-u1-c6-6", "text": "Government collects taxes (leakage) and spends on goods, services, subsidies, transfer payments (injection), influencing the level of aggregate income.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c6-7", "bold": true, "text": "Direction/relationship shown", "type": "text", "style": "heading"}, {"id": "poe-u1-c6-8", "text": "Total leakages (S+T) must equal total injections (I+G) for equilibrium.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c6-9", "bold": true, "text": "How to explain in exam", "type": "text", "style": "heading"}, {"id": "poe-u1-c6-10", "text": "Build on the 2-sector-with-S&I model, then add government as the third leakage/injection pair.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c6-11", "bold": true, "text": "Common labelling mistakes", "type": "text", "style": "heading"}, {"id": "poe-u1-c6-12", "text": "Confusing taxes as an injection instead of a leakage, or omitting transfer payments from government expenditure.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('97d2ae7a-2fec-4239-be0d-91f0bf883c45', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the 4-Sector Circular Flow of Income (adding the Foreign Sector).', 'Priority: Tier 1 | PYQ Connection: Repeated PYQ — Oct 2024 Q1(3) directly asked "maximum possible sectors in circular flow" (answer: 4).', 'Diagram Title

Circular Flow — Open Economy Model

What to draw

Add a "Foreign Sector/Rest of World" box. Show Imports (M) as a leakage (money flowing out to pay for foreign goods) and Exports (X) as an injection (money flowing in from foreign buyers).

What each part represents

This is the most complete/realistic model, representing an open economy with trade.

Direction/relationship shown

Equilibrium condition: total leakages (S + T + M) = total injections (I + G + X).

How to explain in exam

Present this as the "maximum sectors" model — households, firms, government, foreign sector — and give the full leakage/injection equation.

Common labelling mistakes

Mixing up exports and imports as leakage/injection (exports = money IN = injection; imports = money OUT = leakage).', NULL, NULL, NULL, 7, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '4009544f-e398-4ec8-8e40-f8f277523392', '{"blocks": [{"id": "principles-of-economics-ii-u1-c7-q", "text": "Explain the 4-Sector Circular Flow of Income (adding the Foreign Sector).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c7-1", "bold": true, "text": "Diagram Title", "type": "text", "style": "heading"}, {"id": "poe-u1-c7-2", "text": "Circular Flow — Open Economy Model", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c7-3", "bold": true, "text": "What to draw", "type": "text", "style": "heading"}, {"id": "poe-u1-c7-4", "text": "Add a \"Foreign Sector/Rest of World\" box. Show Imports (M) as a leakage (money flowing out to pay for foreign goods) and Exports (X) as an injection (money flowing in from foreign buyers).", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c7-5", "bold": true, "text": "What each part represents", "type": "text", "style": "heading"}, {"id": "poe-u1-c7-6", "text": "This is the most complete/realistic model, representing an open economy with trade.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c7-7", "bold": true, "text": "Direction/relationship shown", "type": "text", "style": "heading"}, {"id": "poe-u1-c7-8", "type": "formula", "expression": "Equilibrium condition: total leakages (S + T + M) = total injections (I + G + X)."}, {"id": "poe-u1-c7-9", "bold": true, "text": "How to explain in exam", "type": "text", "style": "heading"}, {"id": "poe-u1-c7-10", "text": "Present this as the \"maximum sectors\" model — households, firms, government, foreign sector — and give the full leakage/injection equation.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c7-11", "bold": true, "text": "Common labelling mistakes", "type": "text", "style": "heading"}, {"id": "poe-u1-c7-12", "type": "formula", "expression": "Mixing up exports and imports as leakage/injection (exports = money IN = injection; imports = money OUT = leakage)."}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('944dae96-e81c-4655-befc-339c21bbae55', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the traditional concepts of National Income (GDP, GNP, NNP, NI).', 'Priority: Tier 1 | PYQ Connection: Related PYQ pattern — Oct 2024 Q1(4) directly tested "GDP is a sum of..." (MCQ), confirming national income aggregates are examined.', 'GDP (Gross Domestic Product): total market value of all final goods & services produced within a country''s borders in a year.
GNP (Gross National Product): GDP + Net Factor Income from Abroad (NFIA) — includes income earned by residents abroad, excludes income earned by foreigners domestically.
NNP (Net National Product): GNP − Depreciation (capital consumption allowance).
National Income (NI): NNP at Factor Cost = NNP at Market Price − Net Indirect Taxes (Indirect Taxes − Subsidies).', NULL, NULL, NULL, 8, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', 'bd9aafc4-8541-405e-8f54-5a1d74d2183d', '{"blocks": [{"id": "principles-of-economics-ii-u1-c8-q", "text": "Explain the traditional concepts of National Income (GDP, GNP, NNP, NI).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c8-1", "type": "bulletList", "items": ["GDP (Gross Domestic Product): total market value of all final goods & services produced within a country''s borders in a year.", "GNP (Gross National Product): GDP + Net Factor Income from Abroad (NFIA) — includes income earned by residents abroad, excludes income earned by foreigners domestically.", "NNP (Net National Product): GNP − Depreciation (capital consumption allowance).", "National Income (NI): NNP at Factor Cost = NNP at Market Price − Net Indirect Taxes (Indirect Taxes − Subsidies)."]}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('f8f1ec63-a986-4011-8032-2289cc0da1f5', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the modern concepts of National Income (Personal Income, Disposable Income, Per Capita Income).', 'Priority: Tier 2 | PYQ Connection: Current-syllabus topic not yet seen in supplied PYQs but a standard 5-mark item.', 'Personal Income (PI): income actually received by individuals/households — NI − (Corporate taxes + Undistributed profits + Social security contributions) + Transfer payments.
Disposable Income (DI): PI − Personal (direct) taxes; the income households can actually spend or save.
Per Capita Income: National Income ÷ Total Population; used as a rough indicator of average standard of living.', NULL, NULL, NULL, 9, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', 'bd9aafc4-8541-405e-8f54-5a1d74d2183d', '{"blocks": [{"id": "principles-of-economics-ii-u1-c9-q", "text": "Explain the modern concepts of National Income (Personal Income, Disposable Income, Per Capita Income).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c9-1", "type": "bulletList", "items": ["Personal Income (PI): income actually received by individuals/households — NI − (Corporate taxes + Undistributed profits + Social security contributions) + Transfer payments.", "Disposable Income (DI): PI − Personal (direct) taxes; the income households can actually spend or save.", "Per Capita Income: National Income ÷ Total Population; used as a rough indicator of average standard of living."]}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('8ca17784-3473-4f65-a75a-31fd9fe2bb0c', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the methods of measuring National Income.', 'Priority: Tier 1 | PYQ Connection: Related PYQ pattern — Oct 2024 Q1(4) option "Investment, Consumption, Government Purchases and Net Exports" is literally the Expenditure Method formula tested as an MCQ.', 'Product/Output Method: sums the value added by all producing sectors (net of intermediate consumption) — avoids double counting.
Income Method: sums all factor incomes — wages, rent, interest, profit — earned in producing final goods/services.
Expenditure Method: sums final expenditure — Y = C + I + G + (X − M).

All three methods should yield the same National Income figure in principle, since one''s output is another''s income which becomes someone''s expenditure.', NULL, NULL, NULL, 10, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', 'bd9aafc4-8541-405e-8f54-5a1d74d2183d', '{"blocks": [{"id": "principles-of-economics-ii-u1-c10-q", "text": "Explain the methods of measuring National Income.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c10-1", "type": "numberList", "items": ["Product/Output Method: sums the value added by all producing sectors (net of intermediate consumption) — avoids double counting.", "Income Method: sums all factor incomes — wages, rent, interest, profit — earned in producing final goods/services.", "Expenditure Method: sums final expenditure — Y = C + I + G + (X − M)."]}, {"id": "poe-u1-c10-2", "text": "All three methods should yield the same National Income figure in principle, since one''s output is another''s income which becomes someone''s expenditure.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('0da51c88-f1fa-42d4-b9a2-af0a809f1464', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'What is National Income Accounting and why is it important?', 'Priority: Tier 3 | PYQ Connection: Current-syllabus topic not yet seen in supplied PYQs.', 'National Income Accounting is the systematic recording and measurement of a nation''s total economic activity/output over a period, using standardized aggregates (GDP, GNP, NNP, NI, etc.). It''s important because it (i) measures economic performance and growth, (ii) enables international/inter-temporal comparison, (iii) guides policy formulation, (iv) helps track structural changes (sectoral composition) in the economy.', NULL, NULL, NULL, 11, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', 'bd9aafc4-8541-405e-8f54-5a1d74d2183d', '{"blocks": [{"id": "principles-of-economics-ii-u1-c11-q", "text": "What is National Income Accounting and why is it important?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c11-1", "text": "National Income Accounting is the systematic recording and measurement of a nation''s total economic activity/output over a period, using standardized aggregates (GDP, GNP, NNP, NI, etc.). It''s important because it (i) measures economic performance and growth, (ii) enables international/inter-temporal comparison, (iii) guides policy formulation, (iv) helps track structural changes (sectoral composition) in the economy.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('84b6d875-c818-4b48-8efc-80cb0e6b3f06', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Critically explain Say''s Law of Markets.', 'Priority: Tier 1 | PYQ Connection: Repeated PYQ — directly asked as a 5-mark "critically explain" question in Oct 2024 (Q3-P) and tested as T/F in Q2(2).', 'Say''s Law states "Supply creates its own Demand." The classical argument: production of goods generates income (wages, rent, profit) equal to the value of goods produced; this income is then spent (directly or via savings→investment) on buying goods, so aggregate demand automatically equals aggregate supply — general overproduction (glut) is impossible, and the economy self-adjusts to full employment.

Assumptions

laissez-faire economy, flexible wages/prices, all savings automatically become investment, no hoarding, closed economy.

Criticism (Keynes)

People may save without automatically investing (hoarding), especially in a liquidity trap; wages/prices are not perfectly flexible (sticky downward); the law ignores the possibility of deficient aggregate demand and involuntary unemployment, as seen in the Great Depression. Keynes essentially reversed it: "Demand creates its own Supply" in the short run.', NULL, NULL, NULL, 12, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '531dae3d-4965-49a8-8a76-fd28476c71f0', '{"blocks": [{"id": "principles-of-economics-ii-u1-c12-q", "text": "Critically explain Say''s Law of Markets.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c12-1", "text": "Say''s Law states \"Supply creates its own Demand.\" The classical argument: production of goods generates income (wages, rent, profit) equal to the value of goods produced; this income is then spent (directly or via savings→investment) on buying goods, so aggregate demand automatically equals aggregate supply — general overproduction (glut) is impossible, and the economy self-adjusts to full employment.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c12-2", "bold": true, "text": "Assumptions", "type": "text", "style": "heading"}, {"id": "poe-u1-c12-3", "text": "laissez-faire economy, flexible wages/prices, all savings automatically become investment, no hoarding, closed economy.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c12-4", "bold": true, "text": "Criticism (Keynes)", "type": "text", "style": "heading"}, {"id": "poe-u1-c12-5", "text": "People may save without automatically investing (hoarding), especially in a liquidity trap; wages/prices are not perfectly flexible (sticky downward); the law ignores the possibility of deficient aggregate demand and involuntary unemployment, as seen in the Great Depression. Keynes essentially reversed it: \"Demand creates its own Supply\" in the short run.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('f1fb01eb-602d-4698-b658-c611760e89fb', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Give a brief Keynesian overview of income and employment determination.', 'Priority: Tier 1 | PYQ Connection: Related PYQ pattern — underlies the Say''s Law critical-explain question and the Liquidity Trap MCQ (Q1-5, Oct 2024).', 'Keynes, writing after the Great Depression, argued that the level of income, output and employment in the short run is determined by Aggregate Demand (Effective Demand), not automatically by supply (as classical economists via Say''s Law believed). An economy can settle into equilibrium below full employment if aggregate demand is deficient — there is no automatic tendency to full employment. Government intervention (fiscal/monetary policy) may be needed to boost demand and restore full employment.', NULL, NULL, NULL, 13, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '531dae3d-4965-49a8-8a76-fd28476c71f0', '{"blocks": [{"id": "principles-of-economics-ii-u1-c13-q", "text": "Give a brief Keynesian overview of income and employment determination.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c13-1", "text": "Keynes, writing after the Great Depression, argued that the level of income, output and employment in the short run is determined by Aggregate Demand (Effective Demand), not automatically by supply (as classical economists via Say''s Law believed). An economy can settle into equilibrium below full employment if aggregate demand is deficient — there is no automatic tendency to full employment. Government intervention (fiscal/monetary policy) may be needed to boost demand and restore full employment.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('50221329-7801-4192-b871-c6eec810bcae', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the Theory of Effective Demand.', 'Priority: Tier 2 | PYQ Connection: Current-syllabus topic not directly seen yet in supplied PYQs but central to the Keynesian framework tested elsewhere (Say''s Law, Multiplier).', 'Effective Demand is the point where Aggregate Demand (AD) = Aggregate Supply (AS), determining the actual level of output, income and employment in the economy. AD = Consumption + Investment (in a simple economy); AS represents what firms are willing to produce and sell at given price/employment levels. Equilibrium employment is determined at the level of output where AD = AS — this need not correspond to full employment, since deficient demand can leave the economy stuck at underemployment equilibrium.', NULL, NULL, NULL, 14, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '531dae3d-4965-49a8-8a76-fd28476c71f0', '{"blocks": [{"id": "principles-of-economics-ii-u1-c14-q", "text": "Explain the Theory of Effective Demand.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c14-1", "text": "Effective Demand is the point where Aggregate Demand (AD) = Aggregate Supply (AS), determining the actual level of output, income and employment in the economy. AD = Consumption + Investment (in a simple economy); AS represents what firms are willing to produce and sell at given price/employment levels. Equilibrium employment is determined at the level of output where AD = AS — this need not correspond to full employment, since deficient demand can leave the economy stuck at underemployment equilibrium.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('e2e59a95-0dd0-42ad-98e9-cc480705b126', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the Consumption Function with its diagram.', 'Priority: Tier 2 | PYQ Connection: Related PYQ pattern — directly underlies the APC/MPC numerical questions asked in both supplied papers.', 'Diagram Title

Keynesian Consumption Function (C = a + bY)

Axes/Components

X-axis = Income (Y); Y-axis = Consumption (C). Plot the 45° line (where C = Y) and the consumption function line C = a + bY, starting above the origin at "a" (autonomous consumption).

What to draw

The 45° line from origin; the upward-sloping consumption line starting at a positive intercept "a" on the Y-axis with slope "b" (MPC) flatter than 45°. Mark the break-even point where the consumption line crosses the 45° line (S=0).

What each part represents

"a" = autonomous consumption (consumption even at zero income, financed by dissaving); "b" (slope) = Marginal Propensity to Consume (MPC); below the break-even point households dissave, above it they save.

Direction/relationship shown

As income rises, consumption rises but by a smaller proportion (MPC < 1), so the gap between the 45° line and the consumption line (= savings) widens as income grows.

How to explain in exam

State the equation C = a + bY, explain "a" and "b", draw both lines, mark the break-even point, and note that the consumption function underlies both the Multiplier and the Marginal Propensity to Save (MPS = 1 − MPC).

Common labelling mistakes

Forgetting the 45° reference line, or mislabelling "a" as located at the origin instead of above it.', NULL, NULL, NULL, 15, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '531dae3d-4965-49a8-8a76-fd28476c71f0', '{"blocks": [{"id": "principles-of-economics-ii-u1-c15-q", "text": "Explain the Consumption Function with its diagram.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c15-1", "bold": true, "text": "Diagram Title", "type": "text", "style": "heading"}, {"id": "poe-u1-c15-2", "type": "formula", "expression": "Keynesian Consumption Function (C = a + bY)"}, {"id": "poe-u1-c15-3", "bold": true, "text": "Axes/Components", "type": "text", "style": "heading"}, {"id": "poe-u1-c15-4", "type": "formula", "expression": "X-axis = Income (Y); Y-axis = Consumption (C). Plot the 45° line (where C = Y) and the consumption function line C = a + bY, starting above the origin at \"a\" (autonomous consumption)."}, {"id": "poe-u1-c15-5", "bold": true, "text": "What to draw", "type": "text", "style": "heading"}, {"id": "poe-u1-c15-6", "type": "formula", "expression": "The 45° line from origin; the upward-sloping consumption line starting at a positive intercept \"a\" on the Y-axis with slope \"b\" (MPC) flatter than 45°. Mark the break-even point where the consumption line crosses the 45° line (S=0)."}, {"id": "poe-u1-c15-7", "bold": true, "text": "What each part represents", "type": "text", "style": "heading"}, {"id": "poe-u1-c15-8", "type": "formula", "expression": "\"a\" = autonomous consumption (consumption even at zero income, financed by dissaving); \"b\" (slope) = Marginal Propensity to Consume (MPC); below the break-even point households dissave, above it they save."}, {"id": "poe-u1-c15-9", "bold": true, "text": "Direction/relationship shown", "type": "text", "style": "heading"}, {"id": "poe-u1-c15-10", "type": "formula", "expression": "As income rises, consumption rises but by a smaller proportion (MPC < 1), so the gap between the 45° line and the consumption line (= savings) widens as income grows."}, {"id": "poe-u1-c15-11", "bold": true, "text": "How to explain in exam", "type": "text", "style": "heading"}, {"id": "poe-u1-c15-12", "type": "formula", "expression": "State the equation C = a + bY, explain \"a\" and \"b\", draw both lines, mark the break-even point, and note that the consumption function underlies both the Multiplier and the Marginal Propensity to Save (MPS = 1 − MPC)."}, {"id": "poe-u1-c15-13", "bold": true, "text": "Common labelling mistakes", "type": "text", "style": "heading"}, {"id": "poe-u1-c15-14", "text": "Forgetting the 45° reference line, or mislabelling \"a\" as located at the origin instead of above it.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('b5e45f54-ab42-4141-8961-eb0fb6351ffb', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the working of the Investment Multiplier with its diagram.', 'Priority: Tier 1 | PYQ Connection: Repeated PYQ — Oct 2024 Q2(3) directly tested the multiplier formula as True/False: "Investment multiplier(r) = 1/(1-MPC)" — TRUE.', 'Diagram Title

Keynesian Investment Multiplier

Axes/Components

X-axis = Income (Y); Y-axis = Aggregate Demand (C+I). Show the AD line shifting upward (parallel shift) after a rise in Investment (ΔI), and the resulting larger rise in equilibrium income (ΔY) at the new intersection with the 45° line.

What to draw

Original AD line (C+I) crossing the 45° line at E₁ giving income Y₁; a new AD line (C+I+ΔI) shifted up by ΔI, crossing the 45° line at E₂ giving income Y₂. Show that Y₂−Y₁ (ΔY) is larger than ΔI.

What each part represents

The multiplier (k) shows that an initial increase in investment leads to a magnified increase in national income, because each round of new spending becomes someone else''s income, part of which is respent (via MPC).

Formula

k = ΔY/ΔI = 1/(1−MPC) = 1/MPS

How to explain in exam

Define the multiplier, give the formula, explain the "respending" mechanism round by round (I → income → consumption (MPC share) → further income...), then show the diagram.

Common labelling mistakes

Showing ΔY and ΔI as equal on the diagram — the whole point is that ΔY > ΔI.', NULL, NULL, NULL, 16, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '531dae3d-4965-49a8-8a76-fd28476c71f0', '{"blocks": [{"id": "principles-of-economics-ii-u1-c16-q", "text": "Explain the working of the Investment Multiplier with its diagram.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c16-1", "bold": true, "text": "Diagram Title", "type": "text", "style": "heading"}, {"id": "poe-u1-c16-2", "text": "Keynesian Investment Multiplier", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c16-3", "bold": true, "text": "Axes/Components", "type": "text", "style": "heading"}, {"id": "poe-u1-c16-4", "type": "formula", "expression": "X-axis = Income (Y); Y-axis = Aggregate Demand (C+I). Show the AD line shifting upward (parallel shift) after a rise in Investment (ΔI), and the resulting larger rise in equilibrium income (ΔY) at the new intersection with the 45° line."}, {"id": "poe-u1-c16-5", "bold": true, "text": "What to draw", "type": "text", "style": "heading"}, {"id": "poe-u1-c16-6", "text": "Original AD line (C+I) crossing the 45° line at E₁ giving income Y₁; a new AD line (C+I+ΔI) shifted up by ΔI, crossing the 45° line at E₂ giving income Y₂. Show that Y₂−Y₁ (ΔY) is larger than ΔI.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c16-7", "bold": true, "text": "What each part represents", "type": "text", "style": "heading"}, {"id": "poe-u1-c16-8", "text": "The multiplier (k) shows that an initial increase in investment leads to a magnified increase in national income, because each round of new spending becomes someone else''s income, part of which is respent (via MPC).", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c16-9", "bold": true, "text": "Formula", "type": "text", "style": "heading"}, {"id": "poe-u1-c16-10", "type": "formula", "expression": "k = ΔY/ΔI = 1/(1−MPC) = 1/MPS"}, {"id": "poe-u1-c16-11", "bold": true, "text": "How to explain in exam", "type": "text", "style": "heading"}, {"id": "poe-u1-c16-12", "text": "Define the multiplier, give the formula, explain the \"respending\" mechanism round by round (I → income → consumption (MPC share) → further income...), then show the diagram.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c16-13", "bold": true, "text": "Common labelling mistakes", "type": "text", "style": "heading"}, {"id": "poe-u1-c16-14", "text": "Showing ΔY and ΔI as equal on the diagram — the whole point is that ΔY > ΔI.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('2c236612-ec20-4e71-94d3-5e39e4977d09', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the concept of the Liquidity Trap with its diagram.', 'Priority: Tier 1 | PYQ Connection: Repeated PYQ — Oct 2024 Q1(5) directly asked what causes a liquidity trap (MCQ: correct answer "Low interest rates").', 'Diagram Title

Keynesian Liquidity Trap (in the Money Market)

Axes/Components

X-axis = Quantity of Money (demand for money); Y-axis = Rate of Interest. Draw the Liquidity Preference (money demand) curve — normally downward sloping — becoming perfectly horizontal (flat) at a very low interest rate.

What to draw

The horizontal segment of the money-demand curve at the low interest rate, with the money supply curve (vertical) intersecting it in that flat region.

What each part represents

At very low interest rates, people believe rates cannot fall further (and will only rise), so they hold any additional money as idle cash (speculative demand) instead of investing in bonds/securities — money demand becomes infinitely elastic.

Direction/relationship shown

In this zone, increasing the money supply (shifting the vertical MS curve rightward) does NOT lower the interest rate further and has no effect on investment or income — monetary policy becomes ineffective.

How to explain in exam

Define the liquidity trap, state the cause (near-zero rates + expectation of future rate rises), draw the flat liquidity preference curve, and explain the policy implication — fiscal policy (not monetary policy) becomes the effective tool.

Common labelling mistakes

Drawing the liquidity preference curve as fully horizontal throughout instead of only in the low-interest-rate segment.', NULL, NULL, NULL, 17, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '531dae3d-4965-49a8-8a76-fd28476c71f0', '{"blocks": [{"id": "principles-of-economics-ii-u1-c17-q", "text": "Explain the concept of the Liquidity Trap with its diagram.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c17-1", "bold": true, "text": "Diagram Title", "type": "text", "style": "heading"}, {"id": "poe-u1-c17-2", "text": "Keynesian Liquidity Trap (in the Money Market)", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c17-3", "bold": true, "text": "Axes/Components", "type": "text", "style": "heading"}, {"id": "poe-u1-c17-4", "type": "formula", "expression": "X-axis = Quantity of Money (demand for money); Y-axis = Rate of Interest. Draw the Liquidity Preference (money demand) curve — normally downward sloping — becoming perfectly horizontal (flat) at a very low interest rate."}, {"id": "poe-u1-c17-5", "bold": true, "text": "What to draw", "type": "text", "style": "heading"}, {"id": "poe-u1-c17-6", "text": "The horizontal segment of the money-demand curve at the low interest rate, with the money supply curve (vertical) intersecting it in that flat region.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c17-7", "bold": true, "text": "What each part represents", "type": "text", "style": "heading"}, {"id": "poe-u1-c17-8", "text": "At very low interest rates, people believe rates cannot fall further (and will only rise), so they hold any additional money as idle cash (speculative demand) instead of investing in bonds/securities — money demand becomes infinitely elastic.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c17-9", "bold": true, "text": "Direction/relationship shown", "type": "text", "style": "heading"}, {"id": "poe-u1-c17-10", "text": "In this zone, increasing the money supply (shifting the vertical MS curve rightward) does NOT lower the interest rate further and has no effect on investment or income — monetary policy becomes ineffective.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c17-11", "bold": true, "text": "How to explain in exam", "type": "text", "style": "heading"}, {"id": "poe-u1-c17-12", "text": "Define the liquidity trap, state the cause (near-zero rates + expectation of future rate rises), draw the flat liquidity preference curve, and explain the policy implication — fiscal policy (not monetary policy) becomes the effective tool.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c17-13", "bold": true, "text": "Common labelling mistakes", "type": "text", "style": "heading"}, {"id": "poe-u1-c17-14", "text": "Drawing the liquidity preference curve as fully horizontal throughout instead of only in the low-interest-rate segment.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('8d48643c-194f-461f-92c9-6d5513e07591', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Define Inflation, Deflation and Stagflation.', 'Priority: Tier 2 | PYQ Connection: Current-syllabus topic not yet seen in supplied PYQs — likely tested as definitions/MCQ/T-F.', 'Inflation: a sustained/persistent rise in the general price level of goods and services, reducing the purchasing power of money.
Deflation: a sustained fall in the general price level — the opposite of inflation; often associated with falling demand, rising unemployment and economic contraction.
Stagflation: a situation combining stagnant economic growth + high unemployment + high inflation simultaneously — unusual because inflation and unemployment don''t normally rise together (violates the standard Phillips Curve trade-off). Classic example: the 1970s oil-shock era.', NULL, NULL, NULL, 18, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '2c69d9ea-3e98-4249-8e02-de47b3dbffd7', '{"blocks": [{"id": "principles-of-economics-ii-u1-c18-q", "text": "Define Inflation, Deflation and Stagflation.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c18-1", "type": "bulletList", "items": ["Inflation: a sustained/persistent rise in the general price level of goods and services, reducing the purchasing power of money.", "Deflation: a sustained fall in the general price level — the opposite of inflation; often associated with falling demand, rising unemployment and economic contraction.", "Stagflation: a situation combining stagnant economic growth + high unemployment + high inflation simultaneously — unusual because inflation and unemployment don''t normally rise together (violates the standard Phillips Curve trade-off). Classic example: the 1970s oil-shock era."]}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('799617c3-2dbd-4305-a5d0-8dd40471c315', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Distinguish between Cost-Push and Demand-Pull Inflation (with causes).', 'Priority: Tier 1 | PYQ Connection: Repeated PYQ — directly asked as a 7.5-mark "illustrate with causes" question in the SEM-end paper, and appears in Q2(as thematic pairing) across papers.', 'Basis | Demand-Pull Inflation | Cost-Push Inflation
Trigger | Aggregate Demand rises faster than Aggregate Supply | Cost of production (wages, raw materials, energy) rises
Mechanism | "Too much money chasing too few goods" | Firms raise prices to protect profit margins as costs rise
Common causes | Rising money supply, rising government spending, rising exports, falling taxes, credit expansion | Rising wages (wage-push), rising input/raw material prices, higher indirect taxes, supply shocks (e.g., oil prices)
Diagram | AD curve shifts rightward along a given AS curve | AS curve shifts leftward (upward) along a given AD curve', NULL, NULL, NULL, 19, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '2c69d9ea-3e98-4249-8e02-de47b3dbffd7', '{"blocks": [{"id": "principles-of-economics-ii-u1-c19-q", "text": "Distinguish between Cost-Push and Demand-Pull Inflation (with causes).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c19-1", "rows": [["Basis", "Demand-Pull Inflation", "Cost-Push Inflation"], ["Trigger", "Aggregate Demand rises faster than Aggregate Supply", "Cost of production (wages, raw materials, energy) rises"], ["Mechanism", "\"Too much money chasing too few goods\"", "Firms raise prices to protect profit margins as costs rise"], ["Common causes", "Rising money supply, rising government spending, rising exports, falling taxes, credit expansion", "Rising wages (wage-push), rising input/raw material prices, higher indirect taxes, supply shocks (e.g., oil prices)"], ["Diagram", "AD curve shifts rightward along a given AS curve", "AS curve shifts leftward (upward) along a given AD curve"]], "type": "table"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('bbbd27f4-d40f-43c0-865c-00da5fbc6706', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Illustrate Demand-Pull Inflation with a diagram.', 'Priority: Tier 1 | PYQ Connection: Repeated PYQ (paired with cost-push inflation question, SEM-end paper).', 'Diagram Title

Demand-Pull Inflation (AD-AS Model)

Axes/Components

X-axis = Real Output/GDP; Y-axis = Price Level. Draw an upward-sloping AS curve and a downward-sloping AD curve, then a second AD curve shifted to the right.

What to draw

Original AD₁ intersecting AS at E₁ (price P₁); AD₂ (shifted right) intersecting AS at E₂ (price P₂, higher).

What each part represents

The rightward shift represents increased aggregate demand (from higher money supply, government spending, exports, etc.) at the same supply conditions.

Direction/relationship shown

As AD shifts right along a relatively fixed AS, the equilibrium price level rises from P₁ to P₂ — output may also rise somewhat depending on AS slope.

How to explain in exam

Draw AD shift, mark P₁→P₂ rise, list 2-3 specific causes (rising money supply, credit expansion, rising govt/consumer spending).

Common labelling mistakes

Shifting the AS curve instead of the AD curve.', NULL, NULL, NULL, 20, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '2c69d9ea-3e98-4249-8e02-de47b3dbffd7', '{"blocks": [{"id": "principles-of-economics-ii-u1-c20-q", "text": "Illustrate Demand-Pull Inflation with a diagram.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c20-1", "bold": true, "text": "Diagram Title", "type": "text", "style": "heading"}, {"id": "poe-u1-c20-2", "text": "Demand-Pull Inflation (AD-AS Model)", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c20-3", "bold": true, "text": "Axes/Components", "type": "text", "style": "heading"}, {"id": "poe-u1-c20-4", "type": "formula", "expression": "X-axis = Real Output/GDP; Y-axis = Price Level. Draw an upward-sloping AS curve and a downward-sloping AD curve, then a second AD curve shifted to the right."}, {"id": "poe-u1-c20-5", "bold": true, "text": "What to draw", "type": "text", "style": "heading"}, {"id": "poe-u1-c20-6", "text": "Original AD₁ intersecting AS at E₁ (price P₁); AD₂ (shifted right) intersecting AS at E₂ (price P₂, higher).", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c20-7", "bold": true, "text": "What each part represents", "type": "text", "style": "heading"}, {"id": "poe-u1-c20-8", "text": "The rightward shift represents increased aggregate demand (from higher money supply, government spending, exports, etc.) at the same supply conditions.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c20-9", "bold": true, "text": "Direction/relationship shown", "type": "text", "style": "heading"}, {"id": "poe-u1-c20-10", "text": "As AD shifts right along a relatively fixed AS, the equilibrium price level rises from P₁ to P₂ — output may also rise somewhat depending on AS slope.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c20-11", "bold": true, "text": "How to explain in exam", "type": "text", "style": "heading"}, {"id": "poe-u1-c20-12", "text": "Draw AD shift, mark P₁→P₂ rise, list 2-3 specific causes (rising money supply, credit expansion, rising govt/consumer spending).", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c20-13", "bold": true, "text": "Common labelling mistakes", "type": "text", "style": "heading"}, {"id": "poe-u1-c20-14", "text": "Shifting the AS curve instead of the AD curve.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('97fe44c8-a6d3-4c78-b3d1-2d14424ec4dc', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Illustrate Cost-Push Inflation with a diagram.', 'Priority: Tier 1 | PYQ Connection: Repeated PYQ (same source as demand-pull question).', 'Diagram Title

Cost-Push Inflation (AD-AS Model)

Axes/Components

X-axis = Real Output/GDP; Y-axis = Price Level. Draw AD curve fixed, AS curve shifting leftward (upward).

What to draw

Original AS₁ intersecting AD at E₁ (price P₁, output Y₁); AS₂ (shifted left/up due to rising costs) intersecting AD at E₂ (price P₂ higher, output Y₂ lower).

What each part represents

The leftward AS shift represents rising production costs (wages, raw materials, energy, indirect taxes) forcing firms to supply less at every price level.

Direction/relationship shown

Price rises AND output falls simultaneously — this combination is a hallmark of cost-push inflation (can contribute to stagflation).

How to explain in exam

Draw the AS shift, note that both price rises and output falls (unlike demand-pull), and list causes (wage-push, imported inflation, supply shocks).

Common labelling mistakes

Failing to show output FALLING alongside the price rise — this is what distinguishes cost-push from demand-pull.', NULL, NULL, NULL, 21, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '2c69d9ea-3e98-4249-8e02-de47b3dbffd7', '{"blocks": [{"id": "principles-of-economics-ii-u1-c21-q", "text": "Illustrate Cost-Push Inflation with a diagram.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c21-1", "bold": true, "text": "Diagram Title", "type": "text", "style": "heading"}, {"id": "poe-u1-c21-2", "text": "Cost-Push Inflation (AD-AS Model)", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c21-3", "bold": true, "text": "Axes/Components", "type": "text", "style": "heading"}, {"id": "poe-u1-c21-4", "type": "formula", "expression": "X-axis = Real Output/GDP; Y-axis = Price Level. Draw AD curve fixed, AS curve shifting leftward (upward)."}, {"id": "poe-u1-c21-5", "bold": true, "text": "What to draw", "type": "text", "style": "heading"}, {"id": "poe-u1-c21-6", "text": "Original AS₁ intersecting AD at E₁ (price P₁, output Y₁); AS₂ (shifted left/up due to rising costs) intersecting AD at E₂ (price P₂ higher, output Y₂ lower).", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c21-7", "bold": true, "text": "What each part represents", "type": "text", "style": "heading"}, {"id": "poe-u1-c21-8", "text": "The leftward AS shift represents rising production costs (wages, raw materials, energy, indirect taxes) forcing firms to supply less at every price level.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c21-9", "bold": true, "text": "Direction/relationship shown", "type": "text", "style": "heading"}, {"id": "poe-u1-c21-10", "text": "Price rises AND output falls simultaneously — this combination is a hallmark of cost-push inflation (can contribute to stagflation).", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c21-11", "bold": true, "text": "How to explain in exam", "type": "text", "style": "heading"}, {"id": "poe-u1-c21-12", "text": "Draw the AS shift, note that both price rises and output falls (unlike demand-pull), and list causes (wage-push, imported inflation, supply shocks).", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c21-13", "bold": true, "text": "Common labelling mistakes", "type": "text", "style": "heading"}, {"id": "poe-u1-c21-14", "text": "Failing to show output FALLING alongside the price rise — this is what distinguishes cost-push from demand-pull.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('f55331c6-81e3-42b5-845f-5dae29dd2ef8', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Distinguish between Headline Inflation and Core Inflation.', 'Priority: Tier 2 | PYQ Connection: Current-syllabus topic not yet seen in supplied PYQs.', 'Headline Inflation: the raw, unadjusted inflation rate based on the full basket of goods and services, including volatile items like food and fuel.
Core Inflation: inflation calculated after excluding volatile items (food and fuel) from the basket, giving a more stable, underlying measure of price trends used by central banks for policy decisions.', NULL, NULL, NULL, 22, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '2c69d9ea-3e98-4249-8e02-de47b3dbffd7', '{"blocks": [{"id": "principles-of-economics-ii-u1-c22-q", "text": "Distinguish between Headline Inflation and Core Inflation.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c22-1", "type": "bulletList", "items": ["Headline Inflation: the raw, unadjusted inflation rate based on the full basket of goods and services, including volatile items like food and fuel.", "Core Inflation: inflation calculated after excluding volatile items (food and fuel) from the basket, giving a more stable, underlying measure of price trends used by central banks for policy decisions."]}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('5d2f6c69-7287-4a22-b04e-cefa2fe1b615', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'What is Hyperinflation? Explain briefly with an example.', 'Priority: Tier 3 | PYQ Connection: Current-syllabus topic not yet seen in supplied PYQs.', 'Hyperinflation is an extremely rapid and out-of-control rise in the general price level — often defined as inflation exceeding 50% per month — where money rapidly loses value and people rush to spend it before prices rise further. Causes typically include excessive money-printing to finance government deficits, collapse of confidence in currency, or severe supply shocks. Classic examples: Weimar Germany (1920s), Zimbabwe (2000s).', NULL, NULL, NULL, 23, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '2c69d9ea-3e98-4249-8e02-de47b3dbffd7', '{"blocks": [{"id": "principles-of-economics-ii-u1-c23-q", "text": "What is Hyperinflation? Explain briefly with an example.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c23-1", "text": "Hyperinflation is an extremely rapid and out-of-control rise in the general price level — often defined as inflation exceeding 50% per month — where money rapidly loses value and people rush to spend it before prices rise further. Causes typically include excessive money-printing to finance government deficits, collapse of confidence in currency, or severe supply shocks. Classic examples: Weimar Germany (1920s), Zimbabwe (2000s).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('81e5d983-d5d0-4200-bda3-cfc8af72c605', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Distinguish between CPI and WPI as price indices.', 'Priority: Tier 2 | PYQ Connection: Current-syllabus topic not yet seen in supplied PYQs, but a classic "compare" style question.', 'Basis | CPI (Consumer Price Index) | WPI (Wholesale Price Index)
Measures | Prices paid by end consumers for a basket of goods/services | Prices at the wholesale/first bulk-transaction level
Includes services? | Yes | No (goods only, in India)
Used for | Measuring cost of living, indexing wages/pensions, RBI''s inflation targeting | Tracking producer/wholesale-level price trends
Published by (India) | Ministry of Statistics (MoSPI) | Ministry of Commerce & Industry', NULL, NULL, NULL, 24, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '2c69d9ea-3e98-4249-8e02-de47b3dbffd7', '{"blocks": [{"id": "principles-of-economics-ii-u1-c24-q", "text": "Distinguish between CPI and WPI as price indices.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c24-1", "rows": [["Basis", "CPI (Consumer Price Index)", "WPI (Wholesale Price Index)"], ["Measures", "Prices paid by end consumers for a basket of goods/services", "Prices at the wholesale/first bulk-transaction level"], ["Includes services?", "Yes", "No (goods only, in India)"], ["Used for", "Measuring cost of living, indexing wages/pensions, RBI''s inflation targeting", "Tracking producer/wholesale-level price trends"], ["Published by (India)", "Ministry of Statistics (MoSPI)", "Ministry of Commerce & Industry"]], "type": "table"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('a446c96a-197b-4b09-8c72-ea431817b284', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the economic impacts of inflation.', 'Priority: Tier 3 | PYQ Connection: Current-syllabus topic not yet seen in supplied PYQs.', 'redistributes wealth from lenders/savers to borrowers (since debt is repaid in cheaper money)
discourages savings and can distort investment decisions
hurts export competitiveness if domestic prices rise faster than trading partners
can create uncertainty that reduces long-term planning and investment
if very high, undermines confidence in the currency itself (hyperinflation risk).', NULL, NULL, NULL, 25, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '2c69d9ea-3e98-4249-8e02-de47b3dbffd7', '{"blocks": [{"id": "principles-of-economics-ii-u1-c25-q", "text": "Explain the economic impacts of inflation.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c25-1", "type": "numberList", "items": ["redistributes wealth from lenders/savers to borrowers (since debt is repaid in cheaper money)", "discourages savings and can distort investment decisions", "hurts export competitiveness if domestic prices rise faster than trading partners", "can create uncertainty that reduces long-term planning and investment", "if very high, undermines confidence in the currency itself (hyperinflation risk)."]}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('46ae6735-81e9-4170-b5e4-94807750d8e7', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Define unemployment and explain its main types.', 'Priority: Tier 2 | PYQ Connection: Current-syllabus topic not yet seen in supplied PYQs directly, but related to Oct 2024 Q1(8) on fiscal policy and unemployment.', 'Unemployment is the situation where people who are willing and able to work, and are actively seeking employment, cannot find jobs.

Main types

Frictional: short-term, from workers transitioning between jobs.
Structural: mismatch between workers'' skills and available jobs (due to technological/industrial change).
Cyclical (Demand-deficient): arises during economic downturns/recessions when aggregate demand falls.
Seasonal: arises in industries with seasonal work patterns (e.g., agriculture, tourism).
Disguised: more people employed than actually needed (common in agriculture) — marginal productivity near zero.', NULL, NULL, NULL, 26, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', 'bd4d35d4-4466-4a48-a45c-d03a6aeeb976', '{"blocks": [{"id": "principles-of-economics-ii-u1-c26-q", "text": "Define unemployment and explain its main types.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c26-1", "text": "Unemployment is the situation where people who are willing and able to work, and are actively seeking employment, cannot find jobs.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c26-2", "bold": true, "text": "Main types", "type": "text", "style": "heading"}, {"id": "poe-u1-c26-3", "type": "bulletList", "items": ["Frictional: short-term, from workers transitioning between jobs.", "Structural: mismatch between workers'' skills and available jobs (due to technological/industrial change).", "Cyclical (Demand-deficient): arises during economic downturns/recessions when aggregate demand falls.", "Seasonal: arises in industries with seasonal work patterns (e.g., agriculture, tourism).", "Disguised: more people employed than actually needed (common in agriculture) — marginal productivity near zero."]}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('9ad17c74-d20b-4318-b01b-8c04bb6b1b99', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'What measures can reduce unemployment?', 'Priority: Tier 2 | PYQ Connection: Related PYQ pattern — Oct 2024 Q1(8) tested "how expansionary fiscal policy impacts unemployment" (MCQ: decreases unemployment).', 'Expansionary fiscal policy — increased government spending/public works to create jobs
expansionary monetary policy — lower interest rates to spur investment and hiring
skill development & vocational training to fix structural mismatches
promoting labour-intensive industries/MSMEs
employment guarantee schemes (e.g., MGNREGA-type programs)
encouraging entrepreneurship and start-ups.', NULL, NULL, NULL, 27, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', 'bd4d35d4-4466-4a48-a45c-d03a6aeeb976', '{"blocks": [{"id": "principles-of-economics-ii-u1-c27-q", "text": "What measures can reduce unemployment?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c27-1", "type": "numberList", "items": ["Expansionary fiscal policy — increased government spending/public works to create jobs", "expansionary monetary policy — lower interest rates to spur investment and hiring", "skill development & vocational training to fix structural mismatches", "promoting labour-intensive industries/MSMEs", "employment guarantee schemes (e.g., MGNREGA-type programs)", "encouraging entrepreneurship and start-ups."]}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('833d4554-047b-4e87-80ab-f8607fe362af', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Illustrate and explain the short-run Phillips Curve.', 'Priority: Tier 1 | PYQ Connection: Repeated PYQ — Oct 2024 Q3-Q asked to "illustrate and explain" it directly (5m), and Q2(4) tested a (false) statement about it in T/F.', 'Diagram Title

Short-Run Phillips Curve

Axes/Components

X-axis = Rate of Unemployment (%); Y-axis = Rate of Inflation (%). Draw a downward-sloping, convex-to-origin curve.

What to draw

A smooth curve sloping down from high inflation/low unemployment (upper left) to low inflation/high unemployment (lower right). Optionally mark a point of movement along the curve to show the trade-off.

What each part represents

The curve shows an inverse relationship between inflation and unemployment in the short run — policies that reduce unemployment (e.g., expansionary demand policy) tend to raise inflation, and vice versa.

Direction/relationship shown

Downward-sloping — trade-off, not a direct relationship (note: the earlier T/F item in Oct 2024, which called it a relationship between "inflation and national income," is FALSE — it is inflation vs. unemployment).

How to explain in exam

State the origin (A.W. Phillips, based on UK wage-inflation and unemployment data), draw the downward curve, explain the short-run trade-off, and briefly note the long-run critique (vertical LR Phillips Curve at the natural rate of unemployment — money illusion disappears, no permanent trade-off).

Common labelling mistakes

Mislabelling the axes (a very common trap — it is Unemployment vs. Inflation, NOT National Income vs. Inflation).', NULL, NULL, NULL, 28, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', 'bd4d35d4-4466-4a48-a45c-d03a6aeeb976', '{"blocks": [{"id": "principles-of-economics-ii-u1-c28-q", "text": "Illustrate and explain the short-run Phillips Curve.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c28-1", "bold": true, "text": "Diagram Title", "type": "text", "style": "heading"}, {"id": "poe-u1-c28-2", "text": "Short-Run Phillips Curve", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c28-3", "bold": true, "text": "Axes/Components", "type": "text", "style": "heading"}, {"id": "poe-u1-c28-4", "type": "formula", "expression": "X-axis = Rate of Unemployment (%); Y-axis = Rate of Inflation (%). Draw a downward-sloping, convex-to-origin curve."}, {"id": "poe-u1-c28-5", "bold": true, "text": "What to draw", "type": "text", "style": "heading"}, {"id": "poe-u1-c28-6", "text": "A smooth curve sloping down from high inflation/low unemployment (upper left) to low inflation/high unemployment (lower right). Optionally mark a point of movement along the curve to show the trade-off.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c28-7", "bold": true, "text": "What each part represents", "type": "text", "style": "heading"}, {"id": "poe-u1-c28-8", "text": "The curve shows an inverse relationship between inflation and unemployment in the short run — policies that reduce unemployment (e.g., expansionary demand policy) tend to raise inflation, and vice versa.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c28-9", "bold": true, "text": "Direction/relationship shown", "type": "text", "style": "heading"}, {"id": "poe-u1-c28-10", "text": "Downward-sloping — trade-off, not a direct relationship (note: the earlier T/F item in Oct 2024, which called it a relationship between \"inflation and national income,\" is FALSE — it is inflation vs. unemployment).", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c28-11", "bold": true, "text": "How to explain in exam", "type": "text", "style": "heading"}, {"id": "poe-u1-c28-12", "text": "State the origin (A.W. Phillips, based on UK wage-inflation and unemployment data), draw the downward curve, explain the short-run trade-off, and briefly note the long-run critique (vertical LR Phillips Curve at the natural rate of unemployment — money illusion disappears, no permanent trade-off).", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c28-13", "bold": true, "text": "Common labelling mistakes", "type": "text", "style": "heading"}, {"id": "poe-u1-c28-14", "text": "Mislabelling the axes (a very common trap — it is Unemployment vs. Inflation, NOT National Income vs. Inflation).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('109cd2c9-30cc-4011-ac8d-36aa52684423', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Define Trade Cycle and explain its phases with a diagram.', 'Priority: Tier 1 | PYQ Connection: Repeated PYQ — Oct 2024 Q3-B directly asked to "define and explain phases" (5m), and Q2(5) tested a T/F statement on cycle sequencing.', 'Diagram Title

Trade Cycle (Business Cycle) Wave

Axes/Components

X-axis = Time; Y-axis = Level of Economic Activity/GDP. Draw a wavy line oscillating around a long-term upward growth trend line.

What to draw

A curve rising to a Peak/Boom, then declining through a Recession, reaching a Trough/Depression, then rising again through Recovery, back up to the next Peak — repeated as a wave pattern around the rising trend line.

What each part represents (phases)

Expansion/Boom/Peak: high output, high employment, rising prices, high investor confidence.
Recession (downturn): economic activity starts declining, demand falls, unemployment starts rising.
Trough/Depression: the lowest point — high unemployment, low output, low confidence, falling prices possible.
Recovery: economic activity starts picking up again, employment and output rise, leading to the next expansion.

Features

trade cycles are recurrent but not identical in length/intensity; they are wave-like and affect nearly all sectors of the economy simultaneously; each phase feeds into the next.

How to explain in exam

Define trade cycle as periodic fluctuations in aggregate economic activity, draw the wave with the four phases clearly marked and labelled on the time axis, then briefly describe each phase in 1–2 lines.

Common labelling mistakes

Drawing a flat oscillation instead of a wave around an upward-sloping long-term trend line (real economies grow over time even while cycling).', NULL, NULL, NULL, 29, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '204c9054-6123-4e35-9947-64abdd38075e', '{"blocks": [{"id": "principles-of-economics-ii-u1-c29-q", "text": "Define Trade Cycle and explain its phases with a diagram.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c29-1", "bold": true, "text": "Diagram Title", "type": "text", "style": "heading"}, {"id": "poe-u1-c29-2", "text": "Trade Cycle (Business Cycle) Wave", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c29-3", "bold": true, "text": "Axes/Components", "type": "text", "style": "heading"}, {"id": "poe-u1-c29-4", "type": "formula", "expression": "X-axis = Time; Y-axis = Level of Economic Activity/GDP. Draw a wavy line oscillating around a long-term upward growth trend line."}, {"id": "poe-u1-c29-5", "bold": true, "text": "What to draw", "type": "text", "style": "heading"}, {"id": "poe-u1-c29-6", "text": "A curve rising to a Peak/Boom, then declining through a Recession, reaching a Trough/Depression, then rising again through Recovery, back up to the next Peak — repeated as a wave pattern around the rising trend line.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c29-7", "bold": true, "text": "What each part represents (phases)", "type": "text", "style": "heading"}, {"id": "poe-u1-c29-8", "type": "numberList", "items": ["Expansion/Boom/Peak: high output, high employment, rising prices, high investor confidence.", "Recession (downturn): economic activity starts declining, demand falls, unemployment starts rising.", "Trough/Depression: the lowest point — high unemployment, low output, low confidence, falling prices possible.", "Recovery: economic activity starts picking up again, employment and output rise, leading to the next expansion."]}, {"id": "poe-u1-c29-9", "bold": true, "text": "Features", "type": "text", "style": "heading"}, {"id": "poe-u1-c29-10", "text": "trade cycles are recurrent but not identical in length/intensity; they are wave-like and affect nearly all sectors of the economy simultaneously; each phase feeds into the next.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c29-11", "bold": true, "text": "How to explain in exam", "type": "text", "style": "heading"}, {"id": "poe-u1-c29-12", "text": "Define trade cycle as periodic fluctuations in aggregate economic activity, draw the wave with the four phases clearly marked and labelled on the time axis, then briefly describe each phase in 1–2 lines.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c29-13", "bold": true, "text": "Common labelling mistakes", "type": "text", "style": "heading"}, {"id": "poe-u1-c29-14", "text": "Drawing a flat oscillation instead of a wave around an upward-sloping long-term trend line (real economies grow over time even while cycling).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('9a03fe9a-695d-43cb-a785-9e0ddf3ed470', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'What are the probable shapes of a trade cycle under Black Swan events? (e.g., V, U, L, W-shaped recoveries)', 'Priority: Tier 2 | PYQ Connection: Current-syllabus topic not yet seen in supplied PYQs — a newer NEP-2020-style addition likely tested via short notes or diagram-labelling.', 'A "Black Swan" event is a rare, unpredictable, high-impact shock (e.g., a pandemic, financial crash) that disrupts the normal trade cycle pattern. Possible resulting shapes:

V-shaped: sharp, sudden fall followed by an equally sharp, quick recovery.
U-shaped: a fall followed by a prolonged period at the bottom before recovery begins.
L-shaped: a sharp fall followed by stagnation at a low level for a long time, with no real recovery — the worst-case shape.
W-shaped (double-dip): a fall, partial recovery, then a second fall, before final recovery.

Example: The COVID-19 shock produced initial fears of an L-shape but many economies saw a K-shaped recovery (different sectors recovering at very different speeds).', NULL, NULL, NULL, 30, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '204c9054-6123-4e35-9947-64abdd38075e', '{"blocks": [{"id": "principles-of-economics-ii-u1-c30-q", "text": "What are the probable shapes of a trade cycle under Black Swan events? (e.g., V, U, L, W-shaped recoveries)", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c30-1", "text": "A \"Black Swan\" event is a rare, unpredictable, high-impact shock (e.g., a pandemic, financial crash) that disrupts the normal trade cycle pattern. Possible resulting shapes:", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c30-2", "type": "bulletList", "items": ["V-shaped: sharp, sudden fall followed by an equally sharp, quick recovery.", "U-shaped: a fall followed by a prolonged period at the bottom before recovery begins.", "L-shaped: a sharp fall followed by stagnation at a low level for a long time, with no real recovery — the worst-case shape.", "W-shaped (double-dip): a fall, partial recovery, then a second fall, before final recovery."]}, {"id": "poe-u1-c30-3", "text": "Example: The COVID-19 shock produced initial fears of an L-shape but many economies saw a K-shaped recovery (different sectors recovering at very different speeds).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('976ce9cd-3c83-481a-97b7-6dfccf6f06d1', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain Supply Side Economics.', 'Priority: Tier 2 | PYQ Connection: Current-syllabus topic not yet seen in supplied PYQs.', 'Supply-Side Economics argues that economic growth is best achieved by focusing on increasing aggregate supply — through lower taxes, deregulation, and incentives for production/investment — rather than only managing aggregate demand (the Keynesian focus). Key ideas: lower marginal tax rates encourage work, saving and investment; reduced regulation lowers the cost of doing business; the Laffer Curve argues that beyond a certain point, higher tax rates can actually reduce total tax revenue by discouraging economic activity. Associated with "Reaganomics" in the 1980s US.', NULL, NULL, NULL, 31, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', 'f387cb75-8347-42d9-87b7-3b7a11c59c36', '{"blocks": [{"id": "principles-of-economics-ii-u1-c31-q", "text": "Explain Supply Side Economics.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c31-1", "text": "Supply-Side Economics argues that economic growth is best achieved by focusing on increasing aggregate supply — through lower taxes, deregulation, and incentives for production/investment — rather than only managing aggregate demand (the Keynesian focus). Key ideas: lower marginal tax rates encourage work, saving and investment; reduced regulation lowers the cost of doing business; the Laffer Curve argues that beyond a certain point, higher tax rates can actually reduce total tax revenue by discouraging economic activity. Associated with \"Reaganomics\" in the 1980s US.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('00d6748f-81d6-4c77-a2d2-9ac5a96f7cd2', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Draw and explain the Laffer Curve (Supply-Side Economics diagram).', 'Priority: Tier 3 | PYQ Connection: Current-syllabus topic not yet seen in supplied PYQs.', 'Diagram Title

The Laffer Curve

Axes/Components

X-axis = Tax Rate (0% to 100%); Y-axis = Total Tax Revenue. Draw an inverted-U (bell-shaped) curve starting and ending at zero revenue (at 0% and 100% tax rates), peaking somewhere in the middle.

What to draw

The bell curve rising from origin (0% tax = 0 revenue), peaking at an optimal tax rate (T*), then declining back to zero revenue at 100% tax rate.

What each part represents

At 0% tax, no revenue is collected; at 100% tax, no one has an incentive to work/produce, so revenue also falls to zero; the peak (T*) is the tax rate that maximizes total revenue.

Direction/relationship shown

Beyond T*, raising tax rates further actually REDUCES total revenue because it discourages economic activity — this is the core supply-side argument for tax cuts.

How to explain in exam

Draw the bell curve, mark T*, and explain that this justifies supply-side policy prescriptions of cutting excessively high tax rates to boost both output and (counter-intuitively) revenue.

Common labelling mistakes

Drawing a straight or U-shaped (not inverted-U) curve.', NULL, NULL, NULL, 32, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', 'f387cb75-8347-42d9-87b7-3b7a11c59c36', '{"blocks": [{"id": "principles-of-economics-ii-u1-c32-q", "text": "Draw and explain the Laffer Curve (Supply-Side Economics diagram).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c32-1", "bold": true, "text": "Diagram Title", "type": "text", "style": "heading"}, {"id": "poe-u1-c32-2", "text": "The Laffer Curve", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c32-3", "bold": true, "text": "Axes/Components", "type": "text", "style": "heading"}, {"id": "poe-u1-c32-4", "type": "formula", "expression": "X-axis = Tax Rate (0% to 100%); Y-axis = Total Tax Revenue. Draw an inverted-U (bell-shaped) curve starting and ending at zero revenue (at 0% and 100% tax rates), peaking somewhere in the middle."}, {"id": "poe-u1-c32-5", "bold": true, "text": "What to draw", "type": "text", "style": "heading"}, {"id": "poe-u1-c32-6", "type": "formula", "expression": "The bell curve rising from origin (0% tax = 0 revenue), peaking at an optimal tax rate (T*), then declining back to zero revenue at 100% tax rate."}, {"id": "poe-u1-c32-7", "bold": true, "text": "What each part represents", "type": "text", "style": "heading"}, {"id": "poe-u1-c32-8", "text": "At 0% tax, no revenue is collected; at 100% tax, no one has an incentive to work/produce, so revenue also falls to zero; the peak (T*) is the tax rate that maximizes total revenue.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c32-9", "bold": true, "text": "Direction/relationship shown", "type": "text", "style": "heading"}, {"id": "poe-u1-c32-10", "text": "Beyond T*, raising tax rates further actually REDUCES total revenue because it discourages economic activity — this is the core supply-side argument for tax cuts.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c32-11", "bold": true, "text": "How to explain in exam", "type": "text", "style": "heading"}, {"id": "poe-u1-c32-12", "text": "Draw the bell curve, mark T*, and explain that this justifies supply-side policy prescriptions of cutting excessively high tax rates to boost both output and (counter-intuitively) revenue.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c32-13", "bold": true, "text": "Common labelling mistakes", "type": "text", "style": "heading"}, {"id": "poe-u1-c32-14", "text": "Drawing a straight or U-shaped (not inverted-U) curve.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('f84cc5f5-716a-4873-8242-7db2d21fe9ba', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Write a short note on the Asian Financial Crisis (1997–98).', 'Priority: Tier 1 | PYQ Connection: Repeated PYQ — appeared as a direct 5-mark "short note" option in Oct 2024 Q5-A.', 'The Asian Financial Crisis began in Thailand in 1997 when the government floated the baht after failing to defend its fixed exchange-rate peg, triggering a currency collapse that spread to Indonesia, South Korea, Malaysia and other East Asian economies.

Causes

excessive short-term foreign borrowing, over-valued pegged exchange rates, weak banking-sector regulation, asset-price bubbles (especially real estate), and sudden reversal of foreign capital inflows ("hot money" flight).

Impact

sharp currency devaluations, stock market crashes, bank failures, deep recessions, and IMF bailout packages with strict conditionality (structural reforms) for the worst-hit countries.

Lesson/link to theory

illustrates how fixed exchange rates combined with short-term foreign debt and weak financial regulation can trigger a crisis — connects to the "Exchange Rate Stability" concern of macroeconomics and the Trade Cycle''s sharp trough/recession phase.', NULL, NULL, NULL, 33, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', 'b7ade618-5f8e-4c7d-91ac-e48c8df02a41', '{"blocks": [{"id": "principles-of-economics-ii-u1-c33-q", "text": "Write a short note on the Asian Financial Crisis (1997–98).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c33-1", "text": "The Asian Financial Crisis began in Thailand in 1997 when the government floated the baht after failing to defend its fixed exchange-rate peg, triggering a currency collapse that spread to Indonesia, South Korea, Malaysia and other East Asian economies.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c33-2", "bold": true, "text": "Causes", "type": "text", "style": "heading"}, {"id": "poe-u1-c33-3", "text": "excessive short-term foreign borrowing, over-valued pegged exchange rates, weak banking-sector regulation, asset-price bubbles (especially real estate), and sudden reversal of foreign capital inflows (\"hot money\" flight).", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c33-4", "bold": true, "text": "Impact", "type": "text", "style": "heading"}, {"id": "poe-u1-c33-5", "text": "sharp currency devaluations, stock market crashes, bank failures, deep recessions, and IMF bailout packages with strict conditionality (structural reforms) for the worst-hit countries.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c33-6", "bold": true, "text": "Lesson/link to theory", "type": "text", "style": "heading"}, {"id": "poe-u1-c33-7", "text": "illustrates how fixed exchange rates combined with short-term foreign debt and weak financial regulation can trigger a crisis — connects to the \"Exchange Rate Stability\" concern of macroeconomics and the Trade Cycle''s sharp trough/recession phase.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('b44e9bea-6f97-4bde-a4d3-a072d715e348', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Write a short note on the Japanese Asset Price Bubble (late 1980s–1990s).', 'Priority: Tier 2 | PYQ Connection: Current-syllabus topic not yet seen in supplied PYQs, but a core case study — likely tested as a short note similar to the Asian Crisis pattern.', 'Japan experienced a massive asset-price (stock market and real estate) bubble in the late 1980s, fuelled by very loose monetary policy, easy credit, and speculative investment. When the Bank of Japan tightened monetary policy in 1989–90, the bubble burst — stock and land prices collapsed. This led to Japan''s "Lost Decade(s)" — prolonged stagnation, deflation, and very slow growth through the 1990s and beyond, with banks burdened by non-performing loans and firms/households focused on paying down debt rather than spending/investing (a classic case of a liquidity trap in practice, and deflationary pressure).', NULL, NULL, NULL, 34, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', 'b7ade618-5f8e-4c7d-91ac-e48c8df02a41', '{"blocks": [{"id": "principles-of-economics-ii-u1-c34-q", "text": "Write a short note on the Japanese Asset Price Bubble (late 1980s–1990s).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c34-1", "text": "Japan experienced a massive asset-price (stock market and real estate) bubble in the late 1980s, fuelled by very loose monetary policy, easy credit, and speculative investment. When the Bank of Japan tightened monetary policy in 1989–90, the bubble burst — stock and land prices collapsed. This led to Japan''s \"Lost Decade(s)\" — prolonged stagnation, deflation, and very slow growth through the 1990s and beyond, with banks burdened by non-performing loans and firms/households focused on paying down debt rather than spending/investing (a classic case of a liquidity trap in practice, and deflationary pressure).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('0e43b9c5-e26c-46d9-8030-ff387e6497d5', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Write a short note on the Sub-Prime Crisis (2007–08).', 'Priority: Tier 1 | PYQ Connection: Related PYQ pattern — same "short note on a case study" format as the Asian Crisis question actually asked (Oct 2024 Q5-A); a high-probability alternative case-study prompt.', 'The 2007–08 U.S. Sub-Prime Crisis originated from excessive lending of high-risk ("sub-prime") mortgages to borrowers with poor creditworthiness, often at low "teaser" interest rates. These mortgages were bundled into complex securities (e.g., mortgage-backed securities, CDOs) and sold globally, masking the underlying risk. When U.S. housing prices fell and borrowers began defaulting en masse, the securities collapsed in value, triggering bank failures (e.g., Lehman Brothers), a global credit freeze, and the worst global recession since the Great Depression.

Impact

massive unemployment, stock market crashes worldwide, government bailouts of banks, and a wave of new financial regulation (e.g., Dodd-Frank Act) post-crisis.

Link to theory

a textbook example of a boom-bust Trade Cycle, and of how deregulated financial markets and asset bubbles can trigger systemic global recession.', NULL, NULL, NULL, 35, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', 'b7ade618-5f8e-4c7d-91ac-e48c8df02a41', '{"blocks": [{"id": "principles-of-economics-ii-u1-c35-q", "text": "Write a short note on the Sub-Prime Crisis (2007–08).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c35-1", "text": "The 2007–08 U.S. Sub-Prime Crisis originated from excessive lending of high-risk (\"sub-prime\") mortgages to borrowers with poor creditworthiness, often at low \"teaser\" interest rates. These mortgages were bundled into complex securities (e.g., mortgage-backed securities, CDOs) and sold globally, masking the underlying risk. When U.S. housing prices fell and borrowers began defaulting en masse, the securities collapsed in value, triggering bank failures (e.g., Lehman Brothers), a global credit freeze, and the worst global recession since the Great Depression.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c35-2", "bold": true, "text": "Impact", "type": "text", "style": "heading"}, {"id": "poe-u1-c35-3", "text": "massive unemployment, stock market crashes worldwide, government bailouts of banks, and a wave of new financial regulation (e.g., Dodd-Frank Act) post-crisis.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c35-4", "bold": true, "text": "Link to theory", "type": "text", "style": "heading"}, {"id": "poe-u1-c35-5", "text": "a textbook example of a boom-bust Trade Cycle, and of how deregulated financial markets and asset bubbles can trigger systemic global recession.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('ff007094-6246-4bcd-90db-c66610804ce9', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'From the following data, calculate APC and MPC at each income level.', 'PYQ Connection: Repeated PYQ — this is the exact dataset from your Oct 2024 (CX3084) paper, Q5-B.', 'Given Data

Income (Y) | Consumption (C)
1000 | 900
2000 | 1600
3000 | 2200
4000 | 2700
5000 | 3100
6000 | 3400

Required

APC (Average Propensity to Consume) and MPC (Marginal Propensity to Consume) at each income level.

Formula

APC = C / Y

MPC = ΔC / ΔY (change in consumption ÷ change in income between two consecutive rows)

Substitution & Calculation

Y | C | ΔY | ΔC | APC = C/Y | MPC = ΔC/ΔY
1000 | 900 | — | — | 900/1000 = 0.90 | —
2000 | 1600 | 1000 | 700 | 1600/2000 = 0.80 | 700/1000 = 0.70
3000 | 2200 | 1000 | 600 | 2200/3000 = 0.73 | 600/1000 = 0.60
4000 | 2700 | 1000 | 500 | 2700/4000 = 0.68 | 500/1000 = 0.50
5000 | 3100 | 1000 | 400 | 3100/5000 = 0.62 | 400/1000 = 0.40
6000 | 3400 | 1000 | 300 | 3400/6000 = 0.57 | 300/1000 = 0.30

Final Answer

APC falls steadily from 0.90 to 0.57; MPC falls steadily from 0.70 to 0.30 as income rises.

Interpretation

Both APC and MPC decline as income rises — this reflects the Keynesian psychological law that as income increases, people consume a progressively smaller proportion of additional income (saving more at the margin). Since MPC < 1 throughout, this data is consistent with a normal consumption function.

Common Mistake

Students often compute MPC using total C/Y instead of the CHANGE (Δ) in C over the CHANGE in Y — always use consecutive-row differences, never totals, for MPC.', NULL, NULL, NULL, 36, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '54318213-a93e-4ad9-9d36-6c964596ab16', '{"blocks": [{"id": "principles-of-economics-ii-u1-c36-q", "text": "From the following data, calculate APC and MPC at each income level.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c36-1", "bold": true, "text": "Given Data", "type": "text", "style": "heading"}, {"id": "poe-u1-c36-2", "rows": [["Income (Y)", "Consumption (C)"], ["1000", "900"], ["2000", "1600"], ["3000", "2200"], ["4000", "2700"], ["5000", "3100"], ["6000", "3400"]], "type": "table"}, {"id": "poe-u1-c36-3", "bold": true, "text": "Required", "type": "text", "style": "heading"}, {"id": "poe-u1-c36-4", "text": "APC (Average Propensity to Consume) and MPC (Marginal Propensity to Consume) at each income level.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c36-5", "bold": true, "text": "Formula", "type": "text", "style": "heading"}, {"id": "poe-u1-c36-6", "type": "formula", "expression": "APC = C / Y"}, {"id": "poe-u1-c36-7", "type": "formula", "expression": "MPC = ΔC / ΔY (change in consumption ÷ change in income between two consecutive rows)"}, {"id": "poe-u1-c36-8", "bold": true, "text": "Substitution & Calculation", "type": "text", "style": "heading"}, {"id": "poe-u1-c36-9", "rows": [["Y", "C", "ΔY", "ΔC", "APC = C/Y", "MPC = ΔC/ΔY"], ["1000", "900", "—", "—", "900/1000 = 0.90", "—"], ["2000", "1600", "1000", "700", "1600/2000 = 0.80", "700/1000 = 0.70"], ["3000", "2200", "1000", "600", "2200/3000 = 0.73", "600/1000 = 0.60"], ["4000", "2700", "1000", "500", "2700/4000 = 0.68", "500/1000 = 0.50"], ["5000", "3100", "1000", "400", "3100/5000 = 0.62", "400/1000 = 0.40"], ["6000", "3400", "1000", "300", "3400/6000 = 0.57", "300/1000 = 0.30"]], "type": "table"}, {"id": "poe-u1-c36-10", "bold": true, "text": "Final Answer", "type": "text", "style": "heading"}, {"id": "poe-u1-c36-11", "text": "APC falls steadily from 0.90 to 0.57; MPC falls steadily from 0.70 to 0.30 as income rises.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c36-12", "bold": true, "text": "Interpretation", "type": "text", "style": "heading"}, {"id": "poe-u1-c36-13", "text": "Both APC and MPC decline as income rises — this reflects the Keynesian psychological law that as income increases, people consume a progressively smaller proportion of additional income (saving more at the margin). Since MPC < 1 throughout, this data is consistent with a normal consumption function.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c36-14", "bold": true, "text": "Common Mistake", "type": "text", "style": "heading"}, {"id": "poe-u1-c36-15", "text": "Students often compute MPC using total C/Y instead of the CHANGE (Δ) in C over the CHANGE in Y — always use consecutive-row differences, never totals, for MPC.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('7d6a7d4e-7500-40b6-b89e-5eae065dae19', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Define APC and MPC, and calculate them from the following table.', 'PYQ Connection: Repeated PYQ — this is the exact dataset from your SEM-end paper, Q1(2).', 'Given Data

Income (Y) | Consumption (C)
100 | 95
200 | 180
300 | 255
400 | 320
500 | 380
600 | 435
700 | 485
800 | 530
900 | 570
1000 | 610

Required

Definitions of APC & MPC, plus APC and MPC at each income level.

Formula

APC = C/Y; MPC = ΔC/ΔY

Substitution & Calculation

Y | C | ΔY | ΔC | APC | MPC
100 | 95 | — | — | 0.950 | —
200 | 180 | 100 | 85 | 0.900 | 0.85
300 | 255 | 100 | 75 | 0.850 | 0.75
400 | 320 | 100 | 65 | 0.800 | 0.65
500 | 380 | 100 | 60 | 0.760 | 0.60
600 | 435 | 100 | 55 | 0.725 | 0.55
700 | 485 | 100 | 50 | 0.693 | 0.50
800 | 530 | 100 | 45 | 0.663 | 0.45
900 | 570 | 100 | 40 | 0.633 | 0.40
1000 | 610 | 100 | 40 | 0.610 | 0.40

Final Answer

APC declines steadily from 0.95 to 0.61; MPC declines from 0.85 down to 0.40, flattening at the last step.

Interpretation

The consistent decline in both APC and MPC as income rises confirms the diminishing propensity to consume — savings rise as a share of income at higher income levels. The flattening of MPC toward the end (0.40 twice in a row) suggests consumption growth is stabilizing at higher income levels.

Common Mistake

Forgetting that APC has NO value in the first row''s "MPC" column (MPC needs two data points) — leave it blank or write "N/A," don''t guess a number.', NULL, NULL, NULL, 37, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '54318213-a93e-4ad9-9d36-6c964596ab16', '{"blocks": [{"id": "principles-of-economics-ii-u1-c37-q", "text": "Define APC and MPC, and calculate them from the following table.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c37-1", "bold": true, "text": "Given Data", "type": "text", "style": "heading"}, {"id": "poe-u1-c37-2", "rows": [["Income (Y)", "Consumption (C)"], ["100", "95"], ["200", "180"], ["300", "255"], ["400", "320"], ["500", "380"], ["600", "435"], ["700", "485"], ["800", "530"], ["900", "570"], ["1000", "610"]], "type": "table"}, {"id": "poe-u1-c37-3", "bold": true, "text": "Required", "type": "text", "style": "heading"}, {"id": "poe-u1-c37-4", "text": "Definitions of APC & MPC, plus APC and MPC at each income level.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c37-5", "bold": true, "text": "Formula", "type": "text", "style": "heading"}, {"id": "poe-u1-c37-6", "type": "formula", "expression": "APC = C/Y; MPC = ΔC/ΔY"}, {"id": "poe-u1-c37-7", "bold": true, "text": "Substitution & Calculation", "type": "text", "style": "heading"}, {"id": "poe-u1-c37-8", "rows": [["Y", "C", "ΔY", "ΔC", "APC", "MPC"], ["100", "95", "—", "—", "0.950", "—"], ["200", "180", "100", "85", "0.900", "0.85"], ["300", "255", "100", "75", "0.850", "0.75"], ["400", "320", "100", "65", "0.800", "0.65"], ["500", "380", "100", "60", "0.760", "0.60"], ["600", "435", "100", "55", "0.725", "0.55"], ["700", "485", "100", "50", "0.693", "0.50"], ["800", "530", "100", "45", "0.663", "0.45"], ["900", "570", "100", "40", "0.633", "0.40"], ["1000", "610", "100", "40", "0.610", "0.40"]], "type": "table"}, {"id": "poe-u1-c37-9", "bold": true, "text": "Final Answer", "type": "text", "style": "heading"}, {"id": "poe-u1-c37-10", "text": "APC declines steadily from 0.95 to 0.61; MPC declines from 0.85 down to 0.40, flattening at the last step.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c37-11", "bold": true, "text": "Interpretation", "type": "text", "style": "heading"}, {"id": "poe-u1-c37-12", "text": "The consistent decline in both APC and MPC as income rises confirms the diminishing propensity to consume — savings rise as a share of income at higher income levels. The flattening of MPC toward the end (0.40 twice in a row) suggests consumption growth is stabilizing at higher income levels.", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c37-13", "bold": true, "text": "Common Mistake", "type": "text", "style": "heading"}, {"id": "poe-u1-c37-14", "text": "Forgetting that APC has NO value in the first row''s \"MPC\" column (MPC needs two data points) — leave it blank or write \"N/A,\" don''t guess a number.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('5edae465-c357-45ee-bd50-6abecf9098a8', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'If MPC = 0.75, calculate the value of the Investment Multiplier. If Investment increases by ₹200 crore, what will be the resulting increase in National Income?', 'PYQ Connection: Related PYQ pattern — builds directly on the multiplier formula tested as T/F in Oct 2024 Q2(3); numerical application of the same formula is a natural extension likely to be tested.', 'Given Data

MPC = 0.75; ΔI = ₹200 crore

Required

Multiplier (k) and resulting ΔY

Formula

k = 1 / (1 − MPC); ΔY = k × ΔI

Substitution

k = 1 / (1 − 0.75) = 1 / 0.25

Calculation

k = 4

ΔY = 4 × 200 = ₹800 crore

Final Answer

Multiplier = 4; Increase in National Income = ₹800 crore.

Interpretation

Every ₹1 crore of new investment ultimately generates ₹4 crore of additional national income, because each round of spending becomes someone else''s income, a fraction (MPC = 0.75) of which is re-spent in successive rounds, until the effect dies out.

Common Mistake

Using MPS (1−MPC) instead of MPC in the denominator setup, or forgetting to invert (1/(1−MPC), not just (1−MPC)) — always double-check the formula is k = 1/(1−MPC) = 1/MPS.', NULL, NULL, NULL, 38, true, 'University Exam', NULL, NULL, NULL, '3e6244af-d898-4c20-ae02-002974402f34', '54318213-a93e-4ad9-9d36-6c964596ab16', '{"blocks": [{"id": "principles-of-economics-ii-u1-c38-q", "text": "If MPC = 0.75, calculate the value of the Investment Multiplier. If Investment increases by ₹200 crore, what will be the resulting increase in National Income?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u1-c38-1", "bold": true, "text": "Given Data", "type": "text", "style": "heading"}, {"id": "poe-u1-c38-2", "type": "formula", "expression": "MPC = 0.75; ΔI = ₹200 crore"}, {"id": "poe-u1-c38-3", "bold": true, "text": "Required", "type": "text", "style": "heading"}, {"id": "poe-u1-c38-4", "text": "Multiplier (k) and resulting ΔY", "type": "text", "style": "paragraph"}, {"id": "poe-u1-c38-5", "bold": true, "text": "Formula", "type": "text", "style": "heading"}, {"id": "poe-u1-c38-6", "type": "formula", "expression": "k = 1 / (1 − MPC); ΔY = k × ΔI"}, {"id": "poe-u1-c38-7", "bold": true, "text": "Substitution", "type": "text", "style": "heading"}, {"id": "poe-u1-c38-8", "type": "formula", "expression": "k = 1 / (1 − 0.75) = 1 / 0.25"}, {"id": "poe-u1-c38-9", "bold": true, "text": "Calculation", "type": "text", "style": "heading"}, {"id": "poe-u1-c38-10", "type": "formula", "expression": "k = 4"}, {"id": "poe-u1-c38-11", "type": "formula", "expression": "ΔY = 4 × 200 = ₹800 crore"}, {"id": "poe-u1-c38-12", "bold": true, "text": "Final Answer", "type": "text", "style": "heading"}, {"id": "poe-u1-c38-13", "type": "formula", "expression": "Multiplier = 4; Increase in National Income = ₹800 crore."}, {"id": "poe-u1-c38-14", "bold": true, "text": "Interpretation", "type": "text", "style": "heading"}, {"id": "poe-u1-c38-15", "type": "formula", "expression": "Every ₹1 crore of new investment ultimately generates ₹4 crore of additional national income, because each round of spending becomes someone else''s income, a fraction (MPC = 0.75) of which is re-spent in successive rounds, until the effect dies out."}, {"id": "poe-u1-c38-16", "bold": true, "text": "Common Mistake", "type": "text", "style": "heading"}, {"id": "poe-u1-c38-17", "type": "formula", "expression": "Using MPS (1−MPC) instead of MPC in the denominator setup, or forgetting to invert (1/(1−MPC), not just (1−MPC)) — always double-check the formula is k = 1/(1−MPC) = 1/MPS."}], "version": 1}'::jsonb, '2026-09-21 16:58:04.302356+00', '2026-09-21 16:58:04.302356+00'),
('0424229c-b9bf-4293-845c-655c5938c050', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Define Monetary Policy and discuss its primary objectives.', 'Priority: Tier 1 | PYQ Connection: Repeated — directly asked as a 5-mark "define and discuss objectives" question in Oct 2024 Q4-A, and Q1(6) tested "who is the central monetary policy authority in India" (Answer: RBI).', 'Monetary Policy is the policy formulated and implemented by a country''s central bank (RBI in India) to regulate the supply of money and credit in the economy, primarily through interest rates, in order to achieve macroeconomic goals.

Primary objectives

Price stability — controlling inflation within a target range.
Economic growth — ensuring adequate credit availability to support output and employment.
Exchange rate stability — managing currency volatility.
Financial stability — maintaining a sound banking/financial system.
Full employment — supporting conditions for job creation via credit availability.', NULL, NULL, NULL, 1, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '071e61ef-4a0a-474e-b6ec-fd9a9f9f9ee8', '{"blocks": [{"id": "principles-of-economics-ii-u2-c1-q", "text": "Define Monetary Policy and discuss its primary objectives.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c1-1", "text": "Monetary Policy is the policy formulated and implemented by a country''s central bank (RBI in India) to regulate the supply of money and credit in the economy, primarily through interest rates, in order to achieve macroeconomic goals.", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c1-2", "bold": true, "text": "Primary objectives", "type": "text", "style": "heading"}, {"id": "poe-u2-c1-3", "type": "numberList", "items": ["Price stability — controlling inflation within a target range.", "Economic growth — ensuring adequate credit availability to support output and employment.", "Exchange rate stability — managing currency volatility.", "Financial stability — maintaining a sound banking/financial system.", "Full employment — supporting conditions for job creation via credit availability."]}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('22691c6a-388d-4839-bb53-8cf84469ec8f', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the tools/instruments of Monetary Policy.', 'Priority: Tier 1 | PYQ Connection: Related pattern — objectives were directly tested (Q4-A); tools are the natural companion and a high-probability extension.', 'Quantitative (general) tools — affect the overall volume of credit:

Repo Rate — rate at which RBI lends short-term funds to banks.
Reverse Repo Rate — rate at which RBI borrows from banks.
Cash Reserve Ratio (CRR) — % of deposits banks must hold as reserves with RBI.
Statutory Liquidity Ratio (SLR) — % of deposits banks must hold in approved liquid assets (cash, gold, government securities).
Open Market Operations (OMO) — RBI buying/selling government securities to inject/absorb liquidity.
Bank Rate — the rate at which RBI lends long-term funds to banks.

Qualitative (selective) tools — direct credit toward/away from specific sectors:

Margin requirements, moral suasion, direct action, credit rationing.', NULL, NULL, NULL, 2, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '071e61ef-4a0a-474e-b6ec-fd9a9f9f9ee8', '{"blocks": [{"id": "principles-of-economics-ii-u2-c2-q", "text": "Explain the tools/instruments of Monetary Policy.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c2-1", "text": "Quantitative (general) tools — affect the overall volume of credit:", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c2-2", "type": "bulletList", "items": ["Repo Rate — rate at which RBI lends short-term funds to banks.", "Reverse Repo Rate — rate at which RBI borrows from banks.", "Cash Reserve Ratio (CRR) — % of deposits banks must hold as reserves with RBI.", "Statutory Liquidity Ratio (SLR) — % of deposits banks must hold in approved liquid assets (cash, gold, government securities).", "Open Market Operations (OMO) — RBI buying/selling government securities to inject/absorb liquidity.", "Bank Rate — the rate at which RBI lends long-term funds to banks."]}, {"id": "poe-u2-c2-3", "text": "Qualitative (selective) tools — direct credit toward/away from specific sectors:", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c2-4", "type": "bulletList", "items": ["Margin requirements, moral suasion, direct action, credit rationing."]}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('0a4b061d-f0a1-4c19-b9e1-7913a156418d', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the different approaches to Monetary Policy.', 'Priority: Tier 2 | PYQ Connection: Current syllabus — not yet seen directly in supplied PYQs, but a natural companion to the "objectives" question already asked.', 'Monetary Targeting — central bank sets and pursues a target growth rate for money supply.
Inflation Targeting — central bank sets an explicit inflation rate target (India follows a flexible inflation targeting framework, currently targeting CPI inflation within a band, administered by the Monetary Policy Committee).
Exchange Rate Targeting — central bank manages monetary policy to maintain a target exchange rate.
Multiple Indicator Approach — RBI''s earlier approach (pre-2015), considering a broad set of indicators (money supply, credit, output, trade, capital flows, inflation, fiscal deficit) rather than a single target.', NULL, NULL, NULL, 3, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '071e61ef-4a0a-474e-b6ec-fd9a9f9f9ee8', '{"blocks": [{"id": "principles-of-economics-ii-u2-c3-q", "text": "Explain the different approaches to Monetary Policy.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c3-1", "type": "numberList", "items": ["Monetary Targeting — central bank sets and pursues a target growth rate for money supply.", "Inflation Targeting — central bank sets an explicit inflation rate target (India follows a flexible inflation targeting framework, currently targeting CPI inflation within a band, administered by the Monetary Policy Committee).", "Exchange Rate Targeting — central bank manages monetary policy to maintain a target exchange rate.", "Multiple Indicator Approach — RBI''s earlier approach (pre-2015), considering a broad set of indicators (money supply, credit, output, trade, capital flows, inflation, fiscal deficit) rather than a single target."]}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('a64e6bd0-3cb2-4a20-bdc7-4bbc8872117d', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the Monetary Policy process/formulation mechanism in India.', 'Priority: Tier 2 | PYQ Connection: Current syllabus — not yet seen in supplied PYQs; likely tested as a "discuss the process" or short-note style question given the explicit syllabus heading.', 'Assessment — RBI''s research/policy departments assess current macroeconomic conditions (inflation, growth, liquidity, external sector).
Deliberation by the Monetary Policy Committee (MPC) — a 6-member body (3 RBI + 3 external members) meets periodically (bi-monthly) to decide the policy repo rate, voting by majority.
Announcement — the decision (rate change or status quo) is publicly announced along with a policy statement/rationale.
Transmission — the rate decision is transmitted through the banking system (bank lending/deposit rates), affecting credit availability, investment, consumption and ultimately inflation/growth.
Review — outcomes are monitored and feed into the next policy cycle.', NULL, NULL, NULL, 4, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '071e61ef-4a0a-474e-b6ec-fd9a9f9f9ee8', '{"blocks": [{"id": "principles-of-economics-ii-u2-c4-q", "text": "Explain the Monetary Policy process/formulation mechanism in India.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c4-1", "type": "numberList", "items": ["Assessment — RBI''s research/policy departments assess current macroeconomic conditions (inflation, growth, liquidity, external sector).", "Deliberation by the Monetary Policy Committee (MPC) — a 6-member body (3 RBI + 3 external members) meets periodically (bi-monthly) to decide the policy repo rate, voting by majority.", "Announcement — the decision (rate change or status quo) is publicly announced along with a policy statement/rationale.", "Transmission — the rate decision is transmitted through the banking system (bank lending/deposit rates), affecting credit availability, investment, consumption and ultimately inflation/growth.", "Review — outcomes are monitored and feed into the next policy cycle."]}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('46e67d16-1c7b-463c-90f6-31dcf0bac2f9', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the concept of High-Powered Money (H).', 'Priority: Tier 1 | PYQ Connection: Repeated — Oct 2024 Q1(7) directly asked "High-Powered money includes..." as an MCQ (correct answer: "Currency in circulation and reserves held by banks").', 'High-Powered Money (also called the Monetary Base or Reserve Money) is the total liability of the central bank/government that directly backs the money supply. It consists of currency in circulation (with the public and in bank vaults) + reserves held by commercial banks with the central bank (both required and excess reserves). It is called "high-powered" because each unit of it can generate a multiple expansion of the total money supply through the credit-creation process of commercial banks.

Formula

H = Currency with Public (C) + Bank Reserves (R)', NULL, NULL, NULL, 5, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '071e61ef-4a0a-474e-b6ec-fd9a9f9f9ee8', '{"blocks": [{"id": "principles-of-economics-ii-u2-c5-q", "text": "Explain the concept of High-Powered Money (H).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c5-1", "text": "High-Powered Money (also called the Monetary Base or Reserve Money) is the total liability of the central bank/government that directly backs the money supply. It consists of currency in circulation (with the public and in bank vaults) + reserves held by commercial banks with the central bank (both required and excess reserves). It is called \"high-powered\" because each unit of it can generate a multiple expansion of the total money supply through the credit-creation process of commercial banks.", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c5-2", "bold": true, "text": "Formula", "type": "text", "style": "heading"}, {"id": "poe-u2-c5-3", "type": "formula", "expression": "H = Currency with Public (C) + Bank Reserves (R)"}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('1c21e585-38ee-4976-aed1-e39c77640237', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the Money Multiplier and its relationship with High-Powered Money.', 'Priority: Tier 2 | PYQ Connection: Current syllabus — related to the High-Powered Money MCQ already tested, but the multiplier itself has no direct PYQ evidence yet.', 'The Money Multiplier (m) shows how many times the total Money Supply (M) is a multiple of High-Powered Money (H) — i.e., how much total money the banking system creates from each unit of base money, through repeated rounds of deposit creation and lending.

Formula

M = m × H, where m = 1/CRR (simplified case), or more precisely m = (1 + Currency-Deposit Ratio) / (Currency-Deposit Ratio + Reserve-Deposit Ratio)

Relationship with High-Powered Money

H is the base/input; the Money Multiplier is the amplification factor; Total Money Supply is the output. A higher CRR (or higher public preference for holding cash rather than deposits) reduces the multiplier, since less money is available for banks to re-lend at each round.', NULL, NULL, NULL, 6, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '071e61ef-4a0a-474e-b6ec-fd9a9f9f9ee8', '{"blocks": [{"id": "principles-of-economics-ii-u2-c6-q", "text": "Explain the Money Multiplier and its relationship with High-Powered Money.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c6-1", "text": "The Money Multiplier (m) shows how many times the total Money Supply (M) is a multiple of High-Powered Money (H) — i.e., how much total money the banking system creates from each unit of base money, through repeated rounds of deposit creation and lending.", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c6-2", "bold": true, "text": "Formula", "type": "text", "style": "heading"}, {"id": "poe-u2-c6-3", "type": "formula", "expression": "M = m × H, where m = 1/CRR (simplified case), or more precisely m = (1 + Currency-Deposit Ratio) / (Currency-Deposit Ratio + Reserve-Deposit Ratio)"}, {"id": "poe-u2-c6-4", "bold": true, "text": "Relationship with High-Powered Money", "type": "text", "style": "heading"}, {"id": "poe-u2-c6-5", "text": "H is the base/input; the Money Multiplier is the amplification factor; Total Money Supply is the output. A higher CRR (or higher public preference for holding cash rather than deposits) reduces the multiplier, since less money is available for banks to re-lend at each round.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('c6e6cb58-6f74-44e1-85e9-71b1bb25c375', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'If the Cash Reserve Ratio (CRR) is 10% and High-Powered Money is ₹500 crore, calculate the simple Money Multiplier and the resulting Total Money Supply (assuming the simplified case with no currency drain).', 'PYQ Connection: Current syllabus — not yet seen in supplied PYQs; included because Money Multiplier numericals are a standard, syllabus-supported examination pattern in Macroeconomics courses generally.', 'Given Data

CRR = 10% = 0.10; H = ₹500 crore

Required

Money Multiplier (m) and Total Money Supply (M)

Formula

m = 1/CRR; M = m × H

Substitution

m = 1 / 0.10

Calculation

m = 10

M = 10 × 500 = ₹5,000 crore

Final Answer

Money Multiplier = 10; Total Money Supply = ₹5,000 crore.

Interpretation

Every ₹1 crore of high-powered money (base money) supports ₹10 crore of total money supply in the banking system, because banks repeatedly re-lend the portion of deposits not held back as reserves.

Common Mistake

Using CRR directly as the multiplier (e.g., writing m = CRR = 0.10) instead of its reciprocal (m = 1/CRR) — always invert the ratio.', NULL, NULL, NULL, 7, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '071e61ef-4a0a-474e-b6ec-fd9a9f9f9ee8', '{"blocks": [{"id": "principles-of-economics-ii-u2-c7-q", "text": "If the Cash Reserve Ratio (CRR) is 10% and High-Powered Money is ₹500 crore, calculate the simple Money Multiplier and the resulting Total Money Supply (assuming the simplified case with no currency drain).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c7-1", "bold": true, "text": "Given Data", "type": "text", "style": "heading"}, {"id": "poe-u2-c7-2", "type": "formula", "expression": "CRR = 10% = 0.10; H = ₹500 crore"}, {"id": "poe-u2-c7-3", "bold": true, "text": "Required", "type": "text", "style": "heading"}, {"id": "poe-u2-c7-4", "text": "Money Multiplier (m) and Total Money Supply (M)", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c7-5", "bold": true, "text": "Formula", "type": "text", "style": "heading"}, {"id": "poe-u2-c7-6", "type": "formula", "expression": "m = 1/CRR; M = m × H"}, {"id": "poe-u2-c7-7", "bold": true, "text": "Substitution", "type": "text", "style": "heading"}, {"id": "poe-u2-c7-8", "type": "formula", "expression": "m = 1 / 0.10"}, {"id": "poe-u2-c7-9", "bold": true, "text": "Calculation", "type": "text", "style": "heading"}, {"id": "poe-u2-c7-10", "type": "formula", "expression": "m = 10"}, {"id": "poe-u2-c7-11", "type": "formula", "expression": "M = 10 × 500 = ₹5,000 crore"}, {"id": "poe-u2-c7-12", "bold": true, "text": "Final Answer", "type": "text", "style": "heading"}, {"id": "poe-u2-c7-13", "type": "formula", "expression": "Money Multiplier = 10; Total Money Supply = ₹5,000 crore."}, {"id": "poe-u2-c7-14", "bold": true, "text": "Interpretation", "type": "text", "style": "heading"}, {"id": "poe-u2-c7-15", "text": "Every ₹1 crore of high-powered money (base money) supports ₹10 crore of total money supply in the banking system, because banks repeatedly re-lend the portion of deposits not held back as reserves.", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c7-16", "bold": true, "text": "Common Mistake", "type": "text", "style": "heading"}, {"id": "poe-u2-c7-17", "type": "formula", "expression": "Using CRR directly as the multiplier (e.g., writing m = CRR = 0.10) instead of its reciprocal (m = 1/CRR) — always invert the ratio."}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('50dd5c70-7bed-4629-a94a-00cbc9d3de3d', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the process of Credit Creation by commercial banks.', 'Priority: Tier 2 | PYQ Connection: Current syllabus — not yet seen in supplied PYQs, but directly follows from the High-Powered Money question already tested.', 'Commercial banks create credit (money) beyond the initial deposit through repeated lending, since they are required to keep only a fraction of deposits as reserves (CRR) and can lend out the rest.

Process (simplified example)

A bank receives a primary deposit of ₹1,000, keeps 10% (₹100) as reserve, and lends out ₹900. That ₹900, when spent and re-deposited elsewhere in the banking system, again has 10% held back and 90% re-lent — and so on, in successive rounds, until the reserve requirement exhausts the process.

Total credit created = Initial Deposit × (1/CRR) — i.e., governed by the same multiplier logic as the money multiplier.', NULL, NULL, NULL, 8, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '071e61ef-4a0a-474e-b6ec-fd9a9f9f9ee8', '{"blocks": [{"id": "principles-of-economics-ii-u2-c8-q", "text": "Explain the process of Credit Creation by commercial banks.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c8-1", "text": "Commercial banks create credit (money) beyond the initial deposit through repeated lending, since they are required to keep only a fraction of deposits as reserves (CRR) and can lend out the rest.", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c8-2", "bold": true, "text": "Process (simplified example)", "type": "text", "style": "heading"}, {"id": "poe-u2-c8-3", "text": "A bank receives a primary deposit of ₹1,000, keeps 10% (₹100) as reserve, and lends out ₹900. That ₹900, when spent and re-deposited elsewhere in the banking system, again has 10% held back and 90% re-lent — and so on, in successive rounds, until the reserve requirement exhausts the process.", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c8-4", "type": "formula", "expression": "Total credit created = Initial Deposit × (1/CRR) — i.e., governed by the same multiplier logic as the money multiplier."}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('6aa2705a-f71e-4ad7-a882-66a49ddc59bf', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Distinguish between Expansionary and Contractionary Monetary Policy.', 'Priority: Tier 1 | PYQ Connection: Repeated PYQ trap — Oct 2024 Q2(8) tested "Expansionary monetary policy helps in controlling inflation" as True/False; this statement is FALSE — it is contractionary monetary policy that controls inflation.', 'Basis | Expansionary Monetary Policy | Contractionary Monetary Policy
Aim | Boost growth/employment (used in slowdown) | Control inflation (used when prices rising too fast)
Interest rates | Lowered (repo rate cut) | Raised (repo rate hike)
CRR/SLR | Lowered | Raised
Effect on money supply | Increases | Decreases
Effect on aggregate demand | Increases | Decreases', NULL, NULL, NULL, 9, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '071e61ef-4a0a-474e-b6ec-fd9a9f9f9ee8', '{"blocks": [{"id": "principles-of-economics-ii-u2-c9-q", "text": "Distinguish between Expansionary and Contractionary Monetary Policy.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c9-1", "rows": [["Basis", "Expansionary Monetary Policy", "Contractionary Monetary Policy"], ["Aim", "Boost growth/employment (used in slowdown)", "Control inflation (used when prices rising too fast)"], ["Interest rates", "Lowered (repo rate cut)", "Raised (repo rate hike)"], ["CRR/SLR", "Lowered", "Raised"], ["Effect on money supply", "Increases", "Decreases"], ["Effect on aggregate demand", "Increases", "Decreases"]], "type": "table"}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('4dc35322-f1b2-4a48-bada-43903c77dd3d', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Discuss the role of Monetary Policy in stabilising the economy.', 'Priority: Tier 2 | PYQ Connection: Related pattern — Oct 2024 Q2(10) tested (as True) that "Monetary policy and fiscal policy both help in controlling business cycle."', 'Monetary policy stabilises the economy by adjusting interest rates and money supply counter-cyclically: during a slowdown/recession, an expansionary stance (rate cuts, CRR cuts, OMO purchases) boosts credit availability, investment and consumption, pulling the economy out of the trough. During an overheating/inflationary phase, a contractionary stance (rate hikes, CRR hikes, OMO sales) cools down demand and controls inflation. This counter-cyclical adjustment helps smooth the amplitude of the Trade Cycle and supports price stability alongside sustainable growth.', NULL, NULL, NULL, 10, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '071e61ef-4a0a-474e-b6ec-fd9a9f9f9ee8', '{"blocks": [{"id": "principles-of-economics-ii-u2-c10-q", "text": "Discuss the role of Monetary Policy in stabilising the economy.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c10-1", "text": "Monetary policy stabilises the economy by adjusting interest rates and money supply counter-cyclically: during a slowdown/recession, an expansionary stance (rate cuts, CRR cuts, OMO purchases) boosts credit availability, investment and consumption, pulling the economy out of the trough. During an overheating/inflationary phase, a contractionary stance (rate hikes, CRR hikes, OMO sales) cools down demand and controls inflation. This counter-cyclical adjustment helps smooth the amplitude of the Trade Cycle and supports price stability alongside sustainable growth.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('82249b70-eb53-482e-844d-aac23c78d4da', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Define Fiscal Policy and discuss its objectives.', 'Priority: Tier 1 | PYQ Connection: Repeated — directly asked as a 7.5-mark question in the SEM-end paper: "Fiscal policy uses taxation and public expenditure for stabilization and growth — give the objectives of fiscal policy."', 'Fiscal Policy is the use of government spending (expenditure) and taxation (revenue) by the government to influence the level of economic activity, achieve stabilization, and pursue growth and equity goals.

Objectives

Economic growth — via public investment in infrastructure, capital formation.
Price stability — managing aggregate demand through taxation/spending adjustments.
Full employment — generating jobs through public expenditure/works programs.
Equitable distribution of income and wealth — via progressive taxation and welfare/subsidy spending.
Economic stabilization — smoothing business-cycle fluctuations (counter-cyclical fiscal stance).
Balanced regional development.', NULL, NULL, NULL, 11, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '859830f6-8e30-415d-b0db-259102569681', '{"blocks": [{"id": "principles-of-economics-ii-u2-c11-q", "text": "Define Fiscal Policy and discuss its objectives.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c11-1", "text": "Fiscal Policy is the use of government spending (expenditure) and taxation (revenue) by the government to influence the level of economic activity, achieve stabilization, and pursue growth and equity goals.", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c11-2", "bold": true, "text": "Objectives", "type": "text", "style": "heading"}, {"id": "poe-u2-c11-3", "type": "numberList", "items": ["Economic growth — via public investment in infrastructure, capital formation.", "Price stability — managing aggregate demand through taxation/spending adjustments.", "Full employment — generating jobs through public expenditure/works programs.", "Equitable distribution of income and wealth — via progressive taxation and welfare/subsidy spending.", "Economic stabilization — smoothing business-cycle fluctuations (counter-cyclical fiscal stance).", "Balanced regional development."]}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('221268f4-1222-49e3-8d4c-f4fa302d8e5c', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the tools/instruments of Fiscal Policy.', 'Priority: Tier 2 | PYQ Connection: Related pattern — flows naturally from the "objectives" question already directly tested (SEM-end paper).', 'Taxation — direct and indirect taxes, used to raise revenue and influence disposable income/spending.
Public Expenditure — government spending on infrastructure, welfare, subsidies, defence, etc., directly injecting demand into the economy.
Public Borrowing/Debt — financing deficits through domestic/external borrowing.
Public/Government Budget — the overall framework combining revenue and expenditure decisions.
Deficit Financing — printing money or borrowing from the central bank to cover a fiscal shortfall (used cautiously due to inflationary risk).', NULL, NULL, NULL, 12, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '859830f6-8e30-415d-b0db-259102569681', '{"blocks": [{"id": "principles-of-economics-ii-u2-c12-q", "text": "Explain the tools/instruments of Fiscal Policy.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c12-1", "type": "numberList", "items": ["Taxation — direct and indirect taxes, used to raise revenue and influence disposable income/spending.", "Public Expenditure — government spending on infrastructure, welfare, subsidies, defence, etc., directly injecting demand into the economy.", "Public Borrowing/Debt — financing deficits through domestic/external borrowing.", "Public/Government Budget — the overall framework combining revenue and expenditure decisions.", "Deficit Financing — printing money or borrowing from the central bank to cover a fiscal shortfall (used cautiously due to inflationary risk)."]}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('878fc8a0-6219-4d76-89d3-9e349f805161', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain Exchange Rate Management by Central Banks.', 'Priority: Tier 2 | PYQ Connection: Current syllabus — not yet seen directly in supplied PYQs, but a natural extension of the forex-market question already tested.', 'Central banks manage exchange rates to maintain stability, competitiveness and confidence in the domestic currency, since excessive volatility can disrupt trade, investment and inflation control.

Basic mechanisms

Direct intervention — buying/selling foreign currency reserves in the forex market to influence the exchange rate (e.g., RBI selling dollars to support a weakening rupee).
Interest rate adjustments — raising interest rates can attract foreign capital inflows, strengthening the domestic currency.
Forex reserve management — maintaining adequate reserves to intervene when necessary and signal stability to markets.
Exchange rate regime choice — managing along a spectrum from fully fixed to freely floating (most major economies, including India, follow a managed float system).

Relationship with exchange-rate stability

This function directly serves one of the four core concerns of macroeconomics (from Module 1) — exchange rate stability — by preventing excessive currency volatility that could harm trade competitiveness and investor confidence.', NULL, NULL, NULL, 26, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '99024031-4209-41f5-af32-27cb35e75320', '{"blocks": [{"id": "principles-of-economics-ii-u2-c26-q", "text": "Explain Exchange Rate Management by Central Banks.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c26-1", "text": "Central banks manage exchange rates to maintain stability, competitiveness and confidence in the domestic currency, since excessive volatility can disrupt trade, investment and inflation control.", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c26-2", "bold": true, "text": "Basic mechanisms", "type": "text", "style": "heading"}, {"id": "poe-u2-c26-3", "type": "numberList", "items": ["Direct intervention — buying/selling foreign currency reserves in the forex market to influence the exchange rate (e.g., RBI selling dollars to support a weakening rupee).", "Interest rate adjustments — raising interest rates can attract foreign capital inflows, strengthening the domestic currency.", "Forex reserve management — maintaining adequate reserves to intervene when necessary and signal stability to markets.", "Exchange rate regime choice — managing along a spectrum from fully fixed to freely floating (most major economies, including India, follow a managed float system)."]}, {"id": "poe-u2-c26-4", "bold": true, "text": "Relationship with exchange-rate stability", "type": "text", "style": "heading"}, {"id": "poe-u2-c26-5", "text": "This function directly serves one of the four core concerns of macroeconomics (from Module 1) — exchange rate stability — by preventing excessive currency volatility that could harm trade competitiveness and investor confidence.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('7fb366e6-0ff5-4e99-a384-21c3fda3dda3', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the types of Fiscal Policy.', 'Priority: Tier 1 | PYQ Connection: Repeated pattern — Oct 2024 Q1(8) directly tested "How might an expansionary fiscal policy impact unemployment?" (MCQ: correct answer — decrease unemployment).', 'Expansionary Fiscal Policy: increased government spending and/or reduced taxes, used to boost aggregate demand during a slowdown/recession — leads to a larger fiscal deficit.
Contractionary Fiscal Policy: reduced government spending and/or increased taxes, used to cool down an overheating economy or control inflation — reduces the fiscal deficit.
Neutral Fiscal Policy: government spending is fully funded by revenue with no net demand impact (balanced budget stance).', NULL, NULL, NULL, 13, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '859830f6-8e30-415d-b0db-259102569681', '{"blocks": [{"id": "principles-of-economics-ii-u2-c13-q", "text": "Explain the types of Fiscal Policy.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c13-1", "type": "bulletList", "items": ["Expansionary Fiscal Policy: increased government spending and/or reduced taxes, used to boost aggregate demand during a slowdown/recession — leads to a larger fiscal deficit.", "Contractionary Fiscal Policy: reduced government spending and/or increased taxes, used to cool down an overheating economy or control inflation — reduces the fiscal deficit.", "Neutral Fiscal Policy: government spending is fully funded by revenue with no net demand impact (balanced budget stance)."]}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('8a05c32c-55de-4ac9-b50f-fc8fa920d1ab', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Discuss the limitations of Fiscal Policy.', 'Priority: Tier 3 | PYQ Connection: Current syllabus — not yet seen directly in supplied PYQs.', 'Implementation lags — legislative/administrative delays in changing taxes or spending
Political constraints — tax cuts/hikes are politically sensitive and slow to enact
Crowding-out effect — government borrowing can raise interest rates and reduce private investment
Risk of rising public debt — persistent deficits can lead to unsustainable debt burdens
Inflationary risk from deficit financing
Difficulty in precise demand management — hard to fine-tune spending/tax changes to exactly match the economy''s needs.', NULL, NULL, NULL, 14, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '859830f6-8e30-415d-b0db-259102569681', '{"blocks": [{"id": "principles-of-economics-ii-u2-c14-q", "text": "Discuss the limitations of Fiscal Policy.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c14-1", "type": "numberList", "items": ["Implementation lags — legislative/administrative delays in changing taxes or spending", "Political constraints — tax cuts/hikes are politically sensitive and slow to enact", "Crowding-out effect — government borrowing can raise interest rates and reduce private investment", "Risk of rising public debt — persistent deficits can lead to unsustainable debt burdens", "Inflationary risk from deficit financing", "Difficulty in precise demand management — hard to fine-tune spending/tax changes to exactly match the economy''s needs."]}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('c6ac4397-060e-4002-87cc-02fa1b027cba', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the types of taxes (Direct vs Indirect).', 'Priority: Tier 1 | PYQ Connection: Repeated — SEM-end paper directly asked "Summarise the types of taxation" (7.5m).', 'Basis | Direct Tax | Indirect Tax
Who bears it | Paid directly by the person/entity on whom it is levied (cannot be shifted) | Levied on goods/services; burden can be shifted to another party (e.g., consumer)
Examples | Income Tax, Corporate Tax, Wealth Tax | GST, Customs Duty, Excise Duty
Progressivity | Usually progressive (higher earners pay more) | Usually regressive (same rate regardless of income)
Collection point | From the taxpayer directly | Collected via sellers/producers, passed to consumers', NULL, NULL, NULL, 15, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '859830f6-8e30-415d-b0db-259102569681', '{"blocks": [{"id": "principles-of-economics-ii-u2-c15-q", "text": "Explain the types of taxes (Direct vs Indirect).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c15-1", "rows": [["Basis", "Direct Tax", "Indirect Tax"], ["Who bears it", "Paid directly by the person/entity on whom it is levied (cannot be shifted)", "Levied on goods/services; burden can be shifted to another party (e.g., consumer)"], ["Examples", "Income Tax, Corporate Tax, Wealth Tax", "GST, Customs Duty, Excise Duty"], ["Progressivity", "Usually progressive (higher earners pay more)", "Usually regressive (same rate regardless of income)"], ["Collection point", "From the taxpayer directly", "Collected via sellers/producers, passed to consumers"]], "type": "table"}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('4597945b-bc62-4695-9e66-6efaedc30b27', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Distinguish clearly between Tax Impact, Tax Incidence, and Shifting of Tax.', 'Priority: Tier 2 | PYQ Connection: Current syllabus — not yet seen directly in supplied PYQs, but explicitly named in the current syllabus as a distinct sub-topic and highly confusable — a strong candidate for a "distinguish" question.', 'Impact of Tax: refers to the point of initial (legal) imposition of a tax — who the tax is levied ON (i.e., who is legally liable to pay it to the government).
Shifting of Tax: the process by which the burden of a tax is transferred from the person who initially pays it (impact) to another party — e.g., a producer shifting a tax onto consumers via higher prices.
Incidence of Tax: refers to who ultimately bears the real economic burden of the tax after all shifting has occurred — i.e., where the burden finally "rests."

Simple example

A tax is levied on a manufacturer (impact = manufacturer). The manufacturer raises the product''s price (shifting). The consumer ends up paying more (incidence = consumer).', NULL, NULL, NULL, 16, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '859830f6-8e30-415d-b0db-259102569681', '{"blocks": [{"id": "principles-of-economics-ii-u2-c16-q", "text": "Distinguish clearly between Tax Impact, Tax Incidence, and Shifting of Tax.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c16-1", "type": "bulletList", "items": ["Impact of Tax: refers to the point of initial (legal) imposition of a tax — who the tax is levied ON (i.e., who is legally liable to pay it to the government).", "Shifting of Tax: the process by which the burden of a tax is transferred from the person who initially pays it (impact) to another party — e.g., a producer shifting a tax onto consumers via higher prices.", "Incidence of Tax: refers to who ultimately bears the real economic burden of the tax after all shifting has occurred — i.e., where the burden finally \"rests.\""]}, {"id": "poe-u2-c16-2", "bold": true, "text": "Simple example", "type": "text", "style": "heading"}, {"id": "poe-u2-c16-3", "type": "formula", "expression": "A tax is levied on a manufacturer (impact = manufacturer). The manufacturer raises the product''s price (shifting). The consumer ends up paying more (incidence = consumer)."}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('5e6dd682-a6c9-4ab5-b1dc-19a8590e3d82', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the types of Public Expenditure with examples.', 'Priority: Tier 2 | PYQ Connection: Repeated PYQ trap — Oct 2024 Q2(9) tested "Capital expenditure includes the expenditure on salaries of the government employees" as True/False; this is FALSE — salaries are Revenue Expenditure, not Capital Expenditure.', 'Revenue Expenditure: recurring expenditure that does not create assets — e.g., salaries of government employees, pensions, interest payments, subsidies.
Capital Expenditure: expenditure that creates long-term physical or financial assets — e.g., building roads, bridges, schools, hospitals; investment in public sector enterprises.
Developmental Expenditure: spending directly aimed at economic development — e.g., infrastructure, education, health.
Non-Developmental Expenditure: spending on general administration, defence, debt-servicing, law and order.

Economic significance

Capital expenditure builds productive capacity and future growth; revenue expenditure supports current administration and welfare but does not add to the asset base; the mix between the two indicates the quality of government spending.', NULL, NULL, NULL, 17, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '859830f6-8e30-415d-b0db-259102569681', '{"blocks": [{"id": "principles-of-economics-ii-u2-c17-q", "text": "Explain the types of Public Expenditure with examples.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c17-1", "type": "bulletList", "items": ["Revenue Expenditure: recurring expenditure that does not create assets — e.g., salaries of government employees, pensions, interest payments, subsidies.", "Capital Expenditure: expenditure that creates long-term physical or financial assets — e.g., building roads, bridges, schools, hospitals; investment in public sector enterprises.", "Developmental Expenditure: spending directly aimed at economic development — e.g., infrastructure, education, health.", "Non-Developmental Expenditure: spending on general administration, defence, debt-servicing, law and order."]}, {"id": "poe-u2-c17-2", "bold": true, "text": "Economic significance", "type": "text", "style": "heading"}, {"id": "poe-u2-c17-3", "text": "Capital expenditure builds productive capacity and future growth; revenue expenditure supports current administration and welfare but does not add to the asset base; the mix between the two indicates the quality of government spending.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('421ba2ce-b381-480d-817c-c45d2590afb0', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the types of Public Debt and why governments borrow.', 'Priority: Tier 3 | PYQ Connection: Current syllabus — not yet seen in supplied PYQs.', 'Why governments borrow

to finance fiscal deficits (when expenditure exceeds revenue), fund infrastructure/development projects, and manage short-term cash-flow mismatches.

Types of Public Debt

Internal Debt: borrowed from within the country (banks, financial institutions, citizens via government bonds/securities).
External Debt: borrowed from foreign governments, international institutions (IMF, World Bank) or foreign markets.
Marketable Debt: freely tradable securities (e.g., government bonds).
Non-Marketable Debt: not tradable (e.g., small savings schemes, provident funds).
Short-term vs Long-term Debt: classified by maturity period.

Economic implications

rising public debt increases future interest-payment burdens (revenue expenditure), can crowd out private investment, and — if excessive — threatens fiscal sustainability and credit ratings; however, productive borrowing (for capital expenditure) can support long-term growth.', NULL, NULL, NULL, 18, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '859830f6-8e30-415d-b0db-259102569681', '{"blocks": [{"id": "principles-of-economics-ii-u2-c18-q", "text": "Explain the types of Public Debt and why governments borrow.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c18-1", "bold": true, "text": "Why governments borrow", "type": "text", "style": "heading"}, {"id": "poe-u2-c18-2", "text": "to finance fiscal deficits (when expenditure exceeds revenue), fund infrastructure/development projects, and manage short-term cash-flow mismatches.", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c18-3", "bold": true, "text": "Types of Public Debt", "type": "text", "style": "heading"}, {"id": "poe-u2-c18-4", "type": "bulletList", "items": ["Internal Debt: borrowed from within the country (banks, financial institutions, citizens via government bonds/securities).", "External Debt: borrowed from foreign governments, international institutions (IMF, World Bank) or foreign markets.", "Marketable Debt: freely tradable securities (e.g., government bonds).", "Non-Marketable Debt: not tradable (e.g., small savings schemes, provident funds).", "Short-term vs Long-term Debt: classified by maturity period."]}, {"id": "poe-u2-c18-5", "bold": true, "text": "Economic implications", "type": "text", "style": "heading"}, {"id": "poe-u2-c18-6", "text": "rising public debt increases future interest-payment burdens (revenue expenditure), can crowd out private investment, and — if excessive — threatens fiscal sustainability and credit ratings; however, productive borrowing (for capital expenditure) can support long-term growth.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('6ac0c0ac-7430-44e1-86b3-df051e58267c', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the meaning, types and preparation of the Government Budget.', 'Priority: Tier 1 | PYQ Connection: Repeated — Oct 2024 Q4-Q directly asked "Discuss various types of Budget" (5m), and Q1(9) tested the definition of a Deficit Budget as an MCQ.', 'Meaning

A Budget is the government''s annual financial statement showing estimated receipts and expenditure for the coming fiscal year.

Types

Balanced Budget: estimated revenue = estimated expenditure.
Surplus Budget: estimated revenue > estimated expenditure.
Deficit Budget: estimated expenditure > estimated revenue (government spends more than it earns).
Further classified by deficit measure: Revenue Deficit, Fiscal Deficit, Primary Deficit.

Preparation (broad process)

(i) estimation of receipts (tax + non-tax revenue) by ministries/departments, (ii) estimation of expenditure needs across ministries, (iii) consolidation by the Finance Ministry, (iv) presentation in Parliament, (v) discussion and approval, (vi) implementation through the fiscal year.', NULL, NULL, NULL, 19, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '859830f6-8e30-415d-b0db-259102569681', '{"blocks": [{"id": "principles-of-economics-ii-u2-c19-q", "text": "Explain the meaning, types and preparation of the Government Budget.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c19-1", "bold": true, "text": "Meaning", "type": "text", "style": "heading"}, {"id": "poe-u2-c19-2", "text": "A Budget is the government''s annual financial statement showing estimated receipts and expenditure for the coming fiscal year.", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c19-3", "bold": true, "text": "Types", "type": "text", "style": "heading"}, {"id": "poe-u2-c19-4", "type": "bulletList", "items": ["Balanced Budget: estimated revenue = estimated expenditure.", "Surplus Budget: estimated revenue > estimated expenditure.", "Deficit Budget: estimated expenditure > estimated revenue (government spends more than it earns).", "Further classified by deficit measure: Revenue Deficit, Fiscal Deficit, Primary Deficit."]}, {"id": "poe-u2-c19-5", "bold": true, "text": "Preparation (broad process)", "type": "text", "style": "heading"}, {"id": "poe-u2-c19-6", "text": "(i) estimation of receipts (tax + non-tax revenue) by ministries/departments, (ii) estimation of expenditure needs across ministries, (iii) consolidation by the Finance Ministry, (iv) presentation in Parliament, (v) discussion and approval, (vi) implementation through the fiscal year.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('85ab4aac-0e3f-490c-a727-2bc4cd7cc3f9', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Write a short note on FRBM (Fiscal Responsibility and Budget Management).', 'Priority: Tier 2 | PYQ Connection: Current syllabus — not yet seen in supplied PYQs, but explicitly named as a syllabus sub-topic and a natural short-note candidate.', 'The FRBM framework is a fiscal-discipline mechanism requiring the government to set and adhere to targets for reducing fiscal deficit and public debt over time, ensuring long-term macroeconomic and fiscal stability.

Purpose/Key objective

to prevent unchecked government borrowing, maintain inter-generational equity in fiscal management, improve transparency in fiscal operations, and build investor/market confidence in the government''s fiscal management.

Relevance to fiscal discipline

it institutionalises a rules-based approach (deficit/debt ceiling targets) rather than leaving fiscal decisions purely discretionary, though targets are sometimes relaxed during exceptional circumstances (e.g., economic shocks) via an "escape clause."', NULL, NULL, NULL, 20, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '859830f6-8e30-415d-b0db-259102569681', '{"blocks": [{"id": "principles-of-economics-ii-u2-c20-q", "text": "Write a short note on FRBM (Fiscal Responsibility and Budget Management).", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c20-1", "text": "The FRBM framework is a fiscal-discipline mechanism requiring the government to set and adhere to targets for reducing fiscal deficit and public debt over time, ensuring long-term macroeconomic and fiscal stability.", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c20-2", "bold": true, "text": "Purpose/Key objective", "type": "text", "style": "heading"}, {"id": "poe-u2-c20-3", "text": "to prevent unchecked government borrowing, maintain inter-generational equity in fiscal management, improve transparency in fiscal operations, and build investor/market confidence in the government''s fiscal management.", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c20-4", "bold": true, "text": "Relevance to fiscal discipline", "type": "text", "style": "heading"}, {"id": "poe-u2-c20-5", "text": "it institutionalises a rules-based approach (deficit/debt ceiling targets) rather than leaving fiscal decisions purely discretionary, though targets are sometimes relaxed during exceptional circumstances (e.g., economic shocks) via an \"escape clause.\"", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('dc054861-a4f0-475f-bd77-1cdb50de719e', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Discuss the role of Fiscal Policy in stabilising markets/the economy.', 'Priority: Tier 2 | PYQ Connection: Related pattern — Q2(7) and Q2(10) (Oct 2024) tested fiscal policy''s role in employment and business-cycle control as True/False (both True).', 'Fiscal policy stabilises the economy by adjusting government spending and taxation counter-cyclically: during a recession/slowdown, an expansionary stance (higher spending, tax cuts) boosts aggregate demand, output and employment; during an inflationary/overheating phase, a contractionary stance (lower spending, higher taxes) cools down demand. Fiscal policy is often considered especially important when monetary policy becomes ineffective (e.g., in a liquidity trap), since government spending directly injects demand regardless of interest-rate conditions.', NULL, NULL, NULL, 21, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '859830f6-8e30-415d-b0db-259102569681', '{"blocks": [{"id": "principles-of-economics-ii-u2-c21-q", "text": "Discuss the role of Fiscal Policy in stabilising markets/the economy.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c21-1", "text": "Fiscal policy stabilises the economy by adjusting government spending and taxation counter-cyclically: during a recession/slowdown, an expansionary stance (higher spending, tax cuts) boosts aggregate demand, output and employment; during an inflationary/overheating phase, a contractionary stance (lower spending, higher taxes) cools down demand. Fiscal policy is often considered especially important when monetary policy becomes ineffective (e.g., in a liquidity trap), since government spending directly injects demand regardless of interest-rate conditions.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('2d285a3c-8d84-4fa1-b157-6b9a3cd63a88', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Distinguish between Monetary Policy and Fiscal Policy.', 'Priority: Tier 1 | PYQ Connection: Repeated PYQ trap — Oct 2024 Q2(6) tested "Income tax rate is a tool of monetary policy" as True/False; this is FALSE — income tax is a fiscal policy tool.', 'Basis | Monetary Policy | Fiscal Policy
Formulated by | Central Bank (RBI) | Government (Finance Ministry)
Main tools | Interest rates, CRR, SLR, OMO | Taxation, public expenditure, borrowing
Speed of implementation | Relatively faster (policy rate changes quickly) | Slower (requires legislative/budgetary process)
Primary target | Money supply, inflation, credit conditions | Aggregate demand, growth, equity, deficit
Effectiveness in liquidity trap | Weak/ineffective | Remains effective', NULL, NULL, NULL, 22, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '859830f6-8e30-415d-b0db-259102569681', '{"blocks": [{"id": "principles-of-economics-ii-u2-c22-q", "text": "Distinguish between Monetary Policy and Fiscal Policy.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c22-1", "rows": [["Basis", "Monetary Policy", "Fiscal Policy"], ["Formulated by", "Central Bank (RBI)", "Government (Finance Ministry)"], ["Main tools", "Interest rates, CRR, SLR, OMO", "Taxation, public expenditure, borrowing"], ["Speed of implementation", "Relatively faster (policy rate changes quickly)", "Slower (requires legislative/budgetary process)"], ["Primary target", "Money supply, inflation, credit conditions", "Aggregate demand, growth, equity, deficit"], ["Effectiveness in liquidity trap", "Weak/ineffective", "Remains effective"]], "type": "table"}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('b3769363-501a-4c3a-8e4d-0beb56109c48', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Compare Free Trade and Protectionism, and discuss the advantages of Protectionism.', 'Priority: Tier 1 | PYQ Connection: Repeated — Oct 2024 Q4-B directly asked "Explain the advantages of protectionism" (5m); SEM-end paper Q2(3) directly asked to "compare the advantage of free trade to that of protectionism" (7.5m).', 'Basis | Free Trade | Protectionism
Meaning | Trade between countries with minimal government restrictions (no/low tariffs, quotas) | Trade restricted via tariffs, quotas, subsidies to protect domestic industry
Main tools | None/minimal (open borders) | Tariffs, import quotas, subsidies to local producers, licensing
Arguments in favour | Efficient resource allocation via comparative advantage, wider consumer choice, lower prices, promotes competition/innovation | Protects infant/domestic industries, safeguards domestic employment, reduces reliance on imports (self-sufficiency), protects national security-sensitive sectors, corrects trade imbalances
Limitations | Can harm domestic industries unable to compete globally; job losses in import-competing sectors | Raises consumer prices, invites retaliation from trade partners, can breed inefficiency in protected industries, restricts consumer choice
Suitable example | India''s post-1991 trade liberalization | Tariffs on select imports to protect domestic manufacturing (e.g., infant industry protection)

Advantages of Protectionism (focused list)

(i) shields infant/domestic industries from foreign competition until they mature, (ii) preserves domestic employment in vulnerable sectors, (iii) supports national security by maintaining critical domestic production capacity, (iv) can improve the trade balance by reducing import dependence, (v) generates government revenue via tariffs.', NULL, NULL, NULL, 23, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '8817ec65-c8d9-42fc-b8ed-f975847e9acc', '{"blocks": [{"id": "principles-of-economics-ii-u2-c23-q", "text": "Compare Free Trade and Protectionism, and discuss the advantages of Protectionism.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c23-1", "rows": [["Basis", "Free Trade", "Protectionism"], ["Meaning", "Trade between countries with minimal government restrictions (no/low tariffs, quotas)", "Trade restricted via tariffs, quotas, subsidies to protect domestic industry"], ["Main tools", "None/minimal (open borders)", "Tariffs, import quotas, subsidies to local producers, licensing"], ["Arguments in favour", "Efficient resource allocation via comparative advantage, wider consumer choice, lower prices, promotes competition/innovation", "Protects infant/domestic industries, safeguards domestic employment, reduces reliance on imports (self-sufficiency), protects national security-sensitive sectors, corrects trade imbalances"], ["Limitations", "Can harm domestic industries unable to compete globally; job losses in import-competing sectors", "Raises consumer prices, invites retaliation from trade partners, can breed inefficiency in protected industries, restricts consumer choice"], ["Suitable example", "India''s post-1991 trade liberalization", "Tariffs on select imports to protect domestic manufacturing (e.g., infant industry protection)"]], "type": "table"}, {"id": "poe-u2-c23-2", "bold": true, "text": "Advantages of Protectionism (focused list)", "type": "text", "style": "heading"}, {"id": "poe-u2-c23-3", "text": "(i) shields infant/domestic industries from foreign competition until they mature, (ii) preserves domestic employment in vulnerable sectors, (iii) supports national security by maintaining critical domestic production capacity, (iv) can improve the trade balance by reducing import dependence, (v) generates government revenue via tariffs.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('a0bbc3e7-6413-4f9e-95df-b2fb25e2c16a', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the meaning, features and functions of the Foreign Exchange Market.', 'Priority: Tier 1 | PYQ Connection: Repeated — Oct 2024 Q4-P directly asked "Explain the key features and functions of foreign exchange markets" (5m), and Q1(10) independently tested "primary characteristic of the foreign exchange market" as an MCQ (correct answer: Decentralized OTC trading).', 'Meaning

The Foreign Exchange (Forex) Market is the global marketplace where currencies of different countries are bought and sold, determining exchange rates between currencies.

Key features

Decentralized, Over-the-Counter (OTC) structure — no single centralized physical exchange; trading happens electronically/directly between participants worldwide.
Operates 24 hours across global time zones.
Extremely high liquidity and trading volume.
Prices (exchange rates) determined by demand and supply of currencies.

Functions

Transfer of purchasing power across countries (facilitating international trade/payments).
Provision of credit for international trade transactions.
Hedging function — allows businesses to protect against exchange-rate risk (via forwards, options, etc.).
Arbitrage function — enables profit-making from exchange-rate differences across markets, which helps keep rates aligned globally.', NULL, NULL, NULL, 24, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '99024031-4209-41f5-af32-27cb35e75320', '{"blocks": [{"id": "principles-of-economics-ii-u2-c24-q", "text": "Explain the meaning, features and functions of the Foreign Exchange Market.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c24-1", "bold": true, "text": "Meaning", "type": "text", "style": "heading"}, {"id": "poe-u2-c24-2", "text": "The Foreign Exchange (Forex) Market is the global marketplace where currencies of different countries are bought and sold, determining exchange rates between currencies.", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c24-3", "bold": true, "text": "Key features", "type": "text", "style": "heading"}, {"id": "poe-u2-c24-4", "type": "bulletList", "items": ["Decentralized, Over-the-Counter (OTC) structure — no single centralized physical exchange; trading happens electronically/directly between participants worldwide.", "Operates 24 hours across global time zones.", "Extremely high liquidity and trading volume.", "Prices (exchange rates) determined by demand and supply of currencies."]}, {"id": "poe-u2-c24-5", "bold": true, "text": "Functions", "type": "text", "style": "heading"}, {"id": "poe-u2-c24-6", "type": "numberList", "items": ["Transfer of purchasing power across countries (facilitating international trade/payments).", "Provision of credit for international trade transactions.", "Hedging function — allows businesses to protect against exchange-rate risk (via forwards, options, etc.).", "Arbitrage function — enables profit-making from exchange-rate differences across markets, which helps keep rates aligned globally."]}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('ff153924-c8f8-431d-907c-8b3d0c4b2f0e', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'Explain the types of participants in the Foreign Exchange Market.', 'Priority: Tier 2 | PYQ Connection: Related pattern — a natural extension of the "features and functions" question directly tested in Oct 2024 (Q4-P).', 'Commercial Banks — the largest players, handling most forex transactions for clients and themselves.
Central Banks — intervene to manage/stabilise their currency''s exchange rate (e.g., RBI in India).
Businesses/Corporations — engaged in international trade, needing forex for imports/exports and hedging.
Individuals/Tourists — smaller-scale currency conversion needs.
Forex Brokers/Dealers — intermediaries facilitating transactions between parties.
Speculators and Arbitrageurs — trade purely to profit from exchange-rate movements/differences, adding liquidity to the market.', NULL, NULL, NULL, 25, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '99024031-4209-41f5-af32-27cb35e75320', '{"blocks": [{"id": "principles-of-economics-ii-u2-c25-q", "text": "Explain the types of participants in the Foreign Exchange Market.", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c25-1", "type": "numberList", "items": ["Commercial Banks — the largest players, handling most forex transactions for clients and themselves.", "Central Banks — intervene to manage/stabilise their currency''s exchange rate (e.g., RBI in India).", "Businesses/Corporations — engaged in international trade, needing forex for imports/exports and hedging.", "Individuals/Tourists — smaller-scale currency conversion needs.", "Forex Brokers/Dealers — intermediaries facilitating transactions between parties.", "Speculators and Arbitrageurs — trade purely to profit from exchange-rate movements/differences, adding liquidity to the market."]}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('1a1c20ae-91db-47c6-adb5-e2ea9b8fd15a', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'What is the Economic Survey, and how does it relate to the Union Budget?', 'Priority: Tier 3 | PYQ Connection: Current syllabus — not yet seen in supplied PYQs; a newer case-study addition likely tested via short note.', 'What it is

The Economic Survey is an annual document prepared by the Finance Ministry (under the Chief Economic Adviser), presented to Parliament typically just before the Union Budget. It reviews the performance of the economy over the past year and outlines the economic outlook/challenges ahead.

Why relevant to macroeconomic policy

It provides the analytical/data foundation on which the Union Budget''s fiscal policy choices (spending priorities, tax proposals, deficit targets) are based — essentially the "diagnosis" before the Budget''s "prescription."

Syllabus concept demonstrated

Fiscal Policy formulation and the Budget process.

Key exam points

sequencing (Survey → Budget), its role in setting the context/rationale for fiscal decisions, and its function as a transparency/accountability tool for economic policy-making.

Possible exam question

"Explain the relationship between the Economic Survey and the Union Budget." (5-mark, application/short-note style)', NULL, NULL, NULL, 27, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '60a4adf3-4f1a-4efd-8048-5cdc46834585', '{"blocks": [{"id": "principles-of-economics-ii-u2-c27-q", "text": "What is the Economic Survey, and how does it relate to the Union Budget?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c27-1", "bold": true, "text": "What it is", "type": "text", "style": "heading"}, {"id": "poe-u2-c27-2", "text": "The Economic Survey is an annual document prepared by the Finance Ministry (under the Chief Economic Adviser), presented to Parliament typically just before the Union Budget. It reviews the performance of the economy over the past year and outlines the economic outlook/challenges ahead.", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c27-3", "bold": true, "text": "Why relevant to macroeconomic policy", "type": "text", "style": "heading"}, {"id": "poe-u2-c27-4", "text": "It provides the analytical/data foundation on which the Union Budget''s fiscal policy choices (spending priorities, tax proposals, deficit targets) are based — essentially the \"diagnosis\" before the Budget''s \"prescription.\"", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c27-5", "bold": true, "text": "Syllabus concept demonstrated", "type": "text", "style": "heading"}, {"id": "poe-u2-c27-6", "text": "Fiscal Policy formulation and the Budget process.", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c27-7", "bold": true, "text": "Key exam points", "type": "text", "style": "heading"}, {"id": "poe-u2-c27-8", "text": "sequencing (Survey → Budget), its role in setting the context/rationale for fiscal decisions, and its function as a transparency/accountability tool for economic policy-making.", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c27-9", "bold": true, "text": "Possible exam question", "type": "text", "style": "heading"}, {"id": "poe-u2-c27-10", "text": "\"Explain the relationship between the Economic Survey and the Union Budget.\" (5-mark, application/short-note style)", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('c1f98234-f526-4aba-91ed-28688da8f748', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'What is Gender Budgeting, and why is it significant in macroeconomic policy?', 'Priority: Tier 3 | PYQ Connection: Current syllabus — not yet seen in supplied PYQs.', 'What it is

Gender Budgeting is the practice of analysing government budgets/fiscal policy through a gender lens — assessing how spending and revenue decisions affect women and men differently, and allocating resources toward closing gender gaps (e.g., in education, health, employment, financial inclusion).

Why relevant

It reflects the equity/distributional objective of fiscal policy (one of the core objectives of fiscal policy discussed earlier in this module) — ensuring public expenditure promotes inclusive and equitable development, not just aggregate growth.

Syllabus concept demonstrated

Fiscal Policy objectives (equitable distribution) and Public Expenditure allocation.

Key exam points

it is a tool/approach to budgeting (not a separate budget), often implemented through a dedicated "Gender Budget Statement" within the Union Budget documents, tracking gender-specific and gender-sensitive allocations across ministries.

Possible exam question

"Write a short note on Gender Budgeting and its significance." (5-mark short note)', NULL, NULL, NULL, 28, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '60a4adf3-4f1a-4efd-8048-5cdc46834585', '{"blocks": [{"id": "principles-of-economics-ii-u2-c28-q", "text": "What is Gender Budgeting, and why is it significant in macroeconomic policy?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c28-1", "bold": true, "text": "What it is", "type": "text", "style": "heading"}, {"id": "poe-u2-c28-2", "text": "Gender Budgeting is the practice of analysing government budgets/fiscal policy through a gender lens — assessing how spending and revenue decisions affect women and men differently, and allocating resources toward closing gender gaps (e.g., in education, health, employment, financial inclusion).", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c28-3", "bold": true, "text": "Why relevant", "type": "text", "style": "heading"}, {"id": "poe-u2-c28-4", "text": "It reflects the equity/distributional objective of fiscal policy (one of the core objectives of fiscal policy discussed earlier in this module) — ensuring public expenditure promotes inclusive and equitable development, not just aggregate growth.", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c28-5", "bold": true, "text": "Syllabus concept demonstrated", "type": "text", "style": "heading"}, {"id": "poe-u2-c28-6", "text": "Fiscal Policy objectives (equitable distribution) and Public Expenditure allocation.", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c28-7", "bold": true, "text": "Key exam points", "type": "text", "style": "heading"}, {"id": "poe-u2-c28-8", "text": "it is a tool/approach to budgeting (not a separate budget), often implemented through a dedicated \"Gender Budget Statement\" within the Union Budget documents, tracking gender-specific and gender-sensitive allocations across ministries.", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c28-9", "bold": true, "text": "Possible exam question", "type": "text", "style": "heading"}, {"id": "poe-u2-c28-10", "text": "\"Write a short note on Gender Budgeting and its significance.\" (5-mark short note)", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('afa08978-eee8-4a41-b347-415861751ecf', '5c93c785-bc3e-4489-969c-9ec5f21c174a', 'flashcard', 'What is the "Recent MPC" (Monetary Policy Committee) case study meant to illustrate?', 'Priority: Tier 3 | PYQ Connection: Current syllabus — not yet seen in supplied PYQs, but structurally connects directly to the already-tested "central monetary policy authority" MCQ (Oct 2024 Q1-6).', 'What it is

The Monetary Policy Committee (MPC) is the 6-member body (3 RBI officials + 3 external experts appointed by the government) responsible for setting India''s policy repo rate, established under the amended RBI Act (2016), meeting bi-monthly, deciding by majority vote (with the RBI Governor holding a casting vote in case of a tie).

Why relevant to macroeconomic policy

It is the real-world institutional mechanism through which India''s Monetary Policy process and Inflation Targeting approach (discussed earlier in Section A) are actually implemented.

Syllabus concept demonstrated

Monetary Policy Process, Approaches to Monetary Policy (inflation targeting), Objectives of Monetary Policy.

Key exam points

committee composition (6 members), decision-making by majority vote, bi-monthly meeting cycle, its role in transmitting the inflation-targeting framework into an actual repo-rate decision.

Possible exam question

"Discuss the role of the Monetary Policy Committee in India''s monetary policy framework." (5-mark, application/case-study style)', NULL, NULL, NULL, 29, true, 'University Exam', NULL, NULL, NULL, 'dfa056e0-cb09-400f-a2b3-60fc09917e97', '60a4adf3-4f1a-4efd-8048-5cdc46834585', '{"blocks": [{"id": "principles-of-economics-ii-u2-c29-q", "text": "What is the \"Recent MPC\" (Monetary Policy Committee) case study meant to illustrate?", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '{"blocks": [{"id": "poe-u2-c29-1", "bold": true, "text": "What it is", "type": "text", "style": "heading"}, {"id": "poe-u2-c29-2", "text": "The Monetary Policy Committee (MPC) is the 6-member body (3 RBI officials + 3 external experts appointed by the government) responsible for setting India''s policy repo rate, established under the amended RBI Act (2016), meeting bi-monthly, deciding by majority vote (with the RBI Governor holding a casting vote in case of a tie).", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c29-3", "bold": true, "text": "Why relevant to macroeconomic policy", "type": "text", "style": "heading"}, {"id": "poe-u2-c29-4", "text": "It is the real-world institutional mechanism through which India''s Monetary Policy process and Inflation Targeting approach (discussed earlier in Section A) are actually implemented.", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c29-5", "bold": true, "text": "Syllabus concept demonstrated", "type": "text", "style": "heading"}, {"id": "poe-u2-c29-6", "text": "Monetary Policy Process, Approaches to Monetary Policy (inflation targeting), Objectives of Monetary Policy.", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c29-7", "bold": true, "text": "Key exam points", "type": "text", "style": "heading"}, {"id": "poe-u2-c29-8", "text": "committee composition (6 members), decision-making by majority vote, bi-monthly meeting cycle, its role in transmitting the inflation-targeting framework into an actual repo-rate decision.", "type": "text", "style": "paragraph"}, {"id": "poe-u2-c29-9", "bold": true, "text": "Possible exam question", "type": "text", "style": "heading"}, {"id": "poe-u2-c29-10", "text": "\"Discuss the role of the Monetary Policy Committee in India''s monetary policy framework.\" (5-mark, application/case-study style)", "type": "text", "style": "paragraph"}], "version": 1}'::jsonb, '2026-09-21 16:58:56.972891+00', '2026-09-21 16:58:56.972891+00'),
('3034bcb1-20cb-4d44-85e0-55b62f25f6f0', 'd585435a-10fa-4be9-91af-5303a4204ef8', 'pyq', 'Hindi - October 2024', 'Practice PYQs and Ace your Endsems.', '', 2024, 'https://h36y6svq.us-east.insforge.app/api/storage/buckets/cue-pyqs/objects/d585435a-10fa-4be9-91af-5303a4204ef8%2F2024%2F60b1d853-d433-44fc-a32f-9e24da32368d-hindi-october-2024-1-.pdf?v=8300b8cbbeb9f1de0ae492d7cfd5fcd2', 'd585435a-10fa-4be9-91af-5303a4204ef8/2024/60b1d853-d433-44fc-a32f-9e24da32368d-hindi-october-2024-1-.pdf', 2, true, 'Regular Examination', 'Hindi_October_2024 (1).pdf', 2526652, '60b1d853-d433-44fc-a32f-9e24da32368d', NULL, NULL, NULL, NULL, '2026-09-17 12:18:20.348364+00', '2026-09-25 05:05:57.700623+00')
ON CONFLICT (id) DO NOTHING;

COMMIT;
