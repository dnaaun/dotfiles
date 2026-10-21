; A snapshot's value is a Python expression (syrupy writes repr()s), so let
; the Python grammar highlight it on top of the captures in highlights.scm.
(snapshot
  value: (_) @injection.content
  (#set! injection.language "python")
  (#set! injection.include-children))
