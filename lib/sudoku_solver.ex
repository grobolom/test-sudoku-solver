defmodule SudokuSolver do
  @moduledoc """
  Documentation for SudokuSolver.
  """

  @doc """
  Tries to solve!

  SudokuSolver.solve(
    [
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
  )

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
  def solve(input) do
    input
  end

  def is_valid(board) do
    rows = get_rows(board)
    columns = get_columns(board)
    blocks = get_blocks(board)

    rows_are_valid(rows) and columns_are_valid(columns) and blocks_are_valid(blocks)
  end

  def get_rows(board) do
    []
  end

  def get_columns(board) do
    []
  end

  def get_blocks(board) do
    []
  end

  def rows_are_valid(rows) do
    true
  end

  def columns_are_valid(rows) do
    true
  end

  def blocks_are_valid(blocks) do
    true
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
