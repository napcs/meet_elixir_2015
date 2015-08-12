# Campers, meet Elixir!

Elixir is a functional language built on the Erlang Beam virtual machine. It's a dynamic language that's great for building distributed, fault tolerant systems.

Our plan for today is to look at some Elixir basics and then dive into building a couple of programs with Elixir.

Elixir comes with a program called `iex` which is the interactive Elixir environment. We'll use that for much of this talk, to run some code and explore the language's features. Let's start by looking at numbers:

## Numbers

Here's an int

```elixir
42
```

We can add those.

```elixir
40 + 2
```

We can add floats too.

```elixir
40.0 + 2
```

And we can multiply and subtract too.

Can we divide?

```elixir
20 / 5
```

Well that gives us a `4.0`.  So division gives us floats.

We can do integer division though. We use the `div` and `rem` functions to get the whole number quotient and the remainder.

```elixir
div(21, 5)
rem(21, 5)
```


## Strings

Strings are double quoted.

```
"Homer"
```

Can we concatenate?

```
"Homer" + "Simpson"
```

Nope, doesn't work. We use the `<>` to concat.

```elixir
"Homer" <> " " <> "Simpson"
```

There are lots of built-in functions for working with strings that we'll look at soon.

## Matching

When you see this in any programming language:


```
x = 5
```

What does that do?

So what will happen if I do this?

```
5 = x
```

It should error, right? But it doesn't. Hmmm. What about this?

```
6 = x
```

Well, the `=` sign isn't equality. It's matching. It attempts to make the left-hand side and the right hand side the same. It just
so happens that if the left hand side doesn't match the right hand side,  it can be assigned a new value.

```
x = 6
6 = x
```

See, that works. We reassigned x the value of 6. Now, I can prevent that re-assignment by using the carat:

```
^x = 7
```

So how might this work in practice? Well, remember that `<>` is the concatenation operator. So let's say I had a URL that had a product key embedded in it:

```
"/products/" <> id = "/products/12345-luggage-combination"
```

I can extract the ID that way. Kinda neat, eh?

## Lists

Variables are great. But we often have lists of data.
A list is a linked list of values. It's an array.

```elixir
[1,2,3,4]
```

Using a matching expression, we can assign a list to a variable

```elixir
list = [1,2,3,4]
```

But using matching, we can also split a list into variables

```elixir
[first,second,third,fourth] = list
```

Sometimes we just want the first thing from the list, so we can get the "head" of the list, and
then the "tail" of the list, which is the rest of the values in the list:


```elixir
[first|rest] = list
```

And because of the matching operator, we can define what that should be:

```elixir
[first, second | rest] = list
```

So how is this useful? Well, let's say you have a string like this:

```
Homer Simpson 42
```

You could parse it easily like this:

```elixir
[first, last, age] = String.split("Homer Simpson 42")
```

Or you could completely ignore extra data:

```elixir
[first, last | _rest] = String.split("Homer Simpson 42")
```

Handling input becomes quite a bit easier.

We can add things to a list too. It's quicker to add to the front of a list though.


## Tuples

Lists are linked lists, meaning that each entry in the list points to the next one. Finding
the lenght of a list requires traversal of the whole list.

Tuples let us store data contiguosly in memory, meaning finding the bits of
data is really fast. However, modifying the data in a tuple
is expensive.

We often use tuples to return data from functions or to represent things.

```elixir
{:person, "Homer", "Simpson", 42}
```

The `:person` is an atom, a constant where its name is the value. It's used as a label in Elixir.

```elixir
homer = {:person, "Homer", "Simpson", 42}
marge = {:person, "Marge", "Simpson", 42}
moes = {:place, "Moe's Tavern"}
```

Destructure this by matching.

```
{:person, firstname, lastname, age} = homer
```

Ignore things


```
{type, _, lastname, _} = {:person, "Homer", "Simpson", 42}
```

## Conversions

This is a good time to look at converting values.

```elixir
Float.parse("20")
Float.parse("20abc")
Float.parse("abc")
```

Tuples are the return values of
lots of functions in Elixir. And using pattern matching, we can extract what we need.

```elixir
{number, _junk} = Float.parse("20abc")
```


## Anonymous functions

Elixir is a functional language, and so we can declare functions quickly and
bind them to types.

```elixir
add = fn
  (first, second) -> first + second
end
```

### Multiple bodies

We can define one function that has multiple bodies depending on what gets
passed in.

We have a `:place` and a `:person`. Let's make a function that gets a name based on what atom we have.

```elixir
get_name = fn
  {:place, name} -> name
  {:person, first_name, last_name, age} -> "#{first_name} #{last_name}"
end

get_name.(moes)
```


## Enumeration

A lot of what we do is work with lists of data, and Elixir, like most modern languages,
has robust ways for dealing with that. There are many functions built in to the
language that let us work with data.

So, say I have this list of names:

```elixir
names = ["Homer", "Marge", "Bart", "Lisa", "Maggie"]
```

