return function(text, centerY)
    local wSize = imgui.GetWindowSize()
    imgui.SetCursorPosX(wSize.x / 2 - imgui.CalcTextSize((text:gsub('{%x+}', ''))).x / 2)
    if centerY then
        imgui.SetCursorPosY(wSize.y / 2 - imgui.CalcTextSize((text:gsub('{%x+}', ''))).y / 2)
    end
    UI.Components.TextColoredRGB(text)
end
