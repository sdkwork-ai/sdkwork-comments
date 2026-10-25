-- 002_ai_model_eval_threads.sql — deterministic threads for the storefront
-- AI 模型测评 (ai-model-eval) demo suite, referenced by the sdkwork-appstore
-- storefront seeds (tenant 100001).
--
-- Two owner kinds:
--   appstore-listing       owner_id = listing id        (app-level reviews; the
--                            uuid mirrors appstore_listing.comments_thread_id)
--   appstore-listing-spec  owner_id = "{listingId}:{specId}"  (per-spec
--                            evaluation threads; ensured idempotently by the
--                            PC storefront at runtime)
--
-- Reserved stable id blocks (DATABASE_SPEC §6.4, kept far below the snowflake
-- range so generated ids can never collide):
--   731000000001+ listing threads, 732000000001+ spec threads.
-- Comments and projections live in the locale seed
-- locales/zh-CN/002_ai_model_eval_comments.sql and use 733000000001+ /
-- 734000000001+.

INSERT INTO comments_thread
    (id, uuid, tenant_id, organization_id, owner_kind, owner_id, title, locked, status, payload_json, created_at, updated_at, version)
VALUES
    -- App-level listing threads (uuid = appstore_listing.comments_thread_id)
    (731000000001, 'thread-app-eval-model-arena', 100001, 0, 'appstore-listing', 'app-eval-model-arena', 'app-eval-model-arena', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '30 days', CURRENT_TIMESTAMP, 0),
    (731000000002, 'thread-app-eval-agent-arena', 100001, 0, 'appstore-listing', 'app-eval-agent-arena', 'app-eval-agent-arena', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '30 days', CURRENT_TIMESTAMP, 0),
    (731000000003, 'thread-app-eval-math-arena', 100001, 0, 'appstore-listing', 'app-eval-math-arena', 'app-eval-math-arena', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '21 days', CURRENT_TIMESTAMP, 0),
    (731000000004, 'thread-app-eval-longctx-arena', 100001, 0, 'appstore-listing', 'app-eval-longctx-arena', 'app-eval-longctx-arena', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '21 days', CURRENT_TIMESTAMP, 0),
    (731000000005, 'thread-app-eval-multimodal-arena', 100001, 0, 'appstore-listing', 'app-eval-multimodal-arena', 'app-eval-multimodal-arena', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '14 days', CURRENT_TIMESTAMP, 0),
    (731000000006, 'thread-app-eval-tools-arena', 100001, 0, 'appstore-listing', 'app-eval-tools-arena', 'app-eval-tools-arena', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '14 days', CURRENT_TIMESTAMP, 0),

    -- 大模型能力竞技场 (app-eval-model-arena) spec threads
    (732000000001, 'sev-app-eval-model-arena:model-gpt-5', 100001, 0, 'appstore-listing-spec', 'app-eval-model-arena:model-gpt-5', 'app-eval-model-arena · model-gpt-5', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '30 days', CURRENT_TIMESTAMP, 0),
    (732000000002, 'sev-app-eval-model-arena:model-claude-sonnet-45', 100001, 0, 'appstore-listing-spec', 'app-eval-model-arena:model-claude-sonnet-45', 'app-eval-model-arena · model-claude-sonnet-45', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '30 days', CURRENT_TIMESTAMP, 0),
    (732000000003, 'sev-app-eval-model-arena:model-deepseek-v32', 100001, 0, 'appstore-listing-spec', 'app-eval-model-arena:model-deepseek-v32', 'app-eval-model-arena · model-deepseek-v32', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '30 days', CURRENT_TIMESTAMP, 0),
    (732000000004, 'sev-app-eval-model-arena:model-gemini-25-pro', 100001, 0, 'appstore-listing-spec', 'app-eval-model-arena:model-gemini-25-pro', 'app-eval-model-arena · model-gemini-25-pro', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '30 days', CURRENT_TIMESTAMP, 0),
    (732000000005, 'sev-app-eval-model-arena:model-qwen3-max', 100001, 0, 'appstore-listing-spec', 'app-eval-model-arena:model-qwen3-max', 'app-eval-model-arena · model-qwen3-max', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '30 days', CURRENT_TIMESTAMP, 0),
    (732000000006, 'sev-app-eval-model-arena:model-glm-47', 100001, 0, 'appstore-listing-spec', 'app-eval-model-arena:model-glm-47', 'app-eval-model-arena · model-glm-47', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '30 days', CURRENT_TIMESTAMP, 0),
    (732000000007, 'sev-app-eval-model-arena:model-kimi-k2', 100001, 0, 'appstore-listing-spec', 'app-eval-model-arena:model-kimi-k2', 'app-eval-model-arena · model-kimi-k2', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '30 days', CURRENT_TIMESTAMP, 0),
    (732000000008, 'sev-app-eval-model-arena:model-doubao-16', 100001, 0, 'appstore-listing-spec', 'app-eval-model-arena:model-doubao-16', 'app-eval-model-arena · model-doubao-16', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '30 days', CURRENT_TIMESTAMP, 0),

    -- 编程 Agent 评测 (app-eval-agent-arena) spec threads
    (732000000009, 'sev-app-eval-agent-arena:agent-birdcoder', 100001, 0, 'appstore-listing-spec', 'app-eval-agent-arena:agent-birdcoder', 'app-eval-agent-arena · agent-birdcoder', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '30 days', CURRENT_TIMESTAMP, 0),
    (732000000010, 'sev-app-eval-agent-arena:agent-codex', 100001, 0, 'appstore-listing-spec', 'app-eval-agent-arena:agent-codex', 'app-eval-agent-arena · agent-codex', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '30 days', CURRENT_TIMESTAMP, 0),
    (732000000011, 'sev-app-eval-agent-arena:agent-claude-code', 100001, 0, 'appstore-listing-spec', 'app-eval-agent-arena:agent-claude-code', 'app-eval-agent-arena · agent-claude-code', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '30 days', CURRENT_TIMESTAMP, 0),
    (732000000012, 'sev-app-eval-agent-arena:agent-gemini-cli', 100001, 0, 'appstore-listing-spec', 'app-eval-agent-arena:agent-gemini-cli', 'app-eval-agent-arena · agent-gemini-cli', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '30 days', CURRENT_TIMESTAMP, 0),
    (732000000013, 'sev-app-eval-agent-arena:agent-cursor', 100001, 0, 'appstore-listing-spec', 'app-eval-agent-arena:agent-cursor', 'app-eval-agent-arena · agent-cursor', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '30 days', CURRENT_TIMESTAMP, 0),
    (732000000014, 'sev-app-eval-agent-arena:agent-copilot', 100001, 0, 'appstore-listing-spec', 'app-eval-agent-arena:agent-copilot', 'app-eval-agent-arena · agent-copilot', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '30 days', CURRENT_TIMESTAMP, 0),

    -- 数学推理评测 (app-eval-math-arena) spec threads
    (732000000015, 'sev-app-eval-math-arena:model-deepseek-v32', 100001, 0, 'appstore-listing-spec', 'app-eval-math-arena:model-deepseek-v32', 'app-eval-math-arena · model-deepseek-v32', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '21 days', CURRENT_TIMESTAMP, 0),
    (732000000016, 'sev-app-eval-math-arena:model-gpt-5', 100001, 0, 'appstore-listing-spec', 'app-eval-math-arena:model-gpt-5', 'app-eval-math-arena · model-gpt-5', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '21 days', CURRENT_TIMESTAMP, 0),
    (732000000017, 'sev-app-eval-math-arena:model-gemini-25-pro', 100001, 0, 'appstore-listing-spec', 'app-eval-math-arena:model-gemini-25-pro', 'app-eval-math-arena · model-gemini-25-pro', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '21 days', CURRENT_TIMESTAMP, 0),
    (732000000018, 'sev-app-eval-math-arena:model-claude-sonnet-45', 100001, 0, 'appstore-listing-spec', 'app-eval-math-arena:model-claude-sonnet-45', 'app-eval-math-arena · model-claude-sonnet-45', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '21 days', CURRENT_TIMESTAMP, 0),
    (732000000019, 'sev-app-eval-math-arena:model-qwen3-max', 100001, 0, 'appstore-listing-spec', 'app-eval-math-arena:model-qwen3-max', 'app-eval-math-arena · model-qwen3-max', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '21 days', CURRENT_TIMESTAMP, 0),
    (732000000020, 'sev-app-eval-math-arena:model-kimi-k2', 100001, 0, 'appstore-listing-spec', 'app-eval-math-arena:model-kimi-k2', 'app-eval-math-arena · model-kimi-k2', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '21 days', CURRENT_TIMESTAMP, 0),

    -- 长文本理解评测 (app-eval-longctx-arena) spec threads
    (732000000021, 'sev-app-eval-longctx-arena:model-kimi-k2', 100001, 0, 'appstore-listing-spec', 'app-eval-longctx-arena:model-kimi-k2', 'app-eval-longctx-arena · model-kimi-k2', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '21 days', CURRENT_TIMESTAMP, 0),
    (732000000022, 'sev-app-eval-longctx-arena:model-gemini-25-pro', 100001, 0, 'appstore-listing-spec', 'app-eval-longctx-arena:model-gemini-25-pro', 'app-eval-longctx-arena · model-gemini-25-pro', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '21 days', CURRENT_TIMESTAMP, 0),
    (732000000023, 'sev-app-eval-longctx-arena:model-claude-sonnet-45', 100001, 0, 'appstore-listing-spec', 'app-eval-longctx-arena:model-claude-sonnet-45', 'app-eval-longctx-arena · model-claude-sonnet-45', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '21 days', CURRENT_TIMESTAMP, 0),
    (732000000024, 'sev-app-eval-longctx-arena:model-qwen3-max', 100001, 0, 'appstore-listing-spec', 'app-eval-longctx-arena:model-qwen3-max', 'app-eval-longctx-arena · model-qwen3-max', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '21 days', CURRENT_TIMESTAMP, 0),
    (732000000025, 'sev-app-eval-longctx-arena:model-deepseek-v32', 100001, 0, 'appstore-listing-spec', 'app-eval-longctx-arena:model-deepseek-v32', 'app-eval-longctx-arena · model-deepseek-v32', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '21 days', CURRENT_TIMESTAMP, 0),

    -- 多模态理解评测 (app-eval-multimodal-arena) spec threads
    (732000000026, 'sev-app-eval-multimodal-arena:model-gemini-25-pro', 100001, 0, 'appstore-listing-spec', 'app-eval-multimodal-arena:model-gemini-25-pro', 'app-eval-multimodal-arena · model-gemini-25-pro', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '14 days', CURRENT_TIMESTAMP, 0),
    (732000000027, 'sev-app-eval-multimodal-arena:model-gpt-5', 100001, 0, 'appstore-listing-spec', 'app-eval-multimodal-arena:model-gpt-5', 'app-eval-multimodal-arena · model-gpt-5', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '14 days', CURRENT_TIMESTAMP, 0),
    (732000000028, 'sev-app-eval-multimodal-arena:model-claude-sonnet-45', 100001, 0, 'appstore-listing-spec', 'app-eval-multimodal-arena:model-claude-sonnet-45', 'app-eval-multimodal-arena · model-claude-sonnet-45', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '14 days', CURRENT_TIMESTAMP, 0),
    (732000000029, 'sev-app-eval-multimodal-arena:model-qwen3-max', 100001, 0, 'appstore-listing-spec', 'app-eval-multimodal-arena:model-qwen3-max', 'app-eval-multimodal-arena · model-qwen3-max', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '14 days', CURRENT_TIMESTAMP, 0),
    (732000000030, 'sev-app-eval-multimodal-arena:model-doubao-16', 100001, 0, 'appstore-listing-spec', 'app-eval-multimodal-arena:model-doubao-16', 'app-eval-multimodal-arena · model-doubao-16', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '14 days', CURRENT_TIMESTAMP, 0),

    -- 工具调用评测 (app-eval-tools-arena) spec threads
    (732000000031, 'sev-app-eval-tools-arena:model-glm-47', 100001, 0, 'appstore-listing-spec', 'app-eval-tools-arena:model-glm-47', 'app-eval-tools-arena · model-glm-47', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '14 days', CURRENT_TIMESTAMP, 0),
    (732000000032, 'sev-app-eval-tools-arena:model-claude-sonnet-45', 100001, 0, 'appstore-listing-spec', 'app-eval-tools-arena:model-claude-sonnet-45', 'app-eval-tools-arena · model-claude-sonnet-45', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '14 days', CURRENT_TIMESTAMP, 0),
    (732000000033, 'sev-app-eval-tools-arena:model-deepseek-v32', 100001, 0, 'appstore-listing-spec', 'app-eval-tools-arena:model-deepseek-v32', 'app-eval-tools-arena · model-deepseek-v32', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '14 days', CURRENT_TIMESTAMP, 0),
    (732000000034, 'sev-app-eval-tools-arena:model-gpt-5', 100001, 0, 'appstore-listing-spec', 'app-eval-tools-arena:model-gpt-5', 'app-eval-tools-arena · model-gpt-5', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '14 days', CURRENT_TIMESTAMP, 0),
    (732000000035, 'sev-app-eval-tools-arena:model-qwen3-max', 100001, 0, 'appstore-listing-spec', 'app-eval-tools-arena:model-qwen3-max', 'app-eval-tools-arena · model-qwen3-max', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '14 days', CURRENT_TIMESTAMP, 0),
    (732000000036, 'sev-app-eval-tools-arena:model-gemini-25-pro', 100001, 0, 'appstore-listing-spec', 'app-eval-tools-arena:model-gemini-25-pro', 'app-eval-tools-arena · model-gemini-25-pro', FALSE, 'open', '{}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '14 days', CURRENT_TIMESTAMP, 0)
ON CONFLICT (id) DO NOTHING;
