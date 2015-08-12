defmodule StateNormalizer do

  defp do_encode("WISCONSIN"), do: :wi
  defp do_encode("WI"), do: :wi
  defp do_encode("MINNESOTA"), do: :mn
  defp do_encode("MN"), do: :mn

  defp do_encode(_), do: :other

  def encode(state) do
    state
    |> String.upcase
    |> do_encode
  end
end
