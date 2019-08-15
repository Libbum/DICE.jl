@extend struct ResultsV2013 <: Results
    Eind::Array{Float64,1} # Industrial emissions (GtCO2 per year)
    Σ::Array{Float64,1} #World Emissions Intensity
    Ω::Array{Float64,1} # Damages as fraction of gross output
    Λ::Array{Float64,1} # Cost of emissions reductions  (trillions USD per year)
    co2price::Array{Float64,1} # Carbon Dioxide Price (per t CO2)
    cprice::Array{Float64,1} # Carbon Price (per t CO2)
    μ_participants::Array{Float64,1} # Emissions Control Rate (participants)
    MCABATE::Array{Float64,1} # Marginal cost of abatement (2005$ per ton CO2)
    co2price_avg::Array{Float64,1} # Carbon Price (Global Average)
    CEMUTOTPER::Array{Float64,1} # Period utility
end

function model_results(model::Model, config::Options, params::Parameters, vars::Variables, eqs::Equations)
    years = 2005 .+ (config.tstep*(1:config.N));
    Mₐₜ = value.(vars.Mₐₜ);
    Mₐₜppm = value.(vars.Mₐₜ)/2.13;
    Mᵤₚ = value.(vars.Mᵤₚ);
    Mₗₒ = value.(vars.Mₗₒ);
    CCA = value.(vars.CCA);
    CCAratio = value.(vars.CCA)/config.fosslim;
    Tₐₜ = value.(vars.Tₐₜ);
    FORC = value.(vars.FORC);
    Tₗₒ = value.(vars.Tₗₒ);
    YGROSS = value.(vars.YGROSS);
    Ω = value.(vars.Ω);
    DAMAGES = value.(vars.DAMAGES);
    YNET = value.(vars.YNET);
    Λ = value.(vars.Λ);
    MCABATE = value.(vars.MCABATE);
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
    co2price_avg = co2price.*params.partfract
    RI = value.(vars.RI);
    CEMUTOTPER = value.(vars.CEMUTOTPER);
    scc = if typeof(eqs) <: VanillaEquations
        1000 .* shadow_price.(eqs.eeq)./shadow_price.(eqs.cc)
    else
        1000 .* shadow_price.(eqs.eeq)./shadow_price.(eqs.yy)
    end;
    ResultsV2013(years,Mₐₜ,Mₐₜppm,Mᵤₚ,Mₗₒ,CCA,CCAratio,Tₐₜ,FORC,Tₗₒ,YGROSS,DAMAGES,YNET,
               Y,E,I,K,MPK,C,CPC,PERIODU,UTILITY,S,μ,RI,scc,Eind,Σ,Ω,Λ,co2price,cprice,μ_participants,MCABATE,co2price_avg,CEMUTOTPER)
end
