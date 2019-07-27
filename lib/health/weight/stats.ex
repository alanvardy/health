defmodule Health.Weight.Stats do
  @moduledoc "Weight log and associated calculations"
  @type t :: %__MODULE__{
          logs: [map],
          adjusted_weights: [map],
          trend: map
        }
  defstruct logs: [], adjusted_weights: [], trend: []
end
