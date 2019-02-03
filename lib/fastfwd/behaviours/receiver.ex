defmodule Fastfwd.Behaviours.Receiver do

  @moduledoc """
  Default receiver Behaviour specification

  This is the behaviour spec used by Fastfwd to quickly build receiver modules that will act as adapters or
  plugins. Please see the Fastfwd.Receiver module for the default implementation of this behavior.

  """

  @callback fwd_tags() :: [Atom.t]

end