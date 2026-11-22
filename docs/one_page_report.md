# Blinkit Delivery SLA Diagnostic — One-Page Decision Report

**Headline:** Overall sub-10-minute compliance fell from 80.97% in Week 1 to 76.14% in Week 4 (79.01% overall vs. 80% target), driven by three cluster-hour bottlenecks below 60% and Fruits & Vegetables at 62.40%.

**Audience & Timeline:** Regional Operations Director and Rider-Fleet Lead; for the weekly operations review (target: >= 80% compliance by end of next quarter).

**Data Source & Period:** Simulated Blinkit order data (`blinkit_sla.db`), 6,000 orders (5,616 delivered, 384 cancelled) across Mumbai and Bengaluru, 2026-10-05 to 2026-11-01.

**Decision Required:** The Regional Operations Director must decide whether to reallocate riders to three specific bottleneck windows and pause local promotions there, instead of adding riders city-wide.

**What We Found:**
* Overall compliance is 79.01% (below the 80% target), dropping 4.83 percentage points from 80.97% (first 7 days) to 76.14% (last 7 days).
* Three of 24 cluster-hour cells fall below 60%: Whitefield - Lunch (42.63%, median 11 min), Andheri - Evening (48.49%, median 11 min), and Koramangala - Evening (59.54%), compared to Thane - Morning at 93.40% (median 8 min).
* Fruits & Vegetables is the only category below the 80% target at 62.40%, trailing the next-lowest category (Household at 81.63%) by 19.23 percentage points.
* Eight of 24 cells sit below 80%, while 16 cells already meet target.

**Evidence:** `02_aggregation_joins.sql`, `03_segments.sql`, `04_trend.sql`, `cluster_band_cells.csv`, `category_compliance.csv`, `kpi_summary.csv`, `blinkit_sla_analysis.xlsx`.

**Recommendation:**
* **Stop** adding riders city-wide across Mumbai and Bengaluru.
* **Move** surge rider capacity specifically to Whitefield - Lunch, Andheri - Evening, and Koramangala - Evening.
* **Cap** new-customer promotions in Whitefield (Lunch) and Andheri (Evening) until compliance exceeds 80%.
* **Review** Fruits & Vegetables packing workflows with Dark-Store Managers and the Category Team.

**Next Steps:**
* Rider-Fleet Lead: Draft targeted shift reallocation plan for the three bottleneck cells by 2026-11-27.
* Category Team & Dark-Store Managers: Audit Fruits & Vegetables handling times by 2026-12-01.

**Limitations:** Single-day figures are noisy (~200 delivered orders/day), so decisions must rely on weekly trends. Because the data lacks traffic, rider GPS, and packing timestamps, the operational root cause of slow cells and Fruits & Vegetables delays is **cause unknown**; alternative explanations include local road congestion or store-level stockouts.
