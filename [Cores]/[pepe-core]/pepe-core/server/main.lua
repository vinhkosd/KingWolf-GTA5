Framework = {}
Framework.Config = Config
Framework.Shared = Shared
Framework.ServerCallbacks = {}
Framework.UseableItems = {}

function GetCoreObject()
	return Framework
end

RegisterServerEvent('Framework:GetObject')
AddEventHandler('Framework:GetObject', function(cb)
	cb(GetCoreObject())
end)

Framework.ShowSuccess = function(source, msg)
	print("\x1b[32m[pepe-core:LOG]\x1b[0m "..msg)
end
Citizen.CreateThread(function()
	print("\x1b[32m[pepe-core:LOG]\x1b[0m main.lua")
end)