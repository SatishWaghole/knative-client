#!/usr/bin/env bash
# The script prepares Serving/Eventing instances on OpenShift and executes E2E tests

source "$(dirname "$0")/e2e-common.sh"

set -Eeuox pipefail

failed=0

# Build binary & unit tests
(( !failed )) && build_knative_client || failed=1
(( !failed )) && run_unit_tests || failed=1

if [[ "${PULL_BASE_REF:-}" == "release-next" ]]; then
  # Midstream based setup to run on nightly versions of Serving & Eventing
  # Serving setup & tests
  (( !failed )) && install_knative_serving_branch "${SERVING_BRANCH}" || failed=1
  (( !failed )) && run_client_e2e_tests serving || failed=1
  # Eventing setup & tests
  (( !failed )) && install_knative_eventing_branch "${EVENTING_BRANCH}" || failed=1
  (( !failed )) && run_client_e2e_tests eventing || failed=1
else
  # Serverless operator based setup for release branches
  (( !failed )) && install_serverless_operator_branch "${SERVERLESS_BRANCH}" || failed=1
  (( !failed )) && run_client_e2e_tests serving || failed=1
  (( !failed )) && run_client_e2e_tests eventing || failed=1
fi

(( failed )) && exit 1

success
