using DICE
using JuMP
using Ipopt
using Test

DICE.@base mutable struct TestType{T}
    one
    two::Int
    three::T
    four::Vector{T}
end

DICE.@extend mutable struct ExtendTest <: TestType
    five::T
end

#missing = @macroexpand DICE.@extend mutable struct missing <: Missing end

@testset "Abstractions" begin
    @test ExtendTest <: TestType

    etest = ExtendTest(10,10,10,[10],5)
    @test isa(etest, ExtendTest{Int})
    @test fieldnames(typeof(etest)) == (:one,:two,:three,:four,:five)
    @test isa(etest.one, Int)
    @test isa(etest.two, Int)
    @test isa(etest.three, Int)
    @test isa(etest.four, Vector{Int})
    @test isa(etest.five, Int)

 #   @test isa(missing.args..., ErrorException)
end

# The tests shouldn't need to converge for long times,
# so dump early and fail rather than wasting resouces on failure.
optimizer = with_optimizer(Ipopt.Optimizer, print_frequency_iter=500, max_iter=1000, sb="yes");
model = Model(optimizer);
modelrr = Model(optimizer);
model2016 = Model(optimizer);
model2016r2 = Model(optimizer);
modelcjl = Model(optimizer);
vanilla_opt = options(v2013R());
rr_opt = options(v2013R(RockyRoad));
v2016_opt = options(v2016R());
v2016r2_opt = options(v2016R2());
cjl_opt = options(vCJL());
vanilla_params = DICE.generate_parameters(vanilla_opt);
rr_params = DICE.generate_parameters(rr_opt, modelrr);
v2016_params = DICE.generate_parameters(v2016_opt, model2016);
v2016r2_params = DICE.generate_parameters(v2016r2_opt, model2016r2);
cjl_params = DICE.generate_parameters(cjl_opt);

