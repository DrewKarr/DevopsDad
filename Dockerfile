FROM golang:1.13.7 AS build
ADD . /src
WORKDIR /src
RUN make unittest
RUN make linux

FROM scratch
EXPOSE 8080
ENTRYPOINT ["/demo-app"]
COPY --from=build /src/bin/demo-app /demo-app
