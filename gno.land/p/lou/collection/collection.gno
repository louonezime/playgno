package collections

type Collection struct {
	Title       string
	Description string
	Paths       []string
	Tags        []string
	Owner       string // maybe an address or DAO
}

var collections map[string]Collection

func RegisterCollection(name string, col Collection) {
	if _, ok := collections[name]; ok {
		panic("collection already exists")
	}
	collections[name] = col
}

func AddToCollection(name string, path string) {
	col, ok := collections[name]
	if !ok {
		panic("collection not found")
	}
	col.Paths = append(col.Paths, path)
	collections[name] = col
}

func GetCollection(name string) Collection {
	col, ok := collections[name]
	if !ok {
		panic("collection not found")
	}
	return col
}

func ListCollections() []string {
	keys := []string{}
	for name := range collections {
		keys = append(keys, name)
	}
	return keys
}
