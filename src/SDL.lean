import SDL.Events
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

@[extern "lean_sdl_get_img_error"]
constant getIMGError : IO String

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

def Renderer.loadImageAsTexture (r : Renderer) (file : System.FilePath) : IO Texture := do
  let surf ← loadImage file.toString
  let tex ← createTextureFromSurface r surf
  tex
/-
After this the texture can no longer be used.
-/
@[extern "lean_sdl_destroy_texture"]
constant destroyTexture : (t : @& Texture) → IO Unit

/-
A graphic rectangle with (x, y) in the upper left corner.
-/
structure Rect where
  x : UInt32
  y : UInt32
  h : UInt32
  w : UInt32

instance : ToString Rect := ⟨λ r => s!"Rect [x = {r.x}, y = {r.y}, w = {r.w}, h = {r.h}]"⟩

structure Point where
  x : UInt32
  y : UInt32

instance : ToString Point := ⟨λ p => s!"Point [x = {p.x}, y = {p.y}]"⟩

constant SDL_RectP : PointedType

def SDL_Rect := SDL_RectP.type

instance : Inhabited SDL_Rect := ⟨SDL_RectP.val⟩

@[extern "lean_sdl_mk_sdl_rect"]
def mkSDL_Rect (x y w h : UInt32) : SDL_Rect := SDL_RectP.val

def Rect.toSDL_Rect (r : Rect) : SDL_Rect :=
  mkSDL_Rect r.x r.y r.w r.w

constant SDL_PointP : PointedType

def SDL_Point := SDL_PointP.type

instance : Inhabited SDL_Point := ⟨SDL_PointP.val⟩

@[extern "lean_sdl_mk_sdl_point"]
constant mkSDL_Point (x y : UInt32) : SDL_Point

def Point.toSDL_Point (p : Point) : SDL_Point :=
  mkSDL_Point p.x p.y

@[extern "lean_sdl_render_copy"]
def renderCopy (r: @& Renderer) (t : @& Texture) (src dest : @& Option SDL_Rect := none) : IO Unit := ()

def Renderer.copy (r: Renderer) (t : Texture) (src dest : Option Rect := none) : IO Unit :=
  renderCopy r t (Rect.toSDL_Rect <$> src) (Rect.toSDL_Rect <$> dest)

@[extern "lean_sdl_render_fill_rect"]
def renderFillRect (r: @& Renderer) (rect : @& SDL_Rect) : IO Unit := ()

def Renderer.fillRect (r: Renderer) (rect : Rect) : IO Unit :=
  renderFillRect r rect.toSDL_Rect

@[extern "lean_sdl_render_draw_rect"]
def renderDrawRect (r: @& Renderer) (rect : @& SDL_Rect) : IO Unit := ()

/-
Display the result of previous commands.
-/
@[extern "lean_sdl_render_present"]
constant renderPresent : (r: @& Renderer) → IO Unit

def Renderer.present (r : Renderer) : IO Unit := renderPresent r

/-
Clear the renderer with the current draw color.
-/
@[extern "lean_sdl_render_clear"]
constant renderClear : (r: @& Renderer) → IO Unit

structure Color where
  r : UInt8
  g : UInt8
  b : UInt8
  a : UInt8 := 255

namespace Color

def white  := { r:=255, g:=255, b:=255, a:=255 : Color }
def red  := { r:=255, g:=0, b:=0, a:=255 : Color }
def green  := { r:=0, g:=255, b:=0, a:=255 : Color }
def blue  := { r:=0, g:=0, b:=255, a:=255 : Color }
def yellow  := { r:=0, g:=255, b:=255, a:=255 : Color }
def black  := { r:=0, g:=0, b:=0, a:=255 : Color }
def transparent  := { r:=0, g:=0, b:=0, a:=0 : Color }

end Color

@[extern "lean_sdl_set_render_draw_color"]
def setRenderDrawColor (r: @& Renderer) (r g b a : UInt8) : IO Unit := ()

def Renderer.setDrawColor (r: Renderer) (c : Color) : IO Unit :=
  setRenderDrawColor r c.r c.g c.b c.a

/-
Pause thread for ms milliseconds.
-/
@[extern "lean_sdl_delay"]
constant delay : (ms : UInt32) → IO Unit
