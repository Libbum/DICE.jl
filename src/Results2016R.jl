@extend struct ResultsV2016 <: Results
    CCATOT::Array{Float64,1} # Cumulative total emissions
    atfrac::Array{Float64,1} # Atmospheric fraction since 1850
    atfrac2010::Array{Float64,1} # Atmospheric fraction since 2010
end

function model_results(model::JuMP.Model, config::OptionsV2016, params::ParametersV2016, vars::VariablesV2016, eqs::EquationsV2016)
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
    ResultsV2016(years,Mₐₜ,Mₐₜppm,Mᵤₚ,Mₗₒ,CCA,CCAratio,Tₐₜ,FORC,Tₗₒ,YGROSS,Ω,DAMAGES,YNET,Λ,
               Y,E,Eind,Σ,I,K,MPK,C,CPC,PERIODU,UTILITY,S,co2price,cprice,μ,μ_participants,RI,scc,CCATOT,atfrac,atfrac2010)
end
