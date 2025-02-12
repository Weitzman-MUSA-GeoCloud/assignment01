import { expect, describe, it } from '@jest/globals';
import './jest_extensions';

describe('Query 03', () => {
  it('should return the correct results', async () => {
    await expect('../query03.sql')
      .toReturnRecords(
        ['expected_results/query03.csv'],
      );
  });
});