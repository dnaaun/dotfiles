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

; Entries. The priority keeps keys from being repainted as plain strings by
; the Python injection (injections.scm).
((pair
  key: (string) @property)
  (#set! priority 105))
((attribute
  name: (attribute_name) @property)
  (#set! priority 105))

; Scalars
(string) @string
(multiline_string) @string
(number) @number
(boolean) @boolean
(none) @constant.builtin
(ellipsis) @punctuation.special
(plain) @constant
