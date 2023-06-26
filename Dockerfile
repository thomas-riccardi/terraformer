# usage: docker buildx build . -o type=local,dest=generated/ --target=dist
#     check result in generated/
FROM golang:1.19 as builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

# avoid overwriting go.mod or go.sum after go mod download; it would complain and wrongly recommend go mod tidy
COPY build ./build
COPY cmd ./cmd
COPY docs ./docs
COPY providers ./providers
COPY terraformutils ./terraformutils
COPY tests ./tests
COPY *.go ./


RUN CGO_ENABLED=0 GOOS=linux go run build/main.go datadog


FROM scratch as dist

COPY --from=builder /app/terraformer* /
