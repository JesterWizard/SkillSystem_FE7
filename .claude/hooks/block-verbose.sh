#!/bin/bash

# Read the hook JSON from stdin
input=$(cat)

# Extract the command from the tool input
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# Block verbose commands before they enter context
if echo "$command" | grep -qE '(pytest|EXPLAIN ANALYZE)'; then
  echo "Use ctx_batch_execute instead." >&2
  exit 2
fi

if echo "$command" | grep -qE '(kubectl logs|kubectl describe|gcloud|gh api)'; then
  echo "Blocked: verbose output. Redirect to sandbox." >&2
  exit 2
fi

exit 0