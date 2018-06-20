immutable V2016R <: Version end

Base.show(io::IO, v::V2016R) = print(io, "v2016R beta")

"""
    v2016R()

Identifier for the 2016R beta version of the model.
Note that this is a beta version following `DICE2016R-091916ap.gms`.

# Examples
```jldoctest
julia> v2016R()
v2016R beta
```
"""
function v2016R()
    V2016R()
end

export v2016R

@extend immutable OptionsV2016 <: Options
    ψ₁₀::Float64 #Initial damage intercept
end

function options(version::V2016R;
    N::Int = 100, #Number of years to calculate (from 2015 onwards)
    tstep::Int = 5, #Years per Period
    α::Float64 = 1.45, #Elasticity of marginal utility of consumption
    ρ::Float64 = 0.015, #Initial rate of social time preference per year ρ
    γₑ::Float64 = 0.3, #Capital elasticity in production function
    pop₀::Int = 7403, #Initial world population 2015 (millions)
    popadj::Float64 = 0.134, #Growth rate to calibrate to 2050 pop projection
    popasym::Int = 11500, #Asymptotic population (millions)
    δk::Float64 = 0.1, #Depreciation rate on capital (per year)
    q₀::Float64 = 105.5, #Initial world gross output 2015 (trill 2010 USD)
    k₀::Float64 = 223.0, #Initial capital value 2015 (trill 2010 USD)
    a₀::Float64 = 5.115, #Initial level of total factor productivity
    ga₀::Float64 = 0.076, #Initial growth rate for TFP per 5 years
    δₐ::Float64 = 0.005, #Decline rate of TFP per 5 years
    gσ₁::Float64 = -0.0152, #Initial growth of sigma (continuous per year)
    δσ::Float64 = -0.001, #Decline rate of decarbonization per period
    eland₀::Float64 = 2.6, #Carbon emissions from land 2015 (GtCO2 per year)
    deland::Float64 = 0.115, #Decline rate of land emissions (per period)
    e₀::Float64 = 35.85, #Industrial emissions 2015 (GtCO2 per year)
    μ₀::Float64 = 0.03, #Initial emissions control rate for base case 2015
    mat₀::Float64 = 851.0, #Initial Concentration in atmosphere 2015 (GtC)
    mu₀::Float64 = 460.0, #Initial Concentration in upper strata 2015 (GtC)
    ml₀::Float64 = 1740.0, #Initial Concentration in lower strata 2015 (GtC)
    mateq::Float64 = 588.0, #Equilibrium concentration atmosphere  (GtC)
    mueq::Float64 = 360.0, #Equilibrium concentration in upper strata (GtC)
    mleq::Float64 = 1720.0, #Equilibrium concentration in lower strata (GtC)
    ϕ₁₂::Float64 = 0.12, #Carbon cycle transition matrix coefficient
    ϕ₂₃::Float64 = 0.007, #Carbon cycle transition matrix coefficient
    t2xco2::Float64 = 3.1, #Equilibrium temp impact (oC per doubling CO2)
    fₑₓ0::Float64 = 0.5, #2015 forcings of non-CO2 GHG (Wm-2)
    fₑₓ1::Float64 = 1.0, #2100 forcings of non-CO2 GHG (Wm-2)
    tocean₀::Float64 = 0.0068, #Initial lower stratum temp change (C from 1900)
    tatm₀::Float64 = 0.85, #Initial atmospheric temp change (C from 1900)
    ξ₁::Float64 = 0.1005, #Climate equation coefficient for upper level
    ξ₃::Float64 = 0.088, #Transfer coefficient upper to lower stratum
    ξ₄::Float64 = 0.025, #Transfer coefficient for lower level
    η::Float64 = 3.6813, #Forcings of equilibrium CO2 doubling (Wm-2)
    ψ₁₀::Float64 = 0.0, #Initial damage intercept
    ψ₁::Float64 = 0.0, #Damage intercept
    ψ₂::Float64 = 0.00236, #Damage quadratic term
    ψ₃::Float64 = 2.0, #Damage exponent
    θ₂::Float64 = 2.6, #Exponent of control cost function
    pback::Float64 = 550.0, #Cost of backstop 2010$ per tCO2 2015
    gback::Float64 = 0.025, #Initial cost decline backstop cost per period
    limμ::Float64 = 1.2, #Upper limit on control rate after 2150
    tnopol::Float64 = 45.0, #Period before which no emissions controls base
    cprice₀::Float64 = 2.0, #Initial base carbon price (2010$ per tCO2)
    gcprice::Float64 = 0.02, #Growth rate of base carbon price per year
    fosslim::Float64 = 6000.0, #Maximum cumulative extraction fossil fuels (GtC)
    scale1::Float64 = 0.0302455265681763, #Multiplicative scaling coefficient
    scale2::Float64 = -10993.704) #Additive scaling coefficient
    OptionsV2016(N,tstep,α,ρ,γₑ,pop₀,popadj,popasym,δk,q₀,k₀,a₀,ga₀,δₐ,gσ₁,δσ,eland₀,deland,e₀,μ₀,mat₀,mu₀,ml₀,mateq,mueq,mleq,ϕ₁₂,ϕ₂₃,t2xco2,fₑₓ0,fₑₓ1,tocean₀,tatm₀,ξ₁,ξ₃,ξ₄,η,ψ₁,ψ₂,ψ₃,θ₂,pback,gback,limμ,tnopol,cprice₀,gcprice,fosslim,scale1,scale2,ψ₁₀)
