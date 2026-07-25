# VLSI Design of FIR Filter for DSP Applications using FPGA

> **A Verilog-based 16-Tap Low-Pass FIR Filter Implemented on FPGA using MATLAB-Generated Coefficients**

---

## Overview

This project presents the **design, simulation, synthesis, and FPGA implementation** of a **16-Tap Finite Impulse Response (FIR) Low-Pass Filter** using **Verilog HDL**. The filter coefficients are generated in **MATLAB** using a **Hamming window**, quantized into **Q1.15 fixed-point format**, and exported for direct integration into the Verilog design. The implementation targets an FPGA and demonstrates a complete RTL design flow, including simulation, synthesis, timing analysis, and hardware verification.

The project bridges **Digital Signal Processing (DSP)** concepts with **Digital VLSI Design**, showcasing how signal processing algorithms are efficiently implemented in programmable hardware.

The MATLAB script automatically generates all the files required for FPGA simulation, including Verilog coefficient headers and memory initialization files for test stimuli. 

---

# Project Objectives

* Design a digital low-pass FIR filter.
* Generate filter coefficients using MATLAB.
* Quantize floating-point coefficients into fixed-point representation.
* Implement the FIR filter architecture in Verilog HDL.
* Simulate the design using a Verilog testbench.
* Synthesize and implement the design on an FPGA.
* Analyze hardware resource utilization, timing performance, and power consumption.
* Verify the output using FPGA hardware.

---

# Features

* 16-Tap Low-Pass FIR Filter
* MATLAB-based coefficient generation
* Q1.15 Fixed-Point Arithmetic
* Verilog RTL Design
* FPGA Implementation
* Testbench Verification
* Memory-based Input Stimulus
* Synthesizable RTL
* Hardware Friendly Architecture
* Modular Design

---

# Project Architecture

```
                    MATLAB

          Filter Specification
                   │
                   ▼
      Generate FIR Coefficients
                   │
                   ▼
      Quantize to Q1.15 Format
                   │
                   ▼
      Export Verilog Header (.vh)
                   │
                   ▼
             Verilog RTL
                   │
                   ▼
        FIR Filter Architecture
                   │
       ┌───────────┴───────────┐
       │                       │
 Input Samples          Filter Coefficients
       │                       │
       ▼                       ▼
   Shift Registers      Constant Multipliers
            │
            ▼
        Adder Tree
            │
            ▼
       Filter Output
            │
            ▼
       FPGA Hardware
```

---

# FIR Filter Working

The FIR filter computes each output sample as the weighted sum of the current input sample and a finite number of previous samples.

Mathematically,

[
y[n]=\sum_{k=0}^{N-1} h[k]\times x[n-k]
]

Where:

* **x[n]** → Current input sample
* **h[k]** → Filter coefficients
* **y[n]** → Filter output
* **N** → Number of taps (16)

Every new input sample is shifted into a delay line. Each delayed sample is multiplied by its corresponding coefficient, and all products are summed to produce the output.

---

# MATLAB Design

The filter is designed using MATLAB with the following specifications:

| Parameter          | Value             |
| ------------------ | ----------------- |
| Filter Type        | FIR Low-Pass      |
| Number of Taps     | 16                |
| Window             | Hamming           |
| Sampling Frequency | 48 kHz            |
| Cutoff Frequency   | 4 kHz             |
| Data Format        | Q1.15 Fixed Point |

The MATLAB script designs the filter, quantizes the coefficients to 16-bit signed fixed-point, generates a 1 kHz test tone, and exports the required files for Vivado simulation.  

---

# FPGA Design Flow

```
MATLAB
      │
      ▼
Generate Coefficients
      │
      ▼
Write Verilog RTL
      │
      ▼
RTL Simulation
      │
      ▼
Functional Verification
      │
      ▼
Synthesis
      │
      ▼
Implementation
      │
      ▼
Bitstream Generation
      │
      ▼
Program FPGA
      │
      ▼
Hardware Verification
```

---

---

# Tools Used

## Software

* MATLAB
* Xilinx Vivado Design Suite
* Vivado Simulator
* Verilog HDL

## Hardware

* Xilinx FPGA Development Board
* USB Programmer
* PC/Laptop

---

# Input and Output

### Input

* Digital input samples
* Memory initialized test vectors
* 1 kHz sine wave generated in MATLAB

### Output

* Filtered digital samples
* Waveform verification
* FPGA hardware output

---

# Simulation

The testbench performs the following:

* Reads input samples
* Applies data sequentially
* Computes FIR output
* Generates waveforms
* Compares filtered response

---

# FPGA Implementation Steps

## Step 1

Create a new Vivado Project.

---

## Step 2

Add

* Verilog source files
* Testbench
* Constraint file

---

## Step 3

Run RTL Simulation.

---

## Step 4

Verify

* Input waveform
* Output waveform
* Delay behavior
* Filter response

---

## Step 5

Run Synthesis.

Observe

* RTL schematic
* Resource utilization
* Critical path

---

## Step 6

Run Implementation.

Check

* Timing Summary
* Setup/Hold Timing
* Maximum Frequency

---

## Step 7

Generate Bitstream.

---

## Step 8

Program the FPGA.

---

# Hardware Resources

Typical FPGA resources include:

* LUTs
* Flip-Flops
* DSP Slices
* Clock Buffers
* I/O Pins

---


# Results

The project successfully demonstrates the implementation of a **16-Tap Low-Pass FIR Filter** on an FPGA using **Verilog HDL**. MATLAB was used to generate and quantize the filter coefficients, which were integrated into the hardware design. Functional simulation verified correct filtering behavior, and FPGA synthesis confirmed that the design is suitable for real-time DSP applications with efficient hardware resource utilization.

---

# Conclusion

This project provides a complete end-to-end implementation of a digital FIR filter, starting from algorithm design in MATLAB and ending with deployment on FPGA hardware. It highlights the practical application of DSP concepts in VLSI design and serves as an excellent learning platform for FPGA-based digital signal processing. By combining MATLAB, Verilog HDL, and FPGA tools, the project demonstrates how efficient, real-time digital filters can be designed and implemented for modern embedded and communication systems.
