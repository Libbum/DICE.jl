function assign_scenario(s::BasePriceScenario, model::JuMP.Model, config::OptionsV2016R2, params::ParametersV2016, vars::VariablesV2016)
    JuMP.set_value(params.ψ₂, 0.000001);
    for i in 1:config.N
        JuMP.set_upper_bound(vars.CPRICE[i], 10000.0);
    end
    optimize!(model);

    photel = value.(vars.CPRICE);

    for i in 1:config.N
        if i <= config.tnopol
            JuMP.set_upper_bound(vars.CPRICE[i], max(photel[i],params.cpricebase[i]));
        end
    end
    JuMP.set_value(params.ψ₂, config.ψ₂);
end

function assign_scenario(s::BasePriceScenario, model::Model, config::OptionsV2016R, params::ParametersV2016, vars::VariablesV2016)
    JuMP.set_value(params.ψ₂, 0.0);
    optimize!(model);

    photel = value.(vars.CPRICE);

    for i in 1:config.N
        if i <= config.tnopol
            JuMP.set_upper_bound(vars.CPRICE[i], max(photel[i],params.cpricebase[i]));
        end
    end
    JuMP.set_value(params.ψ₂, config.ψ₂);
end

function assign_scenario(s::OptimalPriceScenario, model::Model, config::Options, params::ParametersV2016, vars::VariablesV2016)
    JuMP.fix(vars.μ[1], config.μ₀; force=true);
end

function assign_scenario(s::Scenario, model::JuMP.Model, config::Options, params::ParametersV2016, vars::VariablesV2016)
    if typeof(config) <: OptionsV2016R
        error("$(s) is not a valid scenario for v2016R beta");
    else
        error("$(s) is not a valid scenario for v2016R2");
    end
end
