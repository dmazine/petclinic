# Pet Clinic

PetClinic is an implementation of the [Spring PetClinic Sample Application](https://github.com/spring-projects/spring-petclinic)
using the [Go Programming Language](https://go.dev/) and the [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html).

## Development

### Install Tools

```shell
make install-tools
```

### Database Migrations

#### Create migrations

```shell
migrate create -ext sql -dir db/migrations -seq <name>
```
 
#### Run migrations

```shell
migrate -database <your-database-url> -path db/migrations up
```

## Running Locally

```shell
docker-compose -f deployments/docker-compose.yml up
```
## References

- [The Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Get Your Hands Dirty on Clean Architecture: A hands-on guide to creating clean web applications with code examples in Java](https://www.amazon.com/Hands-Dirty-Clean-Architecture-hands-ebook/dp/B07YFS3DNF)
- [Go (Golang): Clean Architecture & Repositories vs Transactions](https://blog.devgenius.io/go-golang-clean-architecture-repositories-vs-transactions-9b3b7c953463)
- [Standard Go Project Layout](https://github.com/golang-standards/project-layout)
- [Inheritance Strategies with JPA and Hibernate – The Complete Guide](https://thorben-janssen.com/complete-guide-inheritance-strategies-jpa-hibernate/?utm_source=pocket_saves)
- [migrate](https://github.com/golang-migrate/migrate)
