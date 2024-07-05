# Take a screenshot after a short delay
sleep 1; import -window root /tmp/screen_locked.png

# Pixellate it 10x
mogrify -scale 10% -scale 1000% -blur 0x8 /tmp/screen_locked.png

# Lock screen with new image
i3lock -i /tmp/screen_locked.png

# Turn off the screen after a delay
sleep 60; pgrep i3lock && xset dpms force off

