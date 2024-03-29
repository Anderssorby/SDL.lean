import SDL.Types
namespace SDL

structure KeyboardEvent where
  type : UInt32
  timestamp : UInt32
  windowId : UInt32
  state : UInt32
  repeat_ : UInt32
  scancode : UInt32
  sym : UInt32
  mod : UInt32
  deriving Repr, Inhabited
  
structure MouseMotionEvent where
  timestamp : UInt32
  windowId : UInt32
  which : UInt32
  state : UInt32
  point : Point
  xrel : UInt32
  yrel : UInt32
  deriving Repr, Inhabited

structure MouseButtonEvent where
  type : UInt32
  timestamp : UInt32
  windowId : UInt32
  which : UInt32
  button : UInt8
  state : UInt8
  clicks : UInt8
  point : Point
  deriving Repr, Inhabited

structure MouseWheelEvent where
  timestamp : UInt32
  windowId : UInt32
  which : UInt32
  x : UInt32
  y : UInt32
  direction : UInt32
  deriving Repr, Inhabited

structure UserEvent where
  type : UInt32
  deriving Repr, Inhabited

inductive Event
  | commonEvent -- common, common event data
  | windowEvent -- window, window event data
  | keyboardEvent : KeyboardEvent → Event -- key, keyboard event data
  | textEditingEvent -- edit, text editing event data
  | textInputEvent -- text, text input event data
  | mouseMotionEvent : MouseMotionEvent → Event -- motion, mouse motion event data
  | mouseButtonEvent : MouseButtonEvent → Event -- button, mouse button event data
  | mouseWheelEvent : MouseWheelEvent → Event -- wheel, mouse wheel event data
  | joyAxisEvent -- jaxis, joystick axis event data
  | joyBallEvent -- jball, joystick ball event data
  | joyHatEvent -- jhat, joystick hat event data
  | joyButtonEvent -- jbutton, joystick button event data
  | joyDeviceEvent -- jdevice, joystick device event data
  | controllerAxisEvent -- caxis, game controller axis event data
  | controllerButtonEvent -- cbutton, game controller button event data
  | controllerDeviceEvent -- cdevice, game controller device event data
  | audioDeviceEvent -- adevice, audio device event data (>= SDL 2.0.4)
  | quitEvent -- quit, quit request event data,
  | userEvent : UserEvent → Event -- user, custom event data,
  | sysWMEvent -- swm, system dependent window event data
  | touchFingerEvent -- tfinger, touch finger event data
  | multiGestureEvent -- mgesture, multi finger gesture data
  | dollarGestureEvent -- dgesture, multi finger gesture data
  | dropEvent --drop, drag and drop event data

open Event

instance : ToString Event where
  toString e :=
  match e with
  | commonEvent => "SDL_CommonEvent"   
  | windowEvent => "SDL_WindowEvent"
  | keyboardEvent ke => "SDL_KeyboardEvent"   
  | textEditingEvent => "SDL_TextEditingEvent" 
  | textInputEvent => "SDL_TextInputEvent"
  | mouseMotionEvent mme => "SDL_MouseMotionEvent"
  | mouseButtonEvent _ => "SDL_MouseButton"
  | mouseWheelEvent _ => "SDL_MouseWheelEvent"
  | joyAxisEvent => "SDL_JoyAxisEvent"
  | joyBallEvent => "SDL_JoyBallEvent"
  | joyHatEvent => "SDL_JoyHatEvent"
  | joyButtonEvent => "SDL_JoyButtonEvent"
  | joyDeviceEvent => "SDL_JoyDeviceEvent"
  | controllerAxisEvent => "SDL_ControllerAxisEvent"
  | controllerButtonEvent => "SDL_ControllerButtonEvent"
  | controllerDeviceEvent => "SDL_ControllerDeviceEvent"
  | audioDeviceEvent => "SDL_AudioDeviceEvent"
  | quitEvent => "SDL_QuitEvent"
  | userEvent u => "SDL_UserEvent"
  | sysWMEvent => "SDL_SysWMEvent"
  | touchFingerEvent => "SDL_TouchFingerEvent"
  | multiGestureEvent => "SDL_MultiGestureEvent"
  | dollarGestureEvent => "SDL_DollarGestureEvent"
  | dropEvent => "SDL_DropEvent" 

