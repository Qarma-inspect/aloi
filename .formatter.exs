locals_without_parens = [
  # Params
  defcallback: 1
]

# Used by "mix format"
[
  line_length: 130,
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  locals_without_parens: locals_without_parens,
  export: [locals_without_parens: locals_without_parens]
]
