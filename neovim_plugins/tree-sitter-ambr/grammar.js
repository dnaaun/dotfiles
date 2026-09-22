/**
 * Tree-sitter grammar for `.ambr` files: the "amber" snapshot format written
 * by syrupy (https://github.com/syrupy-project/syrupy).
 *
 * The format is line oriented:
 *
 *   # serializer version: 1
 *   # name: test_something[param]
 *     dict({
 *       'key': list([
 *         1,
 *       ]),
 *     })
 *   # ---
 *
 * Every value is either a container that opens with `TypeName(` (plus an
 * optional `[` or `{`) and closes on its own line, a `'''` multi-line string,
 * or a single-line Python `repr()`. Because a repr can contain anything, the
 * single-line values are lexed by the external scanner in src/scanner.c, which
 * classifies them (string / number / boolean / none / ellipsis / plain) and
 * knows to stop before the trailing `,` of a container entry.
 */

/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

module.exports = grammar({
  name: 'ambr',

  externals: $ => [
    $.string,
    $.number,
    $.boolean,
    $.none,
    $.ellipsis,
    $.plain,
    $.attribute_name,
    $.multiline_string_content,
    $._error_sentinel,
  ],

  extras: _ => [/\s/],

  conflicts: $ => [[$.dict, $.set]],

  rules: {
    source_file: $ => seq(optional($.version_marker), repeat($.snapshot)),

    version_marker: $ => seq('#', 'serializer version:', field('version', $.version)),
    version: _ => /[^\r\n]+/,

    snapshot: $ =>
      seq(
        $.name_marker,
        optional(field('value', $._value)),
        $.divider,
      ),

    name_marker: $ => seq('#', 'name:', field('name', $.snapshot_name)),
    snapshot_name: _ => /[^\r\n]+/,

    divider: _ => seq('#', '---'),

    _value: $ =>
      choice(
        $.dict,
        $.set,
        $.list,
        $.tuple,
        $.object,
        $.multiline_string,
        $.string,
        $.number,
        $.boolean,
        $.none,
        $.ellipsis,
        $.plain,
      ),

    // `dict({ ... })`, `OrderedDict({ ... })`, `mappingproxy({ ... })`, ...
    //
    // A key with a custom repr, e.g. an Enum member `<Color.RED: 1>: 2,`, is
    // lexed as one `plain` line because the `: ` inside the repr is not
    // distinguishable from the key/value separator. Such lines are allowed
    // as bare elements so they do not turn the whole dict into an error.
    dict: $ =>
      seq(field('type', $.type_name), '(', '{', repeat(choice($.pair, $._element)), '}', ')'),

    // `set({ ... })`, `frozenset({ ... })`. Looks like a dict until the first
    // `key: value` pair, so this is a GLR conflict with `dict`; a body made of
    // bare elements only is a set, an empty `({ })` is a dict.
    set: $ =>
      prec.dynamic(1, seq(field('type', $.type_name), '(', '{', repeat1($._element), '}', ')')),

    // `list([ ... ])`
    list: $ => seq(field('type', $.type_name), '(', '[', repeat($._element), ']', ')'),

    // `tuple( ... )`, `generator( ... )`: positional entries.
    tuple: $ => seq(field('type', $.type_name), '(', repeat($._element), ')'),

    // `Point( x=1, y=2, )`: namedtuples and objects without a custom repr.
    // An empty `Foo( )` parses as a tuple.
    object: $ => seq(field('type', $.type_name), '(', repeat1($.attribute), ')'),

    type_name: _ => /[A-Za-z_][A-Za-z0-9_]*/,

    pair: $ => seq(field('key', $._value), ':', field('value', $._value), ','),

    attribute: $ => seq(field('name', $.attribute_name), '=', field('value', $._value), ','),

    _element: $ => seq($._value, ','),

    multiline_string: $ => seq("'''", optional($.multiline_string_content), "'''"),
  },
});
