package home

import (
	"std"

	"gno.land/p/demo/avl"
	"gno.land/p/moul/md"
	"gno.land/p/moul/txlink"

	"gno.land/p/lou/rps"
)

var (
	profiles *avl.Tree
	currentSession *rps.Profile
	gameResult string
	won bool
)

func init() {
	currentSession = rps.NewProfile("")
	profiles = avl.NewTree()
	gameResult = ""
	won = false
}

func Play(input string) {
	caller := std.PreviousRealm().Address()
	foundProfile, _ := profiles.Get(caller.String())
	if profile, ok := foundProfile.(*rps.Profile); ok {
		currentSession = profile
	} else {
		currentSession = rps.NewProfile("")
		profiles.Set(caller.String(), currentSession)
	}

	result, hasWon, hasError := rps.SendHand(input);
	gameResult = result
	if hasError != nil {
		return
	}
	won = hasWon
	if won {
		currentSession.SetWins(currentSession.Wins() + 1)
	} else {
		currentSession.SetLosses(currentSession.Losses() + 1)
	}
}

func RenderRockPaperScissors() string {
	out := md.H2("Rock, Paper, Scissor\n\n")
	// out += ufmt.Sprintf("Wins: %d, Losses: %d\n\n", currentSession.Wins(), currentSession.Losses())
	if currentSession.Wins() > 0 || currentSession.Losses() > 0 {
		out += "Career: "
	}
	for i := currentSession.Wins(); i > 0; i-- {
		out += "🏆"
	}
	for i := currentSession.Losses(); i > 0; i-- {
		out += "❌"
	}
	out += "\n\nPlay [ "
	out += md.Link("Rock", txlink.Call("Play", "input", "rock"))
	out += " | "
	out += md.Link("Paper", txlink.Call("Play", "input", "paper"))
	out += " | "
	out += md.Link("Scissors ", txlink.Call("Play", "input", "scissors"))
	out += " ]\n\n" + gameResult
	out += "\n\n"
	return out
}
