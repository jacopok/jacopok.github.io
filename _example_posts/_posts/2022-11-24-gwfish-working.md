---
layout: post
title: A layperson's introduction to GWFish
date: 2022-11-14 17:39:00
description: 
tags: gravitational-waves
# redirect: /assets/pdf/galileian_thesis.pdf
---

## `GWFish` in short

What follows is a short explanation of what this piece of software does, 
aimed at non-physicists. I will first introduce the concept of gravitational 
wave detection and the purpose of `GWFish` at a general level, without
the mathematical details.
Then, I will go into more detail into the things it needs to compute,
including some math, but still at a level which an undergraduate
in a scientific field should be able to understand.

The first direct measurement of gravitational waves was accomplished 
in 2015 by the LIGO interferometers in the United States [@ligoscientificcollaborationandvirgocollaborationObservationGravitationalWaves2016].
In 2017, they were joined by the Virgo interferometer in Italy, and
the network has since detected almost 100 distinct signals. 
Most of these signals were generated by pairs of black holes orbiting each other,
with the remaining few corresponding to pairs of neutron stars or one neutron star 
and one black hole.

By lowering the noise in the interferometer, we went from no detection 
to about one signal per week during detector operation. 
This has already been called the birth of a 
new era of _gravitational wave astronomy_, which can complement "regular" 
electromagnetic astronomy. 

A lot of interest is going towards the question: how can we do better?
Which kinds of new detectors are best if we want to detect even more 
gravitational waves?
These instruments are big, expensive projects, therefore a careful scientific
evaluation of what we think a new detector concept might be able to 
accomplish is crucial when outlining a funding proposal.

The basic questions we wish to answer for any new detector concept are:

- Which kinds of gravitational wave sources will it be able to detect? How many of them?
- How well will it be able to estimate the properties of these sources?

The answers depend on two basic aspects:

- Given a specific astrophysical source, can _new planned detector X_ measure it? 
  If so, how well?
  - For example, consider a pair of black holes, with masses so-and-so, 
    at a distance of such-and-such...
- How many of that astrophysical source kind are there? How far away are they?
  - For example, what is the distribution of black hole binaries? What are their
    typical masses, how often do they occur in any given universe volume?


`GWFish` is a piece of software built for the purpose of giving an approximate
answer to the first of these questions, while it relies on other tools to answer the second.
Typically, the workflow consists in the generation of a theoretical _population_ of, for example,
binaries of black holes, which will contain several thousands of them, listing for each
their masses, distances, spin and so on. This will then be fed into a tool like `GWFish` to 
get detection statistics.

## Matched filtering

This section and the following will go in some detail about the mathematics
of the approximation used in order to quickly get the required detection 
statistics.

Our starting point is matched filtering, a fundamental technique used for all modern gravitational data analysis.
The idea is that we want to extract a very weak signal which is submerged in noise.
A complete overview of the method can be found in [@maggioreGravitationalWavesVolume2007],
here I will give a very brief one.

Our detectors are measuring _strain_, which roughly speaking is the fluctuation in
the length of the detector arms normalized to the arm length itself, $$h(t) = \Delta L (t) / L$$. Gravitational waves distort space itself, and we can therefore measure 
them by looking at this quantity.
The raw strain data from a GW detector typically looks like this:

{% include figure.html path="assets/img/bare.png" class="img-fluid rounded z-depth-1" zoomable=true %}

It is clear that the largest contribution in terms of amplitude is an oscillation
with period on the order of a couple of seconds, and amplitude on the order of a few times $$10^{-18}$$.

The signal we want to measure, unfortunately, is at least three orders of magnitude smaller: $$h \sim 10^{-21}$$! What can we do?
The first step is to look at the "Fourier spectrum" of these data (more specifically, the 
amplitude spectral density, but thinking of it as the amplitude of the Fourier transform is not 
terrible):

{% include figure.html path="assets/img/asd.png" class="img-fluid rounded z-depth-1" zoomable=true %}

We are not even showing the part of the spectrum with period on the order a few seconds,
the trend at low frequency continues and the amplitude for $$f \sim \qty{1}{Hz}$$ there is enormous. 
This detector is _not sensitive_ to signals with very low frequency, but it _is_ sensitive to 
signals with frequencies in a band around 100Hz. 

The first step towards actually measuring something lies in 
_whitening_ the measured data, that is, dividing every Fourier component by its root-mean-square value. 
After this procedure, our data looks like this:

{% include figure.html path="assets/img/whitened.png" class="img-fluid rounded z-depth-1" zoomable=true %}

Still, no signal is visible!
This is because the signal present in these data has high frequency and low amplitude; specifically, if we were to plot it 
subjected to the same procedure as the data, it would look like the orange curve: 

{% include figure.html path="assets/img/true_signal.png" class="img-fluid rounded z-depth-1" zoomable=true %}

So, how can we possibly detect something that is so far smaller in amplitude than our data?

The trick lies in a technique called _matched filtering_.
Suppose our measured data is $$d(t) = n(t) + s(t)$$, 
with $$n(t)$$ being the noise and $$s(t)$$ being the astrophysical signal (assumed here 
to be monochromatic for simplicity),
then we can look at a temporal integral in the form 

$$ I
= \frac{1}{T} \int d(t) s(t) \mathrm{d}t 
= \underbrace{\frac{1}{T} \int n(t) s(t) \mathrm{d}t}_{I_n} +
\underbrace{\frac{1}{T} \int s(t) s(t) \mathrm{d}t}_{I_s}\,,
$$

