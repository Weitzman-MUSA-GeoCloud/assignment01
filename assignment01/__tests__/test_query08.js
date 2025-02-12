import { expect, describe, it } from '@jest/globals';
import './jest_extensions';

describe('Query 08', () => {
  it('should return the correct results', async () => {
    await expect('../query08.sql')
      .toReturnRecords(
        ['expected_results/query08.csv'],
      );
  });
});