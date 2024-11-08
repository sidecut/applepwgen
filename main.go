package main

import (
	"flag"
	"math/rand/v2"
)

var (
	vowels     = []rune("aeiouy")
	consonants = []rune("bcdfghjklmnpqrstvwxz")
	repeat     = flag.Int("n", 1, "Number of non-cryptographically secure passwords to generate")
)

func main() {
	flag.Parse()
	for i := 0; i < *repeat; i++ {
		password := generatePassword()
		println(string(password))
	}
}

// Example:
// 1.  xUvbeh-7giqma-kuspaq
// 2.  dyCraq-0qycvu-buxgog
// 3.  qAktyh-ciwfoz-hywsu0
// 4.  zinpyt-kumgy3-kIfwox
// 5.  piNgof-wyckeb-8zawhy
// 6.  zozcoz-9nezvy-romdEv
// 7.  fibjec-3Birwu-tymzun
// 8.  mybba9-nobzin-vuvcoS
// 9.  pekduk-3sikqa-tizgAm
// 10. sazmyf-muskaX-hyhde1
func generatePassword() string {

	parts := make([][]rune, 3)
	for i := 0; i < 3; i++ {
		parts[i] = []rune(generateSyllable() + generateSyllable())
	}

	// Print the parts
	// fmt.Println(string(parts[0]))
	// fmt.Println(string(parts[1]))
	// fmt.Println(string(parts[2]))

	// Capitalize one letter in one of the parts
	ucasePart := rand.IntN(3)
	ucasePos := rand.IntN(6)
	parts[ucasePart][ucasePos] = parts[ucasePart][ucasePos] - 32

	// Insert digit in one of the parts at either the start or the end
	// But the first blob apparently cannot start with a digit
	digitPart := rand.IntN(3)
	if rand.IntN(2) == 0 && digitPart != 0 {
		// Insert at the start
		parts[digitPart] = append([]rune{rune(rand.IntN(10) + 48)}, parts[digitPart][0:5]...)
	} else {
		// Replace at the end
		parts[digitPart][5] = rune(rand.IntN(10) + 48)
	}

	return string(parts[0]) + "-" + string(parts[1]) + "-" + string(parts[2])
}

func generateSyllable() string {
	// return random consonant + random vowel + random consonant
	return string(consonants[rand.IntN(len(consonants))]) +
		string(vowels[rand.IntN(len(vowels))]) +
		string(consonants[rand.IntN(len(consonants))])
}
