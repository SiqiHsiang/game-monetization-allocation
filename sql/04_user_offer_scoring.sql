DROP TABLE IF EXISTS user_offer_scores;

CREATE TABLE user_offer_scores AS
SELECT
    u.user_id,
    u.monetization_segment,
    o.offer_id,
    o.offer_name,
    u.in_app_purchase_amount AS baseline_revenue,
    o.uplift_mid,
    o.cost,
    (u.in_app_purchase_amount * o.uplift_mid) - o.cost AS expected_incremental_revenue
FROM features_users u
JOIN offers o
  ON u.monetization_segment = o.target_segment
WHERE o.active = true;