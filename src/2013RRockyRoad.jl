immutable RockyRoadOptions <: Options
    N::Int #Number of years to calculate (from 2010 onwards)
    tstep::Int #Years per Period
    α::Float64 #Elasticity of marginal utility of consumption
    ρ::Float64 #Initial rate of social time preference per year ρ
    γₑ::Float64 #Capital elasticity in production function
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
    ξ₁₀::Float64 #Initial Climate equation coefficient for upper level
    ξ₁β::Float64 #Regression slope coef beta (SoA~Equil TSC)
    ξ₁::Float64 #Climate equation coefficient for upper level
    ξ₃::Float64 #Transfer coefficient upper to lower stratum
    ξ₄::Float64 #Transfer coefficient for lower level
    η::Float64 #Forcings of equilibrium CO2 doubling (Wm-2)
    ψ₁₀::Float64 #Initial damage intercept
    ψ₂₀::Float64 #Initial damage quadratic term
    ψ₁::Float64 #Damage intercept (Hotelling-No Damages)
    ψ₂::Float64 #Damage quadratic term (Hotelling-No Damages)
    ψ₃::Float64 #Damage exponent
    θ₂::Float64 #Exponent of control cost function
    pback::Float64 #Cost of backstop 2005$ per tCO2 2010
    gback::Float64 #Initial cost decline backstop cost per period
    limμ::Float64 #Upper limit on control rate after 2150
    tnopol::Float64 #Period before which no emissions controls base
    cprice₀::Float64 #Initial base carbon price (2005$ per tCO2)
    gcprice::Float64 #Growth rate of base carbon price per year
    periodfullpart::Float64 #Period at which have full participation
    partfract2010::Float64 #Fraction of emissions under control in 2010
    partfractfull::Float64 #Fraction of emissions under control at full time
    fosslim::Float64 #Maximum cumulative extraction fossil fuels (GtC)
    scale1::Float64 #Multiplicative scaling coefficient
    scale2::Float64 #Additive scaling coefficient
end

