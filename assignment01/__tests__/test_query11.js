import { expect, describe, it } from '@jest/globals';
import './jest_extensions';

describe('Query 11', () => {
  it('should return the correct closest results', async () => {
    await expect('../query11.sql')
      .toReturnRecords(
        ['expected_results/query11.csv'],
      );
  });
});