defmodule Mix.Tasks.Benchmark do
  use Mix.Task

  @shortdoc "Comparitive speed tests"
  def run(_) do

    range = 1..10
    integer1 = :rand.uniform(100)
    integer2 = :rand.uniform(100)

    FastGlobal.put(:data, "hello")
    hello = "hello"

    Benchee.run(
      %{
        "Run loader"    => fn -> Fastfwd.Loader.run() end,
        "Run loader and write"    => fn -> FastGlobal.put(:data, Fastfwd.Loader.run())  end,
        "Write hello to global" => fn -> FastGlobal.put(:data, "hello") end,
        "Read hello from global" => fn -> FastGlobal.get(:data) end,
        "Read hello from variable" => fn -> x = hello end,
      },
      time: 1,
      warmup: 1,
      memory_time: 1,
      formatters: [{Benchee.Formatters.Console, extended_statistics: true}]
    )

  end



end