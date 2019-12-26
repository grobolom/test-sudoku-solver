defmodule SudokuSolver do
  @moduledoc """
  Documentation for SudokuSolver.
  """

  @doc """
  Tries to solve!

  board = [
    [0,0,4,5,0,9,0,0,0],
    [0,2,8,7,0,0,9,0,0],
    [0,7,9,0,4,0,0,0,8],
    [0,0,0,0,7,1,0,0,4],
    [0,0,0,0,9,0,3,0,6],
    [0,0,0,2,5,0,0,1,0],
    [0,9,0,0,2,0,4,6,0],
    [0,6,0,9,0,5,0,0,0],
    [7,0,0,3,0,4,1,2,0],
  ]

  SudokuSolver.solve(board)

  # output
  [
    [1,3,4,5,8,9,6,7,2],
    [5,2,8,7,3,6,9,4,1],
    [6,7,9,1,4,2,5,3,8],
    [8,5,3,6,7,1,2,8,4],
    [2,1,7,4,9,8,3,5,6],
    [9,4,6,2,5,3,8,1,7],
    [3,9,1,8,2,7,4,6,5],
    [4,6,2,9,1,5,7,8,3],
    [7,8,5,3,6,4,1,2,9],
  ]

  """
  def solve(initial_board) do
    # this will return a bigass list of all the zero locations
    unsolved_elements = unsolved_elements(initial_board)

    # this is where we start
    index = 0

    # when board is valid, go to the next element with n = 1
    # when board is invalid, and n < 9, go to the same element with n += 1
    # when board is invalid, and n = 9, go to the last element with n -= 1
    solvo(initial_board, unsolved_elements, index, 1, 0)
  end

  def unsolved_elements(board) do
    Enum.zip(Range.new(1, 9), board) \
    |> Enum.map(fn({row_index, row}) ->
      Enum.zip(Range.new(1, 9), row) \
      |> Enum.map(fn({col_index, e}) -> {row_index, col_index, e} end)
    end) \
    |> List.flatten \
    |> Enum.filter(fn({_, _, e}) -> e == 0 end)
  end

  def solvo(board, unsolved, i, n, iteration) do
    new_board = get_new_board(board, Enum.at(unsolved, i), n)

    valid = is_valid(new_board)

    cond do
      n > 9 ->
        {r, c, _} = Enum.at(unsolved, i - 1)
        x = Enum.at(board, r - 1) |> Enum.at(c - 1)

        {a, b, _} = Enum.at(unsolved, i)
        superboard = get_new_board(board, {a, b, nil}, 0)

        solvo(superboard, unsolved, i - 1, x + 1, iteration + 1)
      i < 0 ->
        new_board
      valid == true and i == length(unsolved) - 1 ->
        new_board
      valid == true ->
        solvo(new_board, unsolved, i + 1, 1, iteration + 1)
      valid == false and n < 9 ->
        solvo(new_board, unsolved, i, n + 1, iteration + 1)
      valid == false and n == 9 ->
        # last cell to figure out what value we start at when we
        # step back
        {r, c, _} = Enum.at(unsolved, i - 1)
        x = Enum.at(board, r - 1) |> Enum.at(c - 1)

        # current cell to figure out which value we replace with a zero
        {a, b, _} = Enum.at(unsolved, i)
        superboard = get_new_board(board, {a, b, nil}, 0)

        solvo(superboard, unsolved, i - 1, x + 1, iteration + 1)
      true ->
        new_board
    end
  end

  def get_new_board(board, {r, c, _}, n) do
    row = board |> Enum.at(r - 1)
    new_row = row |> List.replace_at(c - 1, n)

    board |> List.replace_at(r - 1, new_row)
  end

  def is_valid(board) do
    rows = get_rows(board)
    columns = get_columns(board)
    blocks = get_blocks(board)

    rows_are_valid(rows) and columns_are_valid(columns) and blocks_are_valid(blocks)
  end

  # returns a list of lists of elements of the rows. Unordered
  def get_rows(board, _range \\ 9) do
    board
  end

  # returns a list of lists of elements of the columns. Unordered
  def get_columns(board, range \\ 9) do
    indexes = Range.new(1, range)
    Enum.map(indexes, fn(row) -> Enum.map(indexes, fn(col) -> board |> Enum.at(col - 1) |> Enum.at(row - 1) end ) end)
  end

  # returns a list of lists of elements of the 9 blocks in sudoku. Unordered
  def get_blocks(board) do
    block_ranges = [
      [Range.new(1, 3), Range.new(1, 3)],
      [Range.new(4, 6), Range.new(1, 3)],
      [Range.new(7, 9), Range.new(1, 3)],
      [Range.new(1, 3), Range.new(4, 6)],
      [Range.new(4, 6), Range.new(4, 6)],
      [Range.new(7, 9), Range.new(4, 6)],
      [Range.new(1, 3), Range.new(7, 9)],
      [Range.new(4, 6), Range.new(7, 9)],
      [Range.new(7, 9), Range.new(7, 9)],
    ]

    Enum.map(block_ranges, fn([row_range, col_range]) ->
      Enum.map(row_range, fn(row) ->
        Enum.map(col_range, fn(col) ->
          board
          |> Enum.at(col - 1)
          |> Enum.at(row - 1)
        end)
      end)
      |> List.flatten
    end)
  end

  def rows_are_valid(rows) do
    Enum.all?(rows, fn(row) -> row_valid(row) end)
  end

  def row_valid(row) do
    no_zeroes = Enum.reject(row, fn(e) -> e == 0 end)
    Enum.uniq(no_zeroes) == no_zeroes
  end

  def columns_are_valid(rows) do
    rows_are_valid(rows)
  end

  def blocks_are_valid(blocks) do
    rows_are_valid(blocks)
  end

  """
  ### discussion
  We are going to solve by brute force, essentially. At every step, we are
  going to look at the next open cell and try a number for that cell. We will
  evaluate if the value we tried is valid by looking at the board as a whole
  and determining if it breaks any rules. If it does not, we move on to the next
  cell. If it does, we will try the next number [1..9]. If we run out of numbers
  to try that are valid, we will step back one tried cell, consider that
  invalid, and try from there again.

  The state that we'd like to track is a list, and the elements it contains
  should have the following information:

  1. the current number that we are trying in that cell
  2. the location of the cell in the grid

  We need the number being currently tried because we may need to back up and
  re-evaluate. We need the cell we were looking at so we can properly set up
  the board.

  We also need to track the initial board. We have the whole array, but
  we need to see both the x and y but also the value of the element.

  ### elements
  [x, y], x -> 1..9, y-> 1..9


  """
end
