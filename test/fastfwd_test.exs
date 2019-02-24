defmodule FastfwdTest do
  use ExUnit.Case
  doctest Fastfwd, except: [preload: 1, preload: 0]

  describe "modules/2" do

    test "returns all modules under the specified namespace that match the specified protocol" do
      assert Fastfwd.modules(Icecream, Fastfwd.Behaviours.Receiver) == [
               Icecream.Pistachio,
               Icecream.Chocolate,
               Icecream.ShavedIce,
               Icecream.Strawberry,
               Icecream.DoubleChocolate
             ]
    end

    test "returns all modules under the specified namespace if no protocol is specified" do
      assert Fastfwd.modules(Icecream) == [
               Icecream.Pistachio,
               Icecream.Spoon,
               Icecream.Chocolate,
               Icecream.ShavedIce,
               Icecream.Strawberry,
               Icecream.DoubleChocolate
             ]
    end

    test "Returns an empty list if nothing matches" do
      assert Fastfwd.modules(ThisDoesNotExist) == []
    end

  end

  describe "senders/0" do
    test "returns all sender modules (using default Fastfwd.Behaviours.Sender behaviour)" do
      assert Fastfwd.senders() == [Icecream]
    end
  end

  describe "find/2" do
    test "returns the first of the modules to support the tag" do
      assert Fastfwd.modules(Icecream)
             |> Fastfwd.find(:chocolate) == Icecream.Chocolate
    end
  end

  describe "tags/1" do
    test "returns all tags from the modules" do
      assert Fastfwd.modules(Icecream)
             |> Fastfwd.tags() == [:pistachio, :chocolate, :strawberry, :chocolate, :double_chocolate]
    end
  end

  describe "routes/1" do
    test "returns a map of active tags to modules" do
      assert Fastfwd.modules(Icecream)
             |> Fastfwd.routes() == %{
               chocolate: Icecream.DoubleChocolate,
               double_chocolate: Icecream.DoubleChocolate,
               pistachio: Icecream.Pistachio,
               strawberry: Icecream.Strawberry
             }
    end
  end

end
