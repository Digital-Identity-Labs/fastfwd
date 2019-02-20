defmodule Fastfwd.Namespace do
  @moduledoc """
  Treat module names as namespaces
  """

  @doc """
  Normalises a module name to a string.

  Returns a string beginning with "Elixir."

  ## Examples

      iex> Fastfwd.Namespace.normalize(Icecream.Chocolate)
      "Elixir.Icecream.Chocolate"

  """
  @spec normalize(module | String.t()) :: [String.t()]
  def normalize(namespace) when is_atom(namespace), do: normalize(Atom.to_string(namespace))

  def normalize(namespace) do
    if String.starts_with?(namespace, "Elixir.") do
      namespace
    else
      "Elixir.#{namespace}"
    end
  end

end