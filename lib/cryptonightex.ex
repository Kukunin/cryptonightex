defmodule CryptoNightex do
  @timeout 20_000

  use Application

  @moduledoc """
  CryptoNightex is an application to calculation CryptoNight hashes.

  It uses native C implementation and communicates via Erlang Ports.
  """

  @doc """
  Calculates a CryptoNight hash

  ## Examples

      iex> CryptoNightex.calculate "0606fac496d005813051e5ad9760865270e9b3da278691fe0faec207a67f7d15d812b04e9e8a4d7e0200003bfb6ed357c8955111594374493de1b2f38e97363744e2ae4e1c49ce181c29c60c"
      {:ok, "7963869b4385a2df066debe120081206bd7e7656798b977061d7b0335cef8100"}

  """
  def calculate(blob) do
    :poolboy.transaction(:cryptonightex_port, fn server ->
      CryptoNightex.Server.calculate(server, blob)
    end, @timeout)
  end

  def start(_type, _args) do
    children = [
      :poolboy.child_spec(:worker, poolboy_config())
    ]

    opts = [strategy: :one_for_one, name: CryptoNightex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp poolboy_config do
    [
      {:name, {:local, :cryptonightex_port}},
      {:worker_module, CryptoNightex.Server},
      {:size, pool_config()[:size]},
      {:max_overflow, pool_config()[:max_overflow]}
    ]
  end

  defp pool_config do
    case Application.fetch_env(:cryptonightex, :pool) do
      {:ok, config} -> config
      :error -> [size: 1, max_overflow: 0]
    end
  end
end
