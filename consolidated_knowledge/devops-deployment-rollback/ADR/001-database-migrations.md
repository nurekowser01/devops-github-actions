# Context
Automated rollbacks of container code are instant. However, if the newer code applied a database migration (e.g., `DROP COLUMN`), reverting to the old container code will cause immediate crashes because the old code expects the column to exist.

# Decision
We strictly enforce **Expand and Contract (Backwards Compatible) Database Migrations**.

# Consequences
- **Positive:** Automated container rollbacks (`v1.1` to `v1.0`) will never crash the application due to schema mismatches.
- **Negative:** Database changes take multiple deployment cycles. For example, to rename a column:
  1. Add new column (v1.1)
  2. Write to both, read from old (v1.2)
  3. Backfill data (script)
  4. Write to both, read from new (v1.3)
  5. Drop old column (v1.4)
