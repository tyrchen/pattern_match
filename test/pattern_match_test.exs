defmodule PatternMatchTest do
  use ExUnit.Case

  @trues Util.test_data |> Enum.map(fn(_) -> true end)
  test "if else performance" do
    assert Util.test_with(&Ifelse.process/1) == @trues
  end

  test "cond performance" do
    assert Util.test_with(&Cond.process/1) == @trues
  end

  test "pattern match performance" do
    assert Util.test_with(&Pattern.process/1) == @trues
  end

end