function dice_options(version::V2013R{RockyRoadFlavour};
    N::Int = 60, #Number of years to calculate (from 2010 onwards)
    tstep::Int = 5, #Years per Period
    α::Float64 = 1.45, #Elasticity of marginal utility of consumption
    ρ::Float64 = 0.015, #Initial rate of social time preference per year ρ
    γₑ::Float64 = 0.3, #Capital elasticity in production function
    pop₀::Int = 6838, #Initial world population (millions)
    popadj::Float64 = 0.134, #Growth rate to calibrate to 2050 pop projection
    popasym::Int = 10500, #Asymptotic population (millions)
    δk::Float64 = 0.1, #Depreciation rate on capital (per year)
    q₀::Float64 = 63.69, #Initial world gross output (trill 2005 USD)
    k₀::Float64 = 135.0, #Initial capital value (trill 2005 USD)
    a₀::Float64 = 3.8, #Initial level of total factor productivity
    ga₀::Float64 = 0.079, #Initial growth rate for TFP per 5 years
    δₐ::Float64 = 0.006, #Decline rate of TFP per 5 years
    gσ₁::Float64 = -0.01, #Initial growth of sigma (continuous per year)
    δσ::Float64 = -0.001, #Decline rate of decarbonization per period
    eland₀::Float64 = 3.3, #Carbon emissions from land 2010 (GtCO2 per year)
    deland::Float64 = 0.2, #Decline rate of land emissions (per period)
    e₀::Float64 = 33.61, #Industrial emissions 2010 (GtCO2 per year)
    μ₀::Float64 = 0.039, #Initial emissions control rate for base case 2010
    mat₀::Float64 = 830.4, #Initial Concentration in atmosphere 2010 (GtC)
    mu₀::Float64 = 1527.0, #Initial Concentration in upper strata 2010 (GtC)
    ml₀::Float64 = 10010.0, #Initial Concentration in lower strata 2010 (GtC)
    mateq::Float64 = 588.0, #Equilibrium concentration atmosphere  (GtC)
    mueq::Float64 = 1350.0, #Equilibrium concentration in upper strata (GtC)
    mleq::Float64 = 10000.0, #Equilibrium concentration in lower strata (GtC)
    ϕ₁₂::Float64 = 0.088, #Carbon cycle transition matrix coefficient
    ϕ₂₃::Float64 = 0.0025, #Carbon cycle transition matrix coefficient
    t2xco2::Float64 = 2.9, #Equilibrium temp impact (oC per doubling CO2)
    fₑₓ0::Float64 = 0.25, #2010 forcings of non-CO2 GHG (Wm-2)
    fₑₓ1::Float64 = 0.7, #2100 forcings of non-CO2 GHG (Wm-2)
    tocean₀::Float64 = 0.0068, #Initial lower stratum temp change (C from 1900)
    tatm₀::Float64 = 0.8, #Initial atmospheric temp change (C from 1900)
    ξ₁₀::Float64 = 0.098, #Initial Climate equation coefficient for upper level
    ξ₁β::Float64 = 0.01243, #Regression slope coef beta (SoA~Equil TSC)
    ξ₁::Float64 = 0.098, #Climate equation coefficient for upper level #Note, this is a param later?
    ξ₃::Float64 = 0.088, #Transfer coefficient upper to lower stratum
    ξ₄::Float64 = 0.025, #Transfer coefficient for lower level
    η::Float64 = 3.8, #Forcings of equilibrium CO2 doubling (Wm-2)
    ψ₁₀::Float64 = 0.0, #Initial damage intercept
    ψ₂₀::Float64 = 0.00267, #Initial damage quadratic term
    ψ₁::Float64 = 0.0, #Damage intercept (Hotelling-No Damages)
    ψ₂::Float64 = 0.0, #Damage quadratic term (Hotelling-No Damages)
    ψ₃::Float64 = 2.0, #Damage exponent
    θ₂::Float64 = 2.8, #Exponent of control cost function
    pback::Float64 = 344.0, #Cost of backstop 2005$ per tCO2 2010
    gback::Float64 = 0.025, #Initial cost decline backstop cost per period
    limμ::Float64 = 1.2, #Upper limit on control rate after 2150
    tnopol::Float64 = 45.0, #Period before which no emissions controls base
    cprice₀::Float64 = 1.0, #Initial base carbon price (2005$ per tCO2)
    gcprice::Float64 = 0.02, #Growth rate of base carbon price per year
    periodfullpart::Float64 = 21.0, #Period at which have full participation
    partfract2010::Float64 = 1.0, #Fraction of emissions under control in 2010
    partfractfull::Float64 = 1.0, #Fraction of emissions under control at full time
    fosslim::Float64 = 6000.0, #Maximum cumulative extraction fossil fuels (GtC)
    scale1::Float64 = 0.016408662, #Multiplicative scaling coefficient
    scale2::Float64 = -3855.106895) #Additive scaling coefficient
    RockyRoadOptions(N,tstep,α,ρ,γₑ,pop₀,popadj,popasym,δk,q₀,k₀,a₀,ga₀,δₐ,gσ₁,δσ,eland₀,deland,e₀,μ₀,mat₀,mu₀,ml₀,mateq,mueq,mleq,ϕ₁₂,ϕ₂₃,t2xco2,fₑₓ0,fₑₓ1,tocean₀,tatm₀,ξ₁₀,ξ₁β,ξ₁,ξ₃,ξ₄,η,ψ₁₀,ψ₂₀,ψ₁,ψ₂,ψ₃,θ₂,pback,gback,limμ,tnopol,cprice₀,gcprice,periodfullpart,partfract2010,partfractfull,fosslim,scale1,scale2)
end

