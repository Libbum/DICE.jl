function scenario_alterations(s::SternScenario, config::RockyRoadOptions, params::RockyRoadParameters)
    config.α = 1.01;
    config.ρ = 0.001;
    params.optlrsav = (config.δk + .004)/(config.δk + .004*config.α + config.ρ)*config.γₑ;
    for i = 1:config.N
        params.rr[i] = 1 ./ ((1+config.ρ).^(config.tstep*(i-1)));
    end
end

function scenario_alterations(s::SternCalibratedScenario, config::RockyRoadOptions, params::RockyRoadParameters)
    config.α = 2.1;
    config.ρ = 0.001;
    params.optlrsav = (config.δk + .004)/(config.δk + .004*config.α + config.ρ)*config.γₑ;
    for i = 1:config.N
        params.rr[i] = 1 ./ ((1+config.ρ).^(config.tstep*(i-1)));
    end
end

function scenario_alterations(s::CopenhagenScenario, config::RockyRoadOptions, params::RockyRoadParameters)
    #The Copenhagen participation fraction.
    imported_partfrac = ones(config.N);
    imported_partfrac[1:18] = [0.2,0.390423082,0.379051794,0.434731269,0.42272216,0.410416777,0.707776548,0.692148237,0.840306905,0.834064356,0.939658852,0.936731085,0.933881267,0.930944201,0.928088049,0.925153812,0.922301007,0.919378497];

    params.partfract .= imported_partfrac;
end

function scenario_alterations(s::Scenario, config::RockyRoadOptions, params::RockyRoadParameters)
end

function assign_scenario(s::BasePriceScenario, model::Model, config::RockyRoadOptions, params::RockyRoadParameters, vars::VariablesV2013)
    JuMP.set_value(params.ψ₂, 0.0);
    optimize!(model);

    photel = value.(vars.CPRICE);

    for i in 1:config.N
        if i <= config.tnopol
            JuMP.set_upper_bound(vars.CPRICE[i], max(photel[i],params.cpricebase[i]));
        end
    end
    JuMP.set_value(params.ψ₂, config.ψ₂₀);
end

function assign_scenario(s::OptimalPriceScenario, model::Model, config::RockyRoadOptions, params::RockyRoadParameters, vars::VariablesV2013)
    JuMP.set_upper_bound(vars.μ[1], config.μ₀);
    for i in 2:config.N
        JuMP.delete_upper_bound(vars.μ[i]);
    end
end

function assign_scenario(s::Limit2DegreesScenario, model::Model, config::RockyRoadOptions, params::RockyRoadParameters, vars::VariablesV2013)
    # The model becomes concave if we have the I.C. fixed,
    # so we remove this constraint and add it in a less liberal fashion.
    JuMP.unfix(vars.Tₐₜ[1]);
    JuMP.set_lower_bound(vars.Tₐₜ[1], 0.0);
    @constraint(model, vars.Tₐₜ[1] == config.tatm₀);
    for i in 1:config.N
        JuMP.set_upper_bound(vars.Tₐₜ[i], 2.0);
    end
end

function assign_scenario(s::SternCalibratedScenario, model::Model, config::RockyRoadOptions, params::RockyRoadParameters, vars::VariablesV2013)
    for i in 1:config.N
        JuMP.set_lower_bound(vars.μ[i], 0.01);
    end

    JuMP.fix(vars.μ[1], 0.038976; force=true);
    JuMP.fix(vars.Tₐₜ[1], 0.83; force=true);
end

function assign_scenario(s::CopenhagenScenario, model::Model, config::RockyRoadOptions, params::RockyRoadParameters, vars::VariablesV2013)
    # The Emissions Control Rate Imported
    imported_μ = fill(0.9, config.N);
    imported_μ[1:27] = [0.02,0.055874801,0.110937151,0.163189757,0.206247482,0.241939219,0.30180914,0.364484979,0.423670192,0.478283881,0.534073643,0.588156847,0.633622,0.672457,0.705173102,0.733018573,0.756457118,0.776297581,0.794110815,0.822197128,0.839125811,0.854453754,0.868106413,0.880485825,0.891631752,0.901741794,0.9];

    for i in 1:config.N
        JuMP.fix(vars.μ[i], imported_μ[i]; force=true);
    end
end

function assign_scenario(s::Scenario, model::Model, config::RockyRoadOptions, params::RockyRoadParameters, vars::VariablesV2013)
end
