local tbItem = Item:GetClass("RegressionAwardItem")
function tbItem:OnUse(pItem)
    local nCloseTime = KItem.GetItemExtParam(pItem.dwTemplateId, 1)
    if nCloseTime > 0 and nCloseTime <= GetTime() then
        me.CenterMsg("Đạo cụ đã hết hạn")
        Log("RegressionPrivilege Item TimeOut", me.dwID, pItem.dwId)
        return 1
    end

    RegressionPrivilege:OnUsePrivilegeItem(me)
    return 1
end