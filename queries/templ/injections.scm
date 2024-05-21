;; extends

(element
  (tag_start
    (attribute
      name: (attribute_name) @attr (#match? @attr "^x-")
      value: (quoted_attribute_value
               (attribute_value) @injection.content
               (#set! injection.language "javascript")
            )
      )
   )
)

(element
  (self_closing_tag
    (attribute
      name: (attribute_name) @attr (#match? @attr "^x-")
      value: (quoted_attribute_value
               (attribute_value) @injection.content
               (#set! injection.language "javascript")
            )
      )
   )
)


(composite_literal
  type: (qualified_type
          package: (package_identifier) @pkg (#eq? @pkg "templ")
          name: (type_identifier) @type (#eq? @type "Attributes")
    )
  body: (literal_value
          (keyed_element
            (literal_element
              (interpreted_string_literal) @key (#match? @key "^\"x-"))

            (literal_element
              (interpreted_string_literal) @injection.content
              (#offset! @injection.content 0 1 0 -1)
              (#set! injection.language "javascript")
              )
            )
          )
)

