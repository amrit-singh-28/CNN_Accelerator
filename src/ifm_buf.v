`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2026 23:09:03
// Design Name: 
// Module Name: ifm_buf
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


module ifm_buf(
input clk,
input rst,
input signed [7:0] ifm_i,
input read,

output reg signed [7:0] buf0, buf1, buf2, buf3
    );
    
always @(posedge clk or negedge rst) begin
if(~rst) begin
buf0 <=0; buf1<=0; buf2<=0; buf3<=0;
end

else begin
    if(read) begin
    buf3<=buf2; buf2<=buf1; buf1<=buf0; buf0<=ifm_i;
    end
    
    else begin
    buf3<=buf3; buf2<=buf2; buf1<=buf1; buf0<=buf0;
    end
end
end
endmodule
