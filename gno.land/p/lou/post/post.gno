package post

type Post struct {
    rating int64
    comment *string
    author string
}

func (post Post) Rating() int64 {
    return post.rating
}

func (post Post) Comment() *string {
    return post.comment
}

func (post Post) Author() string {
    return post.author
}

func NewPost(rating int64, comment string, author string) *Post {
    return &Post{
        rating: rating,
        comment: &comment,
        author: author,
    }
}

func NewRating(rating int64, author string) *Post {
    return &Post{
        rating: rating,
        comment: nil,
        author: author,
    }
}
