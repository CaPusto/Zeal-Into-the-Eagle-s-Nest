cmake_minimum_required(VERSION 3.16)

set(APP_NAME "eaglenest")
set(target_name "eaglenest")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/lib)

set(ZOS_TOOLCHAIN sdcc)
include($ENV{ZOS_PATH}/cmake/zos_init.cmake)

zos_use(zvb)
include($ENV{ZGDK_PATH}/cmake/zgdk_init.cmake)

project(${target_name} C ASM)

add_executable(${target_name}
    src/main.c
    src/render.c
    src/assets.c
)

target_include_directories(${target_name} PRIVATE src)

# Dependencies
find_package(ZVB_SDK REQUIRED CONFIG PATHS "$ENV{ZVB_SDK_PATH}/cmake" NO_DEFAULT_PATH)
find_package(ZGDK REQUIRED CONFIG PATHS "$ENV{ZGDK_PATH}/cmake" NO_DEFAULT_PATH)

target_link_libraries(${target_name} PUBLIC zgdk zvb_gfx)

# Generate .bin output
zos_add_outputs(${target_name})
