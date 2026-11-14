#!/usr/bin/env bash
# Claude Code status line — shows session context/token usage bottom-right.
# Reads the session JSON Claude Code pipes in on stdin; see
# https://code.claude.com/docs/en/statusline.md
input=$(cat)

model=$(jq -r '.model.display_name // "Claude"' <<<"$input")
used_in=$(jq -r '.context_window.total_input_tokens // 0' <<<"$input")
window=$(jq -r '.context_window.context_window_size // 200000' <<<"$input")
pct=$(jq -r '.context_window.used_percentage // empty' <<<"$input")
cost=$(jq -r '.cost.total_cost_usd // 0' <<<"$input")
# Weekly (7-day) usage limits; only present for Claude.ai subscribers.
week=$(jq -r '.rate_limits.seven_day.used_percentage // empty' <<<"$input")

# The per-model (Fable) weekly limit is not in the stdin JSON, only in the
# usage endpoint behind /usage. Cache it and refresh in the background at most
# every 5 minutes so redraws never block on the network.
usage_cache=${XDG_CACHE_HOME:-$HOME/.cache}/claude-statusline/usage.json
usage_ttl=300
refresh_usage() {
    local dir=${usage_cache%/*} tok tmp
    mkdir -p "$dir"
    # noclobber lock: only one refresh at a time; stale locks expire with the TTL.
    ( set -C; : >"$dir/lock" ) 2>/dev/null || return
    tok=$(jq -r '.claudeAiOauth.accessToken // empty' ~/.claude/.credentials.json 2>/dev/null)
    tmp=$(mktemp "$dir/usage.XXXXXX")
    if [[ -n $tok ]] && curl -sf -m 10 https://api.anthropic.com/api/oauth/usage \
        -H "Authorization: Bearer $tok" -H "anthropic-beta: oauth-2025-04-20" >"$tmp" &&
        jq -e '.limits' "$tmp" >/dev/null 2>&1; then
        mv "$tmp" "$usage_cache"
    else
        rm -f "$tmp"
        touch "$usage_cache"   # back off for one TTL on failure, keep old data
    fi
    rm -f "$dir/lock"
}
if [[ ! -f $usage_cache ]] || (($(date +%s) - $(stat -c %Y "$usage_cache") > usage_ttl)); then
    # Drop a lock left behind by a killed refresh.
    find "${usage_cache%/*}" -maxdepth 1 -name lock -mmin +1 -delete 2>/dev/null
    refresh_usage </dev/null >/dev/null 2>&1 &
    disown
fi
week_fable=$(jq -r '[.limits[]? | select(.kind == "weekly_scoped"
    and .scope.model.display_name == "Fable") | .percent][0] // empty' \
    "$usage_cache" 2>/dev/null)
# Fall back to the cached total if stdin did not carry it.
[[ -z $week ]] && week=$(jq -r '[.limits[]? | select(.kind == "weekly_all") | .percent][0] // empty' \
    "$usage_cache" 2>/dev/null)

# Fall back to computing the percentage if the field is absent.
if [[ -z $pct && $window -gt 0 ]]; then
    pct=$((used_in * 100 / window))
fi
pct=${pct%%.*}   # integer only

# Humanize token counts (12345 -> 12.3k, 1500000 -> 1.5M).
human() {
    local n=$1
    if ((n >= 1000000)); then
        printf '%d.%dM' $((n / 1000000)) $(((n % 1000000) / 100000))
    elif ((n >= 1000)); then
        printf '%d.%dk' $((n / 1000)) $(((n % 1000) / 100))
    else
        printf '%d' "$n"
    fi
}

# --- Rendering --------------------------------------------------------------
# Plain ANSI colors so the line follows the terminal theme (like starship).
# Nerd Font icons are written as escapes: editors/tools may strip raw PUA chars.
R=$'\e[0m' DIM=$'\e[2m' BOLD=$'\e[1m'
RED=$'\e[31m' GREEN=$'\e[32m' YELLOW=$'\e[33m' BLUE=$'\e[34m' MAGENTA=$'\e[35m' CYAN=$'\e[36m'
I_MODEL=$'\U000F06A9'   # nf-md-robot
I_CTX=$'\U000F035B'     # nf-md-memory
I_COST=$'\U000F01C1'    # nf-md-currency_usd
I_WEEK=$'\U000F00F0'    # nf-md-calendar_clock
I_FABLE=$'\U000F06D3'   # nf-md-feather
SEP=" ${DIM}│${R} "

# Color by fill level: green < 50% <= yellow < 80% <= red.
level() {
    local p=${1%%.*}
    if ((p >= 80)); then printf '%s' "$RED"
    elif ((p >= 50)); then printf '%s' "$YELLOW"
    else printf '%s' "$GREEN"; fi
}
# Mini bar: bar <percent> <width>  ->  ▰▰▰▱▱▱ in the level color.
bar() {
    local p=${1%%.*} w=$2 i out="" n
    ((p > 100)) && p=100
    n=$(((p * w + 50) / 100))
    for ((i = 0; i < w; i++)); do
        if ((i < n)); then out+="▰"; else out+="▱"; fi
    done
    printf '%s%s%s' "$(level "$p")" "${out:0:n}" "${DIM}${out:n}${R}"
}

I_SESSION=$''     # nf-fa-tag
I_BRANCH=$''      # powerline branch
I_WORKTREE=$''    # nf-fa-tree (linked git worktree)
I_WARM=$''        # nf-fa-bolt
I_COLD=$''        # nf-fa-snowflake_o

I_PR=$''          # nf-oct-git_pull_request

# OSC 8 hyperlink: link <url> <text>
link() { printf '\e]8;;%s\e\\%s\e]8;;\e\\' "$1" "$2"; }
# git remote URL -> https web URL (git@host:o/r.git, ssh://, https://).
remote_web_url() {
    local u=$1
    [[ -z $u ]] && return
    u=${u%.git}
    case $u in
        git@*:*) u=${u#git@}; u="https://${u%%:*}/${u#*:}" ;;
        ssh://* | http*://*) u=${u#*://}; u="https://${u#*@}" ;;
        *) return ;;
    esac
    # AUR repos have no web view at the clone URL; link the package page.
    [[ $u == https://aur.archlinux.org/* ]] && u="https://aur.archlinux.org/packages/${u##*/}"
    printf '%s' "$u"
}

