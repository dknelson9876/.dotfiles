# Gigabyte B450M DS3H BIOS Sleep Issue Workaround

This is a service that is meant to be run at startup to disable the PTXH wakeup signal. A bug present in the BIOS on my motherboard makes my PC immediately wake from sleep on most linux distros, and experiments have found this signal to be the issue.

To enable the service, copy the .service file in this folder to `/etc/systemd/system/biosWakeupWorkaround.service` and enable in systemctl:
```bash
sudo cp biosWakeupWorkaround.service /etc/systemd/system/biosWakeupWorkaround.service
sudo systemctl daemon-reload && sudo systemsctl enable biosWakeupWorkaround.service
```
