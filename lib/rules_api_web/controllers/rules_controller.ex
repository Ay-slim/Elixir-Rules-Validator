defmodule RulesApiWeb.RulesController do
  use RulesApiWeb, :controller

  def validate_rule(conn, %{"rule" => rule_params, "data" => data_params}) do
    case validate_request(rule_params, data_params) do
      {:ok} ->
        field = rule_params["field"]
        condition = rule_params["condition"]
        condition_value = rule_params["condition_value"]
        data = Map.get(data_params, field)
        
        result =
          case condition do
            "eq"  -> data == condition_value
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
            "status" => "success",
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
        data_or_rule = ~w("rule data field condition condition_value")a
        IO.puts(error_message)
        if Enum.member?(data_or_rule, error_message) do
          data_rule_res = %{
            "message" => "#{error_message} is required.",
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

  defp validate_request(rule_params, data_params) do
    required_keys = ~w(field condition condition_value)a
    missing_key = Enum.find(required_keys, &(Map.has_key?(rule_params, &1)))
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
  defp validate_request(%{"rule" => rule_param}), do: {:error, "data"}
  defp validate_request(%{"data" => data_param}), do: {:error, "rule"}
end