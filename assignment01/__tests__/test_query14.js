import { expect, describe, it } from '@jest/globals';
import './jest_extensions';

describe('Query 14', () => {
  it('should return the correct closest results', async () => {
    await expect('../query14.sql')
      .toReturnRecords([
        'expected_results/query14.csv',
      ]);
  });
});