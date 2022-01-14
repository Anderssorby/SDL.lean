
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

@[extern "lean_sdl_render_copy"]
constant renderCopy : (r: @& Renderer) → (t : @& Texture) → IO Unit

@[extern "lean_sdl_render_present"]
constant renderPresent : (r: @& Renderer) → IO Unit

/-
Pause thread for ms milliseconds.
-/
@[extern "lean_sdl_delay"]
constant delay : (ms : UInt32) → IO Unit
