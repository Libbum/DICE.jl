using DICE
import JuMP
using Ipopt

@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

model = JuMP.Model();
modelrr = JuMP.Model();
model2016 = JuMP.Model();
vanilla_opt = options(v2013R());
rr_opt = options(v2013R(RockyRoad));
v2016_opt = options(v2016R());
vanilla_params = DICE.generate_parameters(vanilla_opt);
rr_params = DICE.generate_parameters(rr_opt, modelrr);
v2016_params = DICE.generate_parameters(v2016_opt, model2016);

@testset "Types Display" begin
    @testset "Flavour" begin
        @test sprint(show, Vanilla) == "Vanilla flavour"
        @test sprint(show, RockyRoad) == "Rocky Road flavour"
    end
    @testset "Version" begin
        @test sprint(show, v2013R()) == "v2013R (Vanilla flavour)"
        @test sprint(show, v2013R(RockyRoad)) == "v2013R (Rocky Road flavour)"
        @test sprint(show, v2016R()) == "v2016R beta"
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
        @test sprint(show, "text/plain", vanilla_params) == "Calculated Parameters for Vanilla 2013R\nOptimal savings rate: 0.2582781456953642\nCarbon cycle transition matrix coefficients\nϕ₁₁: 0.912, ϕ₂₁: 0.03832888888888889, ϕ₂₂: 0.9591711111111112, ϕ₃₂: 0.0003375, ϕ₃₃: 0.9996625\n2010 Carbon intensity: 0.5491283628802297\nClimate model parameter: 1.3103448275862069\nBackstop price: [344.0, 335.4, 327.015, 318.84, 310.869, 303.097, 295.519, 288.132, 280.928, 273.905, 267.057, 260.381, 253.871, 247.525, 241.337, 235.303, 229.421, 223.685, 218.093, 212.641, 207.325, 202.141, 197.088, 192.161, 187.357, 182.673, 178.106, 173.653, 169.312, 165.079, 160.952, 156.928, 153.005, 149.18, 145.451, 141.814, 138.269, 134.812, 131.442, 128.156, 124.952, 121.828, 118.782, 115.813, 112.918, 110.095, 107.342, 104.659, 102.042, 99.4912, 97.0039, 94.5788, 92.2143, 89.909, 87.6613, 85.4697, 83.333, 81.2497, 79.2184, 77.238]\nGrowth rate of productivity: [0.079, 0.0766652, 0.0743994, 0.0722006, 0.0700667, 0.0679959, 0.0659863, 0.0640362, 0.0621436, 0.060307, 0.0585246, 0.056795, 0.0551164, 0.0534875, 0.0519067, 0.0503726, 0.0488839, 0.0474392, 0.0460371, 0.0446765, 0.0433561, 0.0420748, 0.0408313, 0.0396245, 0.0384534, 0.037317, 0.0362141, 0.0351438, 0.0341051, 0.0330972, 0.032119, 0.0311697, 0.0302485, 0.0293546, 0.028487, 0.0276451, 0.026828, 0.0260352, 0.0252657, 0.024519, 0.0237943, 0.0230911, 0.0224087, 0.0217464, 0.0211037, 0.02048, 0.0198747, 0.0192873, 0.0187173, 0.0181641, 0.0176273, 0.0171063, 0.0166007, 0.0161101, 0.015634, 0.0151719, 0.0147235, 0.0142884, 0.0138661, 0.0134563]\nEmissions from deforestation: [3.3, 2.64, 2.112, 1.6896, 1.35168, 1.08134, 0.865075, 0.69206, 0.553648, 0.442919, 0.354335, 0.283468, 0.226774, 0.181419, 0.145136, 0.116108, 0.0928867, 0.0743094, 0.0594475, 0.047558, 0.0380464, 0.0304371, 0.0243497, 0.0194798, 0.0155838, 0.012467, 0.00997364, 0.00797891, 0.00638313, 0.0051065, 0.0040852, 0.00326816, 0.00261453, 0.00209162, 0.0016733, 0.00133864, 0.00107091, 0.000856729, 0.000685383, 0.000548307, 0.000438645, 0.000350916, 0.000280733, 0.000224586, 0.000179669, 0.000143735, 0.000114988, 9.19906e-5, 7.35925e-5, 5.8874e-5, 4.70992e-5, 3.76793e-5, 3.01435e-5, 2.41148e-5, 1.92918e-5, 1.54335e-5, 1.23468e-5, 9.87741e-6, 7.90193e-6, 6.32154e-6]\nAvg utility social discout rate: [1.0, 0.92826, 0.861667, 0.799852, 0.74247, 0.689206, 0.639762, 0.593866, 0.551262, 0.511715, 0.475005, 0.440928, 0.409296, 0.379933, 0.352677, 0.327376, 0.30389, 0.282089, 0.261852, 0.243067, 0.225629, 0.209443, 0.194417, 0.18047, 0.167523, 0.155505, 0.144349, 0.133994, 0.124381, 0.115458, 0.107175, 0.0994863, 0.0923492, 0.0857241, 0.0795743, 0.0738657, 0.0685666, 0.0636476, 0.0590816, 0.0548431, 0.0509086, 0.0472565, 0.0438663, 0.0407194, 0.0377982, 0.0350865, 0.0325694, 0.0302329, 0.028064, 0.0260507, 0.0241818, 0.022447, 0.0208367, 0.0193419, 0.0179543, 0.0166663, 0.0154706, 0.0143608, 0.0133305, 0.0123742]\nBase case carbon price: [1.0, 1.10408, 1.21899, 1.34587, 1.48595, 1.64061, 1.81136, 1.99989, 2.20804, 2.43785, 2.69159, 2.97173, 3.28103, 3.62252, 3.99956, 4.41584, 4.87544, 5.38288, 5.94313, 6.5617, 7.24465, 7.99867, 8.83118, 9.75034, 10.7652, 11.8856, 13.1227, 14.4885, 15.9965, 17.6614, 19.4996, 21.5291, 23.7699, 26.2439, 28.9754, 31.9912, 35.3208, 38.9971, 43.0559, 47.5372, 52.4849, 57.9476, 63.9788, 70.6378, 77.9898, 86.107, 95.0691, 104.964, 115.889, 127.951, 141.268, 155.971, 172.205, 190.128, 209.916, 231.765, 255.887, 282.52, 311.925, 344.39]\nPopulation and labour: [6838.0, 7242.49, 7612.06, 7947.31, 8249.55, 8520.56, 8762.43, 8977.44, 9167.89, 9336.08, 9484.22, 9614.42, 9728.61, 9828.59, 9916.01, 9992.34, 10058.9, 10116.9, 10167.4, 10211.4, 10249.6, 10282.8, 10311.6, 10336.7, 10358.4, 10377.3, 10393.6, 10407.8, 10420.1, 10430.8, 10440.0, 10448.1, 10455.0, 10461.0, 10466.2, 10470.8, 10474.7, 10478.1, 10481.0, 10483.5, 10485.7, 10487.7, 10489.3, 10490.7, 10492.0, 10493.1, 10494.0, 10494.8, 10495.5, 10496.1, 10496.6, 10497.1, 10497.5, 10497.8, 10498.1, 10498.4, 10498.6, 10498.8, 10498.9, 10499.1]\nTotal factor productivity: [3.8, 4.12595, 4.46853, 4.82771, 5.2034, 5.59545, 6.00368, 6.42783, 6.8676, 7.32266, 7.79261, 8.27702, 8.77542, 9.2873, 9.81212, 10.3493, 10.8983, 11.4584, 12.0291, 12.6096, 13.1993, 13.7975, 14.4035, 15.0167, 15.6362, 16.2616, 16.8919, 17.5266, 18.165, 18.8064, 19.4502, 20.0956, 20.7421, 21.3891, 22.036, 22.6821, 23.327, 23.9701, 24.6108, 25.2487, 25.8834, 26.5143, 27.141, 27.7631, 28.3803, 28.9921, 29.5983, 30.1985, 30.7924, 31.3797, 31.9603, 32.5337, 33.1, 33.6587, 34.2098, 34.7532, 35.2886, 35.8159, 36.3351, 36.846]\nΔσ: [-0.01, -0.0099501, -0.00990045, -0.00985105, -0.00980189, -0.00975298, -0.00970431, -0.00965589, -0.0096077, -0.00955976, -0.00951206, -0.00946459, -0.00941736, -0.00937037, -0.00932361, -0.00927709, -0.00923079, -0.00918473, -0.0091389, -0.0090933, -0.00904792, -0.00900277, -0.00895785, -0.00891315, -0.00886867, -0.00882442, -0.00878038, -0.00873657, -0.00869297, -0.0086496, -0.00860643, -0.00856349, -0.00852076, -0.00847824, -0.00843593, -0.00839384, -0.00835195, -0.00831027, -0.00826881, -0.00822754, -0.00818649, -0.00814564, -0.00810499, -0.00806455, -0.0080243, -0.00798426, -0.00794442, -0.00790478, -0.00786533, -0.00782609, -0.00778703, -0.00774818, -0.00770951, -0.00767104, -0.00763276, -0.00759468, -0.00755678, -0.00751907, -0.00748155, -0.00744422]\nσ: [0.549128, 0.522347, 0.496996, 0.472992, 0.45026, 0.428725, 0.408319, 0.38898, 0.370647, 0.353262, 0.336774, 0.321132, 0.306289, 0.292201, 0.278827, 0.266126, 0.254064, 0.242604, 0.231715, 0.221365, 0.211526, 0.20217, 0.193271, 0.184806, 0.176751, 0.169084, 0.161786, 0.154837, 0.148219, 0.141914, 0.135908, 0.130183, 0.124727, 0.119525, 0.114564, 0.109832, 0.105318, 0.10101, 0.0968992, 0.0929747, 0.0892276, 0.085649, 0.0822307, 0.078965, 0.0758442, 0.0728615, 0.07001, 0.0672836, 0.0646762, 0.062182, 0.0597958, 0.0575124, 0.0553269, 0.0532348, 0.0512316, 0.0493133, 0.0474758, 0.0457154, 0.0440286, 0.0424121]\nθ₁: [0.0674643, 0.0625697, 0.0580447, 0.0538603, 0.0499898, 0.046409, 0.0430951, 0.0400277, 0.0371875, 0.0345572, 0.0321207, 0.0298631, 0.0277707, 0.025831, 0.0240325, 0.0223644, 0.020817, 0.0193811, 0.0180484, 0.0168112, 0.0156623, 0.0145953, 0.0136041, 0.012683, 0.0118269, 0.0110311, 0.0102911, 0.00960283, 0.00896257, 0.00836683, 0.00781237, 0.00729624, 0.00681566, 0.00636811, 0.0059512, 0.00556277, 0.00520078, 0.00486337, 0.00454879, 0.00425545, 0.00398184, 0.00372659, 0.00348842, 0.00326613, 0.00305862, 0.00286488, 0.00268394, 0.00251493, 0.00235704, 0.00220949, 0.00207158, 0.00194266, 0.00182212, 0.00170939, 0.00160394, 0.00150528, 0.00141296, 0.00132656, 0.00124567, 0.00116994]\nExogenious forcing: [0.25, 0.275, 0.3, 0.325, 0.35, 0.375, 0.4, 0.425, 0.45, 0.475, 0.5, 0.525, 0.55, 0.575, 0.6, 0.625, 0.65, 0.675, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45]\nFraction of emissions in control regieme: [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]"
        @test sprint(show, "text/plain", rr_params) == "Calculated Parameters for Rocky Road 2013R\nOptimal savings rate: 0.2582781456953642\nCarbon cycle transition matrix coefficients\nϕ₁₁: 0.912, ϕ₂₁: 0.03832888888888889, ϕ₂₂: 0.9591711111111112, ϕ₃₂: 0.0003375, ϕ₃₃: 0.9996625\n2010 Carbon intensity: 0.5491283628802297\nClimate model parameter: 1.3103448275862069\nTransient TSC Correction: 0.098\nBackstop price: [344.0, 335.4, 327.015, 318.84, 310.869, 303.097, 295.519, 288.132, 280.928, 273.905, 267.057, 260.381, 253.871, 247.525, 241.337, 235.303, 229.421, 223.685, 218.093, 212.641, 207.325, 202.141, 197.088, 192.161, 187.357, 182.673, 178.106, 173.653, 169.312, 165.079, 160.952, 156.928, 153.005, 149.18, 145.451, 141.814, 138.269, 134.812, 131.442, 128.156, 124.952, 121.828, 118.782, 115.813, 112.918, 110.095, 107.342, 104.659, 102.042, 99.4912, 97.0039, 94.5788, 92.2143, 89.909, 87.6613, 85.4697, 83.333, 81.2497, 79.2184, 77.238]\nGrowth rate of productivity: [0.079, 0.0766652, 0.0743994, 0.0722006, 0.0700667, 0.0679959, 0.0659863, 0.0640362, 0.0621436, 0.060307, 0.0585246, 0.056795, 0.0551164, 0.0534875, 0.0519067, 0.0503726, 0.0488839, 0.0474392, 0.0460371, 0.0446765, 0.0433561, 0.0420748, 0.0408313, 0.0396245, 0.0384534, 0.037317, 0.0362141, 0.0351438, 0.0341051, 0.0330972, 0.032119, 0.0311697, 0.0302485, 0.0293546, 0.028487, 0.0276451, 0.026828, 0.0260352, 0.0252657, 0.024519, 0.0237943, 0.0230911, 0.0224087, 0.0217464, 0.0211037, 0.02048, 0.0198747, 0.0192873, 0.0187173, 0.0181641, 0.0176273, 0.0171063, 0.0166007, 0.0161101, 0.015634, 0.0151719, 0.0147235, 0.0142884, 0.0138661, 0.0134563]\nEmissions from deforestation: [3.3, 2.64, 2.112, 1.6896, 1.35168, 1.08134, 0.865075, 0.69206, 0.553648, 0.442919, 0.354335, 0.283468, 0.226774, 0.181419, 0.145136, 0.116108, 0.0928867, 0.0743094, 0.0594475, 0.047558, 0.0380464, 0.0304371, 0.0243497, 0.0194798, 0.0155838, 0.012467, 0.00997364, 0.00797891, 0.00638313, 0.0051065, 0.0040852, 0.00326816, 0.00261453, 0.00209162, 0.0016733, 0.00133864, 0.00107091, 0.000856729, 0.000685383, 0.000548307, 0.000438645, 0.000350916, 0.000280733, 0.000224586, 0.000179669, 0.000143735, 0.000114988, 9.19906e-5, 7.35925e-5, 5.8874e-5, 4.70992e-5, 3.76793e-5, 3.01435e-5, 2.41148e-5, 1.92918e-5, 1.54335e-5, 1.23468e-5, 9.87741e-6, 7.90193e-6, 6.32154e-6]\nAvg utility social discout rate: [1.0, 0.92826, 0.861667, 0.799852, 0.74247, 0.689206, 0.639762, 0.593866, 0.551262, 0.511715, 0.475005, 0.440928, 0.409296, 0.379933, 0.352677, 0.327376, 0.30389, 0.282089, 0.261852, 0.243067, 0.225629, 0.209443, 0.194417, 0.18047, 0.167523, 0.155505, 0.144349, 0.133994, 0.124381, 0.115458, 0.107175, 0.0994863, 0.0923492, 0.0857241, 0.0795743, 0.0738657, 0.0685666, 0.0636476, 0.0590816, 0.0548431, 0.0509086, 0.0472565, 0.0438663, 0.0407194, 0.0377982, 0.0350865, 0.0325694, 0.0302329, 0.028064, 0.0260507, 0.0241818, 0.022447, 0.0208367, 0.0193419, 0.0179543, 0.0166663, 0.0154706, 0.0143608, 0.0133305, 0.0123742]\nBase case carbon price: [1.0, 1.10408, 1.21899, 1.34587, 1.48595, 1.64061, 1.81136, 1.99989, 2.20804, 2.43785, 2.69159, 2.97173, 3.28103, 3.62252, 3.99956, 4.41584, 4.87544, 5.38288, 5.94313, 6.5617, 7.24465, 7.99867, 8.83118, 9.75034, 10.7652, 11.8856, 13.1227, 14.4885, 15.9965, 17.6614, 19.4996, 21.5291, 23.7699, 26.2439, 28.9754, 31.9912, 35.3208, 38.9971, 43.0559, 47.5372, 52.4849, 57.9476, 63.9788, 70.6378, 77.9898, 86.107, 95.0691, 104.964, 115.889, 127.951, 141.268, 155.971, 172.205, 190.128, 209.916, 231.765, 255.887, 282.52, 311.925, 344.39]\nPopulation and labour: [6838.0, 7242.49, 7612.06, 7947.31, 8249.55, 8520.56, 8762.43, 8977.44, 9167.89, 9336.08, 9484.22, 9614.42, 9728.61, 9828.59, 9916.01, 9992.34, 10058.9, 10116.9, 10167.4, 10211.4, 10249.6, 10282.8, 10311.6, 10336.7, 10358.4, 10377.3, 10393.6, 10407.8, 10420.1, 10430.8, 10440.0, 10448.1, 10455.0, 10461.0, 10466.2, 10470.8, 10474.7, 10478.1, 10481.0, 10483.5, 10485.7, 10487.7, 10489.3, 10490.7, 10492.0, 10493.1, 10494.0, 10494.8, 10495.5, 10496.1, 10496.6, 10497.1, 10497.5, 10497.8, 10498.1, 10498.4, 10498.6, 10498.8, 10498.9, 10499.1]\nTotal factor productivity: [3.8, 4.12595, 4.46853, 4.82771, 5.2034, 5.59545, 6.00368, 6.42783, 6.8676, 7.32266, 7.79261, 8.27702, 8.77542, 9.2873, 9.81212, 10.3493, 10.8983, 11.4584, 12.0291, 12.6096, 13.1993, 13.7975, 14.4035, 15.0167, 15.6362, 16.2616, 16.8919, 17.5266, 18.165, 18.8064, 19.4502, 20.0956, 20.7421, 21.3891, 22.036, 22.6821, 23.327, 23.9701, 24.6108, 25.2487, 25.8834, 26.5143, 27.141, 27.7631, 28.3803, 28.9921, 29.5983, 30.1985, 30.7924, 31.3797, 31.9603, 32.5337, 33.1, 33.6587, 34.2098, 34.7532, 35.2886, 35.8159, 36.3351, 36.846]\nΔσ: [-0.01, -0.0099501, -0.00990045, -0.00985105, -0.00980189, -0.00975298, -0.00970431, -0.00965589, -0.0096077, -0.00955976, -0.00951206, -0.00946459, -0.00941736, -0.00937037, -0.00932361, -0.00927709, -0.00923079, -0.00918473, -0.0091389, -0.0090933, -0.00904792, -0.00900277, -0.00895785, -0.00891315, -0.00886867, -0.00882442, -0.00878038, -0.00873657, -0.00869297, -0.0086496, -0.00860643, -0.00856349, -0.00852076, -0.00847824, -0.00843593, -0.00839384, -0.00835195, -0.00831027, -0.00826881, -0.00822754, -0.00818649, -0.00814564, -0.00810499, -0.00806455, -0.0080243, -0.00798426, -0.00794442, -0.00790478, -0.00786533, -0.00782609, -0.00778703, -0.00774818, -0.00770951, -0.00767104, -0.00763276, -0.00759468, -0.00755678, -0.00751907, -0.00748155, -0.00744422]\nσ: [0.549128, 0.522347, 0.496996, 0.472992, 0.45026, 0.428725, 0.408319, 0.38898, 0.370647, 0.353262, 0.336774, 0.321132, 0.306289, 0.292201, 0.278827, 0.266126, 0.254064, 0.242604, 0.231715, 0.221365, 0.211526, 0.20217, 0.193271, 0.184806, 0.176751, 0.169084, 0.161786, 0.154837, 0.148219, 0.141914, 0.135908, 0.130183, 0.124727, 0.119525, 0.114564, 0.109832, 0.105318, 0.10101, 0.0968992, 0.0929747, 0.0892276, 0.085649, 0.0822307, 0.078965, 0.0758442, 0.0728615, 0.07001, 0.0672836, 0.0646762, 0.062182, 0.0597958, 0.0575124, 0.0553269, 0.0532348, 0.0512316, 0.0493133, 0.0474758, 0.0457154, 0.0440286, 0.0424121]\nθ₁: [0.0674643, 0.0625697, 0.0580447, 0.0538603, 0.0499898, 0.046409, 0.0430951, 0.0400277, 0.0371875, 0.0345572, 0.0321207, 0.0298631, 0.0277707, 0.025831, 0.0240325, 0.0223644, 0.020817, 0.0193811, 0.0180484, 0.0168112, 0.0156623, 0.0145953, 0.0136041, 0.012683, 0.0118269, 0.0110311, 0.0102911, 0.00960283, 0.00896257, 0.00836683, 0.00781237, 0.00729624, 0.00681566, 0.00636811, 0.0059512, 0.00556277, 0.00520078, 0.00486337, 0.00454879, 0.00425545, 0.00398184, 0.00372659, 0.00348842, 0.00326613, 0.00305862, 0.00286488, 0.00268394, 0.00251493, 0.00235704, 0.00220949, 0.00207158, 0.00194266, 0.00182212, 0.00170939, 0.00160394, 0.00150528, 0.00141296, 0.00132656, 0.00124567, 0.00116994]\nExogenious forcing: [0.25, 0.275, 0.3, 0.325, 0.35, 0.375, 0.4, 0.425, 0.45, 0.475, 0.5, 0.525, 0.55, 0.575, 0.6, 0.625, 0.65, 0.675, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45]\nFraction of emissions in control regieme: [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]"
        @test sprint(show, "text/plain", v2016_params) == "Calculated Parameters for 2016R beta\nOptimal savings rate: 0.2582781456953642\nCarbon cycle transition matrix coefficients\nϕ₁₁: 0.88, ϕ₂₁: 0.196, ϕ₂₂: 0.797, ϕ₃₂: 0.0014651162790697675, ϕ₃₃: 0.9985348837209302\n2015 Carbon intensity: 0.35032002736111795\nClimate model parameter: 1.187516129032258\nBackstop price: [550.0, 536.25, 522.844, 509.773, 497.028, 484.603, 472.488, 460.675, 449.158, 437.93, 426.981, 416.307, 405.899, 395.752, 385.858, 376.211, 366.806, 357.636, 348.695, 339.978, 331.478, 323.191, 315.111, 307.234, 299.553, 292.064, 284.762, 277.643, 270.702, 263.935, 257.336, 250.903, 244.63, 238.515, 232.552, 226.738, 221.07, 215.543, 210.154, 204.9, 199.778, 194.783, 189.914, 185.166, 180.537, 176.023, 171.623, 167.332, 163.149, 159.07, 155.093, 151.216, 147.436, 143.75, 140.156, 136.652, 133.236, 129.905, 126.657, 123.491, 120.404, 117.394, 114.459, 111.597, 108.807, 106.087, 103.435, 100.849, 98.3279, 95.8697, 93.4729, 91.1361, 88.8577, 86.6362, 84.4703, 82.3586, 80.2996, 78.2921, 76.3348, 74.4265, 72.5658, 70.7516, 68.9829, 67.2583, 65.5768, 63.9374, 62.339, 60.7805, 59.261, 57.7795, 56.335, 54.9266, 53.5534, 52.2146, 50.9092, 49.6365, 48.3956, 47.1857, 46.0061, 44.8559]\nGrowth rate of productivity: [0.076, 0.0741236, 0.0722934, 0.0705085, 0.0687676, 0.0670698, 0.0654138, 0.0637987, 0.0622235, 0.0606872, 0.0591889, 0.0577275, 0.0563022, 0.0549121, 0.0535563, 0.052234, 0.0509443, 0.0496865, 0.0484597, 0.0472633, 0.0460963, 0.0449582, 0.0438482, 0.0427656, 0.0417097, 0.0406799, 0.0396755, 0.0386959, 0.0377405, 0.0368087, 0.0358999, 0.0350135, 0.034149, 0.0333059, 0.0324835, 0.0316815, 0.0308993, 0.0301364, 0.0293923, 0.0286666, 0.0279588, 0.0272685, 0.0265953, 0.0259386, 0.0252982, 0.0246736, 0.0240644, 0.0234702, 0.0228908, 0.0223256, 0.0217744, 0.0212368, 0.0207124, 0.020201, 0.0197023, 0.0192158, 0.0187414, 0.0182786, 0.0178273, 0.0173872, 0.0169579, 0.0165392, 0.0161308, 0.0157326, 0.0153441, 0.0149653, 0.0145958, 0.0142354, 0.0138839, 0.0135412, 0.0132068, 0.0128807, 0.0125627, 0.0122525, 0.01195, 0.011655, 0.0113672, 0.0110866, 0.0108128, 0.0105459, 0.0102855, 0.0100315, 0.00978385, 0.00954229, 0.00930669, 0.00907691, 0.0088528, 0.00863422, 0.00842104, 0.00821312, 0.00801034, 0.00781257, 0.00761967, 0.00743154, 0.00724806, 0.0070691, 0.00689456, 0.00672434, 0.00655831, 0.00639639]\nEmissions from deforestation: [2.6, 2.301, 2.03639, 1.8022, 1.59495, 1.41153, 1.2492, 1.10554, 0.978407, 0.86589, 0.766313, 0.678187, 0.600195, 0.531173, 0.470088, 0.416028, 0.368185, 0.325843, 0.288371, 0.255209, 0.22586, 0.199886, 0.176899, 0.156556, 0.138552, 0.122618, 0.108517, 0.0960377, 0.0849933, 0.0752191, 0.0665689, 0.0589135, 0.0521384, 0.0461425, 0.0408361, 0.03614, 0.0319839, 0.0283057, 0.0250506, 0.0221698, 0.0196202, 0.0173639, 0.0153671, 0.0135998, 0.0120359, 0.0106517, 0.00942679, 0.00834271, 0.0073833, 0.00653422, 0.00578278, 0.00511776, 0.00452922, 0.00400836, 0.0035474, 0.00313945, 0.00277841, 0.00245889, 0.00217612, 0.00192587, 0.00170439, 0.00150839, 0.00133492, 0.00118141, 0.00104554, 0.000925307, 0.000818897, 0.000724724, 0.000641381, 0.000567622, 0.000502345, 0.000444576, 0.000393449, 0.000348203, 0.000308159, 0.000272721, 0.000241358, 0.000213602, 0.000189038, 0.000167298, 0.000148059, 0.000131032, 0.000115964, 0.000102628, 9.08256e-5, 8.03806e-5, 7.11368e-5, 6.29561e-5, 5.57162e-5, 4.93088e-5, 4.36383e-5, 3.86199e-5, 3.41786e-5, 3.02481e-5, 2.67695e-5, 2.3691e-5, 2.09666e-5, 1.85554e-5, 1.64215e-5, 1.45331e-5]\nAvg utility social discout rate: [1.0, 0.92826, 0.861667, 0.799852, 0.74247, 0.689206, 0.639762, 0.593866, 0.551262, 0.511715, 0.475005, 0.440928, 0.409296, 0.379933, 0.352677, 0.327376, 0.30389, 0.282089, 0.261852, 0.243067, 0.225629, 0.209443, 0.194417, 0.18047, 0.167523, 0.155505, 0.144349, 0.133994, 0.124381, 0.115458, 0.107175, 0.0994863, 0.0923492, 0.0857241, 0.0795743, 0.0738657, 0.0685666, 0.0636476, 0.0590816, 0.0548431, 0.0509086, 0.0472565, 0.0438663, 0.0407194, 0.0377982, 0.0350865, 0.0325694, 0.0302329, 0.028064, 0.0260507, 0.0241818, 0.022447, 0.0208367, 0.0193419, 0.0179543, 0.0166663, 0.0154706, 0.0143608, 0.0133305, 0.0123742, 0.0114865, 0.0106625, 0.00989753, 0.00918749, 0.00852838, 0.00791656, 0.00734862, 0.00682144, 0.00633207, 0.00587781, 0.00545614, 0.00506471, 0.00470137, 0.0043641, 0.00405102, 0.0037604, 0.00349063, 0.00324021, 0.00300776, 0.00279199, 0.00259169, 0.00240576, 0.00223317, 0.00207297, 0.00192425, 0.00178621, 0.00165807, 0.00153912, 0.0014287, 0.00132621, 0.00123107, 0.00114275, 0.00106077, 0.000984669, 0.000914029, 0.000848457, 0.000787589, 0.000731088, 0.00067864, 0.000629954]\nBase case carbon price: [2.0, 2.20816, 2.43799, 2.69174, 2.97189, 3.28121, 3.62272, 3.99978, 4.41608, 4.87571, 5.38318, 5.94346, 6.56206, 7.24505, 7.99912, 8.83167, 9.75088, 10.7658, 11.8863, 13.1234, 14.4893, 15.9973, 17.6624, 19.5007, 21.5303, 23.7712, 26.2453, 28.977, 31.9929, 35.3228, 38.9992, 43.0583, 47.5398, 52.4878, 57.9508, 63.9823, 70.6417, 77.9941, 86.1118, 95.0744, 104.97, 115.895, 127.958, 141.276, 155.98, 172.214, 190.138, 209.928, 231.777, 255.901, 282.535, 311.942, 344.409, 380.256, 419.833, 463.529, 511.774, 565.04, 623.849, 688.78, 760.469, 839.619, 927.007, 1023.49, 1130.02, 1247.63, 1377.48, 1520.85, 1679.15, 1853.91, 2046.87, 2259.91, 2495.12, 2754.82, 3041.54, 3358.11, 3707.62, 4093.51, 4519.57, 4989.97, 5509.33, 6082.74, 6715.84, 7414.83, 8186.57, 9038.64, 9979.39, 11018.0, 12164.8, 13430.9, 14828.8, 16372.2, 18076.3, 19957.7, 22034.9, 24328.3, 26860.4, 29656.0, 32742.7, 36150.6]\nPopulation and labour: [7403.0, 7853.09, 8264.92, 8638.97, 8976.56, 9279.54, 9550.18, 9790.92, 10004.3, 10192.8, 10359.0, 10505.1, 10633.2, 10745.5, 10843.6, 10929.4, 11004.1, 11069.3, 11126.1, 11175.5, 11218.4, 11255.8, 11288.2, 11316.3, 11340.8, 11362.0, 11380.4, 11396.3, 11410.2, 11422.2, 11432.6, 11441.6, 11449.4, 11456.2, 11462.0, 11467.1, 11471.5, 11475.3, 11478.6, 11481.5, 11484.0, 11486.1, 11488.0, 11489.6, 11491.0, 11492.2, 11493.2, 11494.1, 11494.9, 11495.6, 11496.2, 11496.7, 11497.1, 11497.5, 11497.9, 11498.1, 11498.4, 11498.6, 11498.8, 11499.0, 11499.1, 11499.2, 11499.3, 11499.4, 11499.5, 11499.6, 11499.6, 11499.7, 11499.7, 11499.8, 11499.8, 11499.8, 11499.8, 11499.9, 11499.9, 11499.9, 11499.9, 11499.9, 11499.9, 11499.9, 11499.9, 11500.0, 11500.0, 11500.0, 11500.0, 11500.0, 11500.0, 11500.0, 11500.0, 11500.0, 11500.0, 11500.0, 11500.0, 11500.0, 11500.0, 11500.0, 11500.0, 11500.0, 11500.0, 11500.0]\nTotal factor productivity: [5.115, 5.53571, 5.97889, 6.44481, 6.93369, 7.44572, 7.981, 8.53961, 9.12155, 9.72679, 10.3552, 11.0067, 11.681, 12.3779, 13.0971, 13.8382, 14.6009, 15.3846, 16.189, 17.0135, 17.8575, 18.7204, 19.6017, 20.5006, 21.4165, 22.3487, 23.2963, 24.2588, 25.2353, 26.2251, 27.2273, 28.2411, 29.2658, 30.3006, 31.3445, 32.3969, 33.4568, 34.5236, 35.5963, 36.6743, 37.7566, 38.8426, 39.9315, 41.0225, 42.1149, 43.208, 44.3011, 45.3934, 46.4844, 47.5734, 48.6598, 49.7429, 50.8222, 51.8971, 52.9671, 54.0317, 55.0903, 56.1424, 57.1878, 58.2258, 59.2561, 60.2783, 61.292, 62.2969, 63.2926, 64.2789, 65.2555, 66.2221, 67.1784, 68.1242, 69.0594, 69.9836, 70.8968, 71.7988, 72.6894, 73.5686, 74.4361, 75.292, 76.1361, 76.9683, 77.7887, 78.5971, 79.3935, 80.178, 80.9504, 81.7109, 82.4594, 83.1959, 83.9205, 84.6332, 85.334, 86.0231, 86.7005, 87.3662, 88.0203, 88.6629, 89.2941, 89.9141, 90.5228, 91.1204]\nΔσ: [-0.0152, -0.0151242, -0.0150487, -0.0149736, -0.0148989, -0.0148245, -0.0147506, -0.0146769, -0.0146037, -0.0145308, -0.0144583, -0.0143862, -0.0143144, -0.014243, -0.0141719, -0.0141012, -0.0140308, -0.0139608, -0.0138911, -0.0138218, -0.0137528, -0.0136842, -0.0136159, -0.013548, -0.0134804, -0.0134131, -0.0133462, -0.0132796, -0.0132133, -0.0131474, -0.0130818, -0.0130165, -0.0129515, -0.0128869, -0.0128226, -0.0127586, -0.012695, -0.0126316, -0.0125686, -0.0125059, -0.0124435, -0.0123814, -0.0123196, -0.0122581, -0.0121969, -0.0121361, -0.0120755, -0.0120153, -0.0119553, -0.0118957, -0.0118363, -0.0117772, -0.0117185, -0.01166, -0.0116018, -0.0115439, -0.0114863, -0.011429, -0.011372, -0.0113152, -0.0112587, -0.0112026, -0.0111467, -0.011091, -0.0110357, -0.0109806, -0.0109258, -0.0108713, -0.0108171, -0.0107631, -0.0107094, -0.0106559, -0.0106028, -0.0105499, -0.0104972, -0.0104448, -0.0103927, -0.0103409, -0.0102893, -0.0102379, -0.0101868, -0.010136, -0.0100854, -0.0100351, -0.00998501, -0.00993519, -0.00988561, -0.00983628, -0.0097872, -0.00973836, -0.00968977, -0.00964141, -0.0095933, -0.00954543, -0.0094978, -0.00945041, -0.00940325, -0.00935633, -0.00930964, -0.00926318]\nσ: [0.35032, 0.324682, 0.301035, 0.279215, 0.259074, 0.240476, 0.223296, 0.20742, 0.192744, 0.179171, 0.166615, 0.154996, 0.144238, 0.134275, 0.125046, 0.116492, 0.108561, 0.101206, 0.0943825, 0.0880495, 0.08217, 0.0767096, 0.0716365, 0.0669219, 0.0625387, 0.0584624, 0.0546702, 0.051141, 0.0478557, 0.0447962, 0.0419461, 0.0392903, 0.0368146, 0.0345061, 0.0323528, 0.0303437, 0.0284684, 0.0267176, 0.0250823, 0.0235546, 0.0221268, 0.0207921, 0.019544, 0.0183764, 0.0172839, 0.0162614, 0.015304, 0.0144073, 0.0135673, 0.01278, 0.012042, 0.0113501, 0.010701, 0.010092, 0.00952047, 0.00898391, 0.00848005, 0.00800675, 0.00756203, 0.00714405, 0.00675109, 0.00638154, 0.00603392, 0.00570683, 0.00539897, 0.00510913, 0.00483619, 0.00457908, 0.00433682, 0.00410849, 0.00389323, 0.00369025, 0.00349878, 0.00331812, 0.00314763, 0.00298669, 0.00283471, 0.00269117, 0.00255556, 0.00242741, 0.00230628, 0.00219175, 0.00208344, 0.00198099, 0.00188404, 0.00179229, 0.00170543, 0.00162319, 0.00154529, 0.00147149, 0.00140155, 0.00133527, 0.00127243, 0.00121283, 0.00115631, 0.00110268, 0.00105179, 0.00100348, 0.000957617, 0.000914064]\ncumtree: [100.0, 103.546, 106.684, 109.462, 111.92, 114.095, 116.02, 117.724, 119.232, 120.566, 121.747, 122.792, 123.717, 124.536, 125.26, 125.902, 126.469, 126.971, 127.416, 127.809, 128.157, 128.465, 128.738, 128.979, 129.192, 129.381, 129.549, 129.697, 129.828, 129.944, 130.046, 130.137, 130.217, 130.288, 130.351, 130.407, 130.456, 130.5, 130.539, 130.573, 130.603, 130.63, 130.653, 130.674, 130.693, 130.709, 130.724, 130.737, 130.748, 130.758, 130.767, 130.775, 130.782, 130.788, 130.794, 130.798, 130.803, 130.806, 130.81, 130.813, 130.815, 130.818, 130.82, 130.822, 130.823, 130.825, 130.826, 130.827, 130.828, 130.829, 130.83, 130.83, 130.831, 130.832, 130.832, 130.832, 130.833, 130.833, 130.833, 130.834, 130.834, 130.834, 130.834, 130.834, 130.835, 130.835, 130.835, 130.835, 130.835, 130.835, 130.835, 130.835, 130.835, 130.835, 130.835, 130.835, 130.835, 130.835, 130.835, 130.835]\nθ₁: [0.0741062, 0.0669657, 0.0605362, 0.0547447, 0.0495259, 0.0448213, 0.0405787, 0.0367512, 0.0332971, 0.0301786, 0.0273622, 0.0248176, 0.0225177, 0.0204384, 0.0185576, 0.0168559, 0.0153157, 0.0139211, 0.012658, 0.0115134, 0.010476, 0.00953533, 0.00868211, 0.00790794, 0.00720525, 0.00656722, 0.0059877, 0.00546114, 0.00498255, 0.00454741, 0.00415164, 0.00379156, 0.00346383, 0.00316547, 0.00289374, 0.00264618, 0.00242058, 0.00221491, 0.00202737, 0.00185628, 0.00170017, 0.00155768, 0.00142756, 0.00130873, 0.00120015, 0.00110092, 0.0010102, 0.000927233, 0.00085134, 0.000781892, 0.000718324, 0.00066012, 0.000606811, 0.000557971, 0.000513212, 0.000472181, 0.000434556, 0.000400045, 0.000368379, 0.000339317, 0.000312637, 0.000288135, 0.000265629, 0.000244949, 0.000225941, 0.000208467, 0.000192397, 0.000177614, 0.000164012, 0.000151492, 0.000139966, 0.000129352, 0.000119574, 0.000110565, 0.000102262, 9.46074e-5, 8.75486e-5, 8.10375e-5, 7.50302e-5, 6.94861e-5, 6.43681e-5, 5.96424e-5, 5.52777e-5, 5.12453e-5, 4.75191e-5, 4.40748e-5, 4.08904e-5, 3.79454e-5, 3.52212e-5, 3.27007e-5, 3.03679e-5, 2.82084e-5, 2.62088e-5, 2.43568e-5, 2.26411e-5, 2.10512e-5, 1.95776e-5, 1.82115e-5, 1.69447e-5, 1.57697e-5]\nExogenious forcing: [0.5, 0.529412, 0.558824, 0.588235, 0.617647, 0.647059, 0.676471, 0.705882, 0.735294, 0.764706, 0.794118, 0.823529, 0.852941, 0.882353, 0.911765, 0.941176, 0.970588, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5]"
    end
