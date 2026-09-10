"""Verify the approved candidate boundary using the existing restricted stdio server.

Blank frames are transport fixtures, never artwork or animation-quality evidence.
No dependencies are installed and no canonical assets are opened or modified.
"""
import asyncio
import hashlib
import json
import os
from pathlib import Path
import sys
import tempfile
import tomllib

from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client
from PIL import Image


PROJECT = Path(__file__).resolve().parents[2]
ROOT = PROJECT / ".asset-vault" / "aseprite-candidates"
CONFIG = Path(os.environ["USERPROFILE"]) / ".codex" / "config.toml"


async def main():
    cfg = tomllib.loads(CONFIG.read_text(encoding="utf-8"))["mcp_servers"]
    server = cfg["aseprite-urban-legend"]
    assert Path(server["env"]["ASEPRITE_WORKSPACE_ROOT"]).resolve() == ROOT.resolve()
    assert ROOT.resolve().is_relative_to(PROJECT.resolve())
    assert ROOT.is_dir() and not ROOT.is_symlink() and not ROOT.is_junction()
    assert len(server["enabled_tools"]) == 10
    assert "run_lua_script" not in server["enabled_tools"]
    # All temporary material, including the executable's scratch files, stays local.
    with tempfile.TemporaryDirectory(prefix="boundary-check-", dir=ROOT) as scratch:
        work = Path(scratch)
        rel = work.relative_to(ROOT).as_posix()
        env = dict(server["env"], TEMP=scratch, TMP=scratch, PYTHONDONTWRITEBYTECODE="1")
        params = StdioServerParameters(command=server["command"], args=server["args"],
                                       cwd=server["cwd"], env=env)
        async with stdio_client(params) as (read, write):
            async with ClientSession(read, write) as session:
                await session.initialize()
                names = {t.name for t in (await session.list_tools()).tools}
                assert names == set(server["enabled_tools"])

                async def call(name, args):
                    result = await session.call_tool(name, args)
                    assert not result.isError, result
                    output = "\n".join(c.text for c in result.content if c.type == "text")
                    assert not output.startswith(("Failed", "ERROR", "Invalid", "File ")), output
                    return output

                sprite = f"{rel}/fixture.aseprite"
                await call("create_canvas", {"width": 16, "height": 16, "filename": sprite})
                await call("add_frame", {"filename": sprite})
                await call("set_frame_duration", {"filename": sprite, "frame_index": 2, "duration_ms": 200})
                info = json.loads(await call("get_sprite_info", {"filename": sprite}))
                assert (info["width"], info["height"], info["frames"]) == (16, 16, 2)
                assert info["durations_ms"][1] == 200
                original_hash = hashlib.sha256((work / "fixture.aseprite").read_bytes()).hexdigest()
                await call("export_spritesheet", {"filename": sprite,
                    "output_filename": f"{rel}/sheet.png", "data_filename": f"{rel}/sheet.json"})
                with Image.open(work / "sheet.png") as image:
                    assert image.size == (32, 16)
                    assert image.convert("RGBA").getextrema()[3] == (0, 0)
                assert len(json.loads((work / "sheet.json").read_text())["frames"]) == 2
                rejected = 0
                for name, args in [
                    ("get_sprite_info", {"filename": "../outside.aseprite"}),
                    ("get_sprite_info", {"filename": str(PROJECT / "assets/outside.aseprite")}),
                    ("run_lua_script", {"script": "return 1"}),
                    ("export_frame", {"filename": sprite, "frame_index": 1, "output_filename": f"{rel}/sheet.png"}),
                ]:
                    result = await session.call_tool(name, args)
                    assert result.isError, (name, result)
                    rejected += 1
                assert hashlib.sha256((work / "fixture.aseprite").read_bytes()).hexdigest() == original_hash
                report = {"status": "PASS", "transport": "restricted_stdio",
                    "desktop_native_discovery": "NOT_RUN", "tool_count": len(names),
                    "negative_calls_blocked": rejected, "frame_count": 2,
                    "frame_2_ms": 200, "source_preserved": True,
                    "artwork_motion_runtime_human": "NOT_RUN", "candidate_root": str(ROOT)}
    print(json.dumps(report, ensure_ascii=False))


if __name__ == "__main__":
    asyncio.run(main())