opaque SDL_EventP : NonemptyType

def SDL_Event := SDL_EventP.type

instance : Nonempty SDL_Event := SDL_EventP.property

@[extern "lean_sdl_poll_event"]
opaque pollEvent : IO (Bool × Option SDL_Event)

namespace Event.Type


-- Application events

@[extern "lean_SDL_QUIT"]
private opaque _SDL_QUIT (u : Unit) : UInt32 -- user-requested quit; see Remarks for details
def SDL_QUIT: UInt32 := _SDL_QUIT ()

-- Android, iOS and WinRT events; see Remarks for details

@[extern "lean_SDL_APP_TERMINATING"]
private opaque _SDL_APP_TERMINATING (u : Unit) : UInt32 -- OS is terminating the application
def SDL_APP_TERMINATING: UInt32 := _SDL_APP_TERMINATING ()

@[extern "lean_SDL_APP_LOWMEMORY"]
private opaque _SDL_APP_LOWMEMORY (u : Unit) : UInt32 -- OS is low on memory; free some
def SDL_APP_LOWMEMORY: UInt32 := _SDL_APP_LOWMEMORY ()

@[extern "lean_SDL_APP_WILLENTERBACKGROUND"]
private opaque _SDL_APP_WILLENTERBACKGROUND (u : Unit) : UInt32 -- application is entering background
def SDL_APP_WILLENTERBACKGROUND: UInt32 := _SDL_APP_WILLENTERBACKGROUND ()

@[extern "lean_SDL_APP_DIDENTERBACKGROUND"]
private opaque _SDL_APP_DIDENTERBACKGROUND (u : Unit) : UInt32 -- application entered background
def SDL_APP_DIDENTERBACKGROUND: UInt32 := _SDL_APP_DIDENTERBACKGROUND ()

@[extern "lean_SDL_APP_WILLENTERFOREGROUND"]
private opaque _SDL_APP_WILLENTERFOREGROUND (u : Unit) : UInt32 -- application is entering foreground
def SDL_APP_WILLENTERFOREGROUND: UInt32 := _SDL_APP_WILLENTERFOREGROUND ()

@[extern "lean_SDL_APP_DIDENTERFOREGROUND"]
private opaque _SDL_APP_DIDENTERFOREGROUND (u : Unit) : UInt32 -- application entered foreground
def SDL_APP_DIDENTERFOREGROUND: UInt32 := _SDL_APP_DIDENTERFOREGROUND ()

-- Window events

@[extern "lean_SDL_WINDOWEVENT"]
private opaque _SDL_WINDOWEVENT (u : Unit) : UInt32 -- window state change
def SDL_WINDOWEVENT: UInt32 := _SDL_WINDOWEVENT ()

@[extern "lean_SDL_SYSWMEVENT"]
private opaque _SDL_SYSWMEVENT (u : Unit) : UInt32 -- system specific event
def SDL_SYSWMEVENT: UInt32 := _SDL_SYSWMEVENT ()

-- Keyboard events

@[extern "lean_SDL_KEYDOWN"]
private opaque _SDL_KEYDOWN (u : Unit) : UInt32 -- key pressed
def SDL_KEYDOWN: UInt32 := _SDL_KEYDOWN ()

@[extern "lean_SDL_KEYUP"]
private opaque _SDL_KEYUP (u : Unit) : UInt32 -- key released
def SDL_KEYUP: UInt32 := _SDL_KEYUP ()

@[extern "lean_SDL_TEXTEDITING"]
private opaque _SDL_TEXTEDITING (u : Unit) : UInt32 -- keyboard text editing (composition)
def SDL_TEXTEDITING: UInt32 := _SDL_TEXTEDITING ()

@[extern "lean_SDL_TEXTINPUT"]
private opaque _SDL_TEXTINPUT (u : Unit) : UInt32 -- keyboard text input
def SDL_TEXTINPUT: UInt32 := _SDL_TEXTINPUT ()

