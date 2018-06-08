module DICE

using JuMP;
#Ipopt is distributed under the EPL.
#We don't package it here though, and assume you have this set up on your system already.
using Ipopt;

#DICE Versions
abstract type Version end

#Scenarios
abstract type Scenario end
include("Scenarios.jl")

#Configuration options & parameters
abstract type Options end
abstract type Parameters end

#Model settings and output
abstract type Variables end
abstract type Equations end
abstract type Results end

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

function Base.show(io::IO, ::MIME"text/plain", model::DICENarrative)
    println(io, "$(model.scenario) scenario using $(model.version).")
    show(io, model.model)
end

function dice_solve end
function dice_options end

export dice_solve, dice_options

include("2013R.jl")
include("2016R.jl")

end
