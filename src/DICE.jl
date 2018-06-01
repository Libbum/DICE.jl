module DICE

using JuMP;
#Ipopt is distributed under the EPL.
#We don't package it here though, and assume you have this set up on your system already.
using Ipopt;

include("2013RVanilla.jl")

export vanilla_2013R, vanilla_2013R_options

end
