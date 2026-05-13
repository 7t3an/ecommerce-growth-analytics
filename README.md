# Ecommerce Growth Analytics

End-to-end behavioral and revenue analysis of an ecommerce platform built as a portfolio project to demonstrate SQL, Python, and data storytelling skills.

---

## The Problem

Users browse but don't buy. 99.6% of users view products, yet only 32.8% ever make a purchase and 72% of new users never return after their first visit. This project investigates **where and why users drop off**, and what the data says about retention, revenue, and product performance.

---

## What's Inside

```
analysis_notebooks/
├── 00_executive_summary.ipynb   ← Start here full picture in one place
├── 01_user_behavior.ipynb       ← Who are our users and what do they do?
├── 02_funnel_analysis.ipynb     ← Where do users drop off?
├── 03_revenue_analysis.ipynb    ← Who drives revenue and how much?
├── 04_product_analysis.ipynb    ← Which categories and products perform?
└── 05_cohort_analysis.ipynb     ← Do users come back after month one?

sql/
├── user_behavior_mart.sql       ← User-level behavioral signals
├── revenue_mart.sql             ← Order and revenue metrics per user
├── product_mart_v2.sql          ← Product funnel + actual sales
├── analysis_cohorts.sql         ← Cohort retention dataset
└── data_quality/                ← Validation checks across all tables
```

---

## Key Findings

**Funnel collapses between wishlist and purchase.**
70% of users add to cart, 55% wishlist — but only 33% ever buy. The drop doesn't happen at awareness, it happens at the decision stage.

**72% of users never come back after their first month.**
Across 17 monthly cohorts (Jan 2024 - May 2025), the platform consistently loses ~72% of new users before their second visit. Users who do return stay active for 6+ months at a stable ~30% rate, the platform retains its core well, it just fails to convert first-timers.

**Electronics alone drives 41.6% of total revenue ($4.96M).**
Not because more units sell, but because prices are 3–5× higher ($1,200–$2,300 vs $20–$200 in other categories). All 10 categories sell roughly the same number of units per product.

**Repeat buyers are worth 3× more than one-time buyers.**
68% of buyers place more than one order, spending on average $1,754 vs $577 for one-time buyers. Revenue concentration risk is real: a small loyal base drives the majority of income.

---

## Stack

- **Python** - pandas, matplotlib, seaborn
- **SQL** - PostgreSQL with CTEs and mart pattern
- **Jupyter** - analysis notebooks with observations and findings
- **Git** - feature branch workflow (dev → main)

---

## How to Run

```bash
git clone https://github.com/7t3an/ecommerce-growth-analytics
cd ecommerce-growth-analytics

pip install -r requirements.txt

cp .env.example .env
# fill in your DATABASE_URL in .env

jupyter notebook
# open analysis_notebooks/00_executive_summary.ipynb
```

---

## Data Model

Five tables: `users`, `events`, `orders`, `order_items`, `products`, `reviews`.  
Events track behavioral intent (view/cart/wishlist/purchase). Orders are the source of truth for actual revenue. The gap between event-tracked purchases and real orders is documented in `product_mart_v2.sql`.
