local tbAct = Activity:GetClass("Qixi")
tbAct.tbTimerTrigger = 
{
    [1] = {szType = "Day", Time = "10:00" , Trigger = "SendWorldNotify" },
    [2] = {szType = "Day", Time = "13:00" , Trigger = "SendWorldNotify" },
    [3] = {szType = "Day", Time = "19:00" , Trigger = "SendWorldNotify" },
}
tbAct.tbTrigger = { Init = { },
                    Start = { {"StartTimerTrigger", 1}, {"StartTimerTrigger", 2}, {"StartTimerTrigger", 3}, },
                    SendWorldNotify = { {"WorldMsg", "Các vị hiệp sĩ, lãng mạn lễ tình nhân hoạt động bắt đầu, mọi người có thể thông qua [FFFE0D] Hoàn thành mỗi ngày mục tiêu [-] Cùng tiến hành [FFFE0D] Bang phái cống hiến [-] Thu hoạch được tương ứng đạo cụ tham gia hoạt động. Tường tình mời thẩm tra tin tức mới nhất tương quan giới thiệu nội dung!", 1} },
                    End = { }, }

function tbAct:OnTrigger(szTrigger)
    if szTrigger == "Start" then
        Activity:RegisterPlayerEvent(self, "Act_EverydayTarget_Award", "OnAddEverydayAward")
        Activity:RegisterPlayerEvent(self, "Act_KinDonate", "OnKinDonate")
        Activity:RegisterPlayerEvent(self, "Act_QixiOnClientCall", "OnClientCall")
        Activity:RegisterPlayerEvent(self, "Act_TryUseBaiXingItem", "OnTryUseBaiXingItem")
        Activity:RegisterNpcDialog(self, 90,  {Text = "Hối đoái bảy sắc huyền hương", Callback = self.OnNpcDialog, Param = {self}})
    end
    Log("Qixi OnTrigger:", szTrigger)
end

function tbAct:OnAddEverydayAward(pPlayer, nAwardIdx)
    if not self:IsInActivityTime() then
        return
    end

    self:SendActAward(pPlayer)
    Log("Qixi OnAddEverydayAward Success", pPlayer.dwID, nAwardIdx)
end

function tbAct:OnKinDonate(pPlayer, nMaxDegree, nCurDegree, nCurDonateTimes)
    if not self:IsInActivityTime() then
        return
    end

    local nBegin = nMaxDegree - nCurDegree - nCurDonateTimes + 1
    local nEnd = math.min(nMaxDegree - nCurDegree, 25)
    local nSendTimes = 0
    for i = nBegin, nEnd do
        if i%5 == 0 then
            nSendTimes = nSendTimes + 1
        end
    end
    if nSendTimes <= 0 then
        return
    end
    self:SendActAward(pPlayer, nSendTimes)
    Log("Qixi OnKinDonate Success:", pPlayer.dwID, nMaxDegree, nCurDegree, nCurDonateTimes, nSendTimes)
end

function tbAct:SendActAward(pPlayer, nSendTimes)
    local tbAward = {}
    nSendTimes = nSendTimes or 1
    for i = 1, nSendTimes do
        local nRandom = MathRandom(4)
        table.insert(tbAward, self.Def.EVERY_AWARD[nRandom])
    end
    local bRet = pPlayer.CheckNeedArrangeBag()
    if bRet then
        local tbMail = {Title = "Đêm thất tịch ban thưởng", From = "", To = pPlayer.dwID, nLogReazon = Env.LogWay_Qixi}
        tbMail.Text = "Tham dự đêm thất tịch hoạt động lúc, bởi vì ba lô đã đủ, trở xuống ban thưởng lấy bưu kiện hình thức cấp cho."
        tbMail.tbAttach = tbAward
        Mail:SendSystemMail(tbMail)
    else
        pPlayer.SendAward(tbAward, nil, true, Env.LogWay_Qixi)
    end
end

function tbAct:OnNpcDialog()
    Exchange:AskItem(me, "QisexuanxiangExchange", self.ExchangeItem, self)
    me.CenterMsg("Cung cấp “Hoa cùng rượu” Cùng “Thơ cùng kiếm” Các một, lấy hối đoái bảy sắc huyền hương.")
