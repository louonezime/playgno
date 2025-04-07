package home

import (
	"std"

	"gno.land/p/demo/avl"
	"gno.land/p/demo/ufmt"
	"gno.land/p/moul/md"
	"gno.land/p/moul/txlink"

	"gno.land/p/lou/comment"
)

var (
	ratings *avl.Tree
)

func init() {
	ratings = avl.NewTree()
}

func NewRating(rating int64) string {
	caller := std.PreviousRealm().Address()

	if _, exists := ratings.Get(caller.String()); exists {
		panic(caller.String() + " has already rated! Update instead!")
	}
	p := comment.NewRating(rating, caller.String())
	ratings.Set(caller.String(), p)
	return ufmt.Sprintf("Successfully added a #%d rating", rating)
}

func NewRatingWComment(rating int64, commentStr string) string {
	caller := std.PreviousRealm().Address()

	if _, exists := ratings.Get(caller.String()); exists {
		panic(caller.String() + " has already rated! Update instead!")
	}
	p := comment.NewComment(rating, commentStr, caller.String())
	ratings.Set(caller.String(), p)
	return ufmt.Sprintf("Successfully added a #%d rating with a comment", rating)
}

func UpdateRating(rating int64) string {
	caller := std.PreviousRealm().Address()

	if _, exists := ratings.Get(caller.String()); !exists {
		panic("You cannot update this comment")
	}
	_, hasRemoved := ratings.Remove(caller.String())
	if hasRemoved {
		ratings.Set(caller.String(), NewRating(rating))
		return ufmt.Sprintf(("Successfully updated rating!\n"))
	}
	panic("Invalid update of comment!");
}

func DeleteRating() string {
	caller := std.PreviousRealm().Address()

	if _, exists := ratings.Get(caller.String()); !exists {
		panic(caller.String() + " hasn't added a rating yet!")
	}
	value, hasRemoved := ratings.Remove(caller.String())
	if hasRemoved {
		p := value.(*comment.Comment)
		return ufmt.Sprintf("Rating of %s was removed successfully\n", p.Rating())
	}
	panic("Invalid removal of comment!");
}

func RenderRatings() string {
	out := md.H2("★ Ratings ★\n\n")

	if ratings.Size() == 0 {
		out += "No ratings found."
	} else {
		ratings.ReverseIterate("", "", func(key string, value interface{}) bool {
			comment := value.(*comment.Comment)
			out += md.Bold(ufmt.Sprintf("[#%s]:", key))

			out += ufmt.Sprintf(" (%d) ", comment.Rating())
			for i := comment.Rating(); i > 0; i-- {
				out += "★"
			}
			if comment.Comment() != nil {
				out += ufmt.Sprintf(" %s [ ", *comment.Comment())
			}
			out += md.Link("🗑 DELETE", txlink.Call("DeleteRating"))
			out += " ]\n\n"
			return false
		})
	}

	return out
}
