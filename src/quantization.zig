const std = @import("std");

//input matrix must be normalized [0, 1] and returns a symmetric unsigned quantized matrix
pub fn quant_sym_u8_matrix(comptime T: anytype, comptime rows: usize, comptime cols: usize, matrix: *[rows][cols]T) [rows][cols]u8 {
    const stdout = std.io.getStdOut().writer();
    stdout.print("\n quantizing ... ", .{}) catch {};
    // Allocate the result matrix
    var u8Matrix: [rows][cols]u8 = undefined;

    for (matrix, 0..) |*row, i| {
        for (row, 0..) |*value, j| {
            // Convert normalized value (in range [0, 1]) to u8 (in range [0, 255])
            //const u8Value: u8 = @intCast((value.*) * 255);
            const u8Value: u8 = @intFromFloat((value.*) * 255);
            u8Matrix[i][j] = u8Value;
            stdout.print("\n[{}][{}] from {} to {} ", .{ i, j, value.*, u8Matrix[i][j] }) catch {}; // remember to activate stdout
        }
    }

    return u8Matrix;
}

//input vector must be normalized [0, 1] and returns a symmetric unsigned quantized vector
pub fn quant_u8_vector(comptime T: anytype, vector: [][]T) [][]u8 {

    // Allocate the result vector
    var u8Vec = std.heap.c_allocator.alloc([]u8, vector.len) catch unreachable;

    for (vector, 0..) |value, i| {
        // Convert normalized value (in range [0, 1]) to u8 (in range [0, 255])
        const u8Value: u8 = @intCast(value * 255);
        u8Vec[i] = u8Value;
    }

    return u8Vec;
}

//input vector must be normalized [-1, 1] and returns a  quantized vector
pub fn quant_int32_bias(comptime T: anytype, comptime len: usize, vector: *[len]T) [len]i32 {

    // Allocate the result vector
    var i32Vec: [len]i32 = undefined;

    for (vector, 0..) |*value, i| {
        // Convert normalized value (in range [0, 1]) to u8 (in range [0, 255])
        const i32Value: i32 = @intFromFloat((value.*) * 255 * 255);
        i32Vec[i] = i32Value;
    }

    return i32Vec;
}

pub fn get_quantization_error(comptime T: anytype, matrix: [][]T, quantMatrix: [][]u8) [][]T {
    var detaMatrix = std.heap.c_allocator.alloc([]i32, matrix.len) catch unreachable;

    for (matrix, 0..) |row, i| {
        var newRow = std.heap.c_allocator.alloc(i32, matrix[0].len) catch unreachable;
        for (row, 0..) |val, j| {
            const quant255: i32 = @intCast(quantMatrix[i][j] * 255);
            newRow[j] = val - quant255;
        }
        detaMatrix[i] = newRow;
    }
}
