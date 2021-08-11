#[=======================================================================[.rst:
FindTremorfile
--------------

Finds Integer-only Ogg Vorbis decoder, AKA "tremor" (Tremorfile) library.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``Tremorfile::Tremorfile``
  The Tremorfile library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``Tremorfile_FOUND``
  True if the system has the Tremorfile library.
``Tremorfile_VERSION``
  The version of the Tremorfile library which was found.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``Tremorfile_INCLUDE_DIR``
  The directory containing ``ivorbisfile.h``.
``Tremorfile_LIBRARY``
  The path to the Tremorfile library.

#]=======================================================================]
# Find library
find_package(PkgConfig)
pkg_check_modules(PC_Tremorfile QUIET vorbisidec)
find_path(Tremorfile_INCLUDE_DIR
        NAMES ivorbisfile.h
        PATHS ${PC_Tremorfile_INCLUDE_DIRS}
        PATH_SUFFIXES tremor
)
find_library(Tremorfile_LIBRARY
        NAMES vorbisidec
        PATHS ${PC_Tremorfile_LIBRARY_DIRS}
)
set(Tremorfile_VERSION ${PC_Tremorfile_VERSION})

# Handle search arguments
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Tremorfile
        FOUND_VAR Tremorfile_FOUND
        REQUIRED_VARS
            Tremorfile_LIBRARY
            Tremorfile_INCLUDE_DIR
        VERSION_VAR Tremorfile_VERSION
)

# Export target
if(Tremorfile_FOUND AND NOT TARGET Tremorfile::Tremorfile)
    add_library(Tremorfile::Tremorfile UNKNOWN IMPORTED)
    set_target_properties(Tremorfile::Tremorfile PROPERTIES
            IMPORTED_LOCATION "${Tremorfile_LIBRARY}"
            INTERFACE_COMPILE_OPTIONS "${PC_Tremorfile_CFLAGS_OTHER}"
            INTERFACE_INCLUDE_DIRECTORIES "${Tremorfile_INCLUDE_DIR}"
    )
endif()

# Hide cached variables not important for direct user configuration
mark_as_advanced(
        Tremorfile_INCLUDE_DIR
        Tremorfile_LIBRARY
)
