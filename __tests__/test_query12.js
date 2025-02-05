import { expect, describe, it } from '@jest/globals';
import './jest_extensions';

describe('Query 12', () => {
  it('should return the correct closest results', async () => {
    await expect('../query12.sql')
      .toReturnRecords([
        'expected_results/query12.csv',
        'expected_results/query12_alt.csv',
      ]);
  });
});