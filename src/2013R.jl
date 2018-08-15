# Flavours
abstract type Flavour end
struct VanillaFlavour <: Flavour end
struct RockyRoadFlavour <: Flavour end

Base.show(io::IO, f::VanillaFlavour) = print(io, "Vanilla flavour")
Base.show(io::IO, f::RockyRoadFlavour) = print(io, "Rocky Road flavour")

Vanilla = VanillaFlavour()
RockyRoad = RockyRoadFlavour()

export Vanilla, RockyRoad

struct V2013R{F<:Flavour} <: Version
    flavour::F
end

Base.show(io::IO, v::V2013R) = print(io, "v2013R ($(v.flavour))")

"""
    v2013R([flavour])

Identifier for the 2013R version of the model.
Defaults to the `Vanilla` flavour, but also accepts `RockyRoad`.

# Examples
```jldoctest
julia> v2013R()
v2013R (Vanilla flavour)
```

```jldoctest
julia> v2013R(Vanilla)
v2013R (Vanilla flavour)
```

```jldoctest
julia> v2013R(RockyRoad)
v2013R (Rocky Road flavour)
```
"""
function v2013R(flavour::F = VanillaFlavour()) where {F<:Flavour}
    V2013R{F}(flavour)
end

export v2013R

@extend struct VariablesV2013 <: Variables
    Eind::Array{JuMP.Variable,1} # Industrial emissions (GtCO2 per year)
    Ω::Array{JuMP.Variable,1} # Damages as fraction of gross output
    Λ::Array{JuMP.Variable,1} # Cost of emissions reductions  (trillions 2005 USD per year)
    CPRICE::Array{JuMP.Variable,1} # Carbon price (2005$ per ton of CO2)
    CEMUTOTPER::Array{JuMP.Variable,1} # Period utility
end

function model_vars(version::V2013R{F}, model::JuMP.Model, N::Int64, cca_ubound::Float64, μ_ubound::Array{Float64,1}, cprice_ubound::Array{Float64,1}) where F <: Flavour
    # Variables #
    @variable(model, 0.0 <= μ[i=1:N] <= μ_ubound[i]); # Emission control rate GHGs
    @variable(model, FORC[1:N]); # Increase in radiative forcing (watts per m2 from 1900)
    @variable(model, 0.0 <= Tₐₜ[1:N] <= 40.0); # Increase temperature of atmosphere (degrees C from 1900)
    @variable(model, -1.0 <= Tₗₒ[1:N] <= 20.0); # Increase temperatureof lower oceans (degrees C from 1900)
    @variable(model, Mₐₜ[1:N] >= 10.0); # Carbon concentration increase in atmosphere (GtC from 1750)
    @variable(model, Mᵤₚ[1:N] >= 100.0); # Carbon concentration increase in shallow oceans (GtC from 1750)
    @variable(model, Mₗₒ[1:N] >= 1000.0); # Carbon concentration increase in lower oceans (GtC from 1750)
    @variable(model, E[1:N]); # Total CO2 emissions (GtCO2 per year)
    @variable(model, Eind[1:N]); # Industrial emissions (GtCO2 per year)
    @variable(model, C[1:N] >= 2.0); # Consumption (trillions 2005 US dollars per year)
    @variable(model, K[1:N] >= 1.0); # Capital stock (trillions 2005 US dollars)
    @variable(model, CPC[1:N] >= 0.01); #  Per capita consumption (thousands 2005 USD per year)
    @variable(model, I[1:N] >= 0.0); # Investment (trillions 2005 USD per year)
    @variable(model, S[1:N]); # Gross savings rate as fraction of gross world product
    @variable(model, RI[1:N]); # Real interest rate (per annum)
    @variable(model, Y[1:N] >= 0.0); # Gross world product net of abatement and damages (trillions 2005 USD per year)
    @variable(model, YGROSS[1:N] >= 0.0); # Gross world product GROSS of abatement and damages (trillions 2005 USD per year)
    @variable(model, YNET[1:N]); # Output net of damages equation (trillions 2005 USD per year)
    @variable(model, DAMAGES[1:N]); # Damages (trillions 2005 USD per year)
    @variable(model, Ω[1:N]); # Damages as fraction of gross output
    @variable(model, Λ[1:N]); # Cost of emissions reductions  (trillions 2005 USD per year)
    @variable(model, MCABATE[1:N]); # Marginal cost of abatement (2005$ per ton CO2)
    @variable(model, CCA[1:N] <= cca_ubound); # Cumulative industrial carbon emissions (GTC)
    @variable(model, PERIODU[1:N]); # One period utility function
    @variable(model, CPRICE[i=1:N] <= cprice_ubound[i]); # Carbon price (2005$ per ton of CO2)
    @variable(model, CEMUTOTPER[1:N]); # Period utility
    @variable(model, UTILITY); # Welfare function
    VariablesV2013(μ,FORC,Tₐₜ,Tₗₒ,Mₐₜ,Mᵤₚ,Mₗₒ,E,C,K,CPC,I,S,RI,Y,YGROSS,YNET,DAMAGES,MCABATE,CCA,PERIODU,UTILITY,Eind,Ω,Λ,CPRICE,CEMUTOTPER)
end

include("Results2013R.jl")
include("2013RVanilla.jl")
include("2013RRockyRoad.jl")
