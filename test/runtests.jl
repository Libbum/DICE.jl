using DICE
using JuMP
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end


@testset "Invalid Vanilla Scenarios" begin
    @test_throws MethodError dice_solve(Limit2Degrees, v2013R())
    @test_throws MethodError dice_solve(Stern, v2013R())
    @test_throws MethodError dice_solve(SternCalibrated, v2013R())
    @test_throws MethodError dice_solve(Copenhagen, v2013R())
end;
# Optimisation tests.
# Currently, for some unknown reason, we cannot solve these
# tests in the travis environment. They become unfeaseable or
# hit some type of resource limit.
if get(ENV, "TRAVIS", "false") == "false"
    @testset "Utility" begin
        @testset "Vanilla" begin
            baserun = dice_solve(BasePrice, v2013R());
            optimalrun = dice_solve(OptimalPrice, v2013R());

            @test getvalue(baserun.variables.UTILITY) ≈ 2670.2779245830334
            @test getvalue(optimalrun.variables.UTILITY) ≈ 2690.244712873159
        end
    end
end
