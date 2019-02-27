defmodule Fastfwd.Behaviours.Receiver do

  @moduledoc """
  Default receiver Behaviour specification

  This is the behaviour spec used by Fastfwd by default for receiver modules that will act as adapters or
  plugins.

  Please see the `Fastfwd.Receiver` module for the default implementation of this behavior.

  The default `Fastfwd.Sender` module can be told to search for *any* behaviour, not just this one, but it should still
  be compatible with this.

  """

  @doc """
  List all tags provided by this module

  Returns a list of tags as atoms

  ## Examples

      Icecream.DoubleChocolate.fwd_tags()
      [:chocolate, :double_chocolate]

  """
  @callback fwd_tags() :: [Atom.t]

end