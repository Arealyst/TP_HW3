import csv
import random
import os
import sys

NUM_ROWS = 50


COLUMNS = ["MatchesPlayed", "TicketPrice", "Capacity", "Country"]

def generate_row():

    return {
        "MatchesPlayed": random.randint(1, 1000),
        "TicketPrice": round(random.uniform(10.0, 150.0), 2),
        "Capacity": random.randint(5000, 100000),
        "Country": random.choice(["Spain", "England", "Germany", "Italy", "France", "USA", "Mexico", "Canada"]),
    }

OUTPUT_DIR = sys.argv[1] if len(sys.argv) > 1 else "/data"
OUTPUT_FILE = os.path.join(OUTPUT_DIR, "data.csv")

os.makedirs(OUTPUT_DIR, exist_ok=True)

rows = [generate_row() for _ in range(NUM_ROWS)]

with open(OUTPUT_FILE, "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=COLUMNS)
    writer.writeheader()
    writer.writerows(rows)

