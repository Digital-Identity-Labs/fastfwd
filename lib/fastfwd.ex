defmodule Fastfwd do
  @moduledoc """
  Toolkit for quickly building simple module proxies, adapters, plugins, facades, etc.

  """

  def fwd(modules, tag, function_name, params) do
    modules
    |> Fastfwd.select(tag)
    |> apply(function_name, params)
  end


  @doc """
  Returns a list of all modules within a module namespace

  This will include *any* module with within the namespace, including those that lack a required behaviour.

  ## Examples

      iex> Fastfwd.modules(Icecream)
      [Icecream.Pistachio, Icecream.Spoon, Icecream.Chocolate, Icecream.ShavedIce, Icecream.Strawberry, Icecream.DoubleChocolate]

  In this example Icecream.Spoon is not a receiver, and has no receiver tags.

  """
  @spec modules(module) :: [module]
  def modules(namespace) do
    Fastfwd.Modules.all()
    |> Fastfwd.Modules.in_namespace(namespace)
  end

  @doc """
  Returns a list of all modules within a module namespace, filtered by behaviour.

  ## Examples

      iex> Fastfwd.modules(Icecream, Fastfwd.Behaviours.Receiver)
      [Icecream.Pistachio, Icecream.Chocolate, Icecream.ShavedIce, Icecream.Strawberry, Icecream.DoubleChocolate]

   Icecream.Spoon lacks receiver behaviour so it has been excluded.

  """
  @spec modules(module, module) :: [module]
  def modules(namespace, behaviour) do
    Fastfwd.Modules.all()
    |> Fastfwd.Modules.in_namespace(namespace)
    |> Fastfwd.Modules.with_behaviour(behaviour)
  end

  @doc """
  Returns a list of all modules implementing a Sender behaviour (Fastfwd.Behaviours.Sender)

  ## Examples

      iex> Fastfwd.senders()
      [Icecream]

  """
  @spec senders() :: [module]
  def senders() do
    Fastfwd.Modules.all()
    |> Fastfwd.Modules.with_behaviour(Fastfwd.Behaviours.Sender)
  end

  @doc """
  Finds the first appropriate module from a list of modules for the supplied tag

  Returns the module

  ## Examples

      iex> modules = Fastfwd.modules(Icecream)
      iex> Fastfwd.find(modules, :chocolate)
      Icecream.Chocolate

  """
  @spec find([module], atom) :: [module]
  def find(modules, tag) do
    Fastfwd.Modules.find(modules, tag)
  end

  @doc """
  Finds all tags used by receivers in a list of modules

  Returns a list of tags as atoms

  ## Examples

      iex> modules = Fastfwd.modules(Icecream)
      iex> Fastfwd.tags(modules)
      [:pistachio, :chocolate, :strawberry, :chocolate, :double_chocolate]

  """
  @spec tags([module]) :: [atom]
  def tags(modules) do
    modules
    |> Fastfwd.Modules.tags()
  end

  @doc """
  Returns a map of tags and modules

  ## Examples

      iex> Fastfwd.modules(Icecream) |> Fastfwd.map()
      %{chocolate: Icecream.DoubleChocolate, double_chocolate: Icecream.DoubleChocolate, pistachio: Icecream.Pistachio, strawberry: Icecream.Strawberry}

  """
  @spec map([module]) :: map
  def map(modules) do
    modules
    |> Fastfwd.Modules.map()
  end

  @doc """
  Finds all modules for the first application and preloads them, making them visible to Fastfwd.

  If a module has not been loaded it might not be detected as a Fastfwd sender - in some environments Elixir will only load a module
  when it first accessed, and so modules designed to be accessed by Fastfwd may not be ready.

  Modules using the Fastfwd.Sender module will auto-load their receiver modules, but you may want to manually preload modules if you
  are using Fastfwd to build something more bespoke.

  If no applications are specified then Fastfwd will attempt to search the first application found, assuming it to be the current project.

  ## Examples

      iex> Fastfwd.preload()
      {:ok, [:my_app]}


  """
  @spec preload() :: {:ok, [atom]} | {:error, String.t()}
  defdelegate preload(), to:  Fastfwd.Loader, as: :run

  @doc """
  Finds all modules for listed applications and preloads them, making them visible to Fastfwd.

  If a module has not been loaded it might not be detected as a Fastfwd sender - in some environments Elixir will only load a module
  when it first accessed, and so modules designed to be accessed by Fastfwd may not be ready.

  Modules using the Fastfwd.Sender module will auto-load their receiver modules, but you may want to manually preload modules if you
  are using Fastfwd to build something more bespoke.

  If `:all` is specified then Fastfwd will attempt to search all applications.

  ## Examples

      iex> Fastfwd.preload(:my_app)
      {:ok, [:my_app]}

      iex> Fastfwd.preload([:my_app, :my_app_ee, :extra_plugins])
      {:ok, [:my_app, :my_app_ee, :extra_plugins]}

      iex> Fastfwd.preload(:all)
      {:ok, [:my_app, :fastfwd, :fastglobal, :syntax_tools, :benchee, :deep_merge, :logger, :hex, :inets, :ssl, :public_key, :asn1, :crypto, :mix, :iex, :elixir, :compiler, :stdlib, :kernel]}

  """
  @spec preload([atom]) :: {:ok, [atom]} | {:error, String.t()}
  defdelegate preload(list_of_applications), to: Fastfwd.Loader, as: :run

end

