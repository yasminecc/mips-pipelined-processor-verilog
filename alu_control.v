module Alu_control(alu_op,func,alu_control);
input wire [1:0]alu_op;
input wire [5:0]func;

output reg [3:0] alu_control;

//comb block
always @* begin
  case (alu_op)
    0: begin
      alu_control <= 0;
    end
    1: begin
      alu_control <= 1;
    end
    2: begin
      case (func) 
        6'b100000: alu_control <= 0;//add
        6'b100010: alu_control <= 1;//sub
        6'b100100: alu_control <= 4;//and
        6'b100101: alu_control <= 5;//or
        default:  alu_control <= 0;
      endcase 
    end
    3: begin
      alu_control <= 0;
    end
  endcase 
end

endmodule