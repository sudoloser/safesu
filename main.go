package main

import (
	"fmt"
	"os"
	"os/exec"
)

func main() {
	args := os.Args[1:]
	hasBypass := false
	var filteredArgs []string

	for _, arg := range args {
		if arg == "-y" {
			hasBypass = true
		} else {
			filteredArgs = append(filteredArgs, arg)
		}
	}

	if hasBypass {
		// 1. Dynamically find where 'su' is located
		realSuPath, err := exec.LookPath("su")
		if err != nil {
			fmt.Println("Error: Could not find 'su' on this system.")
			os.Exit(1)
		}

		// 2. Execute it
		cmd := exec.Command(realSuPath, filteredArgs...)
		
		cmd.Stdin = os.Stdin
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr

		err = cmd.Run()
		if err != nil {
			// This catches if su fails (like wrong password)
			os.Exit(1) 
		}
	} else {
		fmt.Println("\033[31mPrevented superuser access in case of malware.\033[0m")
		fmt.Println("Use 'su -y' to use su.")
	}
}

