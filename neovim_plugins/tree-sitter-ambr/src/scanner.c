// External scanner for the ambr (syrupy amber snapshot) grammar.
//
// Syrupy writes every non-container value as a single-line Python `repr()`,
// which can contain arbitrary characters (`<Foo object at 0x...>`,
// `datetime.datetime(2024, 1, 1)`, `Point(x=1, y=2)`, ...). Those lines cannot
// be described by tree-sitter's regular-expression tokens because the token
// has to stop *before* the `,` that terminates a container entry and before
// the `: ` that separates a dict key from its value, while still allowing
// those characters inside the repr itself. This scanner lexes such lines and
// classifies them so the grammar gets distinct node types for strings,
// numbers, booleans, `None`, the `…` recursion marker, and everything else
// (`plain`).
//
// It also lexes the body of `'''` multi-line strings, whose lines are written
// verbatim (no escaping), up to the line that consists of just `'''`.

#include "tree_sitter/parser.h"

#include <stdbool.h>
#include <string.h>
#include <wctype.h>

enum TokenType {
  STRING,
  NUMBER,
  BOOLEAN,
  NONE,
  ELLIPSIS,
  PLAIN,
  ATTRIBUTE_NAME,
  MULTILINE_STRING_CONTENT,
  ERROR_SENTINEL,
};

// U+2026 HORIZONTAL ELLIPSIS: syrupy's SYMBOL_ELLIPSIS, written for cycles and
// values nested deeper than the serializer's max depth.
#define HORIZONTAL_ELLIPSIS 0x2026

// Longest single-line value we still classify by content. Anything longer is
// `plain` unless it is made only of number characters.
#define CLASSIFY_BUFFER_SIZE 32

static inline void advance(TSLexer *lexer) { lexer->advance(lexer, false); }
static inline void skip(TSLexer *lexer) { lexer->advance(lexer, true); }

static inline bool at_eol(TSLexer *lexer) {
  return lexer->eof(lexer) || lexer->lookahead == '\n' || lexer->lookahead == '\r';
}

static inline bool is_ident_start(int32_t c) {
  return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_';
}

static inline bool is_ident_char(int32_t c) {
  return is_ident_start(c) || (c >= '0' && c <= '9');
}

static inline bool is_number_char(int32_t c) {
  return (c >= '0' && c <= '9') || c == '.' || c == '-' || c == '+' || c == 'e' || c == 'E' ||
         c == '_';
}

// Accumulates the text of the value being scanned, for classification.
typedef struct {
  char text[CLASSIFY_BUFFER_SIZE + 1];
  size_t length;      // true length, may exceed the buffer
  bool all_number_chars;
} Buffer;

static void buffer_init(Buffer *b) {
  b->text[0] = '\0';
  b->length = 0;
  b->all_number_chars = true;
}

static void buffer_push(Buffer *b, int32_t c) {
  if (b->length < CLASSIFY_BUFFER_SIZE) {
    b->text[b->length] = (c >= 0 && c < 128) ? (char)c : '?';
    b->text[b->length + 1] = '\0';
  }
  b->length++;
  if (!is_number_char(c)) {
    b->all_number_chars = false;
  }
}

static bool buffer_equals(const Buffer *b, const char *s) {
  return b->length <= CLASSIFY_BUFFER_SIZE && strcmp(b->text, s) == 0;
}

// Matches what `repr()` produces for int and float: `-?\d[\d_]*` optionally
// followed by `.\d+` and/or an exponent, plus `inf`, `-inf` and `nan`.
static bool buffer_is_number(const Buffer *b) {
  if (b->length == 0) {
    return false;
  }
  if (buffer_equals(b, "inf") || buffer_equals(b, "-inf") || buffer_equals(b, "nan")) {
    return true;
  }
  if (!b->all_number_chars) {
    return false;
  }
  if (b->length > CLASSIFY_BUFFER_SIZE) {
    // Huge int: every char is a number char; good enough.
    return true;
  }
  const char *s = b->text;
  size_t i = 0;
  if (s[i] == '-') {
    i++;
  }
  size_t digits = 0;
  while (s[i] >= '0' && s[i] <= '9') {
    i++;
    digits++;
  }
  if (digits == 0) {
    return false;
  }
  if (s[i] == '.') {
    i++;
    while (s[i] >= '0' && s[i] <= '9') {
      i++;
    }
  }
  if (s[i] == 'e' || s[i] == 'E') {
    i++;
    if (s[i] == '+' || s[i] == '-') {
      i++;
    }
    size_t exp_digits = 0;
    while (s[i] >= '0' && s[i] <= '9') {
      i++;
      exp_digits++;
    }
    if (exp_digits == 0) {
      return false;
    }
  }
  return s[i] == '\0';
}