function Base.show(io::IO, ::MIME"text/plain", opt::RockyRoadOptions)
    println(io, "Options for Rocky Road 2013R version");
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
    println(io, "tocean₀: $(opt.tocean₀), tatm₀: $(opt.tatm₀), ξ₁₀: $(opt.ξ₁₀), ξ₁β: $(opt.ξ₁β)");
    println(io, "ξ₁: $(opt.ξ₁), ξ₃: $(opt.ξ₃), ξ₄: $(opt.ξ₄), η: $(opt.η)");
    println(io, "Climate Damage Parameters");
    println(io, "ψ₁₀: $(opt.ψ₁₀), ψ₂₀: $(opt.ψ₂₀), ψ₁: $(opt.ψ₁), ψ₂: $(opt.ψ₂), ψ₃: $(opt.ψ₃)");
    println(io, "Abatement Cost");
    println(io, "θ₂: $(opt.θ₂), pback: $(opt.pback), gback: $(opt.gback), limμ: $(opt.limμ)");
    println(io, "tnopol: $(opt.tnopol), cprice₀: $(opt.cprice₀), gcprice: $(opt.gcprice)");
    println(io, "Participation Parameters");
    println(io, "periodfullpart: $(opt.periodfullpart), partfract2010: $(opt.partfract2010), partfractfull: $(opt.partfractfull)");
    println(io, "Fossil Fuel Availability");
    println(io, "fosslim: $(opt.fosslim)");
    println(io, "Scaling Parameters");
    print(io, "scale1: $(opt.scale1), scale2: $(opt.scale2)");
end

immutable RockyRoadParameters <: Parameters
    optlrsav::Float64 # Optimal savings rate
    ϕ₁₁::Float64 # Carbon cycle transition matrix coefficient
    ϕ₂₁::Float64 # Carbon cycle transition matrix coefficient
    ϕ₂₂::Float64 # Carbon cycle transition matrix coefficient
    ϕ₃₂::Float64 # Carbon cycle transition matrix coefficient
    ϕ₃₃::Float64 # Carbon cycle transition matrix coefficient
    σ₀::Float64 # Carbon intensity 2010 (kgCO2 per output 2005 USD 2010)
    λ::Float64 # Climate model parameter
    ξ₁::Float64 # Transient TSC Correction ("Speed of Adjustment Parameter")
    ψ₂::JuMP.NonlinearParameter
    α::JuMP.NonlinearParameter
    ρ::JuMP.NonlinearParameter
    pbacktime::Array{Float64,1} # Backstop price
    gₐ::Array{Float64,1} # Growth rate of productivity from 0 to N
    Etree::Array{Float64,1} # Emissions from deforestation
    rr::Array{Float64,1} # Average utility social discount rate
    cpricebase::Array{Float64,1} # Carbon price in base case
    L::Array{Float64,1} # Level of population and labor
    A::Array{Float64,1} # Level of total factor productivity
    gσ::Array{Float64,1} # Change in sigma (cumulative improvement of energy efficiency)
    σ::Array{Float64,1} # CO2-equivalent-emissions output ratio
    θ₁::Array{Float64,1} # Adjusted cost for backstop
    fₑₓ::Array{Float64,1} # Exogenous forcing for other greenhouse gases
    partfract::Array{JuMP.NonlinearParameter,1} # Fraction of emissions in control regime
end

