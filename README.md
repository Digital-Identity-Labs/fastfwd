# Fastfwd

Plugin style function forwarding in Elixir, for adapters, factories and other fun.
Fastfwd can be used to provide functionality similar to Rails' ActiveRecord type column,
or to allow third party libraries or applications to extend the functionality of your code.

*The documentation is still rather patchy and this is the first release. Fastfwd has not been used in production yet.*

[![Hex pm](http://img.shields.io/hexpm/v/fastfwd.svg?style=flat)](https://hex.pm/packages/fastfwd)
[![API Docs](https://img.shields.io/badge/api-docs-yellow.svg?style=flat)](http://hexdocs.pm/fastfwd/)
[![Build Status](https://travis-ci.org/Digital-Identity-Labs/fastfwd.svg?branch=master
"Build Status")](https://travis-ci.org/Digital-Identity-Labs/fastfwd)
[![License](https://img.shields.io/hexpm/l/fastfwd.svg)](LICENSE)

## Installation

The package can be installed
by adding `fastfwd` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:fastfwd, "~> 0.1.0"}
  ]
end
```

## Example

Fastfwd proves an alternative to hardcoding which module should be used for each type of data, for example with a case statement, like this

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

Fastfwd-compatible modules are given tags:

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

```

Another module is configured to act as a forwarder - this is the module
the rest of your code will interact with.

```elixir
defmodule Bread do

  use Fastfwd.Sender, namespace: Bread, cache: true

  def bake(type, loaves) do
    fwd(type, :bake, [loaves])
  end

end

```

You can then call the appropriate module's function via the forwarder

```
Bread.bake(:stottie, 8)
Bread.bake(order.type, order.quantity)
```

You can easily integrate Fastfwd with with Ecto.

To only store records with a type that matches available tags:

```
def changeset(bread_order, params \\ %{}) do
    user
    |> validate_inclusion(:type, Bread.fwd_tags)
    |> cast(params, [:type, :quantity])
    |> validate_required([:type, :quantity])
end
```



## API Documentation

Full documentation can be found at [https://hexdocs.pm/fastfwd](https://hexdocs.pm/fastfwd).


## More Information

https://en.wikipedia.org/wiki/Dynamic_dispatch#Smalltalk_implementation

https://en.wikipedia.org/wiki/Forwarding_(object-oriented_programming)#Applications

http://charlesleifer.com/blog/django-patterns-pluggable-backends/

## Thanks to

https://edmz.org/personal/2016/02/25/dynamic_function_dispatch_with_elixir.html
