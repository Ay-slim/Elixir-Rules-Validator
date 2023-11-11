# Rules validation in Elixir
This is a quick Elixir rewrite of a simple rules validation API previously [written in Javascript](https://github.com/Ay-slim/ayoflwsolution).
There are two endpoints:
- GET </api/> Which returns basic biodata
- POST </api/validate_rule> which accepts a map with keys rules and data, validating the contents of the data object against the conditions specified in the rule

Example
- Request
JSON
```
{
  "rule": {
    "field": "missions"
    "condition": "gte",
    "condition_value": 30
  },
  "data": {
    "name": "James Holden",
    "crew": "Rocinante",
    "age": 34,
    "position": "Captain",
    "missions": 45
  }
}
```
- Response
```
{
  "data": {
      "validation": {
          "condition": "gte",
          "condition_value": "30",
          "error": false,
          "field": "missions",
          "field_value": "30"
      }
  },
  "message": "field missions successfully validated.",
  "status": "success"
}
```
The above is a validation that the field `missions` in the `data` key fulfills the `condition` key `gte` (greater than or equal to) in the `rules` map.

# Run locally
To start your Phoenix server:
  * Install [Elixir](https://elixir-lang.org/install.html) and [Phoenix](https://hexdocs.pm/phoenix/installation.html)
  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


