# CryptoNightex

`cryptonightex` is an Elixir package for calculating CryptoNight hashes using Ports.

## Installation

The package can be installed by adding `cryptonightex`
to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cryptonightex, "~> 0.1.0"}
  ]
end
```

## Usage

To calculate the classic Cryptonight hash, use:

    CryptoNightex.cryptonight "7000000001e980924e4e1109230383e66d62945ff8e749903bea4336755c00000000000051928aff1b4d72416173a8c3948159a09a73ac3bb556aa6bfbcad1a85da7f4c1d13350531e24031b939b9e2b"
    # => {:ok, "e97ef3fc036d67626e54547a71307303dc5fa89b9df499feeaef9d11acadbe9b"}

If you need a CryptonightV7 hash, use:

    CryptoNightex.cryptonightV7 "7000000001e980924e4e1109230383e66d62945ff8e749903bea4336755c00000000000051928aff1b4d72416173a8c3948159a09a73ac3bb556aa6bfbcad1a85da7f4c1d13350531e24031b939b9e2b"
    # => {:ok, "e97ef3fc036d67626e54547a71307303dc5fa89b9df499feeaef9d11acadbe9b"}

There is `CryptoNightex.calculate/1` function which tries to detect the needed variation
automatically, based on the version of blob.

Documentation is published at [https://hexdocs.pm/cryptonightex](https://hexdocs.pm/cryptonightex).
