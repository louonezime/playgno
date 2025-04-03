package home

import (
	"gno.land/p/moul/md"
)

func Render(_ string) string {
	out := "# Lou's Home\n\n## "
	out += md.Link("★ Add a rating ★", "/r/lou/ratings")
	return out
}
