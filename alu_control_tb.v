`include "alu_control.v"
`timescale 1 ns/1 ns

module alu_control_tb();

  reg [1:0]alu_op;
  reg [5:0]func;

  wire[3:0] alu_control;


  Alu_control alucontrol(alu_op,func,alu_control);
 
  initial begin
    $dumpfile("alu_control.vcd");
    $dumpvars(0, alu_control_tb);
    alu_op = 0;
    #10
    alu_op = 1;
    #10
    alu_op = 2;
      #10
      func = 6'b100000;
      #10
      func = 6'b100010;
      #10
      func = 6'b100100;
      #10
      func = 6'b100101;
    #10
    alu_op = 3;
    #10
    $finish;
  end

endmodule