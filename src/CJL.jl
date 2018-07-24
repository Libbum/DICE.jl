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

@extend immutable OptionsVCJL <: Options
    δσ₂::Float64 #Quadratic term in decarbonization
    σ₀::Float64 #CO₂-equivalent emissions-GNP ratio 2005
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
    deland::Float64 = 0.01, #Decline rate of land emissions (per period)
    mat₀::Float64 = 808.9, #Initial Concentration in atmosphere 2005 (GtC)
    mu₀::Float64 = 1255.0, #Initial Concentration in upper strata 2005 (GtC)
    ml₀::Float64 = 18365.0, #Initial Concentration in lower strata 2005 (GtC)
    mateq::Float64 = 587.473, #Equilibrium concentration atmosphere  (GtC)
    mueq::Float64 = 1143.894, #Equilibrium concentration in upper strata (GtC)
    mleq::Float64 = 18340.0, #Equilibrium concentration in lower strata (GtC)
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
    σ₀::Float64 = .13418, #CO₂-equivalent emissions-GNP ratio 2005
    backrat::Float64 = 2.0, #atio initial to final backstop cost
    partfract1::Float64 = 1.0, #Fraction of emissions under control regime 2005
    partfract2::Float64 = 1.0, #Fraction of emissions under control regime 2015
    partfract21::Float64 = 1.0, #Fraction of emissions under control regime 2205
    dpartfract::Float64 = 0.0) #Decline rate of participation

    OptionsVCJL(N,tstep,α,ρ,γₑ,pop₀,popadj,popasym,δk,q₀,k₀,a₀,ga₀,δₐ,gσ₁,δσ,eland₀,deland,mat₀,mu₀,ml₀,mateq,mueq,mleq,ϕ₁₂,ϕ₂₃,t2xco2,fₑₓ0,fₑₓ1,tocean₀,tatm₀,ξ₁,ξ₃,ξ₄,η,ψ₁,ψ₂,ψ₃,θ₂,pback,gback,limμ,fosslim,scale1,scale2,δσ₂,σ₀,backrat,partfract1,partfract2,partfract21,dpartfract)
end

#TODO: Not completely finished
function Base.show(io::IO, ::MIME"text/plain", opt::OptionsVCJL)
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


@extend immutable ParametersVCJL <: Parameters
    rr::Array{Float64,1} # Average utility social discount rate
    partfract::Array{Float64,1} # Fraction of emissions in control regime
end

function generate_parameters(c::OptionsVCJL, model::JuMP.Model)
    ϕ₁₁::Float64 = 1 - c.ϕ₁₂; # Carbon cycle transition matrix coefficient
    ϕ₂₁::Float64 = c.mateq*c.ϕ₁₂/c.mueq; # Carbon cycle transition matrix coefficient
    ϕ₂₂::Float64 = 1 - ϕ₂₁ - c.ϕ₂₃; # Carbon cycle transition matrix coefficient
    ϕ₃₂::Float64 = c.mueq*c.ϕ₂₃/c.mleq; # Carbon cycle transition matrix coefficient
    ϕ₃₃::Float64 = 1 - ϕ₃₂; # Carbon cycle transition matrix coefficient
    σ₀::Float64 = c.σ₀; # CO2-equivalent emissions-GNP ratio 2005
    λ::Float64 = c.η/c.t2xco2; # Climate model parameter

    # Growth factor population
    #NOTE: This is only a helper function for L, so we don't include it in the Narrative anywhere.
    gfacpop = Array{Float64}(c.N);
    # Level of population and labor
    L = Array{Float64}(c.N);
    # Growth rate of productivity from 0 to N
    gₐ = Array{Float64}(c.N);
    # Change in sigma (cumulative improvement of energy efficiency)
    gσ = Array{Float64}(c.N);
    # Emissions from deforestation
    Etree = Array{Float64}(c.N);
    # Average utility social discount rate
    rr = Array{Float64}(c.N);

    for i in 1:c.N
        gfacpop[i] = (exp.(c.popadj*(i-1))-1)/exp.(c.popadj*(i-1));
        L[i] = c.pop₀*(1-gfacpop[i])+gfacpop[i]*c.popasym;
        gₐ[i] = c.ga₀*exp.(-c.δₐ*(i-1));
        gσ[i] = c.gσ₁*exp.(-c.δσ*(i-1))-c.δσ₂*((i-1)^2);
        Etree[i] = c.eland₀*(1-c.deland)^(i-1);
        rr[i] = 1/((1+c.ρ)^(i-1));
    end

    # Initial conditions and offset required
    # Level of total factor productivity
    A = Array{Float64}(c.N);
    A[1] = c.a₀;
    # CO2-equivalent-emissions output ratio
    σ = Array{Float64}(c.N);
    σ[1] = σ₀;

    for i in 1:c.N-1
        A[i+1] = A[i]/(1-gₐ[i]);
        σ[i+1] = σ[i]/(1-gσ[i+1]);
    end

    # Adjusted cost for backstop
    θ₁ = Array{Float64}(c.N);
    # Exogenous forcing for other greenhouse gases
    fₑₓ = Array{Float64}(c.N);
    # Fraction of emissions in control regime
    partfract = Array{Float64}(c.N);

    for i in 1:c.N
        θ₁[i] = (c.pback*σ[i]/c.θ₂)*((c.backrat-1+exp.(-c.gback*(i-1)))/c.backrat);
        fₑₓ[i] = if i < 101
                        c.fₑₓ0+0.01*(c.fₑₓ1-c.fₑₓ0)*(i-1)
                    else
                        0.36
                    end;
        partfract[i] = if i <= 259
                            c.partfract21+(c.partfract2-c.partfract21)*exp.(-c.dpartfract*(i-2))
                       else
                            c.partfract21
                       end;
    end
    partfract[1] = c.partfract1;
    ParametersVCJL(ϕ₁₁,ϕ₂₁,ϕ₂₂,ϕ₃₂,ϕ₃₃,σ₀,λ,gₐ,Etree,L,A,gσ,σ,θ₁,fₑₓ,rr,partfract)
end

function Base.show(io::IO, ::MIME"text/plain", opt::ParametersVCJL)
    println(io, "Calculated Parameters for DICE-CJL");
    println(io, "Carbon cycle transition matrix coefficients");
    println(io, "ϕ₁₁: $(opt.ϕ₁₁), ϕ₂₁: $(opt.ϕ₂₁), ϕ₂₂: $(opt.ϕ₂₂), ϕ₃₂: $(opt.ϕ₃₂), ϕ₃₃: $(opt.ϕ₃₃)");
    println(io, "2015 Carbon intensity: $(opt.σ₀)");
    println(io, "Climate model parameter: $(opt.λ)");
    println(io, "Growth rate of productivity: $(opt.gₐ)");
    println(io, "Emissions from deforestation: $(opt.Etree)");
    println(io, "Avg utility social discout rate: $(opt.rr)");
    println(io, "Population and labour: $(opt.L)");
    println(io, "Total factor productivity: $(opt.A)");
    println(io, "Δσ: $(opt.gσ)");
    println(io, "σ: $(opt.σ)");
    println(io, "θ₁: $(opt.θ₁)");
    print(io, "Exogenious forcing: $(opt.fₑₓ)");
end
