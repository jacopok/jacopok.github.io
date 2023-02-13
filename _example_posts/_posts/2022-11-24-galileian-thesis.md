---
layout: post
title: Galileian thesis
date: 2022-11-14 17:39:00
description: A thesis about clean coding.
tags: coding
# redirect: /assets/pdf/galileian_thesis.pdf
---

# Introduction

It is an opinion held by many that "scientists write bad code"; as evidence for this claim
I will provide the large number of positive votes on [this academia StackExchange post 
titled "Why do many talented scientists write horrible software?"](https://web.archive.org/web/20220810064956/http://academia.stackexchange.com:80/questions/17781/why-do-many-talented-scientists-write-horrible-software).

This is, however, a thorny statement which should be qualified: code may be "bad" 
according to the standards of software companies, but it may serve the purpose it is written
to accomplish perfectly well, especially if this purpose is to act as a proof 
of concept, or as an exploratory step.
However, the _industry best practices_ that are missing from scientific code
do have a reason to exist, and that reason often becomes apparent when projects
become large enough, and/or used by enough people.
Ignoring some of them is acceptable, and perhaps even advisable, for small projects, 
but for larger ones they start to matter more and more, and code not using 
them starts to accumulate _technical debt_, becoming difficult to read, maintain,
modify, extend.

Resources on these best practices are plentiful, but are often focused on 
giving "industry" examples, which may not be too relevant to the scientific setting.
When making an attempt to implement them in my own
code, it was always a mental strain to "map" them to the kinds of issues I was 
interested in.

This work is an attempt to ease this process for others, providing some examples
of the practical application of these concepts in a practical, scientific context.
Using `GWFish` [@harmsGWFishSimulationSoftware2022] to this end 
is something of a perfect storm.
It is a young piece of software (its development started in earnest in early 2021,
although the ideas it implements are quite a bit older)
which serves a conceptually simple purpose, and which 
has recently started to be useful to a large amount of people.

Because of this, it is worth spending time on refactoring it, 
and adopting some development best practices.
As of the writing of this thesis this process is still underway, therefore unfortunately
I will not be able to discuss as many completed modifications as I would like.

Also, `GWFish` is written in `python`, which is also the programming language I know best.
All discussions in this work will be limited to this language, and although some may
apply for others as well I cannot guarantee this.
The discussions will feature several suggestions of `python`-specific 
tools, and will assume a degree of familiarity with the language 
and its more common scientific packages.

All the code snippets discussed in this thesis, 
as well as the source code for this document, are provided in full in 
the repository [github.com/jacopok/clean-coding-thesis](https://github.com/jacopok/clean-coding-thesis).

# Conclusions

This thesis discussed how some best practices can be applied in order
to make software more maintainable, user-friendly, readable.

Several aspects have not been discussed here, one of the most important of which
is large-scale module organization and object-oriented programming:
the structure of classes, the possibility to use inheritance, interfaces, and so on.
The main reason why this topic was omitted, besides its inherent complexity,
is that concretely applying it to `GWFish` will take a large effort, and it has
not been done yet.
Several improvements are underway for `GWFish`, both in terms of new functionality 
(such as allowing the treatment of different kinds of signals which are difficult to model
with the current infrastructure) and of the application of the concepts discussed 
in this thesis.

The main takeaway I hope a reader will have from this thesis is in 
terms of a sort of "Maslow hierarchy"[^maslow] of software needs.
The main topics discussed are in rough order of _urgency_:
if a piece of software is not being properly _versioned_ that is the first problem
to be solved, since we could not reliably keep track of any changes applied otherwise.
The relative importance of _testing_ and _documentation_ is debatable,
but both are surely more urgent than cosmetic and even _structural_ changes such as the
ones discussed in the "Refactoring" chapter.

[^maslow]: This is a reference to the notorious Maslow hierarchy of needs for humans,
    starting with a need for food and shelter and going all the way to 
    self-actualization and transcendence.

Beautiful, clean and clever code is the equivalent of "self-actualization"
in the hierarchy of needs. It is wonderful to be able to reach it, 
but there are several steps before it which need to be fulfilled for the 
clever snippet of code to be useful.

Implementing a robust _process_ for the development of a software
project that is growing large is not simple, but it is definitely worth it, 
and an initial time investment can have a significant payoff.

# Bibliography
