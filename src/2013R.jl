# Flavours
abstract type Flavour end
struct VanillaFlavour <: Flavour end
struct RockyRoadFlavour <: Flavour end

Base.show(io::IO, f::VanillaFlavour) = print(io, "Vanilla flavour")
Base.show(io::IO, f::RockyRoadFlavour) = print(io, "Rocky Road flavour")

Vanilla = VanillaFlavour()
RockyRoad = RockyRoadFlavour()

export Vanilla, RockyRoad

struct V2013R{T<:Flavour} <: Version
    flavour::T
end

Base.show(io::IO, v::V2013R) = print(io, "v2013R ($(v.flavour))")

function v2013R(flavour::T = VanillaFlavour()) where {T<:Flavour}
    V2013R{T}(flavour)
end


export v2013R

include("2013RVanilla.jl")
include("2013RRockyRoad.jl")

export vanilla_2013R, vanilla_2013R_options,
       rockyroad_2013R, rockyroad_2013R_options
