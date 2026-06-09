`timescale 1ns/1ps

module topmodule_tb;

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
integer flushes;
integer branches;
integer mispredictions;

initial begin

    clk = 0;
    rst = 1;

    cycles = 0;
    flushes = 0;
    branches = 0;
    mispredictions = 0;

    #20;
    rst = 0;

    // run long enough
    #30000;

    $display("\n====================================================");
    $display("REGISTER DUMP");
    $display("====================================================");

    for(integer i=0;i<32;i=i+1)
        $display("x%0d = %h", i, dut.registers.regs[i]);

    $display("\n====================================================");
    $display("PIPELINE STATS");
    $display("====================================================");

    $display("Cycles         = %0d", cycles);
    $display("Branches       = %0d", branches);
    $display("Flushes        = %0d", flushes);
    $display("Mispredictions = %0d", mispredictions);

    if(branches != 0)
        $display("Accuracy       = %f%%",
            (100.0*(branches-mispredictions))/branches);

    $display("\n====================================================");
    $display("BPB CONTENTS");
    $display("====================================================");

    for(integer i=0;i<16;i=i+1)
        $display(
            "BPB[%0d] = %b",
            i,
            dut.branch_predictor.bpb_table[i]
        );

    $display("\n====================================================");
    $display("CACHE CONTENTS");
    $display("====================================================");

    for(integer i=0;i<8;i=i+1)
        $display(
        "LINE=%0d VALID=%b DIRTY=%b TAG=%h DATA=%h",
        i,
        dut.data_memory.data_cache.valid[i],
        dut.data_memory.data_cache.dirty[i],
        dut.data_memory.data_cache.cache_tag[i],
        dut.data_memory.data_cache.dmem_cache[i]
        );

    $display("\n====================================================");
    $display("END OF TEST");
    $display("====================================================");

    $finish;
end

always @(posedge clk) begin

    if(!rst) begin

        cycles = cycles + 1;

        if(dut.flush)
            flushes = flushes + 1;

        if(dut.ExMa_branch) begin

            branches = branches + 1;

            if(dut.ExMa_pred_taken != dut.ExMa_taken_branch)
                mispredictions = mispredictions + 1;
        end

        //--------------------------------------------------
        // Trace branches only
        //--------------------------------------------------

        if(dut.ExMa_branch || dut.ExMa_jump) begin

            $display(
            "[%0t] PC=%h branch=%b jump=%b taken=%b pred=%b flush=%b",
            $time,
            dut.ExMa_pc_out,
            dut.ExMa_branch,
            dut.ExMa_jump,
            dut.ExMa_taken_branch,
            dut.ExMa_pred_taken,
            dut.flush
            );

        end
    end
end

endmodule