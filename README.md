# DICE.jl

The [Dynamic Integrated model of Climate and the Economy](https://sites.google.com/site/williamdnordhaus/dice-rice) (DICE) model family are a popular and capable Integrated Assessment Model (IAM) of climate-change economics pioneered by William Nordhaus: the Sterling Professor of Economics at Yale University.

Economists, financiers and chemical engineers seem to love using the [GAMS](https://www.gams.com/) IDE to solve their optimisation problems, and as such DICE runs either in GAMS or Excel, so long as one purchases an expensive NLP solver on top of the initial (arguably already too expensive) price of the parent software.
Since there are a number of perfectly capable open source non-linear solvers in existence, this repository holds various DICE implementations that require no money down to operate.

## Models

For now, the Vanilla 2013R version is the only one residing here, more are on their way.

## License

The code herein is distributed under the MIT license, so feel free to distribute it as you will under its terms.
The solver listed in the source is [Ipopt](https://projects.coin-or.org/Ipopt): the codebase of which is under EPL.
As we do not include the solver in this repository, there is no need to distribute this license here. EPL is compatible with MIT for this use case (GPL for instance is not).
One is welcomed to use an alternate solver to suit their needs as the [JuMP](https://github.com/JuliaOpt/JuMP.jl) framework integrates with [several](http://www.juliaopt.org/JuMP.jl/0.18/installation.html#getting-solvers).
Please remain aware of the licensing restrictions for each, as many license choices in this domain are incompatible.
