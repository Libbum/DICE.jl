struct BasePriceScenario <: Scenario end
struct OptimalPriceScenario <: Scenario end
struct L2Scenario <: Scenario end
struct SternScenario <: Scenario end
struct SternCalibratedScenario <: Scenario end
struct CopenhagenScenario <: Scenario end

BasePrice = BasePriceScenario()
OptimalPrice = OptimalPriceScenario()
L2 = L2Scenario()
Stern = SternScenario()
SternCalibrated = SternCalibratedScenario()
Copenhagen = CopenhagenScenario()

export BasePrice, OptimalPrice, L2, Stern, SternCalibrated, Copenhagen
