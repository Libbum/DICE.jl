function assign_scenario(s::BasePriceScenario, config::VanillaOptions, params::VanillaParameters)
    params.cpricebase
end

function assign_scenario(s::OptimalPriceScenario, config::VanillaOptions, params::VanillaParameters)
    fill(Inf, config.N)
end

function assign_scenario(s::Scenario, config::VanillaOptions, params::VanillaParameters)
    error("$(s) is not a valid scenario for v2013R (Vanilla flavour)");
end
