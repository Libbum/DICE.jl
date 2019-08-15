struct VCJL <: Version end

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

@extend struct OptionsVCJL <: Options
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
    tstep::Int = 1, #Years per Period (UNUSED IN CJL)
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
    gσ₁::Float64 = -0.00730, #Initial growth of sigma (continuous per year)
    δσ::Float64 = 0.003, #Decline rate of decarbonization per period
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
    tatm₀::Float64 = 0.7307, #2000 atmospheric temp change (C from 1900)
    ξ₁::Float64 = 0.0220, #Climate equation coefficient for upper level
    ξ₃::Float64 = 0.3, #Transfer coefficient upper to lower stratum
    ξ₄::Float64 = 0.005, #Transfer coefficient for lower level
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
    σ₀::Float64 = 0.13418, #CO₂-equivalent emissions-GNP ratio 2005
    backrat::Float64 = 2.0, #atio initial to final backstop cost
    partfract1::Float64 = 1.0, #Fraction of emissions under control regime 2005
    partfract2::Float64 = 1.0, #Fraction of emissions under control regime 2015
    partfract21::Float64 = 1.0, #Fraction of emissions under control regime 2205
    dpartfract::Float64 = 0.0) #Decline rate of participation

    OptionsVCJL(N,tstep,α,ρ,γₑ,pop₀,popadj,popasym,δk,q₀,k₀,a₀,ga₀,δₐ,gσ₁,δσ,eland₀,deland,mat₀,mu₀,ml₀,mateq,mueq,mleq,ϕ₁₂,ϕ₂₃,t2xco2,fₑₓ0,fₑₓ1,tocean₀,tatm₀,ξ₁,ξ₃,ξ₄,η,ψ₁,ψ₂,ψ₃,θ₂,pback,gback,limμ,fosslim,scale1,scale2,δσ₂,σ₀,backrat,partfract1,partfract2,partfract21,dpartfract)
end

function Base.show(io::IO, ::MIME"text/plain", opt::OptionsVCJL)
    println(io, "Options for DICE-CJL");
    println(io, "N: $(opt.N)");
    println(io, "Preferences");
    println(io, "α: $(opt.α), ρ: $(opt.ρ)");
    println(io, "Population and Technology");
    println(io, "γₑ: $(opt.γₑ), pop₀: $(opt.pop₀), popadj: $(opt.popadj), popasym: $(opt.popasym), δk: $(opt.δk)");
    println(io, "q₀: $(opt.q₀), k₀: $(opt.k₀), a₀: $(opt.a₀), ga₀: $(opt.ga₀), δₐ: $(opt.δₐ)");
    println(io, "Emissions Parameters");
    println(io, "σ₀: $(opt.σ₀), gσ₁: $(opt.gσ₁), δσ: $(opt.δσ), δσ₂: $(opt.δσ₂), eland₀: $(opt.eland₀)");
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
    println(io, "θ₂: $(opt.θ₂), pback: $(opt.pback), gback: $(opt.gback), backrat: $(opt.backrat), limμ: $(opt.limμ)");
    println(io, "Fossil Fuel Availability");
    println(io, "fosslim: $(opt.fosslim)");
    println(io, "Scaling Parameters");
    println(io, "scale1: $(opt.scale1), scale2: $(opt.scale2)");
    println(io, "Emissions control");
    print(io, "partfract1: $(opt.partfract1), partfract2: $(opt.partfract2), partfract21: $(opt.partfract21), dpartfract: $(opt.dpartfract)");
end


@extend struct ParametersVCJL <: Parameters
    rr::Array{Float64,1} # Average utility social discount rate
    partfract::Array{Float64,1} # Fraction of emissions in control regime
end

