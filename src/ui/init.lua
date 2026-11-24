EarnedMoneyFormulas = { u8('Без ничего'), u8('Уровень ВИП'), u8('Выбранная сумка'), u8('Уровень ВИП + Выбранная сумка') }
UI = {
    window = imgui.new.bool(true),
    currentDateLog = '',
    earnedMoney = 0,
    cryptoWalletsCombo = imgui.new['const char*'][#crypto_wallet.list](crypto_wallet.list),
    EarnedMoneyFormulasCombo = imgui.new['const char*'][#EarnedMoneyFormulas](EarnedMoneyFormulas),
    priceFilter = imgui.ImGuiTextFilter(),
    Components = {
        TextColoredRGB = require('ui.components.text-colored-rgb'),
        CenterText = require('ui.components.center-text'),
        CenterColumnText = require('ui.components.center-column-text'),
        ActiveButton = require('ui.components.active-button'),
        Tooltip = require('ui.components.tooltip')
    },
    font = {
        Init = require('ui.fonts'),
        requiredSizes = { 12, 14, 18, 24 }
    }
}

require('ui.style')

imgui.OnFrame(function() return UI.window[0] end, function(player)
    local sw, sh = getScreenResolution()
    imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(800, 540), imgui.Cond.FirstUseEver)
    if (imgui.Begin('Cont Opener', UI.window, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)) then
        if imgui.BeginChild('datalogs', imgui.ImVec2(185, 435), true) then
            for date, _ in pairs(containerDropCollector) do
                if UI.Components.ActiveButton(UI.currentDateLog == date, date, imgui.ImVec2(imgui.GetWindowWidth() - 15, 20)) then
                    UI.currentDateLog = date
                end
            end
            imgui.EndChild()
        end
        imgui.SameLine()
        if imgui.BeginChild('hhzhzhhz', imgui.ImVec2(-1, 435), true) then
            imgui.Columns(3)
            UI.Components.CenterColumnText(u8 'Название предмета'); imgui.SetColumnWidth(-1, 250)
            imgui.NextColumn()
            UI.Components.CenterColumnText(u8 'Цена за штуку'); imgui.SetColumnWidth(-1, 120)
            imgui.NextColumn()
            UI.Components.CenterColumnText(u8 'Получено'); imgui.SetColumnWidth(-1, 205)
            imgui.Columns(1)
            imgui.Separator()

            for date, items in pairs(containerDropCollector) do
                if date == UI.currentDateLog then
                    UI.earnedMoney = 0

                    local sortItems = {}

                    for _, k in pairs(items) do
                        table.insert(sortItems, k)
                    end

                    table.sort(sortItems, function(a, b)
                        if a.amount == b.amount then
                            return a.name < b.name
                        end

                        return containerDropPrices[a.name].price[0] * a.amount > containerDropPrices[b.name].price[0] * b.amount
                    end)

                    for item_id, data in pairs(sortItems) do
                        if data.name == 'Пачка с деньгами' then
                            UI.earnedMoney = UI.earnedMoney + data.amount
                            imgui.Columns(3)
                            UI.Components.CenterColumnText(u8(data.name)); imgui.SetColumnWidth(-1, 250)
                            imgui.NextColumn()
                            UI.Components.CenterColumnText('-'); imgui.SetColumnWidth(-1, 120)
                            imgui.NextColumn()
                            UI.Components.CenterColumnText(string.format('{5f9a59}+%s SA$', Utils.commaValue(data.amount, '.'))); imgui.SetColumnWidth(-1, 205)
                            imgui.Columns(1)
                            imgui.Separator()
                        else
                            UI.earnedMoney = UI.earnedMoney + containerDropPrices[data.name].price[0] * data.amount
                            imgui.Columns(3)
                            UI.Components.CenterColumnText(u8(data.name)); imgui.SetColumnWidth(-1, 250)
                            imgui.NextColumn()
                            UI.Components.CenterColumnText(string.format('{5f9a59}%s SA$', Utils.commaValue(containerDropPrices[data.name].price[0], '.'))); imgui.SetColumnWidth(-1, 120)
                            imgui.NextColumn()
                            UI.Components.CenterColumnText(u8(string.format('{5f9a59}+%s SA$ {6087c4}(%s шт.)', Utils.commaValue(containerDropPrices[data.name].price[0] * data.amount, '.'), data.amount))); imgui.SetColumnWidth(-1, 205)
                            imgui.Columns(1)
                            imgui.Separator()
                        end
                    end
                end
            end
            imgui.EndChild()
        end
        if imgui.BeginChild('price list settings', imgui.ImVec2(185, 60), true) then
            imgui.PushFont(UI.font[24])
            if imgui.Button(ti('database-dollar'), imgui.ImVec2(50, 40)) then
                imgui.OpenPopup(u8(('Настройка цен')))
            end
            imgui.SameLine()
            if imgui.Button(ti('settings'), imgui.ImVec2(50, 40)) then
                imgui.OpenPopup(u8('Настройки'))
            end
            imgui.SameLine()
            if imgui.Button(ti('info-circle'), imgui.ImVec2(50, 40)) then
                imgui.OpenPopup(u8('Информация'))
            end
            imgui.PopFont()

            if imgui.BeginPopupModal(u8 'Настройка цен', _, imgui.WindowFlags.NoResize) then
                imgui.Text(u8('Поиск:'))
                UI.priceFilter:Draw('##searchPriceFilter', 400)
                if imgui.BeginChild('price settings', imgui.ImVec2(600, 400), true) then
                    for k, v in pairs(containerDropPrices) do
                        if k ~= 'Пачка с деньгами' then
                            if UI.priceFilter:PassFilter(u8(k)) then
                                imgui.PushItemWidth(135)
                                if imgui.InputInt('##' .. k, v.price, 0) then
                                    containerDropPrices()
                                end
                                imgui.PopItemWidth()
                                imgui.SameLine()
                                UI.Components.TextColoredRGB(u8(string.format('Цена в {5f9a59}SA${ffffff} за %s', k)))
                                imgui.SetCursorPosY(imgui.GetCursorPosY() + 7)
                            end
                        end
                    end
                    imgui.EndChild()
                end

                if imgui.Button(u8 'Закрыть', imgui.ImVec2(imgui.GetWindowWidth() - 15, 30)) then
                    imgui.CloseCurrentPopup()
                end
            end

            if imgui.BeginPopupModal(u8 'Настройки', _, imgui.WindowFlags.NoResize) then
                if imgui.BeginChild('settings', imgui.ImVec2(600, 400), true) then
                    if imgui.Checkbox(u8('Скрывать сообщения от бонусов крипто сумки'), Config.hideMessagesFromCryptoWallet) then
                        Config()
                    end
                    if imgui.Checkbox(u8('Скрывать сообщения от бонусов уровня VIP'), Config.hideMessagesFromPremiumVIP) then
                        Config()
                    end

                    if imgui.Checkbox(u8('Открывать из инвентаря -> '), Config.openInInventory) then
                        Config()
                    end
                    imgui.SameLine()
                    imgui.PushFont(UI.font[18])
                    imgui.Text(ti('question-mark'))
                    imgui.PopFont()
                    UI.Components.Tooltip(u8('Включено - открываться будут только те контейнеры, которые находятся в инвентаре\nВыключено - открываться будут только контейнеры из крипто-сумки'))

                    if imgui.ColorEdit4(u8('##Цвет иконки доступного к открытию контейнера'), Config.boxTypeColor, imgui.ColorEditFlags.NoInputs) then
                        Config()
                    end
                    imgui.SameLine()
                    imgui.Text(u8('Цвет иконки доступного к открытию контейнера'))
                    imgui.SameLine()
                    if imgui.Button(u8('Применить'), imgui.ImVec2(imgui.CalcTextSize(u8('Применить')).x + 20, 20)) then
                        Config()
                        Arizona:applyBoxTypeIconColor(Config.boxTypeColor)
                    end


                    imgui.Separator()

                    imgui.PushItemWidth(120)
                    if imgui.InputInt(u8('Курс покупки VC доллара'), Config.buyCostOfVC, 0) then
                        Config()
                    end

                    if imgui.InputInt(u8('Курс продажи VC доллара'), Config.sellCostOfVC, 0) then
                        Config()
                    end
                    imgui.PopItemWidth()

                    imgui.Separator()

                    imgui.PushItemWidth(250)
                    if imgui.Combo(u8('СумОчка'), Config.selectedCryptoWallet, UI.cryptoWalletsCombo, #crypto_wallet.list) then
                        Config()
                    end
                    if imgui.Combo(u8('##Как считаем?'), Config.selectedEarnedMoneyForumula, UI.EarnedMoneyFormulasCombo, #EarnedMoneyFormulas) then
                        Config()
                    end
                    imgui.PopItemWidth()
                    imgui.SameLine()
                    imgui.Text(u8('Как считаем итоговую сумму?'))

                    imgui.Separator()

                    imgui.Text(u8('Тачки для быстрого слива:'))
                    -- Почему не сохраняло?
                    -- for carId, name in pairs(rofloCars.mapById) do
                    --     if imgui.Checkbox(u8(name), Config.canISellRofloCars[carId]) then
                    --         Config()
                    --     end
                    -- end
                    if imgui.Checkbox(u8('Elegy'), Config.canISellElegy) then Config() end
                    if imgui.Checkbox(u8('Cheetah'), Config.canISellCheetah) then Config() end
                    if imgui.Checkbox(u8('Phoenix'), Config.canISellPhoenix) then Config() end
                    if imgui.Checkbox(u8('Картинг'), Config.canISellKarting) then Config() end

                    imgui.EndChild()
                end

                if imgui.Button(u8 'Закрыть', imgui.ImVec2(imgui.GetWindowWidth() - 15, 30)) then
                    imgui.CloseCurrentPopup()
                end
            end

            imgui.EndChild()
        end

        imgui.SameLine()

        if imgui.BeginChild('earned money', imgui.ImVec2(-1, 60), true) then
            local earnedMoney = UI.earnedMoney
            local earnedMoneyVC = math.floor(earnedMoney / Config.buyCostOfVC[0])
            local walletBonus = crypto_wallet.bonusesMapByName[u8:decode(crypto_wallet.list[Config.selectedCryptoWallet[0] + 1])]
            local rainbowRainbowMoneyVC = Utils.rainbow_text(string.format('+%s VC$', Utils.commaValue(earnedMoneyVC, '.')), { 'af47ff', 'db8eff', 'cb74ff' })

            if Config.selectedEarnedMoneyForumula[0] == 0 then
                UI.Components.CenterText(u8(string.format('Итоговая сумма: {5f9a59}+%s SA$ {ffffff}(%s{ffffff})', Utils.commaValue(earnedMoney, '.'), rainbowRainbowMoneyVC)), true)
            elseif Config.selectedEarnedMoneyForumula[0] == 1 then
                earnedMoney = math.floor((earnedMoney + earnedMoney * 0.15) + 0.5)
                earnedMoneyVC = math.floor(earnedMoney / Config.buyCostOfVC[0])
                rainbowRainbowMoneyVC = Utils.rainbow_text(string.format('+%s VC$', Utils.commaValue(earnedMoneyVC, '.')), { 'af47ff', 'db8eff', 'cb74ff' })
                UI.Components.CenterText(u8(string.format('Итоговая сумма: {5f9a59}+%s SA$ {ffffff}(%s{ffffff})', Utils.commaValue(earnedMoney, '.'), rainbowRainbowMoneyVC)), true)
            elseif Config.selectedEarnedMoneyForumula[0] == 2 then
                earnedMoney = math.floor((earnedMoney + earnedMoney * walletBonus) + 0.5)
                earnedMoneyVC = math.floor(earnedMoney / Config.buyCostOfVC[0])
                rainbowRainbowMoneyVC = Utils.rainbow_text(string.format('+%s VC$', Utils.commaValue(earnedMoneyVC, '.')), { 'af47ff', 'db8eff', 'cb74ff' })
                UI.Components.CenterText(u8(string.format('Итоговая сумма: {5f9a59}+%s SA$ {ffffff}(%s{ffffff})', Utils.commaValue(earnedMoney, '.'), rainbowRainbowMoneyVC)), true)
            elseif Config.selectedEarnedMoneyForumula[0] == 3 then
                earnedMoney = math.floor(((earnedMoney + earnedMoney * 0.15) + (earnedMoney + earnedMoney * 0.15) * walletBonus) + 0.5)
                earnedMoneyVC = math.floor(earnedMoney / Config.buyCostOfVC[0])
                rainbowRainbowMoneyVC = Utils.rainbow_text(string.format('+%s VC$', Utils.commaValue(earnedMoneyVC, '.')), { 'af47ff', 'db8eff', 'cb74ff' })
                UI.Components.CenterText(u8(string.format('Итоговая сумма: {5f9a59}+%s SA$ {ffffff}(%s{ffffff})', Utils.commaValue(earnedMoney, '.'), rainbowRainbowMoneyVC)), true)
            end
            imgui.EndChild()
        end
        imgui.End()
    end
end)

addEventHandler('onWindowMessage', function(msg, key)
    if (msg == 0x0100) then
        if (key == VK_ESCAPE and UI.window[0]) then
            UI.window[0] = false
            consumeWindowMessage(true, true)
        end
    end
end)
