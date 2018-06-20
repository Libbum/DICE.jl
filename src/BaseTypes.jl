@base type Options
    N::Int #Number of years to calculate (from 2010 onwards)
    tstep::Int #Years per Period
    α::Float64 #Elasticity of marginal utility of consumption
    ρ::Float64 #Initial rate of social time preference per year ρ
    γₑ::Float64 #Capital elasticity in production function (Capital share)
    pop₀::Int #Initial world population (millions)
    popadj::Float64 #Growth rate to calibrate to 2050 pop projection
    popasym::Int #Asymptotic population (millions)
    δk::Float64 #Depreciation rate on capital (per year)
    q₀::Float64 #Initial world gross output (trill 2005 USD)
    k₀::Float64 #Initial capital value (trill 2005 USD)
    a₀::Float64 #Initial level of total factor productivity
    ga₀::Float64 #Initial growth rate for TFP per 5 years
    δₐ::Float64 #Decline rate of TFP per 5 years
    gσ₁::Float64 #Initial growth of sigma (continuous per year)
    δσ::Float64 #Decline rate of decarbonization per period
    eland₀::Float64 #Carbon emissions from land 2010 (GtCO2 per year)
    deland::Float64 #Decline rate of land emissions (per period)
    e₀::Float64 #Industrial emissions 2010 (GtCO2 per year)
    μ₀::Float64 #Initial emissions control rate for base case 2010
    mat₀::Float64 #Initial Concentration in atmosphere 2010 (GtC)
    mu₀::Float64 #Initial Concentration in upper strata 2010 (GtC)
    ml₀::Float64 #Initial Concentration in lower strata 2010 (GtC)
    mateq::Float64 #Equilibrium concentration atmosphere  (GtC)
    mueq::Float64 #Equilibrium concentration in upper strata (GtC)
    mleq::Float64 #Equilibrium concentration in lower strata (GtC)
    ϕ₁₂::Float64 #Carbon cycle transition matrix coefficient
    ϕ₂₃::Float64 #Carbon cycle transition matrix coefficient
    t2xco2::Float64 #Equilibrium temp impact (oC per doubling CO2)
    fₑₓ0::Float64 #2010 forcings of non-CO2 GHG (Wm-2)
    fₑₓ1::Float64 #2100 forcings of non-CO2 GHG (Wm-2)
    tocean₀::Float64 #Initial lower stratum temp change (C from 1900)
    tatm₀::Float64 #Initial atmospheric temp change (C from 1900)
    ξ₁::Float64 #Climate equation coefficient for upper level
    ξ₃::Float64 #Transfer coefficient upper to lower stratum
    ξ₄::Float64 #Transfer coefficient for lower level
    η::Float64 #Forcings of equilibrium CO2 doubling (Wm-2)
    ψ₁::Float64 #Damage intercept
    ψ₂::Float64 #Damage quadratic term
    ψ₃::Float64 #Damage exponent
    θ₂::Float64 #Exponent of control cost function
    pback::Float64 #Cost of backstop 2005$ per tCO2 2010
    gback::Float64 #Initial cost decline backstop cost per period
    limμ::Float64 #Upper limit on control rate after 2150
    tnopol::Float64 #Period before which no emissions controls base
    cprice₀::Float64 #Initial base carbon price (2005$ per tCO2)
    gcprice::Float64 #Growth rate of base carbon price per year
    fosslim::Float64 #Maximum cumulative extraction fossil fuels (GtC)
    scale1::Float64 #Multiplicative scaling coefficient
    scale2::Float64 #Additive scaling coefficient
end

@base type Parameters
    ϕ₁₁::Float64 # Carbon cycle transition matrix coefficient
    ϕ₂₁::Float64 # Carbon cycle transition matrix coefficient
    ϕ₂₂::Float64 # Carbon cycle transition matrix coefficient
    ϕ₃₂::Float64 # Carbon cycle transition matrix coefficient
    ϕ₃₃::Float64 # Carbon cycle transition matrix coefficient
    σ₀::Float64 # Carbon intensity 2010 (kgCO2 per output 2005 USD 2010)
    λ::Float64 # Climate model parameter
    pbacktime::Array{Float64,1} # Backstop price
    gₐ::Array{Float64,1} # Growth rate of productivity from 0 to N
    Etree::Array{Float64,1} # Emissions from deforestation
    cpricebase::Array{Float64,1} # Carbon price in base case
    L::Array{Float64,1} # Level of population and labor
    A::Array{Float64,1} # Level of total factor productivity
    gσ::Array{Float64,1} # Change in sigma (cumulative improvement of energy efficiency)
    σ::Array{Float64,1} # CO2-equivalent-emissions output ratio
    θ₁::Array{Float64,1} # Adjusted cost for backstop
    fₑₓ::Array{Float64,1} # Exogenous forcing for other greenhouse gases
end
