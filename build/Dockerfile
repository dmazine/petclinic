# Build the application
FROM golang:1.20-alpine AS build
RUN apk add make gcc musl-dev
ENV GO111MODULE=on
WORKDIR /app
COPY . .
RUN make download build

# Create the docker image
FROM alpine
WORKDIR /app
COPY --from=build /app/bin/petclinic ./
CMD [ "./petclinic" ]
