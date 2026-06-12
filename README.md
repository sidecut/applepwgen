# applepwgen

## Build

```bash
swift build             # debug   → .build/debug/applepwgen
swift build -c release  # release → .build/release/applepwgen

# Or via Makefile
make                    # debug build
make release            # release build
make install            # release + install to ~/.bin/applepwgen
make clean              # remove .build/
make uninstall          # remove ~/.bin/applepwgen
```
