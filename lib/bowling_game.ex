defmodule BowlingGame do
  @moduledoc """
  Documentation for `BowlingGame`.
  """

  def start() do
    rolls = Tuple.duplicate(0, 20)
    Agent.start_link(fn -> {0, rolls, 0} end) 
  end

  def roll(game, pins) do
    Agent.get_and_update(game, fn {score, rolls, current_roll} = state ->
      {state, {score + pins, Tuple.insert_at(rolls, current_roll, pins), current_roll + 1}}
    end)
  end

  def score(game) do
    Agent.get(game, fn {_score, rolls, _current_roll} ->
      0..9
      |> Enum.reduce({0, 0}, fn _frame, {score, frame_index} ->
        cond do
          is_strike(rolls, frame_index) ->
            {score + strike_bonus(rolls, frame_index), frame_index + 1}
          is_spare(rolls, frame_index) ->
            {score + spare_bonus(rolls, frame_index), frame_index + 2}
          true ->
            {score + point_in_frame(rolls, frame_index), frame_index + 2}
        end
      end)
      |> elem(0)
    end)
  end

  defp is_strike(rolls, frame_index) do
    elem(rolls, frame_index) == 10
  end

  defp is_spare(rolls, frame_index) do
    elem(rolls, frame_index) + elem(rolls, frame_index + 1) == 10
  end

  defp strike_bonus(rolls, frame_index) do
    10 + elem(rolls, frame_index + 1) + elem(rolls, frame_index + 2)
  end

  defp spare_bonus(rolls, frame_index) do
    10 + elem(rolls, frame_index + 2)
  end

  defp point_in_frame(rolls, frame_index) do
    elem(rolls, frame_index) + elem(rolls, frame_index + 1)
  end
end
