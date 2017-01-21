# Elix

![Codeship Build Status](https://img.shields.io/codeship/88411dd0-6f86-0134-8d34-22394c4083ce.svg)

A [Hedwig](https://github.com/hedwig-im/hedwig) chatbot for the [Indy Elixir](http://www.indyelixir.org/) Flowdock flow.

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

## Contributing

1. [Fork it!](http://github.com/indyelixir/elix/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'A new feature!'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Open a new Pull Request
