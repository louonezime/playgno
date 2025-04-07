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
	currentProfile *rps.Profile
	gameSession *rps.GameSession
)

func init() {
	currentProfile = rps.NewProfile("")
	gameSession = rps.NewSession()
	profiles = avl.NewTree()
}

func Play(input string) {
	caller := std.PreviousRealm().Address()

	foundProfile, _ := profiles.Get(caller.String())
	if profile, ok := foundProfile.(*rps.Profile); ok {
		currentProfile = profile
	} else {
		currentProfile = rps.NewProfile("")
		profiles.Set(caller.String(), currentProfile)
	}

	if err := gameSession.SendHand(input); err != nil {
		panic(err)
	} else {
		if gameSession.IsATie() {
			return
		} else {
			if gameSession.HasWon() {
				currentProfile.SetWins(currentProfile.Wins() + 1)
			} else {
				currentProfile.SetLosses(currentProfile.Losses() + 1)
			}
		}
	}
}

func RenderRockPaperScissors() string {
	out := md.H2("Rock, Paper, Scissor\n\n")
	// out += ufmt.Sprintf("Wins: %d, Losses: %d\n\n", currentProfile.Wins(), currentProfile.Losses())
	out += currentProfile.String()
	out += "\n\nPlay [ "
	out += md.Link("Rock", txlink.Call("Play", "input", "rock"))
	out += " | "
	out += md.Link("Paper", txlink.Call("Play", "input", "paper"))
	out += " | "
	out += md.Link("Scissors ", txlink.Call("Play", "input", "scissors"))
	out += " ]\n\n" + gameSession.String()
	out += "\n\n"
	return out
}
