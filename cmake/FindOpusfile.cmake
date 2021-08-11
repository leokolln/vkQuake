#[=======================================================================[.rst:
FindOpusfile
------------

Finds the Opusfile library.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``Opusfile::Opusfile``
  The Opusfile library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``Opusfile_FOUND``
  True if the system has the Opusfile library.
``Opusfile_VERSION``
  The version of the Opusfile library which was found.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``Opusfile_INCLUDE_DIR``
  The directory containing ``opusfile.h``.
``Opusfile_LIBRARY``
  The path to the Opusfile library.

#]=======================================================================]
# Find library
find_package(PkgConfig)
pkg_check_modules(PC_Opusfile QUIET opusfile)
find_path(Opusfile_INCLUDE_DIR
        NAMES opusfile.h
        PATHS ${PC_Opusfile_INCLUDE_DIRS}
        PATH_SUFFIXES opus
)
find_library(Opusfile_LIBRARY
        NAMES opusfile
        PATHS ${PC_Opusfile_LIBRARY_DIRS}
)
set(Opusfile_VERSION ${PC_Opusfile_VERSION})

# Handle search arguments
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Opusfile
        FOUND_VAR Opusfile_FOUND
        REQUIRED_VARS
            Opusfile_LIBRARY
            Opusfile_INCLUDE_DIR
        VERSION_VAR Opusfile_VERSION
)

# Export target
if(Opusfile_FOUND AND NOT TARGET Opusfile::Opusfile)
    add_library(Opusfile::Opusfile UNKNOWN IMPORTED)
    set_target_properties(Opusfile::Opusfile PROPERTIES
            IMPORTED_LOCATION "${Opusfile_LIBRARY}"
            INTERFACE_COMPILE_OPTIONS "${PC_Opusfile_CFLAGS_OTHER}"
            INTERFACE_INCLUDE_DIRECTORIES "${Opusfile_INCLUDE_DIR}"
    )
endif()

# Hide cached variables not important for direct user configuration
mark_as_advanced(
        Opusfile_INCLUDE_DIR
        Opusfile_LIBRARY
)