@testset "Types Display" begin
    @testset "Flavour" begin
        @test sprint(show, Vanilla) == "Vanilla flavour"
        @test sprint(show, RockyRoad) == "Rocky Road flavour"
    end
    @testset "Version" begin
        @test sprint(show, v2013R()) == "v2013R (Vanilla flavour)"
        @test sprint(show, v2013R(RockyRoad)) == "v2013R (Rocky Road flavour)"
        @test sprint(show, v2016R()) == "v2016R beta"
        @test sprint(show, vCJL()) == "CJL"
    end
    @testset "Scenario" begin
        @test sprint(show, BasePrice) == "Base (current policy) carbon price"
        @test sprint(show, OptimalPrice) == "Optimal carbon price"
        @test sprint(show, Limit2Degrees) == "Limit warming to 2° with damages"
        @test sprint(show, Stern) == "Stern"
        @test sprint(show, SternCalibrated) == "Calibrated Stern"
        @test sprint(show, Copenhagen) == "Copenhagen participation"
    end
    @testset "Default Options and Parameters" begin
        @test sprint(show, "text/plain", vanilla_opt) == "Options for Vanilla 2013R version\nTime step\nN: 60, tstep: 5\nPreferences\nα: 1.45, ρ: 0.015\nPopulation and Technology\nγₑ: 0.3, pop₀: 6838, popadj: 0.134, popasym: 10500, δk: 0.1\nq₀: 63.69, k₀: 135.0, a₀: 3.8, ga₀: 0.079, δₐ: 0.006\nEmissions Parameters\ngσ₁: -0.01, δσ: -0.001, eland₀: 3.3\ndeland: 0.2, e₀: 33.61, μ₀: 0.039\nCarbon Cycle\nmat₀: 830.4, mu₀: 1527.0, ml₀: 10010.0\nmateq: 588.0, mueq: 1350.0, mleq: 10000.0\nFlow Parameters\nϕ₁₂: 0.088, ϕ₂₃: 0.0025\nClimate Model Parameters\nt2xco2: 2.9, fₑₓ0: 0.25, fₑₓ1: 0.7\ntocean₀: 0.0068, tatm₀: 0.8, ξ₁: 0.098\nξ₃: 0.088, ξ₄: 0.025, η: 3.8\nClimate Damage Parameters\nψ₁: 0.0, ψ₂: 0.00267, ψ₃: 2.0\nAbatement Cost\nθ₂: 2.8, pback: 344.0, gback: 0.025, limμ: 1.2\ntnopol: 45.0, cprice₀: 1.0, gcprice: 0.02\nParticipation Parameters\nperiodfullpart: 21.0, partfract2010: 1.0, partfractfull: 1.0\nFossil Fuel Availability\nfosslim: 6000.0\nScaling Parameters\nscale1: 0.016408662, scale2: -3855.106895"
        @test sprint(show, "text/plain", rr_opt) == "Options for Rocky Road 2013R version\nTime step\nN: 60, tstep: 5\nPreferences\nα: 1.45, ρ: 0.015\nPopulation and Technology\nγₑ: 0.3, pop₀: 6838, popadj: 0.134, popasym: 10500, δk: 0.1\nq₀: 63.69, k₀: 135.0, a₀: 3.8, ga₀: 0.079, δₐ: 0.006\nEmissions Parameters\ngσ₁: -0.01, δσ: -0.001, eland₀: 3.3\ndeland: 0.2, e₀: 33.61, μ₀: 0.039\nCarbon Cycle\nmat₀: 830.4, mu₀: 1527.0, ml₀: 10010.0\nmateq: 588.0, mueq: 1350.0, mleq: 10000.0\nFlow Parameters\nϕ₁₂: 0.088, ϕ₂₃: 0.0025\nClimate Model Parameters\nt2xco2: 2.9, fₑₓ0: 0.25, fₑₓ1: 0.7\ntocean₀: 0.0068, tatm₀: 0.8, ξ₁₀: 0.098, ξ₁β: 0.01243\nξ₁: 0.098, ξ₃: 0.088, ξ₄: 0.025, η: 3.8\nClimate Damage Parameters\nψ₁₀: 0.0, ψ₂₀: 0.00267, ψ₁: 0.0, ψ₂: 0.0, ψ₃: 2.0\nAbatement Cost\nθ₂: 2.8, pback: 344.0, gback: 0.025, limμ: 1.2\ntnopol: 45.0, cprice₀: 1.0, gcprice: 0.02\nParticipation Parameters\nperiodfullpart: 21.0, partfract2010: 1.0, partfractfull: 1.0\nFossil Fuel Availability\nfosslim: 6000.0\nScaling Parameters\nscale1: 0.016408662, scale2: -3855.106895"
        @test sprint(show, "text/plain", v2016_opt) == "Options for 2016R beta version\nTime step\nN: 100, tstep: 5\nPreferences\nα: 1.45, ρ: 0.015\nPopulation and Technology\nγₑ: 0.3, pop₀: 7403, popadj: 0.134, popasym: 11500, δk: 0.1\nq₀: 105.5, k₀: 223.0, a₀: 5.115, ga₀: 0.076, δₐ: 0.005\nEmissions Parameters\ngσ₁: -0.0152, δσ: -0.001, eland₀: 2.6\ndeland: 0.115, e₀: 35.85, μ₀: 0.03\nCarbon Cycle\nmat₀: 851.0, mu₀: 460.0, ml₀: 1740.0\nmateq: 588.0, mueq: 360.0, mleq: 1720.0\nFlow Parameters\nϕ₁₂: 0.12, ϕ₂₃: 0.007\nClimate Model Parameters\nt2xco2: 3.1, fₑₓ0: 0.5, fₑₓ1: 1.0\ntocean₀: 0.0068, tatm₀: 0.85, ξ₁: 0.1005\nξ₃: 0.088, ξ₄: 0.025, η: 3.6813\nClimate Damage Parameters\nψ₁₀: 0.0, ψ₁: 0.0, ψ₂: 0.00236, ψ₃: 2.0\nAbatement Cost\nθ₂: 2.6, pback: 550.0, gback: 0.025, limμ: 1.2\ntnopol: 45.0, cprice₀: 2.0, gcprice: 0.02\nFossil Fuel Availability\nfosslim: 6000.0\nScaling Parameters\nscale1: 0.0302455265681763, scale2: -10993.704"
        @test sprint(show, "text/plain", cjl_opt) == "Options for DICE-CJL\nN: 600\nPreferences\nα: 2.0, ρ: 0.015\nPopulation and Technology\nγₑ: 0.3, pop₀: 6514, popadj: 0.035, popasym: 8600, δk: 0.1\nq₀: 61.1, k₀: 137.0, a₀: 0.02722, ga₀: 0.092, δₐ: 0.001\nEmissions Parameters\nσ₀: 0.13418, gσ₁: -0.0073, δσ: 0.003, δσ₂: 0.0, eland₀: 1.1\nCarbon Cycle\nmat₀: 808.9, mu₀: 1255.0, ml₀: 18365.0\nmateq: 587.473, mueq: 1143.894, mleq: 18340.0\nFlow Parameters\nϕ₁₂: 0.0189288, ϕ₂₃: 0.005\nClimate Model Parameters\nt2xco2: 3.0, fₑₓ0: -0.06, fₑₓ1: 0.3\ntocean₀: 0.0068, tatm₀: 0.7307, ξ₁: 0.022\nξ₃: 0.3, ξ₄: 0.005, η: 3.8\nClimate Damage Parameters\nψ₁: 0.0, ψ₂: 0.0028388, ψ₃: 2.0\nAbatement Cost\nθ₂: 2.8, pback: 1.17, gback: 0.005, backrat: 2.0, limμ: 1.0\nFossil Fuel Availability\nfosslim: 6000.0\nScaling Parameters\nscale1: 194.0, scale2: 381800.0\nEmissions control\npartfract1: 1.0, partfract2: 1.0, partfract21: 1.0, dpartfract: 0.0"
    end
