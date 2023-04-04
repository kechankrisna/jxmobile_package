local tbItem = Item:GetClass("ClearFirstRechargeFlag")

function tbItem:OnUse()
    self:Clear(me)
    return 1
end

function tbItem:Clear(pPlayer)
    Recharge:ClearBuyedFlag(pPlayer)
    Log("ClearFirstRechargeFlag Success", pPlayer.dwTID, (it or {}).dwId or 0)
end

function tbItem:OnTimeOut(dwTID, nCount)
    self:Clear(me)
    me.CenterMsg("Đã tái lập tất cả mức nạp thẻ", true)
end

function tbItem:OnClientUse(it)
    if self:IsHaveFirstAward() then
        local fnGo = function ()
            RemoteServer.UseItem(it.dwId)
        end
    
        me.MsgBox("Vẫn còn mức x2 chưa nạp, chắc chắn dùng chứ?", {{"Dùng", fnGo}, {"Hủy"}})
        return 1
    end
end

function tbItem:IsHaveFirstAward()
    local nMaxBit = 0
    for _, tbInfo in pairs(Recharge.tbSettingGroup.BuyGold) do
        if tbInfo.tbAward2 then
            nMaxBit = math.max(nMaxBit, tbInfo.nGroupIndex)
        end
    end

    local nFlag = Recharge:GetBuyedFlag(me)
    for i = 1, nMaxBit do
        if KLib.GetBit(nFlag, i) == 0 then
            return true
        end
    end
end