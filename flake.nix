{
  description = "SDL2 bindings for Lean";

  inputs = {
    lean = {
      url = "github:leanprover/lean4";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils = {
      url = "github:yatima-inc/nix-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = { self, lean, utils, nixpkgs, flake-utils }:
    let
      supportedSystems = [
        # "aarch64-linux"
        # "aarch64-darwin"
        "i686-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      inherit (utils) lib;
    in
    flake-utils.lib.eachSystem supportedSystems (system:
      let
        leanPkgs = lean.packages.${system};
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (lib.${system}) buildCLib concatStringsSep makeOverridable filter;
        includes = [
          "${pkgs.SDL2.dev}/include"
          "${pkgs.SDL2.dev}/include/SDL2"
          "${pkgs.SDL2_ttf}/include"
          #"${pkgs.SDL2_net.dev}/include"
          "${pkgs.SDL2_gfx}/include"
          "${pkgs.SDL2_mixer}/include"
          "${pkgs.SDL2_image}/include"
          "${leanPkgs.lean-bin-tools-unwrapped}/include"
        ];
        INCLUDE_PATH = concatStringsSep ":" includes;
        libs = [
          "${pkgs.SDL2.out}/lib" "${pkgs.SDL2_image.out}/lib"
        ];
        LD_LIBRARY_PATH = concatStringsSep ":" libs;
        libSDL2 = pkgs.SDL2.out // {
          name = "lib/libSDL2.so";
          linkName = "SDL2";
          libName = "libSDL2.so";
          __toString = d: "${pkgs.SDL2.out}/lib";
        };
        libSDL2_image = pkgs.SDL2_image // {
          name = "lib/libSDL2_image.so";
          linkName = "SDL2_image";
          libName = "libSDL2_image.so";
          __toString = d: "${pkgs.SDL2_image}/lib";
        };
        hasPrefix =
          # Prefix to check for
          prefix:
          # Input string
          content:
          let
            lenPrefix = builtins.stringLength prefix;
          in
          prefix == builtins.substring 0 lenPrefix content;
        sharedLibDeps = [ libSDL2 libSDL2_image ];
        c-shim = buildCLib {
          updateCCOptions = d: d ++ (map (i: "-I${i}") includes);
          name = "lean-SDL2-bindings";
          sourceFiles = [ "bindings/*.c" ];
          # sharedLibDeps = [
          #   libSDL2_image
          #   libSDL2
          # ];
          src = builtins.filterSource
            (path: type: hasPrefix (toString ./. + "/bindings") path) ./.;
          extraDrvArgs = {
            linkName = "lean-SDL2-bindings";
          };
        };
        c-shim-debug = c-shim.override {
          debug = true;
          updateCCOptions = d: d ++ (map (i: "-I${i}") includes) ++ [ "-O0" ];
        };
        name = "SDL";  # must match the name of the top-level .lean file
        project = makeOverridable leanPkgs.buildLeanPackage
          {
            inherit name;
            # linkFlags = [ "-L${libSDL2_image}/lib" "-lSDL2_image" ];
            # Where the lean files are located
            nativeSharedLibs = sharedLibDeps ++ [ c-shim ];
            src = ./src;
          };
        test = makeOverridable leanPkgs.buildLeanPackage
          {
            name = "Tests";
            deps = [ project ];
            # Where the lean files are located
            src = ./test;
          };
        joinDepsDerivations = getSubDrv:
          pkgs.lib.concatStringsSep ":" (map (d: "${getSubDrv d}") ([ ] ++ project.allExternalDeps));
        withGdb = bin: pkgs.writeShellScriptBin "${bin.name}-with-gdb" "${pkgs.gdb}/bin/gdb ${bin}/bin/${bin.name}";
      in
      {
        inherit project test;
        packages = {
          ${name} = project.sharedLib;
          test = test.executable;
          debug-test = (test.overrideArgs {
            debug = true;
            deps =
            [ (project.override {
                nativeSharedLibs = sharedLibDeps ++ [ c-shim-debug ];
              })
            ];
          }).executable // { allowSubstitutes = false; };
          gdb-test = withGdb self.packages.${system}.debug-test;
        };

        checks.test = test.executable;

        defaultPackage = self.packages.${system}.${name};
        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              SDL2
              SDL2_image
              pkg-config
              elan
            ];
            C_INCLUDE_PATH = INCLUDE_PATH;
          };
          lean = pkgs.mkShell {
            inputsFrom = [ project.executable ];
            buildInputs = with pkgs; [
              SDL2
              SDL2_image
              pkg-config
              leanPkgs.lean-dev
            ];
            C_INCLUDE_PATH = INCLUDE_PATH;
          };
        };
      });
}