function generate_parameters(c::RockyRoadOptions, model::JuMP.Model)
    ϕ₁₁::Float64 = 1 - c.ϕ₁₂; # Carbon cycle transition matrix coefficient
    ϕ₂₁::Float64 = c.ϕ₁₂*c.mateq/c.mueq; # Carbon cycle transition matrix coefficient
    ϕ₂₂::Float64 = 1 - ϕ₂₁ - c.ϕ₂₃; # Carbon cycle transition matrix coefficient
    ϕ₃₂::Float64 = c.ϕ₂₃*c.mueq/c.mleq; # Carbon cycle transition matrix coefficient
    ϕ₃₃::Float64 = 1 - ϕ₃₂; # Carbon cycle transition matrix coefficient
    σ₀::Float64 = c.e₀/(c.q₀*(1-c.μ₀)); # Carbon intensity 2010 (kgCO2 per output 2005 USD 2010)
    λ::Float64 = c.η/c.t2xco2; # Climate model parameter
    ξ₁::Float64 = c.ξ₁₀ + c.ξ₁β*(c.t2xco2-2.9); # Transient TSC Correction ("Speed of Adjustment Parameter")

    @NLparameter(model, ψ₂ == c.ψ₂);
    @NLparameter(model, α == c.α);
    @NLparameter(model, ρ == c.ρ);

    optlrsav::Float64 = (c.δk + .004)/(c.δk + .004*getvalue(α) + getvalue(ρ))*c.γₑ; # Optimal savings rate

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
    # Exogenous forcing for other greenhouse gases
    fₑₓ = Array{Float64}(c.N);

    for i in 1:c.N
        pbacktime[i] = c.pback*(1-c.gback)^(i-1);
        gₐ[i] = c.ga₀*exp.(-c.δₐ*5*(i-1));
        Etree[i] = c.eland₀*(1-c.deland)^(i-1);
        rr[i] = 1/((1+getvalue(ρ))^(c.tstep*(i-1)));
        cpricebase[i] = c.cprice₀*(1+c.gcprice)^(5*(i-1));
        fₑₓ[i] = if i < 19
                         c.fₑₓ0+(1/18)*(c.fₑₓ1-c.fₑₓ0)*(i-1)
                     else
                         c.fₑₓ1-c.fₑₓ0
                     end;
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


    for i in 1:c.N-1
        L[i+1] = L[i]*(c.popasym/L[i])^c.popadj;
        A[i+1] = A[i]/(1-gₐ[i]);
        gσ[i+1] = gσ[i]*((1+c.δσ)^c.tstep);
        σ[i+1] = σ[i]*exp.(gσ[i]*c.tstep);
    end

    # Adjusted cost for backstop (Needs σ, hence a separate loop)
    θ₁ = Array{Float64}(c.N);
    for i in 1:c.N
        θ₁[i] = pbacktime[i]*σ[i]/c.θ₂/1000.0;
    end

    # Fraction of emissions in control regime
    pfract = Array{Float64}(c.N);
    for i in 1:c.N
        pfract[i] = if i <= c.periodfullpart
                            c.partfract2010+(c.partfractfull-c.partfract2010)*(i-1)/c.periodfullpart
                       else
                            c.partfractfull
                       end;
    end
    pfract[1] = c.partfract2010;
    @NLparameter(model, partfract[i=1:c.N] == pfract[i]);

    RockyRoadParameters(optlrsav,ϕ₁₁,ϕ₂₁,ϕ₂₂,ϕ₃₂,ϕ₃₃,σ₀,λ,ξ₁,ψ₂,α,ρ,pbacktime,gₐ,Etree,rr,cpricebase,L,A,gσ,σ,θ₁,fₑₓ,partfract)
end

#TODO: Consider adding in NLParameter values here
function Base.show(io::IO, ::MIME"text/plain", opt::RockyRoadParameters)
    println(io, "Calculated Parameters for Rocky Road 2013R");
    println(io, "Optimal savings rate: $(opt.optlrsav)");
    println(io, "Carbon cycle transition matrix coefficients");
    println(io, "ϕ₁₁: $(opt.ϕ₁₁), ϕ₂₁: $(opt.ϕ₂₁), ϕ₂₂: $(opt.ϕ₂₂), ϕ₃₂: $(opt.ϕ₃₂), ϕ₃₃: $(opt.ϕ₃₃)");
    println(io, "2010 Carbon intensity: $(opt.σ₀)");
    println(io, "Climate model parameter: $(opt.λ)");
    println(io, "Transient TSC Correction: $(opt.ξ₁)");
    println(io, "Backstop price: $(opt.pbacktime)");
    println(io, "Growth rate of productivity: $(opt.gₐ)");
    println(io, "Emissions from deforestation: $(opt.Etree)");
    println(io, "Avg utility social discout rate: $(opt.rr)");
    println(io, "Base case carbon price: $(opt.cpricebase)");
    println(io, "Population and labour: $(opt.L)");
    println(io, "Total factor productivity: $(opt.A)");
    println(io, "Δσ: $(opt.gσ)");
    println(io, "σ: $(opt.σ)");
    println(io, "θ₁: $(opt.θ₁)");
    println(io, "Exogenious forcing: $(opt.fₑₓ)");
    print(io, "Fraction of emissions in control regieme: $(getvalue(opt.partfract))");
