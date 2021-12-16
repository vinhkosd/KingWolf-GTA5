Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

local coTheDatCuoc = false
local tongTienDatTai = 0
local tongTienDatXiu = 0
local soNguoiChonTai = 0
local soNguoiChonXiu = 0
local idChonTai = {}
local idChonXiu = {}
local ketQua = ''

function putMoney(id, cau, tien)
    if (coTheDatCuoc == false) then
        local returnData = {}
        returnData.status = 'error'
        returnData.error = 'Không thể đặt, vui lòng chờ giây lát'
        return (returnData)
    end
  
    if cau == 'tai' then
      -- thêm tiền vào tổng số tiền đặt tài
      tongTienDatTai = tongTienDatTai + tien;
      -- thêm id vào list id array nếu chưa có
      for i=1, #idChonTai do
            if(idChonTai[i] ~= nil and idChonTai[i].id == id) then
                idChonTai[i].tien = idChonTai[i].tien + tien
            else
                chonTai = {}
                chonTai.id = id
                chonTai.cau = 'tai'
                chonTai.tien = tien
                table.insert(idChonTai, chonTai)
            end
        end
    else if cau == 'xiu' then
      -- thêm tiền vào tổng số tiền đặt tài
      tongTienDatXiu += tien;
      -- thêm id vào list id array nếu chưa có
        for i=1, #idChonXiu, 1 do
            if(idChonXiu[i] ~= nil and idChonXiu[i].id == id) then
                idChonXiu[i].tien = idChonXiu[i].tien + tien
                canAdd = true
            else
                chonXiu = {}
                chonXiu.id = id
                chonXiu.cau = 'tai'
                chonXiu.tien = tien
                table.insert(idChonXiu, chonXiu)
            end
        end
    end
    local returnData = {}
    returnData.status = 'success'
    return (returnData)
end


RegisterServerEvent('putMoney')
AddEventHandler('putMoney', function(id, cau, tien, callback)
	callback(putMoney(id, cau, tien))
end)