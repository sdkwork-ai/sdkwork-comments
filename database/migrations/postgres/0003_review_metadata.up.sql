-- sdkwork:migration
-- id: 0003_review_metadata
-- engine: postgres
-- module: sdkwork-comments
-- purpose: Add optional review ratings and host metadata for product reviews,
--   plus edit timestamps and comment-reference integrity.
-- reversible: false
-- rollback: forward-fix (rating and metadata are optional extensions)
-- transactional: true
-- lock: lightweight
-- lock_timeout: 2s
-- statement_timeout: 30s

BEGIN;

ALTER TABLE comments_comment
  ADD COLUMN IF NOT EXISTS rating SMALLINT;

ALTER TABLE comments_comment
  DROP CONSTRAINT IF EXISTS ck_comments_comment_rating;

ALTER TABLE comments_comment
  ADD CONSTRAINT ck_comments_comment_rating
  CHECK (rating IS NULL OR (rating >= 1 AND rating <= 5));

ALTER TABLE comments_comment
  ADD COLUMN IF NOT EXISTS metadata_json JSONB NOT NULL DEFAULT '{}'::jsonb;

ALTER TABLE comments_comment
  ADD COLUMN IF NOT EXISTS edited_at TIMESTAMPTZ;

ALTER TABLE comments_comment
  DROP CONSTRAINT IF EXISTS fk_comments_comment_root;

ALTER TABLE comments_comment
  ADD CONSTRAINT fk_comments_comment_root
  FOREIGN KEY (root_comment_id) REFERENCES comments_comment (id) ON DELETE SET NULL;

ALTER TABLE comments_comment
  DROP CONSTRAINT IF EXISTS fk_comments_comment_quote;

ALTER TABLE comments_comment
  ADD CONSTRAINT fk_comments_comment_quote
  FOREIGN KEY (quote_comment_id) REFERENCES comments_comment (id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_comments_comment_rating
  ON comments_comment (thread_id, rating)
  WHERE rating IS NOT NULL;

COMMIT;
