package curator

import (
	"std"

	"gno.land/p/demo/seqid"
)

var (
	collections = make(map[string]Collection)
)

type Collection struct {
	ID          seqid.ID
	Title       string
	Description string
	Owner       std.Address
	Items       []string
}

type Card struct {
}

func CreateCollection(title string, description string) {
	if _, ok := collections[title]; ok {
		panic("collection already exists")
	}
	collections[title] = Collection{
		Title:       title,
		Description: description,
		Owner:       std.PreviousRealm().Address(),
	}
}

func AddToCollection(title string, item string) {
	coll := collections[title]
	if coll.Owner != std.PreviousRealm().Address() {
		panic("only owner can edit collection")
	}
	coll.Items = append(coll.Items, item)
	collections[title] = coll
}

func GetCollection(title string) Collection {
	return collections[title]
}
