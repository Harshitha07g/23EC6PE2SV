module digital_clock_tb;

logic clk;
logic rst;
logic [5:0] sec;
logic [3:0] min;

// Instantiate DUT
digital_clock dut (
    .clk(clk),
    .rst(rst),
    .sec(sec),
    .min(min)
);

//////////////////////////////////////
// Clock Generation
//////////////////////////////////////
always #5 clk = ~clk;

//////////////////////////////////////
// Functional Coverage
//////////////////////////////////////
covergroup clock_cg @(posedge clk);

    // Cover seconds
    coverpoint sec {
        bins sec_values[] = {[0:59]};
        bins wrap = (59 => 0);   // Transition bin
    }

    // Cover minutes
    coverpoint min {
        bins min_values[] = {[0:9]};
    }

    // Cross coverage
    cross sec, min;

endgroup

clock_cg cg;

//////////////////////////////////////
// Test Stimulus
//////////////////////////////////////
initial begin
    clk = 0;
    rst = 1;

    cg = new();

    #10 rst = 0;

    // Run long enough to see multiple wraps
    #2000;

    $display("Coverage = %0.2f %%", cg.get_coverage());
    $finish;
end

//////////////////////////////////////
// Dump File (Waveform)
//////////////////////////////////////
initial begin
    $dumpfile("digital_clock.vcd");   // dump file name
    $dumpvars(0, digital_clock_tb);   // dump all signals
end

//////////////////////////////////////
// Monitor
//////////////////////////////////////
initial begin
    $monitor("Time=%0t | Min=%0d | Sec=%0d", $time, min, sec);
end

endmodule
