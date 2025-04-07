package comment

type Comment struct {
	rating  int64
	comment *string
	author  string
}

func (post Comment) Rating() int64 {
	return post.rating
}

func (post Comment) Comment() *string {
	return post.comment
}

func (post Comment) Author() string {
	return post.author
}

func NewComment(rating int64, comment string, author string) *Comment {
	return &Comment{
		rating:  rating,
		comment: &comment,
		author:  author,
	}
}

func NewRating(rating int64, author string) *Comment {
	return &Comment{
		rating:  rating,
		comment: nil,
		author:  author,
	}
}
