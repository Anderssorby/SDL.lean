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


static void sdl_window_finalizer(void *ptr) { 
  free(ptr);
}

static inline lean_obj_res lean_exclusive_or_copy(lean_obj_arg a, lean_obj_res (*copy_fun)(lean_obj_arg)) {
  if (lean_is_exclusive(a))
    return a;
  return copy_fun(a);
}

inline static void sdl_window_foreach(void *mod, b_lean_obj_arg fn) {}

static lean_external_class *g_sdl_window_class = NULL;

static lean_external_class *get_sdl_window_class() {
  if (g_sdl_window_class == NULL) {
    g_sdl_window_class = lean_register_external_class(
        &sdl_window_finalizer, &sdl_window_foreach);
  }
  return g_sdl_window_class;
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

/*
SDL.createWindow (name: String): IO Window
*/
lean_obj_res lean_sdl_create_window(lean_obj_arg l_name) {
  int width = 1000, height = 1000;
  printf("hello");
  SDL_Window *w = SDL_CreateWindow(
    lean_string_cstr(l_name),
    SDL_WINDOWPOS_CENTERED,
    SDL_WINDOWPOS_CENTERED,
    width, height, 0
  );
  printf("after");
  SDL_Delay(3000);
  lean_object *lean_w = lean_alloc_external(get_sdl_window_class(), w);
  return lean_io_result_mk_ok(lean_w);
}

lean_obj_res lean_sdl_get_error() {
  return lean_io_result_mk_ok(lean_mk_string(SDL_GetError()));
}

