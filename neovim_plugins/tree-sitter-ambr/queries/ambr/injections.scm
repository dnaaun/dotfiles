; A snapshot's value is a Python expression (syrupy writes repr()s), so let
; the Python grammar highlight containers on top of highlights.scm. A
; top-level `'''` string is left out: Python would call it a docstring.
(snapshot
  value: (_) @injection.content
  (#not-kind-eq? @injection.content "multiline_string")
  (#set! injection.language "python")
  (#set! injection.include-children))

; Top-level `'''` strings are often YAML dumps. Prose also parses as YAML, so
; this goes by the shape of the first line instead: a `- key:` list item, a
; `key: scalar`, a bare `key:` with an indented or `- ` line under it, or a
; `|-` block scalar. Strings nested in a container are not matched, since
; there the Python layer overlaps and sibling layers draw in no fixed order.
(snapshot
  value: (multiline_string
    (multiline_string_content) @injection.content)
  (#lua-match? @injection.content "^\n *%- [%w_.%-]+:")
  (#set! injection.language "yaml"))

(snapshot
  value: (multiline_string
    (multiline_string_content) @injection.content)
  (#lua-match? @injection.content "^\n *[%w_.%-]+: [^ \n]+\n")
  (#set! injection.language "yaml"))

(snapshot
  value: (multiline_string
    (multiline_string_content) @injection.content)
  (#lua-match? @injection.content "^\n( *)[%w_.%-]+:\n%1[ %-]")
  (#set! injection.language "yaml"))

(snapshot
  value: (multiline_string
    (multiline_string_content) @injection.content)
  (#lua-match? @injection.content "^\n *|[-+]?%d*\n")
  (#set! injection.language "yaml"))