@[extern "lean_SDL_KEYMAPCHANGED"]
private opaque _SDL_KEYMAPCHANGED (u : Unit) : UInt32 -- keymap changed due to a system event such as an input language or keyboard layout change (>= SDL 2.0.4)
def SDL_KEYMAPCHANGED: UInt32 := _SDL_KEYMAPCHANGED ()

-- Mouse events

@[extern "lean_SDL_MOUSEMOTION"]
private opaque _SDL_MOUSEMOTION (u : Unit) : UInt32 -- mouse moved
def SDL_MOUSEMOTION: UInt32 := _SDL_MOUSEMOTION ()

@[extern "lean_SDL_MOUSEBUTTONDOWN"]
private opaque _SDL_MOUSEBUTTONDOWN (u : Unit) : UInt32 -- mouse button pressed
def SDL_MOUSEBUTTONDOWN: UInt32 := _SDL_MOUSEBUTTONDOWN ()

@[extern "lean_SDL_MOUSEBUTTONUP"]
private opaque _SDL_MOUSEBUTTONUP (u : Unit) : UInt32 -- mouse button released
def SDL_MOUSEBUTTONUP: UInt32 := _SDL_MOUSEBUTTONUP ()

@[extern "lean_SDL_MOUSEWHEEL"]
private opaque _SDL_MOUSEWHEEL (u : Unit) : UInt32 -- mouse wheel motion
def SDL_MOUSEWHEEL: UInt32 := _SDL_MOUSEWHEEL ()

-- Joystick events

@[extern "lean_SDL_JOYAXISMOTION"]
private opaque _SDL_JOYAXISMOTION (u : Unit) : UInt32 -- joystick axis motion
def SDL_JOYAXISMOTION: UInt32 := _SDL_JOYAXISMOTION ()

@[extern "lean_SDL_JOYBALLMOTION"]
private opaque _SDL_JOYBALLMOTION (u : Unit) : UInt32 -- joystick trackball motion
def SDL_JOYBALLMOTION: UInt32 := _SDL_JOYBALLMOTION ()

@[extern "lean_SDL_JOYHATMOTION"]
private opaque _SDL_JOYHATMOTION (u : Unit) : UInt32 -- joystick hat position change
def SDL_JOYHATMOTION: UInt32 := _SDL_JOYHATMOTION ()

@[extern "lean_SDL_JOYBUTTONDOWN"]
private opaque _SDL_JOYBUTTONDOWN (u : Unit) : UInt32 -- joystick button pressed
def SDL_JOYBUTTONDOWN: UInt32 := _SDL_JOYBUTTONDOWN ()

@[extern "lean_SDL_JOYBUTTONUP"]
private opaque _SDL_JOYBUTTONUP (u : Unit) : UInt32 -- joystick button released
def SDL_JOYBUTTONUP: UInt32 := _SDL_JOYBUTTONUP ()

@[extern "lean_SDL_JOYDEVICEADDED"]
private opaque _SDL_JOYDEVICEADDED (u : Unit) : UInt32 -- joystick connected
def SDL_JOYDEVICEADDED: UInt32 := _SDL_JOYDEVICEADDED ()

@[extern "lean_SDL_JOYDEVICEREMOVED"]
private opaque _SDL_JOYDEVICEREMOVED (u : Unit) : UInt32 -- joystick disconnected
def SDL_JOYDEVICEREMOVED: UInt32 := _SDL_JOYDEVICEREMOVED ()

-- Controller events

@[extern "lean_SDL_CONTROLLERAXISMOTION"]
private opaque _SDL_CONTROLLERAXISMOTION (u : Unit) : UInt32 -- controller axis motion
def SDL_CONTROLLERAXISMOTION: UInt32 := _SDL_CONTROLLERAXISMOTION ()

@[extern "lean_SDL_CONTROLLERBUTTONDOWN"]
private opaque _SDL_CONTROLLERBUTTONDOWN (u : Unit) : UInt32 -- controller button pressed
def SDL_CONTROLLERBUTTONDOWN: UInt32 := _SDL_CONTROLLERBUTTONDOWN ()

