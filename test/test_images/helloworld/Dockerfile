# Use the official Golang image to create a build artifact.
# This is based on Debian and sets the GOPATH to /go.
# https://hub.docker.com/_/golang
FROM quay.io/openshift-knative-client-test/golang:1.13 as builder

# Create and change to the app directory.
WORKDIR /app

# Copy local code to the container image.
COPY ./test/test_images/helloworld/ .

# Build the binary.
RUN CGO_ENABLED=0 GOOS=linux GOARCH=ppc64le go build -v -o server

# Use the official Alpine image for a lean production container.
# https://hub.docker.com/_/alpine
# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM quay.io/openshift-knative-client-test/alpine:3
RUN apk add --no-cache ca-certificates

# Copy the binary to the production image from the builder stage.
COPY --from=builder /app/server /server

# Run the web service on container startup.
CMD ["/server"]
