namespace SDL

inductive Event
  | commonEvent -- common, common event data
  | windowEvent -- window, window event data
  | keyboardEvent -- key, keyboard event data
  | textEditingEvent -- edit, text editing event data
  | textInputEvent -- text, text input event data
  | mouseMotionEvent -- motion, mouse motion event data
  | mouseButtonEvent -- button, mouse button event data
  | mouseWheelEvent -- wheel, mouse wheel event data
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
  | userEvent -- user, custom event data,
  | sysWMEvent -- swm, system dependent window event data
  | touchFingerEvent -- tfinger, touch finger event data
  | multiGestureEvent -- mgesture, multi finger gesture data
  | dollarGestureEvent -- dgesture, multi finger gesture data
  | dropEvent --drop, drag and drop event data

constant SDL_EventP : PointedType

def SDL_Event := SDL_EventP.type

instance : Inhabited SDL_Event := ⟨SDL_EventP.val⟩

@[extern "lean_sdl_poll_event"]
constant pollEvent : IO SDL_Event

namespace Event.Type


-- Application events

@[extern "lean_SDL_QUIT"]
private constant _SDL_QUIT (u : Unit) : UInt32 -- user-requested quit; see Remarks for details
def SDL_QUIT: UInt32 := _SDL_QUIT ()

-- Android, iOS and WinRT events; see Remarks for details

@[extern "lean_SDL_APP_TERMINATING"]
private constant _SDL_APP_TERMINATING (u : Unit) : UInt32 -- OS is terminating the application
def SDL_APP_TERMINATING: UInt32 := _SDL_APP_TERMINATING ()

@[extern "lean_SDL_APP_LOWMEMORY"]
private constant _SDL_APP_LOWMEMORY (u : Unit) : UInt32 -- OS is low on memory; free some
def SDL_APP_LOWMEMORY: UInt32 := _SDL_APP_LOWMEMORY ()

@[extern "lean_SDL_APP_WILLENTERBACKGROUND"]
private constant _SDL_APP_WILLENTERBACKGROUND (u : Unit) : UInt32 -- application is entering background
def SDL_APP_WILLENTERBACKGROUND: UInt32 := _SDL_APP_WILLENTERBACKGROUND ()

@[extern "lean_SDL_APP_DIDENTERBACKGROUND"]
private constant _SDL_APP_DIDENTERBACKGROUND (u : Unit) : UInt32 -- application entered background
def SDL_APP_DIDENTERBACKGROUND: UInt32 := _SDL_APP_DIDENTERBACKGROUND ()

@[extern "lean_SDL_APP_WILLENTERFOREGROUND"]
private constant _SDL_APP_WILLENTERFOREGROUND (u : Unit) : UInt32 -- application is entering foreground
def SDL_APP_WILLENTERFOREGROUND: UInt32 := _SDL_APP_WILLENTERFOREGROUND ()

@[extern "lean_SDL_APP_DIDENTERFOREGROUND"]
private constant _SDL_APP_DIDENTERFOREGROUND (u : Unit) : UInt32 -- application entered foreground
def SDL_APP_DIDENTERFOREGROUND: UInt32 := _SDL_APP_DIDENTERFOREGROUND ()

-- Window events

@[extern "lean_SDL_WINDOWEVENT"]
private constant _SDL_WINDOWEVENT (u : Unit) : UInt32 -- window state change
def SDL_WINDOWEVENT: UInt32 := _SDL_WINDOWEVENT ()

@[extern "lean_SDL_SYSWMEVENT"]
private constant _SDL_SYSWMEVENT (u : Unit) : UInt32 -- system specific event
def SDL_SYSWMEVENT: UInt32 := _SDL_SYSWMEVENT ()

-- Keyboard events

@[extern "lean_SDL_KEYDOWN"]
private constant _SDL_KEYDOWN (u : Unit) : UInt32 -- key pressed
def SDL_KEYDOWN: UInt32 := _SDL_KEYDOWN ()

@[extern "lean_SDL_KEYUP"]
private constant _SDL_KEYUP (u : Unit) : UInt32 -- key released
def SDL_KEYUP: UInt32 := _SDL_KEYUP ()

@[extern "lean_SDL_TEXTEDITING"]
private constant _SDL_TEXTEDITING (u : Unit) : UInt32 -- keyboard text editing (composition)
def SDL_TEXTEDITING: UInt32 := _SDL_TEXTEDITING ()

@[extern "lean_SDL_TEXTINPUT"]
private constant _SDL_TEXTINPUT (u : Unit) : UInt32 -- keyboard text input
def SDL_TEXTINPUT: UInt32 := _SDL_TEXTINPUT ()

@[extern "lean_SDL_KEYMAPCHANGED"]
private constant _SDL_KEYMAPCHANGED (u : Unit) : UInt32 -- keymap changed due to a system event such as an input language or keyboard layout change (>= SDL 2.0.4)
def SDL_KEYMAPCHANGED: UInt32 := _SDL_KEYMAPCHANGED ()

