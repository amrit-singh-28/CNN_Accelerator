`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.09.2026 16:06:09
// Design Name: 
// Module Name: psum_add
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


module psum_add #(
    parameter data_width = 25
) (
    input clk,
    input rst,               

    input signed [data_width-1:0] pe0_data,
    input signed [data_width-1:0] pe1_data,
    input signed [data_width-1:0] pe2_data,
    input signed [data_width-1:0] pe3_data,
    input signed [data_width-1:0] fifo_data,

    output signed [data_width-1:0] out
);

    reg signed [data_width-1:0] psum0;
    reg signed [data_width-1:0] psum1;
    reg signed [data_width-1:0] psum2;
    reg signed [data_width-1:0] out_r;

    assign out = out_r;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            psum0 <= 0;
            psum1 <= 0;
            psum2 <= 0;
            out_r <= 0;
        end else begin
            psum0 <= pe0_data + pe1_data;  
            psum1 <= pe2_data + pe3_data;   
            psum2 <= psum0 + psum1;         
            out_r <= fifo_data + psum2;    
        end
    end

endmodule
