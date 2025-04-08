`include "control.v"
`timescale 1 ns/1 ns

module control_tb();

  reg[5:0] opcode;

  wire  reg_dst;
  wire  alu_src;
  wire  mem_to_reg;
  wire  reg_write;
  wire  mem_read;
  wire  mem_write;
  wire  branch;
  wire  jump;
  wire  [1:0]alu_op;

  Control control(opcode,reg_dst, jump, branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write);
 
  initial begin
    $dumpfile("control.vcd");
    $dumpvars(0, control_tb);
    opcode = 6'b000000;
    #10
    opcode = 6'b100011;
    #10
    opcode = 6'b101011;
    #10
    opcode = 6'b000100;
    #10
    opcode = 6'b001000;
    #10
    opcode = 6'b000010;
    #10
    $finish;
  end

endmodule