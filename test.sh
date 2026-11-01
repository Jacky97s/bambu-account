#!/usr/bin/env bash
# Runs bambu-account against a temp dir; never touches the real Bambu Studio config.
set -euo pipefail

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
export BAMBU_STUDIO_DIR="$tmp/studio" BAMBU_ACCOUNT_STORE="$tmp/store" BAMBU_STUDIO_PROC=bambu-account-test-none
mkdir -p "$BAMBU_STUDIO_DIR"
conf="$BAMBU_STUDIO_DIR/BambuNetworkEngine.conf"
cmd="$(dirname "$0")/bambu-account"

echo work >"$conf"
"$cmd" save work >/dev/null
"$cmd" logout >/dev/null
[[ ! -f $conf ]] || { echo "FAIL: logout kept conf"; exit 1; }

echo home >"$conf"
"$cmd" save home >/dev/null
"$cmd" use work >/dev/null
[[ $(cat "$conf") == work ]] || { echo "FAIL: use work"; exit 1; }
[[ $(cat "$BAMBU_ACCOUNT_STORE/_last/BambuNetworkEngine.conf") == home ]] || { echo "FAIL: _last backup"; exit 1; }
"$cmd" use home >/dev/null
[[ $(cat "$conf") == home ]] || { echo "FAIL: use home"; exit 1; }

! "$cmd" use missing 2>/dev/null || { echo "FAIL: missing name accepted"; exit 1; }
[[ $("$cmd" list | tr '\n' ' ') == "_last home work " ]] || { echo "FAIL: list"; exit 1; }

echo "All tests passed"
