defmodule Fastfwd.Sender do

  @moduledoc """
    Behaviour for implementing a typical Fastfwd sender, such as an adapter frontend, forwarder or facade
  """

  defmacro __using__(opts \\ []) do

    namespace = Keyword.get(opts, :namespace, __CALLER__.module)
    behaviour = Keyword.get(opts, :behaviour, nil)
    cache = Keyword.get(opts, :cache, true)
    fallback = Keyword.get(opts, :fallback, nil)


    quote do

      @behaviour Fastfwd.Behaviours.Sender
      @on_load :load_receivers
      @fwd_modcache :"fastfwd/modcache/#{unquote(namespace)}/#{unquote(behaviour)}"

      def fwd(tag, function_name, params) do
        fwd_modules()
        |> Fastfwd.select(tag)
        |> apply(function_name, List.flatten([params]))
      end

      @impl Fastfwd.Behaviours.Sender
      def fwd_tags do
        fwd_modules()
        |> Fastfwd.Modules.tags()
      end

      @impl Fastfwd.Behaviours.Sender
      def fwd_modules() do
        if unquote(cache) do
          cached_mods = FastGlobal.get(@fwd_modcache)
          if is_nil(cached_mods) do
            cached_mods = Fastfwd.modules(unquote(namespace), unquote(behaviour))
            FastGlobal.put(@fwd_modcache, cached_mods)
          end
          cached_mods
        end
        Fastfwd.modules(unquote(namespace), unquote(behaviour))
      end

      def fwd_map() do
        fwd_modules()
        |> Fastfwd.map()
      end

      def load_receivers do
        case Fastfwd.Loader.run(:all) do
          {:ok, _} -> :ok
          _ -> raise "Error preloading modules for #{__MODULE__}"
        end
      end

    end

  end

end

