#!/usr/bin/env bash
set -euo pipefail

# We do not use the travis npm deploy integration as it does not allow us to
# deploy a subpath and and v2 which should, just errors out that the src does not exist
main() {
  cd "$(dirname "$0")/../.."

  echo "//registry.npmjs.org/:_authToken=${NPM_TOKEN}" > ~/.npmrc
  ./ci/container/exec.sh yarn publish --non-interactive release
}

main "$@"
