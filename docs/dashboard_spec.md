# Blinkit Delivery SLA Diagnostic — Dashboard Specification & Data Story

## 1. Worksheet Specifications

### W1: Daily Trend
* **Data Source:** `daily_compliance.csv`
* **Columns Shelf:** `order_date` (Continuous, Exact Date / Day)
* **Rows Shelf:** `SUM(compliance_pct)` (Continuous, formatted to 2 decimal places)
* **Marks Card:** Mark type = **Line**; Color = Dark Blue (`#1F77B4`); Labels = Show min/max mark labels.
* **Filters / Sort:** None (chronological by `order_date` ascending).
* **Annotations:**
  * **Point Annotation** on `2026-10-31`: *"Lowest single-day compliance: 72.86% on 2026-10-31 (note: ~200 daily orders make single-day dips noisy)."*
  * **Area Annotation** over `2026-10-26` to `2026-11-01`: *"Last 7 days averaged 76.14% — down 4.83 percentage points from the first 7 days (80.97%)."*
* **Displayed Values:**
  * First day (`2026-10-05`): **76.5%**
  * Last day (`2026-11-01`): **73.91%**
  * Lowest day (`2026-10-31`): **72.86%**

---

### W2: Cluster-Band Cells
* **Data Source:** `cluster_band_cells.csv`
* **Columns Shelf:** `SUM(compliance_pct)`
* **Rows Shelf:** `cell_label`
* **Marks Card:** Mark type = **Bar**; Color = Calculated field `IF [rank_overall] <= 3 THEN "Bottleneck" ELSE "Other" END` (`Bottleneck` = Red `#D62728`, `Other` = Light Grey `#B0B0B0`); Labels = Show mark labels (`compliance_pct` to 2 decimals).
* **Filters / Sort:** `cell_label` sorted ascending by `SUM(compliance_pct)`. City filter (`city`) applied to this worksheet.
* **Annotations:** Reference line at `80%` labeled *"80% SLA Target"*.
* **Displayed Values (3 Highlighted Bottleneck Cells):**
  * `Whitefield - Lunch`: **42.63%**
  * `Andheri - Evening`: **48.49%**
  * `Koramangala - Evening`: **59.54%**

---

### W3: Worst N
* **Data Source:** `cluster_band_cells.csv`
* **Columns Shelf:** `SUM(compliance_pct)`
* **Rows Shelf:** `cell_label`
* **Marks Card:** Mark type = **Bar**; Color = Red (`#D62728`); Labels = Show mark labels (`compliance_pct` to 2 decimals).
* **Parameter & Filter:**
  * **Parameter:** `Worst N` — Data type: **Integer**, Current value: **3**, Allowable values: **Range (Minimum = 3, Maximum = 7, Step size = 1)**.
  * **Filter:** `cell_label` filtered using **Top/Bottom** → **Bottom** by `Worst N` parameter using `SUM(compliance_pct)`.
* **Sort:** `cell_label` sorted ascending by `SUM(compliance_pct)`.
* **Annotations:** None.
* **Displayed Values:**
  * **At N = 3:** `Whitefield - Lunch` (**42.63%**), `Andheri - Evening` (**48.49%**), `Koramangala - Evening` (**59.54%**)
  * **At N = 5:** `Whitefield - Lunch` (**42.63%**), `Andheri - Evening` (**48.49%**), `Koramangala - Evening` (**59.54%**), `Powai - Evening` (**74.26%**), `Powai - Lunch` (**77.87%**)

---

### W4: Category
* **Data Source:** `category_compliance.csv`
* **Columns Shelf:** `SUM(compliance_pct)`
* **Rows Shelf:** `category`
* **Marks Card:** Mark type = **Bar**; Color = Calculated field `IF [category] = "Fruits & Vegetables" THEN "Flagged" ELSE "Other" END` (`Flagged` = Red `#D62728`, `Other` = Light Grey `#B0B0B0`); Labels = Show mark labels (`compliance_pct` to 2 decimals).
* **Filters / Sort:** `category` sorted ascending by `SUM(compliance_pct)`.
* **Annotations:** None.
* **Displayed Values (All 5 Categories, Ascending):**
  * `Fruits & Vegetables`: **62.4%** (highlighted)
  * `Household`: **81.63%**
  * `Snacks & Beverages`: **83.56%**
  * `Personal Care`: **84.57%**
  * `Dairy & Bread`: **84.74%**

