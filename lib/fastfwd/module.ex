defmodule Fastfwd.Module do
  @moduledoc """
  Interact with individual Fastfwd-compatible modules - check for tags, behaviours, and so on.
  """

  @doc """
  Finds all tags for a module

  Returns a list of atoms if any tags are found, otherwise it returns an empty list.

  ## Examples

      iex> Fastfwd.Module.tags(Icecream.DoubleChocolate)
      [:chocolate, :double_chocolate]

  """
  @spec tags(module) :: [atom]
  def tags(module) do
    try do
      if tagged?(module) do
        module.fwd_tags || []
      else
        []
      end
    rescue
      []
    end
  end

  @doc """
  Does a tag exist for a module?

  Returns true or false.

  It's possible for a module to have a tag yet and not be the selected module for that tag, as it's possible for modules
  to share a tag - they are not unique.

  ## Examples

      iex> Fastfwd.Module.has_tag?(Icecream.DoubleChocolate, :chocolate)
      true

  """
  @spec has_tag?(module, atom) :: boolean
  def has_tag?(module, tag) do
    tags(module)
    |> Enum.member?(tag)
  end

  @doc """
  Does a module have the specified behaviour?

  Returns true or false.

  ## Examples

      iex> Fastfwd.Module.has_behaviour?(Icecream.Spoon, Fastfwd.Behaviours.Receiver)
      false

  """
  @spec has_behaviour?(module, module) :: boolean
  def has_behaviour?(_module, nil) do
    false
  end

  def has_behaviour?(module, behaviour) do
    module.module_info[:attributes]
    |> Keyword.get(:behaviour, [])
    |> Enum.member?(behaviour)
  end

  @doc """
  Does a module have support tags?

  Returns true or false.

  ## Examples

      iex> Fastfwd.Module.tagged?(Icecream.Spoon)
      false

      iex> Fastfwd.Module.tagged?(Icecream.Chocolate)
      true

  """
  @spec tagged?(module) :: boolean
  def tagged?(module) do
    has_behaviour?(module, Fastfwd.Behaviours.Receiver) || :erlang.function_exported(module, :fwd_tags, 0)
  end

end