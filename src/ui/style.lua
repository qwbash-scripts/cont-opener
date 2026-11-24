imgui.OnInitialize(function()
    imgui.GetIO().IniFilename = nil
    -- UI.Colors:Init()
    UI.font.Init(UI.font.requiredSizes)
    local colors                           = imgui.GetStyle().Colors
    colors[imgui.Col.Text]                 = imgui.ImVec4(0.95, 0.96, 0.98, 1.00)
    colors[imgui.Col.TextDisabled]         = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)

    colors[imgui.Col.WindowBg]             = imgui.ImVec4(0.12, 0.12, 0.13, 1.00)
    colors[imgui.Col.ChildBg]              = imgui.ImVec4(0.14, 0.14, 0.15, 1.00)
    colors[imgui.Col.PopupBg]              = imgui.ImVec4(0.16, 0.16, 0.17, 0.98)

    colors[imgui.Col.Border]               = imgui.ImVec4(0.28, 0.28, 0.30, 0.60)
    colors[imgui.Col.BorderShadow]         = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)

    colors[imgui.Col.FrameBg]              = imgui.ImVec4(0.20, 0.20, 0.22, 1.00)
    colors[imgui.Col.FrameBgHovered]       = imgui.ImVec4(0.25, 0.25, 0.28, 1.00)
    colors[imgui.Col.FrameBgActive]        = imgui.ImVec4(0.30, 0.30, 0.34, 1.00)

    colors[imgui.Col.TitleBg]              = imgui.ImVec4(0.10, 0.10, 0.11, 1.00)
    colors[imgui.Col.TitleBgActive]        = imgui.ImVec4(0.15, 0.15, 0.16, 1.00)
    colors[imgui.Col.TitleBgCollapsed]     = imgui.ImVec4(0.08, 0.08, 0.09, 1.00)

    colors[imgui.Col.MenuBarBg]            = imgui.ImVec4(0.14, 0.14, 0.15, 1.00)

    colors[imgui.Col.ScrollbarBg]          = imgui.ImVec4(0.10, 0.10, 0.10, 0.60)
    colors[imgui.Col.ScrollbarGrab]        = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
    colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(0.45, 0.45, 0.48, 1.00)
    colors[imgui.Col.ScrollbarGrabActive]  = imgui.ImVec4(0.55, 0.55, 0.58, 1.00)

    colors[imgui.Col.CheckMark]            = imgui.ImVec4(0.75, 0.75, 0.78, 0.50)

    colors[imgui.Col.SliderGrab]           = imgui.ImVec4(0.55, 0.55, 0.60, 1.00)
    colors[imgui.Col.SliderGrabActive]     = imgui.ImVec4(0.70, 0.70, 0.75, 1.00)

    colors[imgui.Col.Button]               = imgui.ImVec4(0.24, 0.24, 0.26, 1.00)
    colors[imgui.Col.ButtonHovered]        = imgui.ImVec4(0.32, 0.32, 0.35, 1.00)
    colors[imgui.Col.ButtonActive]         = imgui.ImVec4(0.40, 0.40, 0.44, 1.00)

    colors[imgui.Col.Header]               = imgui.ImVec4(0.25, 0.25, 0.28, 1.00)
    colors[imgui.Col.HeaderHovered]        = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
    colors[imgui.Col.HeaderActive]         = imgui.ImVec4(0.45, 0.45, 0.48, 1.00)

    colors[imgui.Col.Separator]            = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
    colors[imgui.Col.SeparatorHovered]     = imgui.ImVec4(0.50, 0.50, 0.55, 1.00)
    colors[imgui.Col.SeparatorActive]      = imgui.ImVec4(0.65, 0.65, 0.70, 1.00)

    colors[imgui.Col.ResizeGrip]           = imgui.ImVec4(0.40, 0.40, 0.43, 0.40)
    colors[imgui.Col.ResizeGripHovered]    = imgui.ImVec4(0.55, 0.55, 0.60, 0.70)
    colors[imgui.Col.ResizeGripActive]     = imgui.ImVec4(0.70, 0.70, 0.75, 1.00)

    colors[imgui.Col.Tab]                  = imgui.ImVec4(0.18, 0.18, 0.20, 1.00)
    colors[imgui.Col.TabHovered]           = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
    colors[imgui.Col.TabActive]            = imgui.ImVec4(0.28, 0.28, 0.31, 1.00)
    colors[imgui.Col.TabUnfocused]         = imgui.ImVec4(0.14, 0.14, 0.15, 1.00)
    colors[imgui.Col.TabUnfocusedActive]   = imgui.ImVec4(0.22, 0.22, 0.24, 1.00)
end)
