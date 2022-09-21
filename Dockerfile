## Build the application
FROM golang:1.19.1 AS builder
WORKDIR /root
COPY . ./
RUN CGO_ENABLED=0 GOOS=linux go build -a -o app .

## Run the application
FROM alpine:latest
ENV VERSION v2
WORKDIR /root
RUN apk add --no-cache ca-certificates
COPY --from=builder /root/app ./
CMD ["./app"]