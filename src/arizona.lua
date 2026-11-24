---@diagnostic disable: lowercase-global
Arizona = {}

rofloCars = {
    mapById = {
        [765] = 'Сертификат Phoenix',
        [539] = 'Сертификат Cheetah',
        [797] = 'Сертификат Картинг',
        [544] = 'Сертификат Elegy'
    },
    -- ну и говно
    sellFlagByCarId = {
        [544] = 'canISellElegy',
        [539] = 'canISellCheetah',
        [765] = 'canISellPhoenix',
        [797] = 'canISellKarting',
    },
    slots = {},
    clicked = false
}

crypto_wallet = {
    slot = nil,
    mapById = {
        [10057] = 'Крипто сумка новичка',
        [10059] = 'Крипто сумка профи',
        [10061] = 'Крипто сумка олигарха',
        [10063] = 'Крипто сумка короля',
    },
    bonusesMapByName = {
        ['Крипто сумка новичка'] = 0.05,
        ['Крипто сумка профи'] = 0.10,
        ['Крипто сумка олигарха'] = 0.18,
        ['Крипто сумка короля'] = 0.35,
    },
    list = { u8('Крипто сумка новичка'), u8('Крипто сумка профи'), u8('Крипто сумка олигарха'), u8('Крипто сумка короля') }
}

containers = {
    mapById = {
        [5787] = 'НФТ контейнер (обычный)',
        [5788] = 'НФТ контейнер (средний)',
        [5789] = 'НФТ контейнер (премиум)',
        [7375] = 'Гоблинский НФТ контейнер',
        [7435] = 'НФТ Каменного Человека',
        [9333] = 'Супер НФТ контейнер'
    },
    inaccessible_containers = {},
    accessible_containers = {},
    accessible_containers_in_wallet = {},
    free_wallet_slots = {},
    last_container_opened = nil
}

