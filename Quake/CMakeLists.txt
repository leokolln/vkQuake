# Options
option(DO_USERDIRS      "Support for user directories"         OFF)
option(USE_CODEC_WAVE   "Support for music using WAVE codec"   ON)
option(USE_CODEC_FLAC   "Support for music using FLAC codec"   OFF)
option(USE_CODEC_MP3    "Support for music using MP3 codec"    ON)
option(USE_CODEC_VORBIS "Support for music using Vorbis codec" ON)
option(USE_CODEC_OPUS   "Support for music using Opus codec"   OFF)
option(USE_CODEC_MOD    "Support for music using MOD codec"    OFF)
option(USE_CODEC_UMX    "Support for music using UMX codec"    OFF)
### Option for MP3 library selection
set(MP3LIB_OPTIONS mad mpg123)
set(MP3LIB "mad" CACHE STRING "Lib to use if MP3 codec support is enabled")
set_property(CACHE MP3LIB PROPERTY STRINGS ${MP3LIB_OPTIONS})
if(NOT MP3LIB IN_LIST MP3LIB_OPTIONS)
    message(SEND_ERROR "MP3LIB set with invalid option '${MP3LIB}'. Valid options are: ${MP3LIB_OPTIONS}")
endif()
### Option for Vorbis library selection
set(VORBISLIB_OPTIONS vorbis tremor)
set(VORBISLIB "vorbis" CACHE STRING "Lib to use if Vorbis codec support is enabled")
set_property(CACHE VORBISLIB PROPERTY STRINGS ${VORBISLIB_OPTIONS})
if(NOT VORBISLIB IN_LIST VORBISLIB_OPTIONS)
    message(SEND_ERROR "VORBISLIB set with invalid option '${VORBISLIB}'. Valid options are: ${VORBISLIB_OPTIONS}")
endif()
### Option for MOD library selection
set(MODLIB_OPTIONS mikmod xmp)
set(MODLIB "mikmod" CACHE STRING "Lib to use if MOD codec support is enabled")
set_property(CACHE MODLIB PROPERTY STRINGS ${MODLIB_OPTIONS})
if(NOT MODLIB IN_LIST MODLIB_OPTIONS)
    message(SEND_ERROR "MODLIB set with invalid option '${MODLIB}'. Valid options are: ${MODLIB_OPTIONS}")
endif()

# Dependencies
find_package(SDL2 REQUIRED)
find_package(Vulkan REQUIRED)
### Conditional dependencies
if(USE_CODEC_FLAC)
    find_package(FLAC REQUIRED)
endif()
if(USE_CODEC_MP3)
    if(MP3LIB STREQUAL "mad")
        find_package(MAD REQUIRED)
    elseif(MP3LIB STREQUAL "mpg123")
        find_package(MPG123 REQUIRED)
    endif()
endif()
if(USE_CODEC_VORBIS)
    if(VORBISLIB STREQUAL "vorbis")
        find_package(Vorbisfile REQUIRED)
    elseif(VORBISLIB STREQUAL "tremor")
        find_package(Tremorfile REQUIRED)
    endif()
endif()
if(USE_CODEC_OPUS)
    find_package(Opusfile REQUIRED)
endif()
if(USE_CODEC_MOD)
    if(MODLIB STREQUAL "mikmod")
        find_package(MikMod REQUIRED)
    elseif(MODLIB STREQUAL "xmp")
        find_package(XMP REQUIRED)
    endif()
endif()

# TODO Support for MacOS (darwin) -lMoltenVK

# General compilation settings
set(CMAKE_C_STANDARD 99)
link_libraries(SDL2::SDL2 Vulkan::Vulkan) # TODO Fix sources to reference only where strictly needed
add_compile_definitions($<$<CONFIG:Debug>:_DEBUG>)
if (NOT MSVC)
    add_compile_options(
            -Wall -Wno-trigraphs
            $<$<NOT:$<CONFIG:Debug>>:-fweb>
            $<$<NOT:$<CONFIG:Debug>>:-frename-registers>
    )
endif()

