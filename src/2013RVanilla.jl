# For Solving #
using JuMP;
#Ipopt is distributed under the EPL.
#We don't package it here though, and assume you have this set up on your system already.
using Ipopt;

# Time Step #
N = 60; #Number of years to calculate (from 2010 onwards)
tstep = 5; #Years per Period

# If optimal control #
opt = true; #If optimized set true if base set false

# Preferences #
α = 1.45; #Elasticity of marginal utility of consumption
ρ = 0.015; #Initial rate of social time preference per year ρ

# Population and technology #
γₑ = 0.3; #Capital elasticity in production function
pop₀ = 6838; #Initial world population (millions)
popadj = 0.134; #Growth rate to calibrate to 2050 pop projection
popasym = 10500; #Asymptotic population (millions)
δk = 0.1; #Depreciation rate on capital (per year)
q₀ = 63.69; #Initial world gross output (trill 2005 USD)
k₀ = 135.0; #Initial capital value (trill 2005 USD)
a₀ = 3.80; #Initial level of total factor productivity
ga₀ = 0.079; #Initial growth rate for TFP per 5 years
δₐ = 0.006; #Decline rate of TFP per 5 years
#Optimal long-run savings rate used for transversality
optlrsav = (δk + .004)/(δk + .004α + ρ)*γₑ;

# Emissions parameters #
gσ₁ = -0.01; #Initial growth of sigma (continuous per year)
δσ = -0.001; #Decline rate of decarbonization per period
eland₀ = 3.3; #Carbon emissions from land 2010 (GtCO2 per year)
deland = 0.2; #Decline rate of land emissions (per period)
e₀ = 33.61; #Industrial emissions 2010 (GtCO2 per year)
miu₀ = 0.039; #Initial emissions control rate for base case 2010

# Carbon cycle #
# Initial Conditions
mat₀ = 830.4; #Initial Concentration in atmosphere 2010 (GtC)
mu₀ = 1527.0; #Initial Concentration in upper strata 2010 (GtC)
ml₀ = 10010.0; #Initial Concentration in lower strata 2010 (GtC)
mateq = 588.0; #Equilibrium concentration atmosphere  (GtC)
mueq = 1350.0; #Equilibrium concentration in upper strata (GtC)
mleq = 10000.0; #Equilibrium concentration in lower strata (GtC)

# Flow paramaters
#Carbon cycle transition matrix
ϕ₁₂ = .088;
ϕ₂₃ = 0.0025; #Carbon cycle transition matrix
# Parameters for long-run consistency of carbon cycle
ϕ₁₁ = 1 - ϕ₁₂;
ϕ₂₁ = ϕ₁₂*mateq/mueq;
ϕ₂₂ = 1 - ϕ₂₁ - ϕ₂₃;
ϕ₃₂ = ϕ₂₃*mueq/mleq;
ϕ₃₃ = 1 - ϕ₃₂;
σ₀ = e₀/(q₀*(1-miu₀)); #Carbon intensity 2010 (kgCO2 per output 2005 USD 2010)

# Climate model parameters #
t2xco2 = 2.9; #Equilibrium temp impact (oC per doubling CO2)
fₑₓ0 = 0.25; #2010 forcings of non-CO2 GHG (Wm-2)
fₑₓ1 = 0.7; #2100 forcings of non-CO2 GHG (Wm-2)
tocean₀ = 0.0068; #Initial lower stratum temp change (C from 1900)
tatm₀ = 0.8; #Initial atmospheric temp change (C from 1900)
ξ₁ = 0.098; #Climate equation coefficient for upper level
ξ₃ = 0.088; #Transfer coefficient upper to lower stratum
ξ₄ = 0.025; #Transfer coefficient for lower level
η = 3.8; #Forcings of equilibrium CO2 doubling (Wm-2)

λ = η/t2xco2; #Climate model parameter

# Climate damage parameters #
ψ₁ = 0.0; #Damage intercept
ψ₂ = 0.00267; #Damage quadratic term
ψ₃ = 2.0; #Damage exponent

