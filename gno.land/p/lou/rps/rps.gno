package rps

import (
	"std"
	"errors"
)

var hands = []string{
	"rock",
	"paper",
	"scissors",
}

type Profile struct {
	wins int64
	losses int64
	account string
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
		wins: 0,
		losses: 0,
		account: account,
	}
}

func SendHand(input string) (string, bool, error) {
	hand := GetHand()

	switch {
	case input == hand:
		return "It's a **tie**! Try Again!\n", false, errors.New("Not a win or loss")
	case input == "rock" && hand == "scissors":
		return "**Rock** beats **Scissors**! You Won!\n", true, nil
	case input == "rock" && hand == "paper":
		return "**Paper** beats **Rock**! You Lost!\n", false, nil
	case input == "scissors" && hand == "paper":
		return "**Scissors** beats **Paper**! You Won!\n", true, nil
	case input == "scissors" && hand == "rock":
		return "**Rock** beats **Scissors**! You Lost!\n", false, nil
	case input == "paper" && hand == "rock":
		return "**Paper** beats **Rock**! You Won!\n", true, nil
	case input == "paper" && hand == "scissors":
		return "**Scissors** beats **Paper**! You Lost!\n", false, nil
	default:
		return "Invalid input!", false, errors.New("Not a valid input")
	}
}

func GetHand() string {
	random := int(std.ChainHeight()) % len(hands)
	return hands[random];
}
