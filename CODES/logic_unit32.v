module logic_unit32 (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [2:0]  op, // 0:AND, 1:OR, 2:XOR, 3:NOR, 4:NAND, 5:XNOR, 6:PASSA, 7:PASSB
    output reg  [31:0] out
);
    always @(*) begin
        case (op)
            3'b000:  out = a & b;       // AND
            3'b001:  out = a | b;       // OR
            3'b010:  out = a ^ b;       // XOR
            3'b011:  out = ~(a | b);    // NOR
            3'b100:  out = ~(a & b);    // NAND
            3'b101:  out = ~(a ^ b);    // XNOR
            3'b110:  out = a;           // PASS A
            3'b111:  out = b;           // PASS B
            default: out = 32'h00000000;
        endcase
    end
endmodule
