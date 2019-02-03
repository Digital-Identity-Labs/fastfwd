defmodule Fastfwd.Receiver do

  @moduledoc """
  This module is a quick way to convert a module into a Fastfwd receiver and use it as an adapter or plugin.

  """

  defmacro __using__(opts) do

    tags = List.flatten([Keyword.get(opts, :tags, [])])

    quote do

      @behaviour Fastfwd.Behaviours.Receiver

      @doc """
      List all tags provided by this module

      Returns a list of tags as atoms

      ## Examples

          Icecream.DoubleChocolate.fwd_tags()
          [:chocolate, :double_chocolate]

      """
      @impl Fastfwd.Behaviours.Receiver
      @spec fwd_tags() :: [module]
      def fwd_tags() do
        unquote(tags)
      end

      defoverridable fwd_tags: 0

    end
  end

end