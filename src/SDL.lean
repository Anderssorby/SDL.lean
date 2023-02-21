import SDL.Types
import SDL.Events
namespace SDL

@[extern "lean_sdl_init"]
opaque init : IO Int

@[extern "lean_sdl_quit"]
opaque quit : IO Unit

@[extern "lean_sdl_get_error"]
opaque getError : IO String

@[extern "lean_sdl_get_img_error"]
opaque getIMGError : IO String

private opaque WindowP : NonemptyType

def Window := WindowP.type

instance : Nonempty Window := WindowP.property

@[extern "lean_sdl_create_window"]
opaque createWindow : (name : String) → (height : UInt32) → (width : UInt32) → IO Window

/--
After this the window can no longer be used.
-/
@[extern "lean_sdl_destroy_window"]
opaque destroyWindow : (r : @& Window) → IO Unit


private opaque RendererP : NonemptyType

def Renderer := RendererP.type

instance : Nonempty Renderer := RendererP.property

@[extern "lean_sdl_create_renderer"]
opaque createRenderer : (w : @& Window) → IO Renderer

/--
After this the renderer can no longer be used.
-/
@[extern "lean_sdl_destroy_renderer"]
opaque destroyRenderer : (r : @& Renderer) → IO Unit


private opaque SurfaceP : NonemptyType

def Surface := SurfaceP.type

instance : Nonempty Surface := SurfaceP.property

@[extern "lean_sdl_load_bmp"]
opaque loadBMP : (file : @& String) → IO Surface

/--
Load an image as a surface.

IMG_Load() from SDL_image.
-/
@[extern "lean_sdl_load_image"]
opaque loadImage : (file : @& String) → IO Surface

/--
Manually free a surface. This is done automatically otherwise.
-/
@[extern "lean_sdl_free_surface"]
opaque freeSurface : (s : @& Surface) → IO Unit

private opaque TextureP : NonemptyType

def Texture := TextureP.type

instance : Nonempty Texture := TextureP.property

@[extern "lean_sdl_create_texture_from_surface"]
opaque createTextureFromSurface : (r: @& Renderer) → (s : @& Surface) → IO Texture

def Renderer.loadImageAsTexture (r : Renderer) (file : System.FilePath) : IO Texture := do
  let surf ← loadImage file.toString
  let tex ← createTextureFromSurface r surf
  return tex
/--
After this the texture can no longer be used.
-/
@[extern "lean_sdl_destroy_texture"]
opaque destroyTexture : (t : @& Texture) → IO Unit

private opaque SDL_RectP : NonemptyType

def SDL_Rect := SDL_RectP.type

instance : Nonempty SDL_Rect := SDL_RectP.property

@[extern "lean_sdl_mk_sdl_rect"]
opaque mkSDL_Rect (x y w h : UInt32) : IO SDL_Rect

def Rect.toSDL_Rect (r : Rect) : IO SDL_Rect :=
  mkSDL_Rect r.x r.y r.w r.w

private opaque SDL_PointP : NonemptyType

def SDL_Point := SDL_PointP.type

instance : Nonempty SDL_Point := SDL_PointP.property

@[extern "lean_sdl_mk_sdl_point"]
opaque mkSDL_Point (x y : UInt32) : SDL_Point

def Point.toSDL_Point (p : Point) : SDL_Point :=
  mkSDL_Point p.x p.y

@[extern "lean_sdl_render_copy"]
opaque renderCopy (r: @& Renderer) (t : @& Texture) (src dest : @& Option SDL_Rect := none) : IO Unit

def Renderer.copy (r: Renderer) (t : Texture) (src dest : Option Rect := none) : IO Unit := do
  let src <- Option.mapM Rect.toSDL_Rect src
  let dest <- Option.mapM Rect.toSDL_Rect dest
  renderCopy r t src dest

@[extern "lean_sdl_render_fill_rect"]
opaque renderFillRect (r: @& Renderer) (rect : @& SDL_Rect) : IO Unit

def Renderer.fillRect (r: Renderer) (rect : Rect) : IO Unit := do
  renderFillRect r (<-rect.toSDL_Rect)

@[extern "lean_sdl_render_draw_rect"]
opaque renderDrawRect (r: @& Renderer) (rect : @& SDL_Rect) : IO Unit

/--
Display the result of previous commands.
-/
@[extern "lean_sdl_render_present"]
opaque renderPresent : (r: @& Renderer) → IO Unit

def Renderer.present (r : Renderer) : IO Unit := renderPresent r

/--
Clear the renderer with the current draw color.
-/
@[extern "lean_sdl_render_clear"]
opaque renderClear : (r: @& Renderer) → IO Unit

@[extern "lean_sdl_set_render_draw_color"]
opaque setRenderDrawColor (r: @& Renderer) (r g b a : UInt8) : IO Unit

def Renderer.setDrawColor (r: Renderer) (c : Color) : IO Unit :=
  setRenderDrawColor r c.r c.g c.b c.a

/--
Pause thread for ms milliseconds.
-/
@[extern "lean_sdl_delay"]
opaque delay : (ms : UInt32) → IO Unit
