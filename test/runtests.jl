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
        @test sprint(show, "text/plain", vanilla_params) == "Calculated Parameters for Vanilla 2013R\nOptimal savings rate: 0.2582781456953642\nCarbon cycle transition matrix coefficients\nϕ₁₁: 0.912, ϕ₂₁: 0.03832888888888889, ϕ₂₂: 0.9591711111111112, ϕ₃₂: 0.0003375, ϕ₃₃: 0.9996625\n2010 Carbon intensity: 0.5491283628802297\nClimate model parameter: 1.3103448275862069\nBackstop price: \n[344.0, 335.4, 327.015, 318.84, 310.869, 303.097, 295.519, 288.132, 280.928, 273.905  …  97.0039, 94.5788, 92.2143, 89.909, 87.6613, 85.4697, 83.333, 81.2497, 79.2184, 77.238]\nGrowth rate of productivity: [0.079, 0.0766652, 0.0743994, 0.0722006, 0.0700667, 0.0679959, 0.0659863, 0.0640362, 0.0621436, 0.060307  …  0.0176273, 0.0171063, 0.0166007, 0.0161101, 0.015634, 0.0151719, 0.0147235, 0.0142884, 0.0138661, 0.0134563]\nEmissions from deforestation: [3.3, 2.64, 2.112, 1.6896, 1.35168, 1.08134, 0.865075, 0.69206, 0.553648, 0.442919  …  4.70992e-5, 3.76793e-5, 3.01435e-5, 2.41148e-5, 1.92918e-5, 1.54335e-5, 1.23468e-5, 9.87741e-6, 7.90193e-6, 6.32154e-6]\nAvg utility social discout rate: [1.0, 0.92826, 0.861667, 0.799852, 0.74247, 0.689206, 0.639762, 0.593866, 0.551262, 0.511715  …  0.0241818, 0.022447, 0.0208367, 0.0193419, 0.0179543, 0.0166663, 0.0154706, 0.0143608, 0.0133305, 0.0123742]\nBase case carbon price: [1.0, 1.10408, 1.21899, 1.34587, 1.48595, 1.64061, 1.81136, 1.99989, 2.20804, 2.43785  …  141.268, 155.971, 172.205, 190.128, 209.916, 231.765, 255.887, 282.52, 311.925, 344.39]\nPopulation and labour: [6838.0, 7242.49, 7612.06, 7947.31, 8249.55, 8520.56, 8762.43, 8977.44, 9167.89, 9336.08  …  10496.6, 10497.1, 10497.5, 10497.8, 10498.1, 10498.4, 10498.6, 10498.8, 10498.9, 10499.1]\nTotal factor productivity: [3.8, 4.12595, 4.46853, 4.82771, 5.2034, 5.59545, 6.00368, 6.42783, 6.8676, 7.32266  …  31.9603, 32.5337, 33.1, 33.6587, 34.2098, 34.7532, 35.2886, 35.8159, 36.3351, 36.846]\nΔσ: [-0.01, -0.0099501, -0.00990045, -0.00985105, -0.00980189, -0.00975298, -0.00970431, -0.00965589, -0.0096077, -0.00955976  …  -0.00778703, -0.00774818, -0.00770951, -0.00767104, -0.00763276, -0.00759468, -0.00755678, -0.00751907, -0.00748155, -0.00744422]\nσ: [0.549128, 0.522347, 0.496996, 0.472992, 0.45026, 0.428725, 0.408319, 0.38898, 0.370647, 0.353262  …  0.0597958, 0.0575124, 0.0553269, 0.0532348, 0.0512316, 0.0493133, 0.0474758, 0.0457154, 0.0440286, 0.0424121]\nθ₁: [0.0674643, 0.0625697, 0.0580447, 0.0538603, 0.0499898, 0.046409, 0.0430951, 0.0400277, 0.0371875, 0.0345572  …  0.00207158, 0.00194266, 0.00182212, 0.00170939, 0.00160394, 0.00150528, 0.00141296, 0.00132656, 0.00124567, 0.00116994]\nExogenious forcing: [0.25, 0.275, 0.3, 0.325, 0.35, 0.375, 0.4, 0.425, 0.45, 0.475  …  0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7]\nFraction of emissions in control regieme: [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0  …  1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]"
        @test sprint(show, "text/plain", rr_params) == "Calculated Parameters for Rocky Road 2013R\nOptimal savings rate: 0.2582781456953642\nCarbon cycle transition matrix coefficients\nϕ₁₁: 0.912, ϕ₂₁: 0.03832888888888889, ϕ₂₂: 0.9591711111111112, ϕ₃₂: 0.0003375, ϕ₃₃: 0.9996625\n2010 Carbon intensity: 0.5491283628802297\nClimate model parameter: 1.3103448275862069\nTransient TSC Correction: 0.098\nBackstop price: \n[344.0, 335.4, 327.015, 318.84, 310.869, 303.097, 295.519, 288.132, 280.928, 273.905  …  97.0039, 94.5788, 92.2143, 89.909, 87.6613, 85.4697, 83.333, 81.2497, 79.2184, 77.238]\nGrowth rate of productivity: [0.079, 0.0766652, 0.0743994, 0.0722006, 0.0700667, 0.0679959, 0.0659863, 0.0640362, 0.0621436, 0.060307  …  0.0176273, 0.0171063, 0.0166007, 0.0161101, 0.015634, 0.0151719, 0.0147235, 0.0142884, 0.0138661, 0.0134563]\nEmissions from deforestation: [3.3, 2.64, 2.112, 1.6896, 1.35168, 1.08134, 0.865075, 0.69206, 0.553648, 0.442919  …  4.70992e-5, 3.76793e-5, 3.01435e-5, 2.41148e-5, 1.92918e-5, 1.54335e-5, 1.23468e-5, 9.87741e-6, 7.90193e-6, 6.32154e-6]\nAvg utility social discout rate: [1.0, 0.92826, 0.861667, 0.799852, 0.74247, 0.689206, 0.639762, 0.593866, 0.551262, 0.511715  …  0.0241818, 0.022447, 0.0208367, 0.0193419, 0.0179543, 0.0166663, 0.0154706, 0.0143608, 0.0133305, 0.0123742]\nBase case carbon price: [1.0, 1.10408, 1.21899, 1.34587, 1.48595, 1.64061, 1.81136, 1.99989, 2.20804, 2.43785  …  141.268, 155.971, 172.205, 190.128, 209.916, 231.765, 255.887, 282.52, 311.925, 344.39]\nPopulation and labour: [6838.0, 7242.49, 7612.06, 7947.31, 8249.55, 8520.56, 8762.43, 8977.44, 9167.89, 9336.08  …  10496.6, 10497.1, 10497.5, 10497.8, 10498.1, 10498.4, 10498.6, 10498.8, 10498.9, 10499.1]\nTotal factor productivity: [3.8, 4.12595, 4.46853, 4.82771, 5.2034, 5.59545, 6.00368, 6.42783, 6.8676, 7.32266  …  31.9603, 32.5337, 33.1, 33.6587, 34.2098, 34.7532, 35.2886, 35.8159, 36.3351, 36.846]\nΔσ: [-0.01, -0.0099501, -0.00990045, -0.00985105, -0.00980189, -0.00975298, -0.00970431, -0.00965589, -0.0096077, -0.00955976  …  -0.00778703, -0.00774818, -0.00770951, -0.00767104, -0.00763276, -0.00759468, -0.00755678, -0.00751907, -0.00748155, -0.00744422]\nσ: [0.549128, 0.522347, 0.496996, 0.472992, 0.45026, 0.428725, 0.408319, 0.38898, 0.370647, 0.353262  …  0.0597958, 0.0575124, 0.0553269, 0.0532348, 0.0512316, 0.0493133, 0.0474758, 0.0457154, 0.0440286, 0.0424121]\nθ₁: [0.0674643, 0.0625697, 0.0580447, 0.0538603, 0.0499898, 0.046409, 0.0430951, 0.0400277, 0.0371875, 0.0345572  …  0.00207158, 0.00194266, 0.00182212, 0.00170939, 0.00160394, 0.00150528, 0.00141296, 0.00132656, 0.00124567, 0.00116994]\nExogenious forcing: [0.25, 0.275, 0.3, 0.325, 0.35, 0.375, 0.4, 0.425, 0.45, 0.475  …  0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7]\nFraction of emissions in control regieme: [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0  …  1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]"
        @test sprint(show, "text/plain", v2016r2_params) == "Calculated Parameters for 2016 versions.\nOptimal savings rate: 0.2582781456953642\nCarbon cycle transition matrix coefficients\nϕ₁₁: 0.88, ϕ₂₁: 0.196, ϕ₂₂: 0.797, ϕ₃₂: 0.0014651162790697675, ϕ₃₃: 0.9985348837209302\n2015 Carbon intensity: 0.35032002736111795\nClimate model parameter: 1.187516129032258\nBackstop price: \n[550.0, 536.25, 522.844, 509.773, 497.028, 484.603, 472.488, 460.675, 449.158, 437.93  …  56.335, 54.9266, 53.5534, 52.2146, 50.9092, 49.6365, 48.3956, 47.1857, 46.0061, 44.8559]\nGrowth rate of productivity: [0.076, 0.0741236, 0.0722934, 0.0705085, 0.0687676, 0.0670698, 0.0654138, 0.0637987, 0.0622235, 0.0606872  …  0.00801034, 0.00781257, 0.00761967, 0.00743154, 0.00724806, 0.0070691, 0.00689456, 0.00672434, 0.00655831, 0.00639639]\nEmissions from deforestation: [2.6, 2.301, 2.03639, 1.8022, 1.59495, 1.41153, 1.2492, 1.10554, 0.978407, 0.86589  …  4.36383e-5, 3.86199e-5, 3.41786e-5, 3.02481e-5, 2.67695e-5, 2.3691e-5, 2.09666e-5, 1.85554e-5, 1.64215e-5, 1.45331e-5]\nAvg utility social discout rate: [1.0, 0.92826, 0.861667, 0.799852, 0.74247, 0.689206, 0.639762, 0.593866, 0.551262, 0.511715  …  0.00123107, 0.00114275, 0.00106077, 0.000984669, 0.000914029, 0.000848457, 0.000787589, 0.000731088, 0.00067864, 0.000629954]\nBase case carbon price: [2.0, 2.20816, 2.43799, 2.69174, 2.97189, 3.28121, 3.62272, 3.99978, 4.41608, 4.87571  …  14828.8, 16372.2, 18076.3, 19957.7, 22034.9, 24328.3, 26860.4, 29656.0, 32742.7, 36150.6]\nPopulation and labour: [7403.0, 7853.09, 8264.92, 8638.97, 8976.56, 9279.54, 9550.18, 9790.92, 10004.3, 10192.8  …  11500.0, 11500.0, 11500.0, 11500.0, 11500.0, 11500.0, 11500.0, 11500.0, 11500.0, 11500.0]\nTotal factor productivity: [5.115, 5.53571, 5.97889, 6.44481, 6.93369, 7.44572, 7.981, 8.53961, 9.12155, 9.72679  …  85.334, 86.0231, 86.7005, 87.3662, 88.0203, 88.6629, 89.2941, 89.9141, 90.5228, 91.1204]\nΔσ: [-0.0152, -0.0151242, -0.0150487, -0.0149736, -0.0148989, -0.0148245, -0.0147506, -0.0146769, -0.0146037, -0.0145308  …  -0.00968977, -0.00964141, -0.0095933, -0.00954543, -0.0094978, -0.00945041, -0.00940325, -0.00935633, -0.00930964, -0.00926318]\nσ: [0.35032, 0.324682, 0.301035, 0.279215, 0.259074, 0.240476, 0.223296, 0.20742, 0.192744, 0.179171  …  0.00140155, 0.00133527, 0.00127243, 0.00121283, 0.00115631, 0.00110268, 0.00105179, 0.00100348, 0.000957617, 0.000914064]\ncumtree: [100.0, 103.546, 106.684, 109.462, 111.92, 114.095, 116.02, 117.724, 119.232, 120.566  …  130.835, 130.835, 130.835, 130.835, 130.835, 130.835, 130.835, 130.835, 130.835, 130.835]\nθ₁: [0.0741062, 0.0669657, 0.0605362, 0.0547447, 0.0495259, 0.0448213, 0.0405787, 0.0367512, 0.0332971, 0.0301786  …  3.03679e-5, 2.82084e-5, 2.62088e-5, 2.43568e-5, 2.26411e-5, 2.10512e-5, 1.95776e-5, 1.82115e-5, 1.69447e-5, 1.57697e-5]\nExogenious forcing: [0.5, 0.529412, 0.558824, 0.588235, 0.617647, 0.647059, 0.676471, 0.705882, 0.735294, 0.764706  …  1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]"
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
# Utility values here are generated by GAMS output from original source files, solved via CONOPT unlsee otherwise stated.
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
        @info "Base Price Scenario with v2016R2"
        result = DICE.solve(BasePrice, v2016R2(), optimizer = optimizer);
        @test result.results.UTILITY ≈ 4485.6767040826 atol=1e-4
        # This has an infinite spool on Travis.
        #if get(ENV, "TRAVIS", "false") == "false"
            @info "Optimal Price Scenario with v2016R2"
            result = DICE.solve(OptimalPrice, v2016R2(), optimizer = optimizer);
            @test result.results.UTILITY ≈ 4515.8311036492 atol=1e-4
        #end
    end
