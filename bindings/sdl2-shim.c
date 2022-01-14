#include <lean/lean.h>

#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_timer.h>

/**
 *  This function initializes  the subsystems specified by \c flags
 */
extern int SDLCALL SDL_Init(Uint32 flags);


/*
SDL.init : IO Int
*/
lean_obj_res lean_sdl_init() {
  int res = SDL_Init(SDL_INIT_EVERYTHING);
  return lean_io_result_mk_ok(lean_int_to_int(res));
}

/*
SDL.quit : IO Unit
*/
lean_obj_res lean_sdl_quit() {
  SDL_Quit();
  return lean_io_result_mk_ok(lean_box(0));
}

static inline lean_obj_res lean_exclusive_or_copy(lean_obj_arg a, lean_obj_res (*copy_fun)(lean_obj_arg)) {
  if (lean_is_exclusive(a))
    return a;
  return copy_fun(a);
}

inline static void noop_foreach(void *mod, b_lean_obj_arg fn) {}

// SDL_Window

static lean_external_class *g_sdl_window_class = NULL;

static void sdl_window_finalizer(void *ptr) { 
  SDL_DestroyWindow(ptr);
}

static lean_external_class *get_sdl_window_class() {
  if (g_sdl_window_class == NULL) {
    g_sdl_window_class = lean_register_external_class(
        &sdl_window_finalizer, &noop_foreach);
  }
  return g_sdl_window_class;
}

/*
SDL.createWindow (name: String): IO Window
*/
lean_obj_res lean_sdl_create_window(lean_obj_arg l_name, uint32_t width, uint32_t height) {
  SDL_Window *w = SDL_CreateWindow(
    lean_string_cstr(l_name),
    SDL_WINDOWPOS_CENTERED,
    SDL_WINDOWPOS_CENTERED,
    width, height, 0
  );
  lean_object *lean_w = lean_alloc_external(get_sdl_window_class(), w);
  return lean_io_result_mk_ok(lean_w);
}

/*
SDL.destroyWindow (w : Window) : IO Unit
*/
lean_obj_res lean_sdl_destroy_window(lean_obj_arg l) {
  SDL_DestroyWindow(lean_get_external_data(l));
  return lean_io_result_mk_ok(lean_box(0));
}

// static inline lean_obj_res sdl_window_copy(lean_object *self) {
// #ifdef DEBUG
//   printf("lean_sdl_window_copy");
// #endif
//   assert(lean_get_external_class(self) == get_sdl_window_class());
//   SDL_Window *a = (SDL_Window *) lean_get_external_data(self);
//   SDL_Window *copy = malloc(sizeof(struct SDL_Window));
//   *copy = *a;

//   return lean_alloc_external(get_sdl_window_class(), copy);
// }

// SDL_Renderer

static lean_external_class *g_sdl_renderer_class = NULL;

static void sdl_renderer_finalizer(void *ptr) { 
  SDL_DestroyRenderer(ptr);
}

static lean_external_class *get_sdl_renderer_class() {
  if (g_sdl_renderer_class == NULL) {
    g_sdl_renderer_class = lean_register_external_class(
        &sdl_renderer_finalizer, &noop_foreach);
  }
  return g_sdl_renderer_class;
}

/*
SDL.createRenderer (w: Window): IO Renderer
*/
lean_obj_res lean_sdl_create_renderer(b_lean_obj_arg window) {
  int index = -1;
  uint32_t flags = 0;
  SDL_Window *w = lean_get_external_data(window);
  SDL_Renderer *r = SDL_CreateRenderer(
    w, index, flags
  );

  lean_object *lean_r = lean_alloc_external(get_sdl_renderer_class(), r);
  return lean_io_result_mk_ok(lean_r);
}

/*
SDL.destroyRenderer (r : Renderer) : IO Unit
*/
void lean_sdl_destroy_renderer(lean_obj_arg l) {
  SDL_DestroyRenderer(lean_get_external_data(l));
}

// SDL_Surface

static lean_external_class *g_sdl_surface_class = NULL;

static void sdl_surface_finalizer(void *ptr) { 
  SDL_FreeSurface(ptr);
}

static lean_external_class *get_sdl_surface_class() {
  if (g_sdl_surface_class == NULL) {
    g_sdl_surface_class = lean_register_external_class(
        &sdl_surface_finalizer, &noop_foreach);
  }
  return g_sdl_surface_class;
}

/*
SDL.loadBMP (file: @& String): IO Surface
*/
lean_obj_res lean_sdl_load_bmp(b_lean_obj_arg file) {
  SDL_Surface *s = SDL_LoadBMP(lean_string_cstr(file));

  lean_object *lean_r = lean_alloc_external(get_sdl_surface_class(), s);
  return lean_io_result_mk_ok(lean_r);
}

