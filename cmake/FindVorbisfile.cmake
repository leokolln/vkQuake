#[=======================================================================[.rst:
FindVorbisfile
--------------

Finds Vorbisfile library.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``Vorbisfile::Vorbisfile``
  The Vorbisfile library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``Vorbisfile_FOUND``
  True if the system has the Vorbisfile library.
``Vorbisfile_VERSION``
  The version of the Vorbisfile library which was found.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``Vorbisfile_INCLUDE_DIR``
  The directory containing ``vorbisfile.h``.
``Vorbisfile_LIBRARY``
  The path to the Vorbisfile library.

#]=======================================================================]
# Find library
find_package(PkgConfig)
pkg_check_modules(PC_Vorbisfile QUIET vorbisfile)
find_path(Vorbisfile_INCLUDE_DIR
        NAMES vorbisfile.h
        PATHS ${PC_Vorbisfile_INCLUDE_DIRS}
        PATH_SUFFIXES vorbis
)
find_library(Vorbisfile_LIBRARY
        NAMES vorbisfile
        PATHS ${PC_Vorbisfile_LIBRARY_DIRS}
)
set(Vorbisfile_VERSION ${PC_Vorbisfile_VERSION})

# Handle search arguments
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Vorbisfile
        FOUND_VAR Vorbisfile_FOUND
        REQUIRED_VARS
            Vorbisfile_LIBRARY
            Vorbisfile_INCLUDE_DIR
        VERSION_VAR Vorbisfile_VERSION
)

# Export target
if(Vorbisfile_FOUND AND NOT TARGET Vorbisfile::Vorbisfile)
    add_library(Vorbisfile::Vorbisfile UNKNOWN IMPORTED)
    set_target_properties(Vorbisfile::Vorbisfile PROPERTIES
            IMPORTED_LOCATION "${Vorbisfile_LIBRARY}"
            INTERFACE_COMPILE_OPTIONS "${PC_Vorbisfile_CFLAGS_OTHER}"
            INTERFACE_INCLUDE_DIRECTORIES "${Vorbisfile_INCLUDE_DIR}"
    )
endif()

# Hide cached variables not important for direct user configuration
mark_as_advanced(
        Vorbisfile_INCLUDE_DIR
        Vorbisfile_LIBRARY
)
