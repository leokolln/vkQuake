#[=======================================================================[.rst:
FindMikMod
----------

Finds the MikMod library.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``MikMod::MikMod``
  The MikMod library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``MikMod_FOUND``
  True if the system has the MikMod library.
``MikMod_VERSION``
  The version of the MikMod library which was found.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``MikMod_INCLUDE_DIR``
  The directory containing ``mikmod.h``.
``MikMod_LIBRARY``
  The path to the MikMod library.

#]=======================================================================]
# Find library
find_package(PkgConfig)
pkg_check_modules(PC_MikMod QUIET libmikmod)
find_path(MikMod_INCLUDE_DIR
        NAMES mikmod.h
        PATHS ${PC_MikMod_INCLUDE_DIRS}
        PATH_SUFFIXES ""
)
find_library(MikMod_LIBRARY
        NAMES mikmod
        PATHS ${PC_MikMod_LIBRARY_DIRS}
)
set(MikMod_VERSION ${PC_MikMod_VERSION})

# Handle search arguments
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MikMod
        FOUND_VAR MikMod_FOUND
        REQUIRED_VARS
            MikMod_LIBRARY
            MikMod_INCLUDE_DIR
        VERSION_VAR MikMod_VERSION
)

# Export target
if(MikMod_FOUND AND NOT TARGET MikMod::MikMod)
    add_library(MikMod::MikMod UNKNOWN IMPORTED)
    set_target_properties(MikMod::MikMod PROPERTIES
            IMPORTED_LOCATION "${MikMod_LIBRARY}"
            INTERFACE_COMPILE_OPTIONS "${PC_MikMod_CFLAGS_OTHER}"
            INTERFACE_INCLUDE_DIRECTORIES "${MikMod_INCLUDE_DIR}"
    )
endif()

# Hide cached variables not important for direct user configuration
mark_as_advanced(
        MikMod_INCLUDE_DIR
        MikMod_LIBRARY
)
