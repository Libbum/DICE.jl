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
- v2016R2 (see [this](https://github.com/Libbum/DICE.jl/issues/4) issue)
- DICE-CJL

**Planned**
-  van der Ploeg safe carbon budget

Suggestions and additions welcomed.

## Usage

Prerequisites for using this package are [JuMP](https://github.com/JuliaOpt/JuMP.jl) and a NLP solver.

We use [Ipopt](https://projects.coin-or.org/Ipopt) here, but it's possible to use one of your choice.
If you don't have these packages on your system, they will be installed when you add this package.

The current recommendation however, is to use the latest version of the Ipopt solver (at time of writing: 3.12.13).
If you use a rolling-release OS like Arch Linux, the [coin-or-ipopt](https://aur.archlinux.org/packages/coin-or-ipopt/) package will keep your system updated.
Then, add the following to your `~/.julia/config/startup.jl` file (create one if it doesn't exist)

```julia
ENV["JULIA_IPOPT_LIBRARY_PATH"] = "/usr/lib"
ENV["JULIA_IPOPT_EXECUTABLE_PATH"] = "/usr/bin"
```

Other distributions may use a different path, so it would be useful to check `which ipopt` to verify the correct path here.

If you've already built Ipopt.jl with the bundled version, simply build it again once your environment is set

```shell
julia> import Pkg; Pkg.build("Ipopt")
```

---

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
All notebooks are stored in a previously executed state, with all outputs rendered.

### Module

Using the module gives your greater control over the inputs of the system, and ultimately allows you to compare different versions of the model with the same input data (if possible and permitted).

Create a new project and install the DICE module. For the moment it is not in METADATA, so add it via the repository directly:

```shell
$ cd /path/to/projects/
$ julia
julia> ]
(v1.1) pkg> generate MyProject
julia> ;
shell> cd MyProject
(v1.1) pkg> activate .
(MyProject) pkg> add https://github.com/Libbum/DICE.jl
```

The simplest of files to run the default solution looks like this:

```julia
using DICE;

dice = solve(OptimalPrice, v2013R());
dice.results.UTILITY
```

A more fleshed out example, enabling you to alter the configuration is also simple enough:

```julia
using DICE;
import JuMP;
using Ipopt;
using Plots;
unicodeplots()

version = v2013R(); #Vanilla flavour
conf = options(version, limμ = 1.1); #Alter the upper limit on the control rate after 2150
ipopt = JuMP.with_optimizer(Ipopt.Optimizer, print_level=0) #Don't print output when optimising solution
dice = solve(BasePrice, version, config = conf, optimizer = ipopt);

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
