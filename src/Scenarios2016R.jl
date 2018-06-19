function assign_scenario(s::BasePriceScenario, model::JuMP.Model, config::OptionsV2016, params::ParametersV2016, vars::VariablesV2016)
    setvalue(params.ψ₂, 0.0);

    JuMP.solve(model);

    photel = getvalue(vars.CPRICE);

    setvalue(params.ψ₂, config.ψ₂₀);
    for i in 1:config.N
        if i <= config.tnopol
            setupperbound(vars.CPRICE[i], max(photel[i],params.cpricebase[i]));
        end
    end
end

function assign_scenario(s::OptimalPriceScenario, model::JuMP.Model, config::OptionsV2016, params::ParametersV2016, vars::VariablesV2016)
    setupperbound(vars.μ[1], config.μ₀);
end

function assign_scenario(s::Scenario, model::JuMP.Model, config::OptionsV2016, params::ParametersV2016, vars::VariablesV2016)
    error("$(s) is not a valid scenario for v2016R beta");
end
