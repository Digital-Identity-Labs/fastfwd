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

defmodule CachedBread do

  use Fastfwd.Sender, namespace: Bread, cache: true

  def bake(type, loaves) do
    fwd(type, :bake, [loaves])
  end

end

defmodule Bread do

  use Fastfwd.Sender, namespace: Bread, cache: false

  def bake(type, loaves) do
    fwd(type, :bake, [loaves])
  end

end