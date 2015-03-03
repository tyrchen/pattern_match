defmodule PatternMatchBench do
  use Benchfella

  bench "if else performance" do
    Util.test_with(&Ifelse.process/1)
  end

  bench "cond performance" do
    Util.test_with(&Cond.process/1)
  end

  bench "pattern match performance" do
    Util.test_with(&Pattern.process/1)
  end

end

