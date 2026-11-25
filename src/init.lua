DEBUG = MOONLY_BUNDLED == nil
require('moonloader')
sampev = require('samp.events')
ffi = require('ffi')
cjc = require('carbJsonConfig')
encoding = require('encoding')
encoding.default = 'CP1251'
u8 = encoding.UTF8

ti = require('tabler_icons')
imgui = require('mimgui')


autoOpen = false
BASE_PATH = getGameDirectory() .. '\\moonloader'

require('drop')
require('config')
require('events')
require('utils')
require('cef')
require('arizona')
require('js')
require('ui')

function main()
    while not isSampAvailable() do wait(0) end
    Arizona:Init()
    sampRegisterChatCommand('cnt', function() UI.window[0] = not UI.window[0] end)

    lua_thread.create(function()
        while true do
            wait(500)

            isSavingDrop = true
            containerDropCollector()
            isSavingDrop = false

            Drop:flushPendingDrops()
        end
    end)

    sampRegisterChatCommand('contopen', function()
        if not Config.openInInventory[0] and crypto_wallet.slot == nil then
            Utils.msg('Нету крипто-сумки в инвентаре или не удалось получить её слот!')
            Utils.msg('Переместите её в другой слот / Отсортируйте инвентарь / Перезайдите в игру')
            return
        end

        if not Config.openInInventory[0] and table.Size(containers.accessible_containers_in_wallet) == 0 then
            Utils.msg('Нету доступных контейнеров в сумке или не удалось получить их количество!')
            return
        end

        if Config.openInInventory[0] and table.Size(containers.accessible_containers) == 0 then
            Utils.msg('Нету доступных контейнеров в инвентаре или не удалось получить их количество!')
            Utils.msg('Отсортируйте инвентарь / Перезайдите в игру')
            return
        end

        autoOpen = not autoOpen
        Utils.msg('Автооткрытие', autoOpen and 'включено' or 'выключено')
    end)

    while true do wait(0) end
end
