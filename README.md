# Fastfwd

Plugin-like function forwarding in Elixir, for adapters, factories and other fun.
Fastfwd can be used to provide functionality similar to Rails' ActiveRecord type column,
or to allow third party libraries or applications to extend the functionality of your code.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `fastfwd` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:fastfwd, "~> 0.1.0"}
  ]
end
```

## Example

Rather than hardcode which module to use for each type of data with a case statement like this

```elixir

    case bread_type do
      :barm -> Bread.Barm.bake(loaves_quantity)
      :stottie -> Bread.Stottie.bake(loaves_quantity)
      :sliced -> Bread.SlicedWhiteLoaf.bake(loaves_quantity)
      :sourdough -> Bread.Sourdough.bake(loaves_quantity)
    end

```

Fastfwd will find all suitable modules and direct calls to the module
that matches the "tag".

```elixir
defmodule Bread.Barm do

  use Fastfwd.Receiver, tags: [:barm]
  def bake(loaves), do: "Baking #{loaves} of #{__MODULE__}"

end

defmodule Bread.Stottie do

  use Fastfwd.Receiver, tags: [:stottie]
  def bake(loaves), do: "Baking #{loaves} of #{__MODULE__}"

end

defmodule Bread.SlicedWhiteLoaf do

  use Fastfwd.Receiver, tags: [:sliced]
  def bake(loaves), do: "Baking #{loaves} of #{__MODULE__}"

end

defmodule Bread.Sourdough do

  use Fastfwd.Receiver, tags: [:sourdough]
  def bake(loaves), do: "Baking #{loaves} of #{__MODULE__}"

end

defmodule Bread do

  use Fastfwd.Sender, namespace: Bread, cache: true

  def bake(type, loaves) do
    fwd(type, :bake, [loaves])
  end

end

```


```
Bread.bake(:stottie, 8)
```

## API Documentation

Full documentation can be found at [https://hexdocs.pm/fastfwd](https://hexdocs.pm/fastfwd).


## More Information

https://en.wikipedia.org/wiki/Dynamic_dispatch#Smalltalk_implementation

https://en.wikipedia.org/wiki/Forwarding_(object-oriented_programming)#Applications

http://charlesleifer.com/blog/django-patterns-pluggable-backends/

## Thanks to

https://edmz.org/personal/2016/02/25/dynamic_function_dispatch_with_elixir.html
