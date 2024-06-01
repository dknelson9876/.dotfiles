#!/bin/sh -e

# Take a screenshot
import -window root /tmp/screen_locked.png

# Pixellate it 10x
mogrify -scale 10% -scale 1000% /tmp/screen_locked.png

# Lock screen with new image
i3lock -i /tmp/screen_locked.png

# Turn off the screen after a delay
sleep 60; pgrep i3lock && xset dpms force off

