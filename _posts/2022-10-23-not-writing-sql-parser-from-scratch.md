---
layout: post
title: I'm not writing an SQL Parser from scratch
description: "How I decided to not roll my own SQL parser and rely on the work of others"
modified: 2022-10-23
category: articles
tags: []
image:
  feature: texture-feature-04.jpg
  credit: Texture Lovers
  creditlink: http://texturelovers.com
---

While working on [SQL Formatter][] I've been on a lookout for a proper SQL parser.
For now this library doesn't really properly parse the SQL,
which ultimately limits the kind of formatting this tool is able to perform.

I've found two libraries that seem to fit the bill:

- [node-sql-parser][]
- [pgsql-ast-parser][]

I've always been humbled by creators of such libraries.
Even when using a parser generator, writing a grammar is not an easy task.
I've learned this first-hand by trying to incorporate a half-assed parser
inside SQL Formatter to perform at least some syntax structure detection.
Writing a full grammar for a language as complex as SQL has always felt to me
as a truly colossal and daunting task. So my kudos/props/thumbs-ups goes to
anyone who has dared to tackle this problem.

## The problem with AST

Unfortunately neither of these libraries is suitable for use inside a formatter
because they produce an Abstract Syntax Tree (AST).
In AST all of the following information is usually discarded:

- Comments
- Case of keywords (SQL is case-insensitive)
- Whitespace (A formatter mostly doesn't need information about original
  whitespace, but for some things it can be useful. Like one might want to
  preserve the original number of empty lines between statements.)
- Redundant parentheses.
- Quoting of identifiers and strings.

So, instead what I want is a Concrete Syntax Tree (CST) which preserves
all this detailed syntactic information, so my formatter could only
change the whitespace and reproduce everything else exactly as it was before.

I figured that it shouldn't be all that hard to add this extra CST-info
to an existing AST-parser. After all, the hard part of describing all the
SQL syntax has already been done for me. So I forged ahead with forking
node-sql-parser.

## A fork of node-sql-parser

I chose node-sql-parser as it supports multiple SQL dialects, which I
really wanted for my parser to have, unlike the pgsql-ast-parser, which
only supported PostgreSQL.

I quickly realized though that this multi-dialect support in node-sql-parser
is somewhat problematic, as it essentially implements a separate parser
for each of the 9 dialects it supports. Still, I figured, the author who has
implemented it like so must know better than me. To keep things simple though,
I decided to first concentrate on just a single dialect.

Next up I discovered that the parser logic doesn't only construct an AST.
It also constructs a list of visited tables and columns. Logically, if
you have an AST, you could simply derive this visited table/column info
from it. Even more, this visiting-detection-logic would most likely
be generalizable for all supported dialects, but strangely it was instead
implemented inside the parser and duplicated in parsers for all dialects.

However, for my purposes I didn't need any of this logic, so I went ahead
and simply deleted it all - less code FTW - and moved on.

The parser also cames with its own AST-to-code function and most tests
are written using it: testing the output of `toSql(parse('CODE'))`.
Which is great - comparing simple strings is much more readable and shorter
than attempting to compare AST itself.

However I soon grew frustrated with this ast-to-sql conversion code.
I found the code to be pretty hard to navigate and several functions
in it were really over-the-top complex. Thankfully again, this wasn't
the code I actually needed - as my main goal was to write my own formatter.
So again, I just deleted this all.

Also I came to the realization that it's near impossible to just evolve
the AST to the structure I'd like it to have. I couldn't retro-fit
all this extra information to the existing AST. I needed lots of additional
nodes and the existing nodes needed to be pretty much completely redesigned.
So be it... and I deleted all the AST-construction code.

Not much was left now. Only the grammar of SQL. At least I won't need
to worry about getting the grammar correct.

Well... that assumption also turned out to be wrong. Over the time
I have discovered lots and lots of bugs in the grammar, the most fundamental
issues being:

- whitespace between keywords is often optional (e.g. `PRIMARY KEY` and `PRIMARYKEY` are parsed the same).
- incorrect operator precedence (e.g. `AND` does not bind more tightly than `OR`)
- strings are sometimes mistaken for quoted identifiers.

There are also countless cases of missing support for various syntax,
while at the same time supporting syntax that isn't actually part of
a particular dialect.

Turns out that the process of implementing support for new dialects
has been though process of copy-pasting the parser of one dialect
and throwing in some minor modifications on top of it. For example,
as a result of this, the Postgres parser supports backtick-quoted
identifiers and it thinks SCHEMA and DATABASE are equivalent (which
they are in MySQL, but not in Postgres).

As a result of all this, I've lost all trust in the correctness of the
grammar, and I've been gradually throwing away parts of it and completely
rewriting them.

So much about not writing an SQL parser from scratch...

[sql formatter]: https://github.com/sql-formatter-org/sql-formatter
[node-sql-parser]: https://github.com/taozhi8833998/node-sql-parser
[pgsql-ast-parser]: https://github.com/oguimbal/pgsql-ast-parser
