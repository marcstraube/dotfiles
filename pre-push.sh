#!/usr/bin/env bash
# Pre-push lint for the dotfiles bare repo.
# Runs `bash -n` on tracked shell scripts and shellcheck on .bashrc.d/*.
# Symlinked from $GIT_DIR/hooks/pre-push by install.sh.
set -euo pipefail

GIT_DIR_ARG="$(git rev-parse --absolute-git-dir)"
WORK_TREE="${GIT_WORK_TREE:-$HOME}"

_git() {
    /usr/bin/git -C "$WORK_TREE" --git-dir="$GIT_DIR_ARG" --work-tree="$WORK_TREE" "$@"
}

fail=0

mapfile -t shell_files < <(
    _git ls-tree -r --name-only HEAD \
        | grep -E '^(\.bashrc(\.d/[^/]+)?|install\.sh|pre-push\.sh)$' \
        | grep -vE '\.md$|^\.bashrc\.d/README'
)

# Meta files (install.sh, pre-push.sh) live in $GIT_DIR, not $WORK_TREE.
_locate() {
    local rel="$1"
    if [[ -f "$WORK_TREE/$rel" ]]; then
        echo "$WORK_TREE/$rel"
    elif [[ -f "$GIT_DIR_ARG/$rel" ]]; then
        echo "$GIT_DIR_ARG/$rel"
    fi
}

for f in "${shell_files[@]}"; do
    abs=$(_locate "$f")
    [[ -n "$abs" ]] || continue
    if ! bash -n "$abs" 2>&1; then
        echo "  bash -n failed: $f" >&2
        fail=1
    fi
done

if command -v shellcheck &>/dev/null; then
    for f in "${shell_files[@]}"; do
        abs=$(_locate "$f")
        [[ -n "$abs" ]] || continue
        if ! shellcheck -s bash -S error "$abs"; then
            echo "  shellcheck failed: $f" >&2
            fail=1
        fi
    done
else
    echo "  (shellcheck not installed, skipping)"
fi

if [[ $fail -ne 0 ]]; then
    echo "Pre-push lint failed. Push aborted." >&2
    exit 1
fi

exit 0
