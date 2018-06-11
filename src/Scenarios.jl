immutable BasePriceScenario <: Scenario end
immutable OptimalPriceScenario <: Scenario end
immutable L2Scenario <: Scenario end
immutable SternScenario <: Scenario end
immutable SternCalibratedScenario <: Scenario end
immutable CopenhagenScenario <: Scenario end

BasePrice = BasePriceScenario()
OptimalPrice = OptimalPriceScenario()
L2 = L2Scenario()
Stern = SternScenario()
SternCalibrated = SternCalibratedScenario()
Copenhagen = CopenhagenScenario()

export BasePrice, OptimalPrice, L2, Stern, SternCalibrated, Copenhagen