function generate_parameters(c::OptionsVCJL)
    ϕ₁₁::Float64 = 1 - c.ϕ₁₂; # Carbon cycle transition matrix coefficient
    ϕ₂₁::Float64 = c.mateq*c.ϕ₁₂/c.mueq; # Carbon cycle transition matrix coefficient
    ϕ₂₂::Float64 = 1 - ϕ₂₁ - c.ϕ₂₃; # Carbon cycle transition matrix coefficient
    ϕ₃₂::Float64 = c.mueq*c.ϕ₂₃/c.mleq; # Carbon cycle transition matrix coefficient
    ϕ₃₃::Float64 = 1 - ϕ₃₂; # Carbon cycle transition matrix coefficient
    σ₀::Float64 = c.σ₀; # CO2-equivalent emissions-GNP ratio 2005
    λ::Float64 = c.η/c.t2xco2; # Climate model parameter

    # Growth factor population
    #NOTE: This is only a helper function for L, so we don't include it in the Narrative anywhere.
    gfacpop = Array{Float64}(undef, c.N);
    # Level of population and labor
    L = Array{Float64}(undef, c.N);
    # Growth rate of productivity from 0 to N
    gₐ = Array{Float64}(undef, c.N);
    # Change in sigma (cumulative improvement of energy efficiency)
    gσ = Array{Float64}(undef, c.N);
    # Emissions from deforestation
    Etree = Array{Float64}(undef, c.N);
    # Average utility social discount rate
    rr = Array{Float64}(undef, c.N);

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
    A = Array{Float64}(undef, c.N);
    A[1] = c.a₀;
    # CO2-equivalent-emissions output ratio
    σ = Array{Float64}(undef, c.N);
    σ[1] = σ₀;

    for i in 1:c.N-1
        A[i+1] = A[i]/(1-gₐ[i]);
        σ[i+1] = σ[i]/(1-gσ[i+1]);
    end

    # Adjusted cost for backstop
    θ₁ = Array{Float64}(undef, c.N);
    # Exogenous forcing for other greenhouse gases
    fₑₓ = Array{Float64}(undef, c.N);
    # Fraction of emissions in control regime
    partfract = Array{Float64}(undef, c.N);

    for i in 1:c.N
        θ₁[i] = (c.pback*σ[i]/c.θ₂)*((c.backrat-1+exp.(-c.gback*(i-1)))/c.backrat);
        fₑₓ[i] = if i < 101
                        c.fₑₓ0+0.01*(c.fₑₓ1-c.fₑₓ0)*(i-1)
                    else
                        0.36 #TODO: Check forcoth implementation in GAMS source. Libbum/DICE.jl/issues/23
                    end;
        partfract[i] = if i <= 259
                            c.partfract21+(c.partfract2-c.partfract21)*exp.(-c.dpartfract*(i-2))
                       else
                            c.partfract21
                       end;
    end
    partfract[1] = 0.25372; #NOTE: This is overriden in the setup, so partfract1 is never really used...
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
    println(io, "Cumulative improvement of energy efficiency: $(opt.gσ)");
    println(io, "CO₂-equivalent-emissions output ratio: $(opt.σ)");
    println(io, "Adjusted cost for backstop: $(opt.θ₁)");
    println(io, "Exogenious forcing: $(opt.fₑₓ)");
    print(io, "Fraction of emissions in control regime: $(opt.partfract)");
end

@extend struct VariablesVCJL <: Variables
    MₐₜAV::Array{VariableRef,1} # Average concentrations
    PCY::Array{VariableRef,1} # Per capita income thousands US dollars
end

