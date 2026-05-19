`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2026 03:43:41 PM
// Design Name: 
// Module Name: topmodule_tb
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

module topmodule_tb;

    reg clk;
    reg rst;

    // DUT
    topmodule uut (
        .clk(clk),
        .rst(rst)
    );

    // -----------------------------
    // CLOCK GENERATION
    // -----------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // -----------------------------
    // TEST SEQUENCE
    // -----------------------------
    initial begin

        // RESET
        rst = 1;

        #10;

        rst = 0;

        // RUN PROGRAM
        #200;

        // -----------------------------
        // REGISTER CHECKS
        // -----------------------------
        $display("====================================");
        $display("REGISTER VALUES");
        $display("====================================");

        $display("x1  = %d", uut.registers.regs[1]);
        $display("x2  = %d", uut.registers.regs[2]);
        $display("x3  = %d", uut.registers.regs[3]);
        $display("x4  = %d", uut.registers.regs[4]);
        $display("x5  = %d", uut.registers.regs[5]);
        $display("x6  = %d", uut.registers.regs[6]);
        $display("x7  = %d", uut.registers.regs[7]);

        // -----------------------------
        // MEMORY CHECKS
        // -----------------------------
        $display("====================================");
        $display("DATA MEMORY VALUES");
        $display("====================================");

        $display("mem[1] = %d", uut.data_memory.datamemorys[1]);
        $display("mem[2] = %d", uut.data_memory.datamemorys[2]);

        // -----------------------------
        // FINAL PC
        // -----------------------------
        $display("====================================");
        $display("FINAL PC");
        $display("====================================");

        $display("PC = %d", uut.pc_out);

        #20;

        $finish;

    end

    // -----------------------------
    // LIVE EXECUTION MONITOR
    // -----------------------------
    initial begin

        $display("==============================================");
        $display("TIME\tPC\t\tINSTR");
        $display("==============================================");

        $monitor("%0t\t%d\t%h",
                 $time,
                 uut.pc_out,
                 uut.instr);

    end

endmodule
