using DICE
using JuMP
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

dice = vanilla_2013R();
solve(dice.model)

@test getvalue(dice.UTILITY) == 2690.2447324365826
