defmodule Fastfwd.Sender do

  @moduledoc """
  Functions for a generic Fastfwd sender, such as an adapter frontend, forwarder or facade.
  This module is a quick way to convert a module into a Fastfwd sender, acting as frontend to various tagged receiver
  modules.

  ## Example

  ```
  defmodule Icecream do

    use Fastfwd.Sender

    def mix(type, tubs) do
      fwd(type, :mix, tubs)
    end

    def icecream_types() do
      fwd_tags()
    end

    def icecream_processors() do
      fwd_modules()
    end

  end
  ```

  ## Usage

  Include this module's functions in your module by `use`ing it. Various options can be set to configure it.

  ## Options

  ### :namespace

  Specifies the namespace to search for suitable receiver modules. Modules with names that start with the specified namespace
  will be checked for compatibility.

  In Fastfwd a "namespace" is a fragment of the module naming hierarchy. For instance, setting a namespace of "Icecream" will cause all Elixir modules with
  names beginning with "Icecream." to be selected. Note the "." - Specifying "NetworkAdapter" as a namespace will
  include "NetworkAdapter.Wifi" but will *not* include "NetworkAdapterSettings"

  Specifying Elixir as the namespace will cause all modules to be checked for compatibility.

  Receiver modules must also have a suitable behaviour.

  The default namespace is the module name of the sender.

  #### Examples

      use Fastfwd.Sender

      use Fastfwd.Sender, namespace: Turtles

      use Fastfwd.Sender, namespace: Elixir


  ### :behaviour

  Specifies the behaviour module that is used by receivers for this sender.

  Only modules that implement this behaviour will be detected by the sender.

  The default behaviour is `Fastfwd.Behaviours.Receiver`

  #### Examples

      use Fastfwd.Sender

      use Fastfwd.Sender, behaviour: MyApp.Behaviours.UserType


  ### :cache

  If enabled the cache option will cache the the module search and routing map for the sender. This makes forwarded
  call to receiver functions much faster.

  You should usually leave this set to true.

  The default value is true.

  #### Examples

      use Fastfwd.Sender, cache: true

  ### :default

  This option defined the default module, returned if searching for a tag returns no value.

  It can be used to implement a generic fallback module, or to trigger errors.

  By default nil is returned if a tag cannot be found.

  #### Examples

      use Fastfwd.Sender, default: MyApp.User.GenericUser

      use Fastfwd.Sender, default:  MyApp.User.TypeError


  ### :autoload

  Enables or disables autoloading of modules. If enabled then the module will attempt to find and load modules before
  searching for suitable receivers. This can cause a delay.

  Autoload will only occur once as the result is cached (even if caching is disabled)

  The default value is true.

  #### Examples

      use Fastfwd.Sender, autoload: true


  ### :load_apps

  If `autoload` is enabled then this module will attempt to load modules before searching them. This option specifies
  which applications should be searched for modules.

  The default setting is to load modules from all applications.

  #### Examples

      use Fastfwd.Sender, load_apps: [:my_app, :an_extension_library]

  ## Functions

  Functions will be added to your module

  * fwd
  * fwd_tags/0
  * fwd_modules/0
  * fwd_routes/0

  See `Fastfwd.Behaviours.Sender` for more information

  """

  defmacro __using__(opts \\ []) do

    this_module =  __CALLER__.module
    namespace = Keyword.get(opts, :namespace, this_module)
    behaviour = Keyword.get(opts, :behaviour, nil)
    cache = Keyword.get(opts, :cache, true)
    default = Keyword.get(opts, :default, nil)
    autoload = Keyword.get(opts, :autoload, true)
    load_apps = Keyword.get(opts, :load_apps, :all)

    quote do

      @behaviour Fastfwd.Behaviours.Sender
      @fwd_modcache :"fastfwd/modcache/#{unquote(namespace)}/#{unquote(behaviour)}"
      @fwd_mapcache :"fastfwd/mapcache/#{unquote(namespace)}/#{unquote(behaviour)}"
      @fwd_apploadcache :"fastfwd/apploadcache/#{unquote(this_module)}"
      @fwd_default_module unquote(default)

      @doc """
      Forward a call to a receiver module selected by tag. This function is provided by `Fastfwd.Sender`.

      Returns whatever the receiver method returns.

      ## Examples

          iex> Icecream.fwd(:chocolate, :eat, [8])
          "Eating 8 of Icecream.DoubleChocolate"

      """
      @impl Fastfwd.Behaviours.Sender
      @spec fwd(atom, atom, list) :: Anything
      def fwd(tag, function_name, params) do
        fwd_routes()
        |> Map.get(tag, @fwd_default_module)
        |> apply(function_name, params)
      end

      @doc """
      List all tags provided by this module. This function is provided by `Fastfwd.Sender`.

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
      List all receiver modules used by this module. This function is provided by `Fastfwd.Sender`.

      Returns a list of module names as atoms/modules

      ## Examples

          Icecream.fwd_modules()
         [Icecream.Pistachio, Icecream.Chocolate, Icecream.ShavedIce, Icecream.Strawberry, Icecream.DoubleChocolate]

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
      Returns a map of tags and modules. This function is provided by `Fastfwd.Sender`.

      If more than one module has a particular tag then module sort order will determine which one gets included as the active
      mapping of tag to module.

      ## Examples

          iex> Icecream.fwd_routes()
          %{chocolate: Icecream.DoubleChocolate, double_chocolate: Icecream.DoubleChocolate, pistachio: Icecream.Pistachio, strawberry: Icecream.Strawberry}

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

