defmodule TaxCalculator do
  #def sales_tax(price, "WI") do
    #price * 0.055
  #end

  #def sales_tax(price, "MN") do
    #price * 0.065
  #end

  #def sales_tax(price, _) do
    #0
  #end

  def sales_tax(price, "WI"), do: price * 0.055
  def sales_tax(price, "MN"), do: price * 0.065
  def sales_tax(price, _), do: 0

end


