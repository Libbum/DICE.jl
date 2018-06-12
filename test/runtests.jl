using DICE
using JuMP
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

#Vanilla utility
baserun = dice_solve(BasePrice, v2013R());
optimalrun = dice_solve(OptimalPrice, v2013R());

@test getvalue(baserun.variables.UTILITY) == 2670.2779245830334
@test getvalue(optimalrun.variables.UTILITY) == 2690.244712873159
