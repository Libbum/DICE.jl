<h1 align="center">DICE.jl</h1>

<div align="center">
    <a href="https://libbum.github.io/DICE.jl/dev">
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
- v2013R (Rocky Road Version)
- v2016R Beta
- v2016R2

**In testing phase**
- DICE-CJL

**Planned**
- v2016R3
-  van der Ploeg safe carbon budget

Suggestions and additions welcomed.

## Usage

Prerequisites for using this package are [JuMP](https://github.com/JuliaOpt/JuMP.jl) and a NLP solver.

We use [Ipopt](https://projects.coin-or.org/Ipopt) here, but it's possible to use one of your choice.
If you don't have these packages on your system, they will be installed when you add this package.

The current packaged version of Ipopt is 3.12.10, however if you use a rolling-release OS like Arch Linux, the [coin-or-ipopt](https://aur.archlinux.org/packages/coin-or-ipopt/) package will keep your system updated to the latest release (currently 3.13.0).
This package is tested against 3.12.10, 3.12.13 and 3.13.0, so feel free to use any of these.

To use the non-packaged (more recent) version, add the following to your `~/.julia/config/startup.jl` file (create one if it doesn't exist)

```julia
ENV["JULIA_IPOPT_LIBRARY_PATH"] = "/usr/lib"
ENV["JULIA_IPOPT_EXECUTABLE_PATH"] = "/usr/bin"
```

This is what Arch uses, other distributions may use a different path&mdash;so it would be useful to check `which ipopt` to verify the correct path here.

If you've already built Ipopt.jl with the bundled version, simply build it again once your environment is set

```shell
julia> import Pkg; Pkg.build("Ipopt")
```

### Linear Solver

By default, Ipopt comes packaged with the MUMPS linear solver.
DICE.jl will always work with this solver and we will make every effort to get it to function over all scenarios.
However, there is an unknown issue when working with this solver requiring us to use some specific modifications that make many pre-defined scenarios quite brittle.
The problem is tracked in [issue #34](https://github.com/Libbum/DICE.jl/issues/34), which you can read about in detail there.
In addition, MUMPS is not so efficient compared to many other solvers.

Because of this, DICE.jl now attempts to use the HSL MA97 solver by default, for which you can [obtain an academic license](www.hsl.rl.ac.uk/ipopt/) for free.
If this solver is not found on your machine, MUMPS will be the fallback.
Additionally, providing the `linear_solver` option to the `DICE.solve` command allows you to set any linear solver your system has available.
Note that DICE.jl is only tested against MUMPS and MA97 for the time being.

If you are using Arch Linux, I have two package builds available to get you up and running with a functioning Ipopt/HSL system.

- [coin-or-coinhsl](https://github.com/Libbum/Arch/blob/master/coin-or-coinhsl/PKGBUILD) (You must provide the coinhsl-2015.06.23.tar.gz file since it is licensed)
- [coin-or-ipopt](https://github.com/Libbum/Arch/blob/master/coin-or-ipopt/PKGBUILD) (Technically the same as the AUR version, but with HSL linked)

For other Linux distributions, please take a look at the above package builds and the [Ipopt installation guide](https://coin-or.github.io/Ipopt/INSTALL.html) for details on how to get your system working.

---

Detailed instructions of setting up other solvers on your machine can be viewed in the [JuMP Documentation](http://www.juliaopt.org/JuMP.jl/0.18/installation.html).
Exactly how solvers other than Ipopt perform with DICE.jl is unknown.
Please file an issue if you need a specific solver to function and it doesn't.

### Notebooks

Self contained notebooks can be found in a separate [DICE.jl-notebooks](https://github.com/Libbum/DICE.jl-notebooks) repository that run default instances of each model, plot the major results and compare the output with original source data (where available).

The best way to use these is to run a notebook server from a cloned copy of this repository:

```bash
$ git clone git@github.com:Libbum/DICE.jl-notebooks.git
$ cd DICE.jl-notebooks
$ julia
julia> ]
(v1.1) pkg> activate .
(DICE.jl-notebooks) pkg> instantiate
(DICE.jl-notebooks) pkg> precompile
$ jupyter lab
```

and follow the generated link to your browser.
The final command can also be `jupyter notebook` if you don't have `lab` installed.
This process is only needed once.
After that you can just run the `jupyter lab` command in the `DICE.jl-notebooks` directory.

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
ipopt = JuMP.optimizer_with_attributes(Ipopt.Optimizer, "print_level"=>0) #Don't print output when optimising solution
lin_solve = ma27; # Use the HSL ma27 linear solver rather than the defalt ma97. This will default to MUMPS if HSL is not on your machine.
dice = solve(BasePrice, version, config = conf, optimizer = ipopt, linear_solver = lin_solve);

r = dice.results;
plot(r.years,r.scc,ylabel="\$ (trillion)",xlabel="Years",title="SCC",legend=false)
```

yielding the estimated global cost of carbon emissions out to 2300 without an optimal carbon price

```

                                                       SCC
                    ┌─────────────────────────────────────────────────────────────────────────┐
                400 │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠖⠉⠉⠉⠦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠎⠀⠀⠀⠀⠀⠀⢱⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡴⠁⠀⠀⠀⠀⠀⠀⠀⠀⢇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡜⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
   $ (trillion)     │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠜⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢱⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠜⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
                    │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠔⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
                    │⠀⠀⠀⠀⠀⠀⠀⠀⢀⠔⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
                    │⠀⠀⠀⠀⠀⠀⣠⠒⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
                    │⠀⠀⢀⣠⠔⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
                  0 │⠀⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
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