function Arizona:Init()
    addEventHandler('onReceivePacket', function(id, bs)
        if id == 220 then
            raknetBitStreamReadInt8(bs);
            local ptype = raknetBitStreamReadInt8(bs)
            if ptype == 17 then
                raknetBitStreamReadInt32(bs)
                local length = raknetBitStreamReadInt16(bs)
                local encoded = raknetBitStreamReadInt8(bs)
                if length > 0 then
                    local text = (encoded ~= 0) and raknetBitStreamDecodeString(bs, length + encoded) or raknetBitStreamReadString(bs, length)
                    local event, data = text:match("^window.executeEvent%('(.-)', .(.+).%);$");
                    local json = decodeJson(data)

                    if event == 'event.inventory.setWalletVisible' then
                        CEF:evalanon(JS.CollectInaccessibleContainers)
                        CEF:evalanon(JS.StoreAccessibleContainers)

                        if autoOpen and not Config.openInInventory[0] then
                            lua_thread.create(function()
                                wait(350)
                                CEF:send(string.format('clickOnButton|{"type": 50, "slot": %d, "action": 1}', table.random_key(containers.accessible_containers_in_wallet)))
                                CEF:evalcef("window.executeEvent('event.setActiveView', '[ null ]');")
                            end)
                        end
                    end

                    if event == 'event.setActiveView' and data:find('%["Inventory"%]') then
                        CEF:evalanon(JS.RecolorAccessibleContainers)
                        self:applyBoxTypeIconColor(Config.boxTypeColor)

                        if autoOpen then
                            if containers.last_container_opened == nil or containers.last_container_opened < os.time() - 0.5 then
                                if Config.openInInventory[0] then
                                    lua_thread.create(function()
                                        wait(350)
                                        CEF:send(string.format('clickOnButton|{"type": 1, "slot": %d, "action": 1}', table.random_key(containers.accessible_containers)))
                                    end)
                                else
                                    lua_thread.create(function()
                                        wait(350)
                                        CEF:send(string.format('clickOnButton|{"type": 1, "slot": %d, "action": 64}', crypto_wallet.slot))
                                    end)
                                end
                                containers.last_container_opened = os.time()
                            end
                        end
                    end

                    if event == 'event.inventory.playerInventory' then
                        -- Crypto Wallet
                        if json[1].data.type == 50 and json[1].action == 0 then
                            if json[1].action == 0 and json[1].data.items[1] and json[1].data.items[1].slot == 0 then
                                containers.free_wallet_slots = {}
                            end

                            if json[1].data.items then
                                for item_id, item in pairs(json[1].data.items) do
                                    if item.item == nil then containers.free_wallet_slots[item.slot] = item.slot end

                                    if item.item and item.time and item.time ~= 0 then
                                        containers.inaccessible_containers[item.slot] = item.slot
                                    end

                                    if item.item and item.time and item.time == 0 then
                                        containers.accessible_containers_in_wallet[item.slot] = item.slot
                                    end
                                end
                            end
                        end

                        if json[1].data.type == 50 and json[1].action == 2 then
                            local item = json[1].data.items[1]
                            if not item.item then
                                containers.inaccessible_containers[item.slot] = nil
                                containers.free_wallet_slots[item.slot] = item.slot
                            else
                                if item.time and item.time ~= 0 then
                                    containers.accessible_containers_in_wallet[item.slot] = nil
                                end

                                containers.free_wallet_slots[item.slot] = nil
                            end
                        end

                        -- Free Containers
                        if json[1].data.type == 1 and json[1].data.items and (json[1].action == 0 or json[1].action == 2) then
                            if json[1].action == 0 and json[1].data.items[1] and json[1].data.items[1].slot == 0 then
                                containers.accessible_containers = {}
                            end

                            for _, item in pairs(json[1].data.items) do
                                if containers.mapById[item.item] ~= nil then
                                    if item.item and item.time and item.time == 0 then
                                        containers.accessible_containers[item.slot] = item.slot
                                    end
                                elseif crypto_wallet.mapById[item.item] ~= nil then
                                    crypto_wallet.slot = item.slot
                                elseif rofloCars.mapById[item.item] ~= nil then
                                    rofloCars.slots[item.slot] = { slot = item.slot, amount = item.amount, carId = item.item }
                                else
                                    rofloCars.slots[item.slot] = nil
                                    containers.accessible_containers[item.slot] = nil
                                end
                            end
                        end
                    end

                    if event == 'containerContent.initialize' then
                        if containers.last_container_opened == nil or containers.last_container_opened < os.time() - 0.3 then
                            if json[1].items then
                                local currentDate = os.date('%d.%m.%y')
                                Drop:queue(currentDate, json[1].items)
                            end
                            containers.last_container_opened = os.time()
                        end
                    end

                    if autoOpen and event == 'event.setActiveView' and data:find('%["ContainerContent"%]') then
                        CEF:send('containerContent.closeMenu')
                        CEF:send('onActiveViewChanged|null')
                        CEF:evalcef("window.executeEvent('event.setActiveView', '[ null ]');")
                        return false
                    end

                    if event == 'event.notify.initialize' and data:find('Открыть можно только на территории аукциона контейнеров') then
                        autoOpen = false
                    end

                    if event == 'event.notify.initialize' and data:find('У вас не хватает места в инвентаре, требуется 6 слот') then
                        autoOpen = false
                    end

                    if event == 'event.notify.initialize' and data:find('Осталось отыграть для открытия NFT') then
                        autoOpen = false
                    end
                end
            end
        end
    end)

    addEventHandler('onSendPacket', function(id, bs)
        if id == 220 then
            id = raknetBitStreamReadInt8(bs)
            local packettype = raknetBitStreamReadInt8(bs)
            if packettype == 18 then
                local strlen = raknetBitStreamReadInt16(bs)
                local str = raknetBitStreamReadString(bs, strlen)
                if str:find('^cont_opener:.*') then
                    local event = str:match('^cont_opener:(.+);')

                    if event == 'collectInaccessibleContainers' then
                        if DEBUG then
                            Utils.dmsg('collectInaccessibleContainers clicked')
                        end

                        if not crypto_wallet.isCollectingInaccessibleContainers then
                            crypto_wallet.isCollectingInaccessibleContainers = true
                            lua_thread.create(function()
                                for k, v in pairs(containers.inaccessible_containers) do
                                    CEF:send(string.format('clickOnButton|{"type": 50,"slot": %s, "action": 65536}', v))
                                    wait(250)
                                end

                                if DEBUG then
                                    Utils.dmsg('collectInaccessibleContainers finished')
                                end
                                crypto_wallet.isCollectingInaccessibleContainers = false
                            end)
                        else
                            Utils.msg('Я уже достаю контейнеры! Не флуди...')
                        end
                    end

                    if event == 'storeAccessibleContainers' then
                        if DEBUG then
                            Utils.dmsg('storeAccessibleContainers clicked')
                        end

                        if not crypto_wallet.isStoringAccessibleContainers then
                            crypto_wallet.isStoringAccessibleContainers = true
                            lua_thread.create(function()
                                for k, v in pairs(containers.accessible_containers) do
                                    if table.Size(containers.free_wallet_slots) == 0 then break end

                                    CEF:send(string.format('inventory.moveItemForce|{"slot": %s, "type": 1, "amount": 1}', v))
                                    wait(250)
                                end

                                if DEBUG then
                                    Utils.dmsg('storeAccessibleContainers finished')
                                end
                                crypto_wallet.isStoringAccessibleContainers = false
                            end)
                        else
                            Utils.msg('Я уже складываю контейнеры! Не флуди...')
                        end
                    end
                end

                if str:find('inventory.moveItemForce') then
                    -- ЬEinventory.moveItemForce|{"slot": 164, "type": 1, "amount": undefined}
                    local slot, type, _ = str:match('^inventory.moveItemForce|{"slot": (%d+), "type": (%d+), "amount": (.+)}$');
                    slot, type = tonumber(slot), tonumber(type)

                    if type == 1 then
                        if rofloCars.slots[slot] ~= nil and rofloCars.sellFlagByCarId[rofloCars.slots[slot].carId] ~= nil and Config[rofloCars.sellFlagByCarId[rofloCars.slots[slot].carId]][0] == true then
                            rofloCars.clicked = true
                        end
                    end
                end
            end
        end
    end)
end

function Arizona:applyBoxTypeIconColor(rgba)
    CEF:evalanon(string.format('if (window.__inventory9333Green) { window.__inventory9333Green.setColor(\"%s\"); }', Utils.Float4ToHex(rgba)))
end