where $$T$$ is the length of the integration period. 
There are two components: 
$$I_s$$ is the average square magnitude of the signal, and it approaches a constant;
on the other hand, $$I_n$$ varies stochastically with $$n$$, but since $$n$$ and $$s$$ are not correlated the integral will be stochastic process with variance $$T$$ (and therefore standard deviation $$\sqrt{T}$$);
due to the division by $$T$$ this term will then decay like $$I_n \sim T^{-1/2}$$.
If we can observe the signal for long enough, then, the $$I_s$$ term will dominate.

This is the essence of gravitational data analysis: if we know the expected signal ahead of time,
we may extract its contribution from noisy data.
The integrals above are optimal if the case of white noise, but going back to the actually-measured
data the procedure is slightly more complicated.

Let us now jump ahead to the final result: first,
we need to estimate the noise power spectral density (that is, the noise power per frequency bin) $$S_n(f)$$,
and use to define with it the scalar product between timeseries $$d(t)$$ and $$h(t)$$ in terms 
of their Fourier transforms $$\widetilde{d}(f)$$ and $$\widetilde{h}(f)$$ as follows:

$$ (d | h) = 4 \Re \int _0^{ \infty } \frac{\widetilde{d}(f) \widetilde{h}(f)}{S_n(f)}\mathrm{d}f
$$

This product is the basis for signal searches, which are performed by
looking for peaks in the following function of $$t$$:

$$ (\text{observed strain data }d | h \text{, theoretical signal, shifted by a time }t)
$$

for a selection ("template bank") of plausible signals $$h$$ we might see.

Similarly, parameter estimation for any observed signal $$d$$ is performed by 
exploring the posterior distribution defined by the likelihood 

$$ 
\mathcal{L} (d | \theta ) 
= \mathcal{N} \exp \left(- \frac{1}{2} (d - h(\theta )| d - h(\theta ))\right)
$$

where $$\mathcal{N}$$ is a constant normalization factor. 

## Fisher matrix error estimation

Up to now we discussed the analysis of current data; the question `GWFish` seeks to answer, 
on the other hand, pertains to data taken by detectors we have not built yet.
We can, however, make estimates as to what their noise level will be and go from there. 

A typical question it answers could be posed as: 

> Given the estimated noise curve of the planned Einstein Telescope gravitational wave interferometer,
> suppose that two black holes with masses $$M_1 = M_2 = 30 M_{\odot}$$ (solar masses)
> merge at a distance of $$10^9$$ light years from Earth.[^under-spec] 
> How well could we measure their masses, distance, and position from the gravitational wave data?

[^under-spec]: The problem as stated is under-specified, there are several other parameters to consider, but let us keep it simple here.

The "proper" way to answer this question would be to simulate noise distributed according
to the given noise curve, add the known signal to it, and analyze it as if it were real data.
This can be done, and it _is_ done to a certain extent, but it is very expensive: a single analysis of this kind takes
several hours to days. 
This is what is done for the data of current detectors, where we know it to be worth it since it's _real_ astrophysical data).

This prevents us from exploring things such as the dependence of the results on things 
such as the masses of the black holes, the distance and so on, as that requires re-doing 
the aforementioned analysis several (thousands of) times.
The solution (or at least a partial one) is to make an approximation, 
called the _Fisher matrix approximation_: basically, we take the aforementioned likelihood, 
and approximate it as a multivariate Gaussian in the parameters $$\theta$$, with mean given by the values we selected.
Then, we may compute its covariance matrix by looking at the (negative expectation value of the) 
Hessian of $$\log \mathcal{L}$$ computed at that maximum-likelihood point, which is called the Fisher matrix:

$$ \mathcal{F}_{ij} = - \mathbb{E} \left( 
  \frac{\partial}{\partial \theta _i} 
  \frac{\partial}{\partial \theta _j}  
  \log \mathcal{L} (d | \theta )
\right)
=  \mathbb{E}
\frac{\partial}{\partial \theta _i} 
\frac{\partial}{\partial \theta _j}  
\left( \frac{1}{2} (d - h(\theta )| d - h(\theta )) \right)
$$

Taking the expectation value amounts to looking at the case in which the noise equals zero, 
i.e. $$d-h(\theta) = 0$$; going through the derivatives we find that the only non-vanishing contribution is
$$\mathcal{F}_{ij} = (\partial_i h | \partial_j h)$$, again evaluated at the maximum likelihood point.

This is the basic quantity `GWFish` is computing; we are approximating the likelihood as a 
Gaussian in the form $$\log \mathcal{L} \sim - \Delta\theta_i \mathcal{F}_{ij} \Delta\theta _j / 2$$ (with the 
[Einstein summation convention](https://en.wikipedia.org/wiki/Einstein_notation)), where $$\Delta \theta = \theta - \overline{\theta}$$
is the deviation of the parameter vector $$\theta$$ from its mean value $$\overline{\theta}$$. 
We may then use the properties of multivariate Gaussians, and state that our estimate for 
the variance of parameter $$i$$ is given in terms of the diagonal components of the inverse of $$\mathcal{F}$$:

$$ \sigma^2 _i \approx (\mathcal{F}^{-1})_{ii}\,.
$$

This is a frequentist phrasing; alternatively, it is equivalent to a Bayesian one
if we take a flat prior on the parameters, $$p(\theta ) = \text{const}$$. 
Surely such a prior will not be ultimately correct (for example, a flat prior on angular variables
is not flat on the sphere), but the Fisher matrix approximation is ultimately
quite rough itself, therefore including non-flat priors is likely not the primary concern. 