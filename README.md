# Fastfwd

Plugin-style function forwarding in Elixir, for adapters, factories and other fun.
Fastfwd can be used to provide functionality similar to Rails' ActiveRecord type column,
or to allow third party libraries or applications to extend the functionality of your code.

*The documentation is still rather patchy and this is the first release. Fastfwd has not been used in production yet.*

[![Hex pm](http://img.shields.io/hexpm/v/fastfwd.svg?style=flat)](https://hex.pm/packages/fastfwd)
[![API Docs](https://img.shields.io/badge/api-docs-yellow.svg?style=flat)](http://hexdocs.pm/fastfwd/)
[![Build Status](https://travis-ci.org/Digital-Identity-Labs/fastfwd.svg?branch=master
"Build Status")](https://travis-ci.org/Digital-Identity-Labs/fastfwd)
[![License](https://img.shields.io/hexpm/l/fastfwd.svg)](LICENSE)

## Installation

The package can be installed by adding `fastfwd` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:fastfwd, "~> 0.1.0"}
  ]
end
```

## Purpose

Elixir lacks OOP inheritance and polymorphism but different types
of data can be processed by selecting a different modules for each type.

Fastfwd proves an alternative to hardcoding which module should be used
for each type of data. You might be using a case statement, like this:

```elixir
    case bread.type do
      :barm -> Bread.Barm.bake(bread.quantity)
      :stottie -> Bread.Stottie.bake(bread.quantity)
      :sliced -> Bread.SlicedWhiteLoaf.bake(bread.quantity)
      :sourdough -> Bread.Sourdough.bake(bread.quantity)
    end
```

This has some disadvantages: whenever you add a new module to handle a new
 data type you need to update all the case statements, and you need to
  know all the modules in advance - it isn't possible to automatically extend
   your application with libraries containing extra data processing modules.

Fastfwd provides an alternative approach: it will search your application
 and libraries to find suitable "receiver" modules, build a table of suitable modules,
 and forward calls from a frontend "sender" module to the appropriate receiver.

 Instead of using a case statement call the method on the sender module like this:

```
Bread.bake(bread.type, bread.quantity)
```

If caching is enabled then Fastfwd can be quite fast - not as fast as using
a static case statement, but close. In my benchmarking it takes 7µs vs 6µs
for an equivalent case statement.

## Usage

### 1) Using the Sender and Receiver modules

The easiest way to use Fastfwd is to `use` the included `Fastfwd.Sender` and `Fastfwd.Receiver` modules to extend your own modules. If you
want more control then the Fastfwd module provides some utility functions that you can use to extend or replace
the bundled `Fastfwd.Sender` and `Fastfwd.Receiver`.

Read the `Fastfwd.Sender` and `Fastfwd.Receiver` docs for more information.

### 2) Writing your own Sender and Receiver modules

When you `use` the `Fastfwd.Sender` it will by default search for modules
that implement the `Fastfwd.Behaviours.Receiver` behaviour, like `Fastfwd.Sender`. If
you need different behaviour you can write your own implementations of
`Fastfwd.Behaviours.Receiver` or `Fastfwd.Behaviours.Sender` behaviour or
specify different behaviours.

Read the `Fastfwd.Behaviours.Sender` and `Fastfwd.Behaviours.Receiver` docs for more information.

### 3) Using the utility functions

Fastfwd works by building a list of suitable modules, then collecting the tags of those modules,
then providing an alternative to `Kernel.apply` that uses a tag to select a module. The supplied
`Fastfwd.Sender` makes this process faster by caching the module list and tag lookup table using
 [Discord's FastGlobal library](https://github.com/discordapp/fastglobal).

The top level `Fastfwd` module contains some useful functions for listing modules and
extracting tags, while `Fastfwd.Modules` and `Fastfwd.Module` have some lower-level
utilities for filtering lists of modules.

These utilities can be used to validating or process tags before using them
to call functions, such as when read and writing to a database or accepting
user input.

## Examples

### Using the Sender and Receiver modules

In this example we create modules to bake various type of bread. We will
create a Bread module that receives order structs and passes the request
to the correct sub-module.

The modules doing the hard work `use` the `Fastfwd.Receiver` module.

```elixir
defmodule Bread.Barm do

  use Fastfwd.Receiver, tags: [:barm]
  def bake(loaves), do: "Baking #{loaves} Lancashire barm cakes"

end

defmodule Bread.Stottie do

  use Fastfwd.Receiver, tags: [:stottie]
  def bake(loaves), do: "Baking #{loaves} Newcastle stotties"

end

defmodule Bread.SlicedWhiteLoaf do

  use Fastfwd.Receiver, tags: [:sliced]
  def bake(loaves), do: "Baking #{loaves} sliced white loaves"

end

defmodule Bread.Sourdough do

  use Fastfwd.Receiver, tags: [:sourdough, :paindecampagne]
  def bake(loaves), do: "Baking #{loaves} pain de campagne"

end

```

Another module is configured to act as a forwarder - this is the module
the rest of your code will interact with. It `use`s the `Fastfwd.Sender`
 module, and is configured to search for suitable modules under the
 'Bread' module namespace.

```elixir
defmodule Bread do

  use Fastfwd.Sender, namespace: Bread, cache: true

  def bake(type, loaves) do
    fwd(type, :bake, [loaves])
  end

end

```

We can then call the appropriate bake function via the forwarder, and
the correct sender module's bake function will be called.

```
Bread.bake(:stottie, 8)
```

### Integrating With Ecto

One of the biggest reasons Fastfwd was created was to mimic the way
Ruby on Rails' ActiveRecord will return polymorphic sub-classes using a
`type` field in the database.

To only store records with a type that matches available tags, verify that
the record's tag is actually supported by a module:

```
def changeset(bread_order, params \\ %{}) do
    user
    |> validate_inclusion(:type, Bread.fwd_tags)
    |> cast(params, [:type, :quantity])
    |> validate_required([:type, :quantity])
end
```


## API Documentation

Full API documentation can be found at
 [https://hexdocs.pm/fastfwd](https://hexdocs.pm/fastfwd).

## Contributing

You can request new features by creating an [issue](https://github.com/Digital-Identity-Labs/fastfwd/issues),
or submit a [pull request](https://github.com/Digital-Identity-Labs/fastfwd/pulls) with your contribution.

## Copyright and License

Copyright (c) 2019 Digital Identity Ltd, UK

Fastfwd is MIT licensed.

## References

 * https://en.wikipedia.org/wiki/Dynamic_dispatch#Smalltalk_implementation
 * https://en.wikipedia.org/wiki/Forwarding_(object-oriented_programming)#Applications
 * http://charlesleifer.com/blog/django-patterns-pluggable-backends/

## Thanks

The "fast" in Fastfwd is from [Discord's FastGlobal library](https://github.com/discordapp/fastglobal)

The "fwd" in Fastfwd is based on the technique [in this blog post](https://edmz.org/personal/2016/02/25/dynamic_function_dispatch_with_elixir.html)



