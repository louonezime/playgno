package home

import (
	"std"

	"gno.land/p/demo/avl"
	"gno.land/p/demo/ufmt"
	"gno.land/p/moul/md"
	"gno.land/p/moul/txlink"

	"gno.land/p/lou/post"
)

var (
	posts *avl.Tree
)

func init() {
	posts = avl.NewTree()
}

func NewRating(rating int64) string {
	caller := std.PreviousRealm().Address()

	if _, exists := posts.Get(caller.String()); exists {
		panic(caller.String() + " has already rated! Update instead!")
	}
	p := post.NewRating(rating, caller.String())
	posts.Set(caller.String(), p)
	return ufmt.Sprintf("Successfully added a #%d rating", rating)
}

func NewRatingWComment(rating int64, comment string) string {
	caller := std.PreviousRealm().Address()

	if _, exists := posts.Get(caller.String()); exists {
		panic(caller.String() + " has already rated! Update instead!")
	}
	p := post.NewPost(rating, comment, caller.String())
	posts.Set(caller.String(), p)
	return ufmt.Sprintf("Successfully added a #%d rating with a comment", rating)
}

func DeleteRating() string {
	caller := std.PreviousRealm().Address()

	if _, exists := posts.Get(caller.String()); !exists {
		panic(caller.String() + " hasn't added a rating yet!")
	}
	value, isRemoved := posts.Remove(caller.String())
	if isRemoved {
		p := value.(*post.Post)
		return ufmt.Sprintf("Rating of %s was removed successfully\n", p.Rating())
	}
	panic("Invalid removal of post!");
}

func RenderRatings() string {
	out := md.H2("★ Ratings ★\n\n")

	if posts.Size() == 0 {
		out += "No ratings found."
	} else {
		posts.ReverseIterate("", "", func(key string, value interface{}) bool {
			post := value.(*post.Post)
			out += md.Bold(ufmt.Sprintf("[#%s]:", key))

			out += ufmt.Sprintf(" (%d) ", post.Rating())
			for i := post.Rating(); i > 0; i-- {
				out += "★"
			}
			if post.Comment() != nil {
				out += ufmt.Sprintf(" %s [ ", *post.Comment())
			}
			out += md.Link("Delete", txlink.Call("DeleteRating"))
			out += " ]\n\n"
			return false
		})
	}

	return out
}
