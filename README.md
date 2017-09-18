# Bkdrf

It's a simple app to parse bkdrf.ru website and do some calculations with the data presented on this site.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bkdrf` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bkdrf, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/bkdrf](https://hexdocs.pm/bkdrf).

## Usage

For example, we want to get all the data about Saratov, run this in the repository root folder:

```
➜ mkdir cache
➜ mix deps.get
➜ mix deps.compile
➜ iex -S mix
Erlang/OTP 20 [erts-9.0.5] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Interactive Elixir (1.5.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Bkdrf.get "saratov"
---
2dc02626-2284-4450-a7b7-c05f6a08412f
Установка пешеходных ограждений
Автомобильная дорога по ул. Тельмана
...
```
