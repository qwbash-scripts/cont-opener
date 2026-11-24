return function(text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize((text:gsub('{%x+}', ''))).x / 2)
    UI.Components.TextColoredRGB(text)
end
