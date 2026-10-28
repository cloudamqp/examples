# Agent instructions

Rules for adding or changing examples in this repo.

## Layout

- Every example lives at `<language>/<library>/`, always two levels deep, even
  when a language has only one example.
- `<language>` is the lowercase language or runtime name: `python`, `ruby`,
  `typescript`, `javascript`, `dotnet`, `java`, `go`, `rust`, `crystal`, `php`, `clojure`,
  `swift`, `lua`, `arduino`, `c`.
- `<library>` is the client library or framework name, as published:
  `pika`, `celery`, `amqp-client`, `rabbitmq-client`, `php-amqplib`, `langohr`.
  Never use numbers or vague names like `example2` or `async`.
- Two styles with the same library get a suffix: `pika-async`.
- Other protocols are leaves too, named after the client: `ruby/mqtt`,
  `ruby/stomp`. There is no top-level protocol folder.

## Each example

- Is self-contained: a reader must be able to copy only that folder and run it.
  Never share code, config or lockfiles between examples, even within a language.
  Duplication is fine.
- Has its own `README.md`, dependency manifest and lockfile, `mise.toml` pinning
  tool versions, and tests that run against a local LavinMQ.
  The exceptions are `lua/nodemcu` and `arduino/pubsubclient`, which need a
  device to run and set the MQTT settings at the top of each file.
  `lua/nodemcu` has no tests or workflow; CI compiles the Arduino sketches.
- Connects using the `BROKER_URL` environment variable. Never commit
  credentials or real broker hostnames.
  MQTT examples use `MQTT_HOST`, `MQTT_PORT`, `MQTT_USERNAME` and
  `MQTT_PASSWORD` instead, defaulting to `localhost`, `1883`, `guest` and
  `guest`, and use TLS when the port is 8883. MQTT has no vhost, so on
  CloudAMQP the username is `vhost:user`, as the console shows it.
- Is minimal: publish with confirms and consume with manual acks and a prefetch,
  unless the example is about something else.
- MQTT examples are a short snippet to read top to bottom: a publisher and a
  worker, each one self-contained file, and a test that runs them both, see
  `ruby/mqtt`.

## When adding an example

1. Create `<language>/<library>/` following the rules above.
2. Add a row to the table in `README.md`, keeping it sorted by language, then example.
3. Add `.github/workflows/<language>-<library>.yml`, copied from an existing
   caller. It calls `_example.yml` with the folder and test command, and its
   `paths` filter lists the example folder, itself and `_example.yml`.
4. Add the folder to the matching ecosystem's `directories` in
   `.github/dependabot.yml`, if dependabot supports it.

## Version control

This repo is worked on with jujutsu (`jj`). When moving an example, move the
whole folder so history can be followed with `git log --follow`.
