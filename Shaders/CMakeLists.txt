add_library(vkQuake_draw_shaders STATIC)
target_sources(vkQuake_draw_shaders PRIVATE
        Compiled/alias_frag.c
        Compiled/alias_alphatest_frag.c
        Compiled/alias_vert.c
        Compiled/basic_alphatest_frag.c
        Compiled/screen_warp_comp.c
        Compiled/screen_warp_rgba8_comp.c
        Compiled/cs_tex_warp_comp.c
        Compiled/basic_frag.c
        Compiled/basic_notex_frag.c
        Compiled/basic_vert.c
        Compiled/sky_layer_frag.c
        Compiled/sky_layer_vert.c
        Compiled/postprocess_frag.c
        Compiled/postprocess_vert.c
        Compiled/world_frag.c
        Compiled/world_vert.c
        Compiled/showtris_frag.c
        Compiled/showtris_vert.c
)
