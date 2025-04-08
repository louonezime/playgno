package home

import (
	"gno.land/p/moul/md"
	"gno.land/p/moul/txlink"

	"gno.land/p/lou/ascii"
)

func Test(titleS string, descS string) {
	title = titleS;
	desc = descS;
}

func Render(path string) string {
	out := md.H1("Lou's Home\n\n")
	out += md.HorizontalRule()

	out += md.Link("test", txlink.Call("Test", "title", "Here'smytitle", "desc", "Here'smydesc"))
	out += "\n\n"
	out += md.Link("test2", Call("Test", "title", "Here'smytitle", "desc", "Heresmydesc"))
	out += "\n\n"
	out += ascii.Box(title + "\n" + desc)
	out += "\n\n"
	out += title + "\n\n" + desc
	out += "\n\n"
	
	out += RenderRockPaperScissors()
	out += RenderMagic8Ball()
	out += RenderRatings()

	return out
}
