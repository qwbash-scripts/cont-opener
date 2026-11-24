function sampev.onServerMessage(color, text)
    -- [Крипто-Сумка] Количество было увеличено на +35%, так как у Вас имеется соответствующая привилегия.
    if Config.hideMessagesFromCryptoWallet[0] and text:match('^%[Крипто%-Сумка%].*так как у Вас имеется соответствующая привилегия%.') then
        return false
    end
    -- [Premium VIP] Количество было увеличено на +15%, так как у Вас имеется соответствующая привилегия.
    if Config.hideMessagesFromPremiumVIP[0] and text:match('^%[Premium VIP%].*так как у Вас имеется соответствующая привилегия%.') then
        return false
    end
end

function sampev.onShowDialog(dialog_id, style, title, button1, button2, text)
    if rofloCars.clicked and title:find('Действие с сертификатом') then
        local sellIndex = Utils.findListInDialog(text, style, 'Продать в гос', false)
        sampSendDialogResponse(dialog_id, 1, sellIndex, '')
        rofloCars.clicked = false
        return false
    end
end