end

#Use same limits for RR case for simplicity
μ_ubound = [if t < 30 1.0 else vanilla_opt.limμ*vanilla_params.partfract[t] end for t in 1:vanilla_opt.N];
vanilla_vars = DICE.model_vars(v2013R(), model, vanilla_opt.N, vanilla_opt.fosslim, μ_ubound, vanilla_params.cpricebase);
rr_vars = DICE.model_vars(v2013R(RockyRoad), modelrr, vanilla_opt.N, vanilla_opt.fosslim, μ_ubound, fill(Inf, vanilla_opt.N));

vanilla_eqs = DICE.model_eqs(OptimalPrice, model, vanilla_opt, vanilla_params, vanilla_vars);
rr_eqs = DICE.model_eqs(OptimalPrice, modelrr, rr_opt, rr_params, rr_vars);

v2016_vars = DICE.model_vars(v2016R(), model2016, v2016_opt.N, v2016_opt.fosslim, [if t < 30 1.0 else v2016_opt.limμ end for t in 1:v2016_opt.N], fill(Inf, v2016_opt.N));
v2016_eqs = DICE.model_eqs(OptimalPrice, model2016, v2016_opt, v2016_params, v2016_vars);
v2016r2_vars = DICE.model_vars(v2016R2(), model2016r2, v2016r2_opt.N, v2016r2_opt.fosslim, [if t < 30 1.0 else v2016r2_opt.limμ end for t in 1:v2016r2_opt.N], fill(Inf, v2016r2_opt.N));
v2016r2_eqs = DICE.model_eqs(OptimalPrice, model2016r2, v2016r2_opt, v2016r2_params, v2016r2_vars);
@testset "Model Construction" begin
    @testset "Variables" begin
        @test typeof(vanilla_vars) <: DICE.VariablesV2013
        @test typeof(rr_vars) <: DICE.VariablesV2013
        @test supertype(typeof(vanilla_vars)) == supertype(typeof(rr_vars))
        @test typeof(v2016_vars) <: DICE.VariablesV2016
        @test all(x->supertype(typeof(x)) <: DICE.Variables, [vanilla_vars,rr_vars,v2016_vars])
    end
    @testset "Equations" begin
        @test typeof(vanilla_eqs) <: DICE.VanillaEquations
        @test typeof(rr_eqs) <: DICE.RockyRoadEquations
        @test supertype(typeof(vanilla_eqs)) == supertype(typeof(rr_eqs))
        @test typeof(v2016_eqs) <: DICE.EquationsV2016
        @test all(x->supertype(typeof(x)) <: DICE.Equations, [vanilla_eqs,rr_eqs,v2016_eqs])
    end
    @testset "Scenarios" begin
        @testset "2013R (Vanilla)" begin
            @test DICE.assign_scenario(BasePrice, vanilla_opt, vanilla_params) == vanilla_params.cpricebase
            @test DICE.assign_scenario(OptimalPrice, vanilla_opt, vanilla_params) ==fill(Inf, vanilla_opt.N)
        end
        @testset "2013R (Rocky Road)" begin
            DICE.assign_scenario(BasePrice, modelrr, rr_opt, rr_params, rr_vars);
            @test all(x->isfinite.(JuMP.upper_bound.(rr_vars.CPRICE)[x]), 1:Int(rr_opt.tnopol))
            DICE.assign_scenario(OptimalPrice, modelrr, rr_opt, rr_params, rr_vars);
            @test JuMP.upper_bound(rr_vars.μ[1]) == rr_opt.μ₀
            DICE.assign_scenario(Limit2Degrees, modelrr, rr_opt, rr_params, rr_vars);
            @test JuMP.upper_bound(rr_vars.Tₐₜ[2]) ≈ 2.0
            DICE.scenario_alterations(Stern, rr_opt, rr_params);
            @test rr_opt.α ≈ 1.01
            DICE.scenario_alterations(SternCalibrated, rr_opt, rr_params);
            @test rr_opt.α ≈ 2.1
            DICE.scenario_alterations(Copenhagen, rr_opt, rr_params);
            @test rr_params.partfract[2] ≈ 0.390423082
        end
        @testset "2016R beta" begin
            DICE.assign_scenario(BasePrice, model2016, v2016_opt, v2016_params, v2016_vars);
            @test all(x->JuMP.has_upper_bound.(v2016_vars.CPRICE)[x], 1:Int(v2016_opt.tnopol))
            DICE.assign_scenario(OptimalPrice, model2016, v2016_opt, v2016_params, v2016_vars);
            @test JuMP.fix_value(v2016_vars.μ[1]) == v2016_opt.μ₀
        end
        @testset "2016R2" begin
            DICE.assign_scenario(BasePrice, model2016r2, v2016r2_opt, v2016r2_params, v2016r2_vars);
            @test all(x->JuMP.has_upper_bound.(v2016r2_vars.CPRICE)[x], 1:Int(v2016r2_opt.tnopol))
            DICE.assign_scenario(OptimalPrice, model2016r2, v2016r2_opt, v2016r2_params, v2016r2_vars);
            @test JuMP.fix_value(v2016r2_vars.μ[1]) == v2016r2_opt.μ₀
        end
    end
    @testset "Invalid Scenarios" begin
        @test_throws ErrorException DICE.solve(Limit2Degrees, v2013R())
        @test_throws ErrorException DICE.solve(Stern, v2013R())
        @test_throws ErrorException DICE.solve(SternCalibrated, v2013R())
        @test_throws ErrorException DICE.solve(Copenhagen, v2013R())
        @test_throws ErrorException DICE.solve(Limit2Degrees, v2016R())
        @test_throws ErrorException DICE.solve(Stern, v2016R())
        @test_throws ErrorException DICE.solve(SternCalibrated, v2016R())
        @test_throws ErrorException DICE.solve(Copenhagen, v2016R())
    end