function model_vars(version::VCJL, model::JuMP.Model, N::Int64, cca_ubound::Float64, μ_ubound::Float64)
    @variable(model, 0.0 <= μ[i=1:N] <= μ_ubound); # Emission control rate GHGs
    @variable(model, FORC[1:N]); # Increase in radiative forcing (watts per m2 from 1900)
    @variable(model, 0.0 <= Tₐₜ[1:N] <= 20.0); # Increase temperature of atmosphere (degrees C from 1900)
    @variable(model, -1.0 <= Tₗₒ[1:N] <= 20.0); # Increase temperatureof lower oceans (degrees C from 1900)
    @variable(model, Mₐₜ[1:N] >= 10.0); # Carbon concentration increase in atmosphere (GtC from 1750)
    @variable(model, Mᵤₚ[1:N] >= 100.0); # Carbon concentration increase in shallow oceans (GtC from 1750)
    @variable(model, Mₗₒ[1:N] >= 1000.0); # Carbon concentration increase in lower oceans (GtC from 1750)
    @variable(model, E[1:N] >= 0.0); # Total CO2 emissions (GtCO2 per year)
    @variable(model, C[1:N] >= 20.0); # Consumption (trillions 2005 US dollars per year)
    @variable(model, K[1:N] >= 100.0); # Capital stock (trillions 2005 US dollars)
    @variable(model, CPC[1:N] >= 0.01); #  Per capita consumption (thousands 2005 USD per year)
    @variable(model, I[1:N] >= 0.0); # Investment (trillions 2005 USD per year)
    @variable(model, S[1:N]); # Gross savings rate as fraction of gross world product
    @variable(model, RI[1:N]); # Real interest rate (per annum)
    @variable(model, Y[1:N] >= 0.0); # Gross world product net of abatement and damages (trillions 2005 USD per year)
    @variable(model, YGROSS[1:N] >= 0.0); # Gross world product GROSS of abatement and damages (trillions 2005 USD per year)
    @variable(model, YNET[1:N]); # Output net of damages equation (trillions 2005 USD per year)
    @variable(model, DAMAGES[1:N]); # Damages (trillions 2005 USD per year)
    @variable(model, MCABATE[1:N]); #->ABATECOST Marginal cost of abatement (2005$ per ton CO2)
    @variable(model, 0.0 <= CCA[1:N] <= cca_ubound); # Cumulative industrial carbon emissions (GTC)
    @variable(model, PERIODU[1:N]); # One period utility function
    @variable(model, UTILITY); # Welfare function
    @variable(model, MₐₜAV[1:N] >= 0.0); # Average concentrations
    @variable(model, PCY[1:N]); # Per capita income thousands US dollars
    VariablesVCJL(μ,FORC,Tₐₜ,Tₗₒ,Mₐₜ,Mᵤₚ,Mₗₒ,E,C,K,CPC,I,S,RI,Y,YGROSS,YNET,DAMAGES,MCABATE,CCA,PERIODU,UTILITY,MₐₜAV,PCY)
end

@extend struct EquationsVCJL <: Equations
    kk::Array{ConstraintRef{Model,C,Shape} where Shape<:JuMP.AbstractShape where C,1} # Capital balance equation
end