end

function tbAct:RefreshPlayerData(pPlayer)
    if not self:IsInActivityTime() then
        return
    end

    local Def          = self.Def
    local nGroup       = Def.SAVE_GROUP
    local nLocalDay    = Lib:GetLocalDay()
    local nLastDataDay = pPlayer.GetUserValue(nGroup, Def.DATA_LOCALDAY_KEY)
    if nLocalDay == nLastDataDay then
        return
    end

    local nIntervalDay = nLocalDay - math.max(nLastDataDay, Lib:GetLocalDay(Def.ACTIVITY_TIME_BEGIN))
    if nLastDataDay == 0 then
        nIntervalDay = nIntervalDay + 1
    end
    local nChange = pPlayer.GetUserValue(nGroup, Def.CHANGE_ITEM_TIMES_KEY) + Def.CHANGE_ITEM_TIMES*nIntervalDay
    local nHelp   = pPlayer.GetUserValue(nGroup, Def.HELP_AWARD_TIMES_KEY) + Def.HELP_AWARD_TIMES*nIntervalDay
    pPlayer.SetUserValue(nGroup, Def.CHANGE_ITEM_TIMES_KEY, nChange)
    pPlayer.SetUserValue(nGroup, Def.HELP_AWARD_TIMES_KEY, nHelp)
    pPlayer.SetUserValue(nGroup, Def.DATA_LOCALDAY_KEY, nLocalDay)
end

function tbAct:CheckSendGift(dwBeSendId, nItemTemplateId)
    if not dwBeSendId or not nItemTemplateId then
        return false, "Số liệu dị thường, mời thử lại"
    end

    local nCount, tbItem = me.GetItemCountInAllPos(nItemTemplateId)
    if nCount <= 0 or not tbItem[1] then
        return false, "Không tìm được nên đạo cụ"
    end

    local pBeSendPlayer = KPlayer.GetPlayerObjById(dwBeSendId)
    if not pBeSendPlayer then
        return false, "Người chơi offline"
    end

    local bRet = pBeSendPlayer.CheckNeedArrangeBag()
    if bRet then
        return false, "Đối phương ba lô không đủ, không cách nào đưa tặng"
    end

    if me.GetNpc().GetDistance(pBeSendPlayer.GetNpc().nId) > Npc.DIALOG_DISTANCE then
        return false, "Khoảng cách quá xa"
    end

    if not me.dwTeamID or me.dwTeamID == 0 then
        return nil, "Ngươi còn không có đội ngũ"
    end

    if not pBeSendPlayer.dwTeamID or pBeSendPlayer.dwTeamID == 0 or me.dwTeamID ~= pBeSendPlayer.dwTeamID then
        return nil, "Hảo hữu không tại trong đội ngũ"
    end

    return self:CommonCheck({me.nSex, me.dwID, me.nLevel}, {pBeSendPlayer.nSex, pBeSendPlayer.dwID, pBeSendPlayer.nLevel})
end

