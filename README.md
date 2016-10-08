# Elix

![Codeship Build Status](https://codeship.com/projects/88411dd0-6f86-0134-8d34-22394c4083ce/status?branch=master)

A [Hedwig](https://github.com/hedwig-im/hedwig) chatbot for the Indy Elixir Flowdock flow.

## Getting Set Up

```
$ git clone git@github.com:indyelixir/elix.git
$ cd elix
$ mix deps.get
```

In development, you can interact with Elix via the console adapter:

```
$ mix run --no-halt
Hedwig Console - press Ctrl+C to exit.

steve> elix ping
elix> pong
steve> elix ship it
elix> https://img.skitch.com/20111026-r2wsngtu4jftwxmsytdke6arwd.png
```

## Testing

```
$ mix test
```
