import ArgumentParser
import SecurityFoundation

struct ApplePasswordGenerator: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "applepwgen",
        abstract: "Generate Apple-style memorable passwords.",
        version: "1.0.0"
    )

    @Option(name: .shortAndLong, help: "Generate <count> passwords")
    var count: Int = 1

    @Flag(name: .shortAndLong, help: "Skip newline after output")
    var skipNewline = false

    @Flag(name: .long, help: "Use simple password style (XXXXX-XXXXX-XXXX)")
    var simple = false

    func run() throws {
        // Generate all passwords except the last one
        for _ in 0..<count - 1 {
            print(simple ? generateSimplePassword() : generatePassword())
        }

        // Generate and print the last password
        if count > 0 {
            let password = simple ? generateSimplePassword() : generatePassword()
            if skipNewline {
                print(password, terminator: "")
            } else {
                print(password)
            }
        }
    }
}

// Password generation functions
func randInt(_ n: Int) -> Int {
    var randomBytes = [UInt8](repeating: 0, count: 1)
    _ = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
    return Int(randomBytes[0]) % n
}

func generateSimplePassword() -> String {
    let lowercaseLetters = Array("abcdefghijklmnopqrstuvwxyz")
    let digits = Array("0123456789")
    let allChars = lowercaseLetters + digits

    // Generate the pattern (5-5-4)
    var parts = ["", "", ""]
    parts[0] = String((0..<5).map { _ in allChars[randInt(allChars.count)] })
    parts[1] = String((0..<5).map { _ in allChars[randInt(allChars.count)] })
    parts[2] = String((0..<4).map { _ in allChars[randInt(allChars.count)] })

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

    // Capitalize one random letter in a random part
    while true {
        let ucasePart = randInt(3)
        let ucasePos = randInt(6)

        // continue if the character is not a letter
        guard charParts[ucasePart][ucasePos].isLetter else {
            continue
        }

        charParts[ucasePart][ucasePos] = Character(charParts[ucasePart][ucasePos].uppercased())
        break
    }

    // Join parts with hyphens
    return charParts.map { String($0) }.joined(separator: "-")
}

ApplePasswordGenerator.main()
