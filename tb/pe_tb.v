`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2026 13:25:39
// Design Name: 
// Module Name: pe_tb
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


module pe_tb;
    reg clk, rst;
    reg signed [7:0] ifm0, ifm1, ifm2, ifm3;
    reg signed [7:0] wgt0, wgt1, wgt2, wgt3;
    wire signed [24:0] p_sum;

    pe dut(.clk(clk), .rst(rst),
           .ifm0(ifm0), .ifm1(ifm1), .ifm2(ifm2), .ifm3(ifm3),
           .wgt0(wgt0), .wgt1(wgt1), .wgt2(wgt2), .wgt3(wgt3),
           .p_sum(p_sum));

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 0;
        ifm0=0; ifm1=0; ifm2=0; ifm3=0;
        wgt0=0; wgt1=0; wgt2=0; wgt3=0;

        @(negedge clk); rst = 1;          // release reset
        ifm0=2; ifm1=3; ifm2=-4; ifm3=5;
        wgt0=3; wgt1=-2; wgt2=1; wgt3=4;

        $monitor("t=%0t pd=(%0d,%0d,%0d,%0d) ps=(%0d,%0d) p_sum=%0d",
                  $time, dut.pd0, dut.pd1, dut.pd2, dut.pd3,
                  dut.ps0, dut.ps1, p_sum);

        repeat (6) @(posedge clk);
        $finish;
    end
endmodule
