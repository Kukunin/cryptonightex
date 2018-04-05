defmodule Mix.Tasks.Compile.NativeCode do
  def run(_args) do
    env = [{"TARGET", CryptoNightex.Server.executable_path()}]
    {result, errcode} = System.cmd("make", [], env: env, stderr_to_stdout: true)
    IO.binwrite(result)
    unless errcode == 0, do: raise "Compilation failed"
    :ok
  end
end

defmodule CryptoNightex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :cryptonightex,
      version: "0.2.0",
      description: "CryptoNight native library for Elixir/Erlang",
      elixir: "~> 1.5",
      compilers: Mix.compilers ++ [:native_code],
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package(),
      source_url: "https://github.com/Kukunin/cryptonightex",
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {CryptoNightex, []},
    ]
  end

  defp deps do
    [{:poolboy, "~> 1.5.1"},
     {:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp package do
    [
      files: ~w(lib mix.exs README.md),
      maintainers: ["Sergiy Kukunin"],
      licenses: ["MIT"],
      files: ["src", "lib", "mix.exs", "Makefile", "LICENSE*", "README*"],
      links: %{"github" => "https://github.com/Kukunin/cryptonightex"}
    ]
  end
end
