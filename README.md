<h1 align="center">DICE.jl</h1>

<div align="center">
    <a href="https://libbum.github.io/DICE.jl/latest">
        <img src="https://img.shields.io/badge/docs-latest-blue.svg" alt="Documentation" />
    </a>
    │
    <a href="https://travis-ci.org/Libbum/DICE.jl">
        <img src="https://travis-ci.org/Libbum/DICE.jl.svg?branch=master" alt="Travis-ci" />
    </a>
    │
    <a href="https://codecov.io/gh/Libbum/DICE.jl">
        <img src="https://codecov.io/gh/Libbum/DICE.jl/branch/master/graph/badge.svg" alt="Codecov" />
    </a>
    |
    <a href="https://app.fossa.io/projects/git%2Bgithub.com%2FLibbum%2FDICE.jl?ref=badge_shield">
        <img src="https://app.fossa.io/api/projects/git%2Bgithub.com%2FLibbum%2FDICE.jl.svg?type=shield" alt="FOSSA Status" />
    </a>
</div>
<br />

The [Dynamic Integrated model of Climate and the Economy](https://sites.google.com/site/williamdnordhaus/dice-rice) (DICE) model family are a popular and capable type of simple Integrated Assessment Model (IAM) of climate-change economics pioneered by William Nordhaus: the Sterling Professor of Economics at Yale University.

Economists, financiers and chemical engineers seem to love using the [GAMS](https://www.gams.com/) IDE to solve their optimisation problems, and as such DICE runs either in GAMS or Excel, so long as one purchases an expensive NLP solver on top of the initial (arguably already too expensive) price of the parent software.
Since there are a number of perfectly capable open source non-linear solvers in existence, this repository holds various DICE implementations that require no money down to operate.

## Models

**Implemented**
- v2013R (Vanilla Version)
- v2016R Beta

**In testing phase**
- v2013R (Rocky Road Version)

- DICE-CJL

**Planned**
- v2016R2 (see [this](https://github.com/Libbum/DICE.jl/issues/4) issue)
-  van der Ploeg safe carbon budget

Suggestions and additions welcomed.

## A note on Julia versions

For anyone interested in this tool and has not used Julia before, you'll need a bit of additional information before you start.
Julia 1.0 has only recently been released, and as such the community is in the process of porting code from the older version 0.64.
This task, for the most part, is fairly trivial and has mostly been completed.
One important package (JuMP) however has been implementing fundamental changes in its architecture, and the Julia 1.0 release has therefore came at quite an awkward time.
JuMP's next release is now estimated to be about a month away (time of writing Dec 13 2018).
For now, there are still teething problems with the current master branch, meaning DICE.jl [has not yet transitioned](https://github.com/Libbum/DICE.jl/pull/16) to the latest version, and therefore does not run on Julia 1.0 just yet.

Please install [version 0.64](https://julialang.org/downloads/oldreleases.html) for the moment.
This issue will be rectified as soon as possible.

## Usage

Prerequisites for using this package are [JuMP](https://github.com/JuliaOpt/JuMP.jl) and a NLP solver.
We use [Ipopt](https://projects.coin-or.org/Ipopt) here, but it's possible to use one of your choice.
If you don't have these packages on your system, they will be installed when you add this package.
Detailed instructions of setting up other solvers on your machine can be viewed in the [JuMP Documentation](http://www.juliaopt.org/JuMP.jl/0.18/installation.html).

### Notebooks

Self contained notebooks can be found in a separate [DICE.jl-notebooks](https://github.com/Libbum/DICE.jl-notebooks) repository that run default instances of each model, plot the major results and compare the output with original source data (where available).

The best way to use these is to run a notebook server from a cloned copy of this repository:

```shell
$ git clone git@github.com:Libbum/DICE.jl-notebooks.git
$ cd DICE.jl-notebooks
$ jupyter notebook
```

and follow the generated link to your browser.
If you don't need to interact with the notebook and are just curious about the output then github renders notebooks natively.
You can just click on them and read through the output.
All notebooks are stored in a previously executed state, whith all outputs rendered.

### Module

Using the module gives your greater control over the inputs of the system, and ultimately allows you to compare different versions of the model with the same input data (if possible and permitted).

First, install the module via

```julia
Pkg.clone("git://github.com/Libbum/DICE.jl.git")
```

The simplest of files to run the default solution looks like this:

```julia
using DICE;

dice = solve(OptimalPrice, v2013R());
dice.results.UTILITY
```

A more fleshed out example, enabling you to alter the configuration is also simple enough:

```julia
using Ipopt;
using DICE;
using Plots;
unicodeplots()

version = v2013R(); #Vanilla flavour
conf = options(version, limμ = 1.1); #Alter the upper limit on the control rate after 2150
ipopt = IpoptSolver(print_level=0)); #Don't print output when optimising solution
dice = solve(BasePrice, version, config = conf, solver = ipopt);

r = dice.results;
plot(r.years,r.scc,ylabel="\$ (trillion)",xlabel="Years",title="SCC",legend=false)
```

yielding the estimated global cost of carbon emissions out to 2300 without an optimal carbon price

```

                                                       SCC
                    ┌─────────────────────────────────────────────────────────────────────────┐
                400 │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠖⠉⠉⠉⠦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ │
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠎⠀⠀⠀⠀⠀⠀⢱⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ │
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡴⠁⠀⠀⠀⠀⠀⠀⠀⠀⢇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ │
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡜⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ │
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ │
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ │
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ │
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ │
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ │
   $ (trillion)     │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ │
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ │
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠜⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ │
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢱⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ │
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠜⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ │
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ │
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠔⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ │
                    │⠀⠀⠀⠀⠀⠀⠀⠀⢀⠔⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ │
                    │⠀⠀⠀⠀⠀⠀⣠⠒⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ │
                    │⠀⠀⢀⣠⠔⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ │
                  0 │⠀⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ │
                    └─────────────────────────────────────────────────────────────────────────┘
                    2000                                                                   2400
                                                      Years
```

## License

The code herein is distributed under the MIT license, so feel free to distribute it as you will under its terms.
The solver listed in the source is [Ipopt](https://projects.coin-or.org/Ipopt): the codebase of which is under EPL.
As we do not include the solver in this repository, there is no need to distribute this license here. EPL is compatible with MIT for this use case (GPL for instance is not).
One is welcomed to use an alternate solver to suit their needs as the [JuMP](https://github.com/JuliaOpt/JuMP.jl) framework integrates with [several](http://www.juliaopt.org/JuMP.jl/0.18/installation.html#getting-solvers).
Please remain aware of the licensing restrictions for each, as many license choices in this domain are incompatible.


[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2FLibbum%2FDICE.jl.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2FLibbum%2FDICE.jl?ref=badge_large)
