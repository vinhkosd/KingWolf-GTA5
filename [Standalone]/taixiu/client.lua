------------------------------------------------------------------
--                          Variables
------------------------------------------------------------------

local showMenu = false

print('tai xiu client loaded')

------------------------------------------------------------------
--                          CODE CLIENT TÀI XỈU
------------------------------------------------------------------


-- Bắt sự kiện pull từ ui tới client sau đó dispatch tới Server
RegisterNUICallback('pull', function(data)
  -- data.id --idEnt
  -- data.dice --tai/xiu
  -- data.money -- so tien cuoc
  local msg = nil
  
  TriggerServerEvent('putMoney', data.id, data.dice, data.money, function(dataCallBack)
    msg = {}
    msg.pull = dataCallBack
    SendNUIMessage(msg)
  end)
  
  -- SetNuiFocus(data.nuifocus, data.nuifocus)
end)

------------------------------------------------------------------
--                          Citizen
------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
    local Ped = GetPlayerPed(-1)
    -- Get informations about what user is targeting
    -- /!\ If not working, check that you have added "target" folder to resources and server.cfg
    TriggerServerEvent("gameStart", function(callback)
      Citizen.Trace(callback) --would never get called
    end)

    Citizen.Wait(1)
	end
end)