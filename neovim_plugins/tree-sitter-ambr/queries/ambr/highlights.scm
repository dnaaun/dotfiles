; Markers: `# serializer version: 1`, `# name: test_x`, `# ---`
(version_marker) @comment
(divider) @comment
(name_marker
  "#" @comment
  "name:" @comment
  name: (snapshot_name) @function)

; Containers
(type_name) @type

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket

[
  ":"
  ","
  "="
] @punctuation.delimiter

; Entries
(pair
  key: (string) @property)
(attribute
  name: (attribute_name) @property)

; Scalars
(string) @string
(multiline_string) @string
(number) @number
(boolean) @boolean
(none) @constant.builtin
(ellipsis) @punctuation.special
(plain) @constant
