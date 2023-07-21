---
layout: post
title: Should you prefer Null or Undefined in JavaScript?
description: "Spoiler: avoid null, always use undefined."
modified: 2023-07-21
category: articles
tags: []
---

Internet contains lots of tutorials describing the differences between `null` and `undefined`.
But most of them fail to see that this isn't a feature, but a bug in the language.

<p style="background: #efefef; padding: 0.5em 1em">
**Note:** Throughout this article I'll be using the term "null" in normal font
when referring to any null-like value,
whatever it happens to be called (`null`, `undefined`, `nil`, etc).
When speaking specifically about JavaScript values `null` and `undefined`,
I'll distinguish with a `monospace font`.
</p>

While many languages have copied the [billion-dollar mistake][null-mistake] of Tony Hoare
by introducing a null values in the first place,
JavaScript author Brendan Eich managed to double the mistake by introducing two null values:
`null` and `undefined`.
The original goal of `null` being [better interop with Java][java-interop].

Luckily nowadays we can use TypeScript to track which values can be nullable.
This eliminates the need for null-checks where they're not needed and
lets the type-checker remind us if we have forgotten to add a null-check.
But because `null !== undefined`, you should really just pick one of these
null-values and eliminate the other from your codebase.

But which one to choose?

### Advantages of `undefined`

The main advantage of `undefined` is that it's deeply ingrained to the JavaScript language.
Lots of language constructs will provide you with `undefined` by default:

- Unassigned variables have value `undefined`.
- All functions without explicit return value return `undefined`.
- Optional function arguments default to `undefined`.
- Accessing missing fields in an object or array will result in `undefined`.
- The optional chaining operator `foo?.bar?.baz` will return `undefined` when part of the chain is missing.
- `typeof undefined === "undefined"` while confusingly `typeof null === "object"`
- TypeScript has special syntax for working with `undefined` (e.g. `{age?: number}`),
  but there's not such syntax for `null` (you'd have to use `{age: number | null}`).
- Most standard-library functions return `undefined` to indicate a missing or no value.

### Advantages of `null`

- When serialized as JSON, fields with `null` values will be preserved (e.g. `{"foo": null, "bar": 1}`),
  while `undefined` values will simply be skipped (e.g. `{"bar": 1}`).
- Historically `undefined` was not directly accessible, while `null` was an actual keyword.
- Some libraries require the use of `null`.
  Notably React has used `null` to [render empty components][react-null],
  though nowadays you can instead use empty fragment `<></>`.
- Some standard-library functions return `null`.
  Notable examples: `RegExp.exec()` and `document.getElementById()`.

To me, all these advantages of `null` seem rather questionable when compared
with the pretty clear advantages of `undefined`.

### My personal experience

I have adopted a no-`null` policy in most of my personal open-source projects
and I've also managed to adopt this style in some commercial projects I've been
involved with.

I haven't really run into any problems with this.
There definitely are times where you do need to use `null` here or there.
Usually because some external library requires it or because the backend API
you're communicating with contains `null` values in JSON, but both of these
cases can be easily remedied by implementing helpers to convert these
`null` values to `undefined`, so you'll only need to deal with `null` at the
edges of your system, and the rest of it can be free of `null`.

For example, here's a TypeScript function I've used
to replace occasional `null` values with `undefined`:

```ts
function nullToUndefined<T>(value: T | null): T | undefined {
  return value === null ? undefined : value;
}
```

And here's a version `JSON.parse()` that will abolish `null` values:

```ts
function parseJson<T>(json: string): T {
  return JSON.parse(json, (key, value) => nullToUndefined(value));
}
```

In general, it has been a smooth sailing.

This is in great contrast to one commercial softwere project I was involved with,
which had adopted the rule to prefer `null` over `undefined`.
As a result, there was a mix of `null` and `undefined` used all over the codebase,
with many places using both simultaneously (as demonstrated by TypeScript
declarations in the form of `age?: number | null`).
Honestly, I think the codebase would have looked better
if no policy towards `null` and `undefined` had been adopted.

This experience confirmed my belief that it's really hard to avoid using `undefined`
in JavaScript, as you'll be fighting against what the language naturally prefers.

Don't make the same mistake, and just use `undefined` instead.

[null-mistake]: https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare/
[java-interop]: https://twitter.com/BrendanEich/status/1271993445180010496?s=20
[react-null]: https://legacy.reactjs.org/blog/2014/07/17/react-v0.11.html#rendering-to-null
