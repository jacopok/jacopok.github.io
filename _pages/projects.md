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
{% if site.enable_project_categories and page.display_categories %}
  <!-- Display categorized projects -->
  {% for category in page.display_categories %}
  <a id="{{ category }}" href=".#{{ category }}">
    <h2 class="category">{{ category }}</h2>
  </a>
  {% assign categorized_projects = site.projects | where: "category", category %}
  {% assign sorted_projects = categorized_projects | sort: "importance" %}
  <!-- Generate cards for each project -->
  {% if page.horizontal %}
  <div class="container">
    <div class="row row-cols-2">
    {% for project in sorted_projects %}
      {% include projects_horizontal.liquid %}
    {% endfor %}
    </div>
  </div>
  {% else %}
  <div class="grid">
    {% for project in sorted_projects %}
      {% include projects.liquid %}
    {% endfor %}
  </div>
  {% endif %}
  {% endfor %}

{% else %}

<!-- Display projects without categories -->

{% assign sorted_projects = site.projects | sort: "importance" %}

  <!-- Generate cards for each project -->

{% if page.horizontal %}

  <div class="container">
    <div class="row row-cols-2">
    {% for project in sorted_projects %}
      {% include projects_horizontal.liquid %}
    {% endfor %}
    </div>
  </div>
  {% else %}
  <div class="grid">
    {% for project in sorted_projects %}
      {% include projects.liquid %}
    {% endfor %}
  </div>
  {% endif %}
{% endif %}
</div>

<br/>

### Working on

#### At the moment

This is a list of things I'm currently working on, within a timescale around a month.

1. Working to improve `mlgw_bns`
   1. including higher order modes
   1. aligning the timing of the waveforms and phasing of the modes
   1. including precession
   1. improving the evaluation time through an architecture change
1. Trying to improve the efficiency of `nessai`
1. Applying to postdocs
1. Training:
   1. trail running and cycling
   1. circus: handstands, acro yoga, acrobatics
   1. bodyweight calisthenics as a complement

#### Will get to

This is a list of tasks that I hope to get to in the future.


1. Improve the visualizations for EOB orbits with [`eob-visualizer`](https://github.com/jacopok/eob-visualizer): with blender, a "cloud of points" for the BH orbits corresponding to the posteriors.
1. Building a surrogate model for xkn (?)
1. applying time-domain relative binning to weird hyperbolic encounters
1. Working on a musical / dance outreach show about black holes
1. Finishing a D&D campaign based on [Frozen Sick](https://www.dndbeyond.com/sources/dnd/wa/frozen-sick#FrozenSick) with Padova people (december 2025)
1. Working on the inclination angle posterior feature and paper for BAYESTAR
1. Cosmological coupling of Black Holes
1. Writing a simple article detailing the science case for multimessenger observations;
   specifically focusing on what we can get from a combined PE
1. DWD and NS-WD detectability studies with [decihertz GW detectors](/_projects/LGWA)
1. Making a systematic study of the effect of the inclusion of high-order parameters
   in (BNS) waveforms
1. Can we build a time-domain evidence integrand for GW inference?
   1. Is it somehow computable from to the SNR TD integrand with the waveform reconstruction?
   1. Can the methodology [here](https://arxiv.org/abs/2310.01544) be also applied to the hyperbolic analyses of GW190521?
1. Learning to play bass
1. Secret project with Filippo
1. Do an LVK-style "population fit" of my run lengths, since 1Msun is a bit more than a km

#### Already did

1. DMing a [D&D campaign](/val_celia) in the West Marches style with Lorenzo - the campaign is now finished, this website contains all the stories of what happened in it!
1. DMing [Call of Cthulhu](/_projects/CoC) at GSSI ("Dockside Dogs", start of November)
1. Reviewing a section of the LGWA whitepaper
1. Helping on a paper about Lunar gravitational wave detection
1. Getting the `mlgw_bns` paper published
1. Making a presentation on [LGWA](/_projects/LGWA) for the [IFAE meeting](https://agenda.infn.it/event/34702/)
1. Getting access to the Virgo data at EGOs
1. Making a presentation for how [GWFish](https://github.com/janosch314/GWFish) works
1. Re-starting the [Fellowship of Clean Code](/_projects/FoCC)
1. Contributing to the [Einstein Telescope](/_projects/ET) Blue Book
1. Graduating at the [Galilean school](https://scuolagalileiana.unipd.it/) with a [thesis about clean coding practices](https://github.com/jacopok/clean-coding-thesis)
1. Making visualizations for EOB orbits with [`eob-visualizer`](https://github.com/jacopok/eob-visualizer)
1. Roughly learning how Stable Diffusion works
1. Making a presentation for the GSSI science fair about [LGWA](/_projects/LGWA)
1. Doing peer review
1. Running [Call of Cthulhu](/_projects/CoC) at GSSI (so far, "The Haunting")
1. Running a TTRPG session with grandma over the holidays
1. Races
   1. 14K trail race on the **8th of October**
   1. [Half-marathon](https://www.rome21k.com/en/21k-info-eng/) on the **19th of November**
   1. Rome Marathon on the **17th of March 2023**
   1. [Via degli Dei](https://www.komoot.com/it-it/tour/1403731244) on the 13-14th of April
