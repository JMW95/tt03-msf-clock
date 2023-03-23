cmake_minimum_required(VERSION 3.16)

project(system_sim LANGUAGES CXX)

set(CMAKE_EXPORT_COMPILE_COMMANDS on)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED on)
set(CMAKE_CXX_EXTENSIONS off)

find_package(verilator REQUIRED HINTS $ENV{VERILATOR_ROOT})

add_executable(system_sim
    src/main.cpp
    src/asic.cpp
    src/clk_and_rst.cpp
    src/data_source.cpp
    src/display.cpp
    src/receiver.cpp
    src/system.cpp
)

verilate(system_sim
    SOURCES ../src/jmw95_top.v
    INCLUDE_DIRS ../src
    TRACE
)