-- Mouse events

@[extern "lean_SDL_MOUSEMOTION"]
private constant _SDL_MOUSEMOTION (u : Unit) : UInt32 -- mouse moved
def SDL_MOUSEMOTION: UInt32 := _SDL_MOUSEMOTION ()

@[extern "lean_SDL_MOUSEBUTTONDOWN"]
private constant _SDL_MOUSEBUTTONDOWN (u : Unit) : UInt32 -- mouse button pressed
def SDL_MOUSEBUTTONDOWN: UInt32 := _SDL_MOUSEBUTTONDOWN ()

@[extern "lean_SDL_MOUSEBUTTONUP"]
private constant _SDL_MOUSEBUTTONUP (u : Unit) : UInt32 -- mouse button released
def SDL_MOUSEBUTTONUP: UInt32 := _SDL_MOUSEBUTTONUP ()

@[extern "lean_SDL_MOUSEWHEEL"]
private constant _SDL_MOUSEWHEEL (u : Unit) : UInt32 -- mouse wheel motion
def SDL_MOUSEWHEEL: UInt32 := _SDL_MOUSEWHEEL ()

-- Joystick events

@[extern "lean_SDL_JOYAXISMOTION"]
private constant _SDL_JOYAXISMOTION (u : Unit) : UInt32 -- joystick axis motion
def SDL_JOYAXISMOTION: UInt32 := _SDL_JOYAXISMOTION ()

@[extern "lean_SDL_JOYBALLMOTION"]
private constant _SDL_JOYBALLMOTION (u : Unit) : UInt32 -- joystick trackball motion
def SDL_JOYBALLMOTION: UInt32 := _SDL_JOYBALLMOTION ()

@[extern "lean_SDL_JOYHATMOTION"]
private constant _SDL_JOYHATMOTION (u : Unit) : UInt32 -- joystick hat position change
def SDL_JOYHATMOTION: UInt32 := _SDL_JOYHATMOTION ()

@[extern "lean_SDL_JOYBUTTONDOWN"]
private constant _SDL_JOYBUTTONDOWN (u : Unit) : UInt32 -- joystick button pressed
def SDL_JOYBUTTONDOWN: UInt32 := _SDL_JOYBUTTONDOWN ()

@[extern "lean_SDL_JOYBUTTONUP"]
private constant _SDL_JOYBUTTONUP (u : Unit) : UInt32 -- joystick button released
def SDL_JOYBUTTONUP: UInt32 := _SDL_JOYBUTTONUP ()

@[extern "lean_SDL_JOYDEVICEADDED"]
private constant _SDL_JOYDEVICEADDED (u : Unit) : UInt32 -- joystick connected
def SDL_JOYDEVICEADDED: UInt32 := _SDL_JOYDEVICEADDED ()

@[extern "lean_SDL_JOYDEVICEREMOVED"]
private constant _SDL_JOYDEVICEREMOVED (u : Unit) : UInt32 -- joystick disconnected
def SDL_JOYDEVICEREMOVED: UInt32 := _SDL_JOYDEVICEREMOVED ()

-- Controller events

@[extern "lean_SDL_CONTROLLERAXISMOTION"]
private constant _SDL_CONTROLLERAXISMOTION (u : Unit) : UInt32 -- controller axis motion
def SDL_CONTROLLERAXISMOTION: UInt32 := _SDL_CONTROLLERAXISMOTION ()

@[extern "lean_SDL_CONTROLLERBUTTONDOWN"]
private constant _SDL_CONTROLLERBUTTONDOWN (u : Unit) : UInt32 -- controller button pressed
def SDL_CONTROLLERBUTTONDOWN: UInt32 := _SDL_CONTROLLERBUTTONDOWN ()

@[extern "lean_SDL_CONTROLLERBUTTONUP"]
private constant _SDL_CONTROLLERBUTTONUP (u : Unit) : UInt32 -- controller button released
def SDL_CONTROLLERBUTTONUP: UInt32 := _SDL_CONTROLLERBUTTONUP ()

@[extern "lean_SDL_CONTROLLERDEVICEADDED"]
private constant _SDL_CONTROLLERDEVICEADDED (u : Unit) : UInt32 -- controller connected
def SDL_CONTROLLERDEVICEADDED: UInt32 := _SDL_CONTROLLERDEVICEADDED ()

@[extern "lean_SDL_CONTROLLERDEVICEREMOVED"]
private constant _SDL_CONTROLLERDEVICEREMOVED (u : Unit) : UInt32 -- controller disconnected
def SDL_CONTROLLERDEVICEREMOVED: UInt32 := _SDL_CONTROLLERDEVICEREMOVED ()

@[extern "lean_SDL_CONTROLLERDEVICEREMAPPED"]
private constant _SDL_CONTROLLERDEVICEREMAPPED (u : Unit) : UInt32 -- controller mapping updated
def SDL_CONTROLLERDEVICEREMAPPED: UInt32 := _SDL_CONTROLLERDEVICEREMAPPED ()

