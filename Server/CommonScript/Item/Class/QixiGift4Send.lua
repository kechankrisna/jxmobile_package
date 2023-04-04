local tbItem = Item:GetClass("QixiGift4Send")

function tbItem:OnClientUse(it)
    Ui:CloseWindow("ItemTips")
    Ui:CloseWindow("ItemBox")
    Ui:OpenWindow("QixiSendGiftPanel", it.dwTemplateId)
end

function tbItem:GetUseSetting(nTemplateId, nItemId)
    if Activity.Qixi:IsInActivityTime() then
        return {szFirstName = "Bán", fnFirst = "SellItem", szSecondName = "Dùng", fnSecond = "UseItem"}
    else
        return {szFirstName = "Bán", fnFirst = "SellItem"}
    end
end