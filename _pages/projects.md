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

1. Re-starting the [Fellowship of Clean Code](focc)
1. Improving [timing in `mlgw_bns`](https://github.com/jacopok/mlgw_bns/issues/47)

#### Will get to

This is a list of tasks that I plan to get to in a timescale of a couple of months.

1. DWD and NS-WD detectability studies with [decihertz GW detectors](LGWA)
1. Improving [`GWFish`](https://github.com/janosch314/GWFish)
1. GRB intensity mapping classification
1. Starting a [GSSI D&D campaign](DnD)

#### Already did

1. Graduating at the [Galilean school](http://www.unipd-scuolagalileiana.it/) with a [thesis about clean coding practices](https://github.com/jacopok/clean-coding-thesis)
