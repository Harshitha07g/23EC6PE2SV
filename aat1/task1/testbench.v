module tb;

// enum for operations
typedef enum {ADD, SUB, MUL, XOR} op_t;

// transaction class
class transaction;
  rand bit [7:0] a,b;
  rand op_t opcode;

  // ensure MUL happens at least 20%
  constraint mul_weight {
    opcode dist {ADD:=3, SUB:=3, MUL:=2, XOR:=2};
  }
endclass

// DUT signals
logic [7:0] a,b;
logic [1:0] opcode;
logic [7:0] y;

// instantiate DUT
alu dut(a,b,opcode,y);

// coverage
covergroup cg;
  coverpoint opcode;
endgroup

cg c = new();

transaction t;

initial begin
  $dumpfile("dump.vcd");
  $dumpvars(0, tb);
  t = new();

  repeat(20) begin
    t.randomize();

    a = t.a;
    b = t.b;
    opcode = t.opcode;

    #10;
    c.sample();

    $display("a=%0d b=%0d opcode=%0d result=%0d", a,b,opcode,y);
  end
  #5;
  $display("Coverage = %0.2f %%", c.get_inst_coverage());
  $finish;
end

endmodule
