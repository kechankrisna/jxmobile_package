local tbItem = Item:GetClass("AddExtDayTargetActvie")
function tbItem:OnUse(it)
    local nCurValue = EverydayTarget:GetTotalActiveValue(me)
    if nCurValue >= 100 then
        me.CenterMsg("Năng động đạt tối đa, không thể dùng")
        return
    end

    local nExtValue = KItem.GetItemExtParam(it.dwTemplateId, 1)
    EverydayTarget:AddActExtActiveValue(me, nExtValue, "Item_" .. it.dwTemplateId)
    me.CenterMsg(string.format("Đã dùng, tăng %d điểm năng động", nExtValue))
    return 1
end