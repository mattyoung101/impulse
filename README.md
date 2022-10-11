# Impulse
Impulse is a retro-inspired FPGA music synthesiser with MIDI support, written in SystemVerilog.

Directory layout:
- concept: Python code to test the overall concept of the synth (oscillators, mixing, etc).
- rtl: SystemVerilog RTL code.
- synth/ecp5: Synthesis scripts and files for Lattice ECP5 using Yosys/Nextpnr.
- testbench: Scripts and SystemVerilog files to run the testbench

**Authors:**
- Matt Young
- Ethan Lo

## Simulation
### Setting up the simulation toolchain
- Install Icarus Verilog: `sudo apt install iverilog`
- Install GTKWave: `sudo apt install gtkwave`
- Install VSCode and the following additional components:
    - [Verilog extension](https://marketplace.visualstudio.com/items?itemName=eirikpre.systemverilog) by Eirik Prestegårdshus
    - Install svls, the SystemVerilog language server: download from [the GitHub repo](https://github.com/dalance/svls) and
    make sure the extracted binary is in VSCode's $PATH. I just moved it to /usr/local/bin.
    - Then, install the [svls-vscode](https://marketplace.visualstudio.com/items?itemName=dalance.svls-vscode) extension by dalance.
    - As you might be able to tell, this is all a bit of a hack, and not ideal. I'm looking in a better setup.
- Install a recent version of CMake. I recommend using the [CMake PPA](https://apt.kitware.com/)

### Running simulations
I use CMake as the build tool. It actually works surprisingly well with custom targets. Here's how you can run
the simulations:

1. `cmake -B build` to generate the build files
2. `cd build`
3. `make sim` to compile the SystemVerilog testbenches into VVP files with IVerilog, and execute these files with IVerilog's `vvp`

You can then look at the .vcd files in the build directory. They are in the FST file format, which is faster
and better than all the others according to my reading. They can be viewed in GTKWave.

If you add or remove any SystemVerilog, you will need to run CMake due to the use of globs. Otherwise, between
runs just type `make sim` in the build directory.

`make clean` will delete the VVP files. Currently VCD files are not deleted, but I'll do this in the future.

## Lattice ECP5 Synthesis
### Introduction
The main FPGA that the Impulse I can be synthesized for is the Lattice ECP5. Specifically, we will either
target the [OrangeCrab](https://groupgets.com/manufacturers/good-stuff-department/products/orangecrab) or
the [ULX3S](https://www.crowdsupply.com/radiona/ulx3s) (probably the latter because of its built-in audio
jack). Eventually, we will also target synthesis on our custom PCB, but that is for the future.

I use the Yosys suite, including nextpnr, as our synthesis tool. In the future, I may also look into
Verilog to Routing and compare these two tools' performance.

### Setting up the synthesis toolchain
TODO

### Performing synthesis
TODO

## Synthesizing for ASIC
Right now we do not have the financial resources to target ASIC production (both in terms of EDA tools and actually
getting on a shuttle), and it is unlikely that this design would be good enough to fab anyway.

That being said, if time and motivation permit, I will look into OpenLane and the Skywater open source PDK
to see if I can produce a design that could in theory be fabbed.

## Licence
Currently being decided. Either proprietary or MPL 2.0. We'll see.