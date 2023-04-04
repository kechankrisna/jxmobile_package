local tbAct     = Activity:GetClass("ContinualRechargeAct")
tbAct.tbTimerTrigger = 
{ 
    [1] = {szType = "Day", Time = "0:00" , Trigger = "RefreshOnlinePlayerData"},
}
tbAct.tbTrigger = {Init = {}, Start = {{"StartTimerTrigger", 1}}, End = {}, RefreshOnlinePlayerData = {}}

function tbAct:OnTrigger(szTrigger)
    if szTrigger == "Start" then
        self:LoadAward()
        self.nRechargeGold = tonumber(self.tbParam[2])
        Activity:RegisterPlayerEvent(self, "OnRecharge", "OnRecharge")
        Activity:RegisterPlayerEvent(self, "Act_OnPlayerLogin", "CheckPlayerData")
        self:RefreshOnlinePlayerData()
    elseif szTrigger == "RefreshOnlinePlayerData" then
        self:RefreshOnlinePlayerData()
    end
end

function tbAct:LoadAward()
    local tbFile = Lib:LoadTabFile(self.tbParam[1], {nParam = 1})
    self.tbEverydayAward = {}
    self.tbSpecialAward = {}
    for _, tbInfo in ipairs(tbFile) do
        if tbInfo.szType == "everyday" then
            self.tbEverydayAward[tbInfo.nParam] = Lib:GetAwardFromString(tbInfo.szAward)
        elseif tbInfo.szType == "specialday" then
            local tbAward = Lib:GetAwardFromString(tbInfo.szAward)
            self.tbSpecialAward[tbInfo.nParam] = {nContinualDay = tbInfo.nParam, tbAward = tbAward}
        end
    end
end

function tbAct:OnRecharge(pPlayer, nGoldRMB, nCardRMB, nChargeGold)
    self:CheckPlayerData(pPlayer)
    local nTodayRecharge = Recharge:GetActContinualData(pPlayer, Recharge.KEY_ACT_CONTINUAL_RECHARGE)
    nTodayRecharge = nTodayRecharge + nChargeGold
    Recharge:SetActContinualData(pPlayer, Recharge.KEY_ACT_CONTINUAL_RECHARGE, nTodayRecharge)
    if nTodayRecharge < self.nRechargeGold then
        return
    end

    if Recharge:GetActContinualData(pPlayer, Recharge.KEY_ACT_CONTINUAL_FLAG) > 0 then
        return
    end

    local nContinual = Recharge:GetActContinualData(pPlayer, Recharge.KEY_ACT_CONTINUAL_DAYS) + 1
    Recharge:SetActContinualData(pPlayer, Recharge.KEY_ACT_CONTINUAL_DAYS, nContinual)
    Recharge:SetActContinualData(pPlayer, Recharge.KEY_ACT_CONTINUAL_FLAG, 1)
    local tbAward = self:GetCurDayAward()
    pPlayer.SendAward(tbAward, true, false, Env.LogWay_ContinualRechargeAct)
    if self.tbSpecialAward[nContinual] then
        pPlayer.SendAward(self.tbSpecialAward[nContinual].tbAward, true, false, Env.LogWay_ContinualRechargeAct)
    end
end

function tbAct:RefreshOnlinePlayerData()
    local tbPlayer = KPlayer.GetAllPlayer()
    for _, pPlayer in pairs(tbPlayer) do
        self:CheckPlayerData(pPlayer)
    end
end

function tbAct:CheckPlayerData(pPlayer)
    local nStartTime   = self:GetOpenTimeInfo()
    local bNotThisSess = Recharge:GetActContinualData(pPlayer, Recharge.KEY_ACT_CONTINUAL_SESSION_TIME) ~= nStartTime
    local nDataDay     = Recharge:GetActContinualData(pPlayer, Recharge.KEY_ACT_CONTINUAL_DATA_DAY)
    local nRecharge    = Recharge:GetActContinualData(pPlayer, Recharge.KEY_ACT_CONTINUAL_RECHARGE)
    local nLocalDay    = Lib:GetLocalDay()
    Recharge:SetActContinualData(pPlayer, Recharge.KEY_ACT_CONTINUAL_DATA_DAY, nLocalDay)
    if nLocalDay - nDataDay >= 1 or bNotThisSess then
        Recharge:SetActContinualData(pPlayer, Recharge.KEY_ACT_CONTINUAL_FLAG, 0)
        Recharge:SetActContinualData(pPlayer, Recharge.KEY_ACT_CONTINUAL_RECHARGE, 0)
        if bNotThisSess then
            Recharge:SetActContinualData(pPlayer, Recharge.KEY_ACT_CONTINUAL_SESSION_TIME, nStartTime)
            Recharge:SetActContinualData(pPlayer, Recharge.KEY_ACT_CONTINUAL_DAYS, 0)
        end
    end