end

function Base.show(io::IO, ::MIME"text/plain", opt::OptionsV2016)
    println(io, "Options for 2016R beta version");
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

#NOTE: partfract removed, cumtree added, fₑₓ timing dropped by 1. issue #1.
immutable ParametersV2016 <: Parameters
    optlrsav::Float64 # Optimal savings rate
    ϕ₁₁::Float64 # Carbon cycle transition matrix coefficient
    ϕ₂₁::Float64 # Carbon cycle transition matrix coefficient
    ϕ₂₂::Float64 # Carbon cycle transition matrix coefficient
    ϕ₃₂::Float64 # Carbon cycle transition matrix coefficient
    ϕ₃₃::Float64 # Carbon cycle transition matrix coefficient
    σ₀::Float64 # Carbon intensity 2010 (kgCO2 per output 2010 USD 2010)
    λ::Float64 # Climate model parameter
    ψ₂::JuMP.NonlinearParameter
    pbacktime::Array{Float64,1} # Backstop price
    gₐ::Array{Float64,1} # Growth rate of productivity from 0 to N
    Etree::Array{Float64,1} # Emissions from deforestation
    rr::Array{Float64,1} # Average utility social discount rate
    cpricebase::Array{Float64,1} # Carbon price in base case
    L::Array{Float64,1} # Level of population and labor
    A::Array{Float64,1} # Level of total factor productivity
    gσ::Array{Float64,1} # Change in sigma (cumulative improvement of energy efficiency)
    σ::Array{Float64,1} # CO2-equivalent-emissions output ratio
    cumtree::Array{Float64,1} # Cumulative from land
    θ₁::Array{Float64,1} # Adjusted cost for backstop
    fₑₓ::Array{Float64,1} # Exogenous forcing for other greenhouse gases
end


