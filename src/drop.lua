--  огда делал это еще не пон€л, что в CEF'е контейнера количество предметов пишетс€ без учЄта бонусов
-- думал по пизде сохран€етс€ дроп. ну пусть будет, хуле
-- да, Drop:apply никогда не будет использован во врем€ работы скрипта
Drop = {}

dropPending = {}
isSavingDrop = false

function Drop:queue(date, items)
    if not isSavingDrop then
        self:apply(date, items)
        return
    end

    dropPending[date] = dropPending[date] or {}
    for _, item in pairs(items) do
        local entry = dropPending[date][item.title]
        if entry == nil then
            entry = { name = item.title, count = 0 }
            dropPending[date][item.title] = entry
        end

        entry.count = entry.count + item.count
    end
end

function Drop:apply(date, items)
    if containerDropCollector[date] == nil then
        containerDropCollector[date] = {}
    end

    for _, item in pairs(items) do
        local entry = containerDropCollector[date][item.title]
        if entry == nil then
            entry = { name = item.title, amount = 0 }
            containerDropCollector[date][item.title] = entry
        end

        if containerDropPrices[item.title] == nil then
            containerDropPrices[item.title] = { price = imgui.new.int(1000) }
            containerDropPrices()
        end
        entry.amount = entry.amount + item.count
    end
end

function Drop:flushPendingDrops()
    for date, bucket in pairs(dropPending) do
        local list = {}
        for _, v in pairs(bucket) do
            list[#list + 1] = { title = v.name, count = v.count }
        end
        self:apply(date, list)
    end
    dropPending = {}
end
