const std = @import("std");
const quant = @import("quantization.zig");
const utils = @import("utils.zig");

pub fn main() !void {

    // declaration
    const rows: usize = 3;
    const cols: usize = 5;
    var matrix: [rows][cols]f64 = undefined;
    var matrixNormalized: [rows][cols]f64 = undefined;
    var matrixQuantized: [rows][cols]u8 = undefined;

    var bias: [rows]f64 = undefined; //don't need to be normalized
    var bias_i32: [rows]i32 = undefined;

    //initialization
    matrix = [rows][cols]f64{
        [_]f64{ 1, 2, 3, 4, 5 },
        [_]f64{ -6, -7, -8, -9, -10 },
        [_]f64{ 11, 12, 13, 14, 15 },
    };

    bias = [rows]f64{ 0.3, 0.4, 0.5 };

    //transforations on matrix of weights
    utils.print_matrix(f64, rows, cols, &matrix, "\n -> Original matrix: ");

    matrixNormalized = utils.normalize_matrix(f64, rows, cols, &matrix);
    utils.print_matrix(f64, rows, cols, &matrixNormalized, "\n -> Normalized matrix: ");

    matrixQuantized = quant.quant_sym_u8_matrix(f64, rows, cols, &matrixNormalized);
    utils.print_matrix(u8, rows, cols, &matrixQuantized, "\n -> Quantized matrix: ");

    //transforations on biases vector
    utils.print_vector(f64, rows, &bias, "\n -> Original bias ");

    bias_i32 = quant.quant_int32_bias(f64, rows, &bias);
    utils.print_vector(i32, rows, &bias_i32, "\n -> bias transformation to i32");
}
