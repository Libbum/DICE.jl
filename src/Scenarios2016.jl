# BasePriceScenario functions are in 2016R.jl and 2016R2.jl respectively.
# We handle the OptimalPriceScenario here only.

function assign_scenario(s::OptimalPriceScenario, model::Model, config::Options, params::ParametersV2016, vars::VariablesV2016; idx::Int64=1)
    JuMP.fix(vars.μ[1], config.μ₀; force=true);
end

function assign_scenario(s::Scenario, model::JuMP.Model, config::Options, params::ParametersV2016, vars::VariablesV2016; idx::Int64=1)
    if config <: OptionsV2016R
        error("$(s) is not a valid scenario for v2016R beta");
    else
        error("$(s) is not a valid scenario for v2016R2");
    end
end
