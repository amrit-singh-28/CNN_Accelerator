`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2026 23:19:49
// Design Name: 
// Module Name: ifm_buf_tb
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

module tb_ifm_buf;
    reg clk, rst, read;
    reg signed [7:0] ifm_i;
    wire signed [7:0] buf0, buf1, buf2, buf3;

    ifm_buf dut(.clk(clk), .rst(rst), .ifm_i(ifm_i), .read(read),
                .buf0(buf0), .buf1(buf1), .buf2(buf2), .buf3(buf3));

    always #5 clk = ~clk;

    initial begin
        clk=0; rst=0; read=0; ifm_i=0;
        @(negedge clk); rst=1;

        read = 1;
        ifm_i = 8'd10; @(posedge clk);
        ifm_i = 8'd20; @(posedge clk);
        ifm_i = 8'd30; @(posedge clk);
        ifm_i = 8'd40; @(posedge clk);
        $display("after 4 pushes: buf0=%0d buf1=%0d buf2=%0d buf3=%0d", buf0,buf1,buf2,buf3);

        read = 0;
        ifm_i = 8'd99; @(posedge clk);
        $display("after hold (ifm_i=99 ignored): buf0=%0d buf1=%0d buf2=%0d buf3=%0d", buf0,buf1,buf2,buf3);

        $finish;
    end
endmodule
