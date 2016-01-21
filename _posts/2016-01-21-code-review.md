---
layout: post
title: Code review checklist
description: "Writing code that passes any review and doing an amazing review"
modified: 2016-01-21
category: articles
tags: []
image:
    feature: texture-feature-05.jpg
    credit: Texture Lovers
    creditlink: http://texturelovers.com
---

An amazing code review is really a result of a <del>battle</del> cooperation between the author and the reviewer...

## Writing code that passes the review (a.k.a. how to pretend you're a wizard)

First off you make the code work—implement the feature, fix the bug, whatever — but that's really the easy part.
The tricky part is convincing your fellow developer that your solution is the most amazing one in the world.
Here are some tricks to make your code look better than it actually is:

### Do more commits

Piling all your changes into one commit will make the reviewer frown at the idea of reviewing your code before he even actually looks at it.
We don't want to anger the reviewer.
Instead split up your changes into easy-to-chew chunks:

  * Fixing the actual issue
  * Refactoring the code
    (really avoid doing the actual fix and refactoring inside the same commit)
  * Renaming files
    (changing something inside a file and also renaming it is a great way to drive the reviewer mad, avoid at all cost)
  * Changing indentation
    (similarly disturbing is trying to pin-point the change when the indentation of the whole thing has changed at the same time)
  * Typo
    (in case there is no previous commit to amend, but it in a separate commit;
    can batch several typos in same commit, though)

Commit just the files related to one type of change.
When you have already made a bunch of unrelated changes inside one file, `hg record` / `git add --patch` are your friends to split things up.

### Do less commits

While it's nice to break things up, not everything needs multiple commits, avoid:

  * Adding something you forgot
    (typo, comments, additional bug)
  * The shitty solution you initially tried
    (it's useful to keep all the intermediate steps while developing, but you don't want the reviewer to know how many times you screwed up)

Your goal is to make the reviewer believe you got it all right with just one try.
Use `commit --amend` to fix things in the previous commit.
Master `hg histedit` / `git rebase --interactive` to fix earlier commits, combine multiple steps to one, reorder commits etc.

### Use commit messages to your advantage

The reviewer is not smart enough to see the pure genius of your code.
Use commit messages to advertise your changes as the greatest things ever:

  * Start with a short (< 60 chars) summary of what's the whole commit is about.
  * Followed by additional details that explain the cool aspects the reviewer might otherwise miss
    (like what did the ninja think when he wrote it, why did he do it in this specific way –
    actually, consider committing such comments together with source code, it makes more sense next to the actual code).
  * Avoid using the word "and" in commit summary —
    it usually means you should break it up to multiple commits.
  * Use present tense
    (your commits shall bring the code of the future, don't talk about it in past tense;
    when working with commits the present tense makes more sense, and it makes you sound cool).

### Write code that you're proud of

If you yourself are not proud about the code, it shouldn't come as a surprise that the reviewer isn't much impressed either.

  * Is it so dead-simple that even your cat can understand it?
    No? It's not good enough.
  * Is it all so beautifully formatted that it makes you cry?
    No? It's not good enough.
  * Would you wear a T-shirt featuring this code?
    No? It's not good enough.

You should really try to amaze the reviewer with your wizard-skills, but even though a wizard wrote it, it should be so simple that even a child can read it.

## Writing an amazing review (a.k.a. ruining the self-esteem of this poor bastard)

Your goal here is to find as many things as possible to complain about, pat yourself on the back, and press "Back to dev".

### Does it work?

If it doesn't, you can save yourself from reading the crappy code.
Just reject it right away.

### Is the formatting correct?

In front-end, most of such issues should be detected by ESLint and SCSS-Lint, but not everything.
The lines might be exceedingly long, use of whitespace inconsistent.
These are the low-flying birds to catch.
Point them all out.

### Is it documented?

We have some pretty rigorous rules for documenting JavaScript code, which means even more reasons to reject the code:

  * Do all classes and public methods have a doc-comment?
  * Are all the new parameters and config options documented?
  * Is the CSS documented?
    (CSS rules can be really tricky to understand, they deserve more comments than JS code, but they usually get less.)
  * Read through the comments —
    do you spot any typos, misspellings, punctuation errors?
    Ha! That fool can't even use a keyboard.

### Is it simple?

Do you understand the code right away?
No? Then it's not simple enough — try to find a reason to reject it:

  * Too long class/method.
  * Too many parameters/options.
  * It has tricky code
    (instead of documenting a hack, we should strive to write it in a non-hacky way instead. Keep it simple, stupid!)
  * Your cat would not understand it.

If all else fails, point out bad names — there are always poorly named classes/methods/variables.
You don't even have to suggest a better alternative, just say the current naming sucks.

### Is it better than before?

To avoid code rot, the code should be in a better state than it was before the change:

  * When old code is changed, it should be updated to follow the best practices
    (e.g. ES6 classes, arrow functions, BEM notation, $-prefixed jQuery vars).
  * Have zero tolerance for dead or commented out code.
  * Have zero tolerance for repeated code
    (smash the DRY principle down their throats).
  * Have zero tolerance for any new technical debt.

Don't be satisfied to create follow-up tasks for cleaning things up —
this way you might end up doing the cleanup by yourself.
Make them feel the pain and reject it!

### Is it tested?

The tests should follow the same high coding standards as the rest of the code.
Often they don't — that's bread for your table:

  * All new functionality is covered by unit tests
  * Tests don't modify global state
  * Dependencies are properly mocked out
  * Tests only use public methods of the test subject
    (no peeking at internal state)
  * Test code is also well factored
    (keep things DRY, hard-coded values are fine though)

You will most certainly find something to complain about in tests, don't miss this opportunity!
