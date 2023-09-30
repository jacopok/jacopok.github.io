---
layout: page
permalink: /publications/
title: publications
description: |
  Short author list publications in reversed chronological order.
years: [2023, 2022]
nav: true
nav_order: 1
---
<!-- _pages/publications.md -->
For a complete list including collaboration papers you can query the arxiv like [this](https://arxiv.org/search/?query=Tissino%2C+j&searchtype=author).

<div class="publications">

{%- for y in page.years %}
  <h2 class="year">{{y}}</h2>
  {% bibliography -f my_papers -q @*[year={{y}}]* %}
{% endfor %}

</div>
