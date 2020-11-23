DensityMulitplier = 1.0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        SetVehicleDensityMultiplaierThisFrame(0.0)
        SetPedSenityMultiplierThisFrame(0.0)
        SetRandomVehicleDensityMultiplierThisFrame(0.0)
        SetParkedVehicleDensityMultiplierThisFrame(DensityMulitplier)
        SetScenarioPedDensityMultiplierThisFrame(DensityMulitplier, DensityMulitplier)
    end
end)