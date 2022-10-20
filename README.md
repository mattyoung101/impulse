# Impulse
Impulse is a retro-inspired FPGA music synthesiser with MIDI support, written in SystemVerilog. Think of it as
the NES, SNES and Sega Genesis all combined together in one super awesome package.

Impulse is simulated, synthesized and iterated on using entirely open source tools: Icarus Verilog, Yosys, Nextpnr
GTKWave and VSCode.

**Directory layout:**
- build: Not included in Git, but this should be generated by CMake. It will contain the testbench compiled code, waveforms
and Yosys synthesis output.
- concept: Python code to test the overall concept of the synth (oscillators, mixing, etc).
- docs: Contains documentation about the chip architecture.
- rtl: SystemVerilog RTL code. The main source of Impulse.
- scripts: Scripts for synthesis and simulation.
- testbench: Scripts and SystemVerilog files that define testbenches for each module

**Authors:**
- Matt Young (m.young2@uqconnect.edu.au)
- Ethan Lo

## Installing tools
This project relies on many open source tools for simulation and synthesis, a lot of which you will need to
compile from source.

In the future this environment will be built as some type of Docker container along with the Yosys suite,
for easy setup, but I haven't gotten around to that yet.

These notes assume you are running an Ubuntu derivative, because I run Linux Mint. However, instructions should
be relatively portable across Linuxes. YMMV on Mac or Windows.

### Setting up the simulation toolchain
- Install Icarus Verilog. In order to support SystemVerilog properly, you must compile Icarus from source code (the version
Ubuntu ships is too old to support `always_ff`, for example).
    - Clone the [Icarus Verilog repo](https://github.com/steveicarus/iverilog) and enter it
    - Install dependencies: `sudo apt install bison flex gperf libreadline-dev libreadline8` and any non-prehistoric C++ compiler
    - `sh autoconf.sh`
    - _(Fish shell only, if you want Clang)_ `set -x CC clang-12; set -x CXX clang++-12`
    - `./configure`
    - `make -j32`
    - `sudo make install`
    - Further instructions can be found in the Icarus Verilog README or the [Installation Guide](https://iverilog.fandom.com/wiki/Installation_Guide#Installation_From_Source) on the Icarus Verilog wiki. The notes above come from my reading of these two resources.
- Install GTKWave: `sudo apt install gtkwave`
- Install VSCode and the following additional components:
    - [Verilog extension](https://marketplace.visualstudio.com/items?itemName=eirikpre.systemverilog) by Eirik Prestegårdshus
    - Install svls, the SystemVerilog language server: download from [the GitHub repo](https://github.com/dalance/svls) and
    make sure the extracted binary is in VSCode's $PATH. I just moved it to /usr/local/bin.
    - Then, install the [svls-vscode](https://marketplace.visualstudio.com/items?itemName=dalance.svls-vscode) extension by dalance.
    - As you might be able to tell, this is all a bit of a hack, and not ideal (especially the fact that _two_ extensions are
    required). I'm looking into whether or not I can create a better extension of my own design using Verible.
- Install a recent version of CMake. I recommend using the [CMake PPA](https://apt.kitware.com/)

### Setting up the synthesis toolchain
- Install Yosys. You will need to compile from source. Clone the [Yosys repo](https://github.com/YosysHQ/yosys)
and follow the instructions in the README (under the "Building from Source" section).
    - It's also possible to use [oss-cad-suite-build](https://github.com/YosysHQ/oss-cad-suite-build), especially for
    Yosys. However I am having problems starting Nextpnr using this on Linux Mint, and they are refusing to answer
    my GitHub issue pointing this out, so I don't recommend it.
- Install Nextpnr
    - TODO

## Simulation
### Introduction
The current simulation tool used is the bleeding-edge version of Icarus Verilog. This is an event driven simulator
that mostly supports SystemVerilog, so is good for our use-case. Another simulator, Verilator, was also looked at -
and might be used in future - but Icarus is easier to understand for me, for now.

Icarus Verilog (`iverilog`) works by transforming Verilog sources and testbenches into .vvp files, which is essentially
bytecode for another program, `vvp`, which then performs the simulation. Both of these stages are handled automatically
by the CMake script.

### Running simulations
I use CMake as the build tool. It actually works surprisingly well for this, using custom targets. Here's how you can run
the simulations:

1. `cmake -B build` to generate the build files
2. `cd build`
3. `make sim` to compile the SystemVerilog testbenches into VVP files with IVerilog, and execute these files with IVerilog's `vvp`

You can then look at the .vcd files in the build directory. They are in the FST file format, which is faster
and better than all the others according to my reading. They can be viewed in GTKWave.

If you add or remove any SystemVerilog, you will need to run CMake due to the use of globs. Otherwise, between
runs just type `make sim` in the build directory.

`make clean` will delete the VVP files. Currently VCD files are not deleted, but I'll do this in the future.

_Note: In the near future I'd also like to support using Verilator as an additional simulator, and make a cycle-accurate
VST of the synth. In the mean time, I'll be sticking with Icarus though._

_Note 2: I'd also like to support vunit or cocotb for verification._

## Synthesis
### Introduction
The main FPGA that the Impulse aims to be synthesized for is the Lattice ECP5. Specifically, we will either
target the [OrangeCrab](https://groupgets.com/manufacturers/good-stuff-department/products/orangecrab) or
the [ULX3S](https://www.crowdsupply.com/radiona/ulx3s) (probably the latter because of its built-in audio
jack). Eventually, we will also target synthesis on our custom PCB, but that is for the future.

As stated previously I'm currently using Yosys/Nextpnr. In the future, I may also look into
Verilog to Routing and compare these two tools' performance.

### Synthesizing for the Lattice ECP5
TODO

### Synthesizing for ASIC
Right now we do not have the financial resources to target ASIC production (both in terms of EDA tools and actually
getting on a shuttle), and it is unlikely that this design would be good enough to fab anyway.

That being said, if time and motivation permit, I will look into OpenLane and the Skywater open source PDK
to see if I can produce a design that could in theory be fabbed, just for fun :P

## Licence
Mozilla Public License 2.0