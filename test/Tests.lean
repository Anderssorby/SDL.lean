import SDL

def animationTest : IO Unit := do
  let r ← SDL.init
  if r != 0 then
    IO.eprintln "Error in init"
  let window ← SDL.createWindow "Animation" 800 500
  let renderer ← SDL.createRenderer window
  let surf ← SDL.loadImage "images/green_nebula.png"
  let bgrd ← SDL.createTextureFromSurface renderer surf
  let ex ← SDL.loadImage "images/explosion.png"
  let a ← SDL.loadImage "images/asteroid.png"
  let explosion ← SDL.createTextureFromSurface renderer ex
  let ast ← SDL.createTextureFromSurface renderer a
  let mut src := { x := 0, y := 0, w := 128, h := 128 }
  let dst := { x := 100, y := 100, w := 128, h := 128 }
  let white  := { r:=255, g:=255, b:=255, a:=255 : SDL.Color }
  SDL.setRenderDrawColor renderer white.r white.g white.b white.a
  for i in [0:17] do
    src := { src with x := (i * 128).toUInt32 }
    println! "frame {i} src = {src} dst = {dst}"
    SDL.renderCopy renderer bgrd
    SDL.renderFillRect renderer (SDL.mkSDL_Rect 50 50 95 93)
    SDL.renderCopy renderer ast (some <| SDL.mkSDL_Rect 0 0 95 93) (some <| SDL.mkSDL_Rect 0 0 95 93)
    SDL.renderCopy renderer explosion (some <| SDL.toSDL_Rect src) (some <| SDL.toSDL_Rect dst)
    -- SDL.renderClear renderer
    SDL.renderPresent renderer
    SDL.delay 500
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
