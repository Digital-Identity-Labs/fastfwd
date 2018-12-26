defmodule Fastfwd.Module do

  def tags(module) do
    try do
      if tagged?(module) do
        module.fwd_tags || []
      end
    rescue
      []
    end
  end

  def has_tag?(module, tag) do
    Enum.find(Fastfwd.Modumodule, fn (x) -> x == tag end)
  end

  def has_behaviour?(module, nil) do
    false
  end

  def has_behaviour?(module, behaviour) do
    module.module_info[:attributes]
    |> Keyword.get(:behaviour, [])
    |> Enum.member?(behaviour)
  end

  def tagged?(module) do
    :erlang.function_exported(module, :fwd_tags, 0)
  end

end