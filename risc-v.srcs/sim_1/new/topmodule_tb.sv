`timescale 1ns / 1ps

module topmodule_tb;

    reg clk;
    reg rst;

    topmodule dut(
        .clk(clk),
        .rst(rst)
    );

    //----------------------------------------------------------
    // CLOCK
    //----------------------------------------------------------

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //----------------------------------------------------------
    // RESET
    //----------------------------------------------------------

    initial begin
        rst = 1;
        #25;
        rst = 0;
    end

    //----------------------------------------------------------
    // VCD
    //----------------------------------------------------------

    initial begin
        $dumpfile("branch_pred.vcd");
        $dumpvars(0, topmodule_tb);
    end

    //----------------------------------------------------------
    // STATISTICS
    //----------------------------------------------------------

    integer branches;
    integer correct_preds;
    integer wrong_preds;
    integer flushes;
    integer btb_hits;

    initial begin
        branches      = 0;
        correct_preds = 0;
        wrong_preds   = 0;
        flushes       = 0;
        btb_hits      = 0;
    end

    //----------------------------------------------------------
    // MAIN TRACE
    //----------------------------------------------------------

    initial begin

        $display("==============================================================================================================================================================================================");
        $display("TIME\tPC\tINSTR\t\tNEXTPC\tPREDPC\tCORRPC\tBPRED\tHIT\tTAKEN\tPREDTK\tFLUSH\tPCSEL\tALUOUT\tBTBOUT\tSTALL");
        $display("==============================================================================================================================================================================================");

        forever begin

            @(posedge clk);

            if(!rst) begin

                $display("%0t\t%h\t%h\t%h\t%h\t%h\t%b\t%b\t%b\t%b\t%b\t%b\t%h\t%h\t%b",

                    $time,

                    dut.pc_out,
                    dut.instr,

                    dut.f_pc,
                    dut.next_pc,
                    dut.pf_pc,

                    dut.branch_pred,
                    dut.hit,

                    dut.taken_branch,
                    dut.IdEx_pred_taken,

                    dut.flush,
                    dut.pcsel,

                    dut.alu_output,
                    dut.btb_out,

                    dut.stall
                );

            end
        end
    end

    //----------------------------------------------------------
    // BRANCH MONITOR
    //----------------------------------------------------------

    always @(posedge clk) begin

        if(!rst && dut.IdEx_branch) begin

            branches = branches + 1;

            if(dut.IdEx_pred_taken == dut.taken_branch) begin

                correct_preds = correct_preds + 1;

                $display("\n[BRANCH CORRECT]");
                $display("PC            = %h", dut.IdEx_pc_out);
                $display("pred_taken    = %b", dut.IdEx_pred_taken);
                $display("actual_taken  = %b", dut.taken_branch);
                $display("target        = %h", dut.alu_output);

            end
            else begin

                wrong_preds = wrong_preds + 1;

                $display("\n[MISPREDICT]");
                $display("PC            = %h", dut.IdEx_pc_out);
                $display("pred_taken    = %b", dut.IdEx_pred_taken);
                $display("actual_taken  = %b", dut.taken_branch);
                $display("pred_target   = %h", dut.btb_out);
                $display("actual_target = %h", dut.alu_output);
                $display("flush         = %b", dut.flush);

            end
        end
    end

    //----------------------------------------------------------
    // FLUSH MONITOR
    //----------------------------------------------------------

    always @(posedge clk) begin

        if(!rst && dut.flush) begin

            flushes = flushes + 1;

            $display("\n[PIPELINE FLUSH]");
            $display("time          = %0t", $time);
            $display("correct_pc    = %h", dut.pf_pc);
            $display("wrong_fetch   = %h", dut.next_pc);

        end
    end

    //----------------------------------------------------------
    // BTB HIT MONITOR
    //----------------------------------------------------------

    always @(posedge clk) begin

        if(!rst && dut.hit) begin

            btb_hits = btb_hits + 1;

            $display("\n[BTB HIT]");
            $display("fetch_pc      = %h", dut.pc_out);
            $display("btb_target    = %h", dut.btb_out);
            $display("branch_pred   = %b", dut.branch_pred);

        end
    end

    //----------------------------------------------------------
    // TIMEOUT + SUMMARY
    //----------------------------------------------------------

    initial begin

        #5000;

        $display("\n====================================================");
        $display("FINAL SUMMARY");
        $display("====================================================");

        $display("Total Branches      = %0d", branches);
        $display("Correct Predictions = %0d", correct_preds);
        $display("Wrong Predictions   = %0d", wrong_preds);
        $display("BTB Hits             = %0d", btb_hits);
        $display("Flushes              = %0d", flushes);

        if(branches > 0) begin
            $display("Prediction Accuracy = %f%%",
                (correct_preds * 100.0) / branches);
        end

        $display("\n====================================================");
        $display("FINAL REGISTER STATE");
        $display("====================================================");

        $display("x1  = %d", dut.registers.regs[1]);
        $display("x2  = %d", dut.registers.regs[2]);
        $display("x3  = %d", dut.registers.regs[3]);
        $display("x4  = %d", dut.registers.regs[4]);
        $display("x5  = %d", dut.registers.regs[5]);
        $display("x6  = %d", dut.registers.regs[6]);
        $display("x7  = %d", dut.registers.regs[7]);
        $display("x8  = %d", dut.registers.regs[8]);
        $display("x9  = %d", dut.registers.regs[9]);
        $display("x10 = %d", dut.registers.regs[10]);
        $display("x11 = %d", dut.registers.regs[11]);
        $display("x12 = %d", dut.registers.regs[12]);

        $display("\n====================================================");
        $display("BTB STATE");
        $display("====================================================");

        $display("valid[0] = %b", dut.branch_target_buffer.valid[0]);
        $display("valid[1] = %b", dut.branch_target_buffer.valid[1]);
        $display("valid[2] = %b", dut.branch_target_buffer.valid[2]);
        $display("valid[3] = %b", dut.branch_target_buffer.valid[3]);

        $display("\n====================================================");

        $finish;
    end

endmodule