session=$(jq -r '.session_name // empty' <<<"$input")
effort=$(jq -r '.effort.level // empty' <<<"$input")
dir=$(jq -r '.workspace.current_dir // .cwd // empty' <<<"$input")
added=$(jq -r '.cost.total_lines_added // 0' <<<"$input")
removed=$(jq -r '.cost.total_lines_removed // 0' <<<"$input")
# Not `// empty`: jq treats false as missing there.
cache_warm=$(jq -r '.prompt_cache.warm | if . == null then empty else tostring end' <<<"$input")
cache_exp=$(jq -r '.prompt_cache.expires_at // empty' <<<"$input")
week_reset=$(jq -r '.rate_limits.seven_day.resets_at // empty' <<<"$input")
if [[ -z $week_reset ]]; then
    week_reset=$(jq -r '[.limits[]? | select(.kind == "weekly_all") | .resets_at][0] // empty' \
        "$usage_cache" 2>/dev/null)
    [[ -n $week_reset ]] && week_reset=$(date -d "$week_reset" +%s 2>/dev/null)
fi

# --- Desktop notification when a weekly limit crosses 80 / 95 / 100 % ---------
# Remembers the highest threshold already announced per limit and reset date,
# so each threshold fires once per week no matter how many sessions redraw.
notify_limit() {   # notify_limit <key> <label> <percent> <reset-epoch>
    local key=$1 label=$2 p=${3%%.*} reset=$4 t hit=0 state last
    [[ -z $p ]] && return
    for t in 80 95 100; do ((p >= t)) && hit=$t; done
    ((hit == 0)) && return
    state=${usage_cache%/*}/notified
    last=$(awk -v k="$key:$reset" '$1 == k {print $2}' "$state" 2>/dev/null)
    ((hit <= ${last:-0})) && return
    { grep -v "^$key:" "$state" 2>/dev/null; echo "$key:$reset $hit"; } >"$state.tmp" &&
        mv "$state.tmp" "$state"
    local urgency=normal when=""
    ((hit >= 95)) && urgency=critical
    [[ -n $reset ]] && when=" – Reset $(date -d "@$reset" '+%a %H:%M')"
    command -v notify-send >/dev/null &&
        notify-send -a "Claude Code" -u "$urgency" -i dialog-warning \
            "Claude: $label bei ${p}%" "Wochenlimit ${hit}% erreicht${when}" &
}
if [[ -n $week ]]; then
    mkdir -p "${usage_cache%/*}"
    notify_limit week "Woche gesamt" "$week" "$week_reset"
    if [[ -n $week_fable ]]; then
        fable_reset=$(jq -r '[.limits[]? | select(.kind == "weekly_scoped"
            and .scope.model.display_name == "Fable") | .resets_at][0] // empty' \
            "$usage_cache" 2>/dev/null)
        [[ -n $fable_reset ]] && fable_reset=$(date -d "$fable_reset" +%s 2>/dev/null)
        notify_limit fable "Fable" "$week_fable" "$fable_reset"
    fi
fi

# --- Line 1: what is running -------------------------------------------------
l1="${MAGENTA}${I_MODEL} ${BOLD}${model}${R}"
if [[ -n $effort ]]; then
    case $effort in
        low) e="○" ;; medium) e="◑" ;; high) e="◕" ;; *) e="●" ;;
    esac
    l1+=" ${DIM}${e} ${effort}${R}"
fi
if [[ -n $session ]]; then
    ((${#session} > 30)) && session="${session:0:29}…"
    l1+="${SEP}${BLUE}${I_SESSION}${R} ${session}"
fi
# Git: branch, dirty marker, and a tree icon inside a linked worktree.
# --no-optional-locks keeps us from fighting with agents running git there.
if [[ -n $dir ]] && git_info=$(git -C "$dir" --no-optional-locks rev-parse \
    --git-dir --git-common-dir 2>/dev/null); then
    { read -r gdir; read -r gcommon; } <<<"$git_info"
    # --show-current also works on an unborn branch; empty when detached.
    branch=$(git -C "$dir" branch --show-current 2>/dev/null)
    [[ -z $branch ]] && branch=$(git -C "$dir" rev-parse --short HEAD 2>/dev/null)
    # Clickable branch (OSC 8): links to the branch on the remote's web UI.
    web=$(remote_web_url "$(git -C "$dir" remote get-url origin 2>/dev/null)")
    if [[ -n $web && $web == https://github.com/* ]]; then
        g="$(link "$web/tree/$branch" "${GREEN}${I_BRANCH} ${branch}${R}")"
    elif [[ -n $web ]]; then
        g="$(link "$web" "${GREEN}${I_BRANCH} ${branch}${R}")"
    else
        g="${GREEN}${I_BRANCH} ${branch}${R}"
    fi
    [[ -n $(git -C "$dir" --no-optional-locks status --porcelain -uno 2>/dev/null | head -1) ]] &&
        g+="${YELLOW}*${R}"
    # Open PR for this branch (GitHub only), cached and refreshed in background.
    if [[ $web == https://github.com/* && -n $branch ]] && command -v gh >/dev/null; then
        pr_cache="${usage_cache%/*}/pr/$(printf '%s' "$web#$branch" | md5sum | cut -c1-16)"
        if [[ ! -f $pr_cache ]] || (($(date +%s) - $(stat -c %Y "$pr_cache") > usage_ttl)); then
            mkdir -p "${pr_cache%/*}"; touch "$pr_cache"
            ( cd "$dir" && gh pr view "$branch" --json number,url,state \
                --jq 'select(.state == "OPEN") | "\(.number) \(.url)"' >"$pr_cache.tmp" 2>/dev/null
              mv "$pr_cache.tmp" "$pr_cache" ) </dev/null >/dev/null 2>&1 &
            disown
        fi
        read -r pr_num pr_url <"$pr_cache" 2>/dev/null
        [[ -n $pr_num ]] && g+=" $(link "$pr_url" "${MAGENTA}${I_PR} #${pr_num}${R}")"
    fi
    [[ $gdir != "$gcommon" ]] && g+=" ${CYAN}${I_WORKTREE}${R}"
    l1+="${SEP}${g}"
fi
if ((added + removed > 0)); then
    l1+="${SEP}${GREEN}+${added}${R} ${RED}−${removed}${R}"
fi

# --- Line 2: consumption -----------------------------------------------------
l2="${BLUE}${I_CTX}${R} $(bar "${pct:-0}" 8) $(level "${pct:-0}")${pct:-0}%${R}"
l2+=" ${DIM}$(human "$used_in")/$(human "$window")${R}"
# Show the cache expiry as a clock time: the line only redraws on activity,
# so a countdown would go stale while idle.
if [[ $cache_warm == true && -n $cache_exp ]]; then
    left=$((cache_exp - $(date +%s)))
    if ((left > 0)); then
        ((left < 300)) && c=$YELLOW || c=$GREEN
        l2+="${SEP}${c}${I_WARM}${R} ${DIM}bis${R} $(date -d "@$cache_exp" +%H:%M)"
    else
        l2+="${SEP}${CYAN}${I_COLD} kalt${R}"
    fi
elif [[ $cache_warm == false ]]; then
    l2+="${SEP}${CYAN}${I_COLD} kalt${R}"
fi
l2+="${SEP}${YELLOW}${I_COST}${R}$(LC_ALL=C printf '%.2f' "$cost")"
if [[ -n $week ]]; then
    l2+="${SEP}${CYAN}${I_WEEK}${R} $(bar "$week" 5) $(level "$week")${week%%.*}%${R}"
    if [[ -n $week_fable ]]; then
        l2+=" ${DIM}·${R} ${MAGENTA}${I_FABLE}${R} $(level "$week_fable")${week_fable%%.*}%${R}"
    fi
    [[ -n $week_reset ]] && l2+=" ${DIM}↻ $(date -d "@$week_reset" '+%a %H:%M')${R}"
fi
printf '%s\n%s' "$l1" "$l2"
