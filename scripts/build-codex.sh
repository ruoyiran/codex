#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<EOF
Usage: $0 [debug|release]

Build the codex binary from the codex-rs workspace.

Arguments:
  debug    Build the debug binary
  release  Build the release binary (default)

Examples:
  $0
  $0 debug
  $0 release
EOF
}

profile="${1:-release}"

case "$profile" in
  -h|--help)
    usage
    exit 0
    ;;
  debug)
    cargo_args=(build -p codex-cli --bin codex)
    binary_path="target/debug/codex"
    ;;
  release)
    cargo_args=(build --release -p codex-cli --bin codex)
    binary_path="target/release/codex"
    ;;
  *)
    echo "Unknown build profile: $profile" >&2
    usage >&2
    exit 1
    ;;
esac

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cargo_root="$repo_root/codex-rs"
manifest_path="$cargo_root/Cargo.toml"

if [[ ! -f "$manifest_path" ]]; then
  echo "Could not find codex-rs/Cargo.toml from repository root: $repo_root" >&2
  exit 1
fi

cargo "${cargo_args[@]}" --manifest-path "$manifest_path"

echo "$cargo_root/$binary_path"
