package rps

import (
	"errors"
	"std"
)

var (
	hands = []string{
		"rock",
		"paper",
		"scissors",
	}

	ErrInvalidHand = errors.New("Invalid hand input: only rock, paper or scissors")
)

type Profile struct {
	wins    int64
	losses  int64
	account string
}

type GameSession struct {
	hasWon bool
	isATie bool
	detail string
}

func (profile Profile) Wins() int64 {
	return profile.wins
}

func (profile Profile) Losses() int64 {
	return profile.losses
}

func (profile Profile) Account() string {
	return profile.account
}

func (profile *Profile) SetWins(wins int64) {
	profile.wins = wins
}

func (profile *Profile) SetLosses(losses int64) {
	profile.losses = losses
}

func NewProfile(account string) *Profile {
	return &Profile{
		wins:    0,
		losses:  0,
		account: account,
	}
}

func NewSession() *GameSession {
	return &GameSession{
		hasWon: false,
		isATie: false,
		detail: "",
	}
}

func (game *GameSession) IsATie() bool {
	return game.isATie
}

func (game *GameSession) HasWon() bool {
	return game.hasWon
}

func (game *GameSession) SendHand(input string) error {
	hand := GetHand()
	game.isATie = false
	game.hasWon = false

	switch {
	case input == hand:
		game.detail = "It's a **tie**! Try Again!\n"
		game.isATie = true
	case input == "rock" && hand == "scissors":
		game.detail = "**Rock** beats **Scissors**! You Won!\n"
		game.hasWon = true
	case input == "rock" && hand == "paper":
		game.detail = "**Paper** beats **Rock**! You Lost!\n"
	case input == "scissors" && hand == "paper":
		game.detail = "**Scissors** beats **Paper**! You Won!\n"
		game.hasWon = true
	case input == "scissors" && hand == "rock":
		game.detail = "**Rock** beats **Scissors**! You Lost!\n"
	case input == "paper" && hand == "rock":
		game.detail = "**Paper** beats **Rock**! You Won!\n"
		game.hasWon = true
	case input == "paper" && hand == "scissors":
		game.detail = "**Scissors** beats **Paper**! You Lost!\n"
	default:
		return ErrInvalidHand
	}
	return nil
}

func GetHand() string {
	random := int(std.ChainHeight()) % len(hands)
	return hands[random]
}

func (profile Profile) String() string {
	out := ""

	if profile.Wins() > 0 || profile.Losses() > 0 {
		out += "Career: "
	}
	for i := profile.Wins(); i > 0; i-- {
		out += "🏆"
	}
	for i := profile.Losses(); i > 0; i-- {
		out += "❌"
	}
	return out
}

func (game GameSession) String() string {
	return game.detail
}
