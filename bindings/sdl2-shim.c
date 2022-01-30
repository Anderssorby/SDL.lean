#include <lean/lean.h>

#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_timer.h>

/**
 * Unwrap an Option of an external object as data for some
 * or NULL for none. Unsafe.
 */
static inline void *lean_option_unwrap(b_lean_obj_arg a) {
  if (lean_is_scalar(a)) {
    return NULL;
  } else {
    lean_object *some_val = lean_ctor_get(a, 0);
    return lean_get_external_data(some_val);      
  }
}

/**
 * Option.some a
 */
static inline lean_object * lean_mk_option_some(lean_object * a) {
  lean_object* tuple = lean_alloc_ctor(1, 1, 0);
  lean_ctor_set(tuple, 0, a);
  return tuple;
}

/**
 * Option.none.
 * Note that this is the same value for Unit and other constant constructors of inductives.
 */
static inline lean_object * lean_mk_option_none() {
  return lean_box(0);
}

static inline lean_object * lean_mk_tuple2(lean_object * a, lean_object * b) {
  lean_object* tuple = lean_alloc_ctor(0, 2, 0);
  lean_ctor_set(tuple, 0, a);
  lean_ctor_set(tuple, 1, b);
  return tuple;
}

/**
 * This function initializes  the subsystems specified by \c flags
 * SDL.init : IO Int
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

// SDL_Renderer

static lean_external_class *g_sdl_renderer_class = NULL;

static void sdl_renderer_finalizer(void *ptr) { 
  SDL_DestroyRenderer(ptr);
}

static lean_external_class *get_sdl_renderer_class() {
  if (g_sdl_renderer_class == NULL) {
    g_sdl_renderer_class = lean_register_external_class(
      &sdl_renderer_finalizer, &noop_foreach
    );
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
SDL.loadImage (file: @& String): IO Surface
*/
lean_obj_res lean_sdl_load_image(b_lean_obj_arg file) {
  SDL_Surface *s = IMG_Load(lean_string_cstr(file));

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
SDL.renderCopy (r: @& Renderer) (t: @& Texture) (src dst: @& Option SDL_Rect): IO Unit
*/
lean_obj_res lean_sdl_render_copy(b_lean_obj_arg r, b_lean_obj_arg t, b_lean_obj_arg o_src, b_lean_obj_arg o_dst) {
  SDL_Rect *src = lean_option_unwrap(o_src);
  SDL_Rect *dst = lean_option_unwrap(o_dst);
  SDL_Renderer *renderer = lean_get_external_data(r);
  SDL_Texture *tex = lean_get_external_data(t);
  SDL_RenderCopy(renderer, tex, src, dst);
  return lean_io_result_mk_ok(lean_box(0));
}

/*
SDL.renderFillRect (r: @& Renderer) (re : @& SDL_Rect): IO Unit
*/
lean_obj_res lean_sdl_render_fill_rect(b_lean_obj_arg r, b_lean_obj_arg re) {
  SDL_Rect *rect = lean_get_external_data(re);
  SDL_Renderer *renderer = lean_get_external_data(r);
  SDL_RenderFillRect(renderer, rect);
  return lean_io_result_mk_ok(lean_box(0));
}
/*
SDL.renderDrawRect (r: @& Renderer) (re : @& SDL_Rect): IO Unit
*/
lean_obj_res lean_sdl_render_draw_rect(b_lean_obj_arg r, b_lean_obj_arg re) {
  SDL_Rect *rect = lean_get_external_data(re);
  SDL_Renderer *renderer = lean_get_external_data(r);
  SDL_RenderDrawRect(renderer, rect);
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
SDL.renderClear (r: @& Renderer): IO Unit
*/
lean_obj_res lean_sdl_render_clear(b_lean_obj_arg r) {
  SDL_Renderer *renderer = lean_get_external_data(r);
  SDL_RenderClear(renderer);
  return lean_io_result_mk_ok(lean_box(0));
}


/*
SDL.getError : IO String
*/
lean_obj_res lean_sdl_get_error() {
  return lean_io_result_mk_ok(lean_mk_string(SDL_GetError()));
}

/*
SDL.getIMGError : IO String
*/
lean_obj_res lean_sdl_get_img_error() {
  return lean_io_result_mk_ok(lean_mk_string(IMG_GetError()));
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
  SDL_Point *p = malloc(sizeof(struct SDL_Point));
  p->x = x;
  p->y = y;
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
  SDL_Rect *r = malloc(sizeof(struct SDL_Rect));
  r->x = x;
  r->y = y;
  r->w = w;
  r->h = h;
  return lean_alloc_external(get_sdl_rect_class(), r);
}

/*
SDL.delay (ms : UInt32) : IO Unit
*/
lean_obj_res lean_sdl_delay(uint32_t ms) {
  SDL_Delay(ms);
  return lean_io_result_mk_ok(lean_box(0));
}

// Events

// SDL_Event

static lean_external_class *g_sdl_event_class = NULL;

static void sdl_event_finalizer(void *ptr) { 
  free(ptr);
}

static lean_external_class *get_sdl_event_class() {
  if (g_sdl_event_class == NULL) {
    g_sdl_event_class = lean_register_external_class(
        &sdl_event_finalizer, &noop_foreach
    );
  }
  return g_sdl_event_class;
}

/*
SDL.pollEvent : IO $ Prod Bool (Option SDL_Event)
*/
lean_obj_res lean_sdl_poll_event() {
  SDL_Event *event = malloc(sizeof(SDL_Event));
  uint8_t b = (uint8_t) SDL_PollEvent(event);
  lean_object* tuple;
  if (b && event != NULL) {
    lean_object* e = lean_alloc_external(get_sdl_event_class(), event);
    // Constructs a (Bool, some SDL_Event) tuple
    tuple = lean_mk_tuple2(lean_box(b), lean_mk_option_some(e));
  } else {
    tuple = lean_mk_tuple2(lean_box(b), lean_mk_option_none());
  }
  return lean_io_result_mk_ok(tuple);
}

// Application events

uint32_t lean_SDL_QUIT() {
  return SDL_QUIT;
}

// Android, iOS and WinRT events; see Remarks for details

uint32_t lean_SDL_APP_TERMINATING() {
  return SDL_APP_TERMINATING;
}

uint32_t lean_SDL_APP_LOWMEMORY() {
  return SDL_APP_LOWMEMORY;
}

uint32_t lean_SDL_APP_WILLENTERBACKGROUND() {
  return SDL_APP_WILLENTERBACKGROUND;
}

uint32_t lean_SDL_APP_DIDENTERBACKGROUND() {
  return SDL_APP_DIDENTERBACKGROUND;
}

uint32_t lean_SDL_APP_WILLENTERFOREGROUND() {
  return SDL_APP_WILLENTERFOREGROUND;
}

uint32_t lean_SDL_APP_DIDENTERFOREGROUND() {
  return SDL_APP_DIDENTERFOREGROUND;
}

// Window events

uint32_t lean_SDL_WINDOWEVENT() {
  return SDL_WINDOWEVENT;
}

uint32_t lean_SDL_SYSWMEVENT() {
  return SDL_SYSWMEVENT;
}

// Keyboard events

uint32_t lean_SDL_KEYDOWN() {
  return SDL_KEYDOWN;
}

uint32_t lean_SDL_KEYUP() {
  return SDL_KEYUP;
}

uint32_t lean_SDL_TEXTEDITING() {
  return SDL_TEXTEDITING;
}

uint32_t lean_SDL_TEXTINPUT() {
  return SDL_TEXTINPUT;
}

uint32_t lean_SDL_KEYMAPCHANGED() {
  return SDL_KEYMAPCHANGED;
}

// Mouse events

uint32_t lean_SDL_MOUSEMOTION() {
  return SDL_MOUSEMOTION;
}

uint32_t lean_SDL_MOUSEBUTTONDOWN() {
  return SDL_MOUSEBUTTONDOWN;
}

uint32_t lean_SDL_MOUSEBUTTONUP() {
  return SDL_MOUSEBUTTONUP;
}

uint32_t lean_SDL_MOUSEWHEEL() {
  return SDL_MOUSEWHEEL;
}

// Joystick events

uint32_t lean_SDL_JOYAXISMOTION() {
  return SDL_JOYAXISMOTION;
}

uint32_t lean_SDL_JOYBALLMOTION() {
  return SDL_JOYBALLMOTION;
}

uint32_t lean_SDL_JOYHATMOTION() {
  return SDL_JOYHATMOTION;
}

uint32_t lean_SDL_JOYBUTTONDOWN() {
  return SDL_JOYBUTTONDOWN;
}

uint32_t lean_SDL_JOYBUTTONUP() {
  return SDL_JOYBUTTONUP;
}

uint32_t lean_SDL_JOYDEVICEADDED() {
  return SDL_JOYDEVICEADDED;
}

uint32_t lean_SDL_JOYDEVICEREMOVED() {
  return SDL_JOYDEVICEREMOVED;
}

// Controller events

uint32_t lean_SDL_CONTROLLERAXISMOTION() {
  return SDL_CONTROLLERAXISMOTION;
}

uint32_t lean_SDL_CONTROLLERBUTTONDOWN() {
  return SDL_CONTROLLERBUTTONDOWN;
}

uint32_t lean_SDL_CONTROLLERBUTTONUP() {
  return SDL_CONTROLLERBUTTONUP;
}

uint32_t lean_SDL_CONTROLLERDEVICEADDED() {
  return SDL_CONTROLLERDEVICEADDED;
}

uint32_t lean_SDL_CONTROLLERDEVICEREMOVED() {
  return SDL_CONTROLLERDEVICEREMOVED;
}

uint32_t lean_SDL_CONTROLLERDEVICEREMAPPED() {
  return SDL_CONTROLLERDEVICEREMAPPED;
}

// Touch events

uint32_t lean_SDL_FINGERDOWN() {
  return SDL_FINGERDOWN;
}

uint32_t lean_SDL_FINGERUP() {
  return SDL_FINGERUP;
}

uint32_t lean_SDL_FINGERMOTION() {
  return SDL_FINGERMOTION;
}

// Gesture events

uint32_t lean_SDL_DOLLARGESTURE() {
  return SDL_DOLLARGESTURE;
}

uint32_t lean_SDL_DOLLARRECORD() {
  return SDL_DOLLARRECORD;
}

uint32_t lean_SDL_MULTIGESTURE() {
  return SDL_MULTIGESTURE;
}

uint32_t lean_SDL_CLIPBOARDUPDATE() {
  return SDL_CLIPBOARDUPDATE;
}

// Drag and drop events

uint32_t lean_SDL_DROPFILE() {
  return SDL_DROPFILE;
}

uint32_t lean_SDL_DROPTEXT() {
  return SDL_DROPTEXT;
}

uint32_t lean_SDL_DROPBEGIN() {
  return SDL_DROPBEGIN;
}

uint32_t lean_SDL_DROPCOMPLETE() {
  return SDL_DROPCOMPLETE;
}

// Audio hotplug events

uint32_t lean_SDL_AUDIODEVICEADDED() {
  return SDL_AUDIODEVICEADDED;
}

uint32_t lean_SDL_AUDIODEVICEREMOVED() {
  return SDL_AUDIODEVICEREMOVED;
}

// Render events

uint32_t lean_SDL_RENDER_TARGETS_RESET() {
  return SDL_RENDER_TARGETS_RESET;
}

uint32_t lean_SDL_RENDER_DEVICE_RESET() {
  return SDL_RENDER_DEVICE_RESET;
}

// These are for your use, and should be allocated with  SDL_RegisterEvents()

uint32_t lean_SDL_USEREVENT() {
  return SDL_USEREVENT;
}

uint32_t lean_SDL_LASTEVENT() {
  return SDL_LASTEVENT;
}

/*
SDL.SDL_Event.type (s : @& SDL_Event) : UInt32
*/
uint32_t lean_sdl_event_type(b_lean_obj_arg s){
  SDL_Event *event = lean_get_external_data(s);
  return event->type;
}

/*
SDL.Event.toKeyboardEventData (s : @& SDL_Event) : (UInt32 × UInt32 × UInt32 × UInt32 × UInt32 × UInt32 × UInt32 × UInt32)
*/
lean_obj_res lean_sdl_event_to_keyboard_event_data(b_lean_obj_arg s){
  SDL_Event * event = lean_get_external_data(s);
  lean_object * tuple = lean_mk_tuple2(
    lean_box(event->key.timestamp),
    lean_mk_tuple2(lean_box(event->key.windowID),
    lean_mk_tuple2(lean_box(event->key.state),
    lean_mk_tuple2(lean_box(event->key.repeat),
    lean_mk_tuple2(lean_box(event->key.keysym.scancode),
    lean_mk_tuple2(lean_box(event->key.keysym.sym),
    lean_box(event->key.keysym.mod)
  ))))));

  return tuple;
}

/*
SDL.Event.toMouseMotionEventData (s : @& SDL_Event) : (UInt32 × UInt32 × UInt32 × UInt32 × UInt32 × UInt32 × UInt32 × UInt32)
*/
lean_obj_res lean_sdl_event_to_mouse_motion_event_data(lean_obj_arg s) {
  SDL_Event * event = lean_get_external_data(s);
  lean_object * tuple = lean_mk_tuple2(
    lean_box(event->motion.timestamp),
    lean_mk_tuple2(lean_box(event->motion.windowID),
    lean_mk_tuple2(lean_box(event->motion.which),
    lean_mk_tuple2(lean_box(event->motion.state),
    lean_mk_tuple2(lean_box((uint32_t) event->motion.x),
    lean_mk_tuple2(lean_box((uint32_t) event->motion.y),
    lean_mk_tuple2(lean_box((uint32_t) event->motion.xrel),
    lean_box((uint32_t) event->motion.yrel)
  )))))));

  return tuple;
}

/*
SDL.Event.toMouseButtonEventData (s : @& SDL_Event) : (UInt32 × UInt32 × UInt32 × UInt8 × UInt8 × UInt8 × UInt32 × UInt32)
*/
lean_obj_res lean_sdl_event_to_mouse_button_event_data(lean_obj_arg s) {
  SDL_Event * event = lean_get_external_data(s);
  lean_object * tuple = lean_mk_tuple2(
    lean_box(event->button.timestamp),
    lean_mk_tuple2(lean_box(event->button.windowID),
    lean_mk_tuple2(lean_box(event->button.which),
    lean_mk_tuple2(lean_box(event->button.button),
    lean_mk_tuple2(lean_box(event->button.state),
    lean_mk_tuple2(lean_box(event->button.clicks),
    lean_mk_tuple2(lean_box(event->button.x),
    lean_box(event->button.y)
  )))))));

  return tuple;
}

/*
SDL.Event.toMouseWheelEventData (s : @& SDL_Event) : (UInt32 × UInt32 × UInt32 × UInt32 × UInt32 × UInt32)
*/
lean_obj_res lean_sdl_event_to_mouse_wheel_event_data(lean_obj_arg s) {
  SDL_Event * event = lean_get_external_data(s);
  lean_object * tuple = lean_mk_tuple2(
    lean_box(event->wheel.timestamp),
    lean_mk_tuple2(lean_box(event->wheel.windowID),
    lean_mk_tuple2(lean_box(event->wheel.which),
    lean_mk_tuple2(lean_box(event->wheel.x),
    lean_mk_tuple2(lean_box(event->wheel.y),
    lean_box(event->wheel.direction)
  )))));

  return tuple;
}