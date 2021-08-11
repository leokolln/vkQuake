cmake_minimum_required(VERSION 3.16)
project(vkQuake C)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

add_subdirectory(Shaders)
add_subdirectory(Quake)