/*
SDL.freeSurface (s: Surface): IO Unit
*/
lean_obj_res lean_sdl_free_surface(b_lean_obj_arg surface) {
  SDL_FreeSurface(lean_get_external_data(surface));
  return lean_io_result_mk_ok(lean_box(0));
}

// SDL_Texture

static lean_external_class *g_sdl_texture_class = NULL;

static void sdl_texture_finalizer(void *ptr) { 
  SDL_DestroyTexture(ptr);
}

static lean_external_class *get_sdl_texture_class() {
  if (g_sdl_texture_class == NULL) {
    g_sdl_texture_class = lean_register_external_class(
        &sdl_texture_finalizer, &noop_foreach);
  }
  return g_sdl_texture_class;
}

/*
SDL.createTextureFromSurface (r: @& Renderer) (s: @& Surface): IO Texture
*/
lean_obj_res lean_sdl_create_texture_from_surface(b_lean_obj_arg r, b_lean_obj_arg s) {
  SDL_Renderer *renderer = lean_get_external_data(r);
  SDL_Surface *surf = lean_get_external_data(s);
  SDL_Texture *t = SDL_CreateTextureFromSurface(renderer, surf);
  lean_object *lean_t = lean_alloc_external(get_sdl_texture_class(), t);
  return lean_io_result_mk_ok(lean_t);
}

/*
SDL.destroyTexture (t : Texture) : IO Unit
*/
lean_obj_res lean_sdl_destroy_texture(b_lean_obj_arg l) {
  SDL_DestroyTexture(lean_get_external_data(l));
  return lean_io_result_mk_ok(lean_box(0));
}

/*
SDL.renderCopy (r: @& Renderer) (t: @& Texture): IO Unit
*/
lean_obj_res lean_sdl_render_copy(b_lean_obj_arg r, b_lean_obj_arg t, b_lean_obj_arg o_src, b_lean_obj_arg o_dst) {
  
  SDL_Renderer *renderer = lean_get_external_data(r);
  SDL_Texture *tex = lean_get_external_data(t);
  SDL_RenderCopy(renderer, tex, NULL, NULL);
  return lean_io_result_mk_ok(lean_box(0));
}

/*
SDL.setRenderDrawColor (r: @& Renderer) (r g b a : UInt8): IO Unit
*/
lean_obj_res lean_sdl_set_render_draw_color(b_lean_obj_arg ren, uint8_t r, uint8_t g, uint8_t b, uint8_t a) {
  SDL_Renderer *renderer = lean_get_external_data(ren);
  SDL_SetRenderDrawColor(renderer, r, g, b, a);
  return lean_io_result_mk_ok(lean_box(0));
}

/*
SDL.renderPresent (r: @& Renderer): IO Unit
*/
lean_obj_res lean_sdl_render_present(b_lean_obj_arg r) {
  SDL_Renderer *renderer = lean_get_external_data(r);
  SDL_RenderPresent(renderer);
  return lean_io_result_mk_ok(lean_box(0));
}

/*
SDL.getError : IO String
*/
lean_obj_res lean_sdl_get_error() {
  return lean_io_result_mk_ok(lean_mk_string(SDL_GetError()));
}

// SDL_Point

static lean_external_class *g_sdl_point_class = NULL;

static void sdl_point_finalizer(void *ptr) { 
  free(ptr);
}

static lean_external_class *get_sdl_point_class() {
  if (g_sdl_point_class == NULL) {
    g_sdl_point_class = lean_register_external_class(
        &sdl_point_finalizer, &noop_foreach);
  }
  return g_sdl_point_class;
}

/*
SDL.mkSDL_Point (x y : UInt32) : SDL_Point
*/
lean_obj_res lean_sdl_mk_sdl_point(uint32_t x, uint32_t y) {
  SDL_Point *p = {x, y};
  return lean_alloc_external(get_sdl_point_class(), p);
}

// SDL_Rect

static lean_external_class *g_sdl_rect_class = NULL;

static void sdl_rect_finalizer(void *ptr) { 
  free(ptr);
}

static lean_external_class *get_sdl_rect_class() {
  if (g_sdl_rect_class == NULL) {
    g_sdl_rect_class = lean_register_external_class(
        &sdl_rect_finalizer, &noop_foreach);
  }
  return g_sdl_rect_class;
}

/*
SDL.mkSDL_Rect (x y w h : UInt32) : SDL_Rect
*/
lean_obj_res lean_sdl_mk_sdl_rect(uint32_t x, uint32_t y, uint32_t w, uint32_t h) {
  SDL_Rect *p = {x, y, w, h};
  return lean_alloc_external(get_sdl_rect_class(), p);
}

/*
SDL.delay (ms : UInt32) : IO Unit
*/
lean_obj_res lean_sdl_delay(uint32_t ms) {
  SDL_Delay(ms);
  return lean_io_result_mk_ok(lean_box(0));
}
