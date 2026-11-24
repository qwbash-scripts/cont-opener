Utils = {}

function Utils.msg(...)
    return sampAddChatMessage(string.format('[ :lua: ] Cont Opener{ffffff}: %s', table.concat({ ... }, ' ')), 15890980)
end

function Utils.dmsg(text, ...)
    return sampAddChatMessage(string.format('[ DEBUG ] Cont Opener{ffffff}: %s', table.concat({ ... }, ' ')), 15890980)
end

function Utils.commaValue(n, char) -- https://www.blast.hk/threads/39380/
    local left, num, right = string.match(n, '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1' .. char):reverse()) .. right
end

function table.toString(tbl, indent)
    local function formatTableKey(k)
        local defaultType = type(k)
        if (defaultType ~= 'string') then
            k = tostring(k)
        end
        local useSquareBrackets = k:find('^(%d+)') or k:find('(%p)') or k:find('\\') or k:find('%-');
        return useSquareBrackets == nil and k or ('[%s]'):format(defaultType == 'string' and "'" .. k .. "'" or k)
    end
    local str = { '{' }
    local indent = indent or 0
    for k, v in pairs(tbl) do
        table.insert(str,
            ('%s%s = %s,'):format(string.rep('    ', indent + 1), formatTableKey(k),
                type(v) == 'table' and table.toString(v, indent + 1) or
                (type(v) == 'string' and "'" .. v .. "'" or tostring(v))))
    end
    table.insert(str, string.rep('    ', indent) .. '}')
    return table.concat(str, '\n')
end

function DeepPrint(t)
    local request_headers_all = ''
    for k, v in pairs(t) do
        if type(v) == 'table' then
            request_headers_all = request_headers_all .. '[' .. k .. ' ' .. DeepPrint(v) .. '] '
        else
            local rowtext = ''
            if type(k) == 'string' then
                rowtext = string.format('[%s %s] ', k, v)
            else
                rowtext = string.format('[%s] ', v)
            end
            request_headers_all = request_headers_all .. rowtext
        end
    end
    return request_headers_all
end

function table.Size(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

function table.random_key(t)
    local keys = {}
    for k in pairs(t) do
        keys[#keys + 1] = k
    end
    if #keys == 0 then return nil end
    return keys[math.random(#keys)]
end

function Utils.rainbow_text(str, colors)
    local result = {}
    for i = 1, #str do
        local c = str:sub(i, i)
        local color = colors[((i - 1) % #colors) + 1]
        table.insert(result, string.format('{%s}%s', color, c))
    end
    return table.concat(result)
end

function Utils.Float4ToHex(color, includeAlpha)
    local r = math.floor(math.min(math.max(color[0]), 1) * 255 + 0.5)
    local g = math.floor(math.min(math.max(color[1]), 1) * 255 + 0.5)
    local b = math.floor(math.min(math.max(color[2]), 1) * 255 + 0.5)
    local a = math.floor(math.min(math.max(color[3], 0), 1) * 255 + 0.5)

    if includeAlpha then
        return string.format('#%02X%02X%02X%02X', r, g, b, a)
    else
        return string.format('#%02X%02X%02X', r, g, b)
    end
end

function Utils.findListInDialog(text, style, linePattern, caseSensitive)
    if caseSensitive == false then
        text = text:lower()
        linePattern = linePattern:lower()
    end

    local lineIndex = 0

    for line in string.gmatch(text, '[^\r\n]+') do
        if string.find(line, linePattern, 1, true) then
            return lineIndex - (style == 5 and 1 or 0)
        end

        lineIndex = lineIndex + 1
    end

    return nil
end
