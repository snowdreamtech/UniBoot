#!/usr/bin/env bash
# ==============================================================================
# UniBoot Test Runner (Root Shortcut)
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Pass all arguments to the actual sync-and-test.sh in the scripts directory
bash "${SCRIPT_DIR}/scripts/sync-and-test.sh" "$@"
