cmake_minimum_required(VERSION 2.6)

PROJECT(alpm-vala)

SET(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/CMakeFiles)

Include(FindPkgConfig)
pkg_check_modules(GLIB REQUIRED gobject-2.0)
# pkg_check_modules(GEE REQUIRED gee-1.0)
pkg_check_modules(GTK REQUIRED gtk+-2.0>=2.16)

Include(FindVala)
Include(UseVala)

#SET(VALA_COMPILE_FLAGS "--enable-experimental-non-null")
SET(VALA_COMPILE_FLAGS --enable-checking --fatal-warnings)
SET(VALA_COMPILE_FLAGS_DEBUG -X -ggdb3)

add_subdirectory(util)
add_subdirectory(bindings)
add_subdirectory(widgets)
add_subdirectory(examples)
add_subdirectory(src)

