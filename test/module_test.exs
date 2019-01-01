defmodule ModuleTest do
  use ExUnit.Case
  doctest Fastfwd.Module

  describe "tags/1" do

    test "returns all tags for a module" do
      assert Fastfwd.Module.tags(Icecream.DoubleChocolate) == [:chocolate, :double_chocolate]
    end

    test "Returns an empty list for any module that lacks tags" do
      assert Fastfwd.Module.tags(Icecream.Spoon) == []
    end

  end

  describe "has_tag?/2" do

    test "returns true if a module has the specified tag" do
      assert Fastfwd.Module.has_tag?(Icecream.DoubleChocolate, :chocolate) == true
    end

    test "returns false if a module lacks the specified tag" do
      assert Fastfwd.Module.has_tag?(Icecream.DoubleChocolate, :vanilla) == false
    end

    test "returns false if a module has no tags" do
      assert Fastfwd.Module.has_tag?(Icecream.Spoon, :metalic) == false
    end

  end

  describe "has_behaviour?/2" do

    test "returns true if a module has the specified behaviour" do
      assert Fastfwd.Module.has_behaviour?(Icecream.Chocolate, Fastfwd.Behaviours.Receiver) == true
    end

    test "returns false if a module lacks the specified behaviour" do
      assert Fastfwd.Module.has_behaviour?(Icecream.Chocolate, Fastfwd.Behaviours.Sender) == false
    end

  end

  describe "tagged?/2" do

    test "returns true if a module has the fwd_tags function and tags" do
      assert Fastfwd.Module.tagged?(Icecream.Chocolate) == true
    end

    test "returns true if a module has the fwd_tags function and no actual tags" do
      assert Fastfwd.Module.tagged?(Icecream.ShavedIce) == true
    end

    test "returns true if a module does not have the fwd_tags function" do
      assert Fastfwd.Module.tagged?(Icecream.Spoon) == false
    end

  end

end
