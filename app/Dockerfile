FROM golang:1.8

ARG app_version=""
ENV APP_VERSION=$app_version


ENV ENV=PROD

WORKDIR /go/src/app
COPY . .

RUN go get -d -v ./...
RUN go install -v ./...


CMD ["app"]