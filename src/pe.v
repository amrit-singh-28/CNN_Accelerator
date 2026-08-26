`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2026 13:01:19
// Design Name: 
// Module Name: pe
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


module pe(
input clk,
input rst,

input signed [7:0] ifm0, ifm1, ifm2, ifm3,
input signed [7:0] wgt0, wgt1, wgt2, wgt3,

output reg signed [24:0] p_sum
    );
    
reg signed [15:0] pd0, pd1, pd2, pd3;
reg signed [16:0] ps0, ps1;

always @(posedge clk or negedge rst) begin
if(~rst) begin
pd0<=0;pd1<=0;pd2<=0;pd3<=0;
ps0<=0;ps1<=0;
p_sum<=0;
end
else begin
pd0 <= ifm0*wgt0;
pd1 <= ifm1*wgt1;
pd2 <= ifm2*wgt2;
pd3 <= ifm3*wgt3;

ps0 <= pd0+pd1;
ps1 <= pd2+pd3;

p_sum <= ps0+ps1;
end
end
endmodule
