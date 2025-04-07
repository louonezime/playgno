package counter

import (
	// "gno.land/p/demo/ufmt"
    "strconv"
)

var count int

func Increment() {
	count++
}

func Decrement() {
	count--
}

func init() {
	count = 0
}

func Render(_ string) string {
    return "Count: " + strconv.Itoa(count)
}
