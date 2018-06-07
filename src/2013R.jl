# Flavours
abstract type Flavour end
struct Vanilla <: Flavour end
struct RockyRoad <: Flavour end

Base.show(io::IO, f::Vanilla) = print(io, "Vanilla flavour")
Base.show(io::IO, f::RockyRoad) = print(io, "Rocky Road flavour")

export Vanilla, RockyRoad

struct V2013R{T<:Flavour} <: Version
    flavour::T
end

Base.show(io::IO, v::V2013R) = print(io, "v2013R ($(v.flavour))")

function v2013R(flavour::T = Vanilla()) where {T<:Flavour}
    V2013R{T}(flavour)
end

export v2013R

include("2013RVanilla.jl")
include("2013RRockyRoad.jl")

export vanilla_2013R, vanilla_2013R_options,
       rockyroad_2013R, rockyroad_2013R_options
