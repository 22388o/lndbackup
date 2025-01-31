FROM golang:1.15-alpine as builder

# Move to working directory /build
WORKDIR /build

# Copy and download dependency using go mod
COPY go.mod .
COPY go.sum .
RUN go mod download

# Copy the code into the container
COPY . .

# Build the application
RUN go build

# Start a new, final image to reduce size.
FROM alpine as final

# Copy the binaries and entrypoint from the builder image.
COPY --from=builder /build/lndbackup /bin/

# Add bash.
RUN apk add --no-cache \
    bash

ENTRYPOINT [ "/bin/lndbackup" ]
