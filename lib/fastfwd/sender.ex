defmodule Fastfwd.Sender do

  defmacro __using__(opts \\ []) do

    namespace = Keyword.get(opts, :namespace, __CALLER__.module)
    behaviour = Keyword.get(opts, :behaviour, nil)

    quote do

      @behaviour Fastfwd.Behaviours.Sender

      def fwd(tag, function_name, params) do
        fwd_modules()
        |> Fastfwd.select(tag)
        |> apply(function_name, params)
      end

      @impl Fastfwd.Behaviours.Sender
      def fwd_tags do
        fwd_modules()
        |> Fastfwd.Modules.tags()
      end

      @impl Fastfwd.Behaviours.Sender
      def fwd_modules() do
        Fastfwd.modules(unquote(namespace), unquote(behaviour))
      end

      def fwd_map() do
        fwd_modules()
        |> Fastfwd.map()
      end

      def load_receivers do

      end


    end

  end

end

