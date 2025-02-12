import { expect, describe, it } from '@jest/globals';
import './jest_extensions';

describe('Query 13', () => {
  it('should return the correct closest results', async () => {
    await expect('../query13.sql')
      .toReturnRecords([
        'expected_results/query13.csv',
      ]);
  });
});