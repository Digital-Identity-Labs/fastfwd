defmodule Icecream.Chocolate do

  use Fastfwd.Receiver, tags: [:chocolate]
  def eat(spoons), do: "Eating #{spoons} of #{__MODULE__}"

end

defmodule Icecream.Strawberry do

  use Fastfwd.Receiver, tags: [:strawberry]
  def eat(spoons), do: "Eating #{spoons} of #{__MODULE__}"


end

defmodule Icecream.Pistachio do

  use Fastfwd.Receiver, tags: [:pistachio]
  def eat(spoons), do: "Eating #{spoons} of #{__MODULE__}"

end

defmodule Icecream.DoubleChocolate do

  use Fastfwd.Receiver, tags: [:chocolate, :double_chocolate]
  def eat(spoons), do: "Eating #{spoons} of #{__MODULE__}"

end

defmodule Icecream.Spoon do

  def material, do: "metal"

end

defmodule Icecream do

  use Fastfwd.Sender

  def eat(type, spoons) do
    fwd(type, :eat, spoons)
  end

end