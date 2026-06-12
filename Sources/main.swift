// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import SecurityFoundation

@main
struct ApplePasswordGenerator: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "applepwgen",
        abstract: "Generate Apple-style memorable passwords.",
        version: "1.1.0"
    )

    @Option(name: .shortAndLong, help: "Generate <count> passwords")
    var count: Int = 1

    @Flag(name: .shortAndLong, help: "Skip newline after output")
    var skipNewline = false

    @Flag(name: .long, help: "Use simple password style (XXXXX-XXXXX-XXXXs)")
    var simple = false

    func validate() throws {
        guard count >= 1 else {
            throw ValidationError("--count must be at least 1.")
        }
    }

    func run() throws {
        for i in 0..<count {
            let password = simple ? generateSimplePassword() : generatePassword()
            if skipNewline && i == count - 1 {
                print(password, terminator: "")
            } else {
                print(password)
            }
        }
    }
}

// Password generation functions
func randInt(_ n: Int) -> Int {
    precondition(n > 0, "randInt requires positive bound, got \(n)")
    var randomBytes = [UInt8](repeating: 0, count: 1)
    let returnCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
    guard returnCode == errSecSuccess else {
        fatalError("Failed to generate random bytes")
    }
    return Int(randomBytes[0]) % n
}

func generateSimplePassword() -> String {
    let lowercaseLetters = Array("abcdefghijklmnopqrstuvwxyz")
    let digits = Array("0123456789")
    let allChars = lowercaseLetters + digits

    // Generate the pattern (5-5-5)
    var parts = ["", "", ""]
    parts[0] = String((0..<5).map { _ in allChars[randInt(allChars.count)] })
    parts[1] = String((0..<5).map { _ in allChars[randInt(allChars.count)] })
    parts[2] = String((0..<5).map { _ in allChars[randInt(allChars.count)] })

    // Convert to character arrays for manipulation
    var charParts = parts.map { Array($0) }

    // Find all positions that contain letters
    var letterPositions: [(part: Int, pos: Int)] = []
    for (partIndex, part) in charParts.enumerated() {
        for (posIndex, char) in part.enumerated() {
            if char.isLetter {
                letterPositions.append((partIndex, posIndex))
            }
        }
    }

    // Capitalize one random letter if we found any letters
    if !letterPositions.isEmpty {
        let randomLetterPos = letterPositions[randInt(letterPositions.count)]
        charParts[randomLetterPos.part][randomLetterPos.pos] =
            Character(charParts[randomLetterPos.part][randomLetterPos.pos].uppercased())
    }

    // Join parts with hyphens
    return charParts.map { String($0) }.joined(separator: "-")
}

func generatePassword() -> String {
    let vowels = Array("aeiouy")
    let consonants = Array("bcdfghjklmnpqrstvwxz")

    func generateSyllable() -> String {
        let randomConsonant1 = String(consonants[randInt(consonants.count)])
        let randomVowel = String(vowels[randInt(vowels.count)])
        let randomConsonant2 = String(consonants[randInt(consonants.count)])
        return randomConsonant1 + randomVowel + randomConsonant2
    }

    // Generate three parts
    var parts = Array(repeating: "", count: 3)
    for i in 0..<3 {
        parts[i] = generateSyllable() + generateSyllable()
    }

    // Convert parts to arrays of characters for manipulation
    var charParts = parts.map { Array($0) }

    // Insert digit in one of the parts
    let digitPart = randInt(3)
    let digit = String(randInt(10))

    if randInt(2) == 0 && digitPart != 0 {
        // Insert at start (except for first part)
        charParts[digitPart].insert(Character(digit), at: 0)
        charParts[digitPart].removeLast()
    } else {
        // Replace at end
        charParts[digitPart][5] = Character(digit)
    }

    // Capitalize one random letter
    var letterPositions: [(part: Int, pos: Int)] = []
    for (partIndex, part) in charParts.enumerated() {
        for (posIndex, char) in part.enumerated() {
            if char.isLetter {
                letterPositions.append((partIndex, posIndex))
            }
        }
    }
    if !letterPositions.isEmpty {
        let randomLetterPos = letterPositions[randInt(letterPositions.count)]
        charParts[randomLetterPos.part][randomLetterPos.pos] =
            Character(charParts[randomLetterPos.part][randomLetterPos.pos].uppercased())
    }

    // Join parts with hyphens
    return charParts.map { String($0) }.joined(separator: "-")
}
