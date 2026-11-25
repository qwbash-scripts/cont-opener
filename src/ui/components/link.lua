return function(link, name, myfunc)
    myfunc = type(name) == 'boolean' and name or myfunc or false
    name = type(name) == 'string' and name or type(name) == 'boolean' and link or link
    local size = imgui.CalcTextSize(name)
    local p = imgui.GetCursorScreenPos()
    local p2 = imgui.GetCursorPos()
    local resultBtn = imgui.InvisibleButton('##' .. link .. name, size)
    if resultBtn then
        if not myfunc then
            CEF:eval("window.cef.Open('" .. tostring(link) .. "', 1);")
        end
    end
    imgui.SetCursorPos(p2)
    local col = { 0xFFFF7700, 0xFFFF9900 }
    local color = imgui.IsItemHovered() and col[1] or col[2]
    imgui.TextColored(imgui.ColorConvertU32ToFloat4(color), name)

    return resultBtn
end
