#!/usr/bin/env bash
#
# Rosé Pine - tmux theme
#
# Almost done, any bug found file a PR to rose-pine/tmux
#
# Inspired by dracula/tmux, catppucin/tmux & challenger-deep-theme/tmux
# Inspired by themepack/tmux
#
#
export TMUX_ROSEPINE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

get_tmux_option() {
    local option value default
    option="$1"
    default="$2"
    value="$(tmux show-option -gqv "$option")"

    if [ -n "$value" ]; then
        echo "$value"
    else
        echo "$default"
    fi
}

set() {
    local option=$1
    local value=$2
    tmux_commands+=(set-option -gq "$option" "$value" ";")
}

setw() {
    local option=$1
    local value=$2
    tmux_commands+=(set-window-option -gq "$option" "$value" ";")
}

unset_option() {
    local option=$1
    local value=$2
    tmux_commands+=(set-option -gu "$option" ";")
}

main() {
    local theme
    theme="$(get_tmux_option "@rose_pine_variant" "")"

    # INFO: Not removing the thm_hl_low and thm_hl_med colors for possible features
    # INFO: If some variables appear unused, they are being used either externally
    # or in the plugin's features
    if [[ $theme == main ]]; then

        thm_base="#191724"
        thm_surface="#1f1d2e"
        thm_overlay="#26233a"
        thm_muted="#6e6a86"
        thm_subtle="#908caa"
        thm_text="#e0def4"
        thm_love="#eb6f92"
        thm_gold="#f6c177"
        thm_rose="#ebbcba"
        thm_pine="#3e8fb0"
        thm_foam="#9ccfd8"
        thm_iris="#c4a7e7"
        thm_hl_low="#21202e"
        thm_hl_med="#403d52"
        thm_hl_high="#524f67"

    elif [[ $theme == dawn ]]; then

        thm_base="#faf4ed"
        thm_surface="#fffaf3"
        thm_overlay="#f2e9e1"
        thm_muted="#9893a5"
        thm_subtle="#797593"
        thm_text="#575279"
        thm_love="#b4367a"
        thm_gold="#ea9d34"
        thm_rose="#d7827e"
        thm_pine="#286983"
        thm_foam="#56949f"
        thm_iris="#907aa9"
        thm_hl_low="#f4ede8"
        thm_hl_med="#dfdad9"
        thm_hl_high="#cecacd"

    elif [[ $theme == moon ]]; then

        thm_base="#232136"
        thm_surface="#2a273f"
        thm_overlay="#393552"
        thm_muted="#6e6a86"
        thm_subtle="#908caa"
        thm_text="#e0def4"
        thm_love="#eb6f92"
        thm_gold="#f6c177"
        thm_rose="#ea9a97"
        thm_pine="#3e8fb0"
        thm_foam="#9ccfd8"
        thm_iris="#c4a7e7"
        thm_hl_low="#2a283e"
        thm_hl_med="#44415a"
        thm_hl_high="#56526e"

    fi

    # Aggregating all commands into a single array
    local tmux_commands=()

    # Status bar
    set "status" "on"
    set status-style "fg=$thm_pine,bg=$thm_base"
    set status-left-length "200"
    set status-right-length "200"

    # Theoretically messages
    set message-style "fg=$thm_subtle,bg=$thm_base"
    set message-command-style "fg=$thm_base,bg=$thm_gold"

    # Pane styling
    set pane-border-style "fg=$thm_hl_high"
    set pane-active-border-style "fg=$thm_gold"
    set display-panes-active-colour "${thm_text}"
    set display-panes-colour "${thm_gold}"

    # Windows
    setw window-status-style "fg=${thm_subtle},bg=${thm_base}"
    setw window-status-current-style "fg=${thm_gold},bg=${thm_base},reverse"
    setw window-status-last-style "fg=${thm_foam},bg=${thm_base}"
    setw window-status-separator ""
    setw window-status-activity-style "blink,underscore"
    setw window-status-bell-style "blink,underscore"

    # Statusline base command configuration: No need to touch anything here
    # Placement is handled below

    local cpu
    cpu="$(get_tmux_option "@rose_pine_cpu" "")"
    readonly cpu

    local ram
    ram="$(get_tmux_option "@rose_pine_ram" "")"
    readonly ram

    local network
    network="$(get_tmux_option "@rose_pine_network" "")"
    readonly network

    # Date and time command: follows the date UNIX command structure
    local date_time
    date_time="$(get_tmux_option "@rose_pine_date_time" "")"
    readonly date_time

    # Settings that allow user to choose their own icons and status bar behaviour
    # START
    local zoom_icon
    zoom_icon="$(get_tmux_option "@rose_pine_zoom_icon" "")"

    local current_session_icon
    current_session_icon="$(get_tmux_option "@rose_pine_session_icon" "")"
    readonly current_session_icon

    local resources_icon
    resources_icon="$(get_tmux_option "@rose_pine_resources_icon" "󰟀")"
    readonly resources_icon

    local network_icon
    network_icon="$(get_tmux_option "@rose_pine_network_icon" "󰒍")"
    readonly network_icon

    local date_time_icon
    date_time_icon="$(get_tmux_option "@rose_pine_date_time_icon" "󰃰")"
    readonly date_time_icon

    local right_separator
    right_separator="$(get_tmux_option "@rose_pine_right_separator" " ")"

    local left_separator
    left_separator="$(get_tmux_option "@rose_pine_left_separator" ":")"

    # END

    local spacer
    spacer=" "
    # I know, stupid, right? For some reason, spaces aren't consistent

    # These variables are the defaults so that the setw and set calls are easier to parse

    local show_window_in_window_status
    show_window_in_window_status=" #I$left_separator#W#{?window_zoomed_flag,$zoom_icon,} "

    local show_session
    readonly show_session=" #[fg=#{?client_prefix,$thm_foam,$thm_text}]$current_session_icon #[fg=$thm_text]#S "

    local show_resources
    readonly show_resources="#[fg=$thm_iris]$cpu #[fg=$thm_iris]$ram#[fg=$thm_subtle]$right_separator#[fg=$thm_subtle]$resources_icon"

    local show_network
    readonly show_network="$spacer#[fg=$thm_pine]$network#[fg=$thm_subtle]$right_separator#[fg=$thm_subtle]$network_icon"

    local show_date_time
    readonly show_date_time="$spacer#[fg=$thm_rose]$date_time#[fg=$thm_subtle] " # $right_separator#[fg=$thm_subtle]$date_time_icon$spacer"

    # Windows format
    setw window-status-format "$show_window_in_window_status"
    setw window-status-current-format "$show_window_in_window_status"

    # Left status: shows session
    local left_column

    left_column=$show_session

    # Right status and organization
    local right_column

    right_column=$spacer$right_column

    if [[ "$cpu" != "" ]] && [[ "$ram" != "" ]]; then
        right_column=$right_column$show_resources
    fi

    if [[ "$network" != "" ]]; then
        right_column=$right_column$show_network
    fi

    if [[ "$date_time" != "" ]]; then
        right_column=$right_column$show_date_time
    fi

    # We set the sections
    set status-left "$left_column"
    set status-right "$right_column"

    # tmux integrated modes

    setw clock-mode-colour "${thm_love}"
    setw mode-style "fg=${thm_gold}"

    # Call everything to action

    tmux "${tmux_commands[@]}"

}

main "$@"
