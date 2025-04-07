postgres:
	docker run -d --name postgres15 -p 5437:5432 -e POSTGRES_PASSWORD=richard10 postgres:15-alpine

createdb:
	docker exec -it postgres15 createdb --username=postgres --owner=postgres simple_bank

dropdb:
	docker exec -it postgres15 dropdb -U postgres simple_bank

migrateup:
	 migrate -path db/migration -database "postgresql://postgres:richard10@localhost:5437/simple_bank?sslmode=disable" -verbose up

migratedown:
	 migrate -path db/migration -database "postgresql://postgres:richard10@localhost:5437/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/techschool/simplebank/db/sqlc Store

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server mock