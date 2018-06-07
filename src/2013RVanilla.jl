struct Vanilla2013ROptions
    N::Int #Number of years to calculate (from 2010 onwards)
    tstep::Int #Years per Period
    cpriceopt::Bool #If optimized set true if base set false
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
    periodfullpart::Float64 #Period at which have full participation
    partfract2010::Float64 #Fraction of emissions under control in 2010
    partfractfull::Float64 #Fraction of emissions under control at full time
    fosslim::Float64 #Maximum cumulative extraction fossil fuels (GtC)
    scale1::Float64 #Multiplicative scaling coefficient
    scale2::Float64 #Additive scaling coefficient
end

function vanilla_2013R_options(;
    N::Int = 60, #Number of years to calculate (from 2010 onwards)
    tstep::Int = 5, #Years per Period
    cpriceopt::Bool = true, #If optimised set true if base set false
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
    ξ₁::Float64 = 0.098, #Climate equation coefficient for upper level
    ξ₃::Float64 = 0.088, #Transfer coefficient upper to lower stratum
    ξ₄::Float64 = 0.025, #Transfer coefficient for lower level
    η::Float64 = 3.8, #Forcings of equilibrium CO2 doubling (Wm-2)
    ψ₁::Float64 = 0.0, #Damage intercept
    ψ₂::Float64 = 0.00267, #Damage quadratic term
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
    Vanilla2013ROptions(N,tstep,cpriceopt,α,ρ,γₑ,pop₀,popadj,popasym,δk,q₀,k₀,a₀,ga₀,δₐ,gσ₁,δσ,eland₀,deland,e₀,μ₀,mat₀,mu₀,ml₀,mateq,mueq,mleq,ϕ₁₂,ϕ₂₃,t2xco2,fₑₓ0,fₑₓ1,tocean₀,tatm₀,ξ₁,ξ₃,ξ₄,η,ψ₁,ψ₂,ψ₃,θ₂,pback,gback,limμ,tnopol,cprice₀,gcprice,periodfullpart,partfract2010,partfractfull,fosslim,scale1,scale2)
end

function Base.show(io::IO, ::MIME"text/plain", opt::Vanilla2013ROptions)
    println(io, "Options for Vanilla 2013R version");
    println(io, "Time step");
    println(io, "N: $(opt.N), tstep: $(opt.tstep)");
    println(io, "Optimal control: $(opt.cpriceopt)");
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
    println(io, "ψ₁: $(opt.ψ₁), ψ₂: $(opt.ψ₂), ψ₃: $(opt.ψ₃)");
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

struct Vanilla2013RParameters
    optlrsav::Float64 # Optimal savings rate
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
    rr::Array{Float64,1} # Average utility social discount rate
    cpricebase::Array{Float64,1} # Carbon price in base case
    L::Array{Float64,1} # Level of population and labor
    A::Array{Float64,1} # Level of total factor productivity
    gσ::Array{Float64,1} # Change in sigma (cumulative improvement of energy efficiency)
    σ::Array{Float64,1} # CO2-equivalent-emissions output ratio
    θ₁::Array{Float64,1} # Adjusted cost for backstop
    fₑₓ::Array{Float64,1} # Exogenous forcing for other greenhouse gases
    partfract::Array{Float64,1} # Fraction of emissions in control regime
end

function generate_parameters(c::Vanilla2013ROptions)
    optlrsav::Float64 = (c.δk + .004)/(c.δk + .004c.α + c.ρ)*c.γₑ; # Optimal savings rate
    ϕ₁₁::Float64 = 1 - c.ϕ₁₂; # Carbon cycle transition matrix coefficient
    ϕ₂₁::Float64 = c.ϕ₁₂*c.mateq/c.mueq; # Carbon cycle transition matrix coefficient
    ϕ₂₂::Float64 = 1 - ϕ₂₁ - c.ϕ₂₃; # Carbon cycle transition matrix coefficient
    ϕ₃₂::Float64 = c.ϕ₂₃*c.mueq/c.mleq; # Carbon cycle transition matrix coefficient
    ϕ₃₃::Float64 = 1 - ϕ₃₂; # Carbon cycle transition matrix coefficient
    σ₀::Float64 = c.e₀/(c.q₀*(1-c.μ₀)); # Carbon intensity 2010 (kgCO2 per output 2005 USD 2010)
    λ::Float64 = c.η/c.t2xco2; # Climate model parameter

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


    for i in 1:c.N-1
        L[i+1] = L[i]*(c.popasym/L[i])^c.popadj;
        A[i+1] = A[i]/(1-gₐ[i]);
        gσ[i+1] = gσ[i]*((1+c.δσ)^c.tstep);
        σ[i+1] = σ[i]*exp.(gσ[i]*c.tstep);
    end

    # Adjusted cost for backstop
    θ₁ = Array{Float64}(c.N);
    # Exogenous forcing for other greenhouse gases
    fₑₓ = Array{Float64}(c.N);
    # Fraction of emissions in control regime
    partfract = Array{Float64}(c.N);

    for i in 1:c.N
        θ₁[i] = pbacktime[i]*σ[i]/c.θ₂/1000.0;
        fₑₓ[i] = if i < 19
                         c.fₑₓ0+(1/18)*(c.fₑₓ1-c.fₑₓ0)*(i-1)
                     else
                         c.fₑₓ1-c.fₑₓ0
                     end;
        partfract[i] = if i <= c.periodfullpart
                            c.partfract2010+(c.partfractfull-c.partfract2010)*(i-1)/c.periodfullpart
                       else
                            c.partfractfull
                       end;
    end
    partfract[1] = c.partfract2010;
    Vanilla2013RParameters(optlrsav,ϕ₁₁,ϕ₂₁,ϕ₂₂,ϕ₃₂,ϕ₃₃,σ₀,λ,pbacktime,gₐ,Etree,rr,cpricebase,L,A,gσ,σ,θ₁,fₑₓ,partfract)
end

function Base.show(io::IO, ::MIME"text/plain", opt::Vanilla2013RParameters)
    println(io, "Calculated Parameters for Vanilla 2013R");
    println(io, "Optimal savings rate: $(opt.optlrsav)");
    println(io, "Carbon cycle transition matrix coefficients");
    println(io, "ϕ₁₁: $(opt.ϕ₁₁), ϕ₂₁: $(opt.ϕ₂₁), ϕ₂₂: $(opt.ϕ₂₂), ϕ₃₂: $(opt.ϕ₃₂), ϕ₃₃: $(opt.ϕ₃₃)");
    println(io, "2010 Carbon intensity: $(opt.σ₀)");
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
    println(io, "θ₁: $(opt.θ₁)");
    println(io, "Exogenious forcing: $(opt.fₑₓ)");
    print(io, "Fraction of emissions in control regieme: $(opt.partfract)");
end

struct Vanilla2013R
    constants::Vanilla2013ROptions
    parameters::Vanilla2013RParameters
    model::JuMP.Model
    μ::Array{JuMP.Variable,1} # Emission control rate GHGs
    FORC::Array{JuMP.Variable,1} # Increase in radiative forcing (watts per m2 from 1900)
    Tₐₜ::Array{JuMP.Variable,1} # Increase temperature of atmosphere (degrees C from 1900)
    Tₗₒ::Array{JuMP.Variable,1} # Increase temperatureof lower oceans (degrees C from 1900)
    Mₐₜ::Array{JuMP.Variable,1} # Carbon concentration increase in atmosphere (GtC from 1750)
    Mᵤₚ::Array{JuMP.Variable,1} # Carbon concentration increase in shallow oceans (GtC from 1750)
    Mₗₒ::Array{JuMP.Variable,1} # Carbon concentration increase in lower oceans (GtC from 1750)
    E::Array{JuMP.Variable,1} # Total CO2 emissions (GtCO2 per year)
    Eind::Array{JuMP.Variable,1} # Industrial emissions (GtCO2 per year)
    C::Array{JuMP.Variable,1} # Consumption (trillions 2005 US dollars per year)
    K::Array{JuMP.Variable,1} # Capital stock (trillions 2005 US dollars)
    CPC::Array{JuMP.Variable,1} #  Per capita consumption (thousands 2005 USD per year)
    I::Array{JuMP.Variable,1} # Investment (trillions 2005 USD per year)
    S::Array{JuMP.Variable,1} # Gross savings rate as fraction of gross world product
    RI::Array{JuMP.Variable,1} # Real interest rate (per annum)
    Y::Array{JuMP.Variable,1} # Gross world product net of abatement and damages (trillions 2005 USD per year)
    YGROSS::Array{JuMP.Variable,1} # Gross world product GROSS of abatement and damages (trillions 2005 USD per year)
    YNET::Array{JuMP.Variable,1} # Output net of damages equation (trillions 2005 USD per year)
    DAMAGES::Array{JuMP.Variable,1} # Damages (trillions 2005 USD per year)
    Ω::Array{JuMP.Variable,1} # Damages as fraction of gross output
    Λ::Array{JuMP.Variable,1} # Cost of emissions reductions  (trillions 2005 USD per year)
    MCABATE::Array{JuMP.Variable,1} # Marginal cost of abatement (2005$ per ton CO2)
    CCA::Array{JuMP.Variable,1} # Cumulative industrial carbon emissions (GTC)
    PERIODU::Array{JuMP.Variable,1} # One period utility function
    CPRICE::Array{JuMP.Variable,1} # Carbon price (2005$ per ton of CO2)
    CEMUTOTPER::Array{JuMP.Variable,1} # Period utility
    UTILITY::JuMP.Variable # Welfare function
    eeq::Array{JuMP.ConstraintRef,1} # Emissions Equation
    cc::Array{JuMP.ConstraintRef,1} # Consumption equation
end

function vanilla_2013R(;
    config::Vanilla2013ROptions = vanilla_2013R_options(),
    solver = IpoptSolver(print_level=3, max_iter=99900,print_frequency_iter=50))

    params = generate_parameters(config);
    model = Model(solver = solver);

    N = config.N;
    # Rate limit
    μ_ubound(t) = if t < 30
                        1.0
                    else
                        config.limμ*params.partfract[t]
                    end;

    # Variables #
    @variable(model, 0.0 <= μ[i=1:N] <= μ_ubound(i)); # Emission control rate GHGs
    @variable(model, FORC[1:N]); # Increase in radiative forcing (watts per m2 from 1900)
    @variable(model, 0.0 <= Tₐₜ[1:N] <= 40.0); # Increase temperature of atmosphere (degrees C from 1900)
    @variable(model, -1.0 <= Tₗₒ[1:N] <= 20.0); # Increase temperatureof lower oceans (degrees C from 1900)
    @variable(model, Mₐₜ[1:N] >= 10.0); # Carbon concentration increase in atmosphere (GtC from 1750)
    @variable(model, Mᵤₚ[1:N] >= 100.0); # Carbon concentration increase in shallow oceans (GtC from 1750)
    @variable(model, Mₗₒ[1:N] >= 1000.0); # Carbon concentration increase in lower oceans (GtC from 1750)
    @variable(model, E[1:N]); # Total CO2 emissions (GtCO2 per year)
    @variable(model, Eind[1:N]); # Industrial emissions (GtCO2 per year)
    @variable(model, C[1:N] >= 2.0); # Consumption (trillions 2005 US dollars per year)
    @variable(model, K[1:N] >= 1.0); # Capital stock (trillions 2005 US dollars)
    @variable(model, CPC[1:N] >= 0.01); #  Per capita consumption (thousands 2005 USD per year)
    @variable(model, I[1:N] >= 0.0); # Investment (trillions 2005 USD per year)
    @variable(model, S[1:N]); # Gross savings rate as fraction of gross world product
    @variable(model, RI[1:N]); # Real interest rate (per annum)
    @variable(model, Y[1:N] >= 0.0); # Gross world product net of abatement and damages (trillions 2005 USD per year)
    @variable(model, YGROSS[1:N] >= 0.0); # Gross world product GROSS of abatement and damages (trillions 2005 USD per year)
    @variable(model, YNET[1:N]); # Output net of damages equation (trillions 2005 USD per year)
    @variable(model, DAMAGES[1:N]); # Damages (trillions 2005 USD per year)
    @variable(model, Ω[1:N]); # Damages as fraction of gross output
    @variable(model, Λ[1:N]); # Cost of emissions reductions  (trillions 2005 USD per year)
    @variable(model, MCABATE[1:N]); # Marginal cost of abatement (2005$ per ton CO2)
    @variable(model, CCA[1:N] <= config.fosslim); # Cumulative industrial carbon emissions (GTC)
    @variable(model, PERIODU[1:N]); # One period utility function
    @variable(model, CPRICE[i=1:N]); # Carbon price (2005$ per ton of CO2)
    @variable(model, CEMUTOTPER[1:N]); # Period utility
    @variable(model, UTILITY); # Welfare function

    # Base carbon price if base, otherwise optimized
    # Warning: If parameters are changed, the next equation might make base case infeasible.
    # If so, reduce tnopol so that we don't run out of resources.
    setupperbound(CPRICE[1], params.cpricebase[1]);
    for i in 2:N
        if !config.cpriceopt
            setupperbound(CPRICE[i], params.cpricebase[i]);
        elseif i > config.tnopol
            setupperbound(CPRICE[i], 1000.0);
        end
    end

    # Equations #
    # Emissions Equation
    eeq = @constraint(model, [i=1:N], E[i] == Eind[i] + params.Etree[i]);
    # Industrial Emissions
    @constraint(model, [i=1:N], Eind[i] == params.σ[i] * YGROSS[i] * (1-μ[i]));
    # Radiative forcing equation
    @NLconstraint(model, [i=1:N], FORC[i] == config.η * (log(Mₐₜ[i]/588.0)/log(2)) + params.fₑₓ[i]);
    # Equation for damage fraction
    @NLconstraint(model, [i=1:N], Ω[i] == config.ψ₁*Tₐₜ[i]+config.ψ₂*Tₐₜ[i]^config.ψ₃);
    # Damage equation
    @constraint(model, [i=1:N], DAMAGES[i] == YGROSS[i]*Ω[i]);
    # Cost of exissions reductions equation
    @NLconstraint(model, [i=1:N], Λ[i] == YGROSS[i] * params.θ₁[i] * μ[i]^config.θ₂ * params.partfract[i]^(1-config.θ₂));
    # Equation for MC abatement
    @NLconstraint(model, [i=1:N], MCABATE[i] == params.pbacktime[i] * μ[i]^(config.θ₂-1));
    # Carbon price equation from abatement
    @NLconstraint(model, [i=1:N], CPRICE[i] == params.pbacktime[i] * (μ[i]/params.partfract[i])^(config.θ₂-1));
    # Output gross equation
    @NLconstraint(model, [i=1:N], YGROSS[i] == params.A[i]*(params.L[i]/1000.0)^(1-config.γₑ)*K[i]^config.γₑ);
    # Output net of damages equation
    @constraint(model, [i=1:N], YNET[i] == YGROSS[i]*(1-Ω[i]));
    # Output net equation
    @constraint(model, [i=1:N], Y[i] == YNET[i] - Λ[i]);
    # Consumption equation
    cc = @constraint(model, [i=1:N], C[i] == Y[i] - I[i]);
    # Per capita consumption definition
    @constraint(model, [i=1:N], CPC[i] == 1000.0 * C[i] / params.L[i]);
    # Savings rate equation
    @constraint(model, [i=1:N], I[i] == S[i] * Y[i]);
    # Period utility
    @constraint(model, [i=1:N], CEMUTOTPER[i] == PERIODU[i] * params.L[i] * params.rr[i]);
    # Instantaneous utility function equation
    @NLconstraint(model, [i=1:N], PERIODU[i] == ((C[i]*1000.0/params.L[i])^(1-config.α)-1)/(1-config.α)-1);

    # Equations (offset) #
    # Cumulative carbon emissions
    @constraint(model, [i=1:N-1], CCA[i+1] == CCA[i] + Eind[i]*5/3.666);
    # Atmospheric concentration equation
    @constraint(model, [i=1:N-1], Mₐₜ[i+1] == Mₐₜ[i]*params.ϕ₁₁ + Mᵤₚ[i]*params.ϕ₂₁ + E[i]*(5/3.666));
    # Lower ocean concentration
    @constraint(model, [i=1:N-1], Mₗₒ[i+1] == Mₗₒ[i]*params.ϕ₃₃ + Mᵤₚ[i]*config.ϕ₂₃);
    # Shallow ocean concentration
    @constraint(model, [i=1:N-1], Mᵤₚ[i+1] == Mₐₜ[i]*config.ϕ₁₂ + Mᵤₚ[i]*params.ϕ₂₂ + Mₗₒ[i]*params.ϕ₃₂);
    # Temperature-climate equation for atmosphere
    @constraint(model, [i=1:N-1], Tₐₜ[i+1] == Tₐₜ[i] + config.ξ₁*((FORC[i+1]-params.λ*Tₐₜ[i])-(config.ξ₃*(Tₐₜ[i]-Tₗₒ[i]))));
    # Temperature-climate equation for lower oceans
    @constraint(model, [i=1:N-1], Tₗₒ[i+1] == Tₗₒ[i] + config.ξ₄*(Tₐₜ[i]-Tₗₒ[i]));
    # Capital balance equation
    @constraint(model, [i=1:N-1], K[i+1] <= (1-config.δk)^config.tstep * K[i] + config.tstep*I[i]);
    # Interest rate equation
    @NLconstraint(model, [i=1:N-1], RI[i] == (1+config.ρ)*(CPC[i+1]/CPC[i])^(config.α/config.tstep)-1);

    # Savings rate for asympotic equilibrium
    @constraint(model, S[i=51:N] .== params.optlrsav);
    # Initial conditions
    @constraint(model, CCA[1] == 90.0);
    @constraint(model, K[1] == config.k₀);
    @constraint(model, Mₐₜ[1] == config.mat₀);
    @constraint(model, Mᵤₚ[1] == config.mu₀);
    @constraint(model, Mₗₒ[1] == config.ml₀);
    @constraint(model, Tₐₜ[1] == config.tatm₀);
    @constraint(model, Tₗₒ[1] == config.tocean₀);

    @constraint(model, UTILITY == config.tstep * config.scale1 * sum(CEMUTOTPER[i] for i=1:N) + config.scale2);

    # Objective function
    @objective(model, Max, UTILITY);
    Vanilla2013R(config,params,model,μ,FORC,Tₐₜ,Tₗₒ,Mₐₜ,Mᵤₚ,Mₗₒ,E,Eind,C,K,CPC,I,S,RI,Y,YGROSS,YNET,DAMAGES,Ω,Λ,MCABATE,CCA,PERIODU,CPRICE,CEMUTOTPER,UTILITY,eeq,cc)
end
