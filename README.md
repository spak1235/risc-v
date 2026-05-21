# 5-Stage Pipelined RV32I RISC-V Processor

A fully functional 32-bit 5-stage pipelined RISC-V CPU designed and implemented in Verilog HDL.  
The processor supports pipelined execution, hazard handling, memory operations, and control flow instructions following the RV32I ISA specification.

---

# Features

- 5-stage pipeline architecture
  - Instruction Fetch (IF)
  - Instruction Decode (ID)
  - Execute (EX)
  - Memory Access (MEM)
  - Write Back (WB)

- RV32I Instruction Support
  - Arithmetic Instructions
  - Logical Instructions
  - Immediate Instructions
  - Load/Store Instructions
  - Branch Instructions
  - Jump Instructions

- Hazard Handling
  - Data Forwarding
  - Load-Use Hazard Stalling
  - Branch and Jump Flushing
  - Store Data Forwarding

- Pipeline Components
  - IF/ID Register
  - ID/EX Register
  - EX/MEM Register
  - MEM/WB Register

- Additional Modules
  - Control Unit
  - ALU Decoder
  - Immediate Generator
  - Register File
  - Instruction Memory
  - Data Memory
  - Hazard Detection Unit
  - Forwarding Unit

---

# Pipeline Architecture

```text
IF -> ID -> EX -> MEM -> WB
```

The processor implements a classic pipelined datapath with hazard mitigation mechanisms to ensure correct execution under data and control dependencies.

---

# Hazard Handling

## Data Hazards
Resolved using:
- EX/MEM Forwarding
- MEM/WB Forwarding

## Load-Use Hazards
Resolved using:
- Stall Detection Unit
- PC Freeze
- IF/ID Freeze
- Bubble Injection into ID/EX

## Control Hazards
Resolved using:
- Pipeline Flushing on Branches and Jumps

---

# Supported Instructions

## Arithmetic Instructions
```assembly
add
sub
addi
```

## Logical Instructions
```assembly
and
or
xor
sll
srl
sra
slt
sltu
```

## Memory Instructions
```assembly
lw
sw
```

## Control Flow Instructions
```assembly
beq
jal
jalr
```

---

# Example Instructions

```assembly
addi x1, x0, 5
addi x2, x0, 10
add  x3, x1, x2
sub  x4, x2, x1
lw   x7, 0(x0)
sw   x5, 0(x0)
beq  x1, x2, label
jal  x0, target
```

---

# Future Improvements

- Branch Prediction
- Cache Integration
- Exception and Interrupt Handling
- FPGA Deployment
- UART Peripheral Integration
- Performance Optimization

---

# Project Status

Completed implementation of a fully hazard-aware 5-stage pipelined RV32I processor with forwarding, stalling, flushing, and memory support.
