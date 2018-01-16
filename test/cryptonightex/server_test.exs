defmodule CryptoNightex.ServerTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, server} = start_supervised CryptoNightex.Server
    %{server: server}
  end

  test "it calculates hashes", %{server: server} do
    input = "0606fac496d005813051e5ad9760865270e9b3da278691fe0faec207a67f7d15d812b04e9e" <>
            "8a4d7e0200003bfb6ed357c8955111594374493de1b2f38e97363744e2ae4e1c49ce181c29c60c"
    expected = "7963869b4385a2df066debe120081206bd7e7656798b977061d7b0335cef8100"
    assert CryptoNightex.Server.calculate(server, input) == {:ok, expected}
    assert CryptoNightex.Server.calculate(server, input) == {:ok, expected}
    assert CryptoNightex.Server.calculate(server, input) == {:ok, expected}
  end

  test "it is case insensitive", %{server: server} do
    input = "0606FAC496D005813051E5AD9760865270E9B3DA278691fe0faec207a67f7d15d812b04e9e" <>
      "8a4d7e0200003bfb6ed357c8955111594374493de1b2f38e97363744E2AE4E1C49CE181C29C60C"
    expected = "7963869b4385a2df066debe120081206bd7e7656798b977061d7b0335cef8100"
    assert CryptoNightex.Server.calculate(server, input) == {:ok, expected}
  end

  test "it fails on invalid input", %{server: server} do
    input = "not_enough"
    assert_raise ArgumentError, fn -> CryptoNightex.Server.calculate(server, input) end
  end

  test "it fails on invalid hex", %{server: server} do
    input = "y606fac496d005813051e5ad9760865270e9b3da278691fe0faec207a67f7d15d812b04e9e" <>
            "8a4d7e0200003bfb6ed357c8955111594374493de1b2f38e97363744e2ae4e1c49ce181c29c60c"
    assert_raise ArgumentError, fn -> CryptoNightex.Server.calculate(server, input) end
  end
end