# Abatement cost #
θ₂ = 2.8; #Exponent of control cost function
pback = 344.0; #Cost of backstop 2005$ per tCO2 2010
gback = 0.025; #Initial cost decline backstop cost per period
limμ = 1.2; #Upper limit on control rate after 2150
tnopol = 45.0; #Period before which no emissions controls base
cprice₀ = 1.0; #Initial base carbon price (2005$ per tCO2)
gcprice = 0.02; #Growth rate of base carbon price per year

# Participation parameters #
periodfullpart = 21; #Period at which have full participation
partfract2010 = 1; #Fraction of emissions under control in 2010
partfractfull = 1; #Fraction of emissions under control at full time

# Availability of fossil fuels #
fosslim  = 6000.0; #Maximum cumulative extraction fossil fuels (GtC)

# Scaling and inessential parameters #
# Note that these are unnecessary for the calculations but are for convenience
scale1 = 0.016408662; #Multiplicative scaling coefficient
scale2 = -3855.106895; #Additive scaling coefficient

# Backstop price
pbacktime = Array{Float64}(N);
# Growth rate of productivity from
gₐ = Array{Float64}(N);
# Emissions from deforestation
Etree = Array{Float64}(N);
# Average utility social discount rate
rr = Array{Float64}(N);
# Carbon price in base case
cpricebase = Array{Float64}(N);

for i in 1:N
    pbacktime[i] = pback*(1-gback)^(i-1);
    gₐ[i] = ga₀*exp.(-δₐ*5*(i-1));
    Etree[i] = eland₀*(1-deland)^(i-1);
    rr[i] = 1/((1+ρ)^(tstep*(i-1)));
    cpricebase[i] = cprice₀*(1+gcprice)^(5*(i-1));
end

# Initial conditions and offset required
# Level of population and labor
L = Array{Float64}(N);
L[1] = pop₀;
# Level of total factor productivity
A = Array{Float64}(N);
A[1] = a₀;
# Change in sigma (cumulative improvement of energy efficiency)
gσ = Array{Float64}(N);
gσ[1] = gσ₁;
# CO2-equivalent-emissions output ratio
σ = Array{Float64}(N);
σ[1] = σ₀;


for i in 1:N-1
    L[i+1] = L[i]*(popasym/L[i])^popadj;
    A[i+1] = A[i]/(1-gₐ[i]);
    gσ[i+1] = gσ[i]*((1+δσ)^tstep);
    σ[i+1] = σ[i]*exp.(gσ[i]*tstep);
end

# Adjusted cost for backstop
θ₁ = Array{Float64}(N);
# Exogenous forcing for other greenhouse gases
fₑₓ = Array{Float64}(N);
# Fraction of emissions in control regime
partfract = Array{Float64}(N);

for i in 1:N
    θ₁[i] = pbacktime[i]*σ[i]/θ₂/1000.0;
    fₑₓ[i] = if i < 19
                     fₑₓ0+(1/18)*(fₑₓ1-fₑₓ0)*(i-1)
                 else
                     fₑₓ1-fₑₓ0
                 end;
    partfract[i] = if i <= periodfullpart
                        partfract2010+(partfractfull-partfract2010)*(i-1)/periodfullpart
                   else
                        partfractfull
                   end;
end
partfract[1] = partfract2010;

vanilla_2013 = Model(solver = IpoptSolver(print_level=3, max_iter=99900,print_frequency_iter=50));
# Rate limit
μ_ubound(t) = if t < 30
                    1.0
                else
                    limμ*partfract[t]
                end;

