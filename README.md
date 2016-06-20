# Mopidy [![Travis](https://img.shields.io/travis/trestrantham/mopidy.svg?maxAge=2592000&style=flat-square)](https://travis-ci.org/trestrantham/mopidy) [![Coveralls](https://img.shields.io/coveralls/trestrantham/mopidy.svg?maxAge=2592000&style=flat-square)](https://coveralls.io/github/trestrantham/mopidy) [![Hex.pm](https://img.shields.io/hexpm/v/mopidy.svg?maxAge=2592000&style=flat-square)](https://hex.pm/packages/mopidy) [![Deps Status](https://beta.hexfaktor.org/badge/all/github/trestrantham/mopidy.svg)](https://beta.hexfaktor.org/github/trestrantham/mopidy) [![Inline docs](http://inch-ci.org/github/trestrantham/mopidy.svg)](http://inch-ci.org/github/trestrantham/mopidy)

A Mopidy client library for Elixir.

## Installation

Add mopidy to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:mopidy, "~> 0.2.0"}]
end
```

Ensure mopidy is started before your application:

```elixir
def application do
  [applications: [:mopidy]]
end
```

Within your application you will need to configure the Mopidy API URL. You do
*not* want to put this information in your `config.exs` file! Either put it in a
`{prod,dev,test}.secret.exs` file which is sourced by `config.exs`, or read the
values in from the environment:

```elixir
config :mopidy,
  api_url: System.get_env("MOPIDY_API_URL")
```

## Usage

The online [documentation][doc] for the Mopidy HTTP API will give you a general
idea of the modules and available functionality. Where possible the namespacing
has been matched.

```shell
iex> {:ok, search_results} = Mopidy.Library.search(%{artist: "radiohead"}, ["spotify:"])
iex> search_results.artists
[%Mopidy.Artist{__model__: "Artist",
  name: "Radiohead Tribute Band",
  uri: "spotify:artist:0ADkBHZhR2cVfANgK5gHQO"},
 %Mopidy.Artist{__model__: "Artist", name: "Radiohead",
  uri: "spotify:artist:4Z8W4fKeB5YxbusRsdQVPb"}]
```

## License

MIT License, see [LICENSE](LICENSE) for details.

[doc]: https://docs.mopidy.com/en/latest/api/http/#http-api
