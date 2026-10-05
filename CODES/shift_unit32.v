module shift_unit32 (
    input  wire [31:0] a,
    input  wire [4:0]  shamt, // Shift amount (0 to 31)
    input  wire [1:0]  op,    // 0:SLL, 1:SRL, 2:SRA, 3:ROL
    output reg  [31:0] out
);
    always @(*) begin
        case (op)
            2'b00: out = a << shamt;                               // SLL
            2'b01: out = a >> shamt;                               // SRL
            2'b10: out = $signed(a) >>> shamt;                     // SRA
            2'b11: out = (a << shamt) | (a >> (32 - shamt));       // ROL
            default: out = 32'h00000000;
        endcase
    end
endmodule