I want to filter out names that start with M, and then I want to append the last name of "Simpson" to whomever is left.

`Enum.filter` will let me filter entries out of a list. `Enum.filter` takes the list and an anonymous function which is executed against each item in the list. If
the anonymous function returns true, the entry is kept. If it returns false, the entry is filtered out.

```elixir
Enum.filter(names, fn(name) -> String.first(name) == "M" end)
```

The `Enum.map` function takes a list and transforms it by taking the return value of the anonymous function and placing it in a new list.

~~~elixir
Enum.map(names, fn(name) -> name <> " Simpson" end)
~~~

Now, I need to run both of these on some data. And while I could use an intermediate variable, that's
really not encouraged; we want to get into the habit of immutable data.

~~~elixir
Enum.map(Enum.filter(names, fn(name) -> String.first(name) == "M" end), fn(name) -> name <> " Simpson" end)
~~~

That works. But it's totally unreadable.

## Piping

Elixir provides the pipe, which is a fantasic way of pushing data around. Using pipes, we can make data flow through our program.

We can push the output of one function into the input of the next function. That means we can do the steps in order, just as if we would
explain them:

~~~elixir
names = ["Homer", "Marge", "Bart", "Lisa", "Maggie"] \
  |> Enum.filter(fn(name) -> String.first(name) == "M" end) \
  |> Enum.map(fn(name) -> name <> " Simpson" end)
~~~

`Enum` is a Module, which is a collection of functions. Anonymous functions only get us so far. If we're going to build real programs
we'll need to create functions stored in modules

## Modules and Functions

A module is a collection of functions. This isn't OOP, so you can't think in
terms of classes. Still, you can organize things based on what they do. Let's
make a state tax calculator.


~~~elixir
defmodule TaxCalculator do

end
~~~

Next, we declare our function that handles Wisconsin sales tax.

```
def sales_tax(price, "WI") do
  price * 0.055
end
```

And when we call it

```
IO.puts TaxCalculator.sales_tax(25, "WI")
```

We get our results. But what if we wanted to handle Minnesota? We just declare
another function body.

```
def sales_tax(price, "MN") do
  price * 0.065
end
```

And of course we'll want to handle every other case too.

```
def sales_tax(price, _) do
  0
end
```

These very short functions can be done on one line instead:

~~~
def sales_tax(price, "WI"), do: price * 0.055
def sales_tax(price, "MN"), do: price * 0.065
def sales_tax(price, _), do: 0
~~~

This makes a program like this much, much easier to read.

## Making a program

Let's move from scripts to making a real program. We use

```
mix new tax_calculator
```

to create a new project. This also creates a nice `tax_calculator` Elixir file for us. But it also creates a folder for us to write some tests.

In `tax_calculator_test.ex`, let's define a unit test that handles tax calculations for Wisconsin:

```elixir
  test "calculates tax for 25 dollars for wisconsin" do
    assert TaxCalculator.sales_tax(25, "WI") == 1.375
  end
```

If we run

```
mix test
```

our test fails.

We already have code to make that pass. So let's put it in the app:

```elixir
def sales_tax(price, "WI"), do: price * 0.055
```

With that in place, the test passes. Let's make another quick test for a state we
don't care about:

```elixir
  test "calculates tax for 25 dollars in Michican" do
    assert TaxCalculator.sales_tax(25, "MI") == 0
  end
```

To make this test pass, we just need to add our "catch-all" function:

```elixir
def sales_tax(price, _other), do: 0
```

Whoo Hoo! Two passing tests. Our program logic works. Now let's build out a UI
that asks us for the amount and the state.

## Getting Input

Elixir has the `IO.puts` function for printing things to the screen, and the `IO.gets` function
for getting data from standard input. We'll make a new file called `lib/tax_calculator/cli.ex`
that will be our command line interface.


~~~elixir

defmodule TaxCalculator.CLI do
  def get_amount do
    IO.gets("What is the amount?")
    |> String.strip
  end

  def get_state do
    IO.gets("What is the state?")
    |> String.strip
  end
end
~~~

And then we'll add a function that executes those prompts
and sends them on to our calculator.

~~~
  def main do
    amount = get_amount
    state = get_state
    tax = TaxCalculator.sales_tax(amount, state)
    IO.puts "The tax is $#{tax}"
  end
~~~

Let's get rid of those intermediate variables. We don't need them.

~~~
  def main do
    tax = TaxCalculator.sales_tax(get_amount, get_state)
    IO.puts "The tax is $#{tax}"
  end
~~~

Now let's run our program - we'll use

```
mix run -e TaxCalculator.CLI.main
```

This loads up our app, compiles anything we need, and then executes our code. Our app runs!



## Repetition

If someone enters a non-numeric value into the program, it's going to fail. We want
to validate the input and ask them to enter a valid value again. Elixir doesn't have
traditional loops. So to solve this problem, we'll use recursion.

We'll add a step to our `get_amount` function