end

struct RockyRoadEquations <: Equations
    eeq::Array{JuMP.ConstraintRef,1} # Emissions Equation
    yy::Array{JuMP.ConstraintRef,1} # Output net equation
end

function model_eqs(version::V2013R{RockyRoadFlavour}, model::JuMP.Model, config::RockyRoadOptions, params::RockyRoadParameters, vars::Variables)
    #TODO: This is probably similar enough to pull into 2013R.jl. Need to confirm this after all scenarios are implemented.
    #TODO: Consider making all the configuration values NLParameters, so we never have to pass things like ψ₂ directly
    N = config.N;
    # Equations #
    # Emissions Equation
    eeq = @constraint(model, [i=1:N], vars.E[i] == vars.Eind[i] + params.Etree[i]);
    # Industrial Emissions
    @constraint(model, [i=1:N], vars.Eind[i] == params.σ[i] * vars.YGROSS[i] * (1-vars.μ[i]));
    # Radiative forcing equation
    @NLconstraint(model, [i=1:N], vars.FORC[i] == config.η * (log(vars.Mₐₜ[i]/588.0)/log(2)) + params.fₑₓ[i]);
    # Equation for damage fraction
    @NLconstraint(model, [i=1:N], vars.Ω[i] == config.ψ₁*vars.Tₐₜ[i]+params.ψ₂*vars.Tₐₜ[i]^config.ψ₃);
    # Damage equation
    @constraint(model, [i=1:N], vars.DAMAGES[i] == vars.YGROSS[i]*vars.Ω[i]);
    # Cost of exissions reductions equation
    @NLconstraint(model, [i=1:N], vars.Λ[i] == vars.YGROSS[i] * params.θ₁[i] * vars.μ[i]^config.θ₂ * params.partfract[i]^(1-config.θ₂));
    # Equation for MC abatement
    @NLconstraint(model, [i=1:N], vars.MCABATE[i] == params.pbacktime[i] * vars.μ[i]^(config.θ₂-1));
    # Carbon price equation from abatement
    @NLconstraint(model, [i=1:N], vars.CPRICE[i] == params.pbacktime[i] * (vars.μ[i]/params.partfract[i])^(config.θ₂-1));
    # Output gross equation
    @NLconstraint(model, [i=1:N], vars.YGROSS[i] == params.A[i]*(params.L[i]/1000.0)^(1-config.γₑ)*vars.K[i]^config.γₑ);
    # Output net of damages equation
    @constraint(model, [i=1:N], vars.YNET[i] == vars.YGROSS[i]*(1-vars.Ω[i]));
    # Output net equation
    yy = @constraint(model, [i=1:N], vars.Y[i] == vars.YNET[i] - vars.Λ[i]);
    # Consumption equation
    @constraint(model, [i=1:N], vars.C[i] == vars.Y[i] - vars.I[i]);
    # Per capita consumption definition
    @constraint(model, [i=1:N], vars.CPC[i] == 1000.0 * vars.C[i] / params.L[i]);
    # Savings rate equation
    @constraint(model, [i=1:N], vars.I[i] == vars.S[i] * vars.Y[i]);
    # Period utility
    @constraint(model, [i=1:N], vars.CEMUTOTPER[i] == vars.PERIODU[i] * params.L[i] * params.rr[i]);
    # Instantaneous utility function equation
    @NLconstraint(model, [i=1:N], vars.PERIODU[i] == ((vars.C[i]*1000.0/params.L[i])^(1-params.α)-1)/(1-params.α)-1);

    # Equations (offset) #
    # Cumulative carbon emissions
    @constraint(model, [i=1:N-1], vars.CCA[i+1] == vars.CCA[i] + vars.Eind[i]*5/3.666);
    # Atmospheric concentration equation
    @constraint(model, [i=1:N-1], vars.Mₐₜ[i+1] == vars.Mₐₜ[i]*params.ϕ₁₁ + vars.Mᵤₚ[i]*params.ϕ₂₁ + vars.E[i]*(5/3.666));
    # Lower ocean concentration
    @constraint(model, [i=1:N-1], vars.Mₗₒ[i+1] == vars.Mₗₒ[i]*params.ϕ₃₃ + vars.Mᵤₚ[i]*config.ϕ₂₃);
    # Shallow ocean concentration
    @constraint(model, [i=1:N-1], vars.Mᵤₚ[i+1] == vars.Mₐₜ[i]*config.ϕ₁₂ + vars.Mᵤₚ[i]*params.ϕ₂₂ + vars.Mₗₒ[i]*params.ϕ₃₂);
    # Temperature-climate equation for atmosphere
    @constraint(model, [i=1:N-1], vars.Tₐₜ[i+1] == vars.Tₐₜ[i] + params.ξ₁*((vars.FORC[i+1]-params.λ*vars.Tₐₜ[i])-(config.ξ₃*(vars.Tₐₜ[i]-vars.Tₗₒ[i]))));
    # Temperature-climate equation for lower oceans
    @constraint(model, [i=1:N-1], vars.Tₗₒ[i+1] == vars.Tₗₒ[i] + config.ξ₄*(vars.Tₐₜ[i]-vars.Tₗₒ[i]));
    # Capital balance equation
    @constraint(model, [i=1:N-1], vars.K[i+1] <= (1-config.δk)^config.tstep * vars.K[i] + config.tstep*vars.I[i]);
    # Interest rate equation
    @NLconstraint(model, [i=1:N-1], vars.RI[i] == (1+params.ρ)*(vars.CPC[i+1]/vars.CPC[i])^(params.α/config.tstep)-1);

    # Savings rate for asympotic equilibrium
    @constraint(model, vars.S[i=N-10:N] .== params.optlrsav);
    # Initial conditions
    @constraint(model, vars.CCA[1] == 90.0);
    @constraint(model, vars.K[1] == config.k₀);
    @constraint(model, vars.Mₐₜ[1] == config.mat₀);
    @constraint(model, vars.Mᵤₚ[1] == config.mu₀);
    @constraint(model, vars.Mₗₒ[1] == config.ml₀);
    @constraint(model, vars.Tₐₜ[1] == config.tatm₀);
    @constraint(model, vars.Tₗₒ[1] == config.tocean₀);

    @constraint(model, vars.UTILITY == config.tstep * config.scale1 * sum(vars.CEMUTOTPER[i] for i=1:N) + config.scale2);

    # Objective function
    @objective(model, Max, vars.UTILITY);

    RockyRoadEquations(eeq,yy)
end

include("ScenariosRockyRoad.jl")

function dice_solve(scenario::Scenario, version::V2013R{RockyRoadFlavour};
    config::RockyRoadOptions = dice_options(version),
    solver = IpoptSolver(print_level=3, max_iter=99900,print_frequency_iter=50,sb="yes"))

    model = Model(solver = solver);
    params = generate_parameters(config, model);

    # Rate limit
    μ_ubound = [if t < 30 1.0 else config.limμ*getvalue(params.partfract[t]) end for t in 1:config.N];
    cprice_ubound = fill(Inf, config.N); #No initial price bound

    variables = model_vars(version, model, config.N, config.fosslim, μ_ubound, cprice_ubound);

    equations = model_eqs(version, model, config, params, variables);

    solve(model);

    setvalue(params.ψ₂, config.ψ₂₀);

    assign_scenario(scenario, config, params, variables);

    solve(model);
    solve(model);

    results = model_results(model, config, params, variables, equations);

    DICENarrative(config,params,model,scenario,version,variables,equations,results)
end
