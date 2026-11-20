# Blinkit Delivery SLA Diagnostic — Requirements & KPI Definition

## 1. Stakeholder Grid

| Stakeholder | Interest | Influence | Quadrant | Action |
|---|---|---|---|---|
| **Regional Operations Director** | Cares a lot | Can change, approve or block it | Manage Closely | Align weekly on KPI definitions, review bottlenecks, and confirm rider/promo decisions. |
| **Rider-Fleet Lead** | Cares a lot | Can change, approve or block it | Manage Closely | Share cluster-and-hour bottleneck findings so rider shifts can be reallocated to high-need windows. |
| **Data & Engineering Team** | Cares less | Can change, approve or block it | Keep Satisfied | Confirm table schema, timestamp definitions, and SLA calculation rules so metrics match official data. |
| **Finance Team** | Cares less | Can change, approve or block it | Keep Satisfied | Provide visibility into how targeted rider allocation avoids unnecessary city-wide staffing costs. |
| **Dark-Store Managers** | Cares a lot | Cannot change the work | Keep Informed | Share weekly cluster-level compliance and category bottlenecks so store teams can adjust packing prep. |
| **Category Team** | Cares a lot | Cannot change the work | Keep Informed | Notify them of product categories dragging down SLA compliance (e.g., handling/packing delays). |
| **Marketing / Growth Team** | Cares less | Cannot change the work | Monitor | Inform only if new-customer promotions need to be paused in struggling clusters during peak hours. |

**Owners of Official Numbers:**
* **Regional Operations Director:** Owns the official **Sub-10-Minute Compliance** KPI and the 80% target threshold.
* **Data & Engineering Team:** Owns the official underlying order timestamps, delivery durations (`delivery_minutes`), and order status records in the `orders` table that our KPI must reconcile against.

---

## 2. Questions & Playback

### Rewritten Discovery Questions

1. **Original:** "Do you want a bar chart or a line chart?"
   * *Why it is poor:* It focuses on visual formatting before understanding the business decision or question.
   * *Rewrite:* "What specific comparisons or trends do you need to see in your weekly review to decide where to add riders?"
2. **Original:** "Should it be real-time?"
   * *Why it is poor:* It is a closed yes/no question that encourages asking for expensive live data without checking how often action is actually taken.
   * *Rewrite:* "How frequently do you make staffing or promotional changes, and how soon after a drop in performance can your team realistically act?"
3. **Original:** "Do you need every late order listed?"
   * *Why it is poor:* It invites a request for raw, unactionable row-level data instead of uncovering the level of summary needed for decisions.
   * *Rewrite:* "When SLA compliance drops, what level of detail helps you pinpoint whether the issue is a specific location, time of day, or product type?"

### Playback Paragraph

You initially asked for a real-time dashboard listing every late order across all stores in Mumbai and Bengaluru. Based on our discussion, what you actually need is a reliable weekly diagnostic that breaks down our city-wide compliance average into specific dark-store clusters, operating hour bands, and product categories. Because your team reviews and adjusts rider shifts or promotions weekly—not minute by minute—a real-time feed of individual orders would add noise rather than clarity. Instead, I will build a weekly diagnostic analysis and dashboard specification that flags which exact clusters and time windows fall below the 80% sub-10-minute target, so you can direct riders to the specific bottlenecks rather than adding staff city-wide.

---

## 3. Ask → Need → Build

| What She Asked For (Ask) | What She Actually Needs (Need) | What We Will Build (Build) |
|---|---|---|
| A real-time dashboard | Know within days, not months, which clusters need action for the weekly ops review | A weekly-cadence SLA diagnostic view covering 4 weeks of order history and weekly trend shifts |
| A list of every late order across all stores | Pinpoint exact operational bottlenecks instead of acting on a vague city-wide average | Aggregated compliance segmented by dark-store cluster, hour band, and product category |
| Broad visibility across all stores | Identify the specific worst-performing windows to reallocate riders or pause promotions | A ranked bottleneck view highlighting the lowest-performing cluster–hour cells against the 80% target |

**Need Statement:**
The Regional Operations Director needs to identify which dark-store clusters, hour bands, and product categories are falling below the 80% sub-10-minute delivery target weekly so that she can allocate riders to true bottlenecks or pause local promotions instead of adding riders city-wide.

---

## 4. KPI Definition: Sub-10-Minute Compliance

| Field | Specification |
|---|---|
| **Name** | Sub-10-Minute Compliance |
| **Definition** | The percentage of delivered orders that reach the customer in 10 minutes or less. |
| **Question Answered** | What share of delivered orders are meeting our 10-minute delivery promise? |
| **Formula** | `(Count of delivered orders where delivery_minutes <= 10) / (Total count of delivered orders) * 100` (Cancelled orders have no delivery time and are excluded from both numerator and denominator.) |
| **Counted On** | Delivered orders only (`status = 'Delivered'`, i.e., rows where `delivery_minutes IS NOT NULL`). |
| **Date Used** | `order_date` |
| **Cut By** | City, dark-store cluster, hour band (Morning, Lunch, Afternoon, Evening), product category, and calendar day. |
| **Target** | At least 80% (`>= 80%`) in every dark-store cluster and every hour band. |
| **Deadline** | End of next quarter. |
| **Starting Point** | 79.01% |
| **Owner** | Regional Operations Director |
| **Source** | `orders` table in `blinkit_sla.db` |

**Boundary Note (`<= 10` vs. `< 10`):**
Defining whether an order delivered in exactly 10 minutes counts as on time (`delivery_minutes <= 10`) or late (`delivery_minutes < 10`) must be explicitly documented before analysis begins. Because delivery times are recorded as whole integers and many orders cluster right at the 10-minute mark, changing the boundary dramatically shifts the headline number: under `<= 10`, overall compliance is 79.01%, whereas under `< 10`, it drops to 57.75%. Writing this rule down prevents teams from arguing over conflicting numbers during weekly reviews.

---

## 5. Decision Log & Scope

### Decision Log

| Date | What Was Decided | Roles Agreed | Why It Matters |
|---|---|---|---|
| 2026-11-20 | On-time SLA is defined strictly as `delivery_minutes <= 10`, calculated over delivered orders only (excluding cancelled orders). | Regional Operations Director, Data & Engineering Team | Ensures consistent reporting across SQL, spreadsheets, and dashboards, and prevents cancelled orders or 10-minute boundary orders from distorting compliance. |
| 2026-11-20 | Reporting cadence is set to weekly (covering a 4-week diagnostic window) rather than real-time. | Regional Operations Director, Rider-Fleet Lead | Matches the actual decision cadence of the weekly operations review and avoids unnecessary engineering effort on live streaming. |

### Out of Scope

* **Real-time order tracking and live alerting:** Excluded because staffing and promotional decisions are made during the weekly operations review, not minute-by-minute.
* **Row-level list of every individual late order:** Excluded because reviewing thousands of individual late orders does not help leadership allocate riders at the cluster or shift level.
* **Root-cause telemetry (e.g., traffic data, rider GPS, store packing timestamps):** Excluded because the dataset only captures order timestamp, store, category, status, and total delivery minutes; operational causes behind slow cells cannot be proven from this data alone.
