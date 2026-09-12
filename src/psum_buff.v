`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.09.2026 16:26:16
// Design Name: 
// Module Name: psum_buff
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


//=====================================================================
// psum_buff.v -- Ping-pong partial-sum accumulation buffer.
// Combines psum_add (4-PE column sum) with two synch_fifo instances
// that alternate between "accumulating" and "draining" roles.
//=====================================================================
module psum_buff #(
    parameter data_width = 25,
    parameter addr_width = 8,
    parameter depth      = 61
) (
    input clk,
    input rst,                  // active-low async reset

    input p_valid_data,
    input p_write_zero,
    input p_init,
    input odd_cnt,

    input signed [data_width-1:0] pe0_data,
    input signed [data_width-1:0] pe1_data,
    input signed [data_width-1:0] pe2_data,
    input signed [data_width-1:0] pe3_data,

    output [data_width-1:0] fifo_out,
    output valid_fifo_out
);

    wire signed [data_width-1:0] adder_out;
    wire empty0, full0, empty1, full1;
    wire [data_width-1:0] fifo_out_i0, fifo_out_i1;

    reg [data_width-1:0] fifo_in0, fifo_in1;
    reg fifo_rd_en0, fifo_wr_en0, fifo_rd_en1, fifo_wr_en1;

    reg d_odd_cnt;               // odd_cnt delayed by 1 cycle
    reg [2:0] p_valid;           // 3-deep shift register: taps [0] (read) and [2] (write)
    reg p_write_zero_reg;

    reg [data_width-1:0] fifo_out_i;   // "draining" role output
    reg [data_width-1:0] fifo_out_a;   // "accumulating" role output -> feeds psum_add

    //-------------------------------------------------------------
    // Delayed odd_cnt: determines which physical FIFO plays which role
    //-------------------------------------------------------------
    always @(posedge clk or negedge rst) begin
        if (!rst) d_odd_cnt <= 0;
        else      d_odd_cnt <= odd_cnt;
    end

    //-------------------------------------------------------------
    // Role mux: swap which FIFO is "accumulating" vs "draining"
    //-------------------------------------------------------------
    always @(*) begin
        if (!rst) begin
            fifo_out_i = 0;
            fifo_out_a = 0;
        end else if (~d_odd_cnt) begin
            fifo_out_i = fifo_out_i1;
            fifo_out_a = fifo_out_i0;
        end else begin
            fifo_out_i = fifo_out_i0;
            fifo_out_a = fifo_out_i1;
        end
    end

    assign valid_fifo_out = p_write_zero_reg;
    assign fifo_out = fifo_out_i[data_width-1] ? {data_width{1'b0}} : fifo_out_i;  // ReLU

    //-------------------------------------------------------------
    // p_valid: 3-deep shift register timing the read/write pair.
    // Tap [0] (1-cycle delay)  -> pop the old accumulated value
    // Tap [2] (3-cycle delay)  -> push the freshly-summed value back
    // Gap of 2 cycles matches psum_add's PE-to-psum2 settling latency.
    //-------------------------------------------------------------
    always @(posedge clk or negedge rst) begin
        if (!rst) p_valid <= 3'b0;
        else      p_valid <= {p_valid[1:0], p_valid_data};
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) p_write_zero_reg <= 1'b0;
        else      p_write_zero_reg <= p_write_zero;
    end

    //-------------------------------------------------------------
    // FIFO read/write enable + data-in selection.
    // Exactly 4 reachable cases after p_init, covering all
    // (write_zero, d_odd_cnt) combinations -- no dead-code else needed.
    //-------------------------------------------------------------
    wire write_zero = p_write_zero || p_write_zero_reg;

    always @(*) begin
        if (!rst) begin
            fifo_rd_en0 = 0; fifo_wr_en0 = 0;
            fifo_rd_en1 = 0; fifo_wr_en1 = 0;
            fifo_in0 = 0;    fifo_in1 = 0;
        end else if (p_init) begin
            // Force both FIFOs to accept a zero -- whole-convolution start
            fifo_rd_en0 = 0; fifo_wr_en0 = 1;
            fifo_rd_en1 = 0; fifo_wr_en1 = 1;
            fifo_in0 = 0;    fifo_in1 = 0;
        end else if (write_zero && d_odd_cnt) begin
            // fifo0 is the one being "reset to zero" (its old result drains out);
            // fifo1 continues normal accumulate read/write
            fifo_rd_en0 = p_write_zero;
            fifo_wr_en0 = p_write_zero_reg;
            fifo_rd_en1 = p_valid[0];
            fifo_wr_en1 = p_valid[2];
            fifo_in0 = 0;
            fifo_in1 = adder_out;
        end else if (write_zero && ~d_odd_cnt) begin
            fifo_rd_en1 = p_write_zero;
            fifo_wr_en1 = p_write_zero_reg;
            fifo_rd_en0 = p_valid[0];
            fifo_wr_en0 = p_valid[2];
            fifo_in1 = 0;
            fifo_in0 = adder_out;
        end else if (~d_odd_cnt) begin
            // normal accumulation, no role swap this cycle
            fifo_rd_en1 = 0; fifo_wr_en1 = 0;
            fifo_rd_en0 = p_valid[0];
            fifo_wr_en0 = p_valid[2];
            fifo_in1 = 0;
            fifo_in0 = adder_out;
        end else begin
            fifo_rd_en0 = 0; fifo_wr_en0 = 0;
            fifo_rd_en1 = p_valid[0];
            fifo_wr_en1 = p_valid[2];
            fifo_in0 = 0;
            fifo_in1 = adder_out;
        end
    end

    //-------------------------------------------------------------
    // Sub-modules: adder tree (Day 7) + two FIFOs (Day 6)
    //-------------------------------------------------------------
    psum_add #(.data_width(data_width)) adder_tree (
        .clk(clk), .rst(rst),
        .pe0_data(pe0_data), .pe1_data(pe1_data),
        .pe2_data(pe2_data), .pe3_data(pe3_data),
        .fifo_data(fifo_out_a),
        .out(adder_out)
    );

    synch_fifo #(.data_width(data_width), .addr_width(addr_width), .depth(depth)) fifo0 (
        .clk(clk), .rst(rst),
        .rd_en(fifo_rd_en0), .wr_en(fifo_wr_en0),
        .empty(empty0), .full(full0),
        .data_out(fifo_out_i0), .data_in(fifo_in0)
    );

    synch_fifo #(.data_width(data_width), .addr_width(addr_width), .depth(depth)) fifo1 (
        .clk(clk), .rst(rst),
        .rd_en(fifo_rd_en1), .wr_en(fifo_wr_en1),
        .empty(empty1), .full(full1),
        .data_out(fifo_out_i1), .data_in(fifo_in1)
    );

endmodule
