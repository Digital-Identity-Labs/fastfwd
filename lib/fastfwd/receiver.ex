defmodule Fastfwd.Receiver do

  @moduledoc """
  Behaviour for implementing a typical Fastfwd receiver, such as a plugin or adapter implentation
  """


  defmacro __using__(opts) do

    tags = List.flatten([Keyword.get(opts, :tags, [])])

    quote do

      @behaviour Fastfwd.Behaviours.Receiver

      @impl Fastfwd.Behaviours.Receiver
      def fwd_tags() do
        unquote(tags)
      end

      defoverridable fwd_tags: 0

    end
  end

end