function tbAct:TrySendGift(pPlayer, dwBeSendId, nItemTemplateId)
    local bRet, szMsg = self:CheckSendGift(dwBeSendId, nItemTemplateId)
    if not bRet then
        me.CenterMsg(szMsg)
        return
    end
    local tbSexCanSend = self.Def.SEND_ITEM[me.nSex]
    local nGiftTemplateId = tbSexCanSend[nItemTemplateId]
    if not nGiftTemplateId then
        me.CenterMsg("Vật phẩm đấy không thể đưa tặng")
        return
    end

    local _, tbItem = me.GetItemCountInAllPos(nItemTemplateId)
    if Item:Consume(tbItem[1], 1) <= 0 then
        me.CenterMsg("Đưa tặng thất bại")
        return
    end

    local pBeSendPlayer = KPlayer.GetPlayerObjById(dwBeSendId)
    ChatMgr:SendPlayerMsg(ChatMgr.ChannelType.Nearby, me.dwID, me.szName, me.nFaction, me.nPortrait, me.nSex, me.nLevel, self.Def.CHAT_GIFT[nItemTemplateId])
    local szChat = string.format(self.Def.CHAT_GIFT[nGiftTemplateId], me.szName)
    ChatMgr:SendPlayerMsg(ChatMgr.ChannelType.Nearby, dwBeSendId, pBeSendPlayer.szName, pBeSendPlayer.nFaction, pBeSendPlayer.nPortrait, pBeSendPlayer.nSex, pBeSendPlayer.nLevel, szChat)

    local pSendItem = pBeSendPlayer.AddItem(nGiftTemplateId, 1, nil, Env.LogWay_Qixi)
    pSendItem.SetStrValue(1, me.szName)
    Log("QIxi TrySendGift Success", me.dwID, dwBeSendId, nItemTemplateId)
    if not self:IsInActivityTime() then
        return
    end
    FriendShip:AddImitity(me.dwID, dwBeSendId, self.Def.IMITITY_SENDGIFT, Env.LogWay_Qixi)
    Log("QIxi TrySendGift Success And AddImitity", me.dwID, dwBeSendId, nItemTemplateId)
end

