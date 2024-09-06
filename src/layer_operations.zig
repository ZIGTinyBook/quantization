const std = @import("std");

const Neuron = struct {
    id: usize,
    out: i32, //is initialized to the biass
    weights: []const u8,
    input: []const u8,
};

pub fn forward_optimized(comptime rows: usize, comptime cols: usize, weights: *[rows][cols]u8, biases: *[rows]i32, inputs: *[cols]u8) [rows]i32 {
    var res: [rows]i32 = undefined;
    //var neurons_thread: [rows]std.Thread = undefined; // Array of threads
    var neurons_out: [rows]Neuron = undefined; // Data for each worker thread
    const stdout = std.io.getStdOut().writer();

    //create and start a thread for each neuron ( there are "rows" neurons)
    for (weights, 0..) |row, i| {
        neurons_out[i] = Neuron{
            .id = i,
            .out = biases.*[i],
            .weights = row[0..],
            .input = inputs,
        };

        // Spawn thread and handle potential errors
        //neurons_thread[i] = std.Thread.spawn(.{}, compute_neuron_out, .{&neurons_out[i]}) catch undefined;

        compute_neuron_out(&neurons_out[i]);
    }

    // Join threads to ensure all of them finish execution
    //for (neurons_thread) |thread| {thread.join();}

    // Display the results
    for (neurons_out, 0..) |neuron, i| {
        res[i] = neuron.out;
    }

    stdout.print("\n \n", .{}) catch {};

    return res;
}

fn compute_neuron_out(data: *Neuron) void {
    const stdout = std.io.getStdOut().writer();
    stdout.print("\n \n", .{}) catch {};

    for (data.*.weights, 0..) |wheight, i| {
        stdout.print("\n id:{} weight:{} input:{} ", .{ data.*.id, wheight, data.*.input[i] }) catch {};
        data.*.out += @as(i32, @as(i32, wheight) * @as(i32, data.*.input[i]));
        stdout.print(" -> out:{}", .{data.*.out}) catch {};
    }
}
