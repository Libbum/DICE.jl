function assign_scenario(s::BasePriceScenario, model::Model, config::OptionsV2016, params::ParametersV2016, vars::VariablesV2016)
    # We add the first solve since our run is infeasible without it.
#    optimize!(model);
    JuMP.set_value(params.ψ₂, 0.0);
    optimize!(model);

    photel = value.(vars.CPRICE);

    for i in 1:config.N
        println(photel[i]);
    end

    JuMP.set_value(params.ψ₂, config.ψ₂);
    for i in 1:config.N
        if i <= config.tnopol
            JuMP.set_upper_bound(vars.CPRICE[i], max(photel[i],params.cpricebase[i]));
            println(max(photel[i],params.cpricebase[i]));
        end
    end
end

function assign_scenario(s::OptimalPriceScenario, model::Model, config::OptionsV2016, params::ParametersV2016, vars::VariablesV2016)
    JuMP.set_upper_bound(vars.μ[1], config.μ₀);
end

function assign_scenario(s::Scenario, model::JuMP.Model, config::OptionsV2016, params::ParametersV2016, vars::VariablesV2016)
    error("$(s) is not a valid scenario for v2016R beta");
end
