defmodule Fastfwd.Loader do
  @moduledoc """
  Makes sure all modules for the specified applications have been loaded *before* Fastfwd searches them for suitable behaviours.

  In some environments Elixir will only load a module when it's first accessed. This means that modules designed to be
  accessed by Fastfwd might not be already loaded when it searches for them, and will not be detected properly.

  You won't need to use this module if your sender modules are `use`-ing the Fastfwd.Sender module, as it will auto-load
  their receiver modules.

  If you are using Fastfwd to build something more bespoke then you may want to manually preload modules using Fastfwd.Loader
  """

  @doc """
  Finds all modules for the *first* application and preloads them, making them visible to Fastfwd.

  If no applications are specified then Fastfwd will attempt to search the first application found, assuming it to be
  the current project. It's best to specify the projects you want to search.

  ## Examples

      iex> Fastfwd.Loader.run()
      {:ok, [:my_app]}

  """
  @spec run() :: {:ok, [atom]} | {:error, string}
  def run() do
    probably_this_application()
    |> run()
  end

  @doc """
  Finds all modules for listed applications and preloads them, making them visible to Fastfwd.


  If `:all` is specified then Fastfwd will attempt to search all applications.

  ## Examples

      iex> Fastfwd.Loader.run(:my_app)
      {:ok, [:my_app]}

      iex> Fastfwd.Loader.run([:my_app, :my_app_ee, :extra_plugins])
      {:ok, [:my_app, :my_app_ee, :extra_plugins]}

      iex> Fastfwd.Loader.run(:all)
      {:ok, [:my_app, :fastfwd, :fastglobal, :syntax_tools, :benchee, :deep_merge, :logger, :hex, :inets, :ssl, :public_key, :asn1, :crypto, :mix, :iex, :elixir, :compiler, :stdlib, :kernel]}

  """
  @spec run(:all) :: {:ok, [atom]} | {:error, String.t()}
  def run(:all) do
    all_applications()
    |> run()
  end

  @doc """
  Finds all modules for listed applications and preloads them, making them visible to Fastfwd.


  If `:all` is specified then Fastfwd will attempt to search all applications.

  ## Examples

      iex> Fastfwd.Loader.run(:my_app)
      {:ok, [:my_app]}

      iex> Fastfwd.Loader.run([:my_app, :my_app_ee, :extra_plugins])
      {:ok, [:my_app, :my_app_ee, :extra_plugins]}

      iex> Fastfwd.Loader.run(:all)
      {:ok, [:my_app, :fastfwd, :fastglobal, :syntax_tools, :benchee, :deep_merge, :logger, :hex, :inets, :ssl, :public_key, :asn1, :crypto, :mix, :iex, :elixir, :compiler, :stdlib, :kernel]}

  """
  @spec run([atom]) :: {:ok, [atom]} | {:error, String.t()}
  def run(apps) do
    List.flatten([apps])
    |> Enum.reject(fn x -> x == :undefined end)
    |> Enum.each(
         fn app ->
           {:ok, modules} = :application.get_key(app, :modules)
           Enum.each(
             modules,
             fn mod ->
               Code.ensure_loaded?(mod)
             end
           )
         end
       )
    {:ok, apps}
  end

  ## I realise this is almost certainly not the best way to do this. TODO: Find the best way to do this
  defp probably_this_application() do
    all_applications()
    |> List.first()
  end

  ## Collect the names of all loaded applications as atoms
  defp all_applications() do
    Application.started_applications(1000)
    |> Enum.map(fn ({app, _, _}) -> app end)
  end

end

