# Blinkit Delivery SLA Diagnostic

A four-part regional operations diagnostic analyzing sub-10-minute delivery SLA compliance across Mumbai and Bengaluru. Built using SQLite, Python, Google Sheets (`.xlsx`), and a structured dashboard specification to isolate underperforming cluster-band cells and recommend targeted operational actions.

*Note: All data in this repository is simulated for an analytical exercise and does not represent real Blinkit operations.*

---

## Scope & Key Metric

* **Primary KPI:** Sub-10-minute delivery SLA compliance, defined as `delivery_minutes <= 10` for **delivered orders only** (cancellations excluded).
* **Target Benchmark:** **80%** compliance.
* **Tool Stack:** SQLite (via Python), spreadsheet statistical modeling & pivot heat tables (`.xlsx`), and Markdown documentation.

---

## Repository Contents

### Part A — Requirements & Scoping
* `docs/requirements.md` — Stakeholder grid, discovery questions, KPI definition, and decision log.

### Part B — SQLite Database, SQL Scripts & CSV Exports
* `generate_data.py` — Script that generates the deterministic `blinkit_sla.db` database.
* `blinkit_sla.db` — SQLite database containing the simulated delivery dataset.
* `verify.sql` — Data integrity and row-count verification queries.
* `01_foundations.sql` – `04_trend.sql` — Foundational filtering, aggregation, compliance breakdowns, and trend analysis scripts.
* `cluster_band_cells.csv`, `daily_compliance.csv`, `category_compliance.csv`, `kpi_summary.csv`, `focus_delivery_minutes.csv` — Unedited SQL exports used in Part C.

### Part C — Spreadsheet Statistical Analysis & Heat Table
* `blinkit_sla_analysis.xlsx` — Workbook containing unmodified CSV imports, `Cell Stats` (statistical formulas and empirical probabilities), `Cells` (heat table pivot with conditional formatting), and `XLOOKUP` reconciliation checks against Part B.

### Part D — Reporting, Dashboard Spec & AI Log
* `docs/dashboard_spec.md` — Dashboard layout, visual specifications, and interactivity plan.
* `docs/one_page_report.md` — Executive one-page decision report grounded in verified workbook and SQL outputs.
* `ai_log.md` — Structured AI workflow prompt log, draft revisions, and manual validation checks.
