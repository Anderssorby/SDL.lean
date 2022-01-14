import SDL

def main (args : List String) : IO UInt32 := do
  try
    let r ← SDL.init
    if r != 0 then
      IO.eprintln "Error in init"
    let window ← SDL.createWindow "Test" 800 500
    let renderer ← SDL.createRenderer window
    let surf ← SDL.loadBMP "test/pixel-world-map.bmp"
    let tex ← SDL.createTextureFromSurface renderer surf
    SDL.renderCopy renderer tex
    SDL.renderPresent renderer
    SDL.delay 5000
    SDL.destroyWindow window
    SDL.quit
    pure 0
  catch e =>
    IO.eprintln <| "error: " ++ toString e
    IO.eprintln (← SDL.getError)
    pure 1

