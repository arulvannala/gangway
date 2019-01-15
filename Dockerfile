FROM golang:1.9
WORKDIR /go/src/github.com/jigsheth57/gangway

RUN go get github.com/golang/dep/cmd/dep
COPY Gopkg.toml Gopkg.lock ./
RUN dep ensure -v -vendor-only

RUN go get -u github.com/mjibson/esc/...
COPY cmd cmd
COPY templates templates
COPY internal internal
RUN esc -o cmd/gangway/bindata.go templates/

RUN CGO_ENABLED=0 GOOS=linux go install -ldflags="-w -s" -v github.com/jigsheth57/gangway/...

FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=0 /go/bin/gangway /bin/gangway
