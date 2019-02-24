defmodule Fastfwd.Modules do

  alias Fastfwd.Namespace

  @moduledoc """
  Interact with Fastfwd-compatible modules - find, filter, build maps.
  """

  @doc """
  Lists *all* modules, whether or not they are using Fastfwd.

  Returns a list of module names, including both Elixir style and Erlang atoms.

  ## Examples

      iex> Fastfwd.Modules.all |> List.first()
      :io

  """
  @spec all() :: [module]
  def all() do
    :code.all_loaded()
    |> Enum.map(&elem(&1, 0))
  end

  @doc """

  Lists all modules in a module namespace (with names under the module name)

  Returns a list of module  names

  ## Examples

      iex> Fastfwd.Modules.in_namespace(Icecream)
      [Icecream.Pistachio, Icecream.Spoon, Icecream.Chocolate, Icecream.ShavedIce, Icecream.Strawberry, Icecream.DoubleChocolate]


  """
  @spec in_namespace(module) :: [module]
  def in_namespace(namespace) do
    all()
    |> in_namespace(namespace)
  end

  @doc """
  Filters a list of modules to only include those under a particular namespace

  Returns filtered list of modules

  ## Examples

      iex> module_list = [Icecream.Pistachio, FrozenYogurt.FullCellphoneBattery, Icecream.Chocolate]
      iex> Fastfwd.Modules.in_namespace(module_list, Icecream)
      [Icecream.Pistachio, Icecream.Chocolate]


  """
  @spec in_namespace([module], module) :: [module]
  def in_namespace(modules, namespace) do
    namespace = Namespace.normalize(namespace)
    modules
    |> Enum.filter(&String.starts_with?(Atom.to_string(&1), "#{namespace}."))
  end

  @doc """
  Lists all modules with the specified behaviour.

  Returns a list of module names

  ## Examples

      iex> Fastfwd.Modules.with_behaviour(Fastfwd.Behaviours.Sender)
      [Icecream]


  """
  @spec with_behaviour(module) :: [module]
  def with_behaviour(behaviour) do
    all()
    |> with_behaviour(behaviour)
  end

  @doc """
  Filters a list of modules to only include those with the specified behaviour

  Returns filtered list of modules

  ## Examples

      iex> module_list = [Icecream.Pistachio, Icecream.Spoon, Icecream.Chocolate, Icecream.ShavedIce, Icecream.Strawberry, Icecream.DoubleChocolate]
      iex> Fastfwd.Modules.with_behaviour(module_list, Fastfwd.Behaviours.Receiver)
      [Icecream.Pistachio, Icecream.Chocolate, Icecream.ShavedIce, Icecream.Strawberry, Icecream.DoubleChocolate]

  """
  @spec with_behaviour([module], module) :: [module]
  def with_behaviour(modules, nil), do: modules
  def with_behaviour(modules, behaviour) do
    modules
    |> Enum.filter(&Fastfwd.Module.has_behaviour?(&1, behaviour))
  end

  @doc """
  Find modules that have tags (any tags at all)

  Returns a filtered list of modules

  ## Examples

      iex> module_list = [Icecream.Pistachio, Icecream.Spoon]
      iex> Fastfwd.Modules.with_tags(module_list)
      [Icecream.Pistachio]

  """
  @spec with_tags([module]) :: [module]
  def with_tags(modules) do
    modules
    |> Enum.filter(fn (module) -> Fastfwd.Module.tagged?(module) end)
  end

  @doc """
  Find all modules that have the specified tag.

  Tags are not necessarily unique -  more than one module may have the same tag.

  Returns a filtered list of modules

  ## Examples

      iex> module_list = [Icecream.Pistachio, Icecream.Spoon, Icecream.Chocolate, Icecream.ShavedIce, Icecream.Strawberry, Icecream.DoubleChocolate]
      iex> Fastfwd.Modules.with_tag(module_list, :chocolate)
      [Icecream.Chocolate, Icecream.DoubleChocolate]


  """
  @spec with_tag([module], atom) :: module
  def with_tag(modules, tag) do
    modules
    |> with_tags()
    |> Enum.filter(fn (module) -> Fastfwd.Module.has_tag?(module, tag) end)
  end

  @doc """
  Find the first module that has the specified tag.

  Returns a single module name.

  ## Examples

      iex> modules_list = Fastfwd.modules(Icecream, Fastfwd.Behaviours.Receiver)
      iex> Fastfwd.Modules.find(modules_list, :chocolate)
      Icecream.Chocolate


  """
  @spec find([module], atom, nil | module) :: module
  def find(modules, tag, default \\ nil) do
    modules
    |> Enum.find(default, fn (module) -> Fastfwd.Module.has_tag?(module, tag) end)
  end

  @doc """
  List all tags found in a collection of modules

  Returns a list of atoms
  Returns a list of atoms

  ## Examples

      iex> modules_list = [Icecream.Pistachio, Icecream.Spoon, Icecream.Chocolate]
      iex> Fastfwd.Modules.tags(modules_list)
      [:pistachio, :chocolate]

  """
  @spec tags([module]) :: [atom]
  def tags(modules) do
    modules
    |> Enum.map(fn (module) -> Fastfwd.Module.tags(module) end)
    |> List.flatten
  end

  @doc """
  Build a map of tags to modules, *without duplicated tags*.

  Returns a map of atoms to module names.

  ## Examples

      iex> modules_list = [Icecream.Pistachio, Icecream.Spoon, Icecream.Chocolate, Icecream.DoubleChocolate]
      iex> Fastfwd.Modules.routes(modules_list)
      %{
        pistachio: Icecream.Pistachio,
        chocolate: Icecream.DoubleChocolate,
        double_chocolate: Icecream.DoubleChocolate,
      }

  """
  @spec routes([module]) :: map
  def routes(modules) do
    for module <- modules,
        tag <- Fastfwd.Module.tags(module),
        into: Map.new(),
        do: {tag, module}
  end

end



