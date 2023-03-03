---
layout: post
title: Take-home assignments - just say no
description: "Another game where the only winning move is not to play"
modified: 2023-03-03
category: articles
tags: []
---
Every so often, when interviewing for a programming job,
you'll receive a message like this:

> As the next step in the process, we'd like for you to complete
> a short take-home assignment.

Instead of rolling up your sleeves and digging into the task,
stop and ask yourself why the heck you should do it.
There are many reasons to say no:

### The "small" task is never quite as small as stated

It's common that the amount of time needed to complete a task
is severely under-estimated by the company. Usually they say
something like "we expect that a good developer is able to
implement this in 6 hours". This is just wishful thinking from
their side - what you really want to know is how much time does
an average applicant take to complete this task. But that
information is rarely given. And even that information will be
skewed, as it won't contain the applicants who gave up.

For example, a common theme is to build some sort of small
application from scratch, but the assignment doesn't take into
account all the setup you would need to do to start a new
project. Most developers spend their days collaborating on
large software projects not creating tiny ones from scratch.

Like with most softwere development estimates, you're better
off multiplying it with at least two.

### The task description always contains ambiguities

Fuzzy requirements is a normal part of software development,
but in the context of a home-assignment, such deficiencies put
you at a disadvantage.

Under normal circumstances you could discuss these requirements
with your client, manager or team-mates. Although some assignments
state that you're encouraged to ask questions, it's not quite
as simple to do in practice.

You might need to send your questions to the HR person,
who will forward them to a developer, and perhaps then you
get a response already on the next day.

Often you'll end up in a dilemma: should I confirm these things
I'm not 100% certain of and thereby delay with the completion
of the task, or should I just implement it as I think it should
be and risk it being completely wrong. There is no winning move.

### There are hidden requirements

It's common that you're not told by which criteria your work
will be assessed. You might obsess over implementing a
linear-time algorithm, but turns out that they were actually
interested in your choice of using a third-party library for
solving that problem. They might say that for bonus points
you can also implement unit tests, but turns out they will
reject your submission if it has no tests.

Once I was outright rejected because my solution contained
more functionality than they had asked for. I had no idea
that this would ever be a bad thing.

### The task might actually be impossible

Once I was tasked with implementing a small service
which pulled data from one API, transformed it, and sent
to another API.  Turned out that the first API didn't
actually contain all the data that the other API was
expecting.  I tried to explain this mismatch to my contact
in the company, but I was essentially told to just try
harder.

A major reason why they didn't understand my
problems was that they had never actually implemented
this task by themselves... which brings us to the next
topic.

### You are essentially doing unpayed work

In the worst case you are given a task to implement
some functionality that the company actually wants to
use in production. This might be accompanied by description
of how the company wants your take-home assignment to
be as similar to the real work as possible.

In such cases nobody can really tell how easy or hard
the task is because nobody has actually done it before.
Usually it turns out that it's way harder than they
thought.

By doing such a task, you might discover that
your work ends up in production, but your application still
gets rejected.

### It demostrates a disrespect towards your time

Such assignments require disproportionately more time
commitment from the applicant than they require from the company.
While you might spend days to come up with a solution,
the reviewer at the company might just briefly glance
at it and quickly reject it.

This is in great contrast with a live coding task,
where both sides have to spend equal amount of time
behind a table, working through the task.

### Your time is better spent elsewhere

Instead of spending lots of time completing the
assignment, you're better off spending this same time
applying to other companies. After all, completing
the assignment perfectly is no guarantee that you'll
get the job.

Instead of crafting the assignment, you
could instead craft well-written cover letters,
which will give you a much better return
on investment than the completion of the take-home
task.

Or you might consider spending the time to
learn new skills, which takes us to the next point.

### It's a dreadful learning opportunity

One might think that completing an assignment is a great
learning opportunity.  You could make use of some technologies
that you've had little experience before, and you could
get some great feedback about your skills.

Nothing is further from the truth.

If you attempt to complete the assignment using some
unfamiliar tech, you're simply handicapping your ability
of successfully doing the task. It's not really
the time and place to learn new things.

Regarding feedback, there's usually two routes: your
solution gets accepted and everything is fine, or you get
rejected with a vague note like "the quality of the
code was not up to our standards."

There seems to be no middle-ground...

### You're not given a chance to defend your solution

In a normal code review, you can respond to the criticisms
the reviewer has made towards the code. The reviewer
might say: you should have organized your code to multiple
classes. To which you might respond: I considered that option,
but these classes would have ended up being highly coupled.

In contrast to this you're rarely given a chance to refute the
assessment that somebody has given on your take-home assignment.

I once heard of a story where the solution was rejected
because it "didn't work", although the applicant had thoroughly
tested it before submitting. He never found out why his
solution didn't work.

## What to do instead?

So, now that I have demonstrated a bunch of reasons why you
should never agree to a take-home assignment, what should you
do when you're asked to do one.

If you simply say no, your application will just get thrown
to the trash bin. That's not an appealing perspective.

With some companies there really is no other option,
but with many, the rules can be flexed.

### Offer to show off one of your existing projects

If you have some sort of portfolio of the past work you've done,
like some open source projects on which your code could be seen,
ask if they would instead consider looking at these.

Demonstrating your ability to implement non-trivial software
should be a much better demonstration of your skills than the
toy project they're asking you to write.

### Propose a live coding session

While live coding test has its own set of problems,
it's still way better than the take-home assignment.
At least the amount of time you spend will be strictly
limited, and you'll also get a chance to evaluate your
future collegues.

### Propose doing paid work

If the company really wants to see what kind of code you write
in a work environment, they should make that environment as
similar to the real thing and pay you for your time.

This will give you a very concrete number of how highly
your time is valued.  Although usually that number will turn out to be zero.

### Ask about the purpose of the home-assignment

What kind of skills of yours would they like to evaluate?

The reality is that the only thing such a take-home assignment
can assess is whether you're really a terrible programmer.
There should be more than one way to convince them that this
is not the case.

If their goal is to determine whether you're actually good,
let alone great, then such a task is of no help.
They are looking for a unicorn, but they have no idea
what one actually looks like.

### Ask: what would it take to waive the take-home assignment requirement?

At the very minimum you might learn something about the company.

I once proposed the following hypothetical scenario:
What if I was Linus Torvalds.
Would I still be required to do the take-home assignment?

To my astonishment, the answer was yes.

Well... at least I learned that this definitely isn't the company
I would want to work in.
