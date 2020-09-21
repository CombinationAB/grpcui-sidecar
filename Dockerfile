FROM golang:1.15.2-alpine3.12 AS build

RUN apk --no-cache add git make gcc musl-dev
RUN go get honnef.co/go/tools/cmd/staticcheck && go install honnef.co/go/tools/cmd/staticcheck
#RUN go get github.com/fullstorydev/grpcui/standalone \
# && go install github.com/fullstorydev/grpcui/standalone/cmd/grpcui
#RUN go get github.com/fullstorydev/grpcui \
# && go install github.com/fullstorydev/grpcui/cmd/grpcui
WORKDIR /build
RUN git clone https://github.com/fullstorydev/grpcui
RUN cd /build/grpcui && PATH=$PATH:/root/go/bin/ make && make install

FROM alpine:3.12 AS runtime

COPY --from=build /go/bin/grpcui /usr/bin/

CMD [ "/usr/bin/grpcui" ]
