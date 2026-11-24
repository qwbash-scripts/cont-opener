return function(sizes)
    for _, size in ipairs(sizes) do
        UI.font[size] = {}

        local config = imgui.ImFontConfig()
        config.MergeMode = true
        config.PixelSnapH = true
        local iconRanges = imgui.new.ImWchar[3](ti.min_range, ti.max_range, 0)
        imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(ti.get_font_data_base85(), size, config, iconRanges) -- Обязательно
        UI.font[size] = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', size, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
        imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(ti.get_font_data_base85(), size, config, iconRanges)
    end
end
