ARG grpcui_version
FROM golang:1.17.7-alpine3.15 AS build
RUN apk add --no-cache git
#RUN go get honnef.co/go/tools/cmd/staticcheck && go install honnef.co/go/tools/cmd/staticcheck
WORKDIR /build
ARG grpcui_version
RUN git clone --branch v${grpcui_version} --depth 1 https://github.com/fullstorydev/grpcui
RUN cd /build/grpcui && CGO_ENABLED=0 go build ./cmd/grpcui

FROM alpine:3.15 AS runtime

COPY --from=build /build/grpcui/grpcui /usr/bin/grpcui

CMD [ "/usr/bin/grpcui" ]
