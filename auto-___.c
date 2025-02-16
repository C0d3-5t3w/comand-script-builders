#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>

typedef struct {
    const char *command;
    const char *option;
    const char *input;
} Command;

Command commands[] = {
    { "ls", "-A", "/" },  // change these with your own values
    { "ls", "-A", "~" },  // change these with your own values
    { "cd", "", "/" },    // change these with your own values
    { "cd", "", "~" }     // change these with your own values
};

void checkRoot() {
    if (geteuid() != 0) {
        printf("This program must be run as root!\n");
        exit(1);
    }
    // remove if you don't need root
}

void signalHandler(int sig) {
    (void)sig;
    printf("\nShutting down...\n");
    exit(0);
}

int main() {
    checkRoot();

    signal(SIGINT, signalHandler);
    signal(SIGTERM, signalHandler);

    while (1) {
        printf("Commands:\n");
        for (int i = 0; i < 4; i++) {
            printf("c%d: %s %s %s\n", i + 1, commands[i].command, commands[i].option, commands[i].input);
        }
        printf("Choose c1, c2, c3, c4: "); // change these with your own command names or descriptions

        char input[3];
        if (fgets(input, sizeof(input), stdin) == NULL) {
            continue;
        }

        int choice = -1;
        if (input[1] == '1') choice = 0;
        else if (input[1] == '2') choice = 1;
        else if (input[1] == '3') choice = 2;
        else if (input[1] == '4') choice = 3;
        else {
            printf("Invalid choice, please try again.\n");
            continue;
        }

        Command command = commands[choice];
        char cmd[256];
        snprintf(cmd, sizeof(cmd), "%s %s %s", command.command, command.option, command.input);

        int result = system(cmd);
        if (result != 0) {
            printf("Error executing command: %d\n", result);
        }
    }

    return 0;
}
