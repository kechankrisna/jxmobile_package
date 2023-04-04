local tbItem = Item:GetClass("AddRedBag")

tbItem.nExtRedBagEventId = 1

function tbItem:OnUse(it)
    local nItemTempId = it.dwTemplateId
    local nEventId = KItem.GetItemExtParam(nItemTempId, self.nExtRedBagEventId) or 0
    local tbSetting = Kin:GetRedBagSetting(nEventId)
    if not tbSetting then
        Log("[x] Item AddRedBag", me.dwID, nItemTempId, nEventId)
        return
    end

    local nKinId = me.dwKinId
    if not nKinId or nKinId<=0 then
        me.CenterMsg("Đại hiệp chưa có bang hội, không thể dùng")
        return
    end

    if not Kin:RedBagGainByItemWithoutCheck(nKinId, me, nEventId) then
        Log("[x] Item AddRedBag", nKinId, me.dwID, nItemTempId, nEventId)
        me.CenterMsg(string.format("Dùng %s thất bại", it.szName))
        return
    end

    me.CenterMsg(string.format("Dùng %s thành công", it.szName))
    Log("Use AddRedBag item", nKinId, me.dwID, it.dwTemplateId, nEventId)
    return 1
end