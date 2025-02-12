import fs from 'node:fs/promises';
import path from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';

import { expect } from '@jest/globals';
import { diff } from 'jest-diff';
import pg from 'pg';
import Papa from 'papaparse';
import * as dotenv from 'dotenv';

// Load environment overrides
const envLoadResult = dotenv.config();
if (envLoadResult.error) {
  if (envLoadResult.error.code == 'ENOENT') {
    throw new Error('Looks like there\'s no connection settings file in your root folder.\nDid you remember to copy the ".env.template" file to ".env"?');
  } else {
    throw envLoadResult.error;
  }
}

// Get the current path
const __dirname = path.dirname(fileURLToPath(import.meta.url));

function indent(str, n=4, char=' ') {
  const prefix = char.repeat(n);
  return str.replace(/^/gm, prefix);  // Replace each beginning of a line with the spaces.
}

async function toReturnRecords(queryFN, resultsFNs, options = {}) {
  // Read the SQL query code.
  const fullQueryFN = path.resolve(__dirname, queryFN);
  let sql = null;
  try {
    // Read the query file.
    sql = await fs.readFile(fullQueryFN, { encoding: 'utf8', flag: 'r' });

    sql = sql.replace(/\/\*.*?\*\//gs, '');  // Remove block comments
    sql = sql.replace(/--.*$/gm, '');        // Remove line comments
    sql = sql.trim();                        // Trim whitespace
    sql = sql.replace(/;$/gm, '');           // Remove trailing semicolon

    // Check if there's anything left. If not, then abort immediately and fail
    // the test.
    if (sql === '') {
      return {
        pass: false,
        message: () => `No query defined yet in file "${queryFN}".`,
      };
    }

    // Wrap the query as a subquery so that we can add ORDER BY and LIMIT if
    // appropriate.
    sql = `SELECT * FROM (\n${indent(sql)}\n) AS query`;

    if (options.orderBy) {
      sql += `\nORDER BY ${options.orderBy}`;
    }
    if (options.limit) {
      sql += `\nLIMIT ${options.limit}`;
    }
  } catch (err) {
    return {
      pass: false,
      message: () => `Failed to read query SQL file "${queryFN}".\n${err}`,
    };
  }

  // Read the expected results.
  let expecteds = [];
  for (const resultsFN of resultsFNs) {
    const fullResultsFN = path.resolve(__dirname, resultsFN);
    try {
      const csv = await fs.readFile(fullResultsFN, { encoding: 'utf8', flag: 'r' });
      const expected = Papa.parse(csv, { header: true });
      expecteds.push(expected);
    } catch (err) {
      return {
        pass: false,
        message: () => `Failed to load expected results from CSV file "${resultsFN}".\n${err}`,
      };
    }
  }

  // Get the database connection configuration.
  const user     = process.env['POSTGRES_USER'];
  const password = process.env['POSTGRES_PASS'];
  const host     = process.env['POSTGRES_HOST'];
  const port     = process.env['POSTGRES_PORT'];
  const database = process.env['POSTGRES_NAME'];

  // Run the query code.
  const client = new pg.Client({ user, password, host, port, database });
  let received = null;
  try {
    await client.connect();
    received = await client.query(sql);
  } catch (err) {
    return {
      pass: false,
      message: () => `Query execution failed.\n${err}`,
    };
  } finally {
    await client.end();
  }

  // Convert all the row data to strings (because the CSV values are only going
  // to be strings).
  received.rows.map((row) => {
    for (const key in row) {
      if(!row[key]) {
        if(row[key] != '0') { row[key] = 'NULL'; }
        else if(row[key] == '0') { row[key] = '0'; }
      }
      else {
        row[key] = row[key].toString();
      }
    }
  });

  // Compare the results. If any of the results files match
  // then the test passes.
  let pass = false;
  let diffStrings = [];
  for (const expected of expecteds) {
    pass = this.equals(received.rows, expected.data);
    diffStrings.push(diff(expected.data, received.rows, {
      expand: this.expand,
    }));

    if (pass) {
      break;
    }
  }

  return {
    pass,
    message: () => `Unexpected results from running the SQL in "${queryFN}".\nExpected one of the following:\n\n${diffStrings.join('\n\n----------\n\n')}`,
  };
}

function areNumbersApproxEqual(a, b, epsilon = 0.000001) {
  const aNum = Number(a);
  const bNum = Number(b);

  if (Number.isNaN(aNum) || Number.isNaN(bNum)) {
    console.log('Not a number:', a, b);
    return undefined;
  } else {
    return Math.abs(aNum - bNum) < epsilon;
  }
}

expect.addEqualityTesters([
  areNumbersApproxEqual,
]);

expect.extend({
  toReturnRecords,
});