# Variables #
@variable(vanilla_2013, 0.0 <= μ[i=1:N] <= μ_ubound(i)); # Emission control rate GHGs
@variable(vanilla_2013, FORC[1:N]); # Increase in radiative forcing (watts per m2 from 1900)
@variable(vanilla_2013, 0.0 <= Tₐₜ[1:N] <= 40.0); # Increase temperature of atmosphere (degrees C from 1900)
@variable(vanilla_2013, -1.0 <= Tₗₒ[1:N] <= 20.0); # Increase temperatureof lower oceans (degrees C from 1900)
@variable(vanilla_2013, Mₐₜ[1:N] >= 10.0); # Carbon concentration increase in atmosphere (GtC from 1750)
@variable(vanilla_2013, Mᵤₚ[1:N] >= 100.0); # Carbon concentration increase in shallow oceans (GtC from 1750)
@variable(vanilla_2013, Mₗₒ[1:N] >= 1000.0); # Carbon concentration increase in lower oceans (GtC from 1750)
@variable(vanilla_2013, E[1:N]); # Total CO2 emissions (GtCO2 per year)
@variable(vanilla_2013, Eind[1:N]); # Industrial emissions (GtCO2 per year)
@variable(vanilla_2013, C[1:N] >= 2.0); # Consumption (trillions 2005 US dollars per year)
@variable(vanilla_2013, K[1:N] >= 1.0); # Capital stock (trillions 2005 US dollars)
@variable(vanilla_2013, CPC[1:N] >= 0.01); #  Per capita consumption (thousands 2005 USD per year)
@variable(vanilla_2013, I[1:N] >= 0.0); # Investment (trillions 2005 USD per year)
@variable(vanilla_2013, S[1:N]); # Gross savings rate as fraction of gross world product
@variable(vanilla_2013, RI[1:N]); # Real interest rate (per annum)
@variable(vanilla_2013, Y[1:N] >= 0.0); # Gross world product net of abatement and damages (trillions 2005 USD per year)
@variable(vanilla_2013, YGROSS[1:N] >= 0.0); # Gross world product GROSS of abatement and damages (trillions 2005 USD per year)
@variable(vanilla_2013, YNET[1:N]); # Output net of damages equation (trillions 2005 USD per year)
@variable(vanilla_2013, DAMAGES[1:N]); # Damages (trillions 2005 USD per year)
@variable(vanilla_2013, Ω[1:N]); # Damages as fraction of gross output
@variable(vanilla_2013, Λ[1:N]); # Cost of emissions reductions  (trillions 2005 USD per year)
@variable(vanilla_2013, MCABATE[1:N]); # Marginal cost of abatement (2005$ per ton CO2)
@variable(vanilla_2013, CCA[1:N] <= fosslim); # Cumulative industrial carbon emissions (GTC)
@variable(vanilla_2013, PERIODU[1:N]); # One period utility function
@variable(vanilla_2013, CPRICE[i=1:N]); # Carbon price (2005$ per ton of CO2)
@variable(vanilla_2013, CEMUTOTPER[1:N]); # Period utility
@variable(vanilla_2013, UTILITY); # Welfare function

# Base carbon price if base, otherwise optimized
# Warning: If parameters are changed, the next equation might make base case infeasible.
# If so, reduce tnopol so that don't run out of resources.
setupperbound(CPRICE[1], cpricebase[1]);
for i in 2:N
    if !opt
        setupperbound(CPRICE[i], cpricebase[i]);
    elseif i > tnopol
        setupperbound(CPRICE[i], 1000.0);
    end
end

# Equations #
# Emissions Equation
eeq = @constraint(vanilla_2013, [i=1:N], E[i] == Eind[i] + Etree[i]);
# Industrial Emissions
@constraint(vanilla_2013, [i=1:N], Eind[i] == σ[i] * YGROSS[i] * (1-μ[i]));
# Radiative forcing equation
@NLconstraint(vanilla_2013, [i=1:N], FORC[i] == η * (log(Mₐₜ[i]/588.0)/log(2)) + fₑₓ[i]);
# Equation for damage fraction
@NLconstraint(vanilla_2013, [i=1:N], Ω[i] == ψ₁*Tₐₜ[i]+ψ₂*Tₐₜ[i]^ψ₃);
# Damage equation
@constraint(vanilla_2013, [i=1:N], DAMAGES[i] == YGROSS[i]*Ω[i]);
# Cost of exissions reductions equation
@NLconstraint(vanilla_2013, [i=1:N], Λ[i] == YGROSS[i] * θ₁[i] * μ[i]^θ₂ * partfract[i]^(1-θ₂));
# Equation for MC abatement
@NLconstraint(vanilla_2013, [i=1:N], MCABATE[i] == pbacktime[i] * μ[i]^(θ₂-1));
# Carbon price equation from abatement
@NLconstraint(vanilla_2013, [i=1:N], CPRICE[i] == pbacktime[i] * (μ[i]/partfract[i])^(θ₂-1));
# Output gross equation
@NLconstraint(vanilla_2013, [i=1:N], YGROSS[i] == A[i]*(L[i]/1000.0)^(1-γₑ)*K[i]^γₑ);
# Output net of damages equation
@constraint(vanilla_2013, [i=1:N], YNET[i] == YGROSS[i]*(1-Ω[i]));
# Output net equation
@constraint(vanilla_2013, [i=1:N], Y[i] == YNET[i] - Λ[i]);
# Consumption equation
cc = @constraint(vanilla_2013, [i=1:N], C[i] == Y[i] - I[i]);
# Per capita consumption definition
@constraint(vanilla_2013, [i=1:N], CPC[i] == 1000.0 * C[i] / L[i]);
# Savings rate equation
@constraint(vanilla_2013, [i=1:N], I[i] == S[i] * Y[i]);
# Period utility
@constraint(vanilla_2013, [i=1:N], CEMUTOTPER[i] == PERIODU[i] * L[i] * rr[i]);
# Instantaneous utility function equation
@NLconstraint(vanilla_2013, [i=1:N], PERIODU[i] == ((C[i]*1000.0/L[i])^(1-α)-1)/(1-α)-1);

