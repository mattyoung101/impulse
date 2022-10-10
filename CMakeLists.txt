# Build script for Impulse
# Although CMake is definitely _not_ designed for building Verilog (you will see copius amounts of hacks in here),
# it is a LOT easier to use for me than Make, and works really well!
# Matt Young, 2022
cmake_minimum_required(VERSION 3.18)
project(impulse)

# Tools
find_program(IVERILOG iverilog REQUIRED)
find_program(VVP vvp REQUIRED)

# Tool flags
set(IVERILOG_FLAGS "-g2005-sv" "-Wall")
set(VVP_FLAGS "-fst")

# Source files. Since these are globs, you will have to rerun CMake if you add new files.
file(GLOB_RECURSE RTL_SRC "rtl/*.sv") # regular RTL sources
file(GLOB_RECURSE TB_SRC "testbench/*.sv") # testbench sources

# Compile testbenches into VVPs using Icarus Verilog
add_custom_target(makevvps ALL) 
foreach(file ${TB_SRC})
    # transform input filename into the name of the VVP
    get_filename_component(fileName ${file} NAME_WE)
    set(vvpFile "${CMAKE_CURRENT_BINARY_DIR}/${fileName}.vvp")

    # register with makevvps that we want to have this vvp made
    add_custom_command(TARGET makevvps
        COMMAND ${IVERILOG} ${IVERILOG_FLAGS} -o ${vvpFile} ${RTL_SRC}
        BYPRODUCTS ${vvpFile}
        VERBATIM
    )

    # TODO append this VVP to the list of VVPs
endforeach()

# Run VVPs