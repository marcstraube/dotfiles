#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ble.sh early init (before everything)
[[ -f /usr/share/blesh/ble.sh ]] && source /usr/share/blesh/ble.sh --noattach

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
    # Vi keymap loads lazily — defer cursor/mode settings via load hook
    blehook/eval-after-load keymap_vi '
        ble-bind -m vi_nmap --cursor 2
        ble-bind -m vi_imap --cursor 6
        bleopt keymap_vi_mode_show=
    '
    ble-attach
fi
