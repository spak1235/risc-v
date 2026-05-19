`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2026 03:54:35 AM
// Design Name: 
// Module Name: topmodule
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


module topmodule(
    input clk, rst
    );
    
    //information fetch
    wire [31:0] pc_add;
    wire [31:0] next_pc;
    wire [31:0] alu_output;
    wire [31:0] pc_out;
    wire pcsel;
    wire pc_add_cout;
    wire [31:0] instr;
    
    mux2 pc_selection(pc_add, alu_output, pcsel, next_pc);
    
    pc program_counter(clk, rst, next_pc, pc_out); 
    
    adder pc_4(pc_out, 32'd4, 1'b0, pc_add, pc_add_cout);
    
    imem instruction_memory(pc_out, instr);
    
    //information decode
    wire [31:0] wb;
    wire [31:0] dataA;
    wire [31:0] dataB;
    wire regwen;
    wire [2:0] immsel;
    wire bsel;
    wire [31:0] imm_instr;
    wire [31:0] bsel_out;
    
    regfile registers(clk, instr[19:15], instr[24:20], instr[11:7], wb, regwen, dataA, dataB);
    
    immgen immediate_generator(instr, immsel, imm_instr);
    
    mux2 b_select(dataB, imm_instr, bsel, bsel_out);
    
    //information excecute
    wire taken_branch;
    wire asel;
    wire [3:0] alusel;
    wire [2:0] funct3;
    wire [31:0] asel_out;
    
    assign funct3 = instr[14:12];
    
    branch_comparator branch_comp(dataA, dataB, funct3, taken_branch);
    mux2 a_sel(dataA, pc_out, asel, asel_out);
    alu ALU(asel_out, bsel_out, alusel, alu_output);
    
    //memory access
    wire [31:0] dataR;
    wire memrw;
    
    dmem data_memory(clk, alu_output, dataB, memrw, dataR);
    
    //writeback
    wire [1:0] wbsel;
    
    mux3 writeback(alu_output, dataR, pc_add, wbsel, wb);
    
    //control_unit
    control_unit control_unit(instr, taken_branch, pcsel, immsel, regwen, bsel, asel, alusel, memrw, wbsel);
endmodule
