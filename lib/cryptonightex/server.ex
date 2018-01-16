defmodule CryptoNightex.Server do
  use GenServer

  require Logger

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def calculate(pid, input, timeout \\ :infinity)
  def calculate(pid, input, timeout)
  when is_binary(input) and byte_size(input) == 152 do
    case input |> String.upcase |> Base.decode16 do
      {:ok, _} -> GenServer.call(pid, {:calc, input |> String.downcase, timeout})
      :error -> raise ArgumentError, "Wrong input #{inspect(input)}"
    end
  end
  def calculate(_, input, _), do: raise ArgumentError, "Wrong input #{inspect(input)}"

  def executable_path do
    [
      :code.priv_dir(:cryptonightex),
      :erlang.system_info(:system_architecture),
      "cryptonight_port"
    ] |> :filename.join()
  end

  def init(:ok) do
    port = Port.open({:spawn, executable_path()}, [:binary, :exit_status])
    {:ok, %{port: port}}
  end

  def handle_call({:calc, input, timeout}, _from, %{port: port} = state) do
    Port.command(port, input)
    result = receive do
      {^port, {:data, value}} -> {:ok, value}
      {^port, {:exit_status, status}} = message ->
        send(self(), message)
        {:error, {:exit, status}}
      after timeout -> {:error, :timeout}
    end
    {:reply, result, state}
  end

  def handle_info({port, {:exit_status, _}}, %{port: port} = state) do
    :timer.sleep(1000)
    {:stop, :port_exit, state}
  end

  def handle_info(info, state) do
    Logger.warn("Unknown request #{inspect(info)}")
    {:noreply, state}
  end
end
