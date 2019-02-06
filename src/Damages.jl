immutable DefaultDamage <: Damage end
immutable TippingPointDamage <: Damage end
immutable EnvironmentalGoodsDamage <: Damage end
immutable FractionProductiviyDamage <: Damage end

Default = DefaultDamage()
TippingPoint = TippingPointDamage()
EnvironmentalGoods = EnvironmentalGoodsDamage()
FractionProductiviy = FractionProductiviyDamage()

Base.show(io::IO, s::DefaultDamage) = print(io, "Default")
Base.show(io::IO, s::TippingPointDamage) = print(io, "Tipping Point")
Base.show(io::IO, s::EnvironmentalGoodsDamage) = print(io, "Incommensurable Environmental Goods")
Base.show(io::IO, s::FractionProductiviyDamage) = print(io, "Fraction of Productivity")

export Default, TippingPoint, FractionProductiviy, EnvironmentalGoods
