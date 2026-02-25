module tb;

  Packet p;

  // 🔥 Real signals for waveform
  int len_signal;
  byte payload_signal [0:7];

  integer i, j;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);

    p = new();

    // Force all values 4 to 8 for 100% coverage
    for (i = 4; i <= 8; i++) begin

      if (!p.randomize() with { len == i; }) begin
        $display("Randomization failed");
        $finish;
      end

      // 🔥 Mirror class values into module signals
      len_signal = p.len;

      for (j = 0; j < p.len; j++)
        payload_signal[j] = p.payload[j];

      #5;
    end

    $display("Coverage = %0.2f%%", p.cg.get_coverage());
    #10;
    $finish;
  end

endmodule
