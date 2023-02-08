FROM rust:latest AS builder

RUN update-ca-certificates

WORKDIR /app

COPY ./ ./

RUN cargo build --release

FROM debian:buster-slim

RUN apt update && apt install -y openssl

WORKDIR /app

COPY --from=builder /app/target/release/reverse_proxy ./

EXPOSE 8000

ENTRYPOINT ["/app/reverse_proxy"]
