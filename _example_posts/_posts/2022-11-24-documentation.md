---
layout: post
title: Documentation
date: 2022-11-14 17:39:00
description: 
tags: coding
# redirect: /assets/pdf/galileian_thesis.pdf
---

# Documentation

A crucial aspect in software usability is the presence of good documentation.

In my experience, when documentation is brought up people's mind often goes to comments
in the code, or line comments; but these are not proper _documentation_. 
Documentation is meant for the _user_ of our code, while line comments 
are at best useful for future developers.
As Clean Code [@martinCleanCodeHandbook2008] puts it, line comments are a 
"necessary evil".

Sometimes, a simple-looking piece of code has a counterintuitive element,
which may be clarified by a quick line comment; however, in most of their typical
uses, line comments could be substituted by clearer code.
The rest of this section, therefore, will not discuss line comments.

## The diátaxis framework

The diátaxis framework [@procidaDiataxisDocumentationFramework2022] 
allows us to structure our thinking about documentation
according to the needs of the user, as opposed to our convenience
when writing the code.

The website referenced above does an excellent job of explaining its 
categories, I will just give a quick summary here.
The classification is along two axes: the first is based on whether
the piece of documentation is meant to be used while studying or while 
working, while the second is based on whether the piece of documentation
contains pratical steps or theoretical knowledge.
Based on this, they distinguish the following categories:

1. __tutorials__ show the user at study practical steps in a safe environment:
  they are meant to show them how to get started using the software;
1. __how-to guides__ show the user at work practical steps in the real world:
  they are meant to show them how to accomplish some practical goal;
1. __reference material__ describes software in a way that is helpful for 
  a user at work, by listing its features, providing examples _etc._;
1. __explanation__ discusses the sofware broadly and theoretically,
  and is therefore meant for a user at study.

Reference material may be auto-generated in certain cases: for example, 
the documentation-formatting software for Python
[`sphinx`](https://www.sphinx-doc.org/en/master/) has an 
[`autodoc`](https://www.sphinx-doc.org/en/master/usage/extensions/autodoc.html)
extension which can read function and class docstrings and 
extract them into HTML documentation.
This, however, is not the be-all and end-all of documentation, and it is arguably
not even the most important part of it.

## Documentation for GWFish

Writing documentation may be a chore, and finding time to do it 
is difficult.
This section is devoted to the thought process behind
the [documentation I wrote for `GWFish`](https://gwfish.readthedocs.io/en/latest/),
and how it grew organically from user requirements.

I started writing it when I was asked to give a short tutorial on the usage of this
piece of software for people working on another gravitational wave detector proposal,
LGWA [@harmsLunarGravitationalwaveAntenna2021].
Having a spoken tutorial refer to written documentation is helpful, therefore
I wrote it down as a documentation page.
I used [`sphinx`](https://www.sphinx-doc.org/en/master/) combined with 
[`readthedocs`](https://readthedocs.org/) to make it so documentation could
be version-tracked in the same repository as the code, as well as be deployed
automatically whenever changes were made there.

Since the aim of a tutorial is to introduce new users to the software, I focused
mine on a simple test case: computing the Fisher matrix errors for a single 
signal, with a specific combination of future planned detectors.
The tutorial is in two parts, 
[here](https://gwfish.readthedocs.io/en/latest/tutorials/tutorial_170817.html)
and 
[here](https://gwfish.readthedocs.io/en/latest/tutorials/tutorial_randomization.html);
it is basic in the sense that it assumes no prior knowledge of the software itself,
but it does assume familiarity with the task of Fisher matrix forecasting.

The tutorial provides runnable scripts and their expected output, with 
an explanation of what that output means. It is computationally cheap, since
it is meant to be a learning tool, not to solve any concrete problems.

This was the starting point; after the architecture (`sphinx`+`readthedocs`) for the documentation was built it was easy to 
make small improvements and complement documentation pages with new information. 

A few examples of things that were added are as follows:

- the conventions for the naming of relevant parameters are not uniform,
  therefore I added a [page](https://gwfish.readthedocs.io/en/latest/reference/parameters_units.html) 
  to the _reference material_ section detailing 
  the ones used by this code specifically;
- a piece of functionality for this code is the computation of a detection 
  horizon (i.e. the maximum distance at which a certain signal can be detected),
  I discussed 
  [the line of reasonining behind this computation](https://gwfish.readthedocs.io/en/latest/explanation/horizon.html) 
  in the _explanation_ section;
- users may want to add new, custom detectors to do their own experiments:
  this was a good candidate for a very brief _how-to_ 
  [page](https://gwfish.readthedocs.io/en/latest/how-to/adding_new_detectors.html), 
  in which the steps to complete this real-world task are detailed; this page does
  not discuss the details of all the possible configurations for the detector, 
  since that is material best deferred to a 
  [reference page](https://gwfish.readthedocs.io/en/latest/reference/detectors.html#).

Crucially, all of these arose from someone's need (often mine) of having a clear
explanation of some aspect of the software readily available. 
Documentation grew organically, without any titanic one-time effort.
