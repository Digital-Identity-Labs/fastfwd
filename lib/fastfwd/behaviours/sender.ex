defmodule Fastfwd.Behaviours.Sender do

  @moduledoc """
  Default sender behaviour for Fastfwd.

  This is the behaviour spec used by Fastfwd to quickly build sender modules that will act as
  forwarders, delegetors, proxies or plugin interfaces.

  Please see the Fastfwd.Sender module for the default implementation of this behavior.

  """

  @callback fwd(Atom.t, Atom.t, [Anything]) :: [Atom.t]
  @callback fwd_tags() :: [Atom.t]
  @callback fwd_modules() :: [Module.t]
  @callback fwd_map() :: Map.t

end