-- Huge server file.

local interiors = {
	[1] = { ["xe"] = 929.79364013672, ["ye"] = 43.871932983398, ["ze"] = 81.09211730957, ["he"] = 174.98580932, ["xo"] = 907.61151123047, ["yo"] = -942.62115478516, ["zo"] = 44.414596557617, ["ho"] = 279.950988, ["name"] = 'Casino'},
}

RegisterServerEvent("interiors:sendData_s")
AddEventHandler("interiors:sendData_s", function()
    TriggerClientEvent("interiors:f_sendData", source, interiors)
end)
