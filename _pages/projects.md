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

1. Making a presentation for the GSSI science fair
1. Improving [`GWFish`](https://github.com/janosch314/GWFish)
  1. Implementing antenna patterns
  1. Studying how it compares, at low SNR, to BAYESTAR / GWTC3 in localization
  1. New documentation for waveform generation
1. DWD and NS-WD detectability studies with [decihertz GW detectors](LGWA)
1. Helping out with some O4 [Virgo](Virgo) chores
1. Contributing to the ISSI conference proceedings
1. DMing a DnD campaign based on [Frozen Sick](https://www.dndbeyond.com/sources/wa/frozen-sick#FrozenSick) with Padova people

##### Questions

1. How does DINGO-IS work exactly?

#### Will get to

This is a list of tasks that I plan to get to in a timescale of a couple of months.

1. Learning how BAYESTAR works and whether we can use it for [Einstein Telescope](ET)
    1. Can we include higher order modes?
1. Improving the way early-warning signals are handled and sent to observatories ([rehear](rehear))
1. Improving [timing in `mlgw_bns`](https://github.com/jacopok/mlgw_bns/issues/47)
1. Working on cosmology with GWs
  1. Measuring $H(z)$
  1. Tracing small-scale $P(k)$ with BBH
1. GRB intensity mapping classification
1. Starting a [GSSI D&D campaign](DnD)
1. Learning to be a Keeper for [Call of Cthulhu](CoC)
1. Making a systematic study of the effect of the inclusion of high-order parameters 
  in (BNS) waveforms

##### Questions

1. Can we incorporate modelling uncertainties in GW PE?
1. How can we include the Earth's motion in PE?
1. How can we train "instant-posterior" models (e.g. DINGO) on longer signals
  such as BNS ones?
1. How does [`jax`](https://jax.readthedocs.io/en/latest/notebooks/quickstart.html) work?

#### Already did

1. Making a presentation for how [GWFish](https://github.com/janosch314/GWFish) works
1. Re-starting the [Fellowship of Clean Code](FoCC)
1. Contributing to the [Einstein Telescope](ET) Blue Book
1. Graduating at the [Galilean school](http://www.unipd-scuolagalileiana.it/) with a [thesis about clean coding practices](https://github.com/jacopok/clean-coding-thesis)
1. Making visualizations for EOB orbits with [`eob-visualizer`](https://github.com/jacopok/eob-visualizer)
1. Roughly learning how Stable Diffusion works
