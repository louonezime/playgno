package home

import (
	"gno.land/p/moul/md"
	// "gno.land/p/moul/txlink"
)

func Render(path string) string {
	out := md.H1("Lou's Home\n\n")

	out += RenderRockPaperScissors()
	out += RenderRatings()

	return out
}
