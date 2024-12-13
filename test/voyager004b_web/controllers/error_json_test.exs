defmodule Voyager004bWeb.ErrorJSONTest do
  use Voyager004bWeb.ConnCase, async: true

  test "renders 404" do
    assert Voyager004bWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert Voyager004bWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
