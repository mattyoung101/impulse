# Build script for Impulse
# Although CMake is definitely _not_ designed for building Verilog (you will see copius amounts of custom targets in here),
# it is hugely easier to use for me than plain old Make, and actually works surprinsingly well!
# I'm pretty happy with this build script overall, and was surprised it didn't take me a week to write.
# Matt Young, 2022
cmake_minimum_required(VERSION 3.18)
project(impulse)

# Tools
find_program(IVERILOG iverilog REQUIRED)
find_program(VVP vvp REQUIRED)
find_program(YOSYS yosys REQUIRED)
# probably add nextpnr here as well

message(STATUS "Icarus Verilog: ${IVERILOG}")
message(STATUS "VVP: ${VVP}")
message(STATUS "Yosys: ${YOSYS}")

# Tool flags
# -g2012 means we support SystemVerilog 2012 (see `man iverilog`)
set(IVERILOG_FLAGS "-g2012" "-Wall")
# -fst is the best format for vvp (see `man vvp`)
set(VVP_FLAGS "-fst")

# Source files. Since these are globs, you will have to rerun CMake if you add new files.
file(GLOB_RECURSE RTL_SRC "rtl/*.sv") # regular RTL sources
file(GLOB_RECURSE TB_SRC "testbench/*.sv") # testbench sources

# list of VVP files we created, for execution
set(vvpFiles "")

# Compile testbenches into VVPs using Icarus Verilog
# TODO rename "makevvps" to "compile_sim"
add_custom_target(makevvps DEPENDS ${RTL_SRC} ${TB_SRC}) 
foreach(file ${TB_SRC})
    # transform input filename into the name of the vvp we want
    get_filename_component(fileName ${file} NAME_WE) # this should be replaced with cmake_path (required >3.20)
    set(vvpFile "${CMAKE_CURRENT_BINARY_DIR}/${fileName}.vvp")
    message(STATUS "[makevvps] Will compile vvp: ${vvpFile} from source: ${file}")

    # register with makevvps that we want to have this vvp made with iverilog
    add_custom_command(TARGET makevvps
        # invoke iverilog correctly: iverilog <flags> -o <vvpFile> <inputFile> <modules...>
        COMMAND ${IVERILOG} ${IVERILOG_FLAGS} -o ${vvpFile} ${file} ${RTL_SRC}
        BYPRODUCTS ${vvpFile}
        COMMENT "Building vvp file ${vvpFile}, flags: ${IVERILOG_FLAGS}"
        VERBATIM
    )
    
    # append this VVP file to the list of VVPs to run
    list(APPEND vvpFiles ${vvpFile})
endforeach()

message(STATUS "List of all VVP files: ${vvpFiles}")

# Run VVPs
add_custom_target(sim ALL DEPENDS makevvps)
foreach(file ${vvpFiles})
    message(STATUS "[sim] Will run vvp: ${file}")

    # register with sim that we want to run this vvp file
    add_custom_command(TARGET sim
        COMMAND ${VVP} ${file} ${VVP_FLAGS}
        COMMENT "Running vvp file ${file}, flags: ${VVP_FLAGS}"
        VERBATIM
        # TODO make ALL VCD files a byproduct of sim
    )
endforeach()

# Synthesise using Yosys for ECP5. The script used is scripts/ecp5.ys (that way we can update synth commands
# without rebuilding CMake)
add_custom_target(yosys_ecp5)
add_custom_command(TARGET yosys_ecp5
    COMMAND ${YOSYS} scripts/ecp5.ys
    COMMENT "Synthesising for Lattice ECP5 to ecp5.json in ${CMAKE_BINARY_DIR}"
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    VERBATIM
)