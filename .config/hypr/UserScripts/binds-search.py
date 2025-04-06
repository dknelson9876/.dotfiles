#!/usr/bin/env python3

import subprocess
import re

def parse_modmask(mod):
    """Parses a numerical modmask into human-readable keys."""
    modstr = ""
    if not re.match(r"^[0-9]+$", str(mod)):
        return ""
    mod = int(mod)
    if mod & 1:
        # modstr += "󰘶 + "
        modstr += "Sh+"
    if mod & 4:
        # modstr += "⌃ + "
        modstr += "Ctrl+"
    if mod & 8:
        # modstr += "⎇ + "
        modstr += "Alt+"
    if mod & 64:
        # modstr += " + "
        modstr += "Su+"
    return modstr

def get_hyprctl_binds():
    """Gets the list of binds from hyprctl."""
    try:
        result = subprocess.run(["hyprctl", "binds"], capture_output=True, text=True, check=True)
        return result.stdout
    except FileNotFoundError:
        print("Error: hyprctl not found. Please ensure it is installed and in your PATH.")
        return None
    except subprocess.CalledProcessError as e:
        print(f"Error running hyprctl: {e}")
        return None

def main():
    binds_output = get_hyprctl_binds()
    if binds_output is None:
        return

    parsed_binds_list = []
    modmask = ""
    key = ""
    description = ""
    dispatcher = ""
    arg = ""

    for line in binds_output.splitlines():
        line = line.strip()
        if line.startswith("modmask: "):
            modmask = line[len("modmask: "):]
        elif line.startswith("key: "):
            str = line[len("key: "):]
            if str.startswith("xf86"):
                if str == "xf86audioraisevolume":
                    str = " "
                elif str == "xf86audiolowervolume":
                    str = " "
                elif str == "xf86AudioMicMute":
                    str = "󰍭 "
                elif str == "xf86audiomute":
                    str = " "
                elif str == "xf86Sleep":
                    str = "󰒲 "
                elif str == "xf86Rfkill":
                    str = "󰀞 "
                elif str == "xf86AudioPlayPause":
                    str = "󰐎 "
                elif str == "xf86AudioPause":
                    str = "󰏤 "
                elif str == "xf86AudioPlay":
                    str = "󰐊 "
                elif str == "xf86AudioNext":
                    str = "󰒭 "
                elif str == "xf86AudioPrev":
                    str = "󰒮 "
                elif str == "xf86audiostop":
                    str = "󰓛 "
                
            key = str
        elif line.startswith("description: "):
            description = line[len("description: "):]
        elif line.startswith("dispatcher: "):
            dispatcher = line[len("dispatcher: "):]
        elif line.startswith("arg: "):
            arg = line[len("arg: "):]
        elif line.startswith("bind"):
            if key:
                if not description:
                    description = "[??]"
                modstring = parse_modmask(modmask)
                parsed_binds_list.append(f"{description} (<small>{modstring}{key}</small>) -> {dispatcher} {arg}")
            modmask = ""
            key = ""
            description = ""
            dispatcher = ""
            arg = ""

    # Handle the last bind if it exists
    if key:
        if not description:
            description = "[No description] (?? Mystery Bind ??)"
        modstring = parse_modmask(modmask)
        parsed_binds_list.append(f"{modstring}{key} ({description}) -> {dispatcher} {arg}")

    if not parsed_binds_list:
        print("No keybindings found.")
        return

    try:
        print("Available commands:")
        for line in parsed_binds_list:
            print(line)
        rofi_process = subprocess.run(
            ["rofi", "-dmenu", "-i", "-p", "Select a keybind:", "-markup-rows"],
            input="\n".join(parsed_binds_list),
            capture_output=True,
            text=True,
            check=True
        )
        selected = rofi_process.stdout.strip()
    except FileNotFoundError:
        print("Error: rofi not found. Please ensure it is installed and in your PATH.")
        return
    except subprocess.CalledProcessError:
        # User likely cancelled rofi
        return

    if selected:
        command_match = re.search(r"->\ (.*)", selected)
        if command_match:
            command_to_execute = command_match.group(1)
            try:
                subprocess.run(command_to_execute, shell=True, check=True)
            except subprocess.CalledProcessError as e:
                print(f"Error executing command '{command_to_execute}': {e}")
            except FileNotFoundError as e:
                print(f"Error: Command not found: {e}")

if __name__ == "__main__":
    main()