# Sound
add_library(vkQuake_snd STATIC)
target_sources(vkQuake_snd PRIVATE
        bgmusic.c
        snd_dma.c
        snd_mix.c
        snd_mem.c
        snd_codec.c
        snd_sdl.c
        # cd_sdl.c # SDL dropped support for cd audio since v1.3.0, no reason to compile, using 'cd_null.c' instead
        cd_null.c
        $<$<BOOL:${USE_CODEC_WAVE}>:snd_wave.c>      # WAVE
        $<$<BOOL:${USE_CODEC_FLAC}>:snd_flac.c>      # FLAC
        $<$<BOOL:${USE_CODEC_MP3}>:snd_mp3tag.c>     # MP3
        $<$<BOOL:${MAD_FOUND}>:snd_mp3.c>            # MP3 - MAD
        $<$<BOOL:${MPG123_FOUND}>:snd_mpg123.c>      # MP3 - MPG123
        $<$<BOOL:${USE_CODEC_VORBIS}>:snd_vorbis.c>  # Vorbis
        $<$<BOOL:${USE_CODEC_OPUS}>:snd_opus.c>      # Opus
        $<$<BOOL:${MikMod_FOUND}>:snd_mikmod.c>      # MOD - MikMod
        $<$<BOOL:${XMP_FOUND}>:snd_xmp.c>            # MOD - XMP
        $<$<BOOL:${USE_CODEC_UMX}>:snd_umx.c>        # UMX
)
target_compile_definitions(vkQuake_snd PRIVATE
        $<$<BOOL:${USE_CODEC_WAVE}>:USE_CODEC_WAVE>           # WAVE
        $<$<BOOL:${USE_CODEC_FLAC}>:USE_CODEC_FLAC>           # FLAC
        $<$<BOOL:${USE_CODEC_MP3}>:USE_CODEC_MP3>             # MP3
        $<$<BOOL:${USE_CODEC_VORBIS}>:USE_CODEC_VORBIS>       # Vorbis
        $<$<STREQUAL:${VORBISLIB},tremor>:VORBIS_USE_TREMOR>  # Vorbis - Tremor
        $<$<BOOL:${USE_CODEC_OPUS}>:USE_CODEC_OPUS>           # Opus
        $<$<BOOL:${MikMod_FOUND}>:USE_CODEC_MIKMOD>           # MOD - MikMod
        $<$<BOOL:${XMP_FOUND}>:USE_CODEC_XMP>                 # MOD - XMP
        $<$<BOOL:${USE_CODEC_UMX}>:USE_CODEC_UMX>             # UMX
)
target_link_libraries(vkQuake_snd PRIVATE
        $<$<BOOL:${FLAC_FOUND}>:FLAC::FLAC>                    # FLAC
        $<$<BOOL:${MAD_FOUND}>:MAD::MAD>                       # MP3 - MAD
        $<$<BOOL:${MPG123_FOUND}>:MPG123::MPG123>              # MP3 - MPG123
        $<$<BOOL:${Vorbisfile_FOUND}>:Vorbisfile::Vorbisfile>  # Vorbis
        $<$<BOOL:${Tremorfile_FOUND}>:Tremorfile::Tremorfile>  # Vorbis
        $<$<BOOL:${Opusfile_FOUND}>:Opusfile::Opusfile>        # Opus
        $<$<BOOL:${MikMod_FOUND}>:MikMod::MikMod>              # MOD - MikMod
        $<$<BOOL:${XMP_FOUND}>:XMP::XMP>                       # MOD - XMP
)

# Network
add_library(vkQuake_net STATIC)
target_link_libraries(vkQuake_net PRIVATE $<$<PLATFORM_ID:Windows,MinGW>:ws2_32>)
target_compile_definitions(vkQuake_net PRIVATE $<$<PLATFORM_ID:Windows,MinGW>:_USE_WINSOCK2>)
target_sources(vkQuake_net PRIVATE
        net_dgrm.c
        net_loop.c
        net_main.c
        $<$<PLATFORM_ID:Linux,FreeBSD,Darwin>:net_bsd.c net_udp.c>
        $<$<PLATFORM_ID:Windows,MinGW>:net_win.c net_wins.c net_wipx.c>
)

