# Pipelined MIPS Processor – Verilog Implementation

This project implements a 5-stage pipelined MIPS processor using Verilog HDL, including separate pipeline registers between each stage. The design modularizes core datapath components and control logic, supporting instruction fetch, decode, execute, memory access, and writeback.

Each module has been tested individually with dedicated testbenches, and full integration is verified using `top_tb.v`.

---

## 🔧 Features

- **5-stage pipeline:** IF, ID, EX, MEM, WB
- Modular Verilog design with clear separation of:
  - ALU
  - Control and ALU Control Units
  - Register File
  - Instruction & Data Memory
  - Immediate Extend and Shift Left
  - Pipeline Registers (e.g., IF/ID, ID/EX, EX/MEM, MEM/WB)
- Sample program executed and tested in simulation
- Easily extendable for hazard detection and forwarding

---

## 📁 Key Files

| File               | Description                                          |
|--------------------|------------------------------------------------------|
| `top.v`            | Top-level module integrating all pipeline stages     |
| `top_tb.v`         | Full simulation testbench                            |
| `alu.v`, `adder.v` | Arithmetic units                                     |
| `control.v`, `alu_control.v` | Generate control signals for datapath    |
| `pc.v`, `mux.v`, `shiftleft2.v`, `sigext.v` | Supporting logic             |
| `regfile.v`        | Dual-read, single-write register file                |
| `imem.v`, `dmem.v` | Instruction and data memory                          |
| `pipReg.v`         | Generic pipeline register module                     |
| `*_tb.v`           | Testbenches for module-level validation              |

---

## ▶️ How to Simulate

1. Open ModelSim or your Verilog simulator.
2. Compile and run the full processor:

```sh
vlog top.v top_tb.v
vsim work.top_tb
run -all
```

3. Use waveform viewer to inspect register/memory updates and pipeline flow.

---

## 📌 Notes

- Pipeline hazard detection is not implemented in this version.
- `top_tb.v` includes simple stimuli that execute a MIPS instruction sequence.

---

## 👩‍💻 Author

**Yasmine Elsisi**  
Computer Engineering @ NYU Abu Dhabi  
[GitHub](https://github.com/YasmineElsisi)
