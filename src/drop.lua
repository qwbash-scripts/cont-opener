-- Когда делал это еще не понял, что в CEF'е контейнера количество предметов пишется без учёта бонусов
-- думал по пизде сохраняется дроп. ну пусть будет, хуле
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
    print(table.toString(items))
    for _, item in pairs(items) do
        print(string.format('title: %s ; count: %s', item.title, item.count))
        local entry = containerDropCollector[date][item.title]
        print(table.toString(entry or {}))
        if entry == nil then
            entry = { name = item.title, amount = 0 }
            containerDropCollector[date][item.title] = entry
        end

        if containerDropPrices[item.title] == nil then
            containerDropPrices[item.title] = { price = imgui.new.int(1000) }
            containerDropPrices()
        end
        print(string.format('entry.amount before = %s', entry.amount))
        entry.amount = entry.amount + item.count
        print(string.format('entry.amount after = %s', entry.amount))
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
