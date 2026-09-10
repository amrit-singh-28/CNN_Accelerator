`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.09.2026 01:08:06
// Design Name: 
// Module Name: synch_fifo
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

module synch_fifo #(
    parameter data_width = 25,
    parameter addr_width = 8,
    parameter depth      = 61
) (
    input clk,
    input rst,                 
    input rd_en,
    input wr_en,

    output empty,
    output full,
    output reg [data_width-1:0] data_out,
    input      [data_width-1:0] data_in
);

    reg [addr_width:0]   cnt;             
    reg [data_width-1:0] fifo_mem [0:depth-1];
    reg [addr_width-1:0] rd_ptr;
    reg [addr_width-1:0] wr_ptr;

    assign empty = (cnt == 0);
    assign full  = (cnt == depth);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            rd_ptr <= 0;
        end else if (rd_en && !empty) begin
            rd_ptr <= (rd_ptr == depth - 1) ? 0 : rd_ptr + 1;
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            data_out <= 0;
        end else if (rd_en && !empty) begin
            data_out <= fifo_mem[rd_ptr];
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            wr_ptr <= (wr_ptr == depth - 1) ? 0 : wr_ptr + 1;
        end
    end

    always @(posedge clk) begin
        if (wr_en && !full)
            fifo_mem[wr_ptr] <= data_in;
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            cnt <= 0;
        end else begin
            case ({wr_en, rd_en})
                2'b00: cnt <= cnt;
                2'b01: cnt <= (!empty) ? cnt - 1 : cnt;
                2'b10: cnt <= (!full)  ? cnt + 1 : cnt;
                2'b11: begin
                    if (empty)       cnt <= cnt + 1; 
                    else if (full)   cnt <= cnt - 1;  
                    else             cnt <= cnt;    
                end
            endcase
        end
    end

endmodule
