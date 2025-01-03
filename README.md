# applepwgen

## How to build the Swift version (old)

```bash
make            # builds debug version
make release    # builds release version
make install    # installs release version

make clean      # clean the build directory
make uninstall  # uninstalls the release version
```

## How to build the Swift version

```bash
# Use either one
swift build             # will build .build/debug/applepw
swift build -c release  # will build .build/release/applepw
swiftc Sources/main.swift -o applepw    # will build ./applepw
```