function model_eqs(model::Model, config::OptionsVCJL, params::ParametersVCJL, vars::VariablesVCJL)
    N = config.N;
    # Equations #
    # Emissions Equation
    eeq = @NLconstraint(model, [i=1:N], vars.E[i] == params.σ[i] * (1-vars.μ[i])*params.A[i]*params.L[i]^(1-config.γₑ)*vars.K[i]^config.γₑ + params.Etree[i]);
    # Radiative forcing equation
    @NLconstraint(model, [i=1:N], vars.FORC[i] == config.η * (log((vars.MₐₜAV[i]+.000001)/596.4)/log(2)) + params.fₑₓ[i]);
    # Average concentrations equation
    @constraint(model, [i=1:N], vars.MₐₜAV[i] == vars.Mₐₜ[i]);
    # Output gross equation
    @NLconstraint(model, [i=1:N], vars.YGROSS[i] == params.A[i]*params.L[i]^(1-config.γₑ)*vars.K[i]^config.γₑ);
    # Damage equation
    @NLconstraint(model, [i=1:N], vars.DAMAGES[i] == vars.YGROSS[i]-vars.YGROSS[i]/(1+config.ψ₁*vars.Tₐₜ[i]+config.ψ₂*vars.Tₐₜ[i]^config.ψ₃));
    # Output net of damages equation
    @NLconstraint(model, [i=1:N], vars.YNET[i] == vars.YGROSS[i]/(1+config.ψ₁*vars.Tₐₜ[i]+config.ψ₂*vars.Tₐₜ[i]^config.ψ₃));
    # ->ABATECOST Abatement cost
    @NLconstraint(model, [i=1:N], vars.MCABATE[i] == params.partfract[i]^(1-config.θ₂)*vars.YGROSS[i]*(params.θ₁[i]*(vars.μ[i]^config.θ₂)));
    # Output net equation
    @NLconstraint(model, [i=1:N], vars.Y[i] == vars.YGROSS[i]*(1-(params.partfract[i]^(1-config.θ₂))*params.θ₁[i]*(vars.μ[i]^config.θ₂))/(1+config.ψ₁*vars.Tₐₜ[i]+config.ψ₂*vars.Tₐₜ[i]^config.ψ₃));
    # Savings rate equation
    @NLconstraint(model, [i=1:N], vars.S[i] == vars.I[i]/(0.001 + vars.Y[i]));
    # Interest rate equation
    @NLconstraint(model, [i=1:N], vars.RI[i] == config.γₑ*vars.Y[i]/vars.K[i]-config.δk);
    # Consumption equation
    @constraint(model, [i=1:N], vars.C[i] == vars.Y[i] - vars.I[i]);
    # Per capita consumption definition
    @constraint(model, [i=1:N], vars.CPC[i] == vars.C[i] * 1000.0 / params.L[i]);
    # Per capita income definition
    @constraint(model, [i=1:N], vars.PCY[i] == vars.Y[i] * 1000.0 / params.L[i]);
    # Instantaneous utility function equation
    @NLconstraint(model, [i=1:N], vars.PERIODU[i] == ((vars.C[i]/params.L[i])^(1-config.α)-1)/(1-config.α));

    # Equations (offset) #
    # Cumulative carbon emissions
    @constraint(model, [i=1:N-1], vars.CCA[i+1] == vars.CCA[i] + vars.E[i]);
    # Capital balance equation
    kk = @constraint(model, [i=1:N-1], vars.K[i+1] <= (1-config.δk) * vars.K[i] + vars.I[i]);
    # Atmospheric concentration equation
    @constraint(model, [i=1:N-1], vars.Mₐₜ[i+1] == vars.Mₐₜ[i]*params.ϕ₁₁ + vars.Mᵤₚ[i]*params.ϕ₂₁ + vars.E[i]);
    # Lower ocean concentration
    @constraint(model, [i=1:N-1], vars.Mₗₒ[i+1] == vars.Mₗₒ[i]*params.ϕ₃₃ + vars.Mᵤₚ[i]*config.ϕ₂₃);
    # Shallow ocean concentration
    @constraint(model, [i=1:N-1], vars.Mᵤₚ[i+1] == vars.Mₐₜ[i]*config.ϕ₁₂ + vars.Mᵤₚ[i]*params.ϕ₂₂ + vars.Mₗₒ[i]*params.ϕ₃₂);
    # Temperature-climate equation for atmosphere
    @constraint(model, [i=1:N-1], vars.Tₐₜ[i+1] == vars.Tₐₜ[i] + config.ξ₁*(vars.FORC[i]-params.λ*vars.Tₐₜ[i]-config.ξ₃*(vars.Tₐₜ[i]-vars.Tₗₒ[i])));
    # Temperature-climate equation for lower oceans
    @constraint(model, [i=1:N-1], vars.Tₗₒ[i+1] == vars.Tₗₒ[i] + config.ξ₄*(vars.Tₐₜ[i]-vars.Tₗₒ[i]));

    # Terminal condition for capital
    @constraint(model, 0.02*vars.K[end] <= vars.I[end]);
    # Fix savings assumption for standardization if needed
    # NOTE: This kills all savings??
    # for i=1:N
    #     JuMP.fix(vars.S[i], 0.22; force=true);
    # end
    # Initial conditions
    JuMP.fix(vars.CCA[1], 0.0; force=true);
    JuMP.fix(vars.K[1], config.k₀; force=true);
    JuMP.fix(vars.Mₐₜ[1], config.mat₀; force=true);
    JuMP.fix(vars.Mᵤₚ[1], config.mu₀; force=true);
    JuMP.fix(vars.Mₗₒ[1], config.ml₀; force=true);
    JuMP.fix(vars.Tₐₜ[1], config.tatm₀; force=true);
    JuMP.fix(vars.Tₗₒ[1], config.tocean₀; force=true);
    #First period predetermined by Kyoto Protocol
    JuMP.fix(vars.μ[1], 0.005; force=true);

    @constraint(model, vars.UTILITY == sum(params.rr[i]*params.L[i]*vars.PERIODU[i]/config.scale1 for i=1:N) + config.scale2);

    # Objective function
    @objective(model, Max, vars.UTILITY);

    EquationsVCJL(eeq,kk)
