#!/bin/bash

declare -a LIST_OF_WINDOW_TITLES_THAT_PREVENT_LOCKING=(
	"YouTube"
)

AWK=/usr/bin/awk
GREP=/usr/bin/grep
XPROP=/usr/bin/xprop

# Find active window id
get_active_id() {
	$XPROP -root | $AWK '$1 ~ /_NET_ACTIVE_WINDOW/ { print $5 }'
}

# Determine a window's title txt by it's ID
get_window_title() {
	$XPROP -id $1 | $AWK -F '=' '$1 ~ /_NET_WM_NAME\(UTF8_STRING\)/ { print $2 }'
}

# determine if a window is fullscreen based on it's ID
is_fullscreen() {
	$XPROP -id $1 | $AWK -F '=' '$1 ~ /_NET_WM_STATE\(ATOM\)/ { for (i=2; i<=3; i++) if ($i ~ /FULLSCREEN/) exit 0; exit 1 }'
	return $?
}

should_lock() {
	id=$(get_active_id)
	title=$(get_window_title $id)

	if is_fullscreen $id; then
		for i in "${LIST_OF_WINDOW_TITLES_THAT_PREVENT_LOCKING[@]}"; do
			if [[ $title =~ $i ]]; then
				return 1
			fi
		done
	else
		return 0
	fi
}

playing_audio() {
    if [ $(grep -r RUNNING /proc/asound | wc -l) -eq 0 ]; then
        return 1
    else
        return 0
    fi
}

# main()
if playing_audio; then
    exit 1
else
    exit 0
fi
# if should_lock; then
#     exit 0
# else
#     exit 1
# fi

