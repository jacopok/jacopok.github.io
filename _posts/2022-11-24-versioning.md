---
layout: post
title: Versioning basics
date: 2022-11-14 17:39:00
description: 
tags: coding
# redirect: /assets/pdf/galileian_thesis.pdf
---

# Versioning

The first step towards successfully managing a software project is _version control_:
having a proper system to track changes to the code made by many people.

The most popular system for this purpose is by far and away [`git`](https://git-scm.com/), 
which was developed [by Linus Torvalds in 2005](https://github.com/git/git/commit/e83c5163316f89bfbde7d9ab23ca2e25604af290).
It is a powerful and fast distributed version control system.

Typically, `git` is used in conjunction with a hosting server in which to store 
the software project: common choices include [`github`](https://github.com/), 
[`gitlab`](https://about.gitlab.com/), [`bitbucket`](https://bitbucket.org/product/).
`GWFish` is hosted on `github`, at the url [github.com/janosch314/GWFish](https://github.com/janosch314/GWFish).

I will not introduce the basics of how to use `git` here, since there are many excellent 
resources for that; the discussion here is targeted at someone who is familiar with how to e.g. make commits, push to a remote repository and pull from it.

Recently, the group developing `GWFish` has started adopting a formal __process__ for the development of new features,
which quite closely matches [Github flow](https://docs.github.com/en/get-started/quickstart/github-flow).
This is not the only possible way of handling a collaborative workflow, but it is a rather simple
and effective one.

The idea is as follows: there is a `main` branch, which is expected to include finished code features
and a usable version of the code.
If I want to add a new feature, I will make a _feature branch_ off the main one.
The syntax is as follows:

```bash
git branch my-new-feature
git checkout my-new-feature
```

I can then work on this feature, making commits and pushing them to the repository.
This way, my work can be public while not interfering with the main branch.
While I will not voluntarily commit anything "wrong", building a new feature is necessarily experimental,
and the branch is a safe place to possibly make mistakes. 

When the feature seems to be good to go, I can then open a Pull Request (PR); the name is somewhat 
unfortunate since it's not in the perspective of the one making it.
`gitlab` calls them "merge requests", which is more descriptive: I am asking for my code 
in the branch to be merged into the main one. 
Regardless of the name, the concept is rather simple: a PR is a structured process with the end 
goal of integrating code from a feature branch into the main one.
This could also be accomplished with a simple git command (`git merge`), but the idea is that 
code from a feature branch should be evaluated and discussed.

As an example I will provide a [pull request](https://github.com/gwastro/pycbc/pull/3939) 
I made not for `GWFish` but for `pycbc`, an older and bigger piece of software 
for gravitational wave data analysis.
There is no need to discuss the specifics of that PR, the point here is the _structure_ 
of what was happening: I made a feature branch, proposing a new feature. 
I had previously outlined in an [issue](https://github.com/gwastro/pycbc/issues/3817) 
the reason why this feature was needed --- a common pattern
is to start with an issue and to solve it with a PR.  

A maintainer of the project reviewed the PR;
technical issues and slight modifications were discussed and implemented until 
a version of the feature which was satisfactory to everyone was reached.
To this end, the automated testing pipeline was quite useful: for each commit
I made to the branch, the pipeline could run to check that I had not accidentally
created a _regression_, i.e. broken some previously-working functionality.

## Semantic versioning

Besides making it easier for developers to track their work, versioning is useful 
in order for users to be able to understand how and when the software they are using 
is changing, whether they should upgrade, whether the functionality they are using
will be broken or discontinued.

The full extent of this information should be specified in long-form in a changelog,
discussed in the next section, but a simple shorthand for it may be given by a 
_standardized_ versioning system such as [semantic versioning](https://semver.org/).
It is a rather simple specification, with all versions[^semver-pre] looking like X.Y.Z with integer X, Y and Z.
An alternative, which is recommended for large projects, is [calendar-based versioning](https://calver.org/).

[^semver-pre]: All full releases; prereleases 
  are allowed to be in the form e.g. X.Y.Z-alpha.

The advantage of using a standardized (and very widespread) system is that the meaning 
may be clear without requiring explanation. If it is not, or a user wants to know more, 
having a changelog is useful.

### Changelogs

A changelog should be human-readable, and communicate in short to a user what changed from a version 
to another. As with versions, it is good for it to follow some standard, and a good 
one may be found at [keep a changelog](https://keepachangelog.com/en/1.0.0/).

If we write good git commit messages it may be tempting to use them to automatically 
construct a changelog. This is a bad idea!
They contain way too much information compared to what the user needs to know 
about the new version.

Is it worth it to use semantic versioning and to maintain a changelog?
As always, it depends on the size of the project at hand, but I would argue that 
if you want people to be able to use it without needing personal contact with you, 
it is time to have a changelog.

Even if this is not the case, however, a changelog may be very useful: 
if a project is being version-tracked, the act of writing out what has been modified
can be helpful in clarifying what is happening with the code. 

## Poetry and dependency management

A common source of issues in software development lies in dependency management.
Ideally, we would like the user to be able to install our package without having to worry 
about its dependencies, with everything being handled automatically.

This has been a long-standing issue in the `python` ecosystem, and a complete solution does 
not exist. However, a lot of work is going into it, and the most promising approach seems to 
be the management of a `pyproject.toml` file with [`poetry`](https://python-poetry.org/).

A usage guide for `poetry` is beyond the scope of this work, and the documentation for it is 
quite good.
It allows for the automatic creation of virtual environments containing only the dependencies
specified as required for the project, thus making it less likely that we will inadvertently use
functionality from dependencies we are not specifying.
It also automates checks for valid version combinations, as well as version control and publishing
a project to `pypi`.

Overall, it is a very convenient system to manage the versions of our software and of its 
dependencies.