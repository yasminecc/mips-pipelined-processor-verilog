`include "pipReg.v"
`timescale 1 ns/1 ns

module pipReg_tb();

reg clk;
reg [31:0] in;
wire [31:0] out;
PipReg #(.WIDTH(32)) pipReg (clk, in, out);


    always begin
      #5 clk <= !clk;
  end


    initial begin

        $dumpfile("pipReg.vcd");
        $dumpvars(0, pipReg_tb);

        clk = 0;
        in = 0;
  
        #10; 


        in = 32'hA5A5A5A5; // Test input 1
        #10;

        in = 32'h5A5A5A5A; // Test input 2
        #10;

        in = 32'hFFFFFFFF; // Test input 3
        #10;

        in = 32'h00000000; // Test input 4
        #10; 

        in = 32'h12345678; // Test input 5
        #10;

        #10;
        $finish;
    end

    

endmodule
