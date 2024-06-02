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

# main()
if should_lock; then
# Take a screenshot
import -window root /tmp/screen_locked.png

# Pixellate it 10x
mogrify -scale 10% -scale 1000% /tmp/screen_locked.png

# Lock screen with new image
i3lock -i /tmp/screen_locked.png

# Turn off the screen after a delay
sleep 60; pgrep i3lock && xset dpms force off

fi
