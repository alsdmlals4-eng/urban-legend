# Aseprite project candidate boundary

Approval: current user request, 2026-09-10, project-local candidate boundary approved.
The existing machine build/server is reused; no installation, paid service or raw Lua is added.

- Shared runtime: `C:/Users/user/.local/share/aseprite-local/mcp` (not game content).
- Configuration entry: `aseprite-urban-legend`; existing `aseprite-candidates` remains unchanged.
- Project candidate root: `.asset-vault/aseprite-candidates/` under this repository.
- Every production task uses a unique subdirectory. No symlinks/junctions/hardlinks.
- Never pass originals under `assets/` or any other project to this server.
- Reuse the deployed 10-tool allowlist, file/axis/frame/pixel limits and overwrite rejection.
- New art/editing uses the image model. Aseprite organizes approved candidate copies, not creative primitives.
- Desktop reload/native discovery of the new entry remains `NOT_RUN`.
- The same configured restricted server was actually verified through stdio: list 10 tools,
  two blank fixture frames, frame 2 at 200 ms, transparent 32x16 PNG + JSON export,
  unchanged source and four denied operations (path escape, canonical asset path, Lua, overwrite).
- Test fixtures are not artwork and do not prove motion quality, user approval or Godot integration.
- Temporary test files are contained inside the candidate root and removed after each test.

Revalidation: run `tools/qa/verify_project_aseprite.py` with the existing deployment Python
environment. It reads the named configuration entry, performs real MCP calls, checks outputs
and prints a bounded JSON result; it never installs packages or modifies runtime assets.

Rollback: remove only `mcp_servers.aseprite-urban-legend` and its env table from local Codex config,
then reload the client. Preserve the shared server and other settings. Candidate cleanup requires
exact path/source/consumer checks. Do not copy the locally built Aseprite executable into Git.
