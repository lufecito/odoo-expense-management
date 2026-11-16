#!/usr/bin/env bash
# Invite a collaborator to this repository. Runs from a systemd user timer.
set -euo pipefail

REPO="lufecito/odoo-expense-management"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG="$ROOT/ops/invite.log"
INVITEE_FILE="$ROOT/ops/invitee.txt"
PERMISSION="push"

log() { printf '%s %s\n' "$(date -Is)" "$*" >>"$LOG"; }

username="$(grep -v '^\s*#' "$INVITEE_FILE" 2>/dev/null | grep -v '^\s*$' | head -1 | tr -d '[:space:]' || true)"
if [ -z "${username:-}" ]; then
  log "ABORT no username configured in ops/invitee.txt"
  exit 1
fi

if ! command -v gh >/dev/null 2>&1; then
  log "ABORT gh not found"
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  log "ABORT gh not authenticated"
  exit 1
fi

# Verify the account exists before inviting anyone.
if ! gh api "/users/$username" >/dev/null 2>&1; then
  log "ABORT GitHub user '$username' not found"
  exit 1
fi

if gh api "/repos/$REPO/collaborators/$username" >/dev/null 2>&1; then
  log "SKIP $username is already a collaborator of $REPO"
else
  if gh api -X PUT "/repos/$REPO/collaborators/$username" -f permission="$PERMISSION" >/dev/null 2>&1; then
    log "OK invited $username to $REPO with permission=$PERMISSION"
  else
    log "FAIL could not invite $username to $REPO"
    exit 1
  fi
fi

if command -v notify-send >/dev/null 2>&1; then
  notify-send "Odoo expense repo" "Invitation processed for $username. See ops/invite.log" || true
fi
