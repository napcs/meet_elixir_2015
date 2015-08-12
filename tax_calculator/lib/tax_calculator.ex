defmodule TaxCalculator do
  def sales_tax(amount, :wi), do: amount * 0.055
  def sales_tax(amount, :il), do: amount * 0.06
  def sales_tax(amount, _), do: 0
end
