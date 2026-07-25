from pathlib import Path

menu_path = Path("scripts/ui/main_menu.gd")
menu = menu_path.read_text(encoding="utf-8")
annual_label = "ANNUAL-MVP-001 육성→사건→연구 PoC"
if annual_label not in menu:
    needle = '''\t_add_scene_button(
\t\tdev_content,
\t\t"CORE-MVP-001 조사→전조→포획 PoC",
\t\t"res://scenes/poc/core_mvp_001/core_mvp_001_scene.tscn"
\t)
'''
    insert = needle + '''\t_add_scene_button(
\t\tdev_content,
\t\t"ANNUAL-MVP-001 육성→사건→연구 PoC",
\t\t"res://scenes/poc/annual_mvp_001/annual_mvp_001_scene.tscn"
\t)
'''
    if needle not in menu:
        raise SystemExit("main menu CORE dev entry insertion point not found")
    menu = menu.replace(needle, insert, 1)
    menu_path.write_text(menu, encoding="utf-8")

runner_path = Path("tests/run_godot_regression.sh")
runner = runner_path.read_text(encoding="utf-8")
annual_tests = '''  annual_mvp_001_data_test
  annual_mvp_001_state_test
  annual_mvp_001_support_resolver_test
  annual_mvp_001_incident_adapter_test
  annual_mvp_001_save_data_test
  annual_mvp_001_scene_test
'''
if "annual_mvp_001_data_test" not in runner:
    needle = '''script_tests=(
  accessibility_settings_test
'''
    replacement = '''script_tests=(
''' + annual_tests + '''  accessibility_settings_test
'''
    if needle not in runner:
        raise SystemExit("regression script_tests insertion point not found")
    runner = runner.replace(needle, replacement, 1)
runner = runner.replace("Godot regression suite: 43/43 test entrypoints passed", "Godot regression suite: 49/49 test entrypoints passed")
runner_path.write_text(runner, encoding="utf-8")
