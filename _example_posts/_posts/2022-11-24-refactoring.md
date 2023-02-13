---
layout: post
title: Refactoring
date: 2022-11-14 17:39:00
description: 
tags: coding
# redirect: /assets/pdf/galileian_thesis.pdf
---

# Refactoring

All previous sections have been _around_ code more than _about_ it:
how to track its versions, document it, test it. 
Indeed, the aforementioned topics should typically have a higher priority 
than making changes to the code.
Eventually, though, we will have to modify it: how and why should we?

In order to make the discussion here somewhat constrained, I will limit it 
to the refactoring of one single function, purposefully doing so 
without modifying anything else. 

## Refactoring `analyzeFisherErrors`

The computation of the errors from Fisher matrices in `GWFish` goes through a function 
called `analyzeFisherErrors`, which takes the following parameters:

- `network`, an object of type `Network`, which contains several `Detector` objects;
- `parameter_values`, a `pandas` `DataFrame` with each row representing a signal, and 
  with each column corresponding to a different event parameter (masses, distance etc.);
- `fisher_parameters`, a list containing the aforementioned parameters in order;
- `population`, a string containing the name of the population being considered;
- `networks_ids`, a list of lists of integers, each between 0 and the number of detectors minus one.

The idea with the `networks_ids` parameter is the following: suppose we have a network 
of three detectors, A B and C, and that we want to be able to compute the capabilities
they would have all together or as pairs of 2. 
We can accomplish this with `network_ids=[[0, 1], [1, 2], [0, 2], [0, 1, 2]]`:
the numbers in each sub-list are indices used to select the detectors 
making up a subnetwork.

This function performs the following tasks for each of the subnetworks:

- compute the overall signal-to-noise ratio (SNR) as the root-mean-square of the individual SNRs;
- compute the network Fisher matrix as the sum of the individual Fisher matrices;
- compute the covariance matrix by inverting the network Fisher matrix;
- compute the sky localization ellipse size, which is determined by the errors 
  on the sky position angles (right ascension and declination);
- write all the computed errors to a text file.

