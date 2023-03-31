---
layout: page
title: projects
permalink: /projects/
description: A collection of everything I'm working on.
nav: true
nav_order: 2
display_categories: [research, hobbies]
horizontal: false
---

<!-- pages/projects.md -->
<div class="projects">
{%- if site.enable_project_categories and page.display_categories %}
  <!-- Display categorized projects -->
  {%- for category in page.display_categories %}
  <h2 class="category">{{ category }}</h2>
  {%- assign categorized_projects = site.projects | where: "category", category -%}
  {%- assign sorted_projects = categorized_projects | sort: "importance" %}
  <!-- Generate cards for each project -->
  {% if page.horizontal -%}
  <div class="container">
    <div class="row row-cols-2">
    {%- for project in sorted_projects -%}
      {% include projects_horizontal.html %}
    {%- endfor %}
    </div>
  </div>
  {%- else -%}
  <div class="grid">
    {%- for project in sorted_projects -%}
      {% include projects.html %}
    {%- endfor %}
  </div>
  {%- endif -%}
  {% endfor %}

{%- else -%}
<!-- Display projects without categories -->
  {%- assign sorted_projects = site.projects | sort: "importance" -%}
  <!-- Generate cards for each project -->
  {% if page.horizontal -%}
  <div class="container">
    <div class="row row-cols-2">
    {%- for project in sorted_projects -%}
      {% include projects_horizontal.html %}
    {%- endfor %}
    </div>
  </div>
  {%- else -%}
  <div class="grid">
    {%- for project in sorted_projects -%}
      {% include projects.html %}
    {%- endfor %}
  </div>
  {%- endif -%}
{%- endif -%}
</div>

### Working on 

#### At the moment

This is a list of things I'm currently working on, within a timescale around a week.

1. Making a presentation on [LGWA](LGWA) for the [IFAE meeting](https://agenda.infn.it/event/34702/)
    1. Remaking plots with new sensitivities
    1. Including Mt. Etna references
1. Making a study about how Fisher matrix sky localization compares to BAYESTAR localization (for full signals and pre-alerts)
1. Improving [`GWFish`](https://github.com/janosch314/GWFish)
    1. Making a PR with horizon-finding improvements
1. Helping out with some O4 [Virgo](Virgo) chores
1. Contributing to the ISSI conference proceedings
1. Learning to be a Keeper for [Call of Cthulhu](CoC)
1. DMing a DnD campaign based on [Frozen Sick](https://www.dndbeyond.com/sources/wa/frozen-sick#FrozenSick) with Padova people
1. Learning to play bass
1. Secret project (IG)

##### Questions


#### Will get to

This is a list of tasks that I plan to get to in a timescale of a couple of months.

1. Improving the way early-warning signals are handled and sent to observatories ([rehear](rehear))
1. Writing a simple article detailing the science case for multimessenger observations; 
  specifically focusing on what we can get from a combined PE
1. Contributing to the [LGWA](LGWA) whitepaper
1. Improving [`GWFish`](https://github.com/janosch314/GWFish)
    1. New documentation for waveform generation
    1. Implementing antenna patterns
    1. Implementing Markov chain network duty factor
1. DWD and NS-WD detectability studies with [decihertz GW detectors](LGWA)
1. Learning how BAYESTAR works and whether we can use it for [Einstein Telescope](ET)
    1. Can we include higher order modes?
1. Improving [timing in `mlgw_bns`](https://github.com/jacopok/mlgw_bns/issues/47)
1. Working on cosmology with GWs
  1. Measuring $H(z)$
  1. Tracing small-scale $P(k)$ with BBH
1. GRB intensity mapping classification
1. Starting a [GSSI D&D campaign](DnD)
1. Making a systematic study of the effect of the inclusion of high-order parameters 
  in (BNS) waveforms

##### Questions

1. Can we incorporate modelling uncertainties in GW PE?
1. How can we include the Earth's motion in PE?
1. How can we train "instant-posterior" models (e.g. DINGO) on longer signals
  such as BNS ones?
1. How does [`jax`](https://jax.readthedocs.io/en/latest/notebooks/quickstart.html) work?
1. How does multi-task gaussian process regression work ([Harisdau+2018](http://arxiv.org/abs/1805.03595))?
1. How does DINGO-IS work exactly?

#### Already did

1. Getting the `mlgw_bns` paper published
1. Getting access to the Virgo data at EGOs
1. Making a presentation for how [GWFish](https://github.com/janosch314/GWFish) works
1. Re-starting the [Fellowship of Clean Code](FoCC)
1. Contributing to the [Einstein Telescope](ET) Blue Book
1. Graduating at the [Galilean school](http://www.unipd-scuolagalileiana.it/) with a [thesis about clean coding practices](https://github.com/jacopok/clean-coding-thesis)
1. Making visualizations for EOB orbits with [`eob-visualizer`](https://github.com/jacopok/eob-visualizer)
1. Roughly learning how Stable Diffusion works
1. Making a presentation for the GSSI science fair about [LGWA](LGWA)