end

# Optimisation tests.
# Utility values here are generated by GAMS output from original source files, solved via CONOPT.
@info "Base Price Scenario with v2013R(Vanilla)"
base = DICE.solve(BasePrice, v2013R(), optimizer = optimizer);
#Tracking issues with some results in Libbum/DICE.jl#21
@testset "Utility" begin
    @testset "2013R (Vanilla)" begin
        @test base.results.UTILITY ≈ 2668.2118865871 atol=1e-4
        @info "Optimal Price Scenario with v2013R(Vanilla)"
        result = DICE.solve(OptimalPrice, v2013R(), optimizer = optimizer);
        @test result.results.UTILITY ≈ 2689.1761542629 atol=1e-4
    end
    @testset "2013R (RockyRoad)" begin
        # Slightly better utility than CONOPT found here.
        @info "Base Price Scenario with v2013R(RockyRoad)"
        result = DICE.solve(BasePrice, v2013R(RockyRoad), optimizer = optimizer);
        @test result.results.UTILITY ≈ 2669.8017192359343 atol=1e-4
        @info "Optimal Price Scenario with v2013R(RockyRoad)"
        result = DICE.solve(OptimalPrice, v2013R(RockyRoad), optimizer = optimizer);
        @test result.results.UTILITY ≈ 2741.2318406380 atol=1e-4
        # Slightly better utility than CONOPT found here.
        @info "Limit 2 Degrees Scenario with v2013R(RockyRoad)"
        result = DICE.solve(Limit2Degrees, v2013R(RockyRoad), optimizer = optimizer);
        @test result.results.UTILITY ≈ 2696.8586446996173 atol=1e-4
        @info "Stern Scenario with v2013R(RockyRoad)"
        result = DICE.solve(Stern, v2013R(RockyRoad), optimizer = optimizer);
        @test result.results.UTILITY ≈ 124305.6025535197 atol=1e-4
        @info "Stern Calibrated Scenario with v2013R(RockyRoad)"
        result = DICE.solve(SternCalibrated, v2013R(RockyRoad), optimizer = optimizer);
        @test result.results.UTILITY ≈ -8469.005859988243 atol=1e-4
        @info "Copenhagen Scenario with v2013R(RockyRoad)"
        result = DICE.solve(Copenhagen, v2013R(RockyRoad), optimizer = optimizer);
        # The value is lower here because GAMS results truncate a lot,
        # giving us a slightly lower utility due to the inverse relationship of cprice and mu
        @test result.results.UTILITY ≈ 2724.1458144691937 atol=1e-4
    end
    @testset "2016R beta" begin
        @info "Base Price Scenario with v2016R"
        result = DICE.solve(BasePrice, v2016R(), optimizer = optimizer);
        @test result.results.UTILITY ≈ 4485.7434565264 atol=1e-4
        @info "Optimal Price Scenario with v2016R"
        result = DICE.solve(OptimalPrice, v2016R(), optimizer = optimizer);
        @test result.results.UTILITY ≈ 4517.3146811528 atol=1e-4
    end
    @testset "2016R2" begin
        # Slightly better utility than CONOPT found here.
        @info "Base Price Scenario with v2016R2"
        result = DICE.solve(BasePrice, v2016R2(), optimizer = optimizer);
        @test result.results.UTILITY ≈ 4489.233548950728 atol=1e-4
        # This has an infinite spool on Travis.
        if get(ENV, "TRAVIS", "false") == "false"
            # Slightly better utility than CONOPT found here.
            @info "Optimal Price Scenario with v2016R2"
            result = DICE.solve(OptimalPrice, v2016R2(), optimizer = optimizer);
            @test result.results.UTILITY ≈ 4518.039198804694 atol=1e-4
        end
    end
