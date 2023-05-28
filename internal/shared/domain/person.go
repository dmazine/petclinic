package domain

type Person struct {
	ID        int64
	FirstName string
	LastName  string
}

func NewPerson(id int64, firstName, lastName string) *Person {
	return &Person{
		ID:        id,
		FirstName: firstName,
		LastName:  lastName,
	}
}
