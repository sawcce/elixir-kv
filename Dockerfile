FROM elixir:latest AS builder
MAINTAINER  <sawcce>

ARG mix_env=prod
ENV MIX_ENV=${mix_env}

WORKDIR /src

COPY mix.exs mix.lock /src/
RUN mix deps.get --only $MIX_ENV
ADD . .
RUN mix release --path /app --quiet

FROM elixir:latest
ARG mix_env=prod
ENV MIX_ENV=${mix_env}
COPY --from=builder /app /app
WORKDIR /app
EXPORT 4000
ENTRYPOINT ["/app/bin/att"]
CMD ["start"]
