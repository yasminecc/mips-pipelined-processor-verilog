`include "pc.v"
`include "imem.v"
`include "alu.v"
`include "regfile.v"
`include "dmem.v"
`include "alu_control.v"
`include "control.v"
`include "mux.v"
`include "sigext.v"
`include "shiftleft2.v"
`include "adder.v"
`include "pipReg.v"

module Top(clk);

input wire clk;
wire [31:0]pc_in;
wire [31:0]pc_out;
wire [31:0]pc_next;
wire [31:0]inst;
wire [27:0]jump_address_no_pc;
wire [31:0]jump_address;


wire reg_dst;
wire jump;
wire branch;
wire mem_read;
wire mem_to_reg;
wire [1:0]alu_op;
wire mem_write;
wire alu_src; 
wire reg_write;

wire [4:0]write_reg;
wire [31:0]write_data;
wire [31:0]rs_value;
wire [31:0]rt_value;
wire [31:0]immediate; 


wire [3:0]alu_cont;
wire [31:0]alu_second_in;
wire zero;
wire [31:0]alu_result;
wire [31:0]offsett;
wire [31:0]br_alu_result;
wire  brach_select;
wire [31:0]branch_result;
wire [31:0] read_data;

//IFID wires
wire [31:0] IFID_inst_out, IFID_instnext_out;

//IDEX wires
wire [31:0] IDEX_instnext_out;
wire [31:0] IDEX_rs_val_out;
wire [31:0] IDEX_rt_val_out;
wire [31:0] IDEX_imm_out;
wire [4:0] IDEX_rt_addrs_out;
wire [4:0] IDEX_rd_addrs_out;
wire [4:0] IDEX_write_reg_out;
//IDEX control wires
wire IDEX_reg_dst_out;
wire IDEX_mem_read_out;
wire IDEX_mem_to_reg_out;
wire [1:0] IDEX_alu_op_out;
wire IDEX_mem_write_out;
wire IDEX_alu_src_out;
wire IDEX_reg_write_out;

//EXMEM wires
wire [31:0] EXMEM_add_result_out;
wire EXMEM_zero_out;
wire [31:0] EXMEM_alu_result_out;
wire [31:0] EXMEM_rt_value_out;
wire [4:0] EXMEM_write_reg_out;
//EXMEM control wires
wire EXMEM_mem_read_out;
wire EXMEM_mem_write_out;
wire EXMEM_reg_write_out;
wire EXMEM_mem_to_reg_out;

//MEMWB wires
wire [31:0] MEMWB_read_data_out;
wire [31:0] MEMWB_alu_result_out;
wire [4:0] MEMWB_write_reg_out;
//MEMWB control wires
wire MEMWB_mem_to_reg_out;
wire MEMWB_reg_write_out;



// IF/ID pipeline registers
PipReg #(32) IFID_inst(clk, inst, IFID_inst_out);
PipReg #(32) IFID_pc_next(clk, pc_next, IFID_instnext_out);


// ID/EX pipeline registers
PipReg #(32) IDEX_instnext(clk, IFID_instnext_out, IDEX_instnext_out);
PipReg #(32) IDEX_rs_value(clk, rs_value, IDEX_rs_val_out);
PipReg #(32) IDEX_rt_value(clk, rt_value, IDEX_rt_val_out);
PipReg #(32) IDEX_immediate(clk, immediate, IDEX_imm_out);
PipReg #(5) IDEX_rt_addrs(clk, IFID_inst_out[20:16], IDEX_rt_addrs_out);
PipReg #(5) IDEX_rd_addrs(clk, IFID_inst_out[15:11], IDEX_rd_addrs_out);
PipReg #(5) IDEX_write_reg(clk, write_reg, IDEX_write_reg_out);
//signals from control
PipReg #(1)  IDEX_reg_dst(clk, reg_dst, IDEX_reg_dst_out); 
PipReg #(1) IDEX_mem_read (clk, mem_read, IDEX_mem_read_out );
PipReg #(1)  IDEX_mem_to_reg(clk, mem_to_reg, IDEX_mem_to_reg_out);
PipReg #(2) IDEX_alu_op(clk, alu_op, IDEX_alu_op_out);
PipReg #(1) IDEX_mem_write (clk, mem_write, IDEX_mem_write_out);
PipReg #(1)  IDEX_alu_src(clk, alu_src, IDEX_alu_src_out);
PipReg #(1)  IDEX_reg_write(clk, reg_write, IDEX_reg_write_out);

