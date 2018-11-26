@extend immutable OptionsV2016 <: Options
    e₀::Float64 #Industrial emissions 2015 (GtCO2 per year)
    μ₀::Float64 #Initial emissions control rate for base case 2015
    tnopol::Float64 #Period before which no emissions controls base
    cprice₀::Float64 #Initial base carbon price (2010$ per tCO2)
    gcprice::Float64 #Growth rate of base carbon price per year
    ψ₁₀::Float64 #Initial damage intercept
end

function Base.show(io::IO, ::MIME"text/plain", opt::OptionsV2016)
    println(io, "Options for 2016 versions");
    println(io, "Time step");
    println(io, "N: $(opt.N), tstep: $(opt.tstep)");
    println(io, "Preferences");
    println(io, "α: $(opt.α), ρ: $(opt.ρ)");
    println(io, "Population and Technology");
    println(io, "γₑ: $(opt.γₑ), pop₀: $(opt.pop₀), popadj: $(opt.popadj), popasym: $(opt.popasym), δk: $(opt.δk)");
    println(io, "q₀: $(opt.q₀), k₀: $(opt.k₀), a₀: $(opt.a₀), ga₀: $(opt.ga₀), δₐ: $(opt.δₐ)");
    println(io, "Emissions Parameters");
    println(io, "gσ₁: $(opt.gσ₁), δσ: $(opt.δσ), eland₀: $(opt.eland₀)");
    println(io, "deland: $(opt.deland), e₀: $(opt.e₀), μ₀: $(opt.μ₀)");
    println(io, "Carbon Cycle");
    println(io, "mat₀: $(opt.mat₀), mu₀: $(opt.mu₀), ml₀: $(opt.ml₀)");
    println(io, "mateq: $(opt.mateq), mueq: $(opt.mueq), mleq: $(opt.mleq)");
    println(io, "Flow Parameters");
    println(io, "ϕ₁₂: $(opt.ϕ₁₂), ϕ₂₃: $(opt.ϕ₂₃)");
    println(io, "Climate Model Parameters");
    println(io, "t2xco2: $(opt.t2xco2), fₑₓ0: $(opt.fₑₓ0), fₑₓ1: $(opt.fₑₓ1)");
    println(io, "tocean₀: $(opt.tocean₀), tatm₀: $(opt.tatm₀), ξ₁: $(opt.ξ₁)");
    println(io, "ξ₃: $(opt.ξ₃), ξ₄: $(opt.ξ₄), η: $(opt.η)");
    println(io, "Climate Damage Parameters");
    println(io, "ψ₁₀: $(opt.ψ₁₀), ψ₁: $(opt.ψ₁), ψ₂: $(opt.ψ₂), ψ₃: $(opt.ψ₃)");
    println(io, "Abatement Cost");
    println(io, "θ₂: $(opt.θ₂), pback: $(opt.pback), gback: $(opt.gback), limμ: $(opt.limμ)");
    println(io, "tnopol: $(opt.tnopol), cprice₀: $(opt.cprice₀), gcprice: $(opt.gcprice)");
    println(io, "Fossil Fuel Availability");
    println(io, "fosslim: $(opt.fosslim)");
    println(io, "Scaling Parameters");
    print(io, "scale1: $(opt.scale1), scale2: $(opt.scale2)");
end

@extend immutable ParametersV2016 <: Parameters
    pbacktime::Array{Float64,1} # Backstop price
    cpricebase::Array{Float64,1} # Carbon price in base case
    rr::Array{Float64,1} # Average utility social discount rate
    optlrsav::Float64 # Optimal savings rate
    ψ₂::JuMP.NonlinearParameter
    cumtree::Array{Float64,1} # Cumulative from land
end

function Base.show(io::IO, ::MIME"text/plain", opt::ParametersV2016)
    println(io, "Calculated Parameters for 2016 versions");
    println(io, "Optimal savings rate: $(opt.optlrsav)");
    println(io, "Carbon cycle transition matrix coefficients");
    println(io, "ϕ₁₁: $(opt.ϕ₁₁), ϕ₂₁: $(opt.ϕ₂₁), ϕ₂₂: $(opt.ϕ₂₂), ϕ₃₂: $(opt.ϕ₃₂), ϕ₃₃: $(opt.ϕ₃₃)");
    println(io, "2015 Carbon intensity: $(opt.σ₀)");
    println(io, "Climate model parameter: $(opt.λ)");
    println(io, "Backstop price: $(opt.pbacktime)");
    println(io, "Growth rate of productivity: $(opt.gₐ)");
    println(io, "Emissions from deforestation: $(opt.Etree)");
    println(io, "Avg utility social discout rate: $(opt.rr)");
    println(io, "Base case carbon price: $(opt.cpricebase)");
    println(io, "Population and labour: $(opt.L)");
    println(io, "Total factor productivity: $(opt.A)");
    println(io, "Δσ: $(opt.gσ)");
    println(io, "σ: $(opt.σ)");
    println(io, "cumtree: $(opt.cumtree)");
    println(io, "θ₁: $(opt.θ₁)");
    print(io, "Exogenious forcing: $(opt.fₑₓ)");
end

@extend struct VariablesV2016 <: Variables
    Eind::Array{JuMP.Variable,1} # Industrial emissions (GtCO2 per year)
    Ω::Array{JuMP.Variable,1} # Damages as fraction of gross output
    Λ::Array{JuMP.Variable,1} # Cost of emissions reductions  (trillions 2005 USD per year)
    CPRICE::Array{JuMP.Variable,1} # Carbon price (2005$ per ton of CO2)
    CEMUTOTPER::Array{JuMP.Variable,1} # Period utility
    CCATOT::Array{JuMP.Variable,1} # Total carbon emissions (GTC)
end

@extend struct EquationsV2016 <: Equations
    cc::Array{JuMP.ConstraintRef,1} # Output Consumption
end

function assign_scenario(s::OptimalPriceScenario, version::Version, model::JuMP.Model, config::OptionsV2016, params::ParametersV2016, vars::VariablesV2016)
    setupperbound(vars.μ[1], config.μ₀);
end

function assign_scenario(s::Scenario, version::Version, model::JuMP.Model, config::OptionsV2016, params::ParametersV2016, vars::VariablesV2016)
    error("$(s) is not a valid scenario for $(version)");
end

include("Results2016.jl")

include("2016R.jl")
include("2016R2.jl")
