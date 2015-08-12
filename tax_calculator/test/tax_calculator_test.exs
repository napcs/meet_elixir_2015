defmodule TaxCalculatorTest do
  use ExUnit.Case

  test "calculates tax for 25 dollars for wisconsin" do
    assert TaxCalculator.sales_tax(25, "WI") == 1.375
  end

  test "calculates tax for 25 dollars for michigan" do
    assert TaxCalculator.sales_tax(25, "MI") == 0
  end

end
