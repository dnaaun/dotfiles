---
description: "jj metaedit - Modify the metadata of a revision without changing its content"
---

# jj metaedit

Modify the metadata of a revision without changing its content.

## Usage

```
jj metaedit [OPTIONS] [REVSETS]...
```

## Arguments

- `[REVSETS]...` - The revision(s) to modify (default: @)

## Options

```
--update-change-id            Generate a new change-id

--update-author-timestamp     Update the author timestamp to now

--update-author               Update the author to the configured user
                              Updates author name and email. The author timestamp
                              is not modified -- use --update-author-timestamp too.

--author <AUTHOR>             Set author to the provided string
                              Changes author name and email while retaining
                              author timestamp for non-discardable commits.

--author-timestamp <TS>       Set the author date (human readable or timestamp)

--update-committer-timestamp  Update the committer timestamp to now

-h, --help                    Print help
```

## Example

Update author for a specific revision:
```bash
JJ_USER='Foo Bar' JJ_EMAIL=foo@bar.com jj metaedit --update-author
```
