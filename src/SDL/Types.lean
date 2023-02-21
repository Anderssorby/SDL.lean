namespace SDL

/-
A graphic rectangle with (x, y) in the upper left corner.
-/
structure Rect where
  x : UInt32
  y : UInt32
  h : UInt32
  w : UInt32
  deriving Repr, Inhabited

instance : ToString Rect := ⟨λ r => s!"Rect [x = {r.x}, y = {r.y}, w = {r.w}, h = {r.h}]"⟩

structure Point where
  x : UInt32
  y : UInt32
  deriving Repr, Inhabited
  
def Rect.move (r : Rect) (p : Point) : Rect :=
  {r with x := p.x, y := p.y}

instance : ToString Point := ⟨λ p => s!"Point [x = {p.x}, y = {p.y}]"⟩

structure Color where
  r : UInt8
  g : UInt8
  b : UInt8
  a : UInt8 := 255
  deriving Repr, Inhabited

namespace Color

def white  := { r:=255, g:=255, b:=255, a:=255 : Color }
def red  := { r:=255, g:=0, b:=0, a:=255 : Color }
def green  := { r:=0, g:=255, b:=0, a:=255 : Color }
def blue  := { r:=0, g:=0, b:=255, a:=255 : Color }
def yellow  := { r:=0, g:=255, b:=255, a:=255 : Color }
def black  := { r:=0, g:=0, b:=0, a:=255 : Color }
def transparent  := { r:=0, g:=0, b:=0, a:=0 : Color }

end Color

end SDL
