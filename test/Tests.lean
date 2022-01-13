import SDL

def main (args : List String) : IO UInt32 := do
  try
    let r ← SDL.init
    if r != 0 then
      IO.eprintln "Error in init"
    let window ← SDL.createWindow "Test" 500 500
    let renderer ← SDL.createRenderer window
    SDL.delay 5000

    SDL.destroyRenderer renderer
    SDL.destroyWindow window
    SDL.quit
    pure 0
  catch e =>
    IO.eprintln <| "error: " ++ toString e -- avoid "uncaught exception: ..."
    IO.eprintln (← SDL.getError)
    pure 1

