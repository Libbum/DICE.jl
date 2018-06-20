function assign_scenario(s::BasePriceScenario, model::JuMP.Model, config::RockyRoadOptions, params::RockyRoadParameters, vars::VariablesV2013)
    setvalue(params.ψ₂, 0.0);

    JuMP.solve(model);

    photel = getvalue(vars.CPRICE);

    for i in 1:config.N
        if i <= config.tnopol
            setupperbound(vars.CPRICE[i], max(photel[i],params.cpricebase[i]));
        end
    end

    setvalue(params.ψ₂, config.ψ₂₀);
end

function assign_scenario(s::OptimalPriceScenario, model::JuMP.Model, config::RockyRoadOptions, params::RockyRoadParameters, vars::VariablesV2013)
    #Coerce ICs first.
    JuMP.solve(model);
    setupperbound(vars.μ[1], config.μ₀);
end

function assign_scenario(s::Limit2DegreesScenario, model::JuMP.Model, config::RockyRoadOptions, params::RockyRoadParameters, vars::VariablesV2013)
    #Coerce ICs first.
    JuMP.solve(model);
    for i in 1:config.N
        setupperbound(vars.Tₐₜ[i], 2.0);
    end
end

function assign_scenario(s::SternScenario, model::JuMP.Model, config::RockyRoadOptions, params::RockyRoadParameters, vars::VariablesV2013)
    setvalue(params.α, 1.01);
    setvalue(params.ρ, 0.001);
    setvalue(params.optlrsav, (config.δk + .004)/(config.δk + .004*1.01 + 0.001)*config.γₑ);
    setvalue(params.rr[i=1:config.N], 1./((1+0.001).^(config.tstep*(i-1))));
end

function assign_scenario(s::SternCalibratedScenario, model::JuMP.Model, config::RockyRoadOptions, params::RockyRoadParameters, vars::VariablesV2013)
    setvalue(params.α, 2.1);
    setvalue(params.ρ, 0.001);
    setvalue(params.optlrsav, (config.δk + .004)/(config.δk + .004*2.1 + 0.001)*config.γₑ);
    setvalue(params.rr[i=1:config.N], 1./((1+0.001).^(config.tstep*(i-1))));

    for i in 1:config.N
        setlowerbound(vars.μ[i], 0.01);
    end

    JuMP.fix(vars.μ[1], 0.038976);
    JuMP.fix(vars.Tₐₜ[1], 0.83);

    JuMP.solve(model);
end

function assign_scenario(s::CopenhagenScenario, model::JuMP.Model, config::RockyRoadOptions, params::RockyRoadParameters, vars::VariablesV2013)
    #The Copenhagen participation fraction.
    imported_partfrac = ones(config.N);
    imported_partfrac[1:19] = [0.2,0.390423082,0.379051794,0.434731269,0.42272216,0.410416777,0.707776548,0.692148237,0.840306905,0.834064356,0.939658852,0.936731085,0.933881267,0.930944201,0.928088049,0.925153812,0.922301007,0.919378497,1.0];

    setvalue(params.partfract[i=1:config.N], imported_partfrac[i]);

    # The Emissions Control Rate Imported
    imported_μ = fill(0.9, config.N);
    imported_μ[1:27] = [0.02,0.055874801,0.110937151,0.163189757,0.206247482,0.241939219,0.30180914,0.364484979,0.423670192,0.478283881,0.534073643,0.588156847,0.633622,0.672457,0.705173102,0.733018573,0.756457118,0.776297581,0.794110815,0.822197128,0.839125811,0.854453754,0.868106413,0.880485825,0.891631752,0.901741794,0.9];

    #Setting bounds on a fixed value is kind of irrelevant really...
    setlowerbound(vars.μ[1], 0.0);
    setupperbound(vars.μ[1], 1.5);
    for i in 1:config.N
        JuMP.fix(vars.μ[i], imported_μ[i]);
    end
end
