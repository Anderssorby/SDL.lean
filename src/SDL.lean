
namespace SDL

/-
Dummy type for SDL
-/
constant SDL : Type

@[extern "lean_sdl_init"]
constant init : IO Int

@[extern "lean_sdl_quit"]
constant quit : IO Unit

@[extern "lean_sdl_get_error"]
constant getError : IO String

constant WindowP : PointedType

def Window := WindowP.type

instance : Inhabited Window := ⟨WindowP.val⟩

@[extern "lean_sdl_create_window"]
constant createWindow : (name : String) → (height : UInt32) → (width : UInt32) → IO Window

/-
After this the window can no longer be used.
-/
@[extern "lean_sdl_destroy_window"]
constant destroyWindow : (r : @& Window) → IO Unit


constant RendererP : PointedType

def Renderer := RendererP.type

instance : Inhabited Renderer := ⟨RendererP.val⟩

@[extern "lean_sdl_create_renderer"]
constant createRenderer : (w : @& Window) → IO Renderer

/-
After this the renderer can no longer be used.
-/
@[extern "lean_sdl_destroy_renderer"]
constant destroyRenderer : (r : @& Renderer) → IO Unit


constant SurfaceP : PointedType

def Surface := SurfaceP.type

instance : Inhabited Surface := ⟨SurfaceP.val⟩

@[extern "lean_sdl_load_bmp"]
constant loadBMP : (file : @& String) → IO Surface

/-
Load an image as a surface.

IMG_Load() from SDL_image.
-/
@[extern "lean_sdl_load_image"]
constant loadImage : (file : @& String) → IO Surface

/-
Manually free a surface. This is done automatically otherwise.
-/
@[extern "lean_sdl_free_surface"]
constant freeSurface : (s : @& Surface) → IO Unit

constant TextureP : PointedType

def Texture := TextureP.type

instance : Inhabited Texture := ⟨TextureP.val⟩

@[extern "lean_sdl_create_texture_from_surface"]
constant createTextureFromSurface : (r: @& Renderer) → (s : @& Surface) → IO Texture

/-
After this the texture can no longer be used.
-/
@[extern "lean_sdl_destroy_texture"]
constant destroyTexture : (t : @& Texture) → IO Unit

structure Rect where
  x : UInt32
  y : UInt32
  h : UInt32
  w : UInt32

structure Point where
  x : UInt32
  y : UInt32

constant SDL_RectP : PointedType

def SDL_Rect := SDL_RectP.type

instance : Inhabited SDL_Rect := ⟨SDL_RectP.val⟩

@[extern "lean_sdl_mk_sdl_rect"]
def mkSDL_Rect (x y w h : UInt32) : SDL_Rect := SDL_RectP.val

@[extern "lean_sdl_rect_null"]
constant SDL_Rect_NULL (u : Unit) : SDL_Rect

def toSDL_Rect (r : Rect) : SDL_Rect :=
  mkSDL_Rect r.x r.y r.w r.w

constant SDL_PointP : PointedType

def SDL_Point := SDL_PointP.type

instance : Inhabited SDL_Point := ⟨SDL_PointP.val⟩

@[extern "lean_sdl_mk_sdl_point"]
constant mkSDL_Point (x y : UInt32) : SDL_Point

def toSDL_Point (p : Point) : SDL_Point :=
  mkSDL_Point p.x p.y

@[extern "lean_sdl_render_copy"]
private def renderCopyNative (r: @& Renderer) (t : @& Texture) (src dest : @& SDL_Rect) : IO Unit := ()

def renderCopy (r: @& Renderer) (t : @& Texture) (src dest : @& Option Rect := none) : IO Unit :=
  let s := if let some r := src then
    toSDL_Rect r
  else
    SDL_Rect_NULL ()
  let d := if let some r := dest then
    toSDL_Rect r
  else
    SDL_Rect_NULL ()
  renderCopyNative r t s d

@[extern "lean_sdl_render_present"]
constant renderPresent : (r: @& Renderer) → IO Unit

structure Color where
  r : UInt8
  g : UInt8
  b : UInt8
  a : UInt8

@[extern "lean_sdl_set_render_draw_color"]
def setRenderDrawColor (r: @& Renderer) (r g b a : UInt8) : IO Unit := ()

/-
Pause thread for ms milliseconds.
-/
@[extern "lean_sdl_delay"]
constant delay : (ms : UInt32) → IO Unit