end

#Use same limits for RR case for simplicity
μ_ubound = [if t < 30 1.0 else vanilla_opt.limμ*vanilla_params.partfract[t] end for t in 1:vanilla_opt.N];
vanilla_vars = DICE.model_vars(v2013R(), model, vanilla_opt.N, vanilla_opt.fosslim, μ_ubound, vanilla_params.cpricebase);
rr_vars = DICE.model_vars(v2013R(RockyRoad), modelrr, vanilla_opt.N, vanilla_opt.fosslim, μ_ubound, fill(Inf, vanilla_opt.N));

vanilla_eqs = DICE.model_eqs(v2013R(), model, vanilla_opt, vanilla_params, vanilla_vars);
rr_eqs = DICE.model_eqs(v2013R(RockyRoad), modelrr, rr_opt, rr_params, rr_vars);

v2016_vars = DICE.model_vars(v2016R(), model2016, v2016_opt.N, v2016_opt.fosslim, [if t < 30 1.0 else v2016_opt.limμ end for t in 1:v2016_opt.N], fill(Inf, v2016_opt.N));
v2016_eqs = DICE.model_eqs(v2016R(), model2016, v2016_opt, v2016_params, v2016_vars);
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
            vanilla_optimal_price = DICE.assign_scenario(OptimalPrice, vanilla_opt, vanilla_params);
            @test all(x->(vanilla_optimal_price[x] ≈ 1000.0), Int(vanilla_opt.tnopol+1):vanilla_opt.N)
        end
        @testset "2013R (Rocky Road)" begin
            # Needs CPRICE, so requires a successful model result to test.
            #DICE.assign_scenario(BasePrice, modelrr, rr_opt, rr_params, rr_vars);
            @test_broken all(isfinite.(JuMP.getupperbound(rr_vars.CPRICE)))
            #DICE.assign_scenario(OptimalPrice, modelrr, rr_opt, rr_params, rr_vars);
            @test_broken JuMP.getupperbound(rr_vars.μ[1]) == rr_opt.μ₀
            #DICE.assign_scenario(Limit2Degrees, modelrr, rr_opt, rr_params, rr_vars);
            @test_broken JuMP.getupperbound(rr_vars.Tₐₜ[1]) ≈ 2.0
            DICE.assign_scenario(Stern, modelrr, rr_opt, rr_params, rr_vars);
            @test JuMP.getvalue(rr_params.α) ≈ 1.01
            #DICE.assign_scenario(SternCalibrated, modelrr, rr_opt, rr_params, rr_vars);
            @test_broken JuMP.getvalue(rr_params.α) ≈ 2.1
            DICE.assign_scenario(Copenhagen, modelrr, rr_opt, rr_params, rr_vars);
            @test JuMP.getvalue(rr_params.partfract[2]) ≈ 0.390423082
            @test JuMP.getlowerbound(rr_vars.μ[3]) ≈ 0.110937151
            @test JuMP.getupperbound(rr_vars.μ[3]) ≈ 0.110937151
        end
        @testset "2016R beta" begin
            #DICE.assign_scenario(BasePrice, model2016, v2016_opt, v2016_params, v2016_vars);
            @test_broken all(isfinite.(JuMP.getupperbound(v2016_vars.CPRICE)))
            DICE.assign_scenario(OptimalPrice, model2016, v2016_opt, v2016_params, v2016_vars);
            @test JuMP.getupperbound(v2016_vars.μ[1]) == v2016_opt.μ₀
        end
    end
    @testset "Invalid Scenarios" begin
        @test_throws ErrorException solve(Limit2Degrees, v2013R())
        @test_throws ErrorException solve(Stern, v2013R())
        @test_throws ErrorException solve(SternCalibrated, v2013R())
        @test_throws ErrorException solve(Copenhagen, v2013R())
        @test_throws ErrorException solve(Limit2Degrees, v2016R())
        @test_throws ErrorException solve(Stern, v2016R())
        @test_throws ErrorException solve(SternCalibrated, v2016R())
        @test_throws ErrorException solve(Copenhagen, v2016R())
    end
