# applepwgen Copilot Instructions

## Build Commands

```bash
swift build                # debug build → .build/debug/applepwgen
swift build -c release     # release build → .build/release/applepwgen
make                       # alias for debug build
make release               # alias for release build
make install               # builds release and installs to ~/.bin/applepwgen
make clean                 # removes .build/
```

There are no tests in this project.

## Architecture

Single-file Swift CLI (`Sources/main.swift`) using [Swift Argument Parser](https://swiftpackageindex.com/apple/swift-argument-parser/documentation). The binary is named `applepwgen`.

**Entry point:** `@main struct ApplePasswordGenerator: ParsableCommand`

**Two password styles:**
- Default: syllable-based memorable passwords — three 6-character parts, each two CVC syllables (`consonant-vowel-consonant`), joined by hyphens. One digit replaces a character in one part; one letter is randomly capitalized.
- `--simple`: random alphanumeric in `XXXXX-XXXXX-XXXXX` pattern with one uppercase letter.

**Randomness:** All randomness uses `SecRandomCopyBytes` from `Security` (cryptographically secure). The `randInt(_:)` helper wraps this for generating a uniform random int in `[0, n)`.

## Key Conventions

- The `randInt` helper uses modulo bias (acceptable for password generation in this context; do not swap it for a different approach without understanding the tradeoff).
- Password parts are always exactly 6 characters after digit insertion — the digit either replaces the last character or is inserted at the start with the last character removed.
