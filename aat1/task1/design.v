module alu(
  input  logic [7:0] a,b,
  input  logic [1:0] opcode,
  output logic [7:0] y
);

always_comb begin
  case(opcode)
    2'b00: y = a + b;   // ADD
    2'b01: y = a - b;   // SUB
    2'b10: y = a * b;   // MUL
    2'b11: y = a ^ b;   // XOR
  endcase
end

endmodule
