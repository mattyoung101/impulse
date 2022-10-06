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

## Simulation
### Configuring the development environment
- Install Icarus Verilog: `sudo apt install iverilog`
- Install VSCode and the [Verilog extension](https://marketplace.visualstudio.com/items?itemName=mshr-h.VerilogHDL) by mshr-h
    - Install Universal Ctags: `sudo apt install universal-ctags`
    - Install svls, the SystemVerilog language server: download from [the GitHub repo](https://github.com/dalance/svls) and
    make sure the extracted binary is in VSCode's $PATH. I just moved it to /usr/bin.
    - Configure the extension to use Ctags and svls
    - TODO instead of using this extension, use the other one - or figure out how to convince this one to let us use modules correctly
- TODO SCons/Waf?

### Running simulations
TODO

## Lattice ECP5 Synthesis
### Introduction
The main FPGA that the Impulse I can be synthesized for is the Lattice ECP5. Specifically, we will either
target the [OrangeCrab](https://groupgets.com/manufacturers/good-stuff-department/products/orangecrab) or
the [ULX3S](https://www.crowdsupply.com/radiona/ulx3s) (probably the latter because of its built-in audio
jack). Eventually, we will also target synthesis on our custom PCB, but that is for the future.

We use the Yosys suite, including nextpnr, as our synthesis tool.

### Configuring the synthesis toolchain

## Synthesizing for ASIC
One day, hopefully ;)

Right now we do not have the financial resources to target ASIC production, but certainly one day it would
be really fun to get it sent off to a TSMC or Skywater shuttle.

## Licence
To be decided