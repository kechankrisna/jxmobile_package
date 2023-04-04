local tbItem = Item:GetClass("DaysCardBox")

function tbItem:CheckUse(it)
    local nLeftDay = Recharge:GetDaysCardLeftDay(me, 1)
    if nLeftDay <= 0 then
        return false, "Không thể mở quà, đại hiệp hiện không ở trong thời hạn nhận Quà 7 Ngày"
    end

    return true
end

function tbItem:OnUse(it)
    local bRet, szMsg = self:CheckUse(it)
    if not bRet then
        me.CenterMsg(szMsg)
        return
    end

    local nItemTID = KItem.GetItemExtParam(it.dwTemplateId, 1)
    if nItemTID <= 0 then
        return
    end

    me.SendAward({{"Item", nItemTID, 1}}, nil, nil, Env.LogWay_FirstRechargeAward)
    return 1
end

function tbItem:OnClientUse(it)
    local bRet, szMsg = self:CheckUse(it)
    if not bRet then
        local fnGo = function ()
            Ui:OpenWindow("WelfareActivity","RechargeGift")
        end
    
        me.MsgBox("Không thể mở quà, đại hiệp hiện không ở trong thời hạn nhận[FFFE0D]Quà 7 Ngày[-]", {{"Mua", fnGo}, {"Không mua"}})
        return 1
    end
end