# Game Monetization Budget Allocation

A decision-focused monetization system that allocates a fixed promotional budget across users and offers to maximize short-term incremental revenue.

This project intentionally emphasizes **decision structure, constraints, and interpretability** over model complexity.


## Business Objective

**Maximize short-term incremental revenue under a fixed campaign budget B.**

- Budget is limited and must be allocated selectively
- Objective is short-term cash flow (not long-term LTV)
- Decisions are evaluated on expected incremental revenue (EV)


## Decision Granularity

**Decision unit:** `user × offer`  
**Not:** user-level prediction, cohort averages, or global heuristics.

For each eligible user and monetization offer, the system computes:
```Expected Incremental Revenue (EV) = baseline_revenue × uplift − cost```

Where:
- `baseline_revenue` is proxied by historical in-app purchase amount
- `uplift` is segment-specific and scenario-based (low / mid / high)
- `cost` is the direct promotional cost per user

This framing allows:
- Explicit trade-offs under budget constraints
- Clear comparison across heterogeneous users and offers
- Transparent reasoning for why some users are *not* selected

## Data Source
- [Mobile Game In-App Purchases Dataset (2025)](https://www.kaggle.com/datasets/pratyushpuri/mobile-game-in-app-purchases-dataset-2025)

- The dataset includs spending segments (Whale / Dolphin / Minnow) and common data quality issues (e.g. missing values).
- `user_id` is treated as the primary key and represents a unique player.
- All decisions and allocations are performed at the user level.
- Each user can receive at most one monetization offer per campaign run.

## System Overview

1. **Ingest**
   - Raw user data loaded into PostgreSQL (Dockerized)

2. **Feature & Segmentation**
   - Users mapped into monetization segments:
     - whale
     - dolphin
     - early_payer
     - late_payer
     - non_payer
   - Segmentation reflects *current monetization state*, not long-term potential

3. **Offer Policy Layer**
   - Explicit offer catalog with:
     - target segment
     - per-user cost
     - uplift assumptions
   - Policies are data-driven and easily adjustable without code changes

4. **Scoring (EV Calculation)**
   - Every valid user–offer pair is scored by expected incremental revenue
   - EV < 0 combinations are explicitly filtered out

5. **Budget-Constrained Allocation**
   - Offers ranked globally by EV
   - Greedy allocation until cumulative cost reaches budget B
   - Output is a concrete execution list


## Key Assumptions

- Objective is **short-term incremental revenue**
- No lifetime modeling, discounting, or state transitions
- Uplift values are scenario assumptions, not causal estimates
- Budget B is fixed and binding
- Stability and interpretability are prioritized over fine-grained personalization

## Artifacts (Directly Usable Outputs)

All final outputs are generated as **business-ready artifacts**:

| Artifact | Description |
|--------|------------|
| `artifacts/allocation.csv` | Executable campaign list (includes user_id, offer, cost, EV) |
| `artifacts/ev_curve.csv` | Budget vs cumulative expected revenue |
| `artifacts/ev_curve.png` | Visualization of budget efficiency |
| `artifacts/segment_breakdown.csv` | Allocation summary by segment |
| `artifacts/segment_total_ev.png` | Revenue contribution by segment |

These artifacts can be directly handed to:
- Monetization / growth operators
- Campaign execution tools
- Finance for ROI estimation

## Example Results (One Run)

- Total budget: ~3000
- Users targeted: ~600
- Expected incremental revenue: ~47k
- Allocation concentrated on:
  - Whale (majority of EV)
  - Dolphin (secondary contributor)
  - Limited early_payer inclusion
  - No non_payer targeting

This outcome reflects the **explicit short-term cash flow objective**, not long-term growth.

## Reproducibility

```
docker compose up -d
python src/ingest.py
psql -f sql/01_schema.sql
psql -f sql/02_features_users.sql
psql -f sql/03_offers.sql
psql -f sql/04_user_offer_scoring.sql
psql -f sql/05_budget_allocation.sql
python src/plot_artifacts.py
```

## Extensibility

The system is intentionally modular:
	•	The scoring layer can be replaced by predictive models
	•	Objectives can be swapped (e.g., long-term LTV)
	•	Offers and uplift assumptions can be iterated without changing allocation logic

The current version represents a clear, auditable baseline decision system.

