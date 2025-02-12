import { expect, describe, it } from '@jest/globals';
import './jest_extensions';

describe('Query 04', () => {
  it('should return the correct results', async () => {
    await expect('../query04.sql')
      .toReturnRecords(
        ['expected_results/query04.csv'],
      );
  });
});