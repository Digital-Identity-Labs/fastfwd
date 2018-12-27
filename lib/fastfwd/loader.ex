defmodule Fastfwd.Loader do

  def run() do
    [probably_the_application()]
    |> run()
  end

  def run(apps) do
    Enum.each(
      apps,
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
  end

  defp probably_the_application() do
    {app, app_name, app_version} = Application.started_applications(1000)
                                   |> List.first()
    app
  end



  ## https://stackoverflow.com/questions/36433481/find-all-modules-that-adopted-behavior

  #
  #  def run(behaviour \\ Fastfwd.Behaviours.Receiver) do
  #    available_modules(behaviour)
  #    |> Enum.reduce([], &load_module/2)
  #  end
  #
  #  defp load_module(module, modules) do
  #    if Code.ensure_loaded?(module), do: [module | modules], else: modules
  #  end
  #
  #  defp available_modules(behaviour) do
  #
  #    Mix.Task.run("loadpaths", [])
  #
  #    Path.wildcard(Path.join([Mix.Project.build_path, "**/ebin/**/*.beam"]))
  #    |> Stream.map(
  #         fn path ->
  #           {:ok, {mod, chunks}} = :beam_lib.chunks('#{path}', [:attributes])
  #           {mod, get_in(chunks, [:attributes, :behaviour])}
  #         end
  #       )
  #      # Filter out behaviours we don't care about and duplicates
  #    |> Stream.filter(fn {_mod, behaviours} -> is_list(behaviours) && behaviour in behaviours end)
  #    |> Enum.uniq
  #    |> Enum.map(fn {module, _} -> module end)
  #  end


end

