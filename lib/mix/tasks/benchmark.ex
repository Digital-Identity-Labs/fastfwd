defmodule Mix.Tasks.Benchmark do
  use Mix.Task

  @shortdoc "Comparitive speed tests"
  def run(_) do

    require Bread.Stottie
    require Bread.Barm
    require Bread.SlicedWhiteLoaf
    require Bread.Sourdough

    Benchee.run(
      %{
        "FastFwd (no cache)" => fn -> using_fastfwd(false) end,
        "FastFwd (cached)" => fn -> using_fastfwd(true) end,
        "Case statement and then calling modules directly" => fn -> using_case() end,

      },
      time: 5,
      warmup: 2,
      memory_time: 2,
      pre_check: true,
      formatters: [{Benchee.Formatters.Console, extended_statistics: true}]
    )

  end

  def bread_type() do
    :stottie
  end

  def loaves_quantity() do
    8
  end

  def using_fastfwd(cache \\ true) do
    if cache do
      Bread.bake(bread_type(), loaves_quantity())
    else
      CachedBread.bake(bread_type(), loaves_quantity())
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

end



