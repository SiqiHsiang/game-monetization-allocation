DROP TABLE IF EXISTS offers;

CREATE TABLE offers (
    offer_id TEXT PRIMARY KEY,
    offer_name TEXT,
    target_segment TEXT,
    cost FLOAT,
    uplift_low FLOAT,
    uplift_mid FLOAT,
    uplift_high FLOAT,
    active BOOLEAN
);

INSERT INTO offers VALUES
('O1', 'Whale Exclusive Pack', 'whale', 10, 0.10, 0.20, 0.30, true),
('O2', 'Early Payer Starter Boost', 'early_payer', 3, 0.20, 0.30, 0.40, true),
('O3', 'Dolphin Limited Offer', 'dolphin', 5, 0.08, 0.15, 0.25, true),
('O4', 'Late Payer Discount', 'late_payer', 2, 0.03, 0.08, 0.15, true);