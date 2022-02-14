defmodule HangmanImplGameTest do
  use ExUnit.Case
  alias Hangman.Impl.Game

  test "new game returns structure" do
    game = Game.new_game()

    assert game.turns_left() == 7
    assert game.game_state() == :initializing
    assert length(game.letters()) > 0
  end

  test "new game returns correct word" do
    game = Game.new_game("wombat")

    assert game.turns_left() == 7
    assert game.game_state() == :initializing
    assert game.letters() == ["w", "o", "m", "b", "a", "t"]
  end

  test "new game returns lower case word" do
    game = Game.new_game("APPLE")

    assert game.turns_left() == 7
    assert game.game_state() == :initializing
    assert game.letters() == ["a", "p", "p", "l", "e"]
  end

  test "state doesn't change if a gaime is won or lost" do
    for state <- [:won, :lost] do
      game = Game.new_game("wombat")
      game = Map.put(game, :game_state, state)
      {new_game, _tally} = Game.make_move(game, "x")
      assert new_game == game
    end
  end

  test "a duplicate letter is reported" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "y")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "we record letters used" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    {game, _tally} = Game.make_move(game, "y")
    {game, _tally} = Game.make_move(game, "x")
    assert MapSet.equal?(game.used, MapSet.new(["x", "y"]))
  end

  test "we recognize a letter in the word" do
    game = Game.new_game("wombat")
    {_game, tally} = Game.make_move(game, "m")
    assert tally.game_state == :good_guess
    {_game, tally} = Game.make_move(game, "t")
    assert tally.game_state == :good_guess
  end

  test "we recognize a letter not in the word" do
    game = Game.new_game("wombat")
    {_game, tally} = Game.make_move(game, "x")
    assert tally.game_state == :bad_guess
    {_game, tally} = Game.make_move(game, "t")
    assert tally.game_state == :good_guess
    {_game, tally} = Game.make_move(game, "y")
    assert tally.game_state == :bad_guess
  end

  test "can handle a sequence of moves" do
    [
      # guess | state | turns left | letters | used
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]],
      ["x", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]]
    ]
    |> test_sequence_of_moves()
  end

  test "can handle a winning game" do
    [
      # guess | state | turns left | letters | used
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]],
      ["x", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]],
      ["l", :good_guess, 5, ["_", "e", "l", "l", "_"], ["a", "e", "l", "x"]],
      ["l", :already_used, 5, ["_", "e", "l", "l", "_"], ["a", "e", "l", "x"]],
      ["o", :good_guess, 5, ["_", "e", "l", "l", "o"], ["a", "e", "l", "o", "x"]],
      ["b", :bad_guess, 4, ["_", "e", "l", "l", "o"], ["a", "b", "e", "l", "o", "x"]],
      ["h", :won, 4, ["h", "e", "l", "l", "o"], ["a", "b", "e", "h", "l", "o", "x"]]
    ]
    |> test_sequence_of_moves()
  end

  test "can handle a lossing game" do
    [
      # guess | state | turns left | letters | used
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["x", :bad_guess, 5, ["_", "_", "_", "_", "_"], ["a", "x"]],
      ["y", :bad_guess, 4, ["_", "_", "_", "_", "_"], ["a", "x", "y"]],
      ["z", :bad_guess, 3, ["_", "_", "_", "_", "_"], ["a", "x", "y", "z"]],
      ["z", :already_used, 3, ["_", "_", "_", "_", "_"], ["a", "x", "y", "z"]],
      ["B", :bad_guess, 2, ["_", "_", "_", "_", "_"], ["B", "a", "x", "y", "z"]],
      ["c", :bad_guess, 1, ["_", "_", "_", "_", "_"], ["B", "a", "c", "x", "y", "z"]],
      ["d", :lost, 0, ["h", "e", "l", "l", "o"], ["B", "a", "c", "d", "x", "y", "z"]]
    ]
    |> test_sequence_of_moves()
  end

  def test_sequence_of_moves(script) do
    game = Game.new_game("hello")
    Enum.reduce(script, game, &check_one_move/2)
  end

  defp check_one_move([guess, state, turns, letters, used], game) do
    {game, tally} = Game.make_move(game, guess)
    assert tally.game_state == state
    assert tally.turns_left == turns
    assert tally.letters == letters
    assert tally.used == used
    game
  end
end
