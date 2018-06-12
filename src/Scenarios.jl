immutable BasePriceScenario <: Scenario end
immutable OptimalPriceScenario <: Scenario end
immutable Limit2DegreesScenario <: Scenario end
immutable SternScenario <: Scenario end
immutable SternCalibratedScenario <: Scenario end
immutable CopenhagenScenario <: Scenario end

BasePrice = BasePriceScenario()
OptimalPrice = OptimalPriceScenario()
Limit2Degrees = Limit2DegreesScenario()
Stern = SternScenario()
SternCalibrated = SternCalibratedScenario()
Copenhagen = CopenhagenScenario()

Base.show(io::IO, s::BasePriceScenario) = print(io, "Base (current policy) carbon price")
Base.show(io::IO, s::OptimalPriceScenario) = print(io, "Optimal carbon price")
Base.show(io::IO, s::Limit2DegreesScenario) = print(io, "Limit warming to 2° with damages")
Base.show(io::IO, s::SternScenario) = print(io, "Stern")
Base.show(io::IO, s::SternCalibratedScenario) = print(io, "Calibrated Stern")
Base.show(io::IO, s::CopenhagenScenario) = print(io, "Copenhagen participation")

export BasePrice, OptimalPrice, Limit2Degrees, Stern, SternCalibrated, Copenhagen
