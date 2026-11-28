CONFIG_PATH = BASE_PATH .. '\\config' .. '\\cont-opener-settings.json'
PRICES_PATH = BASE_PATH .. '\\config' .. '\\cont-opener-prices.json'
COLLECTOR_PATH = BASE_PATH .. '\\config' .. '\\cont-opener-collector.json'

containerDropCollector = {}
cjc.load(COLLECTOR_PATH, containerDropCollector)
containerDropCollector()

containerDropPrices = {}
cjc.load(PRICES_PATH, containerDropPrices)
containerDropPrices()

Config = {
    sellCostOfVC = imgui.new.int(96),
    buyCostOfVC = imgui.new.int(112),
    selectedCryptoWallet = imgui.new.int(3),
    selectedEarnedMoneyForumula = imgui.new.int(0),
    openInInventory = imgui.new.bool(false),
    boxTypeColor = imgui.new.float[4](0.227451, 0.490196, 0.909804, 1.0),
    hideMessagesFromPremiumVIP = imgui.new.bool(false),
    hideMessagesFromCryptoWallet = imgui.new.bool(false),
    autoCloseContainerMenu = imgui.new.bool(false),
    hideContainerMenu = imgui.new.bool(false),
    -- Почему не сохраняло?
    -- canISellRofloCars = {
    --     [765] = imgui.new.bool(false),
    --     [539] = imgui.new.bool(false),
    --     [797] = imgui.new.bool(false),
    --     [544] = imgui.new.bool(false)
    -- }
    canISellElegy = imgui.new.bool(false),
    canISellCheetah = imgui.new.bool(false),
    canISellPhoenix = imgui.new.bool(false),
    canISellKarting = imgui.new.bool(false),
    mindlesslyManipulate = imgui.new.bool(false)
}
cjc.load(CONFIG_PATH, Config)
