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

function model_results(model::JuMP.Model, config::OptionsV2016, params::ParametersV2016, vars::VariablesV2016, eqs::EquationsV2016)
    years = 2010 .+ (config.tstep*(1:config.N));
    Mₐₜ = value.(vars.Mₐₜ);
    Mₐₜppm = Mₐₜ/2.13;
    Mᵤₚ = value.(vars.Mᵤₚ);
    Mₗₒ = value.(vars.Mₗₒ);
    CCA = value.(vars.CCA);
    CCATOT = value.(vars.CCATOT);
    CCAratio = value.(vars.CCA)/config.fosslim;
    Tₐₜ = value.(vars.Tₐₜ);
    FORC = value.(vars.FORC);
    Tₗₒ = value.(vars.Tₗₒ);
    YGROSS = value.(vars.YGROSS);
    Ω = value.(vars.Ω);
    DAMAGES = value.(vars.DAMAGES);
    YNET = value.(vars.YNET);
    Λ = value.(vars.Λ);
    Y = value.(vars.Y);
    E = value.(vars.E);
    Eind = value.(vars.Eind);
    Σ = Eind./YGROSS;
    I = value.(vars.I);
    K = value.(vars.K);
    MPK = config.γₑ.*YGROSS./K;
    C = value.(vars.C);
    CPC = value.(vars.CPC);
    PERIODU = value.(vars.PERIODU);
    UTILITY = value(vars.UTILITY);
    S = value.(vars.S);
    co2price = value.(vars.CPRICE);
    cprice = value.(vars.CPRICE)*3.666;
    μ = value.(vars.μ);
    μ_participants = (co2price./params.pbacktime).^(1/(config.θ₂-1));
    RI = value.(vars.RI);
    scc = 1000 .* shadow_price.(eqs.eeq)./(.00001 .+ shadow_price.(eqs.cc));
    atfrac = (Mₐₜ .- 588)./(CCATOT .+ .000001);
    atfrac2010 = (Mₐₜ .- config.mat₀)./(.00001 .+ CCATOT .- CCATOT[1]);
    ResultsV2016(years,Mₐₜ,Mₐₜppm,Mᵤₚ,Mₗₒ,CCA,CCAratio,Tₐₜ,FORC,Tₗₒ,YGROSS,DAMAGES,YNET,
               Y,E,I,K,MPK,C,CPC,PERIODU,UTILITY,S,μ,RI,scc,Eind,Σ,Ω,Λ,co2price,cprice,μ_participants,CCATOT,atfrac,atfrac2010)
end
