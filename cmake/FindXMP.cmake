#[=======================================================================[.rst:
FindXMP
-------

Finds the Extended Module Player (XMP) library.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``XMP::XMP``
  The XMP library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``XMP_FOUND``
  True if the system has the XMP library.
``XMP_VERSION``
  The version of the XMP library which was found.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``XMP_INCLUDE_DIR``
  The directory containing ``xmp.h``.
``XMP_LIBRARY``
  The path to the XMP library.

#]=======================================================================]
# Find library
find_package(PkgConfig)
pkg_check_modules(PC_XMP QUIET libxmp)
find_path(XMP_INCLUDE_DIR
        NAMES xmp.h
        PATHS ${PC_XMP_INCLUDE_DIRS}
        PATH_SUFFIXES ""
)
find_library(XMP_LIBRARY
        NAMES xmp
        PATHS ${PC_XMP_LIBRARY_DIRS}
)
set(XMP_VERSION ${PC_XMP_VERSION})

# Handle search arguments
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(XMP
        FOUND_VAR XMP_FOUND
        REQUIRED_VARS
            XMP_LIBRARY
            XMP_INCLUDE_DIR
        VERSION_VAR XMP_VERSION
)

# Export target
if(XMP_FOUND AND NOT TARGET XMP::XMP)
    add_library(XMP::XMP UNKNOWN IMPORTED)
    set_target_properties(XMP::XMP PROPERTIES
            IMPORTED_LOCATION "${XMP_LIBRARY}"
            INTERFACE_COMPILE_OPTIONS "${PC_XMP_CFLAGS_OTHER}"
            INTERFACE_INCLUDE_DIRECTORIES "${XMP_INCLUDE_DIR}"
    )
endif()

# Hide cached variables not important for direct user configuration
mark_as_advanced(
        XMP_INCLUDE_DIR
        XMP_LIBRARY
)
