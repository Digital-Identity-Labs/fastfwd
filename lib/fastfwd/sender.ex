defmodule Fastfwd.Sender do

  @moduledoc """
    A typical Fastfwd sender, such as an adapter frontend, forwarder or facade
  """

  defmacro __using__(opts \\ []) do

    namespace = Keyword.get(opts, :namespace, __CALLER__.module)
    behaviour = Keyword.get(opts, :behaviour, nil)
    cache = Keyword.get(opts, :cache, true)
    fallback = Keyword.get(opts, :fallback, nil)
    autoload = Keyword.get(opts, :autoload, true)
    load_apps = Keyword.get(opts, :load_apps, :all)

    quote do

      @behaviour Fastfwd.Behaviours.Sender
      @fwd_modcache :"fastfwd/modcache/#{unquote(namespace)}/#{unquote(behaviour)}"
      @fwd_mapcache :"fastfwd/mapcache/#{unquote(namespace)}/#{unquote(behaviour)}"
      @fwd_apploadcache :"fastfwd/apploadcache"

      @doc """
      Forward a call to a receiver module selected by tag

      Returns whatever the receiver method returns.

      ## Examples

          iex> Icecream.fwd(:chocolate, :eat, [8])
          "Eating 8 of Icecream.DoubleChocolate"

      """
      @impl Fastfwd.Behaviours.Sender
      @spec fwd(atom, atom, list) :: Anything
      def fwd(tag, function_name, params) do
        fwd_map()[tag]
        |> apply(function_name, params)
      end

      @doc """
      List all tags provided by this module

      Returns a list of tags as atoms

      ## Examples

          Icecream.DoubleChocolate.fwd_tags()
          [:chocolate, :double_chocolate]

      """
      @impl Fastfwd.Behaviours.Sender
      @spec fwd_tags() :: [module]
      @impl Fastfwd.Behaviours.Sender
      def fwd_tags do
        fwd_modules()
        |> Fastfwd.Modules.tags()
      end

      @doc """
      List all tags provided by this module

      Returns a list of tags as atoms

      ## Examples

          Icecream.DoubleChocolate.fwd_tags()
          [:chocolate, :double_chocolate]

      """
      @impl Fastfwd.Behaviours.Sender
      @spec fwd_modules() :: [module]
      @impl Fastfwd.Behaviours.Sender
      def fwd_modules() do
        if unquote(cache) do
          cached_mods = FastGlobal.get(@fwd_modcache)
          if is_nil(cached_mods) do
            if unquote(autoload), do: {:ok, _} = fwd_cached_app_autoloader()
            mods = Fastfwd.modules(unquote(namespace), unquote(behaviour))
            :ok = FastGlobal.put(@fwd_modcache, mods)
            mods
          else
            cached_mods
          end
        else
          if unquote(autoload), do: {:ok, _} = fwd_cached_app_autoloader()
          Fastfwd.modules(unquote(namespace), unquote(behaviour))
        end

      end

      @doc """
      List all tags provided by this module

      Returns a list of tags as atoms

      ## Examples

          Icecream.DoubleChocolate.fwd_map()
          [:chocolate, :double_chocolate]

      """
      @impl Fastfwd.Behaviours.Sender
      @spec fwd_routes() :: Map.t()
      def fwd_routes() do
        if unquote(cache) do
          cached_map = FastGlobal.get(@fwd_mapcache)
          if is_nil(cached_map) do
            map = fwd_modules()
                  |> Fastfwd.routes()
            :ok = FastGlobal.put(@fwd_mapcache, map)
            map
          else
            cached_map
          end
        else
          fwd_modules()
          |> Fastfwd.routes()
        end
      end

      ## Scan and load all modules in advance, and cache this to save a little time.
      ## The first run is still rather slow
      defp fwd_cached_app_autoloader() do
        case FastGlobal.get(@fwd_apploadcache) do
          nil -> cached_appload = Fastfwd.Loader.run(unquote(load_apps))
                 FastGlobal.put(@fwd_apploadcache, cached_appload)
                 cached_appload
          stored -> stored
        end
      end

    end

  end

end

