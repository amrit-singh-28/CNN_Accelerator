`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.09.2026 01:10:17
// Design Name: 
// Module Name: tb_synch_fifo
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


module tb_synch_fifo;

    parameter DW = 8;
    parameter AW = 3;
    parameter DEPTH = 4;  

    reg clk, rst, rd_en, wr_en;
    reg  [DW-1:0] data_in;
    wire [DW-1:0] data_out;
    wire empty, full;

    synch_fifo #(.data_width(DW), .addr_width(AW), .depth(DEPTH)) dut (
        .clk(clk), .rst(rst), .rd_en(rd_en), .wr_en(wr_en),
        .empty(empty), .full(full), .data_out(data_out), .data_in(data_in)
    );

    always #5 clk = ~clk;

    integer errors = 0;
    task check(input cond, input [255:0] msg);
        if (!cond) begin
            $display("*** FAIL: %0s (t=%0t)", msg, $time);
            errors = errors + 1;
        end
    endtask

    initial begin
        clk = 0; rst = 0; rd_en = 0; wr_en = 0; data_in = 0;
        @(negedge clk); rst = 1;

        @(negedge clk); wr_en=1; data_in=8'd10; @(negedge clk);
        wr_en=1; data_in=8'd20; @(negedge clk);
        wr_en=0;
        check(dut.cnt == 2, "cnt should be 2 after two writes");

        rd_en = 1; @(negedge clk);
        check(data_out == 8'd10, "first read should return 10 (FIFO order)");
        @(negedge clk);
        check(data_out == 8'd20, "second read should return 20");
        rd_en = 0;
        check(empty == 1, "FIFO should be empty after draining both writes");

        wr_en = 1;
        data_in = 8'd1; @(negedge clk);
        data_in = 8'd2; @(negedge clk);
        data_in = 8'd3; @(negedge clk);
        data_in = 8'd4; @(negedge clk);
        check(full == 1, "FIFO should be full after DEPTH writes");
        data_in = 8'd99; @(negedge clk);  
        wr_en = 0;
        check(dut.cnt == DEPTH, "cnt must not exceed depth (write while full ignored)");

        wr_en = 1; rd_en = 1; data_in = 8'd55;
        @(negedge clk);
        check(dut.cnt == DEPTH, "cnt must stay at depth: write blocked, only read happens");
        check(data_out == 8'd1, "the read during full+simultaneous-write should return oldest value (1)");
        wr_en = 0; rd_en = 0;

        rd_en = 1;
        repeat (3) @(negedge clk);
        rd_en = 0;
        check(empty == 1, "FIFO should be empty after draining remaining entries");

        wr_en = 1; rd_en = 1; data_in = 8'd77;
        @(negedge clk);
        check(dut.cnt == 1, "cnt must go to 1: read blocked (empty), only write happens");
        wr_en = 0; rd_en = 0;

        if (errors == 0)
            $display("*** ALL CHECKS PASSED ***");
        else
            $display("*** %0d CHECK(S) FAILED ***", errors);

        $finish;
    end

endmodule
