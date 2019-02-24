defmodule Mix.Tasks.Benchmark do
  use Mix.Task

  @shortdoc "Comparitive speed tests"
  def run(_) do

    require Bread.Stottie
    require Bread.Barm
    require Bread.SlicedWhiteLoaf
    require Bread.Sourdough

    FastGlobal.put(
      :test,
      %{
        barm: Bread.Barm,
        stottie: Bread.Stottie,
        sliced: Bread.SlicedWhiteLoaf,
        sourdough: Bread.Sourdough
      }
    )

    Fastfwd.preload

    Benchee.run(
      %{
        "FastFwd, auto (no cache)" => fn -> using_fastfwd(false) end,
        "FastFwd, auto (cached)" => fn -> using_fastfwd(true) end,
        "Basic, manual FastGlobal" => fn -> using_fastglobal() end,
        "Case statement and then calling modules directly" => fn -> using_case() end,

      },
      time: 2,
      warmup: 1,
      memory_time: 1,
      pre_check: true,
      formatters: [{Benchee.Formatters.Console, extended_statistics: true}]
    )

  end

  def bread_type() do
    Enum.random([:stottie, :barm, :sliced, :sourdough])
  end

  def loaves_quantity() do
    Enum.random(1..10)
  end

  def using_fastfwd(cache \\ true) do
    if cache do
      CachedBread.bake(bread_type(), loaves_quantity())
    else
      Bread.bake(bread_type(), loaves_quantity())
    end
  end

  def using_case do
    case bread_type() do
      :barm -> Bread.Barm.bake(loaves_quantity())
      :stottie -> Bread.Stottie.bake(loaves_quantity())
      :sliced -> Bread.SlicedWhiteLoaf.bake(loaves_quantity())
      :sourdough -> Bread.Sourdough.bake(loaves_quantity())
    end
  end

  def using_fastglobal do
    apply(FastGlobal.get(:test)[bread_type()], :bake, [loaves_quantity()])
  end

end



