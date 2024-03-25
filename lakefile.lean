import Lake
open Lake DSL

package «SDL» where
  moreLinkArgs := #["-lSDL2", "-lSDL2_image"]

lean_lib «SDL» where
  srcDir := "src"

def cDir   := "bindings"
def ffiSrc := "sdl2-shim.c"
def ffiO   := "sdl2-shim.o"
def ffiLib := "sdl2-shim"

target ffi.o pkg : FilePath := do
  let oFile := pkg.buildDir / ffiO
  let srcJob ← inputFile <| pkg.dir / cDir / ffiSrc
  let weakArgs := #["-I", (← getLeanIncludeDir).toString]
  buildO ffiSrc oFile srcJob weakArgs #["-fPIC"] "cc" getLeanTrace

extern_lib «sdl2-shim» pkg := do
  let name := nameToStaticLib ffiLib
  let ffiO ← fetch <| pkg.target ``ffi.o
  buildStaticLib (pkg.buildDir / name) #[ffiO]

@[default_target] lean_exe Tests where
  root := `test.Tests
