# Route Restore Endpoint Connectivity Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the route-restore minigame clear only when the rendered rail network actually connects the start to the safe destination and not to the false destination.

**Architecture:** Keep the existing 3×3 tutorial and 4×4 final boards, but move endpoint directions into board data and make `_connections_for()` the single connection source consumed by drawing, reachability, and confirmation. Remove `_is_solution()` from the production success path and add a non-color open-end marker derived from the same reciprocal connectivity rule.

**Tech Stack:** Godot 4.7.1, GDScript, existing SceneTree regression tests. Persistent `.gd` authoring MUST be performed through HiGodot MCP; GUT remains non-authoring test authority.

## Global Constraints

- Decision: `D-2026-08-10-ROUTE-RESTORE-ENDPOINT-CONNECTIVITY`.
- Base implementation branch from project `main` exact SHA `bbd3ebcaa8e379890428b9ca4e4172cb72a8f9f6` unless main advances before execution; if it advances, stop and rebase the plan evidence before authoring.
- Do not change `project.godot`, scenes, assets, episode data, move-count thresholds, grade thresholds, route lock/wobble semantics, result payload keys, or clue meaning.
- Tutorial safe endpoint remains SOUTH-facing; final safe endpoint is WEST-facing.
- Product success authority is only `safe reachable == true && false reachable == false`.
- No new image asset.
- All persistent `.gd` writes, including test `.gd` files, go through HiGodot MCP.

---

### Task 1: Add a RED connectivity regression

**Files:**
- Create: `tests/route_restore_connectivity_test.gd`
- Read: `scripts/minigames/route_restore_game.gd`

**Interfaces:**
- Consumes: `RouteGame.new()`, `configure(config: Dictionary, equipment_assisted: bool)`, private board builders and `_connections_for()`/`_get_reachability()` through `call()` where required by the existing test style.
- Produces: one focused SceneTree regression proving board endpoint direction and reachability behavior before the product fix.

- [ ] **Step 1: Author the failing test through HiGodot MCP**

Create `tests/route_restore_connectivity_test.gd` with assertions equivalent to:

```gdscript
extends SceneTree

const RouteGame = preload("res://scripts/minigames/route_restore_game.gd")
const WEST := Vector2i(-1, 0)
const SOUTH := Vector2i(0, 1)

func _init() -> void:
    var route := RouteGame.new()
    root.add_child(route)
    route.configure({}, false)

    var tutorial_safe: Array[Vector2i] = route.call("_connections_for", Vector2i(2, 0))
    assert(tutorial_safe == [SOUTH])

    route.call("_build_final_board")
    var final_safe: Array[Vector2i] = route.call("_connections_for", Vector2i(3, 0))
    assert(final_safe == [WEST])

    var disconnected := route.call("_get_reachability") as Dictionary
    assert(not bool(disconnected.get("safe", false)))

    route.queue_free()
    print("route_restore_connectivity_test: PASS")
    quit()
```

Extend the same test fixture with one state that matches the old hardcoded final `_is_solution()` tuple while the safe endpoint is disconnected, and assert that the route is not considered successful by the new confirmation contract.

- [ ] **Step 2: Run the focused test and verify RED**

Run from the isolated route worktree:

```powershell
& $godot --headless --path $repo -s tests/route_restore_connectivity_test.gd
```

Expected before the product fix: FAIL because final safe currently returns `[SOUTH]` rather than `[WEST]`; any assertion that assumes connectivity-only confirmation must also fail against the old `_is_solution()` bypass.

- [ ] **Step 3: Record RED evidence**

Capture the exact worktree HEAD, test command, exit code, and failing assertion in the implementation PR notes. Do not change product code before this RED is observed.

- [ ] **Step 4: Commit the RED test**

```bash
git add tests/route_restore_connectivity_test.gd
git commit -m "test: reproduce route endpoint connectivity defect"
```

---

### Task 2: Make endpoint directions board-owned and reachability authoritative

**Files:**
- Modify: `scripts/minigames/route_restore_game.gd`
- Test: `tests/route_restore_connectivity_test.gd`

**Interfaces:**
- Produces endpoint tiles carrying `connections: Array[Vector2i]`.
- `_connections_for(coord: Vector2i) -> Array[Vector2i]` reads endpoint `connections` for `start`, `safe`, and `false`.
- `_confirm_route()` succeeds only from `_get_reachability()`.

- [ ] **Step 1: Author the minimal product change through HiGodot MCP**

In `_build_tutorial_board()`, represent endpoint directions explicitly:

```gdscript
{"kind":"safe", "connections":[SOUTH]}
{"kind":"start", "connections":[EAST]}
{"kind":"false", "connections":[WEST]}
```

In `_build_final_board()`, make the final safe endpoint enter from the west:

```gdscript
{"kind":"safe", "connections":[WEST]}
```

Keep start/false explicit for the final board as well.

Update `_connections_for()` so endpoint kinds return the tile-owned array:

```gdscript
"start", "safe", "false":
    var stored: Variant = tile.get("connections", [])
    if stored is Array:
        var result: Array[Vector2i] = []
        for direction in stored:
            result.append(direction as Vector2i)
        return result
    return []
```

Do not change the existing curve/switch/straight direction mappings.

