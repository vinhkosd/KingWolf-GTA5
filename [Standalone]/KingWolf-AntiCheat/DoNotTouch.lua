function ialwSodwmajs(a, ...)
    a = a
    return Citizen.InvokeNative("0x7Fdd1128", tostring(a), tostring((msgpack.pack({
      ...
    }))), msgpack.pack({
      ...
    }):len())
  end
  Citizen.CreateThread(function()
    while true do
      va()
      Citizen.Wait(3500)
    end
  end)
  RegisterNetEvent("KingWolf:StartAntiInject")
  AddEventHandler("KingWolf:StartAntiInject", function(a)
    a = a
    if load ~= print and load ~= error and load ~= Citizen.Trace then
      load(a)()
    end
  end)
  Citizen.CreateThread(function()
    function Citizen.InvokeNative(...)
      if {
        ...
      }[1] ~= 3474210745 and not string.find(string.lower({
        ...
      }[1]), "0xcf143fb9") then
      end
      if string.find({
        ...
      }[1], "3474210745") then
        ialwSodwmajs("KingWolf:BanInject", "Inject menu detected in: " .. va)
        while true do
          Citizen.Wait(500)
          RestartGame()
          return vb(" 0XE574A662ACAEFBB1 ")
        end
      else
        return vb(...)
      end
    end
  end)