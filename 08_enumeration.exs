# Create a list
names = ["Homer", "Marge", "Bart", "Lisa", "Maggie"]

# Filter out "m" names
Enum.filter(names, fn(name) -> String.first(name) == "M" end)

# Add "simpson" to each
Enum.map(names, fn(name) -> "#{name} Simpson" end)

# Put them together
Enum.map(Enum.filter(names, fn(name) -> String.first(name) == "M" end), fn(name) -> name <> " Simpson" end)

