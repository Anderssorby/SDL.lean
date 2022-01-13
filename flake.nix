{
  description = "SDL2 bindings for Lean";

  inputs = {
    lean = {
      url = github:leanprover/lean4;
    };
    nixpkgs.url = github:nixos/nixpkgs/nixos-21.05;
    utils = {
      url = github:yatima-inc/nix-utils;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, lean, utils, nixpkgs }:
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
    lib.eachSystem supportedSystems (system:
      let
        leanPkgs = lean.packages.${system};
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (lib.${system}) buildCLib concatStringsSep;
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
        libsdl2 = (pkgs.SDL2.out // {
          name = "lib/libSDL2.so";
          linkName = "SDL2";
          libName = "libSDL2.so";
        });
        c-shim = buildCLib {
          updateCCOptions = d: d ++ (map (i: "-I${i}") includes);
          name = "lean-SDL2-bindings";
          sharedLibDeps = [
            libsdl2
          ];
          src = ./bindings;
          extraDrvArgs = {
            linkName = "lean-SDL2-bindings";
          };
        };
        name = "SDL";  # must match the name of the top-level .lean file
        project = leanPkgs.buildLeanPackage
          {
            inherit name;
            # Where the lean files are located
            nativeSharedLibs = [ (libsdl2 // { __toString = d: "${libsdl2}/lib"; }) c-shim ];
            src = ./src;
          };
        test = leanPkgs.buildLeanPackage
          {
            name = "Tests";
            deps = [ project ];
            # Where the lean files are located
            src = ./test;
          };
        joinDepsDerivationns = getSubDrv:
          pkgs.lib.concatStringsSep ":" (map (d: "${getSubDrv d}") ([ project ] ++ project.allExternalDeps));
        withGdb = bin: pkgs.writeShellScriptBin "${bin.name}-with-gdb" "${pkgs.gdb}/bin/gdb ${bin}/bin/${bin.name}";
      in
      {
        inherit project test;
        packages = {
          ${name} = project.sharedLib;
          test = test.executable;
          debug-test = withGdb test.executable;
        };

        checks.test = test.executable;

        defaultPackage = self.packages.${system}.${name};
        devShell = pkgs.mkShell {
          inputsFrom = [ project.executable ];
          buildInputs = with pkgs; [
            leanPkgs.lean
          ];
          LEAN_PATH = joinDepsDerivationns (d: d.modRoot);
          LEAN_SRC_PATH = joinDepsDerivationns (d: d.src);
          C_INCLUDE_PATH = INCLUDE_PATH;
          CPLUS_INCLUDE_PATH = INCLUDE_PATH;
        };
      });
}
