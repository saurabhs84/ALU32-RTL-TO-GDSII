`timescale 1ns / 1ps

module alu32_tb;
    reg         clk;
    reg         rst;
    reg         en;
    reg  [3:0]  alu_op;
    reg  [31:0] a_in;
    reg  [31:0] b_in;

    wire [31:0] alu_out;
    wire        zero_flag;
    wire        carry_flag;
    wire        overflow_flag;
    wire        negative_flag;

    integer pass_count = 0;
    integer fail_count = 0;

    alu32 uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .alu_op(alu_op),
        .a_in(a_in),
        .b_in(b_in),
        .alu_out(alu_out),
        .zero_flag(zero_flag),
        .carry_flag(carry_flag),
        .overflow_flag(overflow_flag),
        .negative_flag(negative_flag)
    );

    always #5 clk = ~clk; // 100 MHz clock

    task check_op;
        input [3:0]  op;
        input [31:0] a;
        input [31:0] b;
        input [31:0] exp_res;
        input        exp_z;
        input        exp_n;
        begin
            @(posedge clk);
            a_in   = a;
            b_in   = b;
            alu_op = op;
            en     = 1'b1;

            @(posedge clk); // Allow pipeline register to propagate
            #1;
            if (alu_out === exp_res && zero_flag === exp_z && negative_flag === exp_n) begin
                pass_count = pass_count + 1;
            end else begin
                $display("[-] FAILED: OP=%b A=0x%08h B=0x%08h -> GOT=0x%08h (EXP=0x%08h)", op, a, b, alu_out, exp_res);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("alu32.vcd");
        $dumpvars(0, alu32_tb);

        clk = 0; rst = 1; en = 0; a_in = 0; b_in = 0; alu_op = 0;
        #20 rst = 0;

        $display("         RUNNING 32-BIT ALU TESTBENCH             ");
   

        // Test ADD
        check_op(4'b0000, 32'd100, 32'd250, 32'd350, 1'b0, 1'b0);
        // Test SUB
        check_op(4'b0001, 32'd50, 32'd50, 32'd0, 1'b1, 1'b0);
        // Test AND
        check_op(4'b0010, 32'hFFFF0000, 32'hF0F0AAAA, 32'hF0F00000, 1'b0, 1'b1);
        // Test SLL
        check_op(4'b1000, 32'h00000001, 32'd8, 32'h00000100, 1'b0, 1'b0);
        // Test SRA
        check_op(4'b1010, 32'h80000000, 32'd4, 32'hF8000000, 1'b0, 1'b1);
        // Test SLT Signed
        check_op(4'b0110, -32'd10, 32'd10, 32'd1, 1'b0, 1'b0);

        
        $display(" SUMMARY: PASSED = %0d | FAILED = %0d", pass_count, fail_count);
       
        $finish;
    end
endmodule
