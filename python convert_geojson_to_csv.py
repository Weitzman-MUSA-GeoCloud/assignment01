import json
import csv

geojson_file = "C:/Users/kalmanj/Documents/SCHOOL/cloudcomputing/assignment1/indego-station-statuses.geojson"
csv_file = "C:/Users/kalmanj/Documents/SCHOOL/cloudcomputing/assignment1/indego-station-statuses.csv"

with open(geojson_file) as f:
    data = json.load(f)

with open(csv_file, "w", newline="") as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(["station_name","lon","lat"])
    
    for feature in data["features"]:
        name = feature["properties"]["station_name"]
        lon, lat = feature["geometry"]["coordinates"]
        writer.writerow([name, lon, lat])
