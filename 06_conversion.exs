Float.parse("20")
Float.parse("20abc")
Float.parse("abc")

# Tuples are the return values of lots of functions in Elixir. And using pattern matching, we can extract what we need.

{number, _junk} = Float.parse("20abc")
number
