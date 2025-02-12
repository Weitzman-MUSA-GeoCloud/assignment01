import { expect, describe, it } from '@jest/globals';
import './jest_extensions';

describe('Query 05', () => {
  it('should return the correct results', async () => {
    await expect('../query05.sql')
      .toReturnRecords(
        ['expected_results/query05.csv'],
      );
  });
});