end

# Optimisation tests.
if get(ENV, "TRAVIS", "false") == "true"
    #For some unknown reason, there's an issue using the DICE defaults on travis,
    #but it seems like it's just the first result. So call the solver once first.
    ipopt = IpoptSolver(print_frequency_iter=500, max_iter=1000);
    solve(BasePrice, v2013R(), solver = ipopt);
    @testset "Utility" begin
        @testset "2013R (Vanilla)" begin
            result = solve(BasePrice, v2013R(), solver = ipopt);
            @test result.results.UTILITY ≈ 2670.2779245830334
            result = solve(OptimalPrice, v2013R(), solver = ipopt);
            @test result.results.UTILITY ≈ 2690.244712873159
        end
        @testset "2013R (RockyRoad)" begin
            #NOTE: None of these values have been verified yet.
            # See issue #3. Have set some to broken to remember this.
            result = solve(BasePrice, v2013R(RockyRoad), solver = ipopt);
            @test result.results.UTILITY ≈ 2670.362568216809
            result = solve(OptimalPrice, v2013R(RockyRoad), solver = ipopt);
            @test result.results.UTILITY ≈ 2741.230618094657
            result = solve(Limit2Degrees, v2013R(RockyRoad), solver = ipopt);
            @test result.results.UTILITY ≈ 2695.487309594252
            result = solve(Stern, v2013R(RockyRoad), solver = ipopt);
            @test result.results.UTILITY ≈ 124390.42213103821
            result = solve(SternCalibrated, v2013R(RockyRoad), solver = ipopt);
            @test_broken result.results.UTILITY ≈ 9001.0
            result = solve(Copenhagen, v2013R(RockyRoad), solver = ipopt);
            @test result.results.UTILITY ≈ 2725.414606616763
        end
        @testset "2016R beta" begin
            result = solve(BasePrice, v2016R(), solver = ipopt);
            @test result.results.UTILITY ≈ 4493.8420532623495
            result = solve(OptimalPrice, v2016R(), solver = ipopt);
            @test result.results.UTILITY ≈ 4522.257183520258
        end
    end
end
