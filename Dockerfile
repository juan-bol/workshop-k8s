## Build the application
FROM golang:1.19.1 AS builder
WORKDIR /root
COPY . ./
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -a -o app .

## Run the application
FROM debian:latest
ENV VERSION v1
WORKDIR /root
COPY --from=builder /root/app ./
CMD ["./app"]