import SDL.Types
import SDL.Events
namespace SDL

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

@[extern "lean_sdl_set_render_draw_color"]
def setRenderDrawColor (r: @& Renderer) (r g b a : UInt8) : IO Unit := ()

def Renderer.setDrawColor (r: Renderer) (c : Color) : IO Unit :=
  setRenderDrawColor r c.r c.g c.b c.a

/-
Pause thread for ms milliseconds.
-/
@[extern "lean_sdl_delay"]
constant delay : (ms : UInt32) → IO Unit
