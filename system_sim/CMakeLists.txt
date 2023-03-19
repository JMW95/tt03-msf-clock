cmake_minimum_required(VERSION 3.16)

project(system_sim LANGUAGES CXX)

set(CMAKE_EXPORT_COMPILE_COMMANDS on)

find_package(verilator REQUIRED HINTS $ENV{VERILATOR_ROOT})

add_executable(system_sim
    src/main.cpp
    src/asic.cpp
    src/display.cpp
)

verilate(system_sim
    SOURCES ../src/jmw95_top.v
    INCLUDE_DIRS ../src
    TRACE
)
