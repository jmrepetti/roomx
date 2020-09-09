defmodule Roomx.Mines do
  # may require a seed
  def random_mines_positions(list, mines_to_plant, max_cells) do
    if mines_to_plant > 0 do
      mine_position = :rand.uniform(max_cells)
      if Enum.member?(list, mine_position) do #try again if already taken
        random_mines_positions(list, mines_to_plant, max_cells)
      else
        random_mines_positions([mine_position | list], mines_to_plant - 1, max_cells)
      end
    else
      list
    end
  end

  def gen_empty_and_mines(total_cells, mines_positions) do
    Enum.map(1..total_cells, fn x ->
      if Enum.member?(mines_positions, x) do
        'M'
      else
        'E'
      end
    end)
  end

  def cells_around_a_cell(pos, max_x, max_y) do
    max = max_x * max_y
    top = pos - max_x
    bottom = pos  + max_x
    [
      top,
      top - 1,
      top + 1,
      pos - 1, #left,
      pos + 1, #right,
      bottom ,
      bottom - 1,
      bottom + 1
    ]
    |> Enum.filter(fn x ->
      x >= 0 && x <= max
    end)
    |> Enum.filter(fn x ->
      # for first column, reject everything on the left
      if rem(pos, max_x) == 0 do
        x != pos - 1 &&
        x != bottom - 1 &&
        x != top -  1
      else
        true
      end
      # if pos
      # x >= 0 && x <= max
    end)
    |> Enum.filter(fn x ->
      # for last column, reject everything on the right
      if pos > 0 && rem(pos, max_x - 1) == 0 do
        x != pos + 1 &&
        x != bottom + 1 &&
        x != top + 1
      else
        true
      end
    end)
  end


  def add_mines_around(map, max_x, max_y) do
    map
    |> Enum.with_index
    |> Enum.map(fn({x, pos}) ->
      if x == 'E' do
        near_cells = cells_around_a_cell(pos, max_x, max_y)
        count = Enum.reduce(near_cells, 0, fn cell, acc ->
          if Enum.at(map, cell) == 'M', do: acc + 1, else: acc
        end)
        if count > 0, do: count, else: x
      else
        x
      end
    end)
  end

  @spec generate_map(number, number, any) :: any
  def generate_map(xval,yval,mines) do
    total_cells = xval * yval
    mines_positions = random_mines_positions([], mines, total_cells)
    gen_empty_and_mines(total_cells, mines_positions)
      |> add_mines_around(xval, yval)
  end
end