The function does not return anything. The code is reported here for reference,
with minor changes to allow for correct printing. The full one can be found in 
[this snapshot of the repository](https://github.com/janosch314/GWFish/blob/c63023fe25ed703f30a79309d71035fd4839f24f/GWFish/modules/fishermatrix.py#L97).

```python
def analyzeFisherErrors(network, parameter_values, fisher_parameters, population, networks_ids):
    """
    Analyze parameter errors.
    """

    # Check if sky-location parameters are part of Fisher analysis. 
    # If yes, sky-location error will be calculated.
    signals_havesky = False
    if ('ra' in fisher_parameters) and ('dec' in fisher_parameters):
        signals_havesky = True
        i_ra = fisher_parameters.index('ra')
        i_dec = fisher_parameters.index('dec')
    signals_haveids = False
    if 'id' in parameter_values.columns:
        signals_haveids = True
        signal_ids = parameter_values['id']
        parameter_values.drop('id', inplace=True, axis=1)


    npar = len(fisher_parameters)
    ns = len(network.detectors[0].fisher_matrix[:, 0, 0])  # number of signals
    N = len(networks_ids)

    detect_SNR = network.detection_SNR

    network_names = []
    for n in np.arange(N):
        network_names.append('_'.join(
          [network.detectors[k].name for k in networks_ids[n]])
        )

    for n in np.arange(N):
        parameter_errors = np.zeros((ns, npar))
        sky_localization = np.zeros((ns,))
        networkSNR = np.zeros((ns,))
        for d in networks_ids[n]:
            networkSNR += network.detectors[d].SNR ** 2
        networkSNR = np.sqrt(networkSNR)

        for k in np.arange(ns):
            network_fisher_matrix = np.zeros((npar, npar))

            if networkSNR[k] > detect_SNR[1]:
                for d in networks_ids[n]:
                    if network.detectors[d].SNR[k] > detect_SNR[0]:
                        network_fisher_matrix += np.squeeze(
                          network.detectors[d].fisher_matrix[k, :, :])

                if npar > 0:
                    network_fisher_inverse = invertSVD(network_fisher_matrix)
                    parameter_errors[k, :] = np.sqrt(
                      np.diagonal(network_fisher_inverse))

                    if signals_havesky:
                        sky_localization[k] = (
                          np.pi * np.abs(np.cos(parameter_values['dec'].iloc[k]))
                          * np.sqrt(network_fisher_inverse[i_ra, i_ra]
                          * network_fisher_inverse[i_dec, i_dec]
                          - network_fisher_inverse[i_ra, i_dec]**2))
        delim = " "
        header = ('network_SNR '+delim.join(parameter_values.keys())+
          " "+delim.join(["err_" + x for x in fisher_parameters])
        )

        ii = np.where(networkSNR > detect_SNR[1])[0]
        save_data = np.c_[networkSNR[ii], 
          parameter_values.iloc[ii], 
          parameter_errors[ii, :]]
        if signals_havesky:
            header += " err_sky_location"
            save_data = np.c_[save_data, sky_localization[ii]]
        if signals_haveids:
            header = "signal "+header
            save_data = np.c_[signal_ids.iloc[ii], save_data]

        file_name = ('Errors_' + network_names[n] + '_' 
          + population + '_SNR' + str(detect_SNR[1]) + '.txt'
          )

        if signals_haveids and (len(save_data) > 0):
            np.savetxt('Errors_' + network_names[n] + '_' 
              + population + '_SNR' + str(detect_SNR[1]) + '.txt',
              save_data,
              delimiter=' ', 
              fmt='%s ' + "%.3E " * (len(save_data[0, :]) - 1), 
              header=header, 
              comments=''
            )
        else:
            np.savetxt(
              'Errors_' + network_names[n] + '_' + population + 
              '_SNR' + str(detect_SNR[1]) + '.txt',
              save_data, 
              delimiter=' ', 
              fmt='%s ' + "%.3E " * (len(save_data[0, :]) - 1), 
              header=header, 
              comments=''
            )
```

This function was not written from scratch like this: it shows the signs of a simple
function being gradually extended to "work above its pay grade", which 
made it quite complex.
It has many switches and several layers of loops.
It features some duplication, which is a violation of the so-called 
"DRY principle" (Don't Repeat Yourself): similar but different parts of the 
code being activated in different situations are dangerous, since
it is easy to modify one but not the other.

The next sections will discuss how these issues can be addressed, but 
one thing needs to be made explicit: if this was one-off code, it would be
fine as-is.
The necessity to refactor it came from actual user needs --- specifically, 
a user required `hdf5` output for the errors, which would not be easily achievable
with the function as written here.
As opposed to adding another `if` clause, we can refactor the logic
and make it more modular.

Writing the function in a "messy" way and _then_ refactoring it _if needed_ is a good process:
the messy code is often easier to write quickly, it does not require us to think about
which abstractions we should use and how each of the modular components 
we make maybe used in other contexts.
Premature abstraction can create technical debt just like forests of for loops can.
So, this section should not be interpreted as "fixing bad code", but as 
a natural part of the development process: starting with the easiest-to-write
code that will get the job done, and then refining it.

## Too many purposes

The first thing that catches the eye is that this function is doing two "big" things
at once: calculations (combining Fisher matrices etc.) and input-output (I/O: writing out to a file).
Combining them may seem natural in a first formulation, since once we have computed 
these values we want to save them somewhere, but this poses several issues.

- If a user wishes to use the computed errors, they have no way to access them directly,
  and if they do not modify the source code they must save to a file and then read
  from that file;
- in this case, loss of information: the values are being saved 
  in scientific notation with three decimals in the mantissa, which means all information
  beyond these digits is lost;
- tests are really difficult to write for such a function: it has _side effects_,
  meaning that when it is run it saves things to disk somewhere, as opposed
  to being fully characterized by its output.

A simple solution to this is to split the function in two: one for the computation,
one for the output.

We can do better: several sub-tasks in this function can be modularized, 
with the guiding principle of having each function perform a single conceptual task.


## Type hinting

This function's call signature is a good example of how type hints 
can be useful. Without reading the function code, how could we be able to tell 
that, for example, `population` should be a string while `network` should be
an object of type `Newtork`?

Documenting the function could be a solution, but is not the best one for this purpose.
Despite our best efforts, it is not guaranteed to remain up-to-date;
also, we may get it wrong, and there is no way to automatically check it.

In this context, since we are writing the code of a relatively large module,
it makes sense to use type hinting: python is dynamically typed, so it 
allows us to not say anything about the types of the variables we are using,
but we do have functionality to specify which types we expect.

The syntax to do it in this case is as follows:

```python
def analyzeFisherErrors(
    network: det.Network, 
    parameter_values: pd.DataFrame, 
    fisher_parameters: list[str], 
    population: str, 
    networks_ids: list[list[int]]
) -> None:
```

Python by itself will completely ignore these (as long as they can be evaluated without
raising an error), which means they are only as good 
as documentation written in a comment; however, there are ways in which they
can be better.
For one, they are returned when calling `help(analyzeFisherErrors)` in a console.
That is, however, also true for the docstring of the function.

The real power of type annotations in `python` is that they can be formally checked 
by a tool, called a _static type checker_, 
which will raise an error if, for example, a function is called with the wrong types,
or if it uses its arguments in a way that is not compatible with their stated types.
There are several of these available, but here we will focus on `mypy`.

This is a very useful tool to make spotting errors easier in a big codebase;
since it is only used on the module code, it allows us to have clarity on the 
types within our module while retaining the flexibility of dynamic types
when we use our code in an interactive console or a script.

After installing `mypy` (`pip install mypy`), we may use it from the command line
with the command 

```bash
mypy fishermatrix.py
```

where `fishermatrix.py` is the name of the module file containing the `analyzeFisherErrors`
function.
By itself this will raise several errors, of the sort

```
auxiliary.py:1: error: Skipping analyzing "scipy": module is installed, 
  but missing library stubs or py.typed marker
```

for many packages beyond `scipy`. This reflects the fact that these imported packages are 
not adopting type hints themselves, which means calls to them cannot be checked.
This reflects the fact that type hinting is a relatively recent addition to the 
`python` ecosystem, and many large libraries have not adopted it.

This does not prevent us from using `mypy` in our own code, however, it might 
just limit its usefulness; in order to get rid of the error we can run `mypy` 
with the option `--ignore-missing-imports`.
With it, we get 
```bash
$ mypy fishermatrix.py --ignore-missing-imports 
Success: no issues found in 1 source file
```

This is good! Note that the file also contains other, non-type-hinted functions,
which does not create any issue.
We could enforce typing on _every_ function with the option `--strict`.

We can make sure that `mypy` is indeed checking the body of the function
by making the signature wrong in some way: for example, if we change the 
hint on the `network_ids` argument to `networks_ids: int` (as opposed to 
`networks_ids: list[list[int]]`) we get the error

```python
$ mypy fishermatrix.py --ignore-missing-imports 
fishermatrix.py:52: error: Argument 1 to "len" has incompatible type "int"; expected "Sized"
fishermatrix.py:59: error: Value of type "int" is not indexable
fishermatrix.py:66: error: Value of type "int" is not indexable
fishermatrix.py:74: error: Value of type "int" is not indexable
Found 4 errors in 1 file (checked 1 source file)
```

`mypy` is able to understand that we are using this parameter
as a list (for example, indexing it), so if it were an integer it 
would not be valid.
Several errors can be caught this way.

## Automatic formatting

Git commits often get polluted with meaningless whitespace changes, 
newlines added somewhere, and so on.
This takes away from our ability to understand what was actually changed. 
Also, if different parts of the code are written by different people,
the style will often look inconsistent. 

This is a somewhat minor thing, but having automatic formatting as a part 
of our development routine ensures consistency and makes all code 
easier to read.
There are several choices for this task, and I personally like 
[`black`](https://github.com/psf/black) (of course, this is something 
that should be agreed on within a project).
For `python`, standard style is defined by [PEP8](https://peps.python.org/pep-0008/);
while conforming to it is not a requirement, it is used widely enough that
code formatted according to it will be readily understandable to
a large amount of people.

After installing it with `pip install black`, we may format any file or folder
with a command such as:

```bash
$ black fishermatrix.py 
reformatted fishermatrix.py

All done! 
1 file reformatted.
```

This is the output of the first run, while subsequent ones will show a message such as

```bash
All done!
1 file left unchanged.
```

## Linting and PEP8

We can also use automated analysis tools to check our code for style and
compliance to best practices: this is called _linting_.

When running `pylint`, a common linter, on this function, we get a few warnings,
shortened here for brevity:

```bash
$ pylint fishermatrix.py 
************* Module fishermatrix
fishermatrix.py:38:0: C0301: Line too long (114/100) (line-too-long)
fishermatrix.py:12:0: C0116: Missing function or method docstring (missing-function-docstring)
fishermatrix.py:15:4: C0103: Variable name "dm" doesn't conform to snake_case naming style (invalid-name)
fishermatrix.py:27:0: C0103: Function name "analyzeFisherErrors" doesn't conform to snake_case naming style (invalid-name)
fishermatrix.py:27:0: R0914: Too many local variables (29/15) (too-many-locals)
fishermatrix.py:27:0: R0912: Too many branches (15/12) (too-many-branches)
``` 

Some of these are rather generic warnings, which can be disabled or changed;
however, they do point to some issues we discussed earlier: this function
has too many tasks, and this naturally shows up in its number of local variables,
branches (e.g. `if`s and `for`s).

The heuristics used by a given linter are not gospel, but they may give us
a helpful indication about which parts of the code were not carefully 
written.

## Git hooks

Things such as automatic formatting, linting, and even static type checking, 
are very useful if applied consistently. 
However, we are fallible and may forget to do so; 
also, typing `black <name.py>` often gets annoying. 

There is a nice way, however, to ensure that badly-formatted code does not 
have the chance to get into our version tracking: 
[git hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks).

Using them is not very difficult: we just need to create a file called
`pre-commit` in the folder `.git/hooks/`. 
Its content, as a bash script, will be executed every time we make a commit;
if it returns a non-zero code (which, for example, `black` will do if 
it needed to modify the files it found) it will abort the commit. 
However, it will have modified the relevant files; re-adding them 
will allow us to make a commit with only correctly-formatted files.

## Premature optimizations

The code in `analyzeFisherErrors` 
is often using the syntax `for i in np.arange(N)` in order to loop 
over `N` numbers, as opposed to the native python `for i in range(N)`.
The logic behind it was to improve performance: after all, `numpy` 
is typically faster than native `python` for vector and matrix operations. 

However, using it in this context is a case of premature optimization.
Benchmarking the whole function for this example is overkill, so let us use a simpler
example: suppose we want to compute (but not store) the sums of the first 1000 integers.
The native-python solution is 

```python
for x in range(1000): 
    x+x
```

which takes about \qty{20}{\micro\second} on my machine (measured with the `ipython` magic `%timeit`).
The alternative with `np.arange`,

```python
for x in np.arange(1000): 
    x+x
```

takes roughly double that: \qty{43}{\micro\second}. 
The way to really get a speed improvement in this context would be to ditch the `for` loop completely, 
and directly work with `numpy` vectors:

```python
x_vec = np.arange(1000): 
x_vec + x_vec
```

This takes roughly \qty{1.4}{\micro\second}.

Really, though, the `for` loops within `analyzeFisherErrors` are not the bottleneck in its evaluation, and this function is a rather fast component of the code.
I would argue that in this case readability matters more than speed; 
even if `np.arange` was slightly faster than `range`, 
it would still be worth it to use the simpler 
native syntax in order to have less visual clutter. 

Here performance is secondary to speed, but sometimes it may not be.
In those cases, proper profiling is essential.
There are several tools for this in the `python` ecosystem.
For targeted optimization of a single function, I have had great success
with [`cProfile`](https://docs.python.org/3/library/profile.html) combined with 
the visualization tool [`snakeviz`](https://jiffyclub.github.io/snakeviz/): 
they can provide a breakdown of each function call happening inside the target function,
allowing us to understand which the potentially slow parts are.

Another great tool which has recently been rising in popularity is 
[`scalene`](https://github.com/plasma-umass/scalene) [@bergerScaleneScriptingLanguageAware2020]. It allows for the profiling
of memory usage, as well as distinguishing time spent in native `python`
versus time spent running wrappers around `C` code. 

This is useful since a common strategy to accelerate `python` code
is indeed to take the numerical kernel of our computations and have it 
be computed by efficient, compiled `C` code.
If we made a mistake and the `C` code is not being run, evaluation 
may be slow: `scalene` can aid in spotting such issues.

## Test-aided refactoring and mocking

When refactoring, an important part of the job is to ensure that we are not breaking 
existing functionality. 

So, before modifying anything substantial we should be covered by a test 
(or multiple).
A minimal example of calling the `analyzeFisherErrors` function looks like 
the following. Note that, while it is formatted as a test, it is currently
not performing any actual testing! As written, this is no more than a 
_smoke test_.[^smoke]

[^smoke]: The terms may originate in analog circuit design: this "test" 
    is the equivalent of plugging in a soldered circuit board and 
    seeing whether smoke is coming out of it. 
    The absence of smoke is not a guarantee of the correctness of the results.

```python
import pytest
from fishermatrix import analyzeFisherErrors
from detection import Network, Detector
import pandas as pd
import numpy as np


def test_fisher_analysis_output():

    params = {
        "mass_1": 1.4,
        "mass_2": 1.4,
        "redshift": 0.01,
        "luminosity_distance": 40,
        "theta_jn": 5 / 6 * np.pi,
        "ra": 3.45,
        "dec": -0.41,
        "psi": 1.6,
        "phase": 0,
        "geocent_time": 1187008882,
    }

    parameter_values = pd.DataFrame()
    for key, item in params.items():
        parameter_values[key] = np.full((1,), item)

    fisher_parameters = list(params.keys())

    network = Network(
        detector_ids=["ET"],
        parameters=parameter_values,
        fisher_parameters=fisher_parameters,
        config="detectors.yaml",
    )

    network.detectors[0].fisher_matrix[0, :, :] = fishermatrix.FisherMatrix(
        "gwfish_TaylorF2",
        parameter_values.iloc[0],
        fisher_parameters,
        network.detectors[0],
    )

    network.detectors[0].SNR[0] = 100

    analyzeFisherErrors(
        network=network,
        parameter_values=parameter_values,
        fisher_parameters=fisher_parameters,
        population="test",
        networks_ids=[[0]],
    )
```

The fact that the minimum code required to run this function is so large
is an indication of the high degree of _coupling_ in the codebase: a part 
of it cannot function independently of the others.

In this case, testing the output seems to be hard to do since our code is writing out a file.
Specifically, running this code leads to a file named `Errors_ET_test_SNR8.0.txt` being created,
with the content:

```
network_SNR mass_1 mass_2 redshift luminosity_distance theta_jn ra dec psi phase geocent_time err_mass_1 err_mass_2 err_redshift err_luminosity_distance err_theta_jn err_ra err_dec err_psi err_phase err_geocent_time err_sky_location
100.0 1.400E+00 1.400E+00 1.000E-02 4.000E+01 2.618E+00 3.450E+00 -4.100E-01 1.600E+00 0.000E+00 1.187E+09 1.018E-07 1.018E-07 8.969E-08 2.322E+00 1.042E-01 3.127E-03 2.694E-03 2.042E-01 4.093E-01 5.639E-05 2.423E-05 
```

An option would be to read the file as a part of the test and then delete it, 
but that is somewhat risky: the deletion might have issues (especially if the test 
fails), and if the file is still there for the next test we have created
non-independent test cases.

There are various ways around this, but I will use it to showcase the 
concept of _mocking_: substituting a complex function with a simplified version, 
which does not have its full functionality, but which allows us to check
that the complex function would have been called correctly.

In our case, we can mock the `numpy.savetxt` function, so that our test does not actually
save anything to a file, but we just check that we _would_ save the correct thing.
We can do so with the `pytest-mock` library, and it looks like this:

```python
import pytest
from fishermatrix import analyzeFisherErrors
import fishermatrix
import waveforms
import detection
from detection import Network, Detector
import pandas as pd
import numpy as np


def test_fisher_analysis_output(mocker):

    params = {
        "mass_1": 1.4,
        "mass_2": 1.4,
        "redshift": 0.01,
        "luminosity_distance": 40,
        "theta_jn": 5 / 6 * np.pi,
        "ra": 3.45,
        "dec": -0.41,
        "psi": 1.6,
        "phase": 0,
        "geocent_time": 1187008882,
    }

    parameter_values = pd.DataFrame()
    for key, item in params.items():
        parameter_values[key] = np.full((1,), item)

    fisher_parameters = list(params.keys())

    network = Network(
        detector_ids=["ET"],
        parameters=parameter_values,
        fisher_parameters=fisher_parameters,
        config="detectors.yaml",
    )

    network.detectors[0].fisher_matrix[0, :, :] = fishermatrix.FisherMatrix(
        "gwfish_TaylorF2",
        parameter_values.iloc[0],
        fisher_parameters,
        network.detectors[0],
    )

    network.detectors[0].SNR[0] = 100

    mocker.patch("numpy.savetxt")

    analyzeFisherErrors(
        network=network,
        parameter_values=parameter_values,
        fisher_parameters=fisher_parameters,
        population="test",
        networks_ids=[[0]],
    )

    header = (
        "network_SNR mass_1 mass_2 redshift luminosity_distance "
        "theta_jn ra dec psi phase geocent_time err_mass_1 err_mass_2 "
        "err_redshift err_luminosity_distance err_theta_jn err_ra "
        "err_dec err_psi err_phase err_geocent_time err_sky_location"
    )

    data = [
        1.00000000000e02,
        1.39999999999e00,
        1.39999999999e00,
        1.00000000000e-02,
        4.00000000000e01,
        2.61799387799e00,
        3.45000000000e00,
        -4.09999999999e-01,
        1.60000000000e00,
        0.00000000000e00,
        1.18700888200e09,
        1.01791427671e-07,
        1.01791427689e-07,
        8.96883449508e-08,
        2.32204133549e00,
        1.04213847237e-01,
        3.12695677565e-03,
        2.69412953826e-03,
        2.04240222976e-01,
        4.09349000642e-01,
        5.63911212310e-05,
        2.42285325663e-05,
    ]

    assert np.savetxt.call_args.args[0] == "Errors_ET_test_SNR8.0.txt"
    assert np.allclose(np.savetxt.call_args.args[1], data)

    assert np.savetxt.call_args.kwargs == {
        "delimiter": " ",
        "header": header,
        "comments": "",
    }
```

With this test code ready as a "safety net", we can move on to
the refactoring.

## `analyzeFisherErrors` refactored

I refactored the function as follows:

```python
def sky_localization_area(,
`
    network_fisher_inverse: np.ndarray,
    declination_angle: np.ndarray,
    right_ascension_index: int,
    declination_index: int,
) -> float:
    """
    Compute the 1-sigma sky localization ellipse area starting
    from the full network Fisher matrix inverse and the inclination.
    """
    return (
        np.pi
        * np.abs(np.cos(declination_angle))
        * np.sqrt(
            network_fisher_inverse[right_ascension_index, right_ascension_index]
            * network_fisher_inverse[declination_index, declination_index]
            - network_fisher_inverse[right_ascension_index, declination_index] ** 2
        )
    )


def compute_fisher_errors(
    network: det.Network,
    parameter_values: pd.DataFrame,
    fisher_parameters: list[str],
    sub_network_ids: list[int],
) -> tuple[np.ndarray, np.ndarray, Optional[np.ndarray]]:
    """
    Compute Fisher matrix errors for a network whose
    SNR and Fisher matrices have already been calculated.

    Will only return output for the n_above_thr signals
    for which the network SNR is above network.detection_SNR[1].

    Returns:
    network_snr: array with shape (n_above_thr,)
        Network SNR for the detected signals.
    parameter_errors: array with shape (n_above_thr, n_parameters)
        One-sigma Fisher errors for the parameters.
    sky_localization: array with shape (n_above_thr,) or None
        One-sigma sky localization area in steradians,
        returned if the signals have both right ascension and declination,
        None otherwise.
    """

    n_params = len(fisher_parameters)
    n_signals = len(parameter_values)

    assert n_params > 0
    assert n_signals > 0

    signals_havesky = False
    if ("ra" in fisher_parameters) and ("dec" in fisher_parameters):
        signals_havesky = True
        i_ra = fisher_parameters.index("ra")
        i_dec = fisher_parameters.index("dec")

    detector_snr_thr, network_snr_thr = network.detection_SNR

    parameter_errors = np.zeros((n_signals, n_params))
    if signals_havesky:
        sky_localization = np.zeros((n_signals,))
    network_snr = np.zeros((n_signals,))

    detectors = [network.detectors[d] for d in sub_network_ids]

    network_snr = np.sqrt(sum((detector.SNR**2 for detector in detectors)))

    for k in range(n_signals):
        network_fisher_matrix = np.zeros((n_params, n_params))

        for detector in detectors:
            if detector.SNR[k] > detector_snr_thr:
                network_fisher_matrix += detector.fisher_matrix[k, :, :]

        network_fisher_inverse = invertSVD(network_fisher_matrix)
        parameter_errors[k, :] = np.sqrt(np.diagonal(network_fisher_inverse))

        if signals_havesky:
            sky_localization[k] = sky_localization_area(,
            `
                network_fisher_inverse, parameter_values["dec"].iloc[k], i_ra, i_dec
            )

    detected = np.where(network_snr > network_snr_thr)[0]

    if signals_havesky:
        return (
            network_snr[detected],
            parameter_errors[detected, :],
            sky_localization[detected],
        )

    return network_snr[detected], parameter_errors[detected, :], None


def output_to_txt_file(
    parameter_values: pd.DataFrame,
    network_snr: np.ndarray,
    parameter_errors: np.ndarray,
    sky_localization: Optional[np.ndarray],
    fisher_parameters: list[str],
    filename: str,
) -> None:

    delim = " "
    header = (
        "network_SNR "
        + delim.join(parameter_values.keys())
        + " "
        + delim.join(["err_" + x for x in fisher_parameters])
    )
    save_data = np.c_[network_snr, parameter_values, parameter_errors]
    if sky_localization is not None:
        header += " err_sky_location"
        save_data = np.c_[save_data, sky_localization]

    row_format = "%s " + " ".join(["%.3E" for _ in range(save_data.shape[1] - 1)])

    np.savetxt(
        filename + ".txt",
        save_data,
        delimiter=" ",
        header=header,
        comments="",
        fmt=row_format,
    )


def errors_file_name(
    network: det.Network, sub_network_ids: list[int], population_name: str
) -> str:

    sub_network = "_".join([network.detectors[k].name for k in sub_network_ids])

    return (
        "Errors_"
        + sub_network
        + "_"
        + population_name
        + "_SNR"
        + str(network.detection_SNR[1])
    )


def analyze_and_save_to_txt(
    network: det.Network,
    parameter_values: pd.DataFrame,
    fisher_parameters: list[str],
    sub_network_ids_list: list[list[int]],
    population_name: str,
) -> None:

    for sub_network_ids in sub_network_ids_list:

        network_snr, errors, sky_localization = compute_fisher_errors(
            network=network,
            parameter_values=parameter_values,
            fisher_parameters=fisher_parameters,
            sub_network_ids=sub_network_ids,
        )

        filename = errors_file_name(
            network=network,
            sub_network_ids=sub_network_ids,
            population_name=population_name,
        )

        output_to_txt_file(
            parameter_values=parameter_values,
            network_snr=network_snr,
            parameter_errors=errors,
            sky_localization=sky_localization,
            fisher_parameters=fisher_parameters,
            filename=filename,
        )
```

A summary of the changes made is as follows.

- The functionality of `analyzeFisherErrors` was split into five:
    `compute_fisher_errors`, `sky_localization_area`,
    `output_to_txt`, `errors_file_name`, `analyze_and_save_to_txt`.
    These all contain logically distinct sections of the code, which 
    we may desire to modify independently of each other.
- The `compute_fisher_errors` function now only considers one 
    subnetwork, and the looping over subnetworks is relegated to the 
    higher-level function `analyze_and_save_to_txt`.
- The check for `npar>0` which nested the whole function by one 
    layer was changed to an `assert` statement at the beginning of
    the function --- if the number of parameters is less than zero
    the whole function call is invalid, and something has gone wrong.
- A few computations were happening in different places, such as 
    detector selection (evaluating `network.detectors[d]`) or a check 
    that the network SNR was greater than a threshold value. 
    They were unified.
- The computation of `newtorkSNR` was compacted.

The resulting code is still not perfect, of course. 
For one, too many parameters are being passed amongst these functions. 
This makes them coupled, long, complex.

However, it is now straightforward to use the `compute_fisher_errors` 
function within a script, if we do not need to output to a file.
Also, it is equally straightforward to make a function analogous to
`analyze_and_save_to_txt` but which saves to a format different from
`txt`.

A way to ameliorate this issue will entail modifying more than just 
`analyzeFisherErrors`. Probably, the most convenient approach will be to 
restructure the classes in the whole package,
probably with one representing the whole population analyzed: 
the functions in the refactored code are all working on the same data
(a table of parameter values, a list of which parameters to consider
for the Fisher analysis, a table of Fisher errors etc.).
