import { expect, describe, it } from '@jest/globals';
import './jest_extensions';

describe('Query 06', () => {
  it('should return the correct results', async () => {
    await expect('../query06.sql')
      .toReturnRecords(
        ['expected_results/query06.csv'],
        { orderBy: 'trip_year' },
      );
  });
});