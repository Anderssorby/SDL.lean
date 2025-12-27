import Lean
import Lake
open Lake DSL

package «SDL» {
  moreLinkArgs := #["-L.lake/build/lib", "-lsdl2-shim", "-lSDL2", "-lSDL2_image"]
  extraDepTargets := #[Lean.Name.mkStr1 "sdl2-shim"]
}

lean_lib «SDL» {
  srcDir := "src"
}

def cDir   := "bindings"
def ffiSrc := "sdl2-shim.c"
def ffiO   := "sdl2-shim.o"
def ffiLib := "sdl2-shim"

target ffi.o pkg : System.FilePath := do
  let oFile := pkg.buildDir / ffiO
  let srcJob ← inputFile (text:=.true) <| pkg.dir / cDir / ffiSrc
  let cflags <- captureProc { cmd := "sdl2-config", args := #["--cflags"]}
  let cflags := cflags.splitOn " "
  buildFileAfterDep oFile srcJob fun srcFile => do
    let flags := #["-I", (← getLeanIncludeDir).toString,
      "-I", (<- IO.getEnv "C_INCLUDE_PATH").getD "", "-fPIC"]
    compileO oFile srcFile (cflags.toArray ++ flags)

target «sdl2-shim» pkg : System.FilePath := do
  let name := nameToStaticLib ffiLib
  let ffiO ← fetch <| pkg.target ``ffi.o
  buildStaticLib (pkg.buildDir / "lib" / name) #[ffiO]

lean_exe Tests {
  root := `test.Tests
}
