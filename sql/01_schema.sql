CREATE TABLE IF NOT EXISTS raw_users (
    user_id TEXT PRIMARY KEY,
    age INTEGER,
    gender TEXT,
    country TEXT,
    device TEXT,
    game_genre TEXT,
    session_count INTEGER,
    avg_session_length FLOAT,
    spending_segment TEXT,
    in_app_purchase_amount FLOAT,
    first_purchase_days_after_install INTEGER,
    payment_method TEXT,
    last_purchase_date DATE
);