-- global variable for locales
Locales = {}

-- this is for translation
function _U(str, ...)
    local text = Locales["vi"][str:lower()]
    -- print(str)
    if text ~= nil then
        return string.format(text, ...)
    else
        return str
    end
end