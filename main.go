package main

import (
	"math/rand"
	"strings"
	"time"
)

// generateAppleStylePassword creates an easy-to-pronounce password similar to Apple's style
// with alternating consonants and vowels, followed by numbers
func generateAppleStylePassword(length int) string {
	consonants := []string{"b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "r", "s", "t", "v", "w", "y", "z"}
	vowels := []string{"a", "e", "i", "o", "u"}
	numbers := []string{"2", "3", "4", "5", "6", "7", "8", "9"}

	rand.Seed(time.Now().UnixNano())

	var password strings.Builder
	letterLength := length - 2 // Reserve 2 characters for numbers

	// Alternate between consonants and vowels
	for i := 0; i < letterLength; i++ {
		if i%2 == 0 {
			password.WriteString(consonants[rand.Intn(len(consonants))])
		} else {
			password.WriteString(vowels[rand.Intn(len(vowels))])
		}
	}

	// Add two random numbers at the end
	for i := 0; i < 2; i++ {
		password.WriteString(numbers[rand.Intn(len(numbers))])
	}

	return password.String()
}

func main() {
	// Generate a password with 8 characters (6 letters + 2 numbers)
	password := generateAppleStylePassword(8)
	println(password)
}
