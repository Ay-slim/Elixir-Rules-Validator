defmodule RulesApiWeb.RulesController do
  use RulesApiWeb, :controller

  defp validate_request(rule_params, data_params) do
    required_keys = ["field", "condition", "condition_value"]
    missing_key = Enum.find(Constants.required_rule_keys, &(!Map.has_key?(rule_params, &1)))
    case missing_key do
      nil ->
        case Map.has_key?(data_params, Map.get(rule_params, "field")) do
          true ->
            {:ok}

          _ ->
            {:error, Map.get(rule_params, "field")}
        end
      _ ->
        {:error, missing_key}
    end
  end

  def validate_rule(conn, %{"rule" => rule_params, "data" => data_params}) do
    case validate_request(rule_params, data_params) do
      {:ok} ->
        field = rule_params["field"]
        condition = rule_params["condition"]
        condition_value = rule_params["condition_value"]
        data = Map.get(data_params, field)
        
        result =
          case condition do
            "eq"  -> data === condition_value
            "neq" -> data != condition_value
            "gt"  -> data > condition_value
            "lt"  -> data < condition_value
            "gte" -> data >= condition_value
            "lte" -> data <= condition_value
            _     -> false
          end
        
        if result do
          succ_res_map = %{
            "message" => "field #{field} successfully validated.",
            "status" => "success",
            "data" => %{
                "validation" => %{
                  "error" => false,
                  "field" => "#{field}",
                  "field_value" => "#{data}",
                  "condition" => "#{condition}",
                  "condition_value" => "#{condition_value}"
                }
              }
            }
          conn
            |> put_status(200)
            |> json(succ_res_map)
        else
          failed_res_map = %{
            "message" => "field #{field} failed validation.",
            "status" => "error",
            "data" => %{
                "validation" => %{
                  "error" => true,
                  "field" => "#{field}",
                  "field_value" => "#{data}",
                  "condition" => "#{condition}",
                  "condition_value" => "#{condition_value}"
                }
              }
            }
          conn
            |> put_status(400)
            |> json(failed_res_map)
        end
    
      {:error, error_message} ->
        if Enum.member?(Constants.required_rule_keys, error_message) do
          data_rule_res = %{
            "message" => "rule.#{error_message} is required.",
            "status" => "error",
            "data" => nil
          }
          conn
            |> put_status(400)
            |> json(data_rule_res)
        else
          missing_field_res = %{
            "message" => "field #{error_message} is missing from data.",
            "status" => "error",
            "data" => nil
          }
          conn
            |> put_status(400)
            |> json(missing_field_res)
        end
    end
  end

  def validate_rule(conn, %{"rule" => rule_params}) do
    no_data_res = %{
      "message" => "data is required.",
      "status" => "error",
      "data" => nil
    }
    conn
      |> put_status(400)
      |> json(no_data_res)
  end

  def validate_rule(conn, %{"data" => data_params}) do
    no_rule_res = %{
      "message" => "rule is required.",
      "status" => "error",
      "data" => nil
    }
    conn
      |> put_status(400)
      |> json(no_rule_res)
  end
end