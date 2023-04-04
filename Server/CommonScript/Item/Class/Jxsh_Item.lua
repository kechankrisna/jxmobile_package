--锦绣山河卡
local tbItem = Item:GetClass("Jxsh_Item")
function tbItem:OnUse(pItem)
    Activity:OnPlayerEvent(me, "Act_TryUseJxshItem", pItem)
end

function tbItem:GetUseSetting(nTemplateId, nItemId)
    if Shop:CanSellWare(me, nItemId, 1) then
        return {szFirstName = "Bán", fnFirst = "SellItem", szSecondName = "Giám định", fnSecond = "UseItem"}
    end
    return {szFirstName = "Giám định", fnFirst = "UseItem"}
end