function generate_parameters(c::OptionsV2016, model::JuMP.Model)
    optlrsav::Float64 = (c.δk + .004)/(c.δk + .004c.α + c.ρ)*c.γₑ; # Optimal savings rate
    ϕ₁₁::Float64 = 1 - c.ϕ₁₂; # Carbon cycle transition matrix coefficient
    ϕ₂₁::Float64 = c.ϕ₁₂*c.mateq/c.mueq; # Carbon cycle transition matrix coefficient
    ϕ₂₂::Float64 = 1 - ϕ₂₁ - c.ϕ₂₃; # Carbon cycle transition matrix coefficient
    ϕ₃₂::Float64 = c.ϕ₂₃*c.mueq/c.mleq; # Carbon cycle transition matrix coefficient
    ϕ₃₃::Float64 = 1 - ϕ₃₂; # Carbon cycle transition matrix coefficient
    σ₀::Float64 = c.e₀/(c.q₀*(1-c.μ₀)); # Carbon intensity 2010 (kgCO2 per output 2010 USD 2010)
    λ::Float64 = c.η/c.t2xco2; # Climate model parameter

    @NLparameter(model, ψ₂ == c.ψ₂);

    # Backstop price
    pbacktime = Array{Float64}(c.N);
    # Growth rate of productivity from 0 to N
    gₐ = Array{Float64}(c.N);
    # Emissions from deforestation
    Etree = Array{Float64}(c.N);
    # Average utility social discount rate
    rr = Array{Float64}(c.N);
    # Carbon price in base case
    cpricebase = Array{Float64}(c.N);

    for i in 1:c.N
        pbacktime[i] = c.pback*(1-c.gback)^(i-1);
        gₐ[i] = c.ga₀*exp.(-c.δₐ*5*(i-1));
        Etree[i] = c.eland₀*(1-c.deland)^(i-1);
        rr[i] = 1/((1+c.ρ)^(c.tstep*(i-1)));
        cpricebase[i] = c.cprice₀*(1+c.gcprice)^(5*(i-1));
    end

    # Initial conditions and offset required
    # Level of population and labor
    L = Array{Float64}(c.N);
    L[1] = c.pop₀;
    # Level of total factor productivity
    A = Array{Float64}(c.N);
    A[1] = c.a₀;
    # Change in sigma (cumulative improvement of energy efficiency)
    gσ = Array{Float64}(c.N);
    gσ[1] = c.gσ₁;
    # CO2-equivalent-emissions output ratio
    σ = Array{Float64}(c.N);
    σ[1] = σ₀;

    # Cumulative from land
    cumtree = Array{Float64}(c.N);
    cumtree[1] = 100.0;

    for i in 1:c.N-1
        L[i+1] = L[i]*(c.popasym/L[i])^c.popadj;
        A[i+1] = A[i]/(1-gₐ[i]);
        gσ[i+1] = gσ[i]*((1+c.δσ)^c.tstep);
        σ[i+1] = σ[i]*exp.(gσ[i]*c.tstep);
        cumtree[i+1] = cumtree[i]+Etree[i]*(5/3.666);
    end

    # Adjusted cost for backstop
    θ₁ = Array{Float64}(c.N);
    # Exogenous forcing for other greenhouse gases
    fₑₓ = Array{Float64}(c.N);

    for i in 1:c.N
        θ₁[i] = pbacktime[i]*σ[i]/c.θ₂/1000.0;
        fₑₓ[i] = if i < 18
                        c.fₑₓ0+(1/17)*(c.fₑₓ1-c.fₑₓ0)*(i-1)
                    else
                        c.fₑₓ1-c.fₑₓ0
                    end;
    end
    ParametersV2016(optlrsav,ϕ₁₁,ϕ₂₁,ϕ₂₂,ϕ₃₂,ϕ₃₃,σ₀,λ,ψ₂,pbacktime,gₐ,Etree,rr,cpricebase,L,A,gσ,σ,cumtree,θ₁,fₑₓ)
end

function Base.show(io::IO, ::MIME"text/plain", opt::ParametersV2016)
    println(io, "Calculated Parameters for 2016R beta");
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

