defmodule Fastfwd.Tag do
  @moduledoc """
  Validate and process tags
  """

  alias __MODULE__
  alias Fastfwd.Tags

  def validate(tags, tag) when is_list(tags) do
    if valid?(tags, tag) do
      {:ok, to_atom(tag)}
    else
      {:error, "Tag #{tag} is not present in list of tags #{IO.inspect(tags)}"}
    end
  end

  def validate(tags, tag) when is_atom(tags) do
    validate(tags.fwd_tags(), tag)
  end

  def valid?(tags, tag) do
    Enum.member?(Tags.to_strings(tags), Tag.to_string(tag))
  end

  def to_string(tag) when is_binary(tag) do
    tag
  end

  def to_string(tag) when is_atom(tag) do
    Atom.to_string(tag)
  end

  def to_atom(tag) when is_atom(tag) do
    tag
  end

  def to_atom(tag) when is_binary(tag) do
    try do
      String.to_existing_atom(tag)
    rescue
      RuntimeError -> raise ArgumentError, message: "Cannot convert '#{tag}' into tag atom - it has not already been defined"
    end
  end

end

