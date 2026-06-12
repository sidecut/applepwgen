# applepwgen

## Build

```bash
swift build             # debug   → .build/debug/applepw
swift build -c release  # release → .build/release/applepw

# Or via Makefile
make                    # debug build
make release            # release build
make install            # release + install to ~/.bin/applepw
make clean              # remove .build/
make uninstall          # remove ~/.bin/applepw
```
