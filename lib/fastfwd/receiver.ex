defmodule Fastfwd.Receiver do

  @moduledoc """
  This module is a quick way to convert a module into a Fastfwd receiver and use it as an adapter or plugin.

  ## Example

  ```
  defmodule Icecream.Strawberry do

    use Fastfwd.Receiver, tags: [:strawberry]

    def mix(tubs), do: "Mixing strawberry"

  end

  ```

  ## Usage

  Include this module's functions in your module by `use`ing it, and use the tags option to tag your module with a type.

  ## Options

  ### tags

  A list of names/tags for this module, as atoms. These are the types that your module will handle.

  If you are processing records in a database they may be stored be the `type` column, or as `driver` or `adapter`, but
  Fastfwd uses `tag` as more neutral term.

  #### Examples

      use Fastfwd.Receiver, tags: [:wifi]

      use Fastfwd.Receiver, tags: [:admin, :administrator]

  ## Functions

  Functions will be added to your module

  * fwd_tags/0

  See `Fastfwd.Behaviours.Receiver` for more information

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
      @spec fwd_tags() :: [module()]
      def fwd_tags() do
        unquote(tags)
      end

      defoverridable fwd_tags: 0

    end
  end

end