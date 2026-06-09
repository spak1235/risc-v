`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2026 07:20:47 PM
// Design Name: 
// Module Name: bpb
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


module bpb(
    input clk, rst,
    input branch_taken,
    input [31:0] prev_pc,
    input ex_branch,
    input [31:0] pc_out,
    output branch_pred
    );

    reg [1:0] bpb_table [15:0];

    localparam LOW_0  = 2'b00;
    localparam LOW_1  = 2'b01;
    localparam HIGH_0 = 2'b10;
    localparam HIGH_1 = 2'b11;

    assign branch_pred = bpb_table[pc_out[5:2]][1];

    integer i;
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 16; i = i + 1'b1) begin
                bpb_table[i] <= 2'b00;  // fix: was 1'b0
            end
        end else begin
            if (ex_branch) begin          // fix: guard update inside else, only when ex_branch
                case (bpb_table[prev_pc[5:2]])
                    LOW_0:  bpb_table[prev_pc[5:2]] <= (branch_taken) ? 2'b01 : 2'b00;
                    LOW_1:  bpb_table[prev_pc[5:2]] <= (branch_taken) ? 2'b10 : 2'b00;
                    HIGH_0: bpb_table[prev_pc[5:2]] <= (branch_taken) ? 2'b11 : 2'b01;
                    HIGH_1: bpb_table[prev_pc[5:2]] <= (branch_taken) ? 2'b11 : 2'b10;
                endcase
            end
        end
    end
endmodule
