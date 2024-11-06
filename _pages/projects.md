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
It's too many! I know.

1. Working on the multiband paper (analysis of long signals in the SSB frame)
1. Working on the inclination angle posterior feature and paper for BAYESTAR
1. DMing a [D&D campaign](/val_celia) in the West Marches style with Lorenzo
1. DMing [Call of Cthulhu](/_projects/CoC) at GSSI ("Dockside Dogs", start of November)
1. DMing a D&D campaign based on [Frozen Sick](https://www.dndbeyond.com/sources/dnd/wa/frozen-sick#FrozenSick) with Padova people (november-december 2024)
1. Training by trail running + aerial silks + free body calisthenics-like strength (also climbing and cycling sometimes)

#### Will get to

This is a list of tasks that I plan to get to in a timescale of a couple of months.

1. Helping in the supervision of master's students about:
   1. [upgrades to `mlgw_bns`](https://github.com/jacopok/mlgw_bns/issues/8)
1. [rehear](/rehear): injection studies with ASTRI + SWIFT
   1. Paper draft
   1. Implementing a simplified model for the IRF of ASTRI
   1. Testing it with a simple emission model
   1. Then, moving towards the full injection, yielding percentages of sources pre-localized well enough
   1. Running the same tests with the O3 replay MDC
1. Helping as a reviewee of TEOBResumS-DALI
1. Maintaining [`GWFish`](https://github.com/janosch314/GWFish)
   1. Making the small interface fixes requested
   1. Updating the `pypi` release of the code
1. Cosmological coupling of Black Holes
1. Working on some weird statistical methods for the BOAT
1. O4 [Virgo](/projects/Virgo): participating in the Rapid Response Team
1. Helping standardize waveform review tests for the LVK
1. Improving the NWI's approach to parameter checking
1. Organizing sessions on data visualization for the Fellowship of Clean Code
   <!-- 1. Consistent ephemeris computation for all detectors - time shift to implement from the atom interferometry paper, or from Wen+Chen 2010
   1. Enable simulation of DWD and other low-frequency-derivative signals -->
1. Contributing to the [LGWA](/projects/LGWA) whitepaper (deadline: **end of November**)
   1. Writing some preliminary info about localization
   1. Doing some Fisher runs on massive BBH, multiband
   1. Doing a full PE run for a BNS as seen by LGWA
1. Improving the way early-warning signals are handled and sent to observatories ([rehear](/_projects/rehear))
   1. Comparing CTA slewing strategies with divergent pointing
1. Working on NWI tests
   1. Implementing more of the v5 review tests as well as [these ones](https://git.ligo.org/waveforms/1-main/-/issues/10#note_851322)
1. Making a study about how Fisher matrix sky localization compares to BAYESTAR localization (for full signals and pre-alerts)
1. Checking whether the placement of templates according to a greedy algorithm is a good choice for NR informativeness
1. Checking how fast we can make a truncated template bank for updating inference ([rehear](/_projects/rehear))
1. GWFish long-term things
   1. Making a PR with horizon-finding improvements
      1. Horizon-finding in the case of long-lived signals: when is the optimal time to detect them?
   1. New documentation for waveform generation
   1. Implementing antenna patterns (make tests with comparison to pycbc!)
   1. Implementing Markov chain network duty factor
1. Making a fit for the phenomenology of hyperbolic encounters as a function of energy and angular momentum
1. Writing a simple article detailing the science case for multimessenger observations;
   specifically focusing on what we can get from a combined PE
1. DWD and NS-WD detectability studies with [decihertz GW detectors](/_projects/LGWA)
1. Including higher order modes in BAYESTAR for [Einstein Telescope](/_projects/ET)
1. Improving [timing in `mlgw_bns`](https://github.com/jacopok/mlgw_bns/issues/47)
1. Working on cosmology with GWs
1. Measuring $H(z)$
1. Tracing small-scale $P(k)$ with BBH
1. GRB intensity mapping classification
1. Making a systematic study of the effect of the inclusion of high-order parameters
   in (BNS) waveforms
1. Seeing whether the upgraded version of RES-NOVA can measure neutrino mass through delays with failed SNe
1. Can we build a time-domain evidence integrand for GW inference?
   1. Is it somehow computable from to the SNR TD integrand with the waveform reconstruction?
   1. Can the methodology [here](https://arxiv.org/abs/2310.01544) be also applied to the hyperbolic analyses of GW190521?
1. Learning to play bass
1. Secret project with Filippo
1. Make a page on this website with matplotlib tips and tricks
1. Can we include the full-relativistic eleastic medium treatment from Belgacem+24 in a seismic simulation code?

##### Questions

1. Can we incorporate modelling uncertainties in GW PE?
1. What are the localization capabilities for a lunar detector? can we do a PE run for LGWA?
1. How can we include the Earth's motion in PE?
   1. Justin Janquart did it based on how it's done in Iacovelli+22, but only for the 22 mode
1. How can we train "instant-posterior" models (e.g. DINGO) on longer signals
   such as BNS ones?
1. How does [`jax`](https://jax.readthedocs.io/en/latest/notebooks/quickstart.html) work?
1. How does multi-task gaussian process regression work ([Harisdau+2018](http://arxiv.org/abs/1805.03595))?
1. How does DINGO-IS work exactly?
1. How do the burst search efficiencies compare to matched-filtering SNRs?
1. What causes the [Virgo $1 / \sqrt{f}$ noise](https://wiki.virgo-gw.eu/Commissioning/MysteryOneOverSqrtFnoise)?
1. How does one do injections with BAYESTAR?
1. Does updating the prior each time fix the Bayes factor multiplication bias described by Isi, Farr and Chatziiannou?
1. How does the center of the skymap move with time?

1. How do we do Fisher matrix forecasting with coordinates in the SSB?
1. What are the necessary improvements to the computing infrastructure
   to implement `rehear`?
1. Real-time reanalysis,
1. more EW frequency thresholds,
1. a fast communication system for updates without "polluting" the environment with
   too many GCNs?
1. timings

#### Already did

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
