module adder32 (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire        sub,       // 0: Add, 1: Subtract
    output wire [31:0] result,
    output wire        carry_out,
    output wire        overflow
);
    wire [31:0] b_operand;
    wire [32:0] sum_ext;

    // 2's complement inversion for subtraction
    assign b_operand = sub ? ~b : b;
    assign sum_ext   = {1'b0, a} + {1'b0, b_operand} + {32'd0, sub};

    assign result    = sum_ext[31:0];
    assign carry_out = sum_ext[32];

    // Overflow detection:
    // For ADD: (a[31] == b[31]) && (result[31] != a[31])
    // For SUB: (a[31] != b[31]) && (result[31] != a[31])
    assign overflow  = (a[31] ^ b_operand[31] ^ 1'b1) & (a[31] ^ result[31]);

endmodule
