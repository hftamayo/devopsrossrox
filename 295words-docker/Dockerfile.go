FROM golang:1.18-alpine AS builder

WORKDIR /app

COPY web/. .

RUN go build -o main .

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/main ./
COPY --from=builder /app/public ./web/static

EXPOSE 8088

CMD ["./main"]
