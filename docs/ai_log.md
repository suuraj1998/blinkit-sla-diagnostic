# AI-Assisted Workflow Log

## 1. Exact Prompt Used for Report Drafting (Task / Context / Constraints / Format)

**Task:** Draft a concise, executive one-page decision report based strictly on the verified metrics provided below. Do not recompute or invent any numbers.

**Context:** The report is for Blinkit's Regional Operations Director and Rider-Fleet Lead for their weekly operations review. Overall sub-10-minute compliance (delivered orders only, `delivery_minutes <= 10`) is 79.01% against an 80% target, dropping from 80.97% (first 7 days) to 76.14% (last 7 days). Three of 24 cluster-hour cells are below 60%: Whitefield - Lunch (42.63%, median 11 min, mean 10.97 min), Andheri - Evening (48.49%, median 11 min, mean 11.95 min), and Koramangala - Evening (59.54%). Best cell: Thane - Morning (93.40%, median 8 min). Eight of 24 cells are below 80%. Category compliance: Fruits & Vegetables (62.40%) vs. Household (81.63%). Data period: 2026-10-05 to 2026-11-01 (5,616 delivered orders, 384 cancelled, ~200 delivered orders/day).

**Constraints:**
* Maximum 350 words total.
* Name the benchmark for every comparison (e.g., 80% target, Week 1 vs. Week 4, Thane - Morning, Household).
* Use medians alongside compliance percentages for skewed delivery times instead of relying only on means.
* Do not invent operational causes (such as traffic, rain, or rider shortages); write "cause unknown" wherever the data does not prove a cause.
* Avoid hype words (e.g., "catastrophic", "plummeted", "massive").
* Cite supporting evidence as plain-text file paths only (no URLs or links).

**Format:** Markdown with these exact labelled sections: Headline, Audience & Timeline, Data Source & Period, Decision Required, What We Found (max 5 bullets), Evidence, Recommendation (at least 3 verb-led actions), Next Steps (owner + due date), and Limitations (explicitly note daily sample-size noise).

---

## 2. First-Draft Problems & Prompt Fixes

1. **Problem 1 — Invented Root Causes & Hype Language:**
   * *What went wrong:* The AI's initial draft claimed that compliance "plummeted" in Andheri Evening due to "heavy Mumbai rush-hour traffic and rider fatigue," and blamed Fruits & Vegetables delays on "slow manual weighing at dark stores." None of these causes exist in `blinkit_sla.db`.
   * *Prompt fix:* Added an explicit constraint: *"Do not invent operational causes; write 'cause unknown' wherever the data does not prove a cause, and avoid hype words like 'plummeted' or 'catastrophic'."*

2. **Problem 2 — Mean Used Without Median & Missing Daily-Noise Warning:**
   * *What went wrong:* The first draft cited only the mean delivery time for Andheri - Evening (11.95 min), which is pulled upward by extreme late-order outliers (sd = 3.71), and treated the single-day low (72.86% on 2026-10-31) as a major operational breakdown without noting sample size.
   * *Prompt fix:* Added constraints requiring *"medians alongside compliance percentages for skewed delivery times"* and an explicit Limitations note stating that *"single-day figures are noisy (~200 delivered orders/day)."*

---

## 3. Validation Note

* **Title:** Blinkit Delivery SLA Diagnostic — One-Page Report Validation
* **Sources:** `blinkit_sla.db`, `02_aggregation_joins.sql`, `03_segments.sql`, `04_trend.sql`, `cluster_band_cells.csv`, `category_compliance.csv`, `kpi_summary.csv`, `blinkit_sla_analysis.xlsx`.
* **AI Usage:** Used an AI chat assistant solely to draft and tighten prose for `docs/one_page_report.md` from a pre-verified table of numbers. No SQL queries, spreadsheet formulas, or statistical calculations were delegated to the AI for final reporting.
* **Manual Checks Actually Performed:**
  1. Verified every percentage and count in `docs/one_page_report.md` against `kpi_summary.csv`, `cluster_band_cells.csv`, `category_compliance.csv`, and `Cell Stats` in `blinkit_sla_analysis.xlsx`.
  2. Verified total word count of `docs/one_page_report.md` (~310 words, strictly under the 350-word limit).
  3. Checked that no external links, invented causes, or unverified claims remained in the final text.
* **Changes Made:** Removed invented traffic/packing explanations, replaced hype phrasing with neutral percentage-point differences, added medians for focus cells, and explicitly inserted `"cause unknown"` and the ~200 orders/day noise caveat.
* **Analysis Limits:** The dataset is simulated and contains only order timestamps, store/cluster metadata, category, status, and total delivery minutes. It cannot distinguish between dark-store packing delays, rider dispatch wait times, or road travel time.
