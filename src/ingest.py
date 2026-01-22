import psycopg2
import csv

def to_int(x):
    return int(float(x)) if x not in ("", None) else None

def to_float(x):
    return float(x) if x not in ("", None) else None

def to_date(x):
    return x if x not in ("", None) else None

conn = psycopg2.connect(
    host="localhost",
    port=5432,
    dbname="monetization_db",
    user="monetization_user",
    password="monetization_pass"
)

cur = conn.cursor()

with open("data/mobile_game_inapp_purchases.csv", newline="", encoding="utf-8") as f:
    reader = csv.DictReader(f)
    for row in reader:
        row["Age"] = to_int(row["Age"])
        row["SessionCount"] = to_int(row["SessionCount"])
        row["FirstPurchaseDaysAfterInstall"] = to_int(row["FirstPurchaseDaysAfterInstall"])

        row["AverageSessionLength"] = to_float(row["AverageSessionLength"])
        row["InAppPurchaseAmount"] = to_float(row["InAppPurchaseAmount"])

        row["LastPurchaseDate"] = to_date(row["LastPurchaseDate"])

        cur.execute(
            """
            INSERT INTO raw_users (
                user_id, age, gender, country, device, game_genre,
                session_count, avg_session_length, spending_segment,
                in_app_purchase_amount, first_purchase_days_after_install,
                payment_method, last_purchase_date
            )
            VALUES (
                %(UserID)s, %(Age)s, %(Gender)s, %(Country)s, %(Device)s, %(GameGenre)s,
                %(SessionCount)s, %(AverageSessionLength)s, %(SpendingSegment)s,
                %(InAppPurchaseAmount)s, %(FirstPurchaseDaysAfterInstall)s,
                %(PaymentMethod)s, %(LastPurchaseDate)s
            )
            ON CONFLICT (user_id) DO NOTHING;
            """,
            row
        )

conn.commit()
cur.close()
conn.close()