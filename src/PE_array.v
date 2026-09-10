`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.09.2026 23:50:38
// Design Name: 
// Module Name: PE_array
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


module pe_array(
input clk,
    input rst,               // active-low async reset (matches pe.v / ifm_buf.v)

    input ifm_read,
    input wgt_read,

    input signed [7:0] ifm_row0, ifm_row1, ifm_row2, ifm_row3,
    input signed [7:0] ifm_row4, ifm_row5, ifm_row6, ifm_row7,

    input signed [7:0] wgt_row0, wgt_row1, wgt_row2, wgt_row3,

    // Flattened 20 PE outputs, p_r_c naming: row r, col c
    output signed [24:0] p00, p01, p02, p03, p04,
    output signed [24:0] p10, p11, p12, p13, p14,
    output signed [24:0] p20, p21, p22, p23, p24,
    output signed [24:0] p30, p31, p32, p33, p34
    );
    
wire signed [7:0] ifm_b0_0, ifm_b0_1, ifm_b0_2, ifm_b0_3;
    wire signed [7:0] ifm_b1_0, ifm_b1_1, ifm_b1_2, ifm_b1_3;
    wire signed [7:0] ifm_b2_0, ifm_b2_1, ifm_b2_2, ifm_b2_3;
    wire signed [7:0] ifm_b3_0, ifm_b3_1, ifm_b3_2, ifm_b3_3;
    wire signed [7:0] ifm_b4_0, ifm_b4_1, ifm_b4_2, ifm_b4_3;
    wire signed [7:0] ifm_b5_0, ifm_b5_1, ifm_b5_2, ifm_b5_3;
    wire signed [7:0] ifm_b6_0, ifm_b6_1, ifm_b6_2, ifm_b6_3;
    wire signed [7:0] ifm_b7_0, ifm_b7_1, ifm_b7_2, ifm_b7_3;

    ifm_buf ifm_buf0(.clk(clk), .rst(rst), .ifm_i(ifm_row0), .read(ifm_read),
                      .buf0(ifm_b0_0), .buf1(ifm_b0_1), .buf2(ifm_b0_2), .buf3(ifm_b0_3));
    ifm_buf ifm_buf1(.clk(clk), .rst(rst), .ifm_i(ifm_row1), .read(ifm_read),
                      .buf0(ifm_b1_0), .buf1(ifm_b1_1), .buf2(ifm_b1_2), .buf3(ifm_b1_3));
    ifm_buf ifm_buf2(.clk(clk), .rst(rst), .ifm_i(ifm_row2), .read(ifm_read),
                      .buf0(ifm_b2_0), .buf1(ifm_b2_1), .buf2(ifm_b2_2), .buf3(ifm_b2_3));
    ifm_buf ifm_buf3(.clk(clk), .rst(rst), .ifm_i(ifm_row3), .read(ifm_read),
                      .buf0(ifm_b3_0), .buf1(ifm_b3_1), .buf2(ifm_b3_2), .buf3(ifm_b3_3));
    ifm_buf ifm_buf4(.clk(clk), .rst(rst), .ifm_i(ifm_row4), .read(ifm_read),
                      .buf0(ifm_b4_0), .buf1(ifm_b4_1), .buf2(ifm_b4_2), .buf3(ifm_b4_3));
    ifm_buf ifm_buf5(.clk(clk), .rst(rst), .ifm_i(ifm_row5), .read(ifm_read),
                      .buf0(ifm_b5_0), .buf1(ifm_b5_1), .buf2(ifm_b5_2), .buf3(ifm_b5_3));
    ifm_buf ifm_buf6(.clk(clk), .rst(rst), .ifm_i(ifm_row6), .read(ifm_read),
                      .buf0(ifm_b6_0), .buf1(ifm_b6_1), .buf2(ifm_b6_2), .buf3(ifm_b6_3));
    ifm_buf ifm_buf7(.clk(clk), .rst(rst), .ifm_i(ifm_row7), .read(ifm_read),
                      .buf0(ifm_b7_0), .buf1(ifm_b7_1), .buf2(ifm_b7_2), .buf3(ifm_b7_3));

    //-----------------------------------------------------------------
    // 4 WGT line buffers (one per PE-array row)
    //-----------------------------------------------------------------
    wire signed [7:0] wgt_b0_0, wgt_b0_1, wgt_b0_2, wgt_b0_3;
    wire signed [7:0] wgt_b1_0, wgt_b1_1, wgt_b1_2, wgt_b1_3;
    wire signed [7:0] wgt_b2_0, wgt_b2_1, wgt_b2_2, wgt_b2_3;
    wire signed [7:0] wgt_b3_0, wgt_b3_1, wgt_b3_2, wgt_b3_3;

    wgt_buf wgt_buf0(.clk(clk), .rst(rst), .wgt_i(wgt_row0), .read(wgt_read),
                      .buf0(wgt_b0_0), .buf1(wgt_b0_1), .buf2(wgt_b0_2), .buf3(wgt_b0_3));
    wgt_buf wgt_buf1(.clk(clk), .rst(rst), .wgt_i(wgt_row1), .read(wgt_read),
                      .buf0(wgt_b1_0), .buf1(wgt_b1_1), .buf2(wgt_b1_2), .buf3(wgt_b1_3));
    wgt_buf wgt_buf2(.clk(clk), .rst(rst), .wgt_i(wgt_row2), .read(wgt_read),
                      .buf0(wgt_b2_0), .buf1(wgt_b2_1), .buf2(wgt_b2_2), .buf3(wgt_b2_3));
    wgt_buf wgt_buf3(.clk(clk), .rst(rst), .wgt_i(wgt_row3), .read(wgt_read),
                      .buf0(wgt_b3_0), .buf1(wgt_b3_1), .buf2(wgt_b3_2), .buf3(wgt_b3_3));

    //-----------------------------------------------------------------
    // 20 PEs.  PE[r][c]: ifm from ifm_buf[r+c], wgt from wgt_buf[r]
    //-----------------------------------------------------------------
    // Row 0 (uses wgt_buf0; ifm_buf0..ifm_buf4)
    pe pe00(.clk(clk), .rst(rst), .ifm0(ifm_b0_0), .ifm1(ifm_b0_1), .ifm2(ifm_b0_2), .ifm3(ifm_b0_3),
            .wgt0(wgt_b0_0), .wgt1(wgt_b0_1), .wgt2(wgt_b0_2), .wgt3(wgt_b0_3), .p_sum(p00));
    pe pe01(.clk(clk), .rst(rst), .ifm0(ifm_b1_0), .ifm1(ifm_b1_1), .ifm2(ifm_b1_2), .ifm3(ifm_b1_3),
            .wgt0(wgt_b0_0), .wgt1(wgt_b0_1), .wgt2(wgt_b0_2), .wgt3(wgt_b0_3), .p_sum(p01));
    pe pe02(.clk(clk), .rst(rst), .ifm0(ifm_b2_0), .ifm1(ifm_b2_1), .ifm2(ifm_b2_2), .ifm3(ifm_b2_3),
            .wgt0(wgt_b0_0), .wgt1(wgt_b0_1), .wgt2(wgt_b0_2), .wgt3(wgt_b0_3), .p_sum(p02));
    pe pe03(.clk(clk), .rst(rst), .ifm0(ifm_b3_0), .ifm1(ifm_b3_1), .ifm2(ifm_b3_2), .ifm3(ifm_b3_3),
            .wgt0(wgt_b0_0), .wgt1(wgt_b0_1), .wgt2(wgt_b0_2), .wgt3(wgt_b0_3), .p_sum(p03));
    pe pe04(.clk(clk), .rst(rst), .ifm0(ifm_b4_0), .ifm1(ifm_b4_1), .ifm2(ifm_b4_2), .ifm3(ifm_b4_3),
            .wgt0(wgt_b0_0), .wgt1(wgt_b0_1), .wgt2(wgt_b0_2), .wgt3(wgt_b0_3), .p_sum(p04));

    // Row 1 (uses wgt_buf1; ifm_buf1..ifm_buf5)
    pe pe10(.clk(clk), .rst(rst), .ifm0(ifm_b1_0), .ifm1(ifm_b1_1), .ifm2(ifm_b1_2), .ifm3(ifm_b1_3),
            .wgt0(wgt_b1_0), .wgt1(wgt_b1_1), .wgt2(wgt_b1_2), .wgt3(wgt_b1_3), .p_sum(p10));
    pe pe11(.clk(clk), .rst(rst), .ifm0(ifm_b2_0), .ifm1(ifm_b2_1), .ifm2(ifm_b2_2), .ifm3(ifm_b2_3),
            .wgt0(wgt_b1_0), .wgt1(wgt_b1_1), .wgt2(wgt_b1_2), .wgt3(wgt_b1_3), .p_sum(p11));
    pe pe12(.clk(clk), .rst(rst), .ifm0(ifm_b3_0), .ifm1(ifm_b3_1), .ifm2(ifm_b3_2), .ifm3(ifm_b3_3),
            .wgt0(wgt_b1_0), .wgt1(wgt_b1_1), .wgt2(wgt_b1_2), .wgt3(wgt_b1_3), .p_sum(p12));
    pe pe13(.clk(clk), .rst(rst), .ifm0(ifm_b4_0), .ifm1(ifm_b4_1), .ifm2(ifm_b4_2), .ifm3(ifm_b4_3),
            .wgt0(wgt_b1_0), .wgt1(wgt_b1_1), .wgt2(wgt_b1_2), .wgt3(wgt_b1_3), .p_sum(p13));
    pe pe14(.clk(clk), .rst(rst), .ifm0(ifm_b5_0), .ifm1(ifm_b5_1), .ifm2(ifm_b5_2), .ifm3(ifm_b5_3),
            .wgt0(wgt_b1_0), .wgt1(wgt_b1_1), .wgt2(wgt_b1_2), .wgt3(wgt_b1_3), .p_sum(p14));

    // Row 2 (uses wgt_buf2; ifm_buf2..ifm_buf6)
    pe pe20(.clk(clk), .rst(rst), .ifm0(ifm_b2_0), .ifm1(ifm_b2_1), .ifm2(ifm_b2_2), .ifm3(ifm_b2_3),
            .wgt0(wgt_b2_0), .wgt1(wgt_b2_1), .wgt2(wgt_b2_2), .wgt3(wgt_b2_3), .p_sum(p20));
    pe pe21(.clk(clk), .rst(rst), .ifm0(ifm_b3_0), .ifm1(ifm_b3_1), .ifm2(ifm_b3_2), .ifm3(ifm_b3_3),
            .wgt0(wgt_b2_0), .wgt1(wgt_b2_1), .wgt2(wgt_b2_2), .wgt3(wgt_b2_3), .p_sum(p21));
    pe pe22(.clk(clk), .rst(rst), .ifm0(ifm_b4_0), .ifm1(ifm_b4_1), .ifm2(ifm_b4_2), .ifm3(ifm_b4_3),
            .wgt0(wgt_b2_0), .wgt1(wgt_b2_1), .wgt2(wgt_b2_2), .wgt3(wgt_b2_3), .p_sum(p22));
    pe pe23(.clk(clk), .rst(rst), .ifm0(ifm_b5_0), .ifm1(ifm_b5_1), .ifm2(ifm_b5_2), .ifm3(ifm_b5_3),
            .wgt0(wgt_b2_0), .wgt1(wgt_b2_1), .wgt2(wgt_b2_2), .wgt3(wgt_b2_3), .p_sum(p23));
    pe pe24(.clk(clk), .rst(rst), .ifm0(ifm_b6_0), .ifm1(ifm_b6_1), .ifm2(ifm_b6_2), .ifm3(ifm_b6_3),
            .wgt0(wgt_b2_0), .wgt1(wgt_b2_1), .wgt2(wgt_b2_2), .wgt3(wgt_b2_3), .p_sum(p24));

    // Row 3 (uses wgt_buf3; ifm_buf3..ifm_buf7)
    pe pe30(.clk(clk), .rst(rst), .ifm0(ifm_b3_0), .ifm1(ifm_b3_1), .ifm2(ifm_b3_2), .ifm3(ifm_b3_3),
            .wgt0(wgt_b3_0), .wgt1(wgt_b3_1), .wgt2(wgt_b3_2), .wgt3(wgt_b3_3), .p_sum(p30));
    pe pe31(.clk(clk), .rst(rst), .ifm0(ifm_b4_0), .ifm1(ifm_b4_1), .ifm2(ifm_b4_2), .ifm3(ifm_b4_3),
            .wgt0(wgt_b3_0), .wgt1(wgt_b3_1), .wgt2(wgt_b3_2), .wgt3(wgt_b3_3), .p_sum(p31));
    pe pe32(.clk(clk), .rst(rst), .ifm0(ifm_b5_0), .ifm1(ifm_b5_1), .ifm2(ifm_b5_2), .ifm3(ifm_b5_3),
            .wgt0(wgt_b3_0), .wgt1(wgt_b3_1), .wgt2(wgt_b3_2), .wgt3(wgt_b3_3), .p_sum(p32));
    pe pe33(.clk(clk), .rst(rst), .ifm0(ifm_b6_0), .ifm1(ifm_b6_1), .ifm2(ifm_b6_2), .ifm3(ifm_b6_3),
            .wgt0(wgt_b3_0), .wgt1(wgt_b3_1), .wgt2(wgt_b3_2), .wgt3(wgt_b3_3), .p_sum(p33));
    pe pe34(.clk(clk), .rst(rst), .ifm0(ifm_b7_0), .ifm1(ifm_b7_1), .ifm2(ifm_b7_2), .ifm3(ifm_b7_3),
            .wgt0(wgt_b3_0), .wgt1(wgt_b3_1), .wgt2(wgt_b3_2), .wgt3(wgt_b3_3), .p_sum(p34));

endmodule