end

function tbAct:GetCurDayAward()
    local nLocalDay = Lib:GetLocalDay()
    local nBeginDay = Lib:GetLocalDay(Activity:GetActBeginTime(self.szKeyName))
    return self.tbEverydayAward[nLocalDay - nBeginDay + 1] or self.tbEverydayAward[1]
end

function tbAct:GetUiData()
    if not self.tbUiData then
        local tbData = {}
        tbData.nShowLevel = 1
        tbData.szTitle = "Liên tục trữ giá trị hoạt động"
        tbData.nBottomAnchor = 0

        local nStartTime, nEndTime = self:GetOpenTimeInfo()
        local tbTime1 = os.date("*t", nStartTime)
        local tbTime2 = os.date("*t", nEndTime)
        tbData.szContent = string.format([[Thời gian hoạt động: [c8ff00]%d Năm %d Nguyệt %d Nhật 0 Điểm -%d Nguyệt %d Nhật 24 Điểm [-]
Trong hoạt động cho:
  Mỗi ngày [FFFF00] Trữ giá trị đạt tới chỉ định hạn mức ([c8ff00] Có lại chỉ có trữ giá trị hạn mức trực tiếp hối đoái Nguyên bảo tính toán đi vào, hệ thống đưa tặng Nguyên bảo không đưa vào tính gộp lại trữ giá trị kim ngạch [-])[-], đồng đều đem thu hoạch được một phần ban thưởng, mỗi ngày giới hạn thu hoạch được một lần, [FFFF00] Rạng sáng 0 Điểm [-] Kết toán, liên tục trữ giá trị [FFFF00]3 Trời /7 Trời [-] Đem thu hoạch được một phần khen thưởng thêm, hoạt động trong lúc đó như nửa đường một ngày nào đó chưa trữ giá trị, tính gộp lại số trời cũng là ngài giữ lại.
        ]], tbTime1.year, tbTime1.month, tbTime1.day, tbTime2.month, tbTime2.day)

        tbData.szBtnText = "Tiến đến trữ giá trị"
        tbData.szBtnTrap = "[url=openwnd:test, CommonShop, 'Recharge', 'Recharge']";

        tbData.tbSubInfo = {}
        local tbDesc = self:GetAwardDesc(self.tbEverydayAward[1])
        table.insert(tbData.tbSubInfo, {szType = "Item3", szSub = "ContinualRecharge_Day", nParam = self.nRechargeGold, tbItemList = self.tbEverydayAward[1], tbItemName = tbDesc, tbBgSprite = {"BtnListFifthSpecial", "NewBTn"}})

        for _, tbInfo in pairs(self.tbSpecialAward) do
            local tbDesc = self:GetAwardDesc(tbInfo.tbAward)
            table.insert(tbData.tbSubInfo, {szType = "Item3", szSub = "ContinualRecharge", nParam = tbInfo.nContinualDay, tbItemList = tbInfo.tbAward, tbItemName = tbDesc})
        end
        self.tbUiData = tbData
    end
    return self.tbUiData
end

function tbAct:GetAwardDesc(tbAward)
    local tbDesc = {}
    for _, tbInfo in ipairs(tbAward) do
        local nAwardType = Player.AwardType[tbInfo[1]]
        if nAwardType == Player.award_type_item then
            local szName = KItem.GetItemShowInfo(tbInfo[2])
            table.insert(tbDesc, szName)
        elseif nAwardType == Player.award_type_money then
            local szName = Shop:GetMoneyName(tbInfo[1])
            table.insert(tbDesc, szName)
        else
            table.insert(tbDesc, "Những phần thưởng khác")
        end
    end
    return tbDesc
end