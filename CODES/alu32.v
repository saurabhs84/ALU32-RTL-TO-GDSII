module alu32 (
    input  wire        clk,
    input  wire        rst,
    input  wire        en,
    input  wire [3:0]  alu_op,
    input  wire [31:0] a_in,
    input  wire [31:0] b_in,
    output reg  [31:0] alu_out,
    output reg         zero_flag,
    output reg         carry_flag,
    output reg         overflow_flag,
    output reg         negative_flag
);

    // Registered Inputs
    reg [31:0] a_reg, b_reg;
    reg [3:0]  op_reg;

    // Submodule wires
    wire [31:0] arith_res;
    wire        c_out, v_out;
    wire [31:0] logic_res;
    wire [31:0] shift_res;
    wire [31:0] comp_res;

    reg  [31:0] comb_mux_out;

    // 1. Instantiate Arithmetic Unit
    adder32 u_adder (
        .a(a_reg),
        .b(b_reg),
        .sub(op_reg == 4'b0001),
        .result(arith_res),
        .carry_out(c_out),
        .overflow(v_out)
    );

    // 2. Instantiate Logic Unit
    logic_unit32 u_logic (
        .a(a_reg),
        .b(b_reg),
        .op(op_reg[2:0]),
        .out(logic_res)
    );

    // 3. Instantiate Shift Unit
    shift_unit32 u_shift (
        .a(a_reg),
        .shamt(b_reg[4:0]),
        .op(op_reg[1:0]),
        .out(shift_res)
    );

    // 4. Instantiate Comparator Unit
    comparator32 u_comp (
        .a(a_reg),
        .b(b_reg),
        .signed_cmp(op_reg == 4'b0110),
        .out(comp_res)
    );

    // Stage 1: Input Registration
    always @(posedge clk) begin
        if (rst) begin
            a_reg  <= 32'd0;
            b_reg  <= 32'd0;
            op_reg <= 4'd0;
        end else if (en) begin
            a_reg  <= a_in;
            b_reg  <= b_in;
            op_reg <= alu_op;
        end
    end

    // Stage 2: MUX Selection
    always @(*) begin
        case (op_reg)
            4'b0000: comb_mux_out = arith_res; // ADD
            4'b0001: comb_mux_out = arith_res; // SUB
            4'b0010: comb_mux_out = logic_res; // AND
            4'b0011: comb_mux_out = logic_res; // OR
            4'b0100: comb_mux_out = logic_res; // XOR
            4'b0101: comb_mux_out = logic_res; // NOR
            4'b0110: comb_mux_out = comp_res;  // SLT
            4'b0111: comb_mux_out = comp_res;  // SLTU
            4'b1000: comb_mux_out = shift_res; // SLL
            4'b1001: comb_mux_out = shift_res; // SRL
            4'b1010: comb_mux_out = shift_res; // SRA
            4'b1011: comb_mux_out = logic_res; // NAND
            4'b1100: comb_mux_out = logic_res; // XNOR
            4'b1101: comb_mux_out = logic_res; // PASS A
            4'b1110: comb_mux_out = logic_res; // PASS B
            4'b1111: comb_mux_out = shift_res; // ROL
            default: comb_mux_out = 32'd0;
        endcase
    end

    // Stage 3: Output Registration & Flag Calculation
    always @(posedge clk) begin
        if (rst) begin
            alu_out       <= 32'd0;
            zero_flag     <= 1'b0;
            carry_flag    <= 1'b0;
            overflow_flag <= 1'b0;
            negative_flag <= 1'b0;
        end else if (en) begin
            alu_out       <= comb_mux_out;
            zero_flag     <= (comb_mux_out == 32'd0);
            carry_flag    <= (op_reg == 4'b0000 || op_reg == 4'b0001) ? c_out : 1'b0;
            overflow_flag <= (op_reg == 4'b0000 || op_reg == 4'b0001) ? v_out : 1'b0;
            negative_flag <= comb_mux_out[31];
        end
    end

endmodule