# Equations (offset) #
# Cumulative carbon emissions
@constraint(vanilla_2013, [i=1:N-1], CCA[i+1] == CCA[i] + Eind[i]*5/3.666);
# Atmospheric concentration equation
@constraint(vanilla_2013, [i=1:N-1], Mₐₜ[i+1] == Mₐₜ[i]*ϕ₁₁ + Mᵤₚ[i]*ϕ₂₁ + E[i]*(5/3.666));
# Lower ocean concentration
@constraint(vanilla_2013, [i=1:N-1], Mₗₒ[i+1] == Mₗₒ[i]*ϕ₃₃ + Mᵤₚ[i]*ϕ₂₃);
# Shallow ocean concentration
@constraint(vanilla_2013, [i=1:N-1], Mᵤₚ[i+1] == Mₐₜ[i]*ϕ₁₂ + Mᵤₚ[i]*ϕ₂₂ + Mₗₒ[i]*ϕ₃₂);
# Temperature-climate equation for atmosphere
@constraint(vanilla_2013, [i=1:N-1], Tₐₜ[i+1] == Tₐₜ[i] + ξ₁*((FORC[i+1]-λ*Tₐₜ[i])-(ξ₃*(Tₐₜ[i]-Tₗₒ[i]))));
# Temperature-climate equation for lower oceans
@constraint(vanilla_2013, [i=1:N-1], Tₗₒ[i+1] == Tₗₒ[i] + ξ₄*(Tₐₜ[i]-Tₗₒ[i]));
# Capital balance equation
@constraint(vanilla_2013, [i=1:N-1], K[i+1] <= (1-δk)^tstep * K[i] + tstep*I[i]);
# Interest rate equation
@NLconstraint(vanilla_2013, [i=1:N-1], RI[i] == (1+ρ)*(CPC[i+1]/CPC[i])^(α/tstep)-1);

# Savings rate for asympotic equilibrium
@constraint(vanilla_2013, S[i=51:N] .== optlrsav);
# Initial conditions
@constraint(vanilla_2013, CCA[1] == 90.0);
@constraint(vanilla_2013, K[1] == k₀);
@constraint(vanilla_2013, Mₐₜ[1] == mat₀);
@constraint(vanilla_2013, Mᵤₚ[1] == mu₀);
@constraint(vanilla_2013, Mₗₒ[1] == ml₀);
@constraint(vanilla_2013, Tₐₜ[1] == tatm₀);
@constraint(vanilla_2013, Tₗₒ[1] == tocean₀);

@constraint(vanilla_2013, UTILITY == tstep * scale1 * sum(CEMUTOTPER[i] for i=1:N) + scale2);

# Objective function
@objective(vanilla_2013, Max, UTILITY);

#status = solve(vanilla_2013)
#status2 = solve(vanilla_2013)
#status3 = solve(vanilla_2013)

# Model outputs #
#tatm = getvalue(Tₐₜ); # Atmospheric Temperature (deg C above preindustrial)
#forc = getvalue(FORC); # Total Increase in Forcing (Watts per Meter2, preindustrial)
#tocean = getvalue(Tₗₒ);# Lower Ocean Temperature (deg C above preindustrial)
# Calculate social cost of carbon
#scc = -1000.0.*getdual(eeq)./getdual(cc);