@[extern "lean_SDL_CONTROLLERBUTTONUP"]
private opaque _SDL_CONTROLLERBUTTONUP (u : Unit) : UInt32 -- controller button released
def SDL_CONTROLLERBUTTONUP: UInt32 := _SDL_CONTROLLERBUTTONUP ()

@[extern "lean_SDL_CONTROLLERDEVICEADDED"]
private opaque _SDL_CONTROLLERDEVICEADDED (u : Unit) : UInt32 -- controller connected
def SDL_CONTROLLERDEVICEADDED: UInt32 := _SDL_CONTROLLERDEVICEADDED ()

@[extern "lean_SDL_CONTROLLERDEVICEREMOVED"]
private opaque _SDL_CONTROLLERDEVICEREMOVED (u : Unit) : UInt32 -- controller disconnected
def SDL_CONTROLLERDEVICEREMOVED: UInt32 := _SDL_CONTROLLERDEVICEREMOVED ()

@[extern "lean_SDL_CONTROLLERDEVICEREMAPPED"]
private opaque _SDL_CONTROLLERDEVICEREMAPPED (u : Unit) : UInt32 -- controller mapping updated
def SDL_CONTROLLERDEVICEREMAPPED: UInt32 := _SDL_CONTROLLERDEVICEREMAPPED ()

-- Touch events

@[extern "lean_SDL_FINGERDOWN"]
private opaque _SDL_FINGERDOWN (u : Unit) : UInt32 -- user has touched input device
def SDL_FINGERDOWN: UInt32 := _SDL_FINGERDOWN ()

@[extern "lean_SDL_FINGERUP"]
private opaque _SDL_FINGERUP (u : Unit) : UInt32 -- user stopped touching input device
def SDL_FINGERUP: UInt32 := _SDL_FINGERUP ()

@[extern "lean_SDL_FINGERMOTION"]
private opaque _SDL_FINGERMOTION (u : Unit) : UInt32 -- user is dragging finger on input device
def SDL_FINGERMOTION: UInt32 := _SDL_FINGERMOTION ()

-- Gesture events

@[extern "lean_SDL_DOLLARGESTURE"]
private opaque _SDL_DOLLARGESTURE (u : Unit) : UInt32
def SDL_DOLLARGESTURE: UInt32 := _SDL_DOLLARGESTURE ()

@[extern "lean_SDL_DOLLARRECORD"]
private opaque _SDL_DOLLARRECORD (u : Unit) : UInt32
def SDL_DOLLARRECORD: UInt32 := _SDL_DOLLARRECORD ()

@[extern "lean_SDL_MULTIGESTURE"]
private opaque _SDL_MULTIGESTURE (u : Unit) : UInt32 -- Clipboard events
def SDL_MULTIGESTURE: UInt32 := _SDL_MULTIGESTURE ()

@[extern "lean_SDL_CLIPBOARDUPDATE"]
private opaque _SDL_CLIPBOARDUPDATE (u : Unit) : UInt32 -- the clipboard changed
def SDL_CLIPBOARDUPDATE: UInt32 := _SDL_CLIPBOARDUPDATE ()

-- Drag and drop events

@[extern "lean_SDL_DROPFILE"]
private opaque _SDL_DROPFILE (u : Unit) : UInt32 -- the system requests a file open
def SDL_DROPFILE: UInt32 := _SDL_DROPFILE ()

@[extern "lean_SDL_DROPTEXT"]
private opaque _SDL_DROPTEXT (u : Unit) : UInt32 -- text/plain drag-and-drop event
def SDL_DROPTEXT: UInt32 := _SDL_DROPTEXT ()

@[extern "lean_SDL_DROPBEGIN"]
private opaque _SDL_DROPBEGIN (u : Unit) : UInt32 -- a new set of drops is beginning (>= SDL 2.0.5)
def SDL_DROPBEGIN: UInt32 := _SDL_DROPBEGIN ()

@[extern "lean_SDL_DROPCOMPLETE"]
private opaque _SDL_DROPCOMPLETE (u : Unit) : UInt32 -- current set of drops is now complete (>= SDL 2.0.5)
def SDL_DROPCOMPLETE: UInt32 := _SDL_DROPCOMPLETE ()

-- Audio hotplug events

@[extern "lean_SDL_AUDIODEVICEADDED"]
private opaque _SDL_AUDIODEVICEADDED (u : Unit) : UInt32 -- a new audio device is available (>= SDL 2.0.4)
def SDL_AUDIODEVICEADDED: UInt32 := _SDL_AUDIODEVICEADDED ()

@[extern "lean_SDL_AUDIODEVICEREMOVED"]
private opaque _SDL_AUDIODEVICEREMOVED (u : Unit) : UInt32 -- an audio device has been removed (>= SDL 2.0.4)
def SDL_AUDIODEVICEREMOVED: UInt32 := _SDL_AUDIODEVICEREMOVED ()

-- Render events

@[extern "lean_SDL_RENDER_TARGETS_RESET"]
private opaque _SDL_RENDER_TARGETS_RESET (u : Unit) : UInt32 -- the render targets have been reset and their contents need to be updated (>= SDL 2.0.2)
def SDL_RENDER_TARGETS_RESET: UInt32 := _SDL_RENDER_TARGETS_RESET ()

@[extern "lean_SDL_RENDER_DEVICE_RESET"]
private opaque _SDL_RENDER_DEVICE_RESET (u : Unit) : UInt32 -- the device has been reset and all textures need to be recreated (>= SDL 2.0.4)
def SDL_RENDER_DEVICE_RESET: UInt32 := _SDL_RENDER_DEVICE_RESET ()

-- These are for your use, and should be allocated with  SDL_RegisterEvents()

@[extern "lean_SDL_USEREVENT"]
private opaque _SDL_USEREVENT (u : Unit) : UInt32 -- a user-specified event
def SDL_USEREVENT: UInt32 := _SDL_USEREVENT ()

@[extern "lean_SDL_LASTEVENT"]
private opaque _SDL_LASTEVENT (u : Unit) : UInt32 -- only for bounding internal arrays
def SDL_LASTEVENT: UInt32 := _SDL_LASTEVENT ()

end Event.Type

@[extern "lean_sdl_event_type"]
opaque SDL_Event.type (s : @& SDL_Event) : UInt32

/-
Extract a tuple of the fields of the SDL_KeyboardEvent.
Returns (timestamp, windowId, state, repeat, scancode, sym, mod).
-/
@[extern "lean_sdl_event_to_keyboard_event_data"]
protected opaque SDL_Event.toKeyboardEventData (s : @& SDL_Event) : (UInt32 × UInt32 × UInt32 × UInt32 × UInt32 × UInt32 × UInt32)

/-
Extract a tuple of the fields of the SDL_MouseMotionEvent.
Returns (timestamp, windowId, which, state, x, y, xrel, yrel).
-/
@[extern "lean_sdl_event_to_mouse_motion_event_data"]
protected opaque SDL_Event.toMouseMotionEventData (s : @& SDL_Event) : (UInt32 × UInt32 × UInt32 × UInt32 × UInt32 × UInt32 × UInt32 × UInt32)

/-
Extract a tuple of the fields of the SDL_MouseButtonEvent.
Returns (timestamp, windowId, which, button, state, clicks, x, y).
-/
@[extern "lean_sdl_event_to_mouse_button_event_data"]
protected opaque SDL_Event.toMouseButtonEventData (s : @& SDL_Event) : (UInt32 × UInt32 × UInt32 × UInt8 × UInt8 × UInt8 × UInt32 × UInt32)

/-
Extract a tuple of the fields of the SDL_MouseWheelEvent.
Returns (timestamp, windowId, which, x, y, direction).
-/
@[extern "lean_sdl_event_to_mouse_wheel_event_data"]
protected opaque SDL_Event.toMouseWheelEventData (s : @& SDL_Event) : (UInt32 × UInt32 × UInt32 × UInt32 × UInt32 × UInt32)

