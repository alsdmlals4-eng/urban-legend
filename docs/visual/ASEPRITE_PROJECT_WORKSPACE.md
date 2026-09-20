# Aseprite project candidate boundary

Current readback: 2026-09-14. This restores the missing routing document named by
the deployed `LOCAL_USAGE.md`, not a new installation or an asset approval.
Historical source `fe7b47259aee2133299ed53ac0e47bf47c19e541` was inspected; its old
verification claims are not promoted to current evidence.

- Use the already available `aseprite-urban-legend` restricted tools.
- Candidate root: `.asset-vault/aseprite-candidates/` within this repository.
- Use a unique task subdirectory; staged copies only, no canonical originals,
  links, secrets, other projects, or outside-project candidate roots.
- Read `C:/Users/user/.local/share/aseprite-local/LOCAL_USAGE.md` before use.
- Keep its existing 32 MiB input, 4096 axis, 256 frame and 16,777,216 aggregate
  decoded/export pixel limits. A rejected operation is not permission to use
  arbitrary Lua/CLI or change the tool configuration.
- Select Aseprite for candidate frame/layer/atlas organization and metadata QA.
  Select the image model for creative raster generation/editing. Neither route
  changes `SOFT_ANIME_NOIR_LOCKED` into pixel art.
- User's current separated-image route is chromakey generation then background
  removal, with original/candidate preserved and alpha/fringe inspection.
- Single-pose stills are not an animation. Do not loop unrelated poses or actors.
- Candidate output is not product approval. Root `ASSET_MANIFEST.yml` and
  `docs/IMAGE_ASSET_WORKFLOW.md` retain promotion and rights ownership.
- Preview/readback success does not establish Godot runtime or Human approval.

Current desktop tool discovery is observed; specific operations still require
their own call/output evidence. Do not inherit the historical stdio PASS or
restore its missing helper merely from this document.
