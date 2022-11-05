---
layout: post
title: One grammar to rule them all
description: "My attempt to parse multiple SQL dialects"
modified: 2022-11-05
category: articles
tags: []
image:
  feature: one-ring.jpg
---

In addition to SQL being a notoriously complex language, it also has notoriously many dialects.
As noted by the famous J.R.R.R.R.R.T. when he attempted to write an SQL parser:

> Three SQL dialects for Free Software under the sky,<br>
> Seven for the propriatary ones paid in gold,<br>
> Nine for NoSQL doomed to die,<br>
> One for the Oracle on his dark throne
>
> In the Land of Parsers where the Grammars lie.<br>
> One Grammar to rule them all, One Grammar to find them,<br>
> One Grammar to match them all and in linear time parse them<br>
> In the Land of Parsers where the Grammars lie.

As I wrote in my [previous blog post][], I forked the [node-sql-parser][] library
to build a better one that I could use in [SQL Formatter][].

One major requirement is support for multiple SQL dialects.
The original library accomplished this through copy-paste code duplication,
which is definitely not the route I wanna be traveling.

## The easy case

For example BigQuery and MySQL support `DROP TABLE` statement.
BigQuery syntax is as follows:

```
DROP [EXTERNAL | SNAPSHOT] TABLE [IF EXISTS]
  table_name
```

While MySQL syntax is:

```
DROP [TEMPORARY] TABLE [IF EXISTS]
  table_name [, table_name] ...
  [RESTRICT | CASCADE]
```

I can easily support both by creating a grammar that's sort-of a union of these two:

```
DROP [TEMPORARY | EXTERNAL | SNAPSHOT] TABLE [IF EXISTS]
  table_name [, table_name] ...
  [RESTRICT | CASCADE]
```

A small downside is that this grammar will also match the following SQL:

```sql
DROP EXTERNAL TABLE my_table1, my_table2 CASCADE;
```

This is invalid SQL for both BigQuery and MySQL, but our parser accepts it just fine!

But my purpose here is not to write a validator.
For me it's more important that the parser accepts all possible valid SQL,
it's not a problem if it also accepts SQL that's not supported by any actual database.

## The hard case

A more problematic situation arises when different SQL dialects assign different meaning to the same syntax.

The best example here is the quoting of strings and identifiers:

```sql
SELECT "name" FROM persons;
```

- In PostgreSQL `"name"` refers to the `name` column in `persons` table.
- In MySQL `"name"` is just a literal string containing text “name”.

Accordingly the parser should parse this code differently depending on which SQL dialect it's parsing.
In general there's two solutions for this:

- a single parser that behaves differently depending on current SQL dialect,
- a separate parser for each SQL dialect.

## Approach #1: Using assertions inside single parser

As I'm using [Peggy][] as my parser generator,
it's possible to pass arguments to the parser and check them during parsing.
I can writing something like this (in Peggy grammar):

```pegjs
select_option
  = ALL
  / DISTINCT
  / DISTINCTROW &{ return options.dialect === "mysql"; }
  / UNIQUE &{ return options.dialect === "oracle"; }
```

The `&{ ... }` block is an assertion which doesn't consume any input,
but it will match when `true` is returned -
accordingly making the whole match either succeed or fail.

I can then call the generated parser like so:

```js
parser("SELECT DISTINCTROW foo FROM tbl;", { dialect: "mysql" });
```

The above is somewhat ugly and repetitive though.
I can improve things my extracting the `&{ ... }` block to a separate rule
and assert the matching of that rule:

```pegjs
select_option
  = ALL
  / DISTINCT
  / DISTINCTROW &mysql
  / UNIQUE &oracle

mysql = &{ return options.dialect === "mysql"; }
oracle = &{ return options.dialect === "oracle"; }
```

This looks much better, unfortunately it doesn't work quite as intended.
The problem is that these `&mysql` and `&oracle` rules introduce an empty `undefined` entry to our parse result.
I'll have to explicitly extract just the part that's needed:

```pegjs
select_option
  = ALL
  / DISTINCT
  / kw:DISTINCTROW &mysql { return kw; }
  / kw:UNIQUE &oracle { return kw; }
```

The nice thing here is that I have a single parser
which behaves slightly differently depending on the dialect option passed in.

The downside is the dealing with these `undefined` entries in parse result.

## Approach #2: Generating multiple parsers from one grammar

This approach is not directly supported by Peggy,
but one can write a [plugin][] to make it possible.

I've written [a plugin][generate-plugin] to extend Peggy grammar with the following syntax:

```pegjs
select_option
  = ALL / DISTINCT

select_option$mysql
  = ALL / DISTINCT / DISTINCTROW

select_option$oracle
  = ALL / DISTINCT / UNIQUE
```

In this extended grammar a rule with `$dialect` suffix will replace a rule with the same name
when generating a parser for that particular dialect.
For example, when running parser-generator for MySQL,
the grammar will get pre-processed to be as follows:

```pegjs
select_option
  = ALL / DISTINCT / DISTINCTROW
```

For oracle, the result will be:

```pegjs
string_literal
  = ALL / DISTINCT / UNIQUE
```

And for any other dialect besides these:

```pegjs
string_literal
  = ALL / DISTINCT
```

This approach gets rid of the `undefined` problem, but brings along others:

- As can be seen above, the `ALL / DISTINCT` part is repeated in all rules.
  We would need to extract another rule for just that part to eliminate the duplication.
  It's easily doable, but it's a nuisance.
- There's now a separate parser generated for each dialect,
  which means all the shared code (which is the majority) will get duplicated.
  While each single parser will be smaller the cumulative size of all parsers will be significantly larger.

## Summary

For the time being I've been using the second multi-parser approach.
I initially though that the assertions-approach would incur a significant performance cost,
but after having done some testing,
I can say that there seems to be no measurable performance difference.

So currently the assertions-approach looks like a better option to me,
except that I quite dislike this `undefined` values problem.
Perhaps the best way would be to combine best of both worlds:
using assertions, but eliminating the `undefined` problem with some
post-processing of the grammar with a custom plugin.

Will have to backtrack on my current attack plan on the dark lord and devise another cunning plan.
After all, one does not simply walk into Mordor.

[previous blog post]: http://nene.github.io/2022/10/23/not-writing-sql-parser-from-scratch
[node-sql-parser]: https://github.com/taozhi8833998/node-sql-parser
[sql formatter]: https://github.com/sql-formatter-org/sql-formatter
[peggy]: https://peggyjs.org/
[plugin]: https://peggyjs.org/documentation.html#plugins-api
[generate-plugin]: https://github.com/nene/sql-parser-cst/blob/4a32afa955d47a37852e7ebbce95490aff096094/generate.ts
