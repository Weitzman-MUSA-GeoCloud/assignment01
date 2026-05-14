#!/usr/bin/env node
/**
 * Load indego-station-statuses.geojson into indego.station_statuses.
 *
 * 使用前必须先创建表，否则会报错「关系 indego.station_statuses 不存在」：
 * 1. 在 pgAdmin / VS Code 里对 Assignment1 数据库执行 setup_station_statuses.sql
 * 2. 再在终端执行：node load_stations.js
 *
 * Requires: npm install (pg, dotenv).
 */

import 'dotenv/config';
import pg from 'pg';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const geojsonPath = path.join(__dirname, 'datasets', 'indego-station-statuses.geojson');

const client = new pg.Client({
  host: process.env.POSTGRES_HOST,
  port: process.env.POSTGRES_PORT,
  database: process.env.POSTGRES_NAME,
  user: process.env.POSTGRES_USER,
  password: process.env.POSTGRES_PASS,
});

async function main() {
  if (!fs.existsSync(geojsonPath)) {
    console.error('GeoJSON not found:', geojsonPath);
    process.exit(1);
  }
  const raw = fs.readFileSync(geojsonPath, 'utf8');
  const data = JSON.parse(raw);
  const features = data.features || [];
  if (features.length === 0) {
    console.error('No features in GeoJSON');
    process.exit(1);
  }

  await client.connect();

  for (const f of features) {
    const id = f.properties?.id;
    const name = f.properties?.name ?? '';
    const coords = f.geometry?.coordinates;
    if (id == null || !Array.isArray(coords) || coords.length < 2) continue;
    const [lon, lat] = coords;
    await client.query(
      `INSERT INTO indego.station_statuses (id, name, geog)
       VALUES ($1, $2, ST_SetSRID(ST_MakePoint($3, $4), 4326)::geography)
       ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name, geog = EXCLUDED.geog`,
      [id, name, lon, lat]
    );
  }

  const r = await client.query('SELECT COUNT(*) AS n FROM indego.station_statuses');
  console.log('Loaded', r.rows[0].n, 'stations into indego.station_statuses');
  await client.end();
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
