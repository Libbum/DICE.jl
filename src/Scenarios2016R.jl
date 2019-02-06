function assign_scenario(s::BasePriceScenario, damage::Damage, model::JuMP.Model, config::OptionsV2016, params::ParametersV2016, vars::VariablesV2016)
    # We add the first solve since our run is infeasible without it.
    JuMP.solve(model);
    setvalue(params.ψ₂, 0.0);
    JuMP.solve(model);

    photel = getvalue(vars.CPRICE);

    if typeof(damage) == EnvironmentalGoodsDamage
        setvalue(params.ψ₂, config.ψ₂);
    else
        setvalue(params.ψ₂, config.ψ₂);
    end
    for i in 1:config.N
        if i <= config.tnopol
            setupperbound(vars.CPRICE[i], max(photel[i],params.cpricebase[i]));
        end
    end
end

function assign_scenario(s::OptimalPriceScenario, damage::Damage, model::JuMP.Model, config::OptionsV2016, params::ParametersV2016, vars::VariablesV2016)
    setupperbound(vars.μ[1], config.μ₀);
end

function assign_scenario(s::Scenario, damage::Damage, model::JuMP.Model, config::OptionsV2016, params::ParametersV2016, vars::VariablesV2016)
    error("$(s) is not a valid scenario for v2016R beta");
end
