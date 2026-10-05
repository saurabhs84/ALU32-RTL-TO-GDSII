module comparator32 (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire        signed_cmp, // 1: Signed (SLT), 0: Unsigned (SLTU)
    output wire [31:0] out
);
    wire less_than = signed_cmp ? ($signed(a) < $signed(b)) : (a < b);
    assign out = less_than ? 32'd1 : 32'd0;
endmodule
