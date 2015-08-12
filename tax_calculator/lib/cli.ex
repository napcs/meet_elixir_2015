defmodule TaxCalculator.CLI do
  def get_amount do
    IO.gets("Enter the amount: ")
    |> String.strip
    |> Float.parse
    |> case do
      {amount, _junk} -> amount
      :error ->
        IO.puts "That's not valid. "
        get_amount
    end
  end

  def get_state do
    IO.gets("Enter the state: ")
    |> String.strip
    |> StateNormalizer.encode
  end

  def main([]), do: main

  def main do
    tax = TaxCalculator.sales_tax(get_amount, get_state)
    IO.puts "The tax is $#{tax}"
  end
end