struct VariablesV2016 <: Variables
    μ::Array{JuMP.Variable,1} # Emission control rate GHGs
    FORC::Array{JuMP.Variable,1} # Increase in radiative forcing (watts per m2 from 1900)
    Tₐₜ::Array{JuMP.Variable,1} # Increase temperature of atmosphere (degrees C from 1900)
    Tₗₒ::Array{JuMP.Variable,1} # Increase temperatureof lower oceans (degrees C from 1900)
    Mₐₜ::Array{JuMP.Variable,1} # Carbon concentration increase in atmosphere (GtC from 1750)
    Mᵤₚ::Array{JuMP.Variable,1} # Carbon concentration increase in shallow oceans (GtC from 1750)
    Mₗₒ::Array{JuMP.Variable,1} # Carbon concentration increase in lower oceans (GtC from 1750)
    E::Array{JuMP.Variable,1} # Total CO2 emissions (GtCO2 per year)
    Eind::Array{JuMP.Variable,1} # Industrial emissions (GtCO2 per year)
    C::Array{JuMP.Variable,1} # Consumption (trillions 2010 US dollars per year)
    K::Array{JuMP.Variable,1} # Capital stock (trillions 2010 US dollars)
    CPC::Array{JuMP.Variable,1} # Per capita consumption (thousands 2010 USD per year)
    I::Array{JuMP.Variable,1} # Investment (trillions 2010 USD per year)
    S::Array{JuMP.Variable,1} # Gross savings rate as fraction of gross world product
    RI::Array{JuMP.Variable,1} # Real interest rate (per annum)
    Y::Array{JuMP.Variable,1} # Gross world product net of abatement and damages (trillions 2010 USD per year)
    YGROSS::Array{JuMP.Variable,1} # Gross world product GROSS of abatement and damages (trillions 2010 USD per year)
    YNET::Array{JuMP.Variable,1} # Output net of damages equation (trillions 2010 USD per year)
    DAMAGES::Array{JuMP.Variable,1} # Damages (trillions 2010 USD per year)
    Ω::Array{JuMP.Variable,1} # Damages as fraction of gross output
    Λ::Array{JuMP.Variable,1} # Cost of emissions reductions  (trillions 2010 USD per year)
    MCABATE::Array{JuMP.Variable,1} # Marginal cost of abatement (2010$ per ton CO2)
    CCA::Array{JuMP.Variable,1} # Cumulative industrial carbon emissions (GTC)
    CCATOT::Array{JuMP.Variable,1} # Total carbon emissions (GTC)
    PERIODU::Array{JuMP.Variable,1} # One period utility function
    CPRICE::Array{JuMP.Variable,1} # Carbon price (2010$ per ton of CO2)
    CEMUTOTPER::Array{JuMP.Variable,1} # Period utility
    UTILITY::JuMP.Variable # Welfare function
end

#NOTE: CCATOT and the Tₐₜ upper bound is the only difference tho the 2013R models.
#TODO: Concrete abstractions. See issue #1.
function model_vars(version::V2016R, model::JuMP.Model, N::Int64, cca_ubound::Float64, μ_ubound::Array{Float64,1}, cprice_ubound::Array{Float64,1})
    # Variables #
    @variable(model, 0.0 <= μ[i=1:N] <= μ_ubound[i]); # Emission control rate GHGs
    @variable(model, FORC[1:N]); # Increase in radiative forcing (watts per m2 from 1900)
    @variable(model, 0.0 <= Tₐₜ[1:N] <= 12.0); # Increase temperature of atmosphere (degrees C from 1900)
    @variable(model, -1.0 <= Tₗₒ[1:N] <= 20.0); # Increase temperatureof lower oceans (degrees C from 1900)
    @variable(model, Mₐₜ[1:N] >= 10.0); # Carbon concentration increase in atmosphere (GtC from 1750)
    @variable(model, Mᵤₚ[1:N] >= 100.0); # Carbon concentration increase in shallow oceans (GtC from 1750)
    @variable(model, Mₗₒ[1:N] >= 1000.0); # Carbon concentration increase in lower oceans (GtC from 1750)
    @variable(model, E[1:N]); # Total CO2 emissions (GtCO2 per year)
    @variable(model, Eind[1:N]); # Industrial emissions (GtCO2 per year)
    @variable(model, C[1:N] >= 2.0); # Consumption (trillions 2010 US dollars per year)
    @variable(model, K[1:N] >= 1.0); # Capital stock (trillions 2010 US dollars)
    @variable(model, CPC[1:N] >= 0.01); #  Per capita consumption (thousands 2010 USD per year)
    @variable(model, I[1:N] >= 0.0); # Investment (trillions 2010 USD per year)
    @variable(model, S[1:N]); # Gross savings rate as fraction of gross world product
    @variable(model, RI[1:N]); # Real interest rate (per annum)
    @variable(model, Y[1:N] >= 0.0); # Gross world product net of abatement and damages (trillions 2010 USD per year)
    @variable(model, YGROSS[1:N] >= 0.0); # Gross world product GROSS of abatement and damages (trillions 2010 USD per year)
    @variable(model, YNET[1:N]); # Output net of damages equation (trillions 2010 USD per year)
    @variable(model, DAMAGES[1:N]); # Damages (trillions 2010 USD per year)
    @variable(model, Ω[1:N]); # Damages as fraction of gross output
    @variable(model, Λ[1:N]); # Cost of emissions reductions  (trillions 2010 USD per year)
    @variable(model, MCABATE[1:N]); # Marginal cost of abatement (2010$ per ton CO2)
    @variable(model, CCA[1:N] <= cca_ubound); # Cumulative industrial carbon emissions (GTC)
    @variable(model, CCATOT[1:N]); # Total carbon emissions (GTC)
    @variable(model, PERIODU[1:N]); # One period utility function
    @variable(model, CPRICE[i=1:N] <= cprice_ubound[i]); # Carbon price (2010$ per ton of CO2)
    @variable(model, CEMUTOTPER[1:N]); # Period utility
    @variable(model, UTILITY); # Welfare function
    VariablesV2016(μ,FORC,Tₐₜ,Tₗₒ,Mₐₜ,Mᵤₚ,Mₗₒ,E,Eind,C,K,CPC,I,S,RI,Y,YGROSS,YNET,DAMAGES,Ω,Λ,MCABATE,CCA,CCATOT,PERIODU,CPRICE,CEMUTOTPER,UTILITY)
