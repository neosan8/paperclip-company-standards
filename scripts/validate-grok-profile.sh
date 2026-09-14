#!/bin/bash
# validate-grok-profile.sh — machine check that the Grok Bot primary profile
# is what the JSON says. A standard nobody runs is not a standard.
#
# KULLANIM:
#   ./scripts/validate-grok-profile.sh
#
# ÇIKIŞ KODU: 0 = hepsi geçti · 1 = en az bir invariant bozulmuş

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODELS="$REPO_ROOT/config/models.json"
ROLES="$REPO_ROOT/config/roles.json"
CENTRALS="$REPO_ROOT/config/central-companies.json"

PASS=0
FAIL=0

ok()  { PASS=$((PASS+1)); printf '  ✅ %s\n' "$1"; }
bad() { FAIL=$((FAIL+1)); printf '  ❌ %s\n' "$1"; [ -n "${2:-}" ] && printf '       → %s\n' "$2"; }

printf 'Grok Bot primary profile — denetim\n'

if ! command -v jq >/dev/null 2>&1; then
  echo "jq gerekli"
  exit 1
fi

check_eq() {
  local label="$1" got="$2" want="$3"
  if [ "$got" = "$want" ]; then
    ok "$label = $want"
  else
    bad "$label" "got '$got' want '$want'"
  fi
}

check_not_latest() {
  local label="$1" got="$2"
  if printf '%s' "$got" | grep -qi 'latest'; then
    bad "$label contains latest" "$got"
  else
    ok "$label is not latest ($got)"
  fi
}

primary=$(jq -r '.primary_profile // empty' "$MODELS")
check_eq "models.primary_profile" "$primary" "grok_bot_game"

for role in ceo worker reviewer; do
  adapter=$(jq -r --arg r "$role" '.[$r].adapter // empty' "$MODELS")
  model=$(jq -r --arg r "$role" '.[$r].model // empty' "$MODELS")
  linux=$(jq -r --arg r "$role" '.[$r].adapter_linux_grok_bot_worker // empty' "$MODELS")
  check_eq "models.$role.adapter" "$adapter" "cursor"
  check_eq "models.$role.adapter_linux_grok_bot_worker" "$linux" "cursor-local"
  check_not_latest "models.$role.model" "$model"
done

roles_primary=$(jq -r '.primary_profile // empty' "$ROLES")
check_eq "roles.primary_profile" "$roles_primary" "grok_bot_game"

slots=$(jq -r '.total_slots_per_company // empty' "$ROLES")
check_eq "roles.total_slots_per_company" "$slots" "3"

reviewer_must=$(jq -r '.policy.reviewer_must_exist // empty' "$ROLES")
check_eq "roles.policy.reviewer_must_exist" "$reviewer_must" "true"

ceo_api=$(jq -r '.roles[] | select(.role=="ceo") | .paperclip_api_role' "$ROLES")
worker_api=$(jq -r '.roles[] | select(.role=="worker") | .paperclip_api_role' "$ROLES")
reviewer_api=$(jq -r '.roles[] | select(.role=="reviewer") | .paperclip_api_role' "$ROLES")
check_eq "roles.ceo.paperclip_api_role" "$ceo_api" "ceo"
check_eq "roles.worker.paperclip_api_role" "$worker_api" "engineer"
check_eq "roles.reviewer.paperclip_api_role" "$reviewer_api" "qa"

required=$(jq -r '.required_roles | join(",")' "$ROLES")
check_eq "roles.required_roles" "$required" "ceo,worker,reviewer"

bootstrap=$(jq -r '.grok_bot_seats_bootstrap_this_layer | tostring' "$CENTRALS")
check_eq "central-companies.grok_bot_seats_bootstrap_this_layer" "$bootstrap" "false"

legacy_used=$(jq -r '.legacy_five_slot.used_by_grok_bot_seats | tostring' "$MODELS")
check_eq "models.legacy_five_slot.used_by_grok_bot_seats" "$legacy_used" "false"

ceo_idle=$(jq -r '.roles[] | select(.role=="ceo") | .idle_of_production_execution | tostring' "$ROLES")
check_eq "roles.ceo.idle_of_production_execution" "$ceo_idle" "true"

policy_idle=$(jq -r '.policy.ceo_idle_of_production_execution | tostring' "$ROLES")
check_eq "roles.policy.ceo_idle_of_production_execution" "$policy_idle" "true"

# Standing Neo / Atakan 2026-09-14 lock must stay on the Grok primary path.
# Phrase is the load-bearing wording; heartbeat OFF is not a substitute.
require_phrase() {
  local file="$1" phrase="$2"
  if grep -qF "$phrase" "$REPO_ROOT/$file"; then
    ok "$file contains '$phrase'"
  else
    bad "$file missing required phrase" "$phrase"
  fi
}

for f in \
  roles/ceo/SOUL.md \
  roles/ceo/README.md \
  docs/company-architecture.md \
  docs/flows/new-company-checklist.md \
  standards/cc-paperclip-communication-protocol.md \
  CONTEXT.md \
  AGENTS.md
do
  require_phrase "$f" "idle of production"
done

printf '\ngeçti: %d · başarısız: %d\n' "$PASS" "$FAIL"
if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
