package main

import (
	"math/rand"
	"time"
)

func main() {
	A := []rune("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
	B := []rune("abcdefghijklmnopqrstuvwxyz")
	rand.Seed(time.Now().UnixNano())

	result := make([]rune, 18)
	for i := 0; i < 18; i++ {
		if i%2 == 0 {
			result[i] = A[rand.Intn(len(A))]
		} else {
			result[i] = B[rand.Intn(len(B))]
		}
	}

	println(string(result))
}
