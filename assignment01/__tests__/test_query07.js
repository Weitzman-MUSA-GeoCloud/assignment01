import { expect, describe, it } from '@jest/globals';
import './jest_extensions';

describe('Query 07', () => {
  it('should return the correct results', async () => {
    await expect('../query07.sql')
      .toReturnRecords(
        ['expected_results/query07.csv'],
        { orderBy: 'trip_year' },
      );
  });
});