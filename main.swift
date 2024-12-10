import Darwin
import Security

struct Arguments {
    var repeatCount: Int = 1
    var skipNewline: Bool = false
    var showHelp: Bool = false

    init() {
        let args = CommandLine.arguments
        let validFlags = Set(["-n", "-s", "-h", "--help"])

        // Check for help flags or invalid arguments
        for (index, arg) in args.enumerated() {
            if arg.hasPrefix("-") {
                if arg == "-h" || arg == "--help" {
                    showHelp = true
                    break
                } else if !validFlags.contains(arg) {
                    showHelp = true
                    print("Error: Unknown option '\(arg)'")
                    break
                } else if arg == "-n" {
                    if index + 1 >= args.count || Int(args[index + 1]) == nil {
                        showHelp = true
                        print("Error: -n requires a number argument")
                        break
                    }
                }
            }
        }

        // Only parse other arguments if help is not needed
        if !showHelp {
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

    func printHelp() {
        let programName = CommandLine.arguments[0].split(separator: "/").last ?? "program"
        print(
            """
            Usage: \(programName) [options]

            Generate Apple-style memorable passwords.

            Options:
              -n <count>   Generate <count> passwords (default: 1)
              -s           Skip newline after output
              -h, --help   Show this help message

            Example:
              \(programName) -n 5     Generate 5 passwords
              \(programName) -s       Generate 1 password without newline
            """)
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

if args.showHelp {
    args.printHelp()
    exit(1)
}

// Rest of the existing code remains the same
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
