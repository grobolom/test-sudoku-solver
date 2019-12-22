defmodule SudokuSolverTest do
  use ExUnit.Case
  doctest SudokuSolver

  test "greets the world" do
    assert SudokuSolver.solve(:foo) == :foo
  end
end
