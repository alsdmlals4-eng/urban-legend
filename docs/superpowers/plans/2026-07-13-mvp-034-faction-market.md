# Ver 3.4 Faction Contact and Echo Market Plan

**Goal:** Add persistent faction relationships, idempotent echo-fragment rewards, a functional rumor market, and preparation loadouts without consuming clues or unique agent gear.

**Architecture:** `GameState` owns economy, faction tiers, catalog pricing, purchases, consumable inventory/loadout, one-time rewards, and save migration. Preparation exposes external contacts; the market scene renders catalog and calls those APIs. Recovery/result hooks only grant unique reward IDs or consume active support items.

## Tasks

1. Add deterministic headless tests for reward idempotence, relation tiers/prices/locks, permanent purchases, consumable caps/loadout, requests, and save round trip.
2. Add economy and faction state to `GameState` with safe mvp-033 defaults.
3. Add the rumor market scene and preparation external-contact panel.
4. Connect clue, correct-pattern, request, and resolution rewards with unique IDs.
5. Connect purchased permanent gear and carried consumables to recovery support effects.
6. Update Ver 3.4 / MVP-034 / mvp-034 docs and Base before/after rules.
7. Run all prior and new tests plus preparation/market/recovery scene smoke checks.
