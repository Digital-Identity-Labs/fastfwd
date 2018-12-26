defmodule Fastfwd.Behaviours.Sender do

  @callback fwd_tags() :: [Atom.t]
  @callback fwd_modules() :: [Module.t]

end