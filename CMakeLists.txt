# This file is part of Impulse, the retro music FPGA synthesizer.
# Copyright (c) 2022 Matt Young. All rights reserved.

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0

# Build script for Impulse
# Although CMake is definitely _not_ designed for building Verilog (you will see copius amounts of custom targets in here),
# it is hugely easier to use for me than plain old Make, and actually works surprinsingly well.
cmake_minimum_required(VERSION 3.18)
project(impulse)

# Tools
find_program(IVERILOG iverilog REQUIRED)
find_program(VVP vvp REQUIRED)
find_program(YOSYS yosys REQUIRED)
find_package(verilator REQUIRED)
# probably add nextpnr here as well

message(STATUS "Icarus Verilog: ${IVERILOG}")
message(STATUS "VVP: ${VVP}")
message(STATUS "Yosys: ${YOSYS}")
message(STATUS "Verilator: root ${VERILATOR_ROOT}, bin ${VERILATOR_BIN}")

# Tool flags
# -g2012 means we support SystemVerilog 2012 (see `man iverilog`)
set(IVERILOG_FLAGS "-g2012" "-Wall")
# -fst is the best format for vvp (see `man vvp`)
set(VVP_FLAGS "-fst")
set (VERILATOR_FLAGS "-Wall")

# Source files. Since these are globs, you will have to rerun CMake if you add new files.
file(GLOB_RECURSE RTL_SRC "rtl/*.sv") # regular RTL sources
file(GLOB_RECURSE TB_SRC "testbench/*.sv") # testbench sources
message(STATUS "List of all RTL sources: ${RTL_SRC}")
message(STATUS "List of all testbench sources: ${TB_SRC}")

########## ICARUS VERILOG ##########

# list of VVP files we created in "ivl_compile", for execution
set(vvpFiles "")
# Compile testbenches into VVPs using Icarus Verilog
add_custom_target(ivl_compile DEPENDS ${RTL_SRC} ${TB_SRC}) 
# for each testbench source...
foreach(file ${TB_SRC})
    # transform input filename into the name of the vvp we want
    # note: get_filename_component should be replaced with cmake_path (requires >3.20)
    get_filename_component(fileName ${file} NAME_WE) 
    set(vvpFile "${CMAKE_CURRENT_BINARY_DIR}/${fileName}.vvp")
    message(STATUS "[ivl_compile] Will compile vvp: ${vvpFile} from source: ${file}")

    # register with ivl_compile that we want to have this vvp made with iverilog
    add_custom_command(TARGET ivl_compile
        # invoke iverilog correctly: iverilog <flags> -o <vvpFile> <inputFile> <modules...>
        COMMAND ${IVERILOG} ${IVERILOG_FLAGS} -o ${vvpFile} ${file} ${RTL_SRC}
        BYPRODUCTS ${vvpFile}
        COMMENT "Building VVP file ${vvpFile}, flags: ${IVERILOG_FLAGS}"
        VERBATIM
    )
    
    # append this VVP file to the list of VVPs to run
    list(APPEND vvpFiles ${vvpFile})
endforeach()

message(STATUS "List of all VVP files: ${vvpFiles}")

# Run VVPs in Icarus Verilog (i.e. perform simulation)
add_custom_target(ivl_sim ALL DEPENDS ivl_compile)
foreach(file ${vvpFiles})
    message(STATUS "[ivl_sim] Will run vvp: ${file}")

    # register with ivl_sim that we want to run this vvp file
    add_custom_command(TARGET ivl_sim
        COMMAND ${VVP} ${file} ${VVP_FLAGS}
        COMMENT "Running vvp file ${file}, flags: ${VVP_FLAGS}"
        VERBATIM
        # TODO make ALL VCD files a byproduct of ivl_sim
    )
endforeach()

########## VERILATOR ##########

# Verilator
# TODO build and run for verilator

########## YOSYS / NEXTPNR ##########

# Synthesise using Yosys for ECP5. The script used is scripts/ecp5.ys (that way we can update synth commands
# without rebuilding CMake)
add_custom_target(yosys_ecp5)
add_custom_command(TARGET yosys_ecp5
    COMMAND ${YOSYS} scripts/ecp5.ys
    COMMENT "Synthesising for Lattice ECP5 to ecp5.json in ${CMAKE_BINARY_DIR}"
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    VERBATIM
)

# Synthesise using Yosys for the CXXRTL simulator. Uses scripts/cxxrtl.ys as the script.
add_custom_target(yosys_cxxrtl)
add_custom_command(TARGET yosys_cxxrtl
    COMMAND ${YOSYS} scripts/cxxrtl.ys
    COMMENT "Synthesising for CXXRTL simulator to impulse_cxxrtl.cpp in ${CMAKE_BINARY_DIR}"
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    VERBATIM
)

# TODO add nextpnr_ecp5 target, and also a "flash_ecp5" target that does yosys -> nextpnr -> upload to devkit