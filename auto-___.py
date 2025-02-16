import os
import signal
import subprocess
import sys

# check if the user is root
if os.geteuid() != 0:
    print("This script must be run as root!")
    sys.exit(1)
# remove if you don't need root

user = {
    "command1": {
        "command": "ls",  # command to execute
        "option": "-A",   # option to pass to the command
        "input": "/",     # input to pass to the option
    },
    "command2": {
        "command": "ls",  # change these with your own values
        "option": "-A",   # change these with your own values
        "input": "~",     # change these with your own values
    },
    "command3": {
        "command": "cd",  # change these with your own values
        "input": "/",     # change these with your own values
    },
    "command4": {
        "command": "cd",  # change these with your own values
        "input": "~",     # change these with your own values
    },
}

def signal_handler(sig, frame):
    print("\nShutting down...")
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)
signal.signal(signal.SIGTERM, signal_handler)

while True:
    print("Commands:", user)
    input_choice = input("Choose command1, command2, command3, command4: ")  # change c1-c4 to the amount and names of commands you have

    if input_choice in user:
        self = user[input_choice]
        args = []
        if self["option"]:
            args.append(self["option"])
        if self["input"]:
            args.append(self["input"])
        try:
            result = subprocess.run([self["command"]] + args, check=True)
            print(result.stdout)
        except subprocess.CalledProcessError as e:
            print(f"Error executing command: {e}")
    else:
        print("Invalid choice, please try again.")
