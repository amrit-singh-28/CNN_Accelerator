`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.09.2026 00:25:41
// Design Name: 
// Module Name: loop_ctrl_tb
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
module tb_loop_ctrl;

    reg clk, rst;
    reg start_conv, start_again;
    reg [1:0] cfg_ci, cfg_co;
    wire ifm_read, wgt_read, end_conv;
    wire [5:0] cnt1_o;
    wire [8:0] cnt2_o;
    wire [4:0] cnt3_o;
    wire [2:0] state_o;

    loop_ctrl dut (
        .clk(clk), .rst(rst),
        .start_conv(start_conv), .start_again(start_again),
        .cfg_ci(cfg_ci), .cfg_co(cfg_co),
        .ifm_read(ifm_read), .wgt_read(wgt_read), .end_conv(end_conv),
        .cnt1_o(cnt1_o), .cnt2_o(cnt2_o), .cnt3_o(cnt3_o), .current_state_o(state_o)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 0;
        start_conv = 0; start_again = 0;
        cfg_ci = 2'b00;   // ci = 8  (small on purpose, so FINISH is reachable quickly)
        cfg_co = 2'b00;   // co = 8

        repeat (2) @(negedge clk);
        rst = 1;
        @(negedge clk);

        start_conv = 1;
        @(negedge clk);
        start_conv = 0;

        start_again = 1;
        @(negedge clk);
        start_again = 0;

        // ci=8, co=8: expect roughly 8*8 = 64 tile sweeps of 19 cycles each
        // before FINISH -> generous margin below
        repeat (64 * 19 + 50) @(negedge clk);

        $display("Simulation complete. Did FINISH ever assert? Check waveform/log above.");
        $finish;
    end

    // Cycle-by-cycle trace, no function/$monitor (avoids the XSim crash class)
    always @(posedge clk) begin
        if (rst) begin
            case (state_o)
                3'b000: $write("IDLE");
                3'b001: $write("S1  ");
                3'b010: $write("S2  ");
                3'b100: $write("FIN ");
                default: $write("XXXX");
            endcase
            $display(" | cnt1=%2d cnt2=%2d cnt3=%2d | ifm_read=%b wgt_read=%b end_conv=%b (t=%0t)",
                       cnt1_o, cnt2_o, cnt3_o, ifm_read, wgt_read, end_conv, $time);
        end
    end

    // Self-check: end_conv should pulse exactly once during this run
    integer end_conv_count = 0;
    always @(posedge clk)
        if (end_conv) end_conv_count = end_conv_count + 1;

    initial begin
        #((64*19+60)*10);
        if (end_conv_count == 1)
            $display("*** PASS: end_conv pulsed exactly once ***");
        else
            $display("*** CHECK FAILED: end_conv pulsed %0d times (expected 1) ***", end_conv_count);
    end

endmodule
