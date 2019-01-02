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
      assert Fastfwd.Modules.in_namespace(Icecream) == [Icecream.Pistachio, Icecream.Spoon, Icecream.Chocolate, Icecream.ShavedIce, Icecream.Strawberry, Icecream.DoubleChocolate]
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
      assert Fastfwd.Modules.with_behaviour(Fastfwd.Behaviours.Receiver) == [Icecream.Pistachio, Icecream.Chocolate, Icecream.ShavedIce, Icecream.Strawberry, Icecream.DoubleChocolate]
    end
  end

  describe "with_behaviour/2" do
    test "filters a module list to only include modules with the specified behaviour" do
      modules = [Icecream.Pistachio, Icecream.Spoon, Icecream.Chocolate]
      assert Fastfwd.Modules.with_behaviour(modules, Fastfwd.Behaviours.Receiver) == [Icecream.Pistachio, Icecream.Chocolate]
    end
  end

  describe "with_tags/1" do


  end

  describe "with_tag/2" do


  end

  describe "select/2" do


  end

  describe "tags/1" do


  end

  describe "map/1" do

  end

end
