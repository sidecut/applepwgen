package main

import (
	"math/rand/v2"
)

var (
	vowels     = []rune("aeiou")
	consonants = []rune("bcdfghjklmnpqrstvwxyz")
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
	pwd20 := append(append(append(append(pwd18[:6], '-'), pwd18[6:12]...), '-'), pwd18[12:18]...)

	return pwd20
}
