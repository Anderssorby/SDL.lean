import SDL
open SDL

def animationTest (debugLog : Bool := false) : IO Unit := do
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
  let mut src := { x := 0, y := 0, w := 128, h := 128 : Rect}
  let dst := { x := 100, y := 100, w := 128, h := 128 : Rect}
  renderer.setDrawColor Color.white
  for i in [0:17] do
    src := { src with x := (i * 128).toUInt32 }
    if debugLog then println! "frame {i} src = {src} dst = {dst}"
    renderer.copy bgrd
    renderer.fillRect (SDL.Rect.mk 50 50 95 93)
    renderer.copy ast (some <| SDL.Rect.mk 0 0 95 93) (some <| SDL.Rect.mk 0 0 95 93)
    renderer.copy explosion (some src) (some dst)
    renderer.present
    SDL.delay 100
  SDL.delay 5000
  SDL.destroyWindow window
  SDL.quit

open Event in
partial def eventTest (debugLog : Bool := false) : IO Unit := do
  let r ← SDL.init
  if r != 0 then
    IO.eprintln "Error in init"
  let window ← SDL.createWindow "Event" 800 500
  let renderer ← SDL.createRenderer window
  let bgrd ← SDL.loadImage "images/green_nebula.png" >>= SDL.createTextureFromSurface renderer 
  let explosion ← SDL.loadImage "images/explosion.png" >>= SDL.createTextureFromSurface renderer
  let ast ← SDL.loadImage "images/asteroid.png" >>= SDL.createTextureFromSurface renderer
  renderer.setDrawColor Color.white
  let rec loop : IO Unit := do
    let mut src := { x := 0, y := 0, w := 128, h := 128 }
    let dst := { x := 100, y := 100, w := 128, h := 128 }
    let mut cont := true
    let event ← Event.next
    match event with
    | some quitEvent => do
      if debugLog then println! "quit event"
      cont := false
    | some (keyboardEvent ke) => do
      if debugLog then println! "keyboard event {ke.timestamp}"
    | some _ => do
      if debugLog then println! "event not catched"
      ()
    | none => do
      if debugLog then println! "no event"
      ()
    for i in [0:17] do
      src := { src with x := (i * 128).toUInt32 }
      -- if debugLog then println! "frame {i} src = {src} dst = {dst}"
      renderer.copy bgrd
      renderer.copy ast (some <| SDL.Rect.mk 0 0 95 93) (some <| SDL.Rect.mk 0 0 95 93)
      renderer.copy explosion (some src) (some dst)
      renderer.present
      SDL.delay 100
    if cont then loop
  loop
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
  renderer.copy tex
  renderer.present
  SDL.delay 5000
  SDL.destroyWindow window
  SDL.quit

def main (args : List String) : IO UInt32 := do
  try
    let test := args.getD 0 "bitmap"
    match test with
    | "bitmap" => bitmapTest
    | "animation" => animationTest (args.contains "-d")
    | "event" => eventTest (args.contains "-d")
    | s => IO.eprintln s!"Unknown test {s}"
    pure 0
  catch e =>
    IO.eprintln <| "error: " ++ toString e
    IO.eprintln (← SDL.getError)
    pure 1
