defmodule Ifelse do
  def process(data) do
    if is_list(data) do
      data
      |> Enum.map(fn(entry) -> 
          if is_tuple(entry) do
            {k,v} = entry
            "#{k}: #{v}" |> transform
          else 
            entry |> process
          end
      end)
      |> Enum.join("\n")
    else 
      if is_map(data) do
        data
        |> Enum.map(fn({k, v}) -> transform("#{k}: #{v}") end)
        |> Enum.join("\n")
      else 
        data |> transform
      end
    end
  end

  defp transform(str) do
    "    #{str}"
  end
end

defmodule Cond do
  def process(data) do
    cond do
      is_list(data) ->
        data
        |> Enum.map(fn(item) ->
          cond do
            is_tuple(item) ->
              {k, v} = item 
              "#{k}: #{v}" |> transform
            true ->
              item |> process
          end 
        end)
        |> Enum.join("\n")
      is_map(data) ->
        data
        |> Enum.map(fn({k, v}) -> "#{k}: #{v}" |> transform end)
        |> Enum.join("\n")
      true ->
        "    #{data}"
    end
  end

  defp transform(str) do
    "    #{str}"
  end

end

defmodule Pattern do
  def process(data) when is_tuple(data) do
    {k, v} = data
    "#{k}: #{v}" |> process
  end

  def process(data) when is_list(data) or is_map(data) do
    data
    |> Enum.map(fn(entry) -> process(entry) end)
    |> Enum.join("\n")
  end

  def process(data) do
    "    #{data}"
  end

end

defmodule Util do
  # this function only used for the testing purpose for github json to txt
  def to_file(name) do
    content = name |> File.read! |> Poison.decode! |> Pattern.process
    File.write!(name <> ".txt", content)
  end

  def test_data do
    [
      {1, "    1"},
      {3.14, "    3.14"},
      {%{}, ""},
      {[], ""},
      {:hello, "    hello"},
      {["hello", "world"], "    hello\n    world"},
      {[{"hello", "world"}, {"a", "b"}], "    hello: world\n    a: b"},
      {%{"hello" => "world", "a" => "b"}, "    a: b\n    hello: world"},
      {"github.json" |> File.read! |> Poison.decode!, "github.json.txt" |> File.read!}
    ] 
  end

  def test_with(fun) do
    test_data |> Enum.map(fn({data, result}) ->
      fun.(data) == result
    end)
  end
end
