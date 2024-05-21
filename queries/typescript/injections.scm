;; extends

((template_string
   (string_fragment) @injection.content
   (#set! injection.language "sql")) @_maybe_sql
 (#match? @_maybe_sql "^`--sql"))

