import json
import csv

INPUT_JSON = "station-status.json"      # <-- your file name
OUTPUT_CSV = "station_statuses.csv"

with open(INPUT_JSON, "r", encoding="utf-8") as f:
    data = json.load(f)

features = data["features"]

rows = []
for feat in features:
    props = feat.get("properties", {})
    geom = feat.get("geometry", {})
    coords = geom.get("coordinates", [None, None])

    station_id = props.get("id")
    name = props.get("name")
    lon = coords[0]
    lat = coords[1]

    # skip anything malformed
    if station_id is None or name is None or lon is None or lat is None:
        continue

    rows.append((station_id, name, lon, lat))

with open(OUTPUT_CSV, "w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["id", "name", "lon", "lat"])
    writer.writerows(rows)

print(f"Wrote {len(rows)} rows to {OUTPUT_CSV}")


