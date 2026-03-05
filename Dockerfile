FROM golang:1.26-alpine3.22 AS build

ARG VERSION="untracked"

WORKDIR /webdav/

COPY ./go.mod ./
COPY ./go.sum ./
RUN go mod download

COPY . /webdav/
RUN go build -o main -trimpath -ldflags="-s -w -X 'github.com/hacdias/webdav/v5/cmd.version=$VERSION'" .

FROM scratch

COPY --from=build /webdav/main /bin/webdav
COPY config/webdav.yml /etc/webdav/config.yml

EXPOSE 6065

ENTRYPOINT [ "webdav" ]
