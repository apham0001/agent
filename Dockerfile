FROM golang:1.25-alpine@sha256:8e02eb337d9e0ea459e041f1ee5eece41cbb61f1d83e7d883a3e2fb4862063fa AS builder

WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go generate
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /containerssh-agent .

FROM scratch
COPY --from=builder /containerssh-agent /usr/bin/containerssh-agent
ENTRYPOINT ["/usr/bin/containerssh-agent"]
