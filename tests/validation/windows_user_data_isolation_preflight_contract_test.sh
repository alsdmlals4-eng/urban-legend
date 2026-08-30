#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

assert_first_entry() {
  local runner="$1"
  local array_name="$2"
  local expected="$3"
  local actual
  actual="$(awk -v array_name="$array_name" '
    $0 ~ "^" array_name "=\\(" { inside = 1; next }
    inside && $0 ~ /^[[:space:]]*$/ { next }
    inside { gsub(/^[[:space:]]+|[[:space:]]+$/, ""); print; exit }
  ' "$runner")"
  if [[ "$actual" != "$expected" ]]; then
    echo "FAILED: $(basename "$runner") must run $expected before any Godot test; found ${actual:-<missing>}" >&2
    return 1
  fi
}

assert_first_entry "$PROJECT_ROOT/tests/run_afterlife_canon_v2_migration_tests.sh" "entrypoints" '"res://tests/validation/windows_user_data_isolation_test.gd"'
assert_first_entry "$PROJECT_ROOT/tests/run_annual_mvp_001_tests.sh" "script_tests" "validation/windows_user_data_isolation_test"
assert_first_entry "$PROJECT_ROOT/tests/run_annual_mvp_002_tests.sh" "script_tests" "validation/windows_user_data_isolation_test"
assert_first_entry "$PROJECT_ROOT/tests/run_core_mvp_001_tests.sh" "tests" "validation/windows_user_data_isolation_test"
assert_first_entry "$PROJECT_ROOT/tests/run_godot_regression.sh" "script_tests" "validation/windows_user_data_isolation_test"
assert_first_entry "$PROJECT_ROOT/tests/run_validation_package_1_tests.sh" "script_tests" "validation/windows_user_data_isolation_test"
assert_first_entry "$PROJECT_ROOT/tests/run_validation_package_2_tests.sh" "script_tests" "validation/windows_user_data_isolation_test"

if ! grep -Fqx 'bash "$PROJECT_ROOT/tests/validation/windows_user_data_isolation_preflight_contract_test.sh"' "$PROJECT_ROOT/tests/run_godot_regression.sh"; then
  echo "FAILED: run_godot_regression.sh must invoke the preflight through PROJECT_ROOT" >&2
  exit 1
fi
if ! grep -Fqx '    bash "$PROJECT_ROOT/tests/run_afterlife_canon_v2_migration_tests.sh"' "$PROJECT_ROOT/tests/run_godot_regression.sh"; then
  echo "FAILED: run_godot_regression.sh must invoke the nested Afterlife suite through PROJECT_ROOT" >&2
  exit 1
fi

echo "WINDOWS USER DATA ISOLATION PREFLIGHT CONTRACT: PASS"
