import SDL

def main (args : List String) : IO UInt32 := do
  try
    let r ← SDL.init
    if r != 0 then
      IO.eprintln "Error in init"
    else
      println! "init with {r}"
    let window ← SDL.createWindow "Test"
    pure 0
  catch e =>
    IO.eprintln <| "error: " ++ toString e -- avoid "uncaught exception: ..."
    IO.eprintln <| (← SDL.getError)
    pure 1

