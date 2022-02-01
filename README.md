# SDL2 bindings for lean (unfinished)

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
