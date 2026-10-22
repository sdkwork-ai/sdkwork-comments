-- sdkwork:migration
-- id: 0002_comment_threading
-- engine: postgres
-- module: sdkwork-comments
-- purpose: Add generic two-level threading, quote references, author snapshots,
--   and reply counters for professional comment threads.
-- reversible: false
-- rollback: forward-fix (columns are additive; old clients ignore them)
-- transactional: true
-- lock: lightweight
-- lock_timeout: 2s
-- statement_timeout: 30s

BEGIN;

ALTER TABLE comments_comment
  ADD COLUMN IF NOT EXISTS root_comment_id BIGINT;

ALTER TABLE comments_comment
  ADD COLUMN IF NOT EXISTS quote_comment_id BIGINT;

ALTER TABLE comments_comment
  ADD COLUMN IF NOT EXISTS author_name VARCHAR(128);

ALTER TABLE comments_comment
  ADD COLUMN IF NOT EXISTS author_avatar_url TEXT;

ALTER TABLE comments_comment
  ADD COLUMN IF NOT EXISTS reply_count INTEGER NOT NULL DEFAULT 0;

CREATE INDEX IF NOT EXISTS idx_comments_comment_thread_root_created
  ON comments_comment (tenant_id, organization_id, thread_id, root_comment_id, created_at);

CREATE INDEX IF NOT EXISTS idx_comments_comment_quote
  ON comments_comment (quote_comment_id);

COMMIT;
