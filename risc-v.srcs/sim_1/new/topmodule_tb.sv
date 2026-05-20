`timescale 1ns / 1ps

module topmodule_tb;

    reg clk;
    reg rst;

    // -------------------------------------------------
    // DUT
    // -------------------------------------------------
    topmodule uut(
        .clk(clk),
        .rst(rst)
    );

    // -------------------------------------------------
    // CLOCK GENERATION
    // -------------------------------------------------
    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end

    // -------------------------------------------------
    // RESET
    // -------------------------------------------------
    initial begin

        rst = 1'b1;

        #20;

        rst = 1'b0;

    end

    // -------------------------------------------------
    // OPTIONAL MEMORY INITIALIZATION
    // -------------------------------------------------
    initial begin

        // optional
        // uut.data_memory.mem[0] = 32'd0;

    end

    // -------------------------------------------------
    // MONITOR
    // -------------------------------------------------
    initial begin

        $display("===============================================================================================================================================================================");
        $display("TIME\tPC\tINSTR\t\tSTALL\tFORA\tFORB\tIDEX_RD\tEXMEM_RD\tMEMWB_RD\tALU_OUT\tWB\tPCSEL");
        $display("===============================================================================================================================================================================");

        $monitor("%0t\t%d\t%h\t%b\t%b\t%b\t%d\t\t%d\t\t%d\t\t%d\t%d\t%b",
                 $time,

                 uut.pc_out,
                 uut.IfId_instr,

                 uut.stall,

                 uut.forwardA,
                 uut.forwardB,

                 uut.IdEx_addrd,
                 uut.ExMa_addrd,
                 uut.MaWb_addrd,

                 uut.alu_output,
                 uut.wb,

                 uut.pcsel);

    end

    // -------------------------------------------------
    // FINAL RESULTS
    // -------------------------------------------------
    initial begin

        #500;

        $display("\n====================================");
        $display("FINAL REGISTER VALUES");
        $display("====================================");

        $display("x1  = %d", uut.registers.regs[1]);
        $display("x2  = %d", uut.registers.regs[2]);
        $display("x3  = %d", uut.registers.regs[3]);
        $display("x4  = %d", uut.registers.regs[4]);
        $display("x5  = %d", uut.registers.regs[5]);
        $display("x6  = %d", uut.registers.regs[6]);
        $display("x7  = %d", uut.registers.regs[7]);
        $display("x8  = %d", uut.registers.regs[8]);
        $display("x10 = %d", uut.registers.regs[10]);
        $display("x11 = %d", uut.registers.regs[11]);

        $display("\n====================================");
        $display("DATA MEMORY");
        $display("====================================");

        $display("mem[0] = %d", uut.data_memory.datamemorys[0]);

        $display("\n====================================");
        $display("FINAL PC");
        $display("====================================");

        $display("PC = %d", uut.pc_out);

        $finish;

    end

endmodule