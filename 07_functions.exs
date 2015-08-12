# Simple
add = fn
  (first,second) -> first + second
end




# More complex
homer = {:person, "Homer", "Simpson", 42}
marge = {:person, "Marge", "Simpson", 42}
moes = {:place, "Moe's Tavern"}

get_name = fn
  {:place, name} -> name
  {:person, first_name, last_name, age} -> "#{first_name} #{last_name}"
end

get_name.(moes)
