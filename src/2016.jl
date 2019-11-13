@extend struct ParametersV2016 <: Parameters
    pbacktime::Array{Float64,1} # Backstop price
    cpricebase::Array{Float64,1} # Carbon price in base case
    rr::Array{Float64,1} # Average utility social discount rate
    optlrsav::Float64 # Optimal savings rate
    ψ₂::JuMP.NonlinearParameter
    cumtree::Array{Float64,1} # Cumulative from land
end

function Base.show(io::IO, opt::ParametersV2016)
    ctx = IOContext(io, :limit => true, :compact => true);
    println(io, "Calculated Parameters for 2016 versions.");
    println(io, "Optimal savings rate: $(opt.optlrsav)");
    println(io, "Carbon cycle transition matrix coefficients");
    println(io, "ϕ₁₁: $(opt.ϕ₁₁), ϕ₂₁: $(opt.ϕ₂₁), ϕ₂₂: $(opt.ϕ₂₂), ϕ₃₂: $(opt.ϕ₃₂), ϕ₃₃: $(opt.ϕ₃₃)");
    println(io, "2015 Carbon intensity: $(opt.σ₀)");
    println(io, "Climate model parameter: $(opt.λ)");
    println(io, "Backstop price: ");
    show(ctx, opt.pbacktime);
    println(io, "");
    print(io, "Growth rate of productivity: ");
    show(ctx, opt.gₐ);
    println(io, "");
    print(io, "Emissions from deforestation: ");
    show(ctx, opt.Etree);
    println(io, "");
    print(io, "Avg utility social discout rate: ");
    show(ctx, opt.rr);
    println(io, "");
    print(io, "Base case carbon price: ");
    show(ctx, opt.cpricebase);
    println(io, "");
    print(io, "Population and labour: ");
    show(ctx, opt.L);
    println(io, "");
    print(io, "Total factor productivity: ");
    show(ctx, opt.A);
    println(io, "");
    print(io, "Δσ: ");
    show(ctx, opt.gσ);
    println(io, "");
    print(io, "σ: ");
    show(ctx, opt.σ);
    println(io, "");
    print(io, "cumtree: ");
    show(ctx, opt.cumtree);
    println(io, "");
    print(io, "θ₁: ");
    show(ctx, opt.θ₁);
    println(io, "");
    print(io, "Exogenious forcing: ");
    show(ctx, opt.fₑₓ);
end

@extend struct OptionsV2016R <: Options
    e₀::Float64 #Industrial emissions 2015 (GtCO2 per year)
    μ₀::Float64 #Initial emissions control rate for base case 2015
    tnopol::Float64 #Period before which no emissions controls base
    cprice₀::Float64 #Initial base carbon price (2010$ per tCO2)
    gcprice::Float64 #Growth rate of base carbon price per year
    ψ₁₀::Float64 #Initial damage intercept
end

@extend struct OptionsV2016R2 <: Options
    e₀::Float64 #Industrial emissions 2015 (GtCO2 per year)
    μ₀::Float64 #Initial emissions control rate for base case 2015
    tnopol::Float64 #Period before which no emissions controls base
    cprice₀::Float64 #Initial base carbon price (2010$ per tCO2)
    gcprice::Float64 #Growth rate of base carbon price per year
    ψ₁₀::Float64 #Initial damage intercept
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
