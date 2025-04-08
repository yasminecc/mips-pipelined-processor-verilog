module Sigextend(inst, imm);

input wire [15:0]inst;
output wire [31:0] imm;

assign imm[31:16] = {16{inst[15]}};
assign imm[15:0] = inst;

endmodule