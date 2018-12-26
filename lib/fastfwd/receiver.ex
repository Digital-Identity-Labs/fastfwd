defmodule Fastfwd.Receiver do

  defmacro __using__(opts) do

    tags = Keyword.get(opts, :tags, [])

    quote do

      def fwd_tags() do
        List.flatten([unquote(tags)])
      end

      defoverridable fwd_tags: 0

    end
  end

end