FROM rust:latest AS builder

RUN rustup target add x86_64-unknown-linux-musl
RUN apt update && apt install -y musl-tools musl-dev
RUN update-ca-certificates

WORKDIR /reverse_proxy

COPY ./ ./

RUN cargo build --target x86_64-unknown-linux-musl --release

FROM alpine

WORKDIR /reverse_proxy

COPY --from=builder /reverse_proxy/target/x86_64-unknown-linux-musl/release/reverse_proxy ./

EXPOSE 8000

ENTRYPOINT ["/reverse_proxy/reverse_proxy"]
