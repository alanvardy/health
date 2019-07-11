defmodule Health.Stats.Graph do
  @moduledoc "For rendering graphs"
  @spec render(List.t(), any) :: any
  def render(data, layout \\ %{}) do
    json_data = Jason.encode!(data)
    json_layout = Jason.encode!(layout)
    unique_id = :erlang.unique_integer([:positive])
    EEx.eval_string(template(), data: json_data, layout: json_layout, id: unique_id)
  end

  @spec template :: <<_::1280>>
  def template do
    """
    <div class="plotly-ex">
    <div id="plotly-ex-body-<%= id %>"></div>
    <script>
    Plotly.plot('plotly-ex-body-<%= id %>', <%= data %>, <%= layout %>)
    </script>
    </div>
    """
  end
end
