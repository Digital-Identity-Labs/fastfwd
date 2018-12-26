defmodule Fastfwd do
  @moduledoc """
  Documentation for Fastfwd.
  """

  alias Fastfwd.Modules
  alias Fastfwd.Module

  def modules(namespace, behaviour) do
    Modules.all()
    |> Modules.in_namespace(namespace)
    |> Modules.with_behaviour(behaviour)
  end

  def senders() do
    Modules.all()
    |> Modules.with_behaviour(Fastfwd.Behaviours.Sender)
  end

  def select(modules, tag) do
    Module.with_tag(modules, tag)
  end

  def tags(modules) do
    modules
    |> Fastfwd.Modules.tags()
  end

  def map(modules) do
    modules
    |> Fastfwd.Modules.map()
  end

end

