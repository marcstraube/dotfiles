#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ble.sh early init (before everything) — only on 0.4+
# Older versions (e.g. Arch repo 0.3.4) break starship's hook integration:
# starship init's elif-branch registers via precmd_functions, which ble.sh < 0.4
# does not honor — result: starship_precmd never runs, PS1 stays bash-default.
if [[ -f /usr/share/blesh/ble.sh ]]; then
    _ble_ver=$(awk -F'[=.+]' '/^BLE_VERSION=/{printf "%d", $2*10000+$3*100+$4; exit}' /usr/share/blesh/ble.sh)
    if ((_ble_ver >= 400)); then
        source /usr/share/blesh/ble.sh --noattach
    fi
    unset _ble_ver
fi

# Hook bridge for atuin + starship — they register via precmd_functions arrays
# which need bash-preexec (or ble.sh 0.4+ via its bash-preexec contrib).
# Load bash-preexec as fallback when ble.sh is absent/too old.
if [[ ! ${BLE_VERSION-} && -f /usr/share/bash-preexec/bash-preexec.sh ]]; then
    source /usr/share/bash-preexec/bash-preexec.sh
fi

# Load files from ~/.bashrc.d
if [ -d ${HOME}/.bashrc.d ]; then
    for file in ${HOME}/.bashrc.d/[0-9]*; do
        # shellcheck source=/dev/null  # intentional dynamic load of .bashrc.d/*
        [ -f "$file" ] && source "$file"
    done
fi


complete -C "/usr/bin/symfony self:autocomplete" symfony

# ble.sh late attach (after everything)
if [[ ${BLE_VERSION-} ]]; then
    # blehook/eval-after-load needs 0.4+ — skip on older versions
    # ble.sh encoding: major*10000 + minor*100 + patch (0.4.0 = 400)
    if ((${_ble_version:-0} >= 400)); then
        # Vi keymap loads lazily — defer cursor/mode settings via load hook
        blehook/eval-after-load keymap_vi '
            ble-bind -m vi_nmap --cursor 2
            ble-bind -m vi_imap --cursor 6
            bleopt keymap_vi_mode_show=
        '
    fi
    ble-attach
fi
