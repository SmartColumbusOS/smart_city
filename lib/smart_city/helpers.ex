defmodule SmartCity.Helpers do
  @moduledoc """
  Functions used across SmartCity modules.
  """

  @doc """
  Convert a map with string keys to one with atom keys. Will convert keys nested in a sub-map or a
  map that is part of a list. Ignores atom keys.

  ## Examples

      iex> SmartCity.Helpers.to_atom_keys(%{"abc" => 123})
      %{abc: 123}

      iex> SmartCity.Helpers.to_atom_keys(%{"a" => %{"b" => "c"}})
      %{a: %{b: "c"}}

      iex> SmartCity.Helpers.to_atom_keys(%{"a" => [%{"b" => "c"}]})
      %{a: [%{b: "c"}]}
  """
  @spec to_atom_keys(map()) :: map()
  def to_atom_keys(map) when is_map(map) do
    Map.new(map, fn
      {key, val} when is_map(val) ->
        {String.to_atom(key), to_atom_keys(val)}

      {key, val} when is_list(val) ->
        {String.to_atom(key), Enum.map(val, &to_atom_keys/1)}

      {key, val} when is_binary(key) ->
        {String.to_atom(key), val}

      keyval ->
        keyval
    end)
  end

  def to_atom_keys(value), do: value

  @doc """
  Merges two maps into one, including sub maps. Matching keys from the right map will override their corresponding key in the left map.
  """
  @spec deep_merge(map(), map()) :: map()
  def deep_merge(left, right), do: Map.merge(left, right, &deep_resolve/3)

  defp deep_resolve(_key, %{} = left, %{} = right), do: deep_merge(left, right)
  defp deep_resolve(_key, _left, right), do: right
end
