#[=======================================================================[.rst:
FindMAD
-------

Finds the MPEG Audio Decoder (MAD) library.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``MAD::MAD``
  The MAD library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``MAD_FOUND``
  True if the system has the MAD library.
``MAD_VERSION``
  The version of the MAD library which was found.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``MAD_INCLUDE_DIR``
  The directory containing ``mad.h``.
``MAD_LIBRARY``
  The path to the MAD library.

#]=======================================================================]
# Find library
find_package(PkgConfig)
pkg_check_modules(PC_MAD QUIET mad)
find_path(MAD_INCLUDE_DIR
        NAMES mad.h
        PATHS ${PC_MAD_INCLUDE_DIRS}
        PATH_SUFFIXES mad
)
find_library(MAD_LIBRARY
        NAMES mad
        PATHS ${PC_MAD_LIBRARY_DIRS}
)
set(MAD_VERSION ${PC_MAD_VERSION})

# Handle search arguments
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MAD
        FOUND_VAR MAD_FOUND
        REQUIRED_VARS
            MAD_LIBRARY
            MAD_INCLUDE_DIR
        VERSION_VAR MAD_VERSION
)

# Export target
if(MAD_FOUND AND NOT TARGET MAD::MAD)
    add_library(MAD::MAD UNKNOWN IMPORTED)
    set_target_properties(MAD::MAD PROPERTIES
            IMPORTED_LOCATION "${MAD_LIBRARY}"
            INTERFACE_COMPILE_OPTIONS "${PC_MAD_CFLAGS_OTHER}"
            INTERFACE_INCLUDE_DIRECTORIES "${MAD_INCLUDE_DIR}"
    )
endif()

# Hide cached variables not important for direct user configuration
mark_as_advanced(
        MAD_INCLUDE_DIR
        MAD_LIBRARY
)
