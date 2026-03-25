FROM golang:1.23-alpine AS builder

WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /containerssh-agent .

FROM scratch
COPY --from=builder /containerssh-agent /usr/bin/containerssh-agent
ENTRYPOINT ["/usr/bin/containerssh-agent"]
