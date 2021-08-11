#[=======================================================================[.rst:
FindMPG123
----------

Finds the mpg123 library.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``MPG123::MPG123``
  The mpg123 library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``MPG123_FOUND``
  True if the system has the mpg123 library.
``MPG123_VERSION``
  The version of the mpg123 library which was found.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``MPG123_INCLUDE_DIR``
  The directory containing ``mpg123.h``.
``MPG123_LIBRARY``
  The path to the mpg123 library.

#]=======================================================================]
# Find library
find_package(PkgConfig)
pkg_check_modules(PC_MPG123 QUIET libmpg123)
find_path(MPG123_INCLUDE_DIR
        NAMES mpg123.h
        PATHS ${PC_MPG123_INCLUDE_DIRS}
        PATH_SUFFIXES mpg123
)
find_library(MPG123_LIBRARY
        NAMES mpg123
        PATHS ${PC_MPG123_LIBRARY_DIRS}
)
set(MPG123_VERSION ${PC_MPG123_VERSION})

# Handle search arguments
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MPG123
        FOUND_VAR MPG123_FOUND
        REQUIRED_VARS
            MPG123_LIBRARY
            MPG123_INCLUDE_DIR
        VERSION_VAR MPG123_VERSION
)

# Export target
if(MPG123_FOUND AND NOT TARGET MPG123::MPG123)
    add_library(MPG123::MPG123 UNKNOWN IMPORTED)
    set_target_properties(MPG123::MPG123 PROPERTIES
            IMPORTED_LOCATION "${MPG123_LIBRARY}"
            INTERFACE_COMPILE_OPTIONS "${PC_MPG123_CFLAGS_OTHER}"
            INTERFACE_INCLUDE_DIRECTORIES "${MPG123_INCLUDE_DIR}"
    )
endif()

# Hide cached variables not important for direct user configuration
mark_as_advanced(
        MPG123_INCLUDE_DIR
        MPG123_LIBRARY
)
