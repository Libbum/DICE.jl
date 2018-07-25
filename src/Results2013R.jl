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

function model_results(model::JuMP.Model, config::Options, params::Parameters, vars::Variables, eqs::Equations)
    years = 2005+(config.tstep*(1:config.N));
    Mₐₜ = getvalue(vars.Mₐₜ);
    Mₐₜppm = getvalue(vars.Mₐₜ)/2.13;
    Mᵤₚ = getvalue(vars.Mᵤₚ);
    Mₗₒ = getvalue(vars.Mₗₒ);
    CCA = getvalue(vars.CCA);
    CCAratio = getvalue(vars.CCA)/config.fosslim;
    Tₐₜ = getvalue(vars.Tₐₜ);
    FORC = getvalue(vars.FORC);
    Tₗₒ = getvalue(vars.Tₗₒ);
    YGROSS = getvalue(vars.YGROSS);
    Ω = getvalue(vars.Ω);
    DAMAGES = getvalue(vars.DAMAGES);
    YNET = getvalue(vars.YNET);
    Λ = getvalue(vars.Λ);
    MCABATE = getvalue(vars.MCABATE);
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
    co2price_avg = if typeof(params) <: VanillaParameters
        co2price.*params.partfract
    else
        co2price.*getvalue(params.partfract)
    end;
    RI = getvalue(vars.RI);
    CEMUTOTPER = getvalue(vars.CEMUTOTPER);
    scc = if typeof(eqs) <: VanillaEquations
        -1000.*getdual(eqs.eeq)./getdual(eqs.cc)
    else
        -1000.*getdual(eqs.eeq)./getdual(eqs.yy)
    end;
    ResultsV2013(years,Mₐₜ,Mₐₜppm,Mᵤₚ,Mₗₒ,CCA,CCAratio,Tₐₜ,FORC,Tₗₒ,YGROSS,DAMAGES,YNET,
               Y,E,I,K,MPK,C,CPC,PERIODU,UTILITY,S,μ,RI,scc,Eind,Σ,Ω,Λ,co2price,cprice,μ_participants,MCABATE,co2price_avg,CEMUTOTPER)
end