// Called right after a candidate value has been fully consumed and its end
// marked. Returns true when the value is terminated here, i.e. the rest of the
// line is nothing (top-level value), a trailing `,` (container entry), or a
// `: ` (dict key). On false the lexer may have advanced past a `,` or `:` that
// then belongs to the value; the caller must mark_end and keep scanning.
static bool at_value_end(TSLexer *lexer) {
  if (at_eol(lexer)) {
    return true;
  }
  if (lexer->lookahead == ',') {
    advance(lexer);
    return at_eol(lexer);
  }
  if (lexer->lookahead == ':') {
    advance(lexer);
    return lexer->lookahead == ' ';
  }
  return false;
}

// Consumes the rest of the line as a `plain` value. The token ends before a
// trailing `,` (the entry separator) but includes every other character.
static bool finish_plain(TSLexer *lexer, bool value_ok) {
  if (!value_ok) {
    return false;
  }
  lexer->mark_end(lexer);
  while (!at_eol(lexer)) {
    int32_t c = lexer->lookahead;
    advance(lexer);
    if (c == ',' && at_eol(lexer)) {
      break;
    }
    lexer->mark_end(lexer);
  }
  lexer->result_symbol = PLAIN;
  return true;
}

// Scans a Python string literal starting at the opening quote (`'` or `"`).
// Returns false if the line ends before the closing quote.
static bool scan_string_literal(TSLexer *lexer) {
  int32_t quote = lexer->lookahead;
  advance(lexer);
  while (!at_eol(lexer)) {
    if (lexer->lookahead == '\\') {
      advance(lexer);
      if (at_eol(lexer)) {
        return false;
      }
      advance(lexer);
      continue;
    }
    if (lexer->lookahead == quote) {
      advance(lexer);
      return true;
    }
    advance(lexer);
  }
  return false;
}

static bool scan_value(TSLexer *lexer, const bool *valid_symbols) {
  // Every value token is valid wherever `plain` is, so this one flag says
  // whether a value may be produced at all (as opposed to only an
  // `attribute_name`, e.g. after the first attribute of an object).
  const bool value_ok = valid_symbols[PLAIN];

  while (!lexer->eof(lexer) && iswspace(lexer->lookahead)) {
    skip(lexer);
  }
  if (lexer->eof(lexer)) {
    return false;
  }

  int32_t c = lexer->lookahead;

  // `# name:`, `# ---`, ... are markers only at column 0; the grammar lexes
  // those itself.
  if (c == '#' && lexer->get_column(lexer) == 0) {
    return false;
  }

  // Container closers sit alone on their line; a repr never starts with one.
  if (c == ')' || c == ']' || c == '}') {
    return false;
  }

  // The `[` / `{` right after a container's `(` belongs to the grammar. A
  // value that starts with a bracket is a repr and continues on the line.
  if (c == '[' || c == '{') {
    advance(lexer);
    if (at_eol(lexer)) {
      return false;
    }
    return finish_plain(lexer, value_ok);
  }

  if (c == '\'' || c == '"') {
    if (!scan_string_literal(lexer)) {
      // Unterminated on this line; not something repr() produces, but keep
      // going rather than erroring out.
      return finish_plain(lexer, value_ok);
    }
    // `''` immediately followed by another `'` is the `'''` that opens a
    // multi-line string; leave it to the grammar.
    if (c == '\'' && lexer->lookahead == '\'') {
      return false;
    }
    lexer->mark_end(lexer);
    if (at_value_end(lexer)) {
      if (!value_ok) {
        return false;
      }
      lexer->result_symbol = STRING;
      return true;
    }
    return finish_plain(lexer, value_ok);
  }

  Buffer buffer;
  buffer_init(&buffer);

  if (is_ident_start(c)) {
    while (is_ident_char(lexer->lookahead)) {
      buffer_push(&buffer, lexer->lookahead);
      advance(lexer);
    }
    lexer->mark_end(lexer);

    if (lexer->lookahead == '(') {
      // `Name(`, `Name([` or `Name({` alone on the line opens a container,
      // which the grammar lexes itself. Anything else, e.g. the dataclass
      // repr `Point(x=1, y=2)`, is a plain value.
      advance(lexer);
      if (lexer->lookahead == '[' || lexer->lookahead == '{') {
        advance(lexer);
      }
      if (at_eol(lexer)) {
        return false;
      }
      return finish_plain(lexer, value_ok);
    }

    if (lexer->lookahead == '=' && valid_symbols[ATTRIBUTE_NAME]) {
      lexer->result_symbol = ATTRIBUTE_NAME;
      return true;
    }

    if (at_value_end(lexer)) {
      if (!value_ok) {
        return false;
      }
      if (buffer_equals(&buffer, "True") || buffer_equals(&buffer, "False")) {
        lexer->result_symbol = BOOLEAN;
      } else if (buffer_equals(&buffer, "None")) {
        lexer->result_symbol = NONE;
      } else if (buffer_is_number(&buffer)) {
        lexer->result_symbol = NUMBER;
      } else {
        lexer->result_symbol = PLAIN;
      }
      return true;
    }
    return finish_plain(lexer, value_ok);
  }

  if ((c >= '0' && c <= '9') || c == '-') {
    while (is_number_char(lexer->lookahead) || is_ident_char(lexer->lookahead)) {
      buffer_push(&buffer, lexer->lookahead);
      advance(lexer);
    }
    lexer->mark_end(lexer);
    if (at_value_end(lexer)) {
      if (!value_ok) {
        return false;
      }
      lexer->result_symbol = buffer_is_number(&buffer) ? NUMBER : PLAIN;
      return true;
    }
    return finish_plain(lexer, value_ok);
  }

  if (c == HORIZONTAL_ELLIPSIS) {
    advance(lexer);
    lexer->mark_end(lexer);
    if (at_value_end(lexer)) {
      if (!value_ok) {
        return false;
      }
      lexer->result_symbol = ELLIPSIS;
      return true;
    }
    return finish_plain(lexer, value_ok);
  }

  return finish_plain(lexer, value_ok);
}

