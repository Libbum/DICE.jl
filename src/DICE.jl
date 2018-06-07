module DICE

using JuMP;
#Ipopt is distributed under the EPL.
#We don't package it here though, and assume you have this set up on your system already.
using Ipopt;

#DICE Versions
abstract type Version end

#Scenarios
abstract type Scenario end

#solve(BasePrice, v2013R(RockyRoad)) for example
# Don't alias version (ie keep it as v2016R()) so as not to confuse
# v2013R (generic function with 2 methods)
function solve(s::Scenario, v::Version)
    println("Solving $(s) scenario using $(v)...")
end

export solve

include("2013R.jl")
include("2016R.jl")
include("Scenarios.jl")

end
