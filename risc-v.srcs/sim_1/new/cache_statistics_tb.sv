`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2026 04:59:50 PM
// Design Name: 
// Module Name: cache_statistics_tb
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


`timescale 1ns/1ps

module cache_statistics_tb;

reg clk;
reg rst;

wire [31:0] rout;

topmodule dut(
    .clk(clk),
    .rst(rst),
    .rout(rout)
);

always #5 clk = ~clk;

integer cycles;

// Instruction cache
integer ic_access;
integer ic_hit;
integer ic_miss;

// Data cache
integer dc_access;
integer dc_hit;
integer dc_miss;

integer load_count;
integer store_count;

real ic_hit_rate;
real dc_hit_rate;

initial begin

    clk = 0;
    rst = 1;

    cycles    = 0;

    ic_access = 0;
    ic_hit    = 0;
    ic_miss   = 0;

    dc_access = 0;
    dc_hit    = 0;
    dc_miss   = 0;

    load_count  = 0;
    store_count = 0;

    #20;
    rst = 0;

    //------------------------------------------------
    // Run long enough to execute complete program
    //------------------------------------------------

    #15000;

    ic_hit_rate = (100.0*ic_hit)/ic_access;
    dc_hit_rate = (100.0*dc_hit)/dc_access;

    $display("\n=================================================");
    $display("CACHE STATISTICS");
    $display("=================================================\n");

    $display("Total Cycles              : %0d",cycles);

    $display("\nInstruction Cache");
    $display("-----------------------------");
    $display("Accesses                  : %0d",ic_access);
    $display("Hits                      : %0d",ic_hit);
    $display("Misses                    : %0d",ic_miss);
    $display("Hit Rate                  : %0f %%",ic_hit_rate);

    $display("\nData Cache");
    $display("-----------------------------");
    $display("Accesses                  : %0d",dc_access);
    $display("Loads                     : %0d",load_count);
    $display("Stores                    : %0d",store_count);
    $display("Hits                      : %0d",dc_hit);
    $display("Misses                    : %0d",dc_miss);
    $display("Hit Rate                  : %0f %%",dc_hit_rate);

    $display("\n=================================================");

    $finish;

end

always @(posedge clk) begin

    if(!rst) begin

        cycles = cycles + 1;

        //-----------------------------
        // Instruction Cache
        //-----------------------------

        ic_access = ic_access + 1;

        if(dut.icache_hit)
            ic_hit = ic_hit + 1;
        else
            ic_miss = ic_miss + 1;

        //-----------------------------
        // Data Cache
        //-----------------------------

        if(dut.ExMa_memread || dut.ExMa_memrw) begin

            dc_access = dc_access + 1;

            if(dut.ExMa_memread)
                load_count = load_count + 1;

            if(dut.ExMa_memrw)
                store_count = store_count + 1;

            if(dut.dcache_hit)
                dc_hit = dc_hit + 1;
            else
                dc_miss = dc_miss + 1;

        end

    end

end

endmodule
