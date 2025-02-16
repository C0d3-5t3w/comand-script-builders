package main

import (
	"fmt"
	"os"
	"os/exec"
	"os/signal"
	"syscall"
)

// check if user is root
func checkRoot() {
	if os.Geteuid() != 0 {
		fmt.Println("This program must be run as root!")
		os.Exit(1)
	}
}

// remove this if you dont need root

type User struct {
	command interface{}
	option  interface{}
	input   interface{}
}

var user = map[string]User{
	"c1": {
		command: "ls", // command to execute
		option:  "-A", // option to pass to the command
		input:   "/",  // input to pass to the command
	},
	"c2": {
		command: "ls", // change these with your own values
		option:  "-A", // change these with your own values
		input:   "~",  // change these with your own values
	},
	"c3": {
		command: "cd", // change these with your own values
		input:   "/",  // change these with your own values
	},
	"c4": {
		command: "cd", // change these with your own values
		input:   "~",  // change these with your own values
	},
}

func main() {
	checkRoot()

	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		<-sigs
		fmt.Println("\nShutting down...")
		os.Exit(0)
	}()

	for {
		var input string
		fmt.Println("Commands:", user)
		fmt.Print("Choose c1, c2, c3, c4: ") // change c1-c4 to the amount and names of comands you have
		fmt.Scanln(&input)

		if self, exists := user[input]; exists {
			args := []string{}
			if self.option.(string) != "" {
				args = append(args, self.option.(string))
			}
			if self.input.(string) != "" {
				args = append(args, self.input.(string))
			}
			cmd := exec.Command(self.command.(string), args...)
			cmd.Stdout = os.Stdout
			cmd.Stderr = os.Stderr
			if err := cmd.Run(); err != nil {
				fmt.Printf("Error executing command: %v\n", err)
			}
		} else {
			fmt.Println("Invalid choice, please try again.")
		}
	}
}
