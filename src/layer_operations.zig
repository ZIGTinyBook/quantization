const std = @import("std");

const Neuron = struct {
    id: usize,
    out: i32,
    weights: *[]u8,
    input: *[]u8,
    bias: i32,
};

pub fn forward_optimized(comptime rows: usize, comptime cols: usize, weights: *[rows][cols]u8, biases: *[rows]i32, inputs: *[rows][cols]u8) [rows]i32 {
    var res: [rows]i32 = undefined;
    var neurons_thread: [rows]std.Thread(Neuron) = undefined; // Array of threads
    var neurons_out: [rows]Neuron = undefined; // Data for each worker thread

    //create and start a thread for each neuron ( there are "rows" neurons)
    for (weights, 0..) |*row, i| {
        neurons_out[i] = Neuron{
            .id = i,
            .out = biases[i].*,
            .weights = row,
            .input = inputs[i],
        };
        neurons_thread = try std.Thread.spawn(compute_neuron_out, &neurons_out[i]);
    }

    // Wait for all threads to complete
    for (neurons_thread) |*thread| {
        _ = thread.wait();
    }

    // Display the results
    for (neurons_out, 0..) |neuron, i| {
        res[i] = neuron.out;
    }
}

fn compute_neuron_out(data: *Neuron) void {
    for (data.weights, 0..) |*wheight, i| {
        data.out += @intCast((wheight.*) * data.input[i].*);
    }
}
