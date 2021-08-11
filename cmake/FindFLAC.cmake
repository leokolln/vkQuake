#[=======================================================================[.rst:
FindFLAC
--------

Finds the Free Lossless Audio Codec (FLAC) library.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``FLAC::FLAC``
  The FLAC library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``FLAC_FOUND``
  True if the system has the FLAC library.
``FLAC_VERSION``
  The version of the FLAC library which was found.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``FLAC_INCLUDE_DIR``
  The directory containing ``all.h``.
``FLAC_LIBRARY``
  The path to the FLAC library.

#]=======================================================================]
# Find library
find_package(PkgConfig)
pkg_check_modules(PC_FLAC QUIET flac)
find_path(FLAC_INCLUDE_DIR
        NAMES all.h
        PATHS ${PC_FLAC_INCLUDE_DIRS}
        PATH_SUFFIXES FLAC
)
find_library(FLAC_LIBRARY
        NAMES FLAC
        PATHS ${PC_FLAC_LIBRARY_DIRS}
)
set(FLAC_VERSION ${PC_FLAC_VERSION})

# Handle search arguments
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(FLAC
        FOUND_VAR FLAC_FOUND
        REQUIRED_VARS
            FLAC_LIBRARY
            FLAC_INCLUDE_DIR
        VERSION_VAR FLAC_VERSION
)

# Export target
if(FLAC_FOUND AND NOT TARGET FLAC::FLAC)
    add_library(FLAC::FLAC UNKNOWN IMPORTED)
    set_target_properties(FLAC::FLAC PROPERTIES
            IMPORTED_LOCATION "${FLAC_LIBRARY}"
            INTERFACE_COMPILE_OPTIONS "${PC_FLAC_CFLAGS_OTHER}"
            INTERFACE_INCLUDE_DIRECTORIES "${FLAC_INCLUDE_DIR}"
    )
endif()

# Hide cached variables not important for direct user configuration
mark_as_advanced(
        FLAC_INCLUDE_DIR
        FLAC_LIBRARY
)
