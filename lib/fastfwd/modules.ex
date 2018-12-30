defmodule Fastfwd.Modules do
  @moduledoc """
  Interact with Fastfwd-compatible modules - find, filter, build maps.
  """


  def all() do
    :code.all_loaded()
    |> Enum.map(&elem(&1, 0))
  end

  def in_namespace(namespace) do
    all()
    |> in_namespace(namespace)
  end

  def in_namespace(modules, namespace) do
    modules
    |> Enum.filter(&String.starts_with?(Atom.to_string(&1), "#{namespace}."))
  end

  def with_behaviour(modules, nil) do
    modules
  end

  def with_behaviour(modules, behaviour) do
    modules
    |> Enum.filter(&Fastfwd.Module.has_behaviour?(&1, behaviour))
  end

  def with_tags() do

  end

  def with_tags(modules) do

  end

  def with_tags(modules, tags) do

  end

  def with_tag(modules, tag) do
    modules
    |> Enum.find(tag, fn (x) -> x == tag end)
  end

  def select(modules, tag) do
    modules
    |> Enum.find(fn (module) -> Fastfwd.Module.has_tag?(module, tag) end)
  end

  def tags(modules) do
    modules
    |> Enum.map(fn (module) -> Fastfwd.Module.tags(module) end)
    |> List.flatten
  end

  def map(modules) do
    for module <- modules,
        tag <- Fastfwd.Module.tags(module),
        into: Map.new(),
        do: {tag, module}
  end

end
