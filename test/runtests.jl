using DICE
using JuMP
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

dice = dice_solve(OptimalPrice, v2013R());

@test getvalue(dice.variables.UTILITY) == 2690.244712873159
