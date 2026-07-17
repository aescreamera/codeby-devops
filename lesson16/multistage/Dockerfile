FROM golang:1.23-alpine AS builder
RUN apk add --no-cache git
WORKDIR /src
RUN git clone https://github.com/golang/example.git .
WORKDIR /src/outyet
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -v -o /app/web-app .

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/web-app .
EXPOSE 8080
CMD ["./web-app", "-http", ":8080"]