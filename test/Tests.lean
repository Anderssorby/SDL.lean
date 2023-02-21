import SDL
open SDL

def animationTest (debugLog : Bool := false) : IO Unit := do
  let r ← SDL.init
  if r != 0 then
    IO.eprintln "Error in init"
    return
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

structure Data where
  cont : Bool := true
  point : Point := {x := 0, y := 0}
  debugLog : Bool
  
def SDLTest := StateT Data IO
  deriving Monad, MonadState

instance : MonadLift IO SDLTest := ⟨StateT.lift⟩

open Event in
def handleEvent (event : Event) : SDLTest Unit := do
  let data ← get
  match event with
  | quitEvent => do
    if data.debugLog then println! "quit event"
    modifyGet λ data => ((), {data with cont := false : Data})
  | keyboardEvent ke => do
    if data.debugLog then println! "keyboard event {ke.timestamp}"
  | mouseMotionEvent mme => do
    if data.debugLog then println! "mouse motion event {mme.point}"
    modifyGet λ data => ((), {data with point := mme.point })
  | userEvent e => do
    if data.debugLog then println! "event {e.type}"
  | _ => do
    if data.debugLog then println! "event not catched"

open SDL.Event.Type in
def printCodes : IO Unit := do
  println! "Events:"
  println! "SDL_QUIT = {SDL_QUIT}"
  println! "SDL_MOUSEMOTION = {SDL_MOUSEMOTION}"
  println! "SDL_KEYDOWN = {SDL_KEYDOWN}"

partial def eventTest (debugLog : Bool := false) : IO Unit := do
  let r ← SDL.init
  if r != 0 then
    IO.eprintln "Error in init"
  if debugLog then printCodes
  let window ← SDL.createWindow "Event" 800 500
  let renderer ← SDL.createRenderer window
  let bgrd ← SDL.loadImage "images/green_nebula.png" >>= SDL.createTextureFromSurface renderer 
  let explosion ← SDL.loadImage "images/explosion.png" >>= SDL.createTextureFromSurface renderer
  let ast ← SDL.loadImage "images/asteroid.png" >>= SDL.createTextureFromSurface renderer
  let astR := { x := 0, y := 0, w := 95, h := 93 : Rect }
  renderer.setDrawColor Color.white
  let rec loop : SDLTest Unit := do
    let mut src := { x := 0, y := 0, w := 128, h := 128 }
    let dst := { x := 100, y := 100, w := 128, h := 128 }
    for i in [0:17] do
      Event.processEventQueue handleEvent 
      let data : Data ← get
      if !data.cont then break
      src := { src with x := (i * 128).toUInt32 }
      renderer.copy bgrd
      renderer.copy ast (some astR) (some <| astR.move data.point)
      renderer.copy explosion (some src) (some dst)
      renderer.present
      SDL.delay 100
    if (← get).cont then loop
  let (_, _d) ← loop.run { debugLog : Data }
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
    let test := args.getD 0 "event"
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
