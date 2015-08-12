# Pipes nake it cleaner.
names = ["Homer", "Marge", "Bart", "Lisa", "Maggie"] \
  |> Enum.filter(fn(name) -> String.first(name) == "M" end) \
  |> Enum.map(fn(name) -> name <> " Simpson" end)

IO.inspect names
