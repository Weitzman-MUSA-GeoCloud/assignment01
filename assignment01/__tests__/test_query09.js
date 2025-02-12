import { expect, describe, it } from '@jest/globals';
import './jest_extensions';

describe('Query 09', () => {
  it('should return the correct results', async () => {
    await expect('../query09.sql')
      .toReturnRecords(
        ['expected_results/query09.csv'],
        { orderBy: 'passholder_type' },
      );
  });
});