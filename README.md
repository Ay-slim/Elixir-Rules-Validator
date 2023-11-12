# Rules validation in Elixir
This is a quick Elixir rewrite of a simple rules validation API previously [written in Javascript](https://github.com/Ay-slim/ayoflwsolution).
There are two endpoints:
- GET `/api/` Which returns basic biodata
- POST `/api/validate_rule/` which accepts a map with the keys `rule` and `data`, validating the contents of the data object against the conditions specified in the rule

## Examples

GET `/api/`

- Response 200 OK
```
{
  "data": {
      "email": "ayooluwaadedipe@gmail.com",
      "github": "@Ay-slim",
      "name": "Ayooluwa Adedipe"
  },
  "message": "My Rule-Validation API",
  "status": "success"
}
```

POST `/api/validate_rule/`
### Successful response
Validates that the field `missions` in the `data` key fulfills the `condition` key `gte` (greater than or equal to) in the `rules` map.

Note:
  Valid condition values include:
    eq: Equals
    neq: Not equal
    gt: Greater than
    lt: Less than
    gte: Greater than or equal to
    lte: Less than or equal to

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
200 OK
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

### Failed validation
In the event that the target field value does not fulfill the set conditions:

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
    "missions": 20
  }
}
```
- Response
400 Bad Request
```
{
  "data": {
      "validation": {
          "condition": "eq",
          "condition_value": "30",
          "error": true,
          "field": "missions",
          "field_value": "29"
      }
  },
  "message": "field missions failed validation.",
  "status": "error"
}
```
### Missing data value
In the event where the field specified in the rule value is not present in the data value

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
    "position": "Captain"
  }
}
```
- Response
400 Bad Request
```
{
  "data": null,
  "message": "field missions is missing from data.",
  "status": "error"
}
```
### Missing required field
In the event that any of the required fields are not present

JSON
```
{
  "rule": {
    "field": "missions"
    "condition": "gte"
  },
  "data": {
    "name": "James Holden",
    "crew": "Rocinante",
    "age": 34,
    "position": "Captain"
  }
}
```
- Response
400 Bad Request
```
{
  "data": null,
  "message": "rule.condition_value is required.",
  "status": "error"
}
```

JSON
```
{
  "rule": {
    "field": "missions"
    "condition": "gte"
  }
}
```
- Response
400 Bad Request
```
{
  "data": null,
  "message": "data is required.",
  "status": "error"
}
```

# Run locally
To start your Phoenix server:
  * Install [Elixir](https://elixir-lang.org/install.html) and [Phoenix](https://hexdocs.pm/phoenix/installation.html)
  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


