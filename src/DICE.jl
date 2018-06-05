module DICE

using JuMP;
#Ipopt is distributed under the EPL.
#We don't package it here though, and assume you have this set up on your system already.
using Ipopt;

include("2013RVanilla.jl")
include("2013RRockyRoad.jl")

export vanilla_2013R, vanilla_2013R_options,
       rockyroad_2013R, rockyroad_2013R_options, rr_scenarios

end
