defmodule Fastfwd.Behaviours.Sender do

  @moduledoc """
  Default sender behaviour for Fastfwd.

  This is the behaviour spec used in Fastfwd by default for sender modules that will act as
  forwarders, delegators, proxies or plugin interfaces.

  Please see the `Fastfwd.Sender` module for the default implementation of this behavior.

  """

  @doc """
  Forward a call to a receiver module selected by tag

  Returns whatever the receiver method returns.

  ## Examples

      iex> Icecream.fwd(:chocolate, :eat, [8])
      "Eating 8 of Icecream.DoubleChocolate"

  """
  @callback fwd(Atom.t, Atom.t, [Anything]) :: [Atom.t]


  @doc """
  List all tags provided by this module's receiver modules

  Returns a list of tags as atoms

  ## Examples

      iex> Icecream.fwd_tags()
      [:pistachio, :chocolate, :strawberry, :chocolate, :double_chocolate]

  """
  @callback fwd_tags() :: [Atom.t]

  @doc """
  List all receiver modules used by this module

  Returns a list of module names as atoms/modules

  ## Examples

     iex> Icecream.fwd_modules()
     [Icecream.Pistachio, Icecream.Chocolate, Icecream.ShavedIce, Icecream.Strawberry, Icecream.DoubleChocolate]

  """
  @callback fwd_modules() :: [Module.t]

  @doc """
  Returns a map of tags and modules

  If more than one module has a particular tag then module sort order will determine which one gets included as the active
  mapping of tag to module.

  ## Examples

      iex> Icecream.fwd_routes()
      %{chocolate: Icecream.DoubleChocolate, double_chocolate: Icecream.DoubleChocolate, pistachio: Icecream.Pistachio, strawberry: Icecream.Strawberry}

  """
  @callback fwd_routes() :: Map.t

end