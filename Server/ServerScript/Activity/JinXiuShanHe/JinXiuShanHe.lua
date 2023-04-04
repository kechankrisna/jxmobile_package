local tbAct        = Activity:GetClass("JinXiuShanHe")
tbAct.GROUP        = 65
tbAct.DATA_DAY     = 50 --鉴定次数的天数
tbAct.IDENTIFY     = 51 --鉴定的次数
tbAct.DAY_GIFT     = 52 --每日礼包
tbAct.IDENTIFY_NUM = 5 --锦绣山河每天鉴定次数
tbAct.COST_COIN    = 1000
tbAct.nCloseTime   = Lib:ParseDateTime("2016/10/10") --供创建收集册使用
tbAct.tbTimerTrigger = 
{
    [1] = {szType = "Day", Time = "10:00" , Trigger = "SendWorldNotify" },
    [2] = {szType = "Day", Time = "13:00" , Trigger = "SendWorldNotify" },
    [3] = {szType = "Day", Time = "20:00" , Trigger = "SendWorldNotify" },
}
tbAct.tbTrigger    = {  Init = { },
                        Start = { {"StartTimerTrigger", 1}, {"StartTimerTrigger", 2}, {"StartTimerTrigger", 3}, },
                        End = { },
                        SendWorldNotify = { {"WorldMsg", "Các vị thiếu hiệp, “Cẩm Tú Sơn Hà khắp chốn mừng vui” Hai mươi hoạt động bắt đầu, mọi người có thể thông qua thẩm tra “Tin tức mới nhất” Hiểu rõ trong hoạt động cho!", 20} },
}
tbAct.JOIN_LEVEL   = 20
tbAct.ITEM         = 3029

function tbAct:OnTrigger(szTrigger)
    if szTrigger == "Start" then
        Activity:RegisterPlayerEvent(self, "Act_EverydayTarget_Award", "OnAddEverydayAward")
        Activity:RegisterPlayerEvent(self, "Act_DailyGift", "OnGainDailyGift")
        Activity:RegisterPlayerEvent(self, "Act_TryUseJxshItem", "TryUseJxshItem")
        local _, nEndTime = self:GetOpenTimeInfo()
        CollectionSystem:OnActJxshStart(nEndTime)
    elseif szTrigger == "End" then
        CollectionSystem:SendRankAward(CollectionSystem.JINXIUSHANHE)
        CollectionSystem:OnActJxshEnd()
        Log("JinXiuShanHe Send Rank Award")
    end
    Log("ZhongQiuJie OnTrigger:", szTrigger)
end

function tbAct:OnAddEverydayAward(pPlayer, nIdx)
    if pPlayer.nLevel < self.JOIN_LEVEL then
        return
    end

    pPlayer.SendAward({{"Item", self.ITEM, 1, GetTime() + 24*60*60}}, nil, true, Env.LogWay_JXSH)
end

function tbAct:CheckData(pPlayer)
    local nLocalDay = Lib:GetLocalDay()
    local nGroup    = self.GROUP
    local nDataDay  = pPlayer.GetUserValue(nGroup, self.DATA_DAY)
    if nDataDay ~= nLocalDay then
        pPlayer.SetUserValue(nGroup, self.DATA_DAY, nLocalDay)
        pPlayer.SetUserValue(nGroup, self.IDENTIFY, 0)
        pPlayer.SetUserValue(nGroup, self.DAY_GIFT, 0)
    end
end

--领取每日礼包
function tbAct:OnGainDailyGift(pPlayer)
    self:CheckData(pPlayer)
    if pPlayer.nLevel < self.JOIN_LEVEL then
        return
    end

    if pPlayer.GetUserValue(self.GROUP, self.DAY_GIFT) > 0 then
        return
    end
    pPlayer.SetUserValue(self.GROUP, self.DAY_GIFT, 1)

    pPlayer.SendAward({{"Item", self.ITEM, 1, GetTime() + 24*60*60}}, nil, true, Env.LogWay_JXSH)
end

function tbAct:CheckIdentify(pPlayer)
    self:CheckData(pPlayer)
    return pPlayer.GetUserValue(self.GROUP, self.IDENTIFY) < self.IDENTIFY_NUM, "Giám định thất bại, hôm nay thẻ giám định phiến số lượng đã đạt hạn mức cao nhất!"
end

function tbAct:CheckUse(pPlayer, pItem)
    local bRet, szMsg = self:CheckIdentify(pPlayer)
    if not bRet then
        return false, szMsg
    end

    if pItem.nCount <= 0 then
        return false, "Đạo cụ số lượng không đủ"
    end

    if pPlayer.GetMoney("Coin") < self.COST_COIN then
        return false, "Ngân lượng không đủ, không cách nào giám định"
    end
    return true
end

function tbAct:TryUseJxshItem(pPlayer, pItem)
    local bRet, szMsg = self:CheckUse(pPlayer, pItem)
    if not bRet then
        pPlayer.CenterMsg(szMsg)
        return
    end

    if not pPlayer.CostMoney("Coin", self.COST_COIN, Env.LogWay_JXSH) then
        pPlayer.CenterMsg("Ngân lượng khấu trừ dị thường, giám định thất bại")
        return
    end

    if pPlayer.ConsumeItem(pItem, 1, Env.LogWay_JXSH) ~= 1 then
        Log("JXSH Use Item Err", pPlayer.dwID, pItem.dwTemplateId, pItem.dwId)
        pPlayer.CenterMsg("Đạo cụ khấu trừ dị thường, giám định thất bại")
        return
    end

    local nUse = pPlayer.GetUserValue(self.GROUP, self.IDENTIFY)
    pPlayer.SetUserValue(self.GROUP, self.IDENTIFY, nUse + 1)

    local nGetItem = KItem.GetItemExtParam(pItem.dwTemplateId, 1)
    pPlayer.SendAward({{"Item", nGetItem, 1}}, nil, true, Env.LogWay_JXSH)
    pPlayer.CenterMsg("Giám định thành công")
end