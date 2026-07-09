# Conventions
- Keep changes scoped; preserve existing scene node names, signals, save compatibility, and user changes.
- New GDScript files start with a Korean comment stating the script role.
- Treat `battle_scene` as anomaly stabilization/recovery, not RPG combat; avoid adding HP/damage/kill/death framing.
- Equipment and records are investigation aids, not stat farming. JSON IDs and `GameState` save keys are cross-scene contracts.
- Use `GameState` for persisted progress/equipment state and episode loader/data access patterns already in the project.