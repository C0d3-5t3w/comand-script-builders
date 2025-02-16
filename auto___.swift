import Foundation

// check if user is root
func checkRoot() {
    let uid = getuid()
    if uid != 0 {
        print("This program must be run as root!")
        exit(1)
    }
}

// remove this if you dont need root

struct User {
    var command: String? // comand to execute
    var option: String? // option for the command
    var input: String? // input for the option
}

let user: [String: User] = [
    "c1": User(command: "ls", option: "-A", input: "/"), // change this to your command 
    "c2": User(command: "ls", option: "-A", input: "~"), // change this to your command
    "c3": User(command: "cd", option: nil, input: "/"), // change this to your command
    "c4": User(command: "cd", option: nil, input: "~") // change this to your command
]

func main() {
    checkRoot()

    let sigintSrc = DispatchSource.makeSignalSource(signal: SIGINT, queue: .main)
    let sigtermSrc = DispatchSource.makeSignalSource(signal: SIGTERM, queue: .main)

    sigintSrc.setEventHandler {
        print("\nShutting down...")
        exit(0)
    }
    sigtermSrc.setEventHandler {
        print("\nShutting down...")
        exit(0)
    }

    sigintSrc.resume()
    sigtermSrc.resume()

    while true {
        print("Commands:", user)
        print("Choose c1, c2, c3, c4: ", terminator: "") // change this to your command names
        guard let input = readLine(), let self = user[input] else {
            print("Invalid choice, please try again.")
            continue
        }

        var args: [String] = []
        if let option = self.option {
            args.append(option)
        }
        if let input = self.input {
            args.append(input)
        }

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = [self.command] + args
        process.standardOutput = FileHandle.standardOutput
        process.standardError = FileHandle.standardError

        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            print("Error executing command: \(error)")
        }
    }
}

main()