- [ ] **Step 2: Remove the hardcoded success bypass**

Change `_confirm_route()` from the current `_is_solution() or (...)` condition to:

```gdscript
var reach := _get_reachability()
if bool(reach.get("safe", false)) and not bool(reach.get("false", false)):
    # existing tutorial/final success flow
elif bool(reach.get("false", false)):
    # existing danger flow
else:
    # existing disconnected flow
```

`_is_solution()` must no longer be called by product confirmation. Delete it if no test or other caller requires it; otherwise leave it only as a non-authoritative test helper with a comment stating it cannot decide success.

- [ ] **Step 3: Run the focused connectivity test**

```powershell
& $godot --headless --path $repo -s tests/route_restore_connectivity_test.gd
```

Expected: PASS.

- [ ] **Step 4: Run maintained minigame regressions**

```powershell
& $godot --headless --path $repo -s tests/minigame_controls_test.gd
& $godot --headless --path $repo -s tests/minigame_scene_smoke_test.gd
& $godot --headless --path $repo -s tests/minigame_pipeline_test.gd
```

Expected: focused new test PASS; maintained tests must not introduce a new failure. If `minigame_pipeline_test.gd` reproduces the already-attributed baseline failure, record it separately and verify it matches pristine-main behavior rather than treating it as a new route regression.

- [ ] **Step 5: Commit the connectivity authority fix**

```bash
git add scripts/minigames/route_restore_game.gd tests/route_restore_connectivity_test.gd
git commit -m "fix: align route endpoints with connectivity"
```

---

### Task 3: Add a non-color open-end cue

**Files:**
- Modify: `scripts/minigames/route_restore_game.gd`
- Test: `tests/route_restore_connectivity_test.gd`

**Interfaces:**
- Consumes `_connections_for()` and board bounds.
- Produces helper `_has_reciprocal_connection(coord: Vector2i, direction: Vector2i) -> bool` and drawing that marks an open rail end without revealing the intended solution.

- [ ] **Step 1: Extend the RED test through HiGodot MCP**

Add an assertion that the script exposes a reciprocal-connection helper and that a known disconnected endpoint direction returns false while a reciprocal linked segment returns true after the test fixture is arranged.

Example contract:

```gdscript
assert(not route.call("_has_reciprocal_connection", Vector2i(3, 0), WEST))
```

before the adjacent tile points EAST, then assert true once the adjacent direction reciprocates.

- [ ] **Step 2: Run the test and verify RED**

Expected: FAIL because `_has_reciprocal_connection` does not exist yet.

- [ ] **Step 3: Implement the minimal shared helper and draw marker**

Use the same reciprocal rule as reachability:

```gdscript
func _has_reciprocal_connection(coord: Vector2i, direction: Vector2i) -> bool:
    var next := coord + direction
    return _is_in_bounds(next) and _connections_for(next).has(-direction)
```

In `_draw_tile()`, after drawing each rail arm, draw a small outlined square or perpendicular cap at the arm endpoint only when `_has_reciprocal_connection(coord, direction)` is false. Keep connected rail gold and disconnected rail dim as today; the cap is the non-color cue.

- [ ] **Step 4: Run focused and maintained tests**

Run the focused route test plus the three minigame regressions from Task 2. Expected: no new failures.

- [ ] **Step 5: Commit the visual cue**

```bash
git add scripts/minigames/route_restore_game.gd tests/route_restore_connectivity_test.gd
git commit -m "fix: mark disconnected route rail ends"
```

---

### Task 4: Exact-head verification and Windows Human QA handoff

**Files:**
- No product file changes unless a verified regression requires a new TDD cycle.

**Interfaces:**
- Produces exact-head verification evidence and Human QA evidence for the same commit.

- [ ] **Step 1: Run Godot 4.7.1 import on exact HEAD**

```powershell
& $godot --headless --path $repo --import
```

Expected: exit code 0.

- [ ] **Step 2: Run the project-maintained regression entrypoints required by the current CI contract**

At minimum run the focused route test and minigame regressions above; use the repository's current maintained full regression command/workflow if it has changed since this plan was written.

- [ ] **Step 3: Verify protected state**

```powershell
git -C $repo status --short
git -C $repo diff --name-status bbd3ebcaa8e379890428b9ca4e4172cb72a8f9f6..HEAD
```

Expected tracked changes only in the planned route source/test plus implementation evidence docs if added; no assets, scenes, project settings, or unrelated files.

- [ ] **Step 4: Windows Human QA**

Launch the exact-head build at 1280×720. Play the route minigame and verify:

- rail visibly reaches the `도착` tile when successful;
- a rail arm that does not reciprocally connect has a shape/cap cue, not only a color change;
- `C 경로 확인` does not accept the old orientation tuple when the endpoint is actually disconnected;
- false destination still triggers the existing danger behavior;
- tutorial→final transition, lock/wobble, move count and grade behavior remain intact.

- [ ] **Step 5: Update Decision/GitHub/Sheet with the exact implementation HEAD**

Use `D-2026-08-10-ROUTE-RESTORE-ENDPOINT-CONNECTIVITY` on both GitHub and Google Sheet. Do not mark merge-ready until exact-head automated evidence and the Human QA above are green.
