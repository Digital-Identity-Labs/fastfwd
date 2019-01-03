defmodule ModulesTest do
  use ExUnit.Case
  use ExMatchers

  doctest Fastfwd.Modules

  describe "all/0" do

    test "returns all modules" do
      all = :code.all_loaded()
            |> Enum.map(&elem(&1, 0))
      assert Fastfwd.Modules.all() == all
    end

    test "returns a list that is not empty" do
      expect Fastfwd.Modules.all(), to_not: be_empty()
    end

    test "returned list includes Elixir modules" do
      expect Fastfwd.Modules.all(), to: include(Elixir.String)
      expect Fastfwd.Modules.all(), to: include(Mix)
    end

    test "returned list includes Erlang module atoms" do
      expect Fastfwd.Modules.all(), to: include(:io)
      expect Fastfwd.Modules.all(), to: include(:application)
    end

  end

  describe "in_namespace/1" do

    test "returns all modules within a namespace" do
      assert Fastfwd.Modules.in_namespace(Icecream) == [
               Icecream.Pistachio,
               Icecream.Spoon,
               Icecream.Chocolate,
               Icecream.ShavedIce,
               Icecream.Strawberry,
               Icecream.DoubleChocolate
             ]
    end

  end

  describe "in_namespace/2" do

    test "filters a module list to only include modules within a namespace" do
      modules = [Icecream.Strawberry, Possum.Bitey, Elixir.String]
      assert Fastfwd.Modules.in_namespace(modules, Icecream) == [Icecream.Strawberry]
    end

  end

  describe "with_behaviour/1" do
    test "returns all modules with the specified behaviour" do
      assert Fastfwd.Modules.with_behaviour(Fastfwd.Behaviours.Receiver) == [
               Icecream.Pistachio,
               Icecream.Chocolate,
               Icecream.ShavedIce,
               Icecream.Strawberry,
               Icecream.DoubleChocolate
             ]
    end
  end

  describe "with_behaviour/2" do
    test "filters a module list to only include modules with the specified behaviour" do
      modules = [Icecream.Pistachio, Icecream.Spoon, Icecream.Chocolate]
      assert Fastfwd.Modules.with_behaviour(modules, Fastfwd.Behaviours.Receiver) == [
               Icecream.Pistachio,
               Icecream.Chocolate
             ]
    end
  end

  describe "with_tags/1" do
    test "filters a list of modules to only include those with a fwd_tags function" do
      assert Fastfwd.Modules.with_tags([Icecream.Pistachio, Icecream.Spoon, Elixir.String]) == [Icecream.Pistachio]
    end
  end

  describe "with_tag/2" do
    test "returns all modules that provide the specified tag" do
      module_list = [
        Icecream.Pistachio,
        Icecream.Spoon,
        Icecream.Chocolate,
        Icecream.ShavedIce,
        Icecream.Strawberry,
        Icecream.DoubleChocolate
      ]
      assert Fastfwd.Modules.with_tag(module_list, :chocolate) == [Icecream.Chocolate, Icecream.DoubleChocolate]
    end

  end

  describe "select/2" do
    test "returns the most appropriate module for the tag (tags are not unique per module)" do
      modules_list = Fastfwd.modules(Icecream, Fastfwd.Behaviours.Receiver)
      assert Fastfwd.Modules.select(modules_list, :chocolate) == Icecream.Chocolate
    end

  end

  describe "tags/1" do
    test "returns all tags provided by a list of modules" do
      modules_list = [Icecream.Pistachio, Icecream.Spoon, Icecream.Chocolate]
      assert Fastfwd.Modules.tags(modules_list) == [:pistachio, :chocolate]
    end

  end

  describe "map/1" do
    test "returns a map of tags (as atoms) mapped to modules" do
      modules_list = [Icecream.Pistachio, Icecream.Spoon, Icecream.Chocolate, Icecream.DoubleChocolate]
      assert Fastfwd.Modules.map(modules_list) ==
               %{
                 pistachio: Icecream.Pistachio,
                 chocolate: Icecream.DoubleChocolate,
                 double_chocolate: Icecream.DoubleChocolate,
               }
    end
  end

end



