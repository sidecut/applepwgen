import Foundation

// Command line arguments handling
struct Arguments {
    var repeatCount: Int = 1
    var skipNewline: Bool = false

    init() {
        let args = CommandLine.arguments
        for (index, arg) in args.enumerated() {
            if arg == "-n" && index + 1 < args.count {
                self.repeatCount = Int(args[index + 1]) ?? 1
            }
            if arg == "-s" {
                self.skipNewline = true
            }
        }
    }
}

let vowels = Array("aeiouy")
let consonants = Array("bcdfghjklmnpqrstvwxz")

func randInt(_ n: Int) -> Int {
    var randomBytes = [UInt8](repeating: 0, count: 1)
    _ = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
    return Int(randomBytes[0]) % n
}

func generateSyllable() -> String {
    let randomConsonant1 = String(consonants[randInt(consonants.count)])
    let randomVowel = String(vowels[randInt(vowels.count)])
    let randomConsonant2 = String(consonants[randInt(consonants.count)])
    return randomConsonant1 + randomVowel + randomConsonant2
}

func generatePassword() -> String {
    // Generate three parts
    var parts = Array(repeating: "", count: 3)
    for i in 0..<3 {
        parts[i] = generateSyllable() + generateSyllable()
    }

    // Convert parts to arrays of characters for manipulation
    var charParts = parts.map { Array($0) }

    // Capitalize one random letter in a random part
    let ucasePart = randInt(3)
    let ucasePos = randInt(6)
    charParts[ucasePart][ucasePos] = Character(charParts[ucasePart][ucasePos].uppercased())

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

    // Join parts with hyphens
    return charParts.map { String($0) }.joined(separator: "-")
}

// Main execution
let args = Arguments()
for _ in 0..<args.repeatCount - 1 {
    print(generatePassword())
}

if args.repeatCount > 0 {
    let password = generatePassword()
    if args.skipNewline {
        print(password, terminator: "")
    } else {
        print(password)
    }
}
