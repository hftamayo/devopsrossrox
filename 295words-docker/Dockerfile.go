FROM golang:1.18-alpine AS builder

WORKDIR /app

COPY web/dispatcher.go .
COPY web/go.mod .
COPY web/static ./static

RUN go build -o dispatcher .

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/dispatcher ./
COPY --from=builder /app/static ./static

EXPOSE 8088

CMD ["./dispatcher"]