# System
add_library(vkQuake_sys STATIC)
target_compile_definitions(vkQuake_sys PRIVATE $<$<BOOL:${DO_USERDIRS}>:DO_USERDIRS>)
target_sources(vkQuake_sys PRIVATE
        $<$<PLATFORM_ID:Linux,FreeBSD>:pl_linux.c>
        $<$<PLATFORM_ID:Linux,FreeBSD,Darwin>:sys_sdl_unix.c>
        $<$<PLATFORM_ID:Darwin>:pl_osx.m>
        $<$<PLATFORM_ID:Windows,MinGW>:pl_win.c sys_sdl_win.c>
)

# Input
add_library(vkQuake_input STATIC)
target_sources(vkQuake_input PRIVATE in_sdl.c)

# Draw
add_library(vkQuake_draw STATIC)
target_link_libraries(vkQuake_draw PUBLIC vkQuake_draw_shaders)
target_sources(vkQuake_draw PRIVATE
        gl_draw.c
        gl_fog.c
        gl_heap.c
        gl_mesh.c
        gl_model.c
        gl_refrag.c
        gl_rlight.c
        gl_rmain.c
        gl_rmisc.c
        gl_vidsdl.c
        gl_screen.c
        gl_sky.c
        gl_texmgr.c
        gl_warp.c
        r_alias.c
        r_brush.c
        r_part.c
        r_sprite.c
        r_world.c
        image.c
)

# Main
add_executable(vkQuake WIN32)
target_link_libraries(vkQuake PRIVATE
        vkQuake_net
        vkQuake_sys
        vkQuake_snd
        vkQuake_input
        vkQuake_draw
        SDL2::SDL2main
        $<$<PLATFORM_ID:Linux,FreeBSD,Darwin,MinGW>:m> # Would be better to just check if not MSVC?
        $<$<PLATFORM_ID:Windows,MinGW>:winmm>
)
target_sources(vkQuake PRIVATE
        cfgfile.c
        chase.c
        cl_demo.c
        cl_input.c
        cl_main.c
        cl_parse.c
        cl_tent.c
        cmd.c
        common.c
        console.c
        crc.c
        cvar.c
        host.c
        host_cmd.c
        keys.c
        main_sdl.c
        mathlib.c
        menu.c
        pr_cmds.c
        pr_edict.c
        pr_exec.c
        sbar.c
        strlcat.c
        strlcpy.c
        sv_main.c
        sv_move.c
        sv_phys.c
        sv_user.c
        view.c
        wad.c
        world.c
        zone.c
        $<$<PLATFORM_ID:Windows,MinGW>:../Windows/vkQuake.rc>
)

# TODO: Add install directives

#[=======================================================================[
Notes
-----
Differences to original Makefile:
* Definition "USE_SDL2" not set, has no references on code or dependencies # TODO Review
* Dropped explicit support for SunOS.
* Options for sound codecs MikMod and XMP unified under MOD option, similar to Vorbis and MP3.

Future Improvements
-------------------
* Rename file `snd_mp3.c` to `snd_mad.c`, as it is only compiled when using MAD codec.
* Remove include of `SDL.h` from `quakedef.h`, include only where necessary for better organization and compilation.
* Unify defines `USE_CODEC_MIKMOD` and `USE_CODEC_XMP` under `USE_CODEC_MOD`.
* Fix MOD and UMX not being considered `CDRIP_TYPES`. Add to allow auto play as other music with name pattern `trackXX`.
* Remove winmm usage
* Remove non WinSoc2 code

Build on Windows
----------------
## Dependencies
```powershell
vcpkg install sdl2[vulkan]:x64-windows libmad:x64-windows libvorbis:x64-windows
```
## Compilation
```powershell
mkdir build
cd build
cmake -DCMAKE_TOOLCHAIN_FILE=C:\vcpkg\scripts\buildsystems\vcpkg.cmake ..
cmake --build .
```
Output will be: `build\Quake\Debug\vkQuake.exe`
#]=======================================================================]