// EX/MEM pipeline registers
PipReg #(32) EXMEM_add_result(clk, alu_result, EXMEM_add_result_out); 
PipReg #(1)  EXMEM_zero(clk, zero, EXMEM_zero_out); 
PipReg #(32) EXMEM_alu_result(clk, alu_result, EXMEM_alu_result_out); 
PipReg #(32) EXMEM_rt_value(clk, IDEX_rt_val_out, EXMEM_rt_value_out);
PipReg #(5) EXMEM_write_reg(clk, IDEX_write_reg_out, EXMEM_write_reg_out);
//signals from control
PipReg #(1) EXMEM_mem_read(clk, IDEX_mem_read_out, EXMEM_mem_read_out);
PipReg #(1) EXMEM_mem_write(clk, IDEX_mem_write_out, EXMEM_mem_write_out);
PipReg #(1) EXMEM_reg_write(clk, IDEX_reg_write_out, EXMEM_reg_write_out);
PipReg #(1) EXMEM_mem_to_reg(clk, IDEX_mem_to_reg_out, EXMEM_mem_to_reg_out);

// MEM/WB pipeline registers
PipReg #(32) MEMWB_read_data(clk, read_data, MEMWB_read_data_out);     
PipReg #(32) MEMWB_alu_result(clk, EXMEM_alu_result_out, MEMWB_alu_result_out); 
PipReg #(5)  MEMWB_write_reg(clk, EXMEM_write_reg_out, MEMWB_write_reg_out); 
//signals from control
PipReg #(1)  MEMWB_mem_to_reg(clk, EXMEM_mem_to_reg_out, MEMWB_mem_to_reg_out); 
PipReg #(1)  MEMWB_reg_write(clk, EXMEM_reg_write_out, MEMWB_reg_write_out);


// IF Stage
PC pc(clk, pc_in, pc_out); 
Adder pc_adder(pc_out, 4, pc_next);
Imem imem(pc_out, inst);

// ID Stage
Control control(IFID_instnext_out[31:26], reg_dst, jump, branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write);
Mux #(5) mux_write_reg(IDEX_rt_addrs_out, IDEX_rd_addrs_out, IDEX_reg_dst_out, IDEX_write_reg_out);
RegisterFile regfile(clk, IFID_inst_out[25:21], IFID_inst_out[20:16], MEMWB_write_reg_out, write_data, MEMWB_reg_write_out, rs_value, rt_value);
Sigextend signedextend(IFID_inst_out[15:0], immediate);

// EX Stage
Mux mux_alu_select(IDEX_rt_val_out, IDEX_imm_out, IDEX_alu_src_out, alu_second_in);
Alu_control alu_control(IDEX_alu_op_out, IDEX_imm_out[5:0], alu_cont);
Alu alu(alu_cont, IDEX_rs_val_out, alu_second_in, alu_result, zero);

// MEM Stage
Dmem data_mem(clk, EXMEM_alu_result_out, EXMEM_rt_value_out, EXMEM_mem_read_out, EXMEM_mem_write_out, read_data);

// WB Stage
Mux mux_dmem(MEMWB_alu_result_out, MEMWB_read_data_out, MEMWB_mem_to_reg_out, write_data);


Shiftleft2 #(26,28) shift_jump(inst[25:0],jump_address_no_pc); 
assign jump_address = {pc_next[31:28],jump_address_no_pc};
Shiftleft2 shift_branch(immediate,offsett); 
Adder adder_branch(pc_next,offsett,br_alu_result);
assign branch_select = branch & zero; 
Mux mux_branch(pc_next,br_alu_result,branch_select,branch_result);
Mux mux_jump_or_branch(branch_result,jump_address,jump,pc_in); 


endmodule

//////////////////////////////////////////////////
//given
// PC pc(clk, pc_in, pc_out); 
// Adder pc_adder(pc_out, 4, pc_next);
// Imem imem(pc_out,inst);
// Shiftleft2 #(26,28) shift_jump(inst[25:0],jump_address_no_pc); 
// assign jump_address = {pc_next[31:28],jump_address_no_pc};
// Control control(IFID_instnext_out[31:26],reg_dst, jump, branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write);
// Mux #(5) mux_write_reg(inst[20:16],inst[15:11],reg_dst, write_reg);
// RegisterFile regfile(clk, inst[25:21], inst[20:16], write_reg, write_data, reg_write, rs_value, rt_value);//yes?
// Sigextend signedextend(inst[15:0],immediate);
// Mux mux_alu_select(rt_value,immediate,alu_src,alu_second_in);
// Alu_control alu_control(alu_op, inst[5:0], alu_cont);
// Alu alu(alu_cont, rs_value, alu_second_in, alu_result, zero);

//  Shiftleft2 shift_branch(immediate,offsett); 
//  Adder adder_branch(pc_next,offsett,br_alu_result);
//  assign branch_select = branch & zero; 
//  Mux mux_branch(pc_next,br_alu_result,branch_select,branch_result);
//  Mux mux_jump_or_branch(branch_result,jump_address,jump,pc_in); 

// Dmem data_mem(clk, alu_result,rt_value, mem_read, mem_write, read_data);
// Mux mux_dmem(alu_result,read_data,mem_to_reg,write_data);

