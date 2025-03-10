;; extends

(
 (raw_string_literal_content) @injection.content
  (#match? @injection.content "^--sql")
  (#set! injection.language "sql")
)
