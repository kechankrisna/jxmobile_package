
local tbItem = Item:GetClass("SuperWeekCard");
local nIndex = 3
function tbItem:OnUse(it)
    local bRet, szMsg = Recharge:IsCanBuySuperDaysCard(me, nIndex)
    if bRet then
        return
    end
    Recharge:AddBuySuperDaysCardCount(me, nIndex)
    me.CenterMsg("Có quyền mua Thẻ Tuần Chí Tôn!")
    return 1
end

function tbItem:OnClientUse(it)
    local bRet, szMsg = Recharge:IsCanBuySuperDaysCard(me, nIndex)
    if bRet then
        me.CenterMsg("Đã có quyền mua Thẻ Tuần Chí Tôn!")
        return
    end
end