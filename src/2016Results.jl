struct ResultsV2016 <: Results
    years::Array{Int64,1}
    Mₐₜ::Array{Float64,1}
    Mₐₜppm::Array{Float64,1}
    Mᵤₚ::Array{Float64,1}
    Mₗₒ::Array{Float64,1}
    CCA::Array{Float64,1}
    CCATOT::Array{Float64,1}
    CCAratio::Array{Float64,1}
    Tₐₜ::Array{Float64,1}
    FORC::Array{Float64,1}
    Tₗₒ::Array{Float64,1}
    YGROSS::Array{Float64,1}
    Ω::Array{Float64,1}
    DAMAGES::Array{Float64,1}
    YNET::Array{Float64,1}
    Λ::Array{Float64,1}
    Y::Array{Float64,1}
    E::Array{Float64,1}
    Eind::Array{Float64,1}
    Σ::Array{Float64,1} #World Emissions Intensity
    I::Array{Float64,1}
    K::Array{Float64,1}
    MPK::Array{Float64,1} #First Period gross MPK
    C::Array{Float64,1}
    CPC::Array{Float64,1}
    PERIODU::Array{Float64,1}
    UTILITY::Float64
    S::Array{Float64,1}
    co2price::Array{Float64,1}
    cprice::Array{Float64,1}
    μ::Array{Float64,1}
    μ_participants::Array{Float64,1}
    RI::Array{Float64,1}
    scc::Array{Float64,1}
    atfrac::Array{Float64,1}
    atfrac2010::Array{Float64,1}
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
    ResultsV2016(years,Mₐₜ,Mₐₜppm,Mᵤₚ,Mₗₒ,CCA,CCATOT,CCAratio,Tₐₜ,FORC,Tₗₒ,YGROSS,Ω,DAMAGES,YNET,Λ,
               Y,E,Eind,Σ,I,K,MPK,C,CPC,PERIODU,UTILITY,S,co2price,cprice,μ,μ_participants,RI,scc,atfrac,atfrac2010)
end
