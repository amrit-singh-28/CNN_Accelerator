`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.09.2026 17:08:38
// Design Name: 
// Module Name: tb_psum_add
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps
module tb_psum_add;

    reg clk, rst;
    reg signed [24:0] pe0, pe1, pe2, pe3, fifo_d;
    wire signed [24:0] out;

    psum_add dut (
        .clk(clk), .rst(rst),
        .pe0_data(pe0), .pe1_data(pe1), .pe2_data(pe2), .pe3_data(pe3),
        .fifo_data(fifo_d),
        .out(out)
    );

    always #5 clk = ~clk;

    integer errors = 0;
    task check(input cond, input [511:0] msg);  
        if (!cond) begin
            $display("*** FAIL: %0s (t=%0t)", msg, $time);
            errors = errors + 1;
        end
    endtask

    initial begin
        clk=0; rst=0;
        pe0=0; pe1=0; pe2=0; pe3=0; fifo_d=0;
        @(negedge clk); rst = 1;

        pe0 = 25'sd10;
        pe1 = -25'sd3;
        pe2 = 25'sd7;
        pe3 = 25'sd2;
        fifo_d = 25'sd100;
      
        @(negedge clk);
        check(out == 25'sd100, "edge 1: out = fifo_data + stale psum2(0) = 100");
        @(negedge clk);
        check(out == 25'sd100, "edge 2: out still 100 -- psum2 just became real (16) but hasn't reached out_r yet");
        @(negedge clk);
        check(out == 25'sd116, "edge 3: out = fifo_data(100) + real psum2(16) = 116, pipeline fully settled");
        @(negedge clk);
        check(out == 25'sd116, "edge 4: out remains 116 while inputs held steady");

        if (errors == 0) $display("*** ALL CHECKS PASSED ***");
        else              $display("*** %0d CHECK(S) FAILED ***", errors);

        $finish;
    end

endmodule
