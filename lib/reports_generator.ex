defmodule ReportsGenerator do
  alias ReportsGenerator.Parser

  @available_foods [
    "açai",
    "churrasco",
    "esfirra",
    "hamburger",
    "pastel",
    "pizza",
    "prato feito",
    "sushi"
  ]

  @options ["foods","users"]

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  def fetch_higer_cost(report, option) when option in @options do
    {:or, Enum.max_by(report, fn {_key, value} -> value end) }
  end

  def fetch_higer_cost(_report, _option), do: {:error, "Invalid option!"}

  defp sum_values([id, food_name, price ], %{"foods" => foods, "users" => users} = report) do
    users = Map.put(users, id, users[id] + price)
    foods = Map.put(foods, food_name, foods[food_name] + +1)

    %{report | "users" => users, "foods" => foods}
  end

  defp report_acc do
    foods = Enum.into(@available_foods, %{}, &{&1, 0})
    users = Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})

    %{"users" => users, "foods" => foods}
  end
end
