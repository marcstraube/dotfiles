# ============================================================================
# ble.sh Configuration (0.4+)
# ============================================================================
# Sourced during "source ble.sh --noattach" — vi keymap not loaded yet.
# Vi-specific settings (cursor, mode indicator) go in ~/.bashrc after ble-attach.

# --- Syntax Highlighting (Catppuccin-inspired) ---
ble-face -s syntax_default           'fg=white'
ble-face -s syntax_command           'fg=cyan'
ble-face -s syntax_quoted            'fg=green'
ble-face -s syntax_escape            'fg=magenta'
ble-face -s syntax_error             'fg=white,bg=red'
ble-face -s syntax_varname           'fg=magenta'
ble-face -s syntax_comment           'fg=242,italic'
ble-face -s syntax_glob              'fg=magenta,bold'
ble-face -s command_builtin          'fg=yellow'
ble-face -s command_alias            'fg=cyan'
ble-face -s command_function         'fg=cyan,bold'
ble-face -s command_keyword          'fg=blue,bold'
ble-face -s command_file             'fg=green'
ble-face -s command_directory        'fg=cyan,underline'
ble-face -s filename_directory       'fg=cyan,underline'
ble-face -s filename_executable      'fg=green,bold'
ble-face -s filename_link            'fg=magenta'

# --- Autosuggestions ---
ble-face -s auto_complete            'fg=242'
bleopt complete_auto_delay=100

# --- Completion ---
bleopt complete_menu_filter=1
bleopt complete_ambiguous=1

# --- Highlighting ---
bleopt highlight_syntax=1
bleopt highlight_filename=1

# --- Misc ---
bleopt prompt_eol_mark=
bleopt exec_errexit_mark=

# Transient prompt — collapse previous prompts after command execution
bleopt prompt_ps1_transient=trim
bleopt prompt_ps1_final='$(starship module time)$(starship module character)'