---

### W5: Big Numbers
* **Data Source:** `kpi_summary.csv`
* **Columns Shelf:** None (three side-by-side text sheets or Measure Names)
* **Rows Shelf:** None
* **Marks Card:** Mark type = **Text**; Font size enlarged (28pt bold) for the KPI values with 11pt subtitle labels below each number.
* **Filters / Sort:** None.
* **Annotations:** None.
* **Displayed Values:**
  * Overall Compliance (4 Weeks): **79.01%**
  * First 7 Days (`2026-10-05` to `2026-10-11`): **80.97%**
  * Last 7 Days (`2026-10-26` to `2026-11-01`): **76.14%**

---

## 2. Dashboard Assembly & Interactivity

* **Dashboard Size:** Fixed size — **1200 × 768 pixels**.
* **Title Text Box (Top Banner):** *"Blinkit Delivery SLA Diagnostic — Mumbai & Bengaluru (Oct 5 – Nov 1, 2026)"*
* **Layout Order (Top to Bottom, Left to Right):**
  1. **Top Row:** `W5 Big Numbers` (full width, 3 KPI callouts side by side).
  2. **Middle Row:** `W1 Daily Trend` (left, 60% width) and `W4 Category` (right, 40% width).
  3. **Bottom Row:** `W2 Cluster-Band Cells` (left, 60% width) and `W3 Worst N` (right, 40% width), with the `City` filter and `Worst N` parameter control placed above W2/W3.
* **City Filter Scope:**
  * **Applied to:** **W2 (`Cluster-Band Cells`) only**.
  * **Excluded Worksheets & Reasons:**
    * **W3 (`Worst N`):** Deliberately excluded even though it shares W2's data source. A Bottom-N filter evaluates before a standard dimension filter, so filtering W3 by city would drop cells from the other city and display fewer than N bars instead of that city's own lowest N.
    * **W1 (`Daily Trend`), W4 (`Category`), and W5 (`Big Numbers`):** Cannot be reached by the `city` filter because their underlying CSV data sources (`daily_compliance.csv`, `category_compliance.csv`, `kpi_summary.csv`) are pre-aggregated across both cities and do not contain a `city` column.
* **Click-to-Filter Action:**
  * **Setting:** Enable **Use as Filter** on `W2` (or add a Dashboard Filter Action: Source Sheet = `W2 Cluster-Band Cells`, Target Sheet = `W3 Worst N`, Run action on = **Select**, Clearing the selection will = **Show all values**).
  * **Result after clicking `Whitefield - Lunch` in W2:** `W3 Worst N` filters down to display only **1 bar**: `Whitefield - Lunch` at **42.63%**.

---

## 3. Five-Point Data Story

1. **Caption:** *"Overall sub-10-minute compliance sits at 79.01%, slipping from 80.97% in Week 1 to 76.14% in Week 4."*
   * **View Shown:** `W5 Big Numbers` + `W1 Daily Trend`
   * **Annotation:** Area annotation over the last 7 days noting the 4.83 percentage-point drop from Week 1.
2. **Caption:** *"Daily compliance hit a 28-day low of 72.86% on 2026-10-31, though single-day swings reflect ~200 daily orders."*
   * **View Shown:** `W1 Daily Trend`
   * **Annotation:** Point annotation on `2026-10-31` (`72.86%`) warning that single-day figures are noisy.
3. **Caption:** *"City averages hide severe local bottlenecks: 3 of 24 cluster-hour cells fall below 60%, led by Whitefield - Lunch at 42.63%."*
   * **View Shown:** `W2 Cluster-Band Cells`
   * **Annotation:** 80% target reference line highlighting `Whitefield - Lunch` (42.63%), `Andheri - Evening` (48.49%), and `Koramangala - Evening` (59.54%).
4. **Caption:** *"Focusing on the Worst 3 cells isolates the exact windows driving SLA failure without over-staffing healthy clusters like Thane - Morning (93.40%)."*
   * **View Shown:** `W3 Worst N` (set to `N = 3`)
   * **Annotation:** None.
5. **Caption:** *"Across product lines, Fruits & Vegetables drags compliance down at 62.40%, trailing Household (81.63%) by 19.23 percentage points."*
   * **View Shown:** `W4 Category`
   * **Annotation:** Highlighted red bar on `Fruits & Vegetables` (`62.4%`) versus the next lowest category (`Household` at `81.63%`).
