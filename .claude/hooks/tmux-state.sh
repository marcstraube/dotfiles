#!/usr/bin/env bash
# Claude Code hook: mirror the session state into the tmux window list.
# Sets the window options @claude (icon) and @claude_state (name); tmux.conf
# appends #{@claude} to window-status-format and clears "done" on visit.
#
#   working  - Claude is busy (prompt sent, tool running)
#   waiting  - Claude needs you (permission prompt, question)
#   done     - turn finished while you were looking elsewhere
#   error    - turn ended with an API error
[[ -n $TMUX && -n $TMUX_PANE ]] || exit 0
input=$(cat)
event=$(jq -r '.hook_event_name // empty' <<<"$input")
tool=$(jq -r '.tool_name // empty' <<<"$input")

case $event in
    UserPromptSubmit | PostToolUse | PostToolUseFailure) state=working ;;
    PreToolUse)
        # Questions block on the user just like permission prompts do.
        [[ $tool == AskUserQuestion ]] && state=waiting || state=working ;;
    PermissionRequest | Notification) state=waiting ;;
    Stop) state=done ;;
    StopFailure) state=error ;;
    SessionStart | SessionEnd) state=clear ;;
    *) exit 0 ;;
esac

# A finished turn in the window you are looking at needs no marker.
if [[ $state == done ]]; then
    seen=$(tmux display -p -t "$TMUX_PANE" '#{&&:#{window_active},#{session_attached}}' 2>/dev/null)
    [[ $seen == 1 ]] && state=clear
fi

case $state in
    working) icon=$'' ;;   # nf-fa-cog
    waiting) icon=$'' ;;   # nf-fa-bell
    done) icon=$'' ;;      # nf-fa-check
    error) icon=$'' ;;     # nf-fa-times
esac

if [[ $state == clear ]]; then
    tmux set -w -t "$TMUX_PANE" -u @claude \; set -w -t "$TMUX_PANE" -u @claude_state
else
    tmux set -w -t "$TMUX_PANE" @claude "$icon" \; set -w -t "$TMUX_PANE" @claude_state "$state"
fi 2>/dev/null
exit 0
