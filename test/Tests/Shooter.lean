import SDL

open SDL
namespace Shooter

structure Data where
  cont : Bool := true
  point : Point := {x := 0, y := 0}
  debugLog : Bool := false
  
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

partial def run (debugLog : Bool := false) : IO Unit := do
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
  let (_, d) ← loop.run { debugLog : Data }
  SDL.destroyWindow window
  SDL.quit

end Shooter
