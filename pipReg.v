module PipReg #(parameter WIDTH = 32) (
    input wire clk,
    input wire [WIDTH-1:0] in,
    output wire [WIDTH-1:0] out
);


reg [WIDTH-1:0] register = 0;

always @(posedge clk) begin
    register <= in;  // Assign the input to the output on the rising edge of the clock
end

assign out = register;

endmodule