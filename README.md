# Impulse
Impulse is a retro-inspired FPGA music synthesiser with MIDI support, written in SystemVerilog.

This repository houses the first iteration of the Impulse synthesiser, the Impulse I.

Directory layout:
- concept: Python code to test the overall concept of the synth (oscillators, mixing, etc).
- rtl: SystemVerilog RTL code.
- synth/ecp5: Synthesis scripts and files for Lattice ECP5 using Yosys/Nextpnr.
- testbench: Scripts and SystemVerilog files to run the testbench

**Authors:**
- Matt Young
- Ethan Lo

## Running simulations
The simulation tool currently used is Icarus Verilog. If that proves to be too slow, I might move to
Verilator.

TODO

## Synthesizing for the Lattice ECP5
The main FPGA that the Impulse I can be synthesized for is the Lattice ECP5. Specifically, we will either
target the [OrangeCrab](https://groupgets.com/manufacturers/good-stuff-department/products/orangecrab) or
the [ULX3S](https://www.crowdsupply.com/radiona/ulx3s) (probably the latter because of its built-in audio
jack). Eventually, we will also target synthesis on our custom PCB, but that is for the future.

We use the Yosys suite, including nextpnr, as our synthesis tool.

TODO

## Synthesizing for ASIC
One day, hopefully ;)

Right now we do not have the financial resources to target ASIC production, but certainly one day it would
be really fun to get it sent off to a TSMC or Skywater shuttle.

## Licence
To be decided