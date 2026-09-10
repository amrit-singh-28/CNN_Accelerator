`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.09.2026 23:54:13
// Design Name: 
// Module Name: PE_FSM
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


module loop_ctrl(
    input clk,
    input rst,               
    input start_conv,
    input start_again,
    input [1:0] cfg_ci,
    input [1:0] cfg_co,

    output reg ifm_read,
    output reg wgt_read,
    output reg end_conv,

    
    output [5:0] cnt1_o,
    output [8:0] cnt2_o,
    output [4:0] cnt3_o,
    output [2:0] current_state_o
    );

    reg [5:0] ci, co;
    reg [5:0] cnt1;
    reg [8:0] cnt2;
    reg [4:0] cnt3;

    reg [2:0] current_state;
    reg [2:0] next_state;

    parameter [2:0] IDLE = 3'b000, S1 = 3'b001, S2 = 3'b010, FINISH = 3'b100;
    parameter [6:0] tile_length = 16;

    assign cnt1_o = cnt1;
    assign cnt2_o = cnt2;
    assign cnt3_o = cnt3;
    assign current_state_o = current_state;

    
    always @(posedge clk or negedge rst)
        if (!rst) current_state <= IDLE;
        else      current_state <= next_state;

    
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ci <= 0;
            co <= 0;
        end else if (start_conv) begin
            ci <= ((cfg_ci + 6'b000001) << 3);
            co <= ((cfg_co + 6'b000001) << 3);
        end
    end
   
    wire tile_done   = (cnt1 == tile_length + 2);
    wire ci_done     = tile_done && (cnt2 == ci - 1);   
    wire job_done    = ci_done   && (cnt3 == co - 1);  

    always @(*) begin
        next_state = 3'bx;
        case (current_state)
            IDLE:
                if (start_again)
                    next_state = S1;
                else
                    next_state = IDLE;

            S1:
                next_state = (cnt1 == 4) ? S2 : S1;

            S2:
                if (job_done)
                    next_state = FINISH;   
                else if (tile_done)
                    next_state = S1;       
                else
                    next_state = S2;

            FINISH:
                next_state = IDLE;

            default:
                next_state = IDLE;
        endcase
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            cnt1 <= 0;
        end else begin
            if (next_state == IDLE)
                cnt1 <= 0;
            else if(current_state == IDLE)
                cnt1 <= 0;
            else if (cnt1 == tile_length + 2)
                cnt1 <= 0;
            else
                cnt1 <= cnt1 + 1;
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            cnt2 <= 0;
        end else if (next_state == IDLE) begin
            cnt2 <= 0;
        end else if (tile_done) begin
            if (cnt2 == ci - 1)
                cnt2 <= 0;
            else
                cnt2 <= cnt2 + 1;
        end
        
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            cnt3 <= 0;
        end else if (next_state == IDLE) begin
            cnt3 <= 0;
        end else if (ci_done) begin
            if (cnt3 == co - 1)
                cnt3 <= 0;
            else
                cnt3 <= cnt3 + 1;
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ifm_read <= 0;
            wgt_read <= 0;
            end_conv <= 0;
        end else begin
            case (next_state)
                S1: begin
                    ifm_read <= 1;
                    wgt_read <= 1;
                    end_conv <= 0;
                end
                S2: begin
                    ifm_read <= 1;
                    wgt_read <= 0;
                    end_conv <= 0;
                end
                FINISH: begin
                    ifm_read <= 0;
                    wgt_read <= 0;
                    end_conv <= 1;   
                end
                default: begin      
                    ifm_read <= 0;
                    wgt_read <= 0;
                    end_conv <= 0;
                end
            endcase
        end
    end

endmodule
