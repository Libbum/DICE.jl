module DICE

using JuMP;
#Ipopt is distributed under the EPL.
#We don't package it here though, and assume you have this set up on your system already.
using Ipopt;

#DICE Versions
abstract type Version end

#Scenarios
abstract type Scenario end

#solve(OptimalPrice(), v2013R(RockyRoad())) for example
function solve(s::Scenario, v::Version)
    println("Solving $(s) scenario using $(v)...")
end

export solve

include("2013R.jl")
include("2016R.jl")
include("Scenarios.jl")

end
