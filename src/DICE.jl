module DICE

#Don't polute the namespace. We want to use `solve` ourselves.
import JuMP;
import JuMP: @variable, @constraint, @NLconstraint, @objective, @NLparameter;
import JuMP: getvalue, setvalue, getdual, setupperbound, setlowerbound;
#Ipopt is distributed under the EPL.
#We don't package it here though, and assume you have this set up on your system already.
using Ipopt;

#DICE Versions
abstract type Version end

#Configuration options & parameters
abstract type Options end
abstract type Parameters end

#Model settings and output
abstract type Variables end
abstract type Equations end
abstract type Results end

#Scenarios
abstract type Scenario end
include("Scenarios.jl")

struct DICENarrative
    constants::Options
    parameters::Parameters
    model::JuMP.Model
    scenario::Scenario
    version::Version
    variables::Variables
    equations::Equations
    results::Results
end

function Base.show(io::IO, ::MIME"text/plain", dice::DICENarrative)
    println(io, "$(dice.scenario) scenario using $(dice.version).")
    show(io, dice.model)
end

function solve end
function options end

export solve, options

include("2013R.jl")
include("2016R.jl")

end
