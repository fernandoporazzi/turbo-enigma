FROM golang:1.16-alpine AS builder
RUN mkdir -p /turbo-enigma
WORKDIR /turbo-enigma

COPY go.* ./
RUN go mod download

COPY . ./
RUN CGO_ENABLED=0 GOOS=linux go build -o bin/turbo-enigma

FROM scratch

COPY --from=builder /turbo-enigma/bin/. /.
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

ENV HTTP_PORT=80
ENV NOTIFICATION_RULES="[{\"channel\":\"#test\", \"labels\":[\"test\"]}]"
ENV MESSAGE="New Merge Request Created"
ENV SLACK_AVATAR_URL="https://avatars.githubusercontent.com/u/46966179?s=200&v=4"
ENV SLACK_USERNAME="codelicia/turbo-enigma"
ENV SLACK_WEBHOOK_URL="http://turboenigma.localhost"

ENTRYPOINT ["/turbo-enigma"]
