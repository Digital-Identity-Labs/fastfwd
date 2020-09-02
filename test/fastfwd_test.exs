defmodule FastfwdTest do
  use ExUnit.Case
  doctest Fastfwd,
          except: [
            preload: 1,
            preload: 0
          ]

  describe "modules/2" do

    test "returns all modules under the specified namespace that match the specified protocol" do
      assert Fastfwd.modules(Icecream, Fastfwd.Behaviours.Receiver)
             |> Enum.sort() == [
               Icecream.Chocolate,
               Icecream.DoubleChocolate,
               Icecream.Pistachio,
               Icecream.ShavedIce,
               Icecream.Strawberry
             ]
    end

    test "returns all modules under the specified namespace if no protocol is specified" do
      assert Fastfwd.modules(Icecream)
             |> Enum.sort() ==  [Icecream.Chocolate, Icecream.DoubleChocolate, Icecream.Pistachio, Icecream.ShavedIce, Icecream.Spoon, Icecream.Strawberry]
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
      assert Icecream
             |> Fastfwd.modules()
             |> Fastfwd.find(:chocolate) == Icecream.Chocolate
    end
  end

  describe "tags/1" do
    test "returns all tags from the modules" do
      assert Icecream
             |> Fastfwd.modules()
             |> Fastfwd.tags()
             |> Enum.sort() == [:chocolate, :chocolate, :double_chocolate, :pistachio, :strawberry]
    end
  end

  describe "routes/1" do
    test "returns a map of active tags to modules" do
      assert Map.equal? Icecream
                        |> Fastfwd.modules()
                        |> Fastfwd.routes(), %{
                          chocolate: Icecream.DoubleChocolate,
                          double_chocolate: Icecream.DoubleChocolate,
                          pistachio: Icecream.Pistachio,
                          strawberry: Icecream.Strawberry
                        }
    end
  end

end
