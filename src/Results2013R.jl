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
    Mₐₜ = JuMP.value.(vars.Mₐₜ);
    Mₐₜppm = JuMP.value.(vars.Mₐₜ)/2.13;
    Mᵤₚ = JuMP.value.(vars.Mᵤₚ);
    Mₗₒ = JuMP.value.(vars.Mₗₒ);
    CCA = JuMP.value.(vars.CCA);
    CCAratio = JuMP.value.(vars.CCA)/config.fosslim;
    Tₐₜ = JuMP.value.(vars.Tₐₜ);
    FORC = JuMP.value.(vars.FORC);
    Tₗₒ = JuMP.value.(vars.Tₗₒ);
    YGROSS = JuMP.value.(vars.YGROSS);
    Ω = JuMP.value.(vars.Ω);
    DAMAGES = JuMP.value.(vars.DAMAGES);
    YNET = JuMP.value.(vars.YNET);
    Λ = JuMP.value.(vars.Λ);
    MCABATE = JuMP.value.(vars.MCABATE);
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
    co2price_avg = if typeof(params) <: VanillaParameters
        co2price.*params.partfract
    else
        co2price.*JuMP.value.(params.partfract)
    end;
    RI = JuMP.value.(vars.RI);
    CEMUTOTPER = JuMP.value.(vars.CEMUTOTPER);
    scc = if typeof(eqs) <: VanillaEquations
        -1000.0*JuMP.dual.(eqs.eeq)./JuMP.dual.(eqs.cc)
    else
        -1000.0*JuMP.dual.(eqs.eeq)./JuMP.dual.(eqs.yy)
    end;
    ResultsV2013(years,Mₐₜ,Mₐₜppm,Mᵤₚ,Mₗₒ,CCA,CCAratio,Tₐₜ,FORC,Tₗₒ,YGROSS,DAMAGES,YNET,
               Y,E,I,K,MPK,C,CPC,PERIODU,UTILITY,S,μ,RI,scc,Eind,Σ,Ω,Λ,co2price,cprice,μ_participants,MCABATE,co2price_avg,CEMUTOTPER)
end