end

#Show model
@testset "Display" begin
    @test sprint(show, "text/plain", base) == "Base (current policy) carbon price scenario using v2013R (Vanilla flavour).\nA JuMP Model\nMaximization problem with:\nVariables: 1561\nObjective function type: VariableRef\n`GenericAffExpr{Float64,VariableRef}`-in-`MathOptInterface.EqualTo{Float64}`: 656 constraints\n`GenericQuadExpr{Float64,VariableRef}`-in-`MathOptInterface.EqualTo{Float64}`: 240 constraints\n`VariableRef`-in-`MathOptInterface.EqualTo{Float64}`: 15 constraints\n`VariableRef`-in-`MathOptInterface.GreaterThan{Float64}`: 716 constraints\n`VariableRef`-in-`MathOptInterface.LessThan{Float64}`: 298 constraints\nNonlinear: 539 constraints\nModel mode: AUTOMATIC\nCachingOptimizer state: ATTACHED_OPTIMIZER\nSolver name: Ipopt\nNames registered in the model: C, CCA, CEMUTOTPER, CPC, CPRICE, DAMAGES, E, Eind, FORC, I, K, MCABATE, Mᵤₚ, Mₐₜ, Mₗₒ, PERIODU, RI, S, Tₐₜ, Tₗₒ, UTILITY, Y, YGROSS, YNET, Λ, Ω, μ"
end
