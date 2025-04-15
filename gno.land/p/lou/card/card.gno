package card

import (
	"gno.land/p/mason/md"
	"gno.land/p/moul/mdtable"

	"gno.land/p/lou/ascii"
)

var (
	table mdtable.Table
)

type Card struct {
	header string
	hWidthAlignment ascii.WAlignment

	content []string
	cWidthAlignment ascii.WAlignment
	cHeightAlignment ascii.HAlignment

	width uint64
	height uint64
	darkMode bool
}

func (card *Card) SetHeader(header string) {
	card.header = header
}

func (card *Card) SetContent(content []string) {
	card.content = content
}

func (card *Card) AppendContent(content string) {
	card.content = append(card.content, content)
}

func (card *Card) SetHeight(height uint64) {
	card.height = height
}

func (card *Card) SetWidth(width uint64) {
	card.width = width
}

func (card *Card) SetHeaderAlignmentW(
	width ascii.WAlignment,
) {
	card.hWidthAlignment = width
}

func (card *Card) SetContentAlignmentW(
	width ascii.WAlignment,
) {
	card.cWidthAlignment = width
}

func (card *Card) SetContentAlignmentH(
	height ascii.HAlignment,
) {
	card.cHeightAlignment = height
}

func (card *Card) SetDarkMode() {
	card.darkMode = true
}

func contentRender(lines []string, wAlign ascii.WAlignment, width int, height int, hAlign ascii.HAlignment) string {
	maxWidth := width
	for i := 0; i < len(lines); i++ {
		if len(lines[i]) > maxWidth {
			maxWidth = len(lines[i])
		}
	}

	if len(lines) > height {
		height = len(lines)
	}
	lines = ascii.PadHeight(lines, height, hAlign)

	body := ""
	for _, line := range lines {
		body += ascii.PadLine(line, maxWidth, wAlign, "⠀") + "\n" // + "<br>"" if possible in future
	}

	return body + "\n"
}

func RenderTable(card Card) string {
	header := ascii.PadLine(card.header, int(card.width), card.hWidthAlignment, "⠀")
	table := mdtable.Table{
		Headers: []string{header},
	}
	formattedContent := contentRender(card.content, card.cWidthAlignment, int(card.width), int(card.height), card.cHeightAlignment)
	table.Append([]string{formattedContent})
	return table.String()
}

func (card Card) String() string {
	if (!card.darkMode) {
		return RenderTable(card)
	}
	// header := ascii.PadLine(card.header, int(card.width), card.hWidthAlignment, "⠀")
	out := "# " + card.header + "\n\n"
	// out := ascii.Frame([]string{card.header}, card.hWidthAlignment, int(card.width), 1, ascii.AlignHCenter)
	out += ascii.Frame(card.content, card.cWidthAlignment, int(card.width), int(card.height), card.cHeightAlignment) // TODO Change to FixedFrame
	out += "`footer here`\n\n"
	out += md.Link("click here", "/yo") + "\n"
	return out
}

func NewCard(
	header string,
	content []string,
	width uint64,
	height uint64,
) *Card {
	maxW := uint64(len(header))
	if maxW > width {
		width = maxW
	}

	return &Card{
		header: header,
		hWidthAlignment: ascii.AlignWCenter,
		
		content: content,
		cWidthAlignment: ascii.AlignWCenter,
		cHeightAlignment: ascii.AlignHCenter,

		width: width,
		height: height,
		darkMode: false,
	}
}