-- Touch events

@[extern "lean_SDL_FINGERDOWN"]
private constant _SDL_FINGERDOWN (u : Unit) : UInt32 -- user has touched input device
def SDL_FINGERDOWN: UInt32 := _SDL_FINGERDOWN ()

@[extern "lean_SDL_FINGERUP"]
private constant _SDL_FINGERUP (u : Unit) : UInt32 -- user stopped touching input device
def SDL_FINGERUP: UInt32 := _SDL_FINGERUP ()

@[extern "lean_SDL_FINGERMOTION"]
private constant _SDL_FINGERMOTION (u : Unit) : UInt32 -- user is dragging finger on input device
def SDL_FINGERMOTION: UInt32 := _SDL_FINGERMOTION ()

-- Gesture events

@[extern "lean_SDL_DOLLARGESTURE"]
private constant _SDL_DOLLARGESTURE (u : Unit) : UInt32
def SDL_DOLLARGESTURE: UInt32 := _SDL_DOLLARGESTURE ()

@[extern "lean_SDL_DOLLARRECORD"]
private constant _SDL_DOLLARRECORD (u : Unit) : UInt32
def SDL_DOLLARRECORD: UInt32 := _SDL_DOLLARRECORD ()

@[extern "lean_SDL_MULTIGESTURE"]
private constant _SDL_MULTIGESTURE (u : Unit) : UInt32 -- Clipboard events
def SDL_MULTIGESTURE: UInt32 := _SDL_MULTIGESTURE ()

@[extern "lean_SDL_CLIPBOARDUPDATE"]
private constant _SDL_CLIPBOARDUPDATE (u : Unit) : UInt32 -- the clipboard changed
def SDL_CLIPBOARDUPDATE: UInt32 := _SDL_CLIPBOARDUPDATE ()

-- Drag and drop events

@[extern "lean_SDL_DROPFILE"]
private constant _SDL_DROPFILE (u : Unit) : UInt32 -- the system requests a file open
def SDL_DROPFILE: UInt32 := _SDL_DROPFILE ()

@[extern "lean_SDL_DROPTEXT"]
private constant _SDL_DROPTEXT (u : Unit) : UInt32 -- text/plain drag-and-drop event
def SDL_DROPTEXT: UInt32 := _SDL_DROPTEXT ()

@[extern "lean_SDL_DROPBEGIN"]
private constant _SDL_DROPBEGIN (u : Unit) : UInt32 -- a new set of drops is beginning (>= SDL 2.0.5)
def SDL_DROPBEGIN: UInt32 := _SDL_DROPBEGIN ()

@[extern "lean_SDL_DROPCOMPLETE"]
private constant _SDL_DROPCOMPLETE (u : Unit) : UInt32 -- current set of drops is now complete (>= SDL 2.0.5)
def SDL_DROPCOMPLETE: UInt32 := _SDL_DROPCOMPLETE ()

-- Audio hotplug events

@[extern "lean_SDL_AUDIODEVICEADDED"]
private constant _SDL_AUDIODEVICEADDED (u : Unit) : UInt32 -- a new audio device is available (>= SDL 2.0.4)
def SDL_AUDIODEVICEADDED: UInt32 := _SDL_AUDIODEVICEADDED ()

@[extern "lean_SDL_AUDIODEVICEREMOVED"]
private constant _SDL_AUDIODEVICEREMOVED (u : Unit) : UInt32 -- an audio device has been removed (>= SDL 2.0.4)
def SDL_AUDIODEVICEREMOVED: UInt32 := _SDL_AUDIODEVICEREMOVED ()

-- Render events

@[extern "lean_SDL_RENDER_TARGETS_RESET"]
private constant _SDL_RENDER_TARGETS_RESET (u : Unit) : UInt32 -- the render targets have been reset and their contents need to be updated (>= SDL 2.0.2)
def SDL_RENDER_TARGETS_RESET: UInt32 := _SDL_RENDER_TARGETS_RESET ()

@[extern "lean_SDL_RENDER_DEVICE_RESET"]
private constant _SDL_RENDER_DEVICE_RESET (u : Unit) : UInt32 -- the device has been reset and all textures need to be recreated (>= SDL 2.0.4)
def SDL_RENDER_DEVICE_RESET: UInt32 := _SDL_RENDER_DEVICE_RESET ()

-- These are for your use, and should be allocated with  SDL_RegisterEvents()

@[extern "lean_SDL_USEREVENT"]
private constant _SDL_USEREVENT (u : Unit) : UInt32 -- a user-specified event
def SDL_USEREVENT: UInt32 := _SDL_USEREVENT ()

@[extern "lean_SDL_LASTEVENT"]
private constant _SDL_LASTEVENT (u : Unit) : UInt32 -- only for bounding internal arrays
def SDL_LASTEVENT: UInt32 := _SDL_LASTEVENT ()

end Event.Type

end SDL