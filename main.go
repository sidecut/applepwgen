package main

import (
	"fmt"
	"math/rand"
	"strings"
	"time"
)

// generateApplePassword creates an Apple-style password with:
// - 2 uppercase letters
// - 6 lowercase letters
// - 2 numbers
// - 2 special characters
func generateApplePassword() string {
	const (
		upperChars   = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		lowerChars   = "abcdefghijklmnopqrstuvwxyz"
		numbers      = "0123456789"
		specialChars = "!@#$%^&*"
	)

	rand.Seed(time.Now().UnixNano())

	// Generate components
	upper := make([]string, 2)
	for i := range upper {
		upper[i] = string(upperChars[rand.Intn(len(upperChars))])
	}

	lower := make([]string, 6)
	for i := range lower {
		lower[i] = string(lowerChars[rand.Intn(len(lowerChars))])
	}

	nums := make([]string, 2)
	for i := range nums {
		nums[i] = string(numbers[rand.Intn(len(numbers))])
	}

	special := make([]string, 2)
	for i := range special {
		special[i] = string(specialChars[rand.Intn(len(specialChars))])
	}

	// Combine all parts
	allParts := append(upper, append(lower, append(nums, special...)...)...)

	// Shuffle the combined password
	rand.Shuffle(len(allParts), func(i, j int) {
		allParts[i], allParts[j] = allParts[j], allParts[i]
	})

	return strings.Join(allParts, "")
}

func main() {
	// Generate and print 5 passwords
	for i := 0; i < 5; i++ {
		password := generateApplePassword()
		fmt.Printf("Generated Password %d: %s\n", i+1, password)
	}
}
