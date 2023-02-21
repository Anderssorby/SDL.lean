# SDL2 bindings for lean (unfinished)

## Using lake in a nix env

Build with nix and lake `nix develop --command lake build`. Nix provides the external dependencies and environment.

## Using nix

Build with `nix build .`

## Test examples

### Git LFS for test images

Install [git-lfs](https://git-lfs.github.com/) and run `git lfs install && git lfs checkout`.

### Run examples

Run a named test:

* bitmap
* animation
* event (default)

```bash
nix run .#test -- NAME_OF_TEST
```

or with lake

```bash
lake exe Tests NAME_OF_TEST
```
