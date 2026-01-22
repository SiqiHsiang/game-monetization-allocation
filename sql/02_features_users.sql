DROP TABLE IF EXISTS features_users;

CREATE TABLE features_users AS
SELECT
    user_id,
    age, gender, country, device, game_genre, payment_method,
    session_count,
    avg_session_length,
    session_count * avg_session_length AS engagement_score,
    in_app_purchase_amount,
    spending_segment,
    first_purchase_days_after_install,
    CASE WHEN in_app_purchase_amount > 0 THEN true ELSE false END AS is_payer,
    CASE
        WHEN spending_segment = 'Whale' THEN 'whale'
        WHEN spending_segment = 'Dolphin' THEN 'dolphin'
        WHEN in_app_purchase_amount > 0
             AND first_purchase_days_after_install IS NOT NULL
             AND first_purchase_days_after_install <= 7
             THEN 'early_payer'
        WHEN in_app_purchase_amount > 0 THEN 'late_payer'
        ELSE 'non_payer'
    END AS monetization_segment
FROM raw_users;