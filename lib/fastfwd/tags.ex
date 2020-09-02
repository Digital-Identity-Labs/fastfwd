defmodule Fastfwd.Tags do
  @moduledoc """
  Validate and process tags
  """

  alias Fastfwd.Tag

  def to_strings(module) when is_atom(module) do
    module.fwd_tags()
    |> Enum.map(fn x -> Tag.to_string(x) end)
  end

  def to_strings(tags) when is_list(tags) do
    Enum.map(tags, fn x -> Tag.to_string(x) end)
  end

  def to_string(tags) do
    tags
    |> to_strings()
    |> Enum.join(", ")
  end

end