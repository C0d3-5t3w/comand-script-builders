const std = @import("std");

const User = struct {
    command: []const u8, // command to execute
    option: []const u8, // option to pass to the command
    input: []const u8, // input to pass to the command
};

const users = [_]User{
    User{ .command = "ls", .option = "-A", .input = "/" }, // change these with your own values
    User{ .command = "ls", .option = "-A", .input = "~" }, // change these with your own values
    User{ .command = "cd", .input = "/" }, // change these with your own values
    User{ .command = "cd", .input = "~" }, // change these with your own values
};

fn checkRoot() void {
    // check if the user is root
    if (std.os.geteuid() != 0) {
        std.debug.print("This program must be run as root!\n", .{});
        std.os.exit(1);
    }
    // remove if you don't need root
}

fn signalHandler(_: i32) void {
    std.debug.print("\nShutting down...\n", .{});
    std.os.exit(0);
}

pub fn main() void {
    checkRoot();

    const signals = [_]std.os.Signals{
        std.os.Signals.sigint,
        std.os.Signals.sigterm,
    };
    for (signals) |sig| {
        std.os.signal(sig, signalHandler);
    }

    var stdin = std.io.getStdIn().reader();

    while (true) {
        std.debug.print("Commands: {s}\n", .{users});
        std.debug.print("Choose c1, c2, c3, c4: ", .{}); // change these with your own command names or descriptions

        var input: [3]u8 = undefined;
        stdin.read(input[0..]) catch continue;

        const choice = switch (input[1]) {
            '1' => 0,
            '2' => 1,
            '3' => 2,
            '4' => 3,
            else => {
                std.debug.print("Invalid choice, please try again.\n", .{});
                continue;
            },
        };

        const user = users[choice];
        var args = std.ArrayList([]const u8).init(std.heap.page_allocator);
        defer args.deinit();

        if (user.option.len > 0) {
            args.append(user.option) catch continue;
        }
        if (user.input.len > 0) {
            args.append(user.input) catch continue;
        }

        const result = std.os.execvp(user.command, args.toOwnedSlice()) catch |err| {
            std.debug.print("Error executing command: {s}\n", .{err});
            continue;
        };
        std.debug.print("{s}\n", .{result});
    }
}