function tbAct:ExchangeItem(tbItems)
    for nItemTemplateId, nCount in pairs(tbItems or {}) do
        local nTrueCount = me.GetItemCountInAllPos(nItemTemplateId)
        if nTrueCount < nCount then
            me.CenterMsg("Ba lô đạo cụ số lượng không đủ, hối đoái thất bại")
            Log("Qixi ExchangeItem Count Err")
            return
        end
    end
    local tbSetting = Exchange.tbExchangeSetting["QisexuanxiangExchange"]
    local tbAwardIdx = Exchange:Check_Qixi(tbItems, tbSetting)
    if not tbAwardIdx or #tbAwardIdx == 0 then
        return
    end

    local tbAllExchange = tbSetting.tbAllExchange
    local tbAllAward = {}
    for _, nIdex in ipairs(tbAwardIdx) do
        local tbSet = tbAllExchange[nIdex]
        for nItemId, nCount in pairs(tbSet.tbAllItem) do
            if me.ConsumeItemInAllPos(nItemId, nCount, Env.LogWay_Qixi) ~= nCount then
                Log(debug.traceback(), me.dwID)
                return
            end
        end
        table.insert(tbAllAward, unpack(tbSet.tbAllAward))
    end
    me.SendAward(tbAllAward, nil, true, Env.LogWay_Qixi)
    Log("Qixi ExchangeItem Success", me.dwID, #tbAllAward)
end

function tbAct:GetBaixingHelpper(dwID)
    if not self:IsInActivityTime() then
        return nil, "Không tại hoạt động thời gian bên trong"
    end

    local pBaixing = KPlayer.GetPlayerObjById(dwID)
    self:RefreshPlayerData(pBaixing)
    local nLastCount = pBaixing.GetUserValue(self.Def.SAVE_GROUP, self.Def.CHANGE_ITEM_TIMES_KEY)
    if nLastCount <= 0 then
        return nil, "Bái tinh số lần đã hao hết"
    end

    if not pBaixing.dwTeamID or pBaixing.dwTeamID == 0 then
        return nil, "Ngươi còn không có đội ngũ"
    end

    local tbMember = TeamMgr:GetMembers(pBaixing.dwTeamID)
    if #tbMember ~= 2 then
        return nil, "Nhất định phải hai người đơn độc tổ đội"
    end

    local dwHelperID = tbMember[1] == dwID and tbMember[2] or tbMember[1]
    local pHelper = KPlayer.GetPlayerObjById(dwHelperID)
    if not pHelper then
        return nil, "Không tìm được đồng đội"
    end

    local bRet, szMsg = self:CommonCheck({pBaixing.nSex, pBaixing.dwID, pBaixing.nLevel}, {pHelper.nSex, pHelper.dwID, pHelper.nLevel})
    if not bRet then
        return nil, szMsg
    end
    self:RefreshPlayerData(pHelper)
    if pHelper.GetUserValue(self.Def.SAVE_GROUP, self.Def.HELP_AWARD_TIMES_KEY) <= 0 then
        return nil, "Hảo hữu hiệp trợ số lần đã sử dụng hết"
    end
    return pHelper.dwID
end

function tbAct:BaiXing(pItem, dwBaixing, dwHelper)
    local pBaixing = KPlayer.GetPlayerObjById(dwBaixing)
    local pHelper = KPlayer.GetPlayerObjById(dwHelper)
    if not pBaixing or not pHelper then
        return
    end

    self:RefreshPlayerData(pBaixing)
    self:RefreshPlayerData(pHelper)
    local nLastCount = pBaixing.GetUserValue(self.Def.SAVE_GROUP, self.Def.CHANGE_ITEM_TIMES_KEY)
    if nLastCount <= 0 then
        return
    end
    local nHelpCount = pHelper.GetUserValue(self.Def.SAVE_GROUP, self.Def.HELP_AWARD_TIMES_KEY)
    if nHelpCount <= 0 then
        return
    end

    local bRet, szMsg = pBaixing.CheckNeedArrangeBag()
    if bRet then
        pBaixing.CenterMsg(szMsg)
        return
    end

    if pBaixing.bDoingBaixing or pHelper.bDoingBaixing then
        pBaixing.CenterMsg("Ngay tại bái tinh")
        pHelper.CenterMsg("Ngay tại bái tinh")
        return
    end

    local nRet = Item:Consume(pItem, 1)
    if nRet ~= 1 then
        return
    end

    pBaixing.SetUserValue(self.Def.SAVE_GROUP, self.Def.CHANGE_ITEM_TIMES_KEY, nLastCount - 1)
    pHelper.SetUserValue(self.Def.SAVE_GROUP, self.Def.HELP_AWARD_TIMES_KEY, nHelpCount - 1)
    pBaixing.nBaiXingTimes = self.Def.BAIXING_EXT_TIMES
    pBaixing.bDoingBaixing = true
    pBaixing.bDoingBaixing = true

    Env:SetSystemSwitchOff(pBaixing, Env.SW_All)
    Env:SetSystemSwitchOff(pHelper, Env.SW_All)

    if pBaixing.GetActionMode() ~= Npc.NpcActionModeType.act_mode_none then
        ActionMode:DoChangeActionMode(pBaixing, Npc.NpcActionModeType.act_mode_none)
    end
    if pHelper.GetActionMode() ~= Npc.NpcActionModeType.act_mode_none then
        ActionMode:DoChangeActionMode(pHelper, Npc.NpcActionModeType.act_mode_none)
    end

    local _, nBaixingX, nBaixingY = pBaixing.GetWorldPos()
    local _, nHelperX, nHelperY = pHelper.GetWorldPos()
    pBaixing.GetNpc().CastSkill(1083, 1, nHelperX, nHelperY)
    pHelper.GetNpc().CastSkill(1083, 1, nBaixingX, nBaixingY)

    FriendShip:AddImitity(dwBaixing, dwHelper, self.Def.IMITITY_BAIXING, Env.LogWay_Qixi)
    pBaixing.SendAward({{"Item", self.Def.BAIXING_AWARDS_ID, 1}}, false, true, Env.LogWay_Qixi)
    pHelper.SendAward(self.Def.BAIXING_HELP_AWARDS, nil, 1, Env.LogWay_Qixi)

    Timer:Register(Env.GAME_FPS * self.Def.BAIXING_EXT_INTERVAL, self.ContinueBaiXing, self, dwBaixing, dwHelper)
    pBaixing.CallClientScript("Activity.Qixi:BeginBaiXing", pHelper.GetNpc().nId)
    pHelper.CallClientScript("Activity.Qixi:BeginBaiXing", pBaixing.GetNpc().nId)
    Log("Qixi BaiXing", dwBaixing, dwHelper)
    return true
end

function tbAct:CheckContinueBaixing(dwBaixing, dwHelper)
    local pBaixing = KPlayer.GetPlayerObjById(dwBaixing)
    local pHelper = KPlayer.GetPlayerObjById(dwHelper)
    if not pBaixing or not pHelper then
        return false
    end

    if not pBaixing.nBaiXingTimes or pBaixing.nBaiXingTimes <= 0 then
        return false
    end

    return true
end

function tbAct:ContinueBaiXing(dwBaixing, dwHelper)
    if not self:CheckContinueBaixing(dwBaixing, dwHelper) then
        self:RestoreState(dwBaixing, dwHelper)
        return
    end

    local pBaixing = KPlayer.GetPlayerObjById(dwBaixing)
    local pHelper = KPlayer.GetPlayerObjById(dwHelper)
    pBaixing.nBaiXingTimes = pBaixing.nBaiXingTimes - 1 or 0
    pBaixing.SendAward(self.Def.BAIXING_EXT_AWARDS, 1, nil, Env.LogWay_Qixi)
    pHelper.SendAward(self.Def.BAIXING_EXT_AWARDS, 1, nil, Env.LogWay_Qixi)
    Log("Qixi ContinueBaiXing", dwBaixing, dwHelper, pBaixing.nBaiXingTimes)
    return true
end

function tbAct:RestoreState(dwBaixing, dwHelper)
    local pBaixing = KPlayer.GetPlayerObjById(dwBaixing)
    if pBaixing then
        Env:SetSystemSwitchOn(pBaixing, Env.SW_All)
        pBaixing.GetNpc().RestoreAction()
        pBaixing.bDoingBaixing = false
        pBaixing.CallClientScript("Activity.Qixi:CloseBaiXing")
    end
    local pHelper = KPlayer.GetPlayerObjById(dwHelper)
    if pHelper then
        Env:SetSystemSwitchOn(pHelper, Env.SW_All)
        pHelper.GetNpc().RestoreAction()
        pHelper.bDoingBaixing = false
        pHelper.CallClientScript("Activity.Qixi:CloseBaiXing")
    end
end

function tbAct:OnTryUseBaiXingItem(pPlayer, pItem)
    local dwHelper, szMsg = self:GetBaixingHelpper(pPlayer.dwID)
    if not dwHelper then
        pPlayer.CenterMsg(szMsg)
        return
    end

    local bRet, szMessage = self:CheckPos(pItem, pPlayer.dwID, dwHelper)
    if not bRet then
        pPlayer.CenterMsg(szMessage)
        return
    end
    
    local bRet = self:BaiXing(pItem, pPlayer.dwID, dwHelper)
    if bRet and pItem and pItem.nCount > 0 then
        local tbItem = Item:GetClass("Qisexuanxiang")
        tbItem:RandomPos(pItem)
    end
end

function tbAct:CheckPos(pItem, dwBaixing, dwHelper)
    local pBaiXing = KPlayer.GetPlayerObjById(dwBaixing)
    local pHelper = KPlayer.GetPlayerObjById(dwHelper)

    local nMapId, nX, nY = pBaiXing.GetWorldPos()
    local nHelperMap     = pHelper.GetWorldPos()
    local tbItem         = Item:GetClass("Qisexuanxiang")
    local nMapTemplateId = pItem.GetIntValue(tbItem.MAPTEMPLATEID)
    local nPosX          = pItem.GetIntValue(tbItem.POS_X)
    local nPosY          = pItem.GetIntValue(tbItem.POS_Y)
    if not IsSameMapId(nMapId, nMapTemplateId) or nX ~= nPosX or nY ~= nPosY then
        return false, "Mời lúc trước hướng bái tinh địa điểm"
    end

    if nMapId ~= nHelperMap or pBaiXing.GetNpc().GetDistance(pHelper.GetNpc().nId) > Npc.DIALOG_DISTANCE then
        return false, "Đồng đội không tại bái tinh phạm vi bên trong"
    end

    return true
end

tbAct.tbClientSafeCall = {
    TrySendGift       = 1,
    RefreshPlayerData = 1,
}
function tbAct:OnClientCall(pPlayer, szFunc, ...)
    if Lib:IsEmptyStr(szFunc) or not self[szFunc] or not self.tbClientSafeCall[szFunc] then
        return
    end

    self[szFunc](self, pPlayer, ...)
end