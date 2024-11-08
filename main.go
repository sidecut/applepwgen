package main

import (
	"math/rand/v2"
)

var (
	vowels     = []rune("aeiouy")
	consonants = []rune("bcdfghjklmnpqrstvwxz")
)

func main() {
	password := generatePassword()

	println(string(password))
}

func generatePassword() []rune {
	pwd18 := make([]rune, 18)
	for i := 0; i < len(pwd18); i++ {
		// if i%7 == 6 {
		// 	password[i] = '-'
		// } else
		if i%2 == 0 {
			pwd18[i] = consonants[rand.IntN(len(consonants))]
		} else {
			pwd18[i] = vowels[rand.IntN(len(vowels))]
		}
	}

	// Add a number at a random position
	position := rand.IntN(len(pwd18))
	pwd18[position] = rune('0' + rand.IntN(10))

	// Add an uppercase letter at a random position
	position = rand.IntN(len(pwd18))
	pwd18[position] = rune('A' + rand.IntN(26))

	// Now format with dashes
	pwd20 := make([]rune, 20)
	for s, d := 0, 0; s < len(pwd18); s, d = s+1, d+1 {
		if d%7 == 6 {
			pwd20[d] = '-'
			d++
		}
		pwd20[d] = pwd18[s]
	}

	return pwd20
}
