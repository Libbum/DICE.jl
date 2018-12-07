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

function model_results(model::Model, config::OptionsV2016, params::ParametersV2016, vars::VariablesV2016, eqs::EquationsV2016)
    years = 2010 .+(config.tstep*(1:config.N));
    Mₐₜ = JuMP.value.(vars.Mₐₜ);
    Mₐₜppm = Mₐₜ/2.13;
    Mᵤₚ = JuMP.value.(vars.Mᵤₚ);
    Mₗₒ = JuMP.value.(vars.Mₗₒ);
    CCA = JuMP.value.(vars.CCA);
    CCATOT = JuMP.value.(vars.CCATOT);
    CCAratio = JuMP.value.(vars.CCA)/config.fosslim;
    Tₐₜ = JuMP.value.(vars.Tₐₜ);
    FORC = JuMP.value.(vars.FORC);
    Tₗₒ = JuMP.value.(vars.Tₗₒ);
    YGROSS = JuMP.value.(vars.YGROSS);
    Ω = JuMP.value.(vars.Ω);
    DAMAGES = JuMP.value.(vars.DAMAGES);
    YNET = JuMP.value.(vars.YNET);
    Λ = JuMP.value.(vars.Λ);
    Y = JuMP.value.(vars.Y);
    E = JuMP.value.(vars.E);
    Eind = JuMP.value.(vars.Eind);
    Σ = Eind./YGROSS;
    I = JuMP.value.(vars.I);
    K = JuMP.value.(vars.K);
    MPK = config.γₑ.*YGROSS./K;
    C = JuMP.value.(vars.C);
    CPC = JuMP.value.(vars.CPC);
    PERIODU = JuMP.value.(vars.PERIODU);
    UTILITY = JuMP.value(vars.UTILITY);
    S = JuMP.value.(vars.S);
    co2price = JuMP.value.(vars.CPRICE);
    cprice = JuMP.value.(vars.CPRICE)*3.666;
    μ = JuMP.value.(vars.μ);
    μ_participants = (co2price./params.pbacktime).^(1/(config.θ₂-1));
    RI = JuMP.value.(vars.RI);
    scc = -1000.0 .*JuMP.dual.(eqs.eeq)./(.00001 .+JuMP.dual.(eqs.cc));
    atfrac = (Mₐₜ .-588)./(CCATOT .+.000001);
    atfrac2010 = (Mₐₜ .-config.mat₀)./(.00001 .+CCATOT .-CCATOT[1]);
    ResultsV2016(years,Mₐₜ,Mₐₜppm,Mᵤₚ,Mₗₒ,CCA,CCAratio,Tₐₜ,FORC,Tₗₒ,YGROSS,DAMAGES,YNET,
               Y,E,I,K,MPK,C,CPC,PERIODU,UTILITY,S,μ,RI,scc,Eind,Σ,Ω,Λ,co2price,cprice,μ_participants,CCATOT,atfrac,atfrac2010)
end
