# CryptoNightex

`cryptonightex` is an Elixir package for calculating CryptoNight hashes using 
C bindings via NIF.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `cryptonightex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cryptonightex, "~> 0.1.0"}
  ]
end
```

## Usage

    CryptoNightex.calculate "7000000001e980924e4e1109230383e66d62945ff8e749903bea4336755c00000000000051928aff1b4d72416173a8c3948159a09a73ac3bb556aa6bfbcad1a85da7f4c1d13350531e24031b939b9e2b"
    # => "e97ef3fc036d67626e54547a71307303dc5fa89b9df499feeaef9d11acadbe9b"

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/cryptonightex](https://hexdocs.pm/cryptonightex).