end

struct EquationsV2016 <: Equations
    eeq::Array{JuMP.ConstraintRef,1} # Emissions Equation
    cc::Array{JuMP.ConstraintRef,1} # Output Consumption
end

#TODO: I think we can drop the version requirement here.
#NOTE: Addition CCATOT, Λ looses partfract term issue #1
#NOTE: MCABATE and CPRICE are the same in the original...
function model_eqs(version::V2016R, model::JuMP.Model, config::OptionsV2016, params::ParametersV2016, vars::VariablesV2016)
    N = config.N;
    # Equations #
    # Emissions Equation
    eeq = @constraint(model, [i=1:N], vars.E[i] == vars.Eind[i] + params.Etree[i]);
    # Industrial Emissions
    @constraint(model, [i=1:N], vars.Eind[i] == params.σ[i] * vars.YGROSS[i] * (1-vars.μ[i]));
    # Cumulative total carbon emissions
    @constraint(model, [i=1:N], vars.CCATOT[i] == vars.CCA[i] + params.cumtree[i]);
    # Radiative forcing equation
    @NLconstraint(model, [i=1:N], vars.FORC[i] == config.η * (log(vars.Mₐₜ[i]/588.0)/log(2)) + params.fₑₓ[i]);
    # Equation for damage fraction
    @NLconstraint(model, [i=1:N], vars.Ω[i] == config.ψ₁*vars.Tₐₜ[i]+params.ψ₂*vars.Tₐₜ[i]^config.ψ₃);
    # Damage equation
    @constraint(model, [i=1:N], vars.DAMAGES[i] == vars.YGROSS[i]*vars.Ω[i]);
    # Cost of exissions reductions equation
    @NLconstraint(model, [i=1:N], vars.Λ[i] == vars.YGROSS[i] * params.θ₁[i] * vars.μ[i]^config.θ₂);
    # Equation for MC abatement
    @NLconstraint(model, [i=1:N], vars.MCABATE[i] == params.pbacktime[i] * vars.μ[i]^(config.θ₂-1));
    # Carbon price equation from abatement
    @NLconstraint(model, [i=1:N], vars.CPRICE[i] == params.pbacktime[i] * vars.μ[i]^(config.θ₂-1));
    # Output gross equation
    @NLconstraint(model, [i=1:N], vars.YGROSS[i] == params.A[i]*(params.L[i]/1000.0)^(1-config.γₑ)*vars.K[i]^config.γₑ);
    # Output net of damages equation
    @constraint(model, [i=1:N], vars.YNET[i] == vars.YGROSS[i]*(1-vars.Ω[i]));
    # Output net equation
    @constraint(model, [i=1:N], vars.Y[i] == vars.YNET[i] - vars.Λ[i]);
    # Consumption equation
    cc = @constraint(model, [i=1:N], vars.C[i] == vars.Y[i] - vars.I[i]);
    # Per capita consumption definition
    @constraint(model, [i=1:N], vars.CPC[i] == 1000.0 * vars.C[i] / params.L[i]);
    # Savings rate equation
    @constraint(model, [i=1:N], vars.I[i] == vars.S[i] * vars.Y[i]);
    # Period utility
    @constraint(model, [i=1:N], vars.CEMUTOTPER[i] == vars.PERIODU[i] * params.L[i] * params.rr[i]);
    # Instantaneous utility function equation
    @NLconstraint(model, [i=1:N], vars.PERIODU[i] == ((vars.C[i]*1000.0/params.L[i])^(1-config.α)-1)/(1-config.α)-1);

    # Equations (offset) #
    # Cumulative carbon emissions
    @constraint(model, [i=1:N-1], vars.CCA[i+1] == vars.CCA[i] + vars.Eind[i]*(5/3.666));
    # Atmospheric concentration equation
    @constraint(model, [i=1:N-1], vars.Mₐₜ[i+1] == vars.Mₐₜ[i]*params.ϕ₁₁ + vars.Mᵤₚ[i]*params.ϕ₂₁ + vars.E[i]*(5/3.666));
    # Lower ocean concentration
    @constraint(model, [i=1:N-1], vars.Mₗₒ[i+1] == vars.Mₗₒ[i]*params.ϕ₃₃ + vars.Mᵤₚ[i]*config.ϕ₂₃);
    # Shallow ocean concentration
    @constraint(model, [i=1:N-1], vars.Mᵤₚ[i+1] == vars.Mₐₜ[i]*config.ϕ₁₂ + vars.Mᵤₚ[i]*params.ϕ₂₂ + vars.Mₗₒ[i]*params.ϕ₃₂);
    # Temperature-climate equation for atmosphere
    @constraint(model, [i=1:N-1], vars.Tₐₜ[i+1] == vars.Tₐₜ[i] + config.ξ₁*((vars.FORC[i+1]-params.λ*vars.Tₐₜ[i])-(config.ξ₃*(vars.Tₐₜ[i]-vars.Tₗₒ[i]))));
    # Temperature-climate equation for lower oceans
    @constraint(model, [i=1:N-1], vars.Tₗₒ[i+1] == vars.Tₗₒ[i] + config.ξ₄*(vars.Tₐₜ[i]-vars.Tₗₒ[i]));
    # Capital balance equation
    @constraint(model, [i=1:N-1], vars.K[i+1] <= (1-config.δk)^config.tstep * vars.K[i] + config.tstep*vars.I[i]);
    # Interest rate equation
    @NLconstraint(model, [i=1:N-1], vars.RI[i] == (1+config.ρ)*(vars.CPC[i+1]/vars.CPC[i])^(config.α/config.tstep)-1);

    # Savings rate for asympotic equilibrium
    @constraint(model, vars.S[i=N-10:N] .== params.optlrsav);
    # Initial conditions
    @constraint(model, vars.CCA[1] == 400.0);
    @constraint(model, vars.K[1] == config.k₀);
    @constraint(model, vars.Mₐₜ[1] == config.mat₀);
    @constraint(model, vars.Mᵤₚ[1] == config.mu₀);
    @constraint(model, vars.Mₗₒ[1] == config.ml₀);
    @constraint(model, vars.Tₐₜ[1] == config.tatm₀);
    @constraint(model, vars.Tₗₒ[1] == config.tocean₀);

    @constraint(model, vars.UTILITY == config.tstep * config.scale1 * sum(vars.CEMUTOTPER[i] for i=1:N) + config.scale2);

    # Objective function
    @objective(model, Max, vars.UTILITY);

    EquationsV2016(eeq,cc)
end

include("Scenarios2016R.jl")
include("2016Results.jl")

function solve(scenario::Scenario, version::V2016R;
    config::OptionsV2016 = options(version),
    solver = IpoptSolver(print_level=3, max_iter=99900,print_frequency_iter=50,sb="yes"))

    model = JuMP.Model(solver = solver);
    params = generate_parameters(config, model);

    # Rate limit
    μ_ubound = [if t < 30 1.0 else config.limμ end for t in 1:config.N];
    cprice_ubound = fill(Inf, config.N); #No initial price bound

    variables = model_vars(version, model, config.N, config.fosslim, μ_ubound, cprice_ubound);

    equations = model_eqs(version, model, config, params, variables);

    assign_scenario(scenario, model, config, params, variables);

    JuMP.solve(model);
    JuMP.solve(model);
    JuMP.solve(model);

    results = model_results(model, config, params, variables, equations);

    DICENarrative(config,params,model,scenario,version,variables,equations,results)
end
