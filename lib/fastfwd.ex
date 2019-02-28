defmodule Fastfwd do
  @moduledoc """
  Toolkit for quickly building simple module proxies, adapters, plugins, facades, and so on.

  Fastfwd can be used to provide functionality similar to Rails' ActiveRecord type column,
  or to allow third party libraries or applications to extend the functionality of your code.

  Please read the Readme.md file for an introduction.

  ## Usage

  ### 1) Using the Sender and Receiver modules

  The easiest way to use Fastfwd is to `use` the included `Fastfwd.Sender` and `Fastfwd.Receiver` modules to extend your own modules. If you
  want more control then the Fastfwd module provides some utility functions that you can use to extend or replace
  the bundled `Fastfwd.Sender` and `Fastfwd.Receiver`.

  Read the `Fastfwd.Sender` and `Fastfwd.Receiver` docs for more information.

  ### 2) Writing your own Sender and Receiver modules

  When you `use` the `Fastfwd.Sender` it will by default search for modules
  that implement the `Fastfwd.Behaviours.Receiver` behaviour, like `Fastfwd.Sender`. If
  you need different behaviour you can write your own implementations of
  `Fastfwd.Behaviours.Receiver` or `Fastfwd.Behaviours.Sender` behaviour or
  specify different behaviours.

  Read the `Fastfwd.Behaviours.Sender` and `Fastfwd.Behaviours.Receiver` docs for more information.

  ### 3) Using the utility functions

  Fastfwd works by building a list of suitable modules, then collecting the tags of those modules,
  then providing an alternative to `Kernel.apply` that uses a tag to select a module. The supplied
  `Fastfwd.Sender` makes this process faster by caching the module list and tag lookup table using
  [Discord's FastGlobal library](https://github.com/discordapp/fastglobal).

  The top level `Fastfwd` module contains some useful functions for listing modules and
  extracting tags, while `Fastfwd.Modules` and `Fastfwd.Module` have some lower-level
  utilities for filtering lists of modules.

  These utilities can be used to validating or process tags before using them
  to call functions, such as when read and writing to a database or accepting
  user input.

  This top-level module, `Fastfwd`, contains the most useful utilties for (2) and (3).

  """

  def fwd(modules, tag, function_name, params) do
    modules
    |> Fastfwd.find(tag)
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

      iex> Fastfwd.modules(Icecream) |> Fastfwd.routes()
      %{chocolate: Icecream.DoubleChocolate, double_chocolate: Icecream.DoubleChocolate, pistachio: Icecream.Pistachio, strawberry: Icecream.Strawberry}

  """
  @spec routes([module]) :: map
  def routes(modules) do
    modules
    |> Fastfwd.Modules.routes()
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

