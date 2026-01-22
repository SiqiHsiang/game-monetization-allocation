DROP TABLE IF EXISTS allocation;

CREATE TABLE allocation AS
WITH ranked AS (
    SELECT
        user_id,
        offer_id,
        offer_name,
        monetization_segment,
        cost,
        expected_incremental_revenue,
        ROW_NUMBER() OVER (
            ORDER BY expected_incremental_revenue DESC
        ) AS ev_rank,
        SUM(cost) OVER (
            ORDER BY expected_incremental_revenue DESC
        ) AS cumulative_cost
    FROM user_offer_scores
    WHERE expected_incremental_revenue > 0
)
SELECT *
FROM ranked
WHERE cumulative_cost <= 3000;