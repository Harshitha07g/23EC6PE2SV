module tb;

  EthPacket p;

  int length_signal;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);

    p = new();

    // Force coverage bins 46–50
    for (int i = 46; i <= 50; i++) begin

      if (!p.randomize() with { length == i; }) begin
        $display("Randomization failed");
        $finish;
      end

      length_signal = p.length;

      #5;
    end

    $display("Coverage = %0.2f%%", p.cg.get_coverage());
    #10;
    $finish;
  end

endmodule