// Scans the lines between the opening `'''` (already consumed) and the line
// that holds the closing `'''`. Lines are taken verbatim. The token includes
// the newline that ends its last line, so the closing `'''` starts on a fresh
// line for the grammar. Returns false when there is no content at all.
static bool scan_multiline_string_content(TSLexer *lexer) {
  if (!at_eol(lexer)) {
    return false;
  }
  if (lexer->lookahead == '\r') {
    advance(lexer);
  }
  if (lexer->lookahead == '\n') {
    advance(lexer);
  }

  bool has_content = false;
  lexer->mark_end(lexer);

  while (!lexer->eof(lexer)) {
    // Is this the closing line: optional indent, `'''`, optional `,`, EOL?
    while (lexer->lookahead == ' ' || lexer->lookahead == '\t') {
      advance(lexer);
    }
    int quotes = 0;
    while (quotes < 3 && lexer->lookahead == '\'') {
      advance(lexer);
      quotes++;
    }
    if (quotes == 3) {
      if (lexer->lookahead == ',') {
        advance(lexer);
      }
      if (at_eol(lexer)) {
        break;
      }
    }

    // A content line: take the rest of it, including its line ending.
    while (!at_eol(lexer)) {
      advance(lexer);
    }
    if (lexer->lookahead == '\r') {
      advance(lexer);
    }
    if (lexer->lookahead == '\n') {
      advance(lexer);
    }
    has_content = true;
    lexer->mark_end(lexer);
  }

  if (!has_content) {
    return false;
  }
  lexer->result_symbol = MULTILINE_STRING_CONTENT;
  return true;
}

void *tree_sitter_ambr_external_scanner_create(void) { return NULL; }

void tree_sitter_ambr_external_scanner_destroy(void *payload) { (void)payload; }

unsigned tree_sitter_ambr_external_scanner_serialize(void *payload, char *buffer) {
  (void)payload;
  (void)buffer;
  return 0;
}

void tree_sitter_ambr_external_scanner_deserialize(void *payload, const char *buffer,
                                                   unsigned length) {
  (void)payload;
  (void)buffer;
  (void)length;
}

bool tree_sitter_ambr_external_scanner_scan(void *payload, TSLexer *lexer,
                                            const bool *valid_symbols) {
  (void)payload;

  // Tree-sitter marks every token valid while recovering from an error; our
  // heuristics would only make a mess of that.
  if (valid_symbols[ERROR_SENTINEL]) {
    return false;
  }

  if (valid_symbols[MULTILINE_STRING_CONTENT]) {
    return scan_multiline_string_content(lexer);
  }

  if (valid_symbols[PLAIN] || valid_symbols[ATTRIBUTE_NAME]) {
    return scan_value(lexer, valid_symbols);
  }

  return false;
}
