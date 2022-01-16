import SDL

def animationTest : IO Unit := do
  let r ← SDL.init
  if r != 0 then
    IO.eprintln "Error in init"
  let window ← SDL.createWindow "Animation" 800 500
  let renderer ← SDL.createRenderer window
  let surf ← SDL.loadBMP "images/green_nebula.bmp"
  let bgrd ← SDL.createTextureFromSurface renderer surf
  let ex ← SDL.loadImage "images/explosion.png"
  let explosion ← SDL.createTextureFromSurface renderer ex
  SDL.renderCopy renderer bgrd none none
  let mut src := SDL.toSDL_Rect { x := 0, y := 0, w := 128, h := 128 }
  let mut dst := SDL.toSDL_Rect { x := 100, y := 100, w := 128, h := 128 }
  SDL.renderCopy renderer explosion (some src) (some dst)
  SDL.renderPresent renderer
  SDL.delay 5000
  SDL.destroyWindow window
  SDL.quit
  
def bitmapTest : IO Unit := do
  let r ← SDL.init
  if r != 0 then
    IO.eprintln "Error in init"
  let window ← SDL.createWindow "Test" 800 500
  let renderer ← SDL.createRenderer window
  let surf ← SDL.loadBMP "images/green_nebula.bmp"
  let tex ← SDL.createTextureFromSurface renderer surf
  SDL.renderCopy renderer tex
  SDL.renderPresent renderer
  SDL.delay 5000
  SDL.destroyWindow window
  SDL.quit

def main (args : List String) : IO UInt32 := do
  try
    let test := args.getD 0 "bitmap"
    match test with
    | "bitmap" => bitmapTest
    | "animation" => animationTest
    | s => IO.eprintln s!"Unknown test {s}"
    pure 0
  catch e =>
    IO.eprintln <| "error: " ++ toString e
    IO.eprintln (← SDL.getError)
    pure 1
