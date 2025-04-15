package collections

import (
	"gno.land/p/moul/md"
	"gno.land/p/moul/mdtable"

    "gno.land/p/lou/ascii"
    "gno.land/p/lou/card"
)

var (
    table mdtable.Table
    cardtest *card.Card = card.NewCard("header", []string{"hey", "how", "u", "doing"}, 24, 0)
)

func init() {
    cardtest.SetDarkMode()
    line := ascii.PadLine("hey", 24, ascii.AlignWCenter, "⠀")
    table.Append([]string{line})
    // cardtest := card.NewCard("header", []string{"content", "here"}, 24, nil)
}
// 24

func Render(_ string) string {
    out := md.H1("Collections")
    
    out += md.HorizontalRule()
    out += "<gno-columns>\n\n"
    out += cardtest.String()
    out += cardtest.String()
    out += "|||\n\n"
    out += cardtest.String()
    out += "|||\n\n"
    out += cardtest.String()
    out += "</gno-columns>\n\n"
    return out
}
// dao to create a shared collection???
// your own collection
// add tags