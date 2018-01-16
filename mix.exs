defmodule Mix.Tasks.Compile.NativeCode do
  def run(_args) do
    env = [{"TARGET", executable_path()}]
    {result, errcode} = System.cmd("make", [], env: env, stderr_to_stdout: true)
    IO.binwrite(result)
    unless errcode == 0, do: raise "Compilation failed"
  end

  def executable_path do
    [
      :code.priv_dir(:cryptonightex),
      :erlang.system_info(:system_architecture),
      "cryptonight_port"
    ] |> :filename.join()
  end
end

defmodule CryptoNightex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :cryptonightex,
      version: "0.1.0",
      elixir: "~> 1.5",
      compilers: [:native_code] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      deps: deps()
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
    [{:poolboy, "~> 1.5.1"}]
  end
end
