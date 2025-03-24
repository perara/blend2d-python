cmake_minimum_required(VERSION 3.15)

project(blend2d_python C CXX)

# C++17 is required for nanobind
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Blend2D setup
set(BLEND2D_DIR "${CMAKE_CURRENT_LIST_DIR}/3rdparty/blend2d"
    CACHE PATH "Location of 'blend2d'")

set(BLEND2D_BUILD_STATIC TRUE)
include("${BLEND2D_DIR}/CMakeLists.txt")

if("${CMAKE_CXX_COMPILER_ID}" MATCHES "^(GNU|Clang|AppleClang)$")
  list(APPEND BLEND2D_CFLAGS "-fvisibility=hidden")
endif()

# Nanobind setup
# Use nanobind from 3rdparty directory
set(NANOBIND_DIR "${CMAKE_CURRENT_LIST_DIR}/3rdparty/nanobind" CACHE PATH "Location of 'nanobind'")
add_subdirectory(${NANOBIND_DIR})

# Find Python and NumPy (needed for array support)
find_package(Python REQUIRED COMPONENTS Interpreter Development.Module NumPy)

# Blend2D nanobind module
set(BLEND2DPY_TARGET_NAME "_capi" CACHE STRING "Name of the extension file")

# Process the src subdirectory which contains our nanobind source files
add_subdirectory(src)

# Install the module
install(TARGETS ${BLEND2DPY_TARGET_NAME} DESTINATION blend2d)
