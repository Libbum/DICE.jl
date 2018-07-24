immutable VCJL <: Version end

Base.show(io::IO, v::VCJL) = print(io, "CJL")

"""
    vCJL()

Identifier for the DICE-CJL version of the model.

# Examples
```jldoctest
julia> vCJL()
CJL
```
"""
function vCJL()
    VCJL()
end

export vCJL

@extend immutable OptionsCJL <: Options
    δσ₂::Float64 #Quadratic term in decarbonization
    σ₀::Float64 #CO₂-equivalent emissions-GNP ratio 2005
    ϕ₁₁::Float64 #Carbon cycle transition matrix coefficient
    ϕ₂₁::Float64 #Carbon cycle transition matrix coefficient
    ϕ₂₂::Float64 #Carbon cycle transition matrix coefficient
    ϕ₃₂::Float64 #Carbon cycle transition matrix coefficient
    ϕ₃₃::Float64 #Carbon cycle transition matrix coefficient
    backrat::Float64 #atio initial to final backstop cost
    partfract1::Float64 #Fraction of emissions under control regime 2005
    partfract2::Float64 #Fraction of emissions under control regime 2015
    partfract21::Float64 #Fraction of emissions under control regime 2205
    dpartfract::Float64 #Decline rate of participation
end

function options(version::VCJL;
    N::Int = 600, #Number of years to calculate (from 2005 onwards)
    tstep::Int = 1, #Years per Period
    α::Float64 = 2.0, #Elasticity of marginal utility of consumption
    ρ::Float64 = 0.015, #Initial rate of social time preference per year
    γₑ::Float64 = 0.3, #Capital elasticity in production function
    pop₀::Int = 6514, #2005 world population (millions)
    popadj::Float64 = 0.035, #->gpop₀ Growth rate of population per year
    popasym::Int = 8600, #Asymptotic population (millions)
    δk::Float64 = 0.1, #Depreciation rate on capital (per year)
    q₀::Float64 = 61.1, #Initial world gross output (trill 2005 USD)
    k₀::Float64 = 137.0, #Initial capital value (trill 2005 USD)
    a₀::Float64 = 0.02722, #Initial level of total factor productivity
    ga₀::Float64 = 0.092, #Initial growth rate for TFP per year
    δₐ::Float64 = 0.001, #Decline rate of TFP per year
    gσ₁::Float64 = -.00730, #Initial growth of sigma (continuous per year)
    δσ::Float64 = -0.003, #Decline rate of decarbonization per period
    eland₀::Float64 = 1.1, #Carbon emissions from land 2005 (GtCO2 per year)
    mat₀::Float64 = 808.9, #Initial Concentration in atmosphere 2005 (GtC)
    mu₀::Float64 = 1255.0, #Initial Concentration in upper strata 2005 (GtC)
    ml₀::Float64 = 18365.0, #Initial Concentration in lower strata 2005 (GtC)
    ϕ₁₂::Float64 = 0.0189288, #Carbon cycle transition matrix coefficient
    ϕ₂₃::Float64 = 0.005, #Carbon cycle transition matrix coefficient
    t2xco2::Float64 = 3.0, #Equilibrium temp impact (oC per doubling CO2)
    fₑₓ0::Float64 = -0.06, #2000 forcings of non-CO2 GHG (Wm-2)
    fₑₓ1::Float64 = 0.3, #2000 forcings of non-CO2 GHG (Wm-2)
    tocean₀::Float64 = 0.0068, #2000 lower stratum temp change (C from 1900)
    tatm₀::Float64 = .7307, #2000 atmospheric temp change (C from 1900)
    ξ₁::Float64 = .0220, #Climate equation coefficient for upper level
    ξ₃::Float64 = .3, #Transfer coefficient upper to lower stratum
    ξ₄::Float64 = .005, #Transfer coefficient for lower level
    η::Float64 = 3.8, #Forcings of equilibrium CO2 doubling (Wm-2)
    ψ₁::Float64 = 0.0, #Damage intercept
    ψ₂::Float64 = 0.0028388, #Damage quadratic term
    ψ₃::Float64 = 2.0, #Damage exponent
    θ₂::Float64 = 2.8, #Exponent of control cost function
    pback::Float64 = 1.17, #Cost of backstop 2005$ per tCO2 2005
    gback::Float64 = 0.005, #Initial cost decline backstop cost per year
    limμ::Float64 = 1.0, #Upper limit on control rate after 2150
    fosslim::Float64 = 6000.0, #Maximum cumulative extraction fossil fuels (GtC)
    scale1::Float64 = 194., #Multiplicative scaling coefficient
    scale2::Float64 = 381800., #Additive scaling coefficient
    δσ₂::Float64 = 0.0, #Quadratic term in decarbonization
    σ₀::Float64 = .13418, #CO₂-equivalent emissions-GNP ratio 2005 //NOT PARAM
    ϕ₁₁::Float64 = 0.9810712, #Carbon cycle transition matrix coefficient
    ϕ₂₁::Float64 = 0.0097213, #Carbon cycle transition matrix coefficient
    ϕ₂₂::Float64 = 0.9852787, #Carbon cycle transition matrix coefficient
    ϕ₃₂::Float64 = 0.0003119, #Carbon cycle transition matrix coefficient
    ϕ₃₃::Float64 = 0.9996881, #Carbon cycle transition matrix coefficient //!NOT PARAM
    backrat::Float64 = 2.0, #atio initial to final backstop cost
    partfract1::Float64 = 1.0, #Fraction of emissions under control regime 2005
    partfract2::Float64 = 1.0, #Fraction of emissions under control regime 2015
    partfract21::Float64 = 1.0, #Fraction of emissions under control regime 2205
    dpartfract::Float64 = 0.0) #Decline rate of participation

    OptionsCJL(N,tstep,α,ρ,γₑ,pop₀,popadj,popasym,δk,q₀,k₀,a₀,ga₀,δₐ,gσ₁,δσ,eland₀,mat₀,mu₀,ml₀,ϕ₁₂,ϕ₂₃,t2xco2,fₑₓ0,fₑₓ1,tocean₀,tatm₀,ξ₁,ξ₃,ξ₄,η,ψ₁,ψ₂,ψ₃,θ₂,pback,gback,limμ,fosslim,scale1,scale2,δσ₂,σ₀,ϕ₁₁,ϕ₂₁,ϕ₂₂,ϕ₃₂,ϕ₃₃,backrat,partfract1,partfract2,partfract21,dpartfract)
