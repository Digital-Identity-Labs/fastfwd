defmodule LoaderTest do
  use ExUnit.Case
  use ExMatchers

  doctest Fastfwd.Loader


  ##
  ## TODO/FIXME: I'm testing the output rather than the actual functionality because doing the right thing seems
  ## rather difficult - need to find better approach.

  describe "run/0" do

    test "returns a tuple of :ok and applications" do
      assert {:ok, applications} = Fastfwd.Loader.run()
    end

    test "returned applications list is array of atoms" do
      {:ok, applications} = Fastfwd.Loader.run()
      expect applications, to_not: be_empty()
      Enum.each(applications, fn (application) -> assert is_atom(application)  end)
    end

    test "returned applications list contains one item" do
      {:ok, applications} = Fastfwd.Loader.run()
      expect applications, to: have_items(1)
    end

  end

  describe "run/1" do

    test "returns a tuple of :ok and applications" do
      assert {:ok, applications} = Fastfwd.Loader.run()
    end

    test "returned applications list is array of atoms" do
      {:ok, applications} = Fastfwd.Loader.run()
      expect applications, to_not: be_empty()
      Enum.each(applications, fn (application) -> assert is_atom(application)  end)
    end

    test "specifying a list of applications should result in those applications being returned" do
      {:ok, applications} = Fastfwd.Loader.run([:ex_unit, :ssl, :elixir])
     assert applications == [:ex_unit, :ssl, :elixir]
    end

    test "specifying a single atom of :all should cause all applications to be searched, and returned as list" do
      {:ok, applications} = Fastfwd.Loader.run(:all)
      expect applications, to_not: be_empty()
      assert applications == Application.started_applications(1000)
                             |> Enum.map(fn ({app, _, _}) -> app end)
    end

  end

end

