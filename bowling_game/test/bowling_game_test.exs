defmodule BowlingGameTest do
  use ExUnit.Case
  doctest BowlingGame

  setup do
    {:ok, game} = BowlingGame.start()
    %{game: game}
  end

  test "gutter game", %{game: game} do
    roll_many(game, 20, 0)
    
    assert BowlingGame.score(game) == 0 
  end

  test "all ones", %{game: game} do
    roll_many(game, 20, 1)

    assert BowlingGame.score(game) == 20 
  end

  test "one spare", %{game: game} do
    roll_spare(game)
    BowlingGame.roll(game, 3)

    roll_many(game, 17, 0)

    assert BowlingGame.score(game) == 16
  end

  test "one strike", %{game: game} do
    roll_strike(game)
    BowlingGame.roll(game, 3)
    BowlingGame.roll(game, 4)

    roll_many(game, 16, 0)

    assert BowlingGame.score(game) == 24 
  end

  test "perfect game", %{game: game} do
    roll_many(game, 12, 10)

    assert BowlingGame.score(game) == 300
  end

  defp roll_many(game, n, pins) do
    1..n
    |> Enum.each(fn _ ->
      BowlingGame.roll(game, pins)
    end)
  end

  defp roll_spare(game) do
    BowlingGame.roll(game, 5)
    BowlingGame.roll(game, 5)
  end

  defp roll_strike(game) do
    BowlingGame.roll(game, 10)
  end
end
