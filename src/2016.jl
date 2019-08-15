@extend struct ParametersV2016 <: Parameters
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
    Eind::Array{JuMP.VariableRef,1} # Industrial emissions (GtCO2 per year)
    Ω::Array{JuMP.VariableRef,1} # Damages as fraction of gross output
    Λ::Array{JuMP.VariableRef,1} # Cost of emissions reductions  (trillions 2005 USD per year)
    CPRICE::Array{JuMP.VariableRef,1} # Carbon price (2005$ per ton of CO2)
    CEMUTOTPER::Array{JuMP.VariableRef,1} # Period utility
    CCATOT::Array{JuMP.VariableRef,1} # Total carbon emissions (GTC)
end

@extend struct EquationsV2016 <: Equations
    cc::Array{JuMP.ConstraintRef,1} # Output Consumption
end

include("Scenarios2016.jl")
include("Results2016.jl")

include("2016R.jl")
include("2016R2.jl")
