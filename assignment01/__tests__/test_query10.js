import { expect, describe, it } from '@jest/globals';
import './jest_extensions';

describe('Query 10', () => {
  it('should return the correct results (when checking the closest results)', async () => {
    await expect('../query10.sql')
      .toReturnRecords(
        ['expected_results/query10asc.csv'],
        { orderBy: 'distance, station_id', limit: 5 },
      );
  });

  it('should return the correct results (when checking the farthest results)', async () => {
    await expect('../query10.sql')
      .toReturnRecords(
        ['expected_results/query10desc.csv'],
        { orderBy: 'distance desc, station_id', limit: 5 },
      );
  });
});