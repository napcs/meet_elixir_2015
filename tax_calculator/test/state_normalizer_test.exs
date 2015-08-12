defmodule StateNormalizerTest do
  use ExUnit.Case

  test "convert WISCONSIN to :wi" do
    assert StateNormalizer.encode("WISCONSIN") == :wi
  end

  test "convert WI to :wi" do
    assert StateNormalizer.encode("WI") == :wi
  end

  test "convert MINNESOTA to :mn" do
    assert StateNormalizer.encode("MINNESOTA") == :mn
  end

  test "convert MICHIGAN to :other" do
    assert StateNormalizer.encode("MICHIGAN") == :other
  end

  test "convert Wisconsin to :wi" do
    assert StateNormalizer.encode("Wisconsin") == :wi
  end

end