end

function Base.show(io::IO, ::MIME"text/plain", opt::OptionsCJL)
    println(io, "Options for DICE-CJL");
    println(io, "Time step");
    println(io, "N: $(opt.N), tstep: $(opt.tstep)");
    println(io, "Preferences");
    println(io, "α: $(opt.α), ρ: $(opt.ρ)");
    println(io, "Population and Technology");
    println(io, "γₑ: $(opt.γₑ), pop₀: $(opt.pop₀), popadj: $(opt.popadj), popasym: $(opt.popasym), δk: $(opt.δk)");
    println(io, "q₀: $(opt.q₀), k₀: $(opt.k₀), a₀: $(opt.a₀), ga₀: $(opt.ga₀), δₐ: $(opt.δₐ)");
    println(io, "Emissions Parameters");
    println(io, "gσ₁: $(opt.gσ₁), δσ: $(opt.δσ), eland₀: $(opt.eland₀)");
    println(io, "Carbon Cycle");
    println(io, "mat₀: $(opt.mat₀), mu₀: $(opt.mu₀), ml₀: $(opt.ml₀)");
    println(io, "Flow Parameters");
    println(io, "ϕ₁₂: $(opt.ϕ₁₂), ϕ₂₃: $(opt.ϕ₂₃)"); #TODO: Fill this in.
    println(io, "Climate Model Parameters");
    println(io, "t2xco2: $(opt.t2xco2), fₑₓ0: $(opt.fₑₓ0), fₑₓ1: $(opt.fₑₓ1)");
    println(io, "tocean₀: $(opt.tocean₀), tatm₀: $(opt.tatm₀), ξ₁: $(opt.ξ₁)");
    println(io, "ξ₃: $(opt.ξ₃), ξ₄: $(opt.ξ₄), η: $(opt.η)");
    println(io, "Climate Damage Parameters");
    println(io, "ψ₁: $(opt.ψ₁), ψ₂: $(opt.ψ₂), ψ₃: $(opt.ψ₃)");
    println(io, "Abatement Cost");
    println(io, "θ₂: $(opt.θ₂), pback: $(opt.pback), gback: $(opt.gback), limμ: $(opt.limμ)");
    println(io, "Fossil Fuel Availability");
    println(io, "fosslim: $(opt.fosslim)");
    println(io, "Scaling Parameters");
    print(io, "scale1: $(opt.scale1), scale2: $(opt.scale2)");
end
