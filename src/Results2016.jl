@extend struct ResultsV2016 <: Results
    Eind::Array{Float64,1} # Industrial emissions (GtCO2 per year)
    Σ::Array{Float64,1} #World Emissions Intensity
    Ω::Array{Float64,1} # Damages as fraction of gross output
    Λ::Array{Float64,1} # Cost of emissions reductions  (trillions USD per year)
    co2price::Array{Float64,1} # Carbon Dioxide Price (per t CO2)
    cprice::Array{Float64,1} # Carbon Price (per t CO2)
    μ_participants::Array{Float64,1} # Emissions Control Rate (participants)
    CCATOT::Array{Float64,1} # Cumulative total emissions
    atfrac::Array{Float64,1} # Atmospheric fraction since 1850
    atfrac2010::Array{Float64,1} # Atmospheric fraction since 2010
end

function model_results(model::JuMP.Model, config::Options, params::ParametersV2016, vars::VariablesV2016, eqs::EquationsV2016)
    years = 2010+(config.tstep*(1:config.N));
    Mₐₜ = getvalue(vars.Mₐₜ);
    Mₐₜppm = Mₐₜ/2.13;
    Mᵤₚ = getvalue(vars.Mᵤₚ);
    Mₗₒ = getvalue(vars.Mₗₒ);
    CCA = getvalue(vars.CCA);
    CCATOT = getvalue(vars.CCATOT);
    CCAratio = getvalue(vars.CCA)/config.fosslim;
    Tₐₜ = getvalue(vars.Tₐₜ);
    FORC = getvalue(vars.FORC);
    Tₗₒ = getvalue(vars.Tₗₒ);
    YGROSS = getvalue(vars.YGROSS);
    Ω = getvalue(vars.Ω);
    DAMAGES = getvalue(vars.DAMAGES);
    YNET = getvalue(vars.YNET);
    Λ = getvalue(vars.Λ);
    Y = getvalue(vars.Y);
    E = getvalue(vars.E);
    Eind = getvalue(vars.Eind);
    Σ = Eind./YGROSS;
    I = getvalue(vars.I);
    K = getvalue(vars.K);
    MPK = config.γₑ.*YGROSS./K;
    C = getvalue(vars.C);
    CPC = getvalue(vars.CPC);
    PERIODU = getvalue(vars.PERIODU);
    UTILITY = getvalue(vars.UTILITY);
    S = getvalue(vars.S);
    co2price = getvalue(vars.CPRICE);
    cprice = getvalue(vars.CPRICE)*3.666;
    μ = getvalue(vars.μ);
    μ_participants = (co2price./params.pbacktime).^(1/(config.θ₂-1));
    RI = getvalue(vars.RI);
    scc = -1000.*getdual(eqs.eeq)./(.00001+getdual(eqs.cc));
    atfrac = (Mₐₜ-588)./(CCATOT+.000001);
    atfrac2010 = (Mₐₜ-config.mat₀)./(.00001+CCATOT-CCATOT[1]);
    ResultsV2016(years,Mₐₜ,Mₐₜppm,Mᵤₚ,Mₗₒ,CCA,CCAratio,Tₐₜ,FORC,Tₗₒ,YGROSS,DAMAGES,YNET,
               Y,E,I,K,MPK,C,CPC,PERIODU,UTILITY,S,μ,RI,scc,Eind,Σ,Ω,Λ,co2price,cprice,μ_participants,CCATOT,atfrac,atfrac2010)
end