end

# Just put the default into OptimalPrice for the moment.
function assign_scenario(s::OptimalPriceScenario, model::Model, config::OptionsVCJL, params::ParametersVCJL, vars::VariablesVCJL)
end

function assign_scenario(s::Scenario, model::Model, config::OptionsVCJL, params::ParametersVCJL, vars::VariablesVCJL)
    error("$(s) is not a valid scenario for DICE-CJL");
end

@extend struct ResultsVCJL <: Results
    MCABATE::Array{Float64,1} # Marginal cost of abatement (2005$ per ton CO2)
    MₐₜAV::Array{Float64,1} # Average concentrations
    PCY::Array{Float64,1} # Per capita income thousands US dollars
    mcemis::Array{Float64,1} #Unsure: TODO
end

function model_results(model::Model, config::OptionsVCJL, params::ParametersVCJL, vars::VariablesVCJL, eqs::EquationsVCJL)
    years = 2005+(1:config.N); # TODO: check this
    Mₐₜ = value.(vars.Mₐₜ);
    MₐₜAV = value.(vars.MₐₜAV);
    Mₐₜppm = value.(vars.Mₐₜ)/2.13;
    Mᵤₚ = value.(vars.Mᵤₚ);
    Mₗₒ = value.(vars.Mₗₒ);
    CCA = value.(vars.CCA);
    CCAratio = value.(vars.CCA)/config.fosslim;
    Tₐₜ = value.(vars.Tₐₜ);
    FORC = value.(vars.FORC);
    Tₗₒ = value.(vars.Tₗₒ);
    YGROSS = value.(vars.YGROSS);
    DAMAGES = value.(vars.DAMAGES);
    YNET = value.(vars.YNET);
    MCABATE = value.(vars.MCABATE);
    Y = value.(vars.Y);
    E = value.(vars.E);
    I = value.(vars.I);
    K = value.(vars.K);
    PCY = value.(vars.PCY)
    MPK = config.γₑ.*YGROSS./K;
    C = value.(vars.C);
    CPC = value.(vars.CPC);
    PERIODU = value.(vars.PERIODU);
    UTILITY = value.(vars.UTILITY);
    S = value.(vars.S);
    μ = value.(vars.μ);
    RI = value.(vars.RI);
    scc = 1000 .* shadow_price.(eqs.eeq)./(shadow_price.(eqs.kk) .+ 0.00000000001);
    mcemis = config.θ₂.*params.θ₁.*μ.^(config.θ₂-1)./params.σ.*1000.;
    ResultsVCJL(years,Mₐₜ,Mₐₜppm,Mᵤₚ,Mₗₒ,CCA,CCAratio,Tₐₜ,FORC,Tₗₒ,YGROSS,DAMAGES,YNET,
               Y,E,I,K,MPK,C,CPC,PERIODU,UTILITY,S,μ,RI,scc,MCABATE,MₐₜAV,PCY,mcemis)
end



function solve(scenario::Scenario, version::VCJL;
    config::OptionsVCJL = options(version),
    optimizer = with_optimizer(Ipopt.Optimizer, print_level=5, max_iter=99900,print_frequency_iter=250,sb="yes"))
    model = Model(optimizer);


    params = generate_parameters(config);

    variables = model_vars(version, model, config.N, config.fosslim, config.limμ);

    assign_scenario(scenario, model, config, params, variables);

    equations = model_eqs(model, config, params, variables);

    optimize!(model);
    #optimize!(model);
    #optimize!(model);
    #optimize!(model);
    #optimize!(model);
    #optimize!(model);

    #results = model_results(model, config, params, variables, equations);

    #DICENarrative(config,params,model,scenario,version,variables,equations,results)
    println("Done");
end
