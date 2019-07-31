struct BasePriceScenario <: Scenario end
struct OptimalPriceScenario <: Scenario end
struct Limit2DegreesScenario <: Scenario end
struct SternScenario <: Scenario end
struct SternCalibratedScenario <: Scenario end
struct CopenhagenScenario <: Scenario end

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
