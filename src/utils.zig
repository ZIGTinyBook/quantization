const std = @import("std");

//return range [0, 1]
pub fn normalize_matrix(comptime T: type, comptime rows: usize, comptime cols: usize, matrix: *[rows][cols]T) [rows][cols]T {
    const stdout = std.io.getStdOut().writer();
    stdout.print("\n normalizing ... ", .{}) catch {};
    // Ensure matrix is not empty
    if (matrix.len == 0 or matrix[0].len == 0) {
        return matrix;
    }

    // Find the minimum and maximum values in the matrix
    var minValue = matrix[0][0];
    var maxValue = matrix[0][0];

    for (matrix) |*row| {
        for (row) |*value| {
            if (value.* < minValue) minValue = value.*;
            if (value.* > maxValue) maxValue = value.*;
        }
    }

    // Calculate the range of the matrix values
    const range = maxValue - minValue;
    stdout.print("\n max={} , min={} , range={}... ", .{ maxValue, minValue, range }) catch {};

    // declare normalized matrix
    var normalizedMatrix: [rows][cols]T = undefined;

    // Handle case where range is zero (to avoid division by zero)
    if (range == 0) {
        return normalizedMatrix;
    }

    for (matrix, 0..) |*row, i| {
        for (row, 0..) |*value, j| {
            // Normalize the value to the range [0, 1]
            normalizedMatrix[i][j] = (value.* - minValue) / range;
            stdout.print("\n[{}][{}] from {} to {} ", .{ i, j, value.*, normalizedMatrix[i][j] }) catch {}; // remember to activate stdout
        }
    }

    return normalizedMatrix;
}

//return range: [0, 1]
pub fn normalize_vector(comptime T: anytype, vec: []T) []T {
    // Find the minimum and maximum values in the vector
    var minValue = vec[0];
    var maxValue = vec[0];

    for (vec) |value| {
        if (value < minValue) minValue = value;
        if (value > maxValue) maxValue = value;
    }

    // Calculate the range of the vector values
    const range = maxValue - minValue;

    // Create a new vector to hold the normalized values
    var normalizedVector = std.heap.c_allocator.alloc([]T, vec.len) catch unreachable;

    for (vec, 0..) |value, i| {
        // Normalize the value to the range [0, 1]
        normalizedVector[i] = (value - minValue) / range;
    }

    return normalizedVector;
}

//return range: [-1, 1]
pub fn normalize_bias(comptime T: anytype, vec: []T) []T {
    // Find the minimum and maximum values in the matrix
    var maxValue = vec[0];

    for (vec) |value| {
        if (value > maxValue) maxValue = value;
    }

    // Create a new vector to hold the normalized values
    var normalizedBias = std.heap.c_allocator.alloc([]T, vec.len) catch unreachable;

    for (vec, 0..) |value, i| {
        // Normalize the value to the range [0, 1]
        normalizedBias[i] = value / maxValue;
    }

    return normalizedBias;
}

pub fn print_matrix(comptime T: anytype, comptime rows: usize, comptime cols: usize, matrix: *[rows][cols]T, comptime caption: []const u8) void {
    const stdout = std.io.getStdOut().writer();
    stdout.print("{s}\n", .{caption}) catch {};

    for (matrix) |*row| {
        for (row) |*item| {
            // Print each item with format specifier based on type
            switch (T) {
                f64 => stdout.print("{:.3} ", .{item.*}) catch {},
                i32 => stdout.print("{} ", .{item.*}) catch {},
                u8 => stdout.print(" {} ", .{item.*}) catch {},
                else => @compileError("Unsupported type"),
            }
        }
        stdout.print("\n", .{}) catch {};
    }
}

pub fn print_vector(comptime T: anytype, comptime len: usize, vect: *[len]T, comptime caption: []const u8) void {
    const stdout = std.io.getStdOut().writer();
    stdout.print("{s}\n", .{caption}) catch {};

    for (vect) |*item| {
        // Print each item with format specifier based on type
        switch (T) {
            f64 => stdout.print("{:.3} ", .{item.*}) catch {},
            i32 => stdout.print("{} ", .{item.*}) catch {},
            u8 => stdout.print(" {} ", .{item.*}) catch {},
            else => @compileError("Unsupported type"),
        }
    }
}
