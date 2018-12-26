defmodule Fastfwd.OldSender do

  defmacro __using__(opts \\ []) do

    {method, source} = cond do
      Keyword.get(opts, :behaviour) -> {:behavior, Keyword.get(opts, :behaviour)}
      Keyword.get(opts, :namespace) -> {:namespace, Keyword.get(opts, :namespace, __MODULE__)}
      Keyword.get(opts, :children) -> {:namespace, __MODULE__}
      true -> {:namespace, __MODULE__}
    end

    quote do

      def fwd(tag, function_name, params) do
        Fastfwd.modules(namespace, behaviour)
        |> Fastfwd.select(tag)
        |> apply(function_name, params)
      end

      def fwd_tags do
        Fastfw.modules(namespace)
        |> Enum.map(fn (module) -> module.fwd_tags end)
        |> List.flatten
      end

      def has_fwd_tag?(fwd_tags, tag) do
        Enum.find(fwd_tags, fn (x) -> x == tag end)
      end

      def available_fwd_modules() do
        :code.all_loaded()
        |> Enum.map(&elem(&1, 0))
        |> Enum.filter(&String.starts_with?(Atom.to_string(&1), "#{__MODULE__}."))
      end

      defp select_fwd_module(tag) do
        available_fwd_modules()
        |> Enum.find(fn (module) -> has_fwd_tag?(module.fwd_tags, tag) end)
      end

    end

  end

end