end

#Show model
@testset "Display" begin
    @test sprint(show, "text/plain", base) == "Base (current policy) carbon price scenario using v2013R (Vanilla flavour).\nA JuMP Model\nMaximization problem with:\nVariables: 1561\nObjective function type: VariableRef\n`GenericAffExpr{Float64,VariableRef}`-in-`MathOptInterface.EqualTo{Float64}`: 656 constraints\n`GenericQuadExpr{Float64,VariableRef}`-in-`MathOptInterface.EqualTo{Float64}`: 240 constraints\n`VariableRef`-in-`MathOptInterface.EqualTo{Float64}`: 15 constraints\n`VariableRef`-in-`MathOptInterface.GreaterThan{Float64}`: 716 constraints\n`VariableRef`-in-`MathOptInterface.LessThan{Float64}`: 298 constraints\nNonlinear: 539 constraints\nModel mode: AUTOMATIC\nCachingOptimizer state: ATTACHED_OPTIMIZER\nSolver name: Ipopt\nNames registered in the model: C, CCA, CEMUTOTPER, CPC, CPRICE, DAMAGES, E, Eind, FORC, I, K, MCABATE, Mᵤₚ, Mₐₜ, Mₗₒ, PERIODU, RI, S, Tₐₜ, Tₗₒ, UTILITY, Y, YGROSS, YNET, Λ, Ω, μ"
end
