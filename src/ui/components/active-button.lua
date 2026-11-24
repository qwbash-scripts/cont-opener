return function(status, ...)
    local button

    if status then
        imgui.PushStyleColor(imgui.Col.Button, imgui.GetStyle().Colors[imgui.Col.CheckMark])
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.GetStyle().Colors[imgui.Col.CheckMark])
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.GetStyle().Colors[imgui.Col.CheckMark])

        button = imgui.Button(...)

        imgui.PopStyleColor(3)
    else
        imgui.PushStyleColor(imgui.Col.Button, imgui.GetStyle().Colors[imgui.Col.FrameBg])
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.GetStyle().Colors[imgui.Col.FrameBg])
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.GetStyle().Colors[imgui.Col.FrameBg])

        button = imgui.Button(...)

        imgui.PopStyleColor(3)
    end

    return button
end
