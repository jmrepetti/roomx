defmodule Roomx.RoomsAgent do
  use Agent

  def start_link(_arg) do
    Agent.start_link(fn -> %{}  end, name: __MODULE__)
  end

  def update(id, state) do
    # add or override existing state
    Agent.update(__MODULE__, &Map.put(&1, id, state))
  end

  def get(id) do
    Agent.get(__MODULE__, &Map.get(&1, id))
  end

  def delete(id) do
    Agent.update(__MODULE__, &Map.delete(&1, id))
  end
end