open Event.Type in
def SDL_Event.toEvent (s : SDL_Event) : Event :=
  let type := s.type
  if type = SDL_QUIT then
    Event.quitEvent
  else if type = SDL_KEYDOWN ∨ type = SDL_KEYUP then
    let (timestamp, windowId, state, repeat_, scancode, sym, mod) := s.toKeyboardEventData
    Event.keyboardEvent { type, windowId, state, repeat_, scancode, sym, mod, timestamp : KeyboardEvent }
  else if type = SDL_MOUSEMOTION then
    let (timestamp, windowId, which, state, x, y, xrel, yrel) := s.toMouseMotionEventData
    Event.mouseMotionEvent { timestamp, windowId, which, state, point := { x, y : Point}, xrel, yrel : MouseMotionEvent }
  else if type = SDL_MOUSEBUTTONDOWN ∨ type = SDL_MOUSEBUTTONUP then
    let (timestamp, windowId, which, button, state, clicks, x, y) := s.toMouseButtonEventData
    Event.mouseButtonEvent { type, timestamp, windowId, which, button, state, clicks, point := {x, y} : MouseButtonEvent }
  else if type = SDL_MOUSEWHEEL then
    let (timestamp, windowId, which, x, y, direction) := s.toMouseWheelEventData
    Event.mouseWheelEvent { timestamp, windowId, which, x, y, direction : MouseWheelEvent }
  else if type = SDL_AUDIODEVICEADDED ∨ type = SDL_AUDIODEVICEREMOVED then
    Event.audioDeviceEvent
  else if type = SDL_CONTROLLERAXISMOTION then
    Event.controllerAxisEvent
  else if type = SDL_CONTROLLERBUTTONDOWN ∨ type = SDL_CONTROLLERBUTTONUP then
    Event.controllerButtonEvent
  else if type = SDL_CONTROLLERDEVICEADDED
    ∨ type = SDL_CONTROLLERDEVICEREMOVED
    ∨ type = SDL_CONTROLLERDEVICEREMAPPED then
    Event.controllerDeviceEvent
  else if type = SDL_DOLLARGESTURE ∨ type = SDL_DOLLARRECORD then
    Event.dollarGestureEvent
  else if type = SDL_DROPFILE
    ∨ type = SDL_DROPTEXT
    ∨ type = SDL_DROPBEGIN
    ∨ type = SDL_DROPCOMPLETE then
    Event.dropEvent
  else if type = SDL_FINGERMOTION
    ∨ type = SDL_FINGERDOWN
    ∨ type = SDL_FINGERUP then
    Event.touchFingerEvent
  else if type = SDL_JOYAXISMOTION then
    Event.joyAxisEvent
  else if type = SDL_JOYBALLMOTION then
    Event.joyBallEvent
  else if type = SDL_JOYHATMOTION then
    Event.joyHatEvent
  else if type = SDL_JOYBUTTONDOWN ∨ type = SDL_JOYBUTTONUP then
    Event.joyButtonEvent
  else if type = SDL_JOYDEVICEADDED ∨ type = SDL_JOYDEVICEREMOVED then
    Event.joyDeviceEvent
  else if type = SDL_MULTIGESTURE then
    Event.multiGestureEvent
  else if type = SDL_SYSWMEVENT then
    Event.sysWMEvent
  else if type = SDL_TEXTEDITING then
    Event.textEditingEvent
  else if type = SDL_TEXTINPUT then
    Event.textInputEvent
  else if type = SDL_WINDOWEVENT then
    Event.windowEvent
  else
    Event.userEvent { type : UserEvent }

/-
Handle the current queue of Event.
-/
partial def Event.processEventQueue {M : Type → Type} [MonadLift IO M] [Monad M]
    (handleEvent : Event → M Unit) : M Unit := do
  let rec loop : M Unit := do
    let (hasNext, opt_sdl_event) ← liftM SDL.pollEvent
    if let some sdl_event := opt_sdl_event then
      handleEvent sdl_event.toEvent
      if hasNext then
        loop
  loop

end SDL