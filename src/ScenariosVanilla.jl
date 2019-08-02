function assign_scenario(s::BasePriceScenario, config::VanillaOptions, params::VanillaParameters)
    bound_cprice(params.cpricebase)
end

function assign_scenario(s::OptimalPriceScenario, config::VanillaOptions, params::VanillaParameters)
    bound_cprice(fill(Inf, config.N))
end

function assign_scenario(s::Scenario, config::VanillaOptions, params::VanillaParameters)
    error("$(s) is not a valid scenario for v2013R (Vanilla flavour)");
end

function bound_cprice(cprice_ubound::Array{Float64,1})
    cprice_ubound[1] = params.cpricebase[1];
    # Warning: If parameters are changed, the next equation might make base case infeasible.
    # If so, reduce tnopol so that we don't run out of resources.
    for i in 2:config.N
        if i > config.tnopol
            cprice_ubound[i] = 1000.0;
        end
    end
    cprice_ubound
end
