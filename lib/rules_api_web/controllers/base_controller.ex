defmodule RulesApiWeb.BaseController do
  use RulesApiWeb, :controller

  def index(conn, _params) do
    response_data = %{
      "message" => "My Rule-Validation API",
      "status" => "success",
      "data" => %{
        "name" => "Ayooluwa Adedipe",
        "github" => "@Ay-slim",
        "email" => "ayooluwaadedipe@gmail.com"
      }
    }
    conn
      |> put_status(200)
      |> json(response_data)
  end
end