~~~elixir
  def get_amount do
    IO.gets("What is the amount?")
    |> String.strip
    |> Floa.parse
    |> case do
      {amount, _junk} -> amount
      :error ->
        IO.puts "that's not valid!"
        get_amount
    end
  end
~~~

If the conversion results in an `:error` atom, we will have it execute the `get_amount` function again.

## A little metaprogramming

Let's validate the states. What if someone types in "wisconsin" as the state? We want to support both the state name
and the state abbreviation.

We'll make a new module for this called `StateNormalizer` and write some unit tests. Let's create
the Elixir file from scratch, but we'll create the unit test by copying the existing one we have and
then renaming things.

~~~
touch lib/state_normalizer.ex
cp test/tax_calculator_test.ex test/state_normalizer_test.ex
~~~

For our test, we'll ensure that a state that comes in as "WISCONSIN" gets converted appropriately:

```elixir
  test "converts 'WISCONSIN' to :wi" do
    assert StateNormalizer.encode("WISCONSIN") == :wi
  end
```

Then we implement our module:


```elixir
defmodule StateNormalizer do
  def encode("WISCONSIN"), do: :wi
end
```

And the test passes. But what if we wanted to handle the abbreviation?

```elixir
  test "converts 'WISCONSIN' to :wi" do
    assert StateNormalizer.encode("WISCONSIN") == :wi
  end
```

Well, we just need another matching function signature:

```elixir
  def encode("WI"), do: :wi
```

What about other states?

```elixir
  test "converts 'MINNESOTA' to :mn" do
    assert StateNormalizer.encode("MINNESOTA") == :mn
  end

  test "converts 'MN' to :mn" do
    assert StateNormalizer.encode("MN") == :mn
  end
```

```elixir
  def encode("MN"), do: :mn
  def encode("MINNESOTA"), do: :mn
```

But what about other states?

```
  test "converts 'MI' to :other" do
    assert StateNormalizer.encode("MI") == :other
  end
```

Well, we need a catch-all.


```elixir
  def encode(_other), do: :other
```

So what if we wanted to accept mixed-case like "Wisconsin"?

```elixir
  test "converts 'Wisconsin' to :other" do
    assert StateNormalizer.encode("Wisconsin") == :wi
  end
```

Welp, that one fails. Why does it fail? Because our "catch all" is catching it, of course.

We could make another permutation of this but what we should do is uppercase whatever comes in and match it.

So what we'll do is rename our existing functions from `encode` to `do_encode` and make them private:

```elixir
  defp do_encode("WISCONSIN"), do: :wi
  defp do_encode("WI"), do: :wi
  defp do_encode("MINNESOTA"), do: :mn
  defp do_encode("MN"), do: :mn
  defp do_encode(_other), do: :other
```

Then we'll make a new `encode` function that uppercases whatever comes in and delegates to our `do_encode` functions:

```elixir
  def encode(state) do
    state
    |> String.upcase
    |> do_encode
  end
```

Now the tests pass.

So now we just need to alter our calculator so it uses the atoms instead of the strings:

```elixir
  def sales_tax(price, :wi), do: price * 0.055
  def sales_tax(price, :mn), do: price * 0.065
  def sales_tax(price, _), do: 0
```

Don't forget to run the tests for this. They'll need changing too!

And then we can plug in our normalizer into the function that gets the state:

```elixir
  def get_state do
    IO.gets("What is the state?")
    |> String.strip
    |> StateNormalizer.encode
  end
```

Pretty cool. But what if we had lots of states to do this for? It could get really obnoxious to write out all of these matching functions. W could do it, but
we don't have to. Elixir lets us write code that writes code. We can define a map that maps the states to the atoms:

```elixir
  states = %{
    ~w(WISCONSIN WI) => :wi,
    ~w(ILLINOIS IL) => :il,
    ~w(MINNESOTA MN) => :mn
  }

```

Then we can use the `for` continuation to pull the `states` map apart and flatten it. And
then for each one of those we define the `do_encode` function using the values in the map.

```elixir
  for {keys, value} <- states, key <- keys do
    defp do_encode(unquote(key)), do: unquote(value)
  end
```

This generates all of the matching functions we need.

## Escript

One last bit. Let's use Erlang's `escript` library to create an executable that can run anywhere
Erlang is installed.

Let's add this to our `mix.exs` project section, right before deps:

~~~elixir
   escript: [ main_module: TaxCalculator.CLI ],
~~~


Now we can run our app with

```
$ mix escript.build
$ ./tip_calculator 5
```

When we run it we get a message saying that our main function is undefined. We defined
a `main` function, but the one we made doesn't take any arguments. Escript needs to pass
command line arguments in. So we need to support an optional array. The easiest way to do this? Just define
a new `main` function that takes in an array of arguments, discard them, and call the existing function.

```elixir
def main(_args), do: main
```



And that's it - when we rebuild, it works.

```
mix excript.build
./tax_calculator
```

### Where to go next

From here, go learn more about Elixir. Visit the Elixir IRC chatroom or join the Elixir mailing list. Read one of the Elixir books out there, and go out and ask questions.
