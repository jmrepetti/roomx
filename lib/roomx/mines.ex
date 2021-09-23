defmodule Roomx.Mines do
  use Memoize

  defmemo neighbor_cells(pos, max_x, max_y) do
    north = pos - max_x
    northe = north + 1
    northw = north - 1
    west = pos - 1
    east = pos + 1
    south = pos + max_x
    southw = south - 1
    southe = south + 1
    IO.inspect "neighbor_cells for: #{pos}"
    neigh = [
      northw,
      north,
      northe,
      west,
      east,
      southw,
      south,
      southe
    ]
    # |> IO.inspect(charlists: :as_lists)
    |> Enum.filter(fn x ->
      # remove any negative value or bigger than total cells
      x >= 0 && x <= (max_x * max_y)
    end)
    |> Enum.filter(fn x ->
      # for first column, reject everything on the left
      if pos == 0 || (rem(pos, max_x) == 0) do
        # IO.inspect "for first column, reject everything on the left: #{pos}"
        # IO.inspect([west, northw, southw], charlists: :as_lists)
        !Enum.member?([west, northw, southw], x)
      else
        true
      end
      # if pos
      # x >= 0 && x <= max
    end)
    |> Enum.filter(fn x ->
      # for last column, reject everything on the right
      if pos > 0 && rem(pos, max_x - 1) == 0 do
        # IO.inspect "for last column, reject everything on the right: #{pos}"
        # IO.inspect([east, northe, southe], charlists: :as_lists)
        !Enum.member?([east, northe, southe], x)
      else
        true
      end
    end)
  end
  # may require a seed
  def random_numbers(list, n, max) do
    if n > 0 do
      mine_position = :rand.uniform(max)
      if Enum.member?(list, mine_position) do #try again if already taken
        random_numbers(list, n, max)
      else
        random_numbers([mine_position | list], n - 1, max)
      end
    else
      list
    end
  end

  def gen_map(mines, max) do
    mines_location = random_numbers([], mines, max)
    Enum.map(1..max, fn x ->
      if Enum.member?(mines_location, x), do: 'M', else: 'E'
    end)
  end

  defp count_neighbor_mines(map, cell_pos, max_x, max_y) do
    neighbor_cells(cell_pos, max_x, max_y)
    |> Enum.reduce(0, fn pos, acc ->
        if Enum.at(map, pos) == 'M', do: acc + 1, else: acc
    end)
  end

  defp mark_near_mines(map, max_x, max_y) do
    map
    |> Enum.with_index
    |> Enum.map(fn({cell, idx}) ->
      if cell != 'M' do # == 'E' doesn't work, because adding marks replace E with numbers
        count = count_neighbor_mines(map, idx, max_x, max_y)
        if count > 0, do: count, else: cell
      else
        cell
      end
    end)
  end

  @spec generate_map(number, number, any) :: any
  def generate_map(xval,yval,mines) do
    gen_map(mines, xval * yval)
    |> mark_near_mines(xval, yval)
  end
end
