local DAY_SEC = 24*3600
function RegressionPrivilege:OnStartUp()
    MarketStall:RegisterCheckOpen("RegressionPrivilege", function(pPlayer)
        local bRet, szMsg = self:IsCloseMarketStall(pPlayer)
        return not bRet, szMsg
    end)
end

function RegressionPrivilege:FreezePrivilege(pPlayer, nBeginTime)
    pPlayer.SetUserValue(self.GROUP, self.ACTIVITY_TRIGGER, nBeginTime)
    pPlayer.SetUserValue(self.GROUP, self.BEGIN_TIME, nBeginTime)
    pPlayer.SetUserValue(self.GROUP, self.ITEM_USED_FLAG, 0)
    Log("RegressionPrivilege OnNewServerActOpen Freeze Privilege", pPlayer.dwID)
end

function RegressionPrivilege:RefreshBackPlayerData(pPlayer)
    if self.tbNewServerActInfo and
        self.tbNewServerActInfo.nCreateTime > GetServerCreateTime() and
        self.tbNewServerActInfo.tbRechargeInfo[pPlayer.szAccount] then
        local nStartTime = self.tbNewServerActInfo.nVersion
        local bLast = pPlayer.GetUserValue(self.GROUP, self.ACTIVITY_TRIGGER) ~= nStartTime
        if bLast then
            self:FreezePrivilege(pPlayer, nStartTime)
        end
        return pPlayer.GetUserValue(self.GROUP, self.ITEM_USED_FLAG) == 0, true
    end
    if pPlayer.GetUserValue(self.GROUP, self.ACTIVITY_TRIGGER) > 0 then
        pPlayer.SetUserValue(self.GROUP, self.ACTIVITY_TRIGGER, 0)
    end
    return false, false
end

function RegressionPrivilege:OnLogin(pPlayer)
    if pPlayer.nLevel < self.Privilege_Lv then
        return
    end

    local bLock, bBackPlayer = self:RefreshBackPlayerData(pPlayer)

    local tbStayInfo  = KPlayer.GetRoleStayInfo(pPlayer.dwID)
    local nLastOnline = tbStayInfo and tbStayInfo.nLastOnlineTime or 0
    local nOutDay     = 0
    if nLastOnline > 0 then
        nOutDay = math.min(Lib:GetLocalDay() - Lib:GetLocalDay(nLastOnline), self.Max_OutlineDays)
    end
    if nOutDay < self.Outline_Days then
        return
    end

    if bLock then
        local nOutDayInLock = pPlayer.GetUserValue(self.GROUP, self.LOCK_OUTDAY)
        nOutDayInLock = nOutDayInLock + nOutDay
        pPlayer.SetUserValue(self.GROUP, self.LOCK_OUTDAY, nOutDayInLock)
        Log("RegressionPrivilege OnLogin BeLock", pPlayer.dwID, nOutDay, nOutDayInLock)
    else
        pPlayer.SetUserValue(self.GROUP, self.OUTLINE_DAY, nOutDay)
        if not bBackPlayer then
            pPlayer.SetUserValue(self.GROUP, self.ACTIVITY_TRIGGER, 0)
            pPlayer.SetUserValue(self.GROUP, self.ITEM_USED_FLAG, 0)
        end
        self:StartPrivilege(pPlayer)
        Log("RegressionPrivilege OnLogin", pPlayer.dwID, nOutDay, bBackPlayer)
    end
end

function RegressionPrivilege:OnUsePrivilegeItem(pPlayer)
    if self.tbNewServerActInfo and GetServerCreateTime() >= self.tbNewServerActInfo.nCreateTime then
        Activity:OnPlayerEvent(pPlayer, "Act_OnUseRegressionPrivilegeItem")
        return
    end

    pPlayer.SetUserValue(self.GROUP, self.ITEM_USED_FLAG, 1)
    local nOutDay = pPlayer.GetUserValue(self.GROUP, self.LOCK_OUTDAY)
    if nOutDay <= self.Outline_Days then
        --不是回归玩家，但是使用了道具
        Log("RegressionPrivilege OnUsePrivilegeItem Warning", pPlayer.dwID, nOutDay)
        nOutDay = self.Outline_Days
    end
    pPlayer.SetUserValue(self.GROUP, self.LOCK_OUTDAY, 0)

    nOutDay = math.min(nOutDay, self.Max_OutlineDays)
    pPlayer.SetUserValue(self.GROUP, self.OUTLINE_DAY, nOutDay)
    self:StartPrivilege(pPlayer, true)
    pPlayer.CenterMsg("Sử dụng thành công, chức năng gian hàng được bật")
    Log("RegressionPrivilege OnUsePrivilegeItem", pPlayer.dwID)
end

function RegressionPrivilege:SetPrivilege(pPlayer, nOutDay, tbPrivilege)
    local szPrivilege = ""
    for _, tbInfo in ipairs(tbPrivilege) do
        local nKey = tbInfo[1]
        local nPercent = tbInfo[3]
        local nLast = pPlayer.GetUserValue(self.GROUP, nKey)
        local nThis = math.ceil(nOutDay*nPercent) + nLast
        nThis = math.min(nThis, math.ceil(self.Max_OutlineDays*nPercent))
        pPlayer.SetUserValue(self.GROUP, nKey, nThis)
        local nMaxKey = tbInfo[2]
        if nMaxKey then
            pPlayer.SetUserValue(self.GROUP, nMaxKey, nThis)
        end
        szPrivilege = string.format("%s|%d:%d-%d", szPrivilege, nKey, nLast, nThis)
    end
    Log("RegressionPrivilege SetPrivilege", pPlayer.dwID, nOutDay, szPrivilege)
end

function RegressionPrivilege:StartPrivilege(pPlayer, bUseItem)
    local nGroup  = self.GROUP
    local nLastBeginTime = pPlayer.GetUserValue(nGroup, self.BEGIN_TIME)
    if not bUseItem and (Lib:GetLocalDay() - Lib:GetLocalDay(nLastBeginTime) < self.Outline_Days) then
        pPlayer.CenterMsg("Thiếu đặc quyền")
        return
    end
    local nOutDay = pPlayer.GetUserValue(nGroup, self.OUTLINE_DAY)
    if nOutDay < self.Outline_Days then
        nOutDay = self.Outline_Days
        pPlayer.SetUserValue(nGroup, self.OUTLINE_DAY, nOutDay)
        Log("RegressionPrivilege StartPrivilege Warning", pPlayer.dwID)
    end

    pPlayer.SetUserValue(nGroup, self.BEGIN_TIME, GetTime())
    pPlayer.SetUserValue(nGroup, self.NEW_VERSION, 1)
    pPlayer.SetUserValue(nGroup, self.FREE_GAIN, 0)
    pPlayer.SetUserValue(nGroup, self.TIANJIAN_FLAG, 0)

    local tbPrivilege = {
        {self.KINDONATE_TIMES, self.KINDONATE_TIMES_MAX, 1},
        {self.REFRESHSHOP_TIMES, self.REFRESHSHOP_TIMES_MAX, 1/7},
        {self.CHUANGONG_TIMES, self.CHUANGONG_TIMES_MAX, 2},
        {self.XIULIAN_TIMES, self.XIULIAN_TIMES_MAX, 1800},
        {self.MONEYTREE_TIMES, self.MONEYTREE_TIMES_MAX, 1},
        {self.KINSTORE_TIMES, self.KINSTORE_TIMES_MAX, 1},
        {self.DayTargetEXT.nSaveKey, self.DayTargetEXT.nMaxSaveKey, 1/self.DayTargetEXT.nDayPer},
    }
    for _, tbActInfo in pairs(self.DOUBLE_ACT) do
        table.insert(tbPrivilege, {tbActInfo.nSaveKey, tbActInfo.nMaxSaveKey, 1/tbActInfo.nDayPer})
    end
    --充值特权
    if pPlayer.GetUserValue(nGroup, self.OLD_VIPLEVEL) >= self.nRechargeVipLv then
        for _, tbInfo in pairs(self.RECHARGE_AWARD) do
            table.insert(tbPrivilege, {tbInfo.nSaveKey, nil, 1/tbInfo.nDayPer})
        end
    else
        for _, tbInfo in pairs(self.RECHARGE_AWARD) do
            pPlayer.SetUserValue(nGroup, tbInfo.nSaveKey, math.ceil(nOutDay/tbInfo.nDayPer))
        end
    end

    self:SetPrivilege(pPlayer, nOutDay, tbPrivilege)

    local nVipLv  = pPlayer.GetVipLevel()
    local nEnergy = self:GetEnergy(nVipLv, nOutDay)
    pPlayer.SetUserValue(nGroup, self.OLD_VIPLEVEL, nVipLv)
    pPlayer.SetUserValue(nGroup, self.YUANQI_AWARD, nEnergy)

    self:SendBackEmail(pPlayer)
    DirectLevelUp:CheckPlayerData(pPlayer)
    Log("RegressionPrivilege StartPrivilege", pPlayer.dwID, nOutDay)
end

function RegressionPrivilege:SendBackEmail(pPlayer)
    -- local nVipLv   = pPlayer.GetVipLevel()
    -- local nEndTime = self:GetPrivilegeTime(pPlayer)
    -- local nOut     = pPlayer.GetUserValue(self.GROUP, self.OUTLINE_DAY)
    -- local tbAward  = {{"Item", self.nClearItem, 1, nEndTime}, {"Item", 2708, 1, nEndTime}}
    -- local nEnergy  = self:GetEnergy(nVipLv, nOut)
    -- if nEnergy > 0 then
    --     table.insert(tbAward, {"Energy", nEnergy})
    -- end
    -- if nVipLv >= 4 then
    --     table.insert(tbAward, {"Item", 4759, 1, nEndTime})
    -- end

    -- table.insert(tbAward, {"SkillExp", 360*nOut})
    -- if nVipLv >= self.LvUp_VipLv then
    --     local nLevelUpTID = DirectLevelUp:GetCanBuyItem()
    --     local bHadBuy = DirectLevelUp:CheckHadBuyOne(pPlayer)
    --     if nLevelUpTID and not bHadBuy then
    --         DirectLevelUp:AddBuyedFlag(pPlayer, nLevelUpTID)
    --         table.insert(tbAward, {"Item", nLevelUpTID, 1, nEndTime})
    --         Log("RegressionPrivilege SendBackEmail With LevelUpItem", pPlayer.dwID)
    --     end
    -- end
    local tbAwardMail = {Title = "Quà trở lại", From = "Độc Cô Kiếm ", nLogReazon = Env.LogWay_RegressionPrivilege, Text = "      Tình duyên lại đúc mộng giang hồ! Kiếm hiệp trở về đúng lúc! Thiếu hiệp trở lại võ lâm, khiến người vui mừng, đặc biệt chuẩn bị lễ mọn, mong rằng thiếu hiệp lại sáng tạo huy hoàng.\n      Điều kiện phù hợp hiệp sĩ có thể đạt được gấp đôi trữ giá trị thiết lập lại khiến, chuyên môn xưng hào, đại lượng tu vi chờ miễn phí siêu giá trị phúc lợi, còn có trở về hoạt động ban thưởng gấp bội, lên thẳng đan, thiên kiếm khiến đánh gãy, mỗi ngày phúc lợi miễn phí thiết lập lại rất nhiều hảo lễ đón lấy, hiệp sĩ một ngày tại giang hồ, giang hồ không có một ngày lãng quên hiệp sĩ, tìm về bạn thân, tái chiến giang hồ![c8ff00] [url=openwnd: Ấn vào đây tìm hiểu, RegressionPrivilegePanel] [-]", To = pPlayer.dwID}
    -- tbAwardMail.nRecyleTime = nEndTime - GetTime()
    Mail:SendSystemMail(tbAwardMail)
end

-- function RegressionPrivilege:OnVipChanged(nNewLevel, nOldLevel)
--     local pPlayer = me
--     if nOldLevel >= self.LvUp_VipLv or nNewLevel < self.LvUp_VipLv then
--         return
--     end

--     if not self:IsInPrivilegeTime(pPlayer) then
--         return
--     end

--     local nItemTID = DirectLevelUp:GetCanBuyItem()
--     if not nItemTID then
--         return
--     end

--     if DirectLevelUp:CheckHadBuyOne(pPlayer) then
--         return
--     end

--     DirectLevelUp:AddBuyedFlag(pPlayer, nItemTID)
--     local nEndTime = self:GetPrivilegeTime(pPlayer)
--     pPlayer.SendAward({{"Item", nItemTID, 1, nEndTime}}, true, nil, Env.LogWay_RegressionPrivilege)
--     Log("RegressionPrivilege OnVipChanged", pPlayer.dwID, nOldLevel, nNewLevel, nItemTID)
-- end

function RegressionPrivilege:TryGainFreeGift(pPlayer, nId)
    if not self:IsNewVersionPlayer(pPlayer) then
        return
    end

    if not self:CheckFreeGain(pPlayer, nId) then
        return
    end

    local bRet, szMsg = RegressionPrivilege:CheckFreeGainExt(pPlayer, nId)
    if not bRet then
        pPlayer.CenterMsg(szMsg)
        return
    end

    local nFreeGain = pPlayer.GetUserValue(self.GROUP, self.FREE_GAIN)
    nFreeGain = KLib.SetBit(nFreeGain, nId, 1)
    pPlayer.SetUserValue(self.GROUP, self.FREE_GAIN, nFreeGain)
    local tbAward = self:GetFreeGainAward(pPlayer, nId)
    pPlayer.SendAward(tbAward, false, true, Env.LogWay_RegressionPrivilege)
    pPlayer.CenterMsg("Nhận thành công")
    pPlayer.CallClientScript("RegressionPrivilege:OnBuyCallBack")
    Log("RegressionPrivilege TryGainFreeGift", pPlayer.dwID, nId)
end

function RegressionPrivilege:CheckCanBuyDiscdTianJian(pPlayer)
    if not self:IsInPrivilegeTime(pPlayer) then
        return false, "Không phải trở về người chơi, không thể mua "
    end

    if pPlayer.GetUserValue(self.GROUP, self.OUTLINE_DAY) < self.tbTianJian.nCanBuyDay then
        return false, "Lần này không thể mua "
    end

    if pPlayer.GetUserValue(self.GROUP, self.TIANJIAN_FLAG) > 0 then
        return false, "Đã mua"
    end

    return true
end

function RegressionPrivilege:TryBuyDiscdTianJian(pPlayer)
    local bRet, szMsg = self:CheckCanBuyDiscdTianJian(pPlayer)
    if not bRet then
        pPlayer.CenterMsg(szMsg)
        return
    end

    local fnCostCallback = function (nPlayerId, bSuccess, szBillNo)
        return self:BuyTJSuccess(nPlayerId, bSuccess)
    end

    -- CostGold谨慎调用, 调用前请搜索 _LuaPlayer.CostGold 查看使用说明, 它处调用时请保留本注释
    local bRet = pPlayer.CostGold(self.tbTianJian.nPrice, Env.LogWay_RegressionPrivilege, nil, fnCostCallback)
    if not bRet then
        pPlayer.CenterMsg("Thanh toán không thành công, vui lòng thử lại")
    end
end

function RegressionPrivilege:BuyTJSuccess(nPlayerId, bSuccess)
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if not pPlayer then
        return false, "Người chơi đã ngoại tuyến"
    end

    if not bSuccess then
        return false, "Mua hàng thất bại"
    end

    local bRet, szMsg = self:CheckCanBuyDiscdTianJian(pPlayer)
    if not bRet then
        return false, szMsg
    end

    local nTJ = pPlayer.GetUserValue(self.GROUP, self.TIANJIAN_FLAG)
    pPlayer.SetUserValue(self.GROUP, self.TIANJIAN_FLAG, nTJ + 1)
    pPlayer.SendAward({{"Item", self.tbTianJian.nItemTID, 1}}, true, nil, Env.LogWay_RegressionPrivilege)
    return true
end

function RegressionPrivilege:TryBuyKinDonate(pPlayer)
    if pPlayer.dwKinId == 0 then
        pPlayer.CenterMsg("Hiện chưa có bang hội, không thể thiết lập lại")
        return
    end

    local nCanRecoverTimes = pPlayer.GetUserValue(self.GROUP, self.KINDONATE_TIMES)
    if nCanRecoverTimes <= 0 then
        pPlayer.CenterMsg("Số lần thiết lập không đủ")
        return
    end
    local szDegreeKey = "DonationCount"
    local nMax = DegreeCtrl:GetMaxDegree(szDegreeKey, pPlayer)
    local nCur = DegreeCtrl:GetDegree(pPlayer, szDegreeKey)
    if nCur >= nMax then
        pPlayer.CenterMsg("Số lần đã đủ, không cần thiết lập lại ")
        return
    end

    pPlayer.SetUserValue(self.GROUP, self.KINDONATE_TIMES, nCanRecoverTimes - 1)
    DegreeCtrl:AddDegree(pPlayer, szDegreeKey, nMax - nCur)
    pPlayer.CenterMsg("Số lần đóng góp hôm nay đã được thiết lập lại và có thể được quyên góp một lần nữa.")
    pPlayer.CallClientScript("RegressionPrivilege:OnBuyCallBack")
    pPlayer.CallClientScript("Ui:OpenWindow", "KinVaultPanel")
    Log("RegressionPrivilege TryBuyKinDonate", pPlayer.dwID, nCanRecoverTimes, nMax, nCur)
end

function RegressionPrivilege:TryRefreshShop(pPlayer)
    if pPlayer.nLevel < Shop.SHOW_LEVEL then
        pPlayer.CenterMsg("Cấp bậc chưa đủ, không cách nào thiết lập lại ")
        return
    end

    local nRefreshTimes = pPlayer.GetUserValue(self.GROUP, self.REFRESHSHOP_TIMES)
    if nRefreshTimes <= 0 then
        pPlayer.CenterMsg("Thiết lập lại số lần đã sử dụng hết ")
        return
    end

    nRefreshTimes = nRefreshTimes - 1
    pPlayer.SetUserValue(self.GROUP, self.REFRESHSHOP_TIMES, nRefreshTimes)
    Shop:RefreshLimitInfo(pPlayer)
    pPlayer.CallClientScript("RegressionPrivilege:OnBuyCallBack")
    pPlayer.CallClientScript("Ui:OpenWindow", "CommonShop", "Treasure")
    pPlayer.CenterMsg("Số lượng mua ở Kỳ Trân Các đã được thiết lập lại, và nó đã được chuyển đến Giảm giá cho các hiệp sĩ.")
    Log("RegressionPrivilege TryRefreshShop", pPlayer.dwID, nRefreshTimes)
end

function RegressionPrivilege:TryRestoreChuanGong(pPlayer)
    local nCanRecoverTimes = pPlayer.GetUserValue(self.GROUP, self.CHUANGONG_TIMES)
    if nCanRecoverTimes <= 0 then
        return
    end

    if pPlayer.nLevel < ChuangGong.nGetMinLevel then
        pPlayer.CenterMsg("Cấp độ không đủ, không thể nhận")
        return
    end

    nCanRecoverTimes = nCanRecoverTimes - 1
    pPlayer.SetUserValue(self.GROUP, self.CHUANGONG_TIMES, nCanRecoverTimes)
    DegreeCtrl:AddDegree(pPlayer, "ChuangGong", 1)
    pPlayer.CenterMsg("Nhận thành công 1 lần truyền công")
    pPlayer.CallClientScript("RegressionPrivilege:OnBuyCallBack")
    Log("RegressionPrivilege TryRestoreChuanGong", pPlayer.dwID, nCanRecoverTimes)
end

function RegressionPrivilege:CheckXiulanTime(pPlayer)
    local nCanRecoverTime = pPlayer.GetUserValue(self.GROUP, self.XIULIAN_TIMES)
    if nCanRecoverTime <= 0 then
        return false, "Không có thời gian tu luyện"
    end

    local nCount = pPlayer.GetItemCountInAllPos(1422) --修炼珠
    if nCount <= 0 then
        return false, "Không có tu luyện châu"
    end

    local nCanResidueTime = XiuLian.tbDef.nMaxAddXiuLianTime - XiuLian:GetXiuLianResidueTime(pPlayer)
    if nCanResidueTime <= 0 then
        return false, "Tích lũy thời gian tu luyện đã đầy"
    end
    return true, _, math.min(nCanRecoverTime, nCanResidueTime)
end

function RegressionPrivilege:TryAddXiulianTime(pPlayer)
    if not self:IsNewVersionPlayer(pPlayer) then
        return
    end

    local bRet, szMsg, nRecoverTime = self:CheckXiulanTime(pPlayer)
    if not bRet then
        pPlayer.CenterMsg(szMsg)
        return
    end

    local nLastTime = pPlayer.GetUserValue(self.GROUP, self.XIULIAN_TIMES) - nRecoverTime
    pPlayer.SetUserValue(self.GROUP, self.XIULIAN_TIMES, nLastTime)
    XiuLian:AddXiuLianResiduTime(pPlayer, nRecoverTime)
    pPlayer.CenterMsg(string.format("Thành công nhận lấy %s giờ tu luyện ", Lib:TimeDesc(nRecoverTime)))
    pPlayer.CallClientScript("RegressionPrivilege:OnBuyCallBack")
    Log("RegressionPrivilege TryAddXiulianTime", pPlayer.dwID, nRecoverTime)
end

function RegressionPrivilege:TryRestoreMoneyTree(pPlayer)
    local nCurTimes = pPlayer.GetUserValue(self.GROUP, self.MONEYTREE_TIMES)
    if nCurTimes <= 0 then
        pPlayer.CenterMsg("Không đủ số lần")
        return
    end

    local bHaveFree = MoneyTree:IsHaveFreeTimes(pPlayer)
    pPlayer.SetUserValue(self.GROUP, self.MONEYTREE_TIMES, nCurTimes - 1)
    local nMoney = MoneyTree:DoShaking(pPlayer)
    if bHaveFree then
        MoneyTree:RestoreFreeTimes(pPlayer)
    end

    pPlayer.CenterMsg(string.format("Hiệp sĩ tiêu hao miễn phí số lần run cây tiền, thu hoạch được %d Ngân lượng ", nMoney))
    pPlayer.CallClientScript("RegressionPrivilege:OnBuyCallBack")
    Log("RegressionPrivilege TryRestoreMoneyTree", pPlayer.dwID, nCurTimes - 1)
end

function RegressionPrivilege:TryRefreshKinStore(pPlayer)
    if not self:IsNewVersionPlayer(pPlayer) then
        return
    end
    if pPlayer.dwKinId == 0 then
        pPlayer.CenterMsg("Hiện chưa có bang hội, không thể thiết lập lại")
        return
    end

    if Shop:GetBuildingLevelServer(pPlayer, Kin.Def.Building_DrugStore) <= 0 then
        pPlayer.CenterMsg("Trân bảo phường chưa mở ra")
        return
    end

    local nCanRecoverTimes = pPlayer.GetUserValue(self.GROUP, self.KINSTORE_TIMES)
    if nCanRecoverTimes <= 0 then
        pPlayer.CenterMsg("Không đủ số lần đặt lại")
        return
    end

    Shop:RefreshFamilyShopWare(pPlayer);
    local tbFamilyShopData = pPlayer.GetScriptTable("FamilyShop")
    tbFamilyShopData.nLastDay = Lib:GetLocalDay(GetTime() - Shop.FAMILY_SHOP_REFRESH)

    pPlayer.SetUserValue(self.GROUP, self.KINSTORE_TIMES, nCanRecoverTimes - 1)
    pPlayer.CenterMsg("Đã đổi mới trân bảo phường thương phẩm, hiệp sĩ có thể tiến hành mua ")
    pPlayer.CallClientScript("RegressionPrivilege:OnBuyCallBack")
    pPlayer.CallClientScript("Ui:OpenWindow", "KinStore", Kin.Def.Building_DrugStore)
    Log("RegressionPrivilege TryRefreshKinStore", pPlayer.dwID, nCanRecoverTimes)
end

function RegressionPrivilege:OnBuyBackGiftSuccess(pPlayer, nGroupIdx, nBuyCount)
    if not self:IsInPrivilegeTime(pPlayer) or not self:IsNewVersionPlayer(pPlayer) then
        return nBuyCount
    end
    if pPlayer.GetVipLevel() < RegressionPrivilege.nRechargeVipLv then
        return nBuyCount
    end
    for _, tbInfo in ipairs(self.RECHARGE_AWARD) do
        if tbInfo.nRechargeIdx == nGroupIdx then
            local nSaveKey = tbInfo.nSaveKey
            local nLastTimes = pPlayer.GetUserValue(self.GROUP, nSaveKey)
            if nLastTimes > 0 then
                local nBuyTimes = math.min(nLastTimes, nBuyCount)
                local tbAllAward = {}
                for i = 1, nBuyTimes do
                    Lib:MergeTable(tbAllAward, tbInfo.tbAward)
                end
                pPlayer.SetUserValue(self.GROUP, nSaveKey, nLastTimes - nBuyTimes)
                pPlayer.SendAward(tbAllAward, true, true, Env.LogWay_RegressionPrivilege)
                pPlayer.CallClientScript("RegressionPrivilege:OnBuyCallBack")
                Log("RegressionPrivilege OnBuyBackGiftSuccess", pPlayer.dwID, nGroupIdx, nBuyCount, nLastTimes, nBuyTimes)
                return nBuyCount - nBuyTimes
            end
            Log("RegressionPrivilege OnBuyBackGiftSuccess Not Times", pPlayer.dwID, nGroupIdx, nBuyCount, nLastTimes)
            return nBuyCount
        end
    end
    Log("RegressionPrivilege OnBuyBackGiftSuccess GroupIdx Err", pPlayer.dwID, nGroupIdx, nBuyCount)
    return nBuyCount
end

function RegressionPrivilege:GetDoubleAward(pPlayer, szAct, tbSrcAward)
    if not pPlayer then
        return false, nil, tbSrcAward
    end

    if not self:IsInPrivilegeTime(pPlayer) or not self:IsNewVersionPlayer(pPlayer) then
        return false, nil, tbSrcAward
    end

    local tbInfo = self.DOUBLE_ACT[szAct]
    if not tbInfo then
        return false, nil, tbSrcAward
    end

    local nLastTime = pPlayer.GetUserValue(self.GROUP, tbInfo.nSaveKey)
    if nLastTime <= 0 then
        return false, nil, tbSrcAward
    end

    local tbFinalAward
    if tbSrcAward then
        tbFinalAward = {unpack(tbSrcAward)}
        local nSrcAwardLen = #tbSrcAward
        for i = 1, nSrcAwardLen do
            tbFinalAward[nSrcAwardLen + i] = tbSrcAward[i]
        end
    end
    nLastTime = nLastTime - 1
    pPlayer.SetUserValue(self.GROUP, tbInfo.nSaveKey, nLastTime)
    Log("RegressionPrivilege ReduceDoubleAward Times:", pPlayer.dwID, szAct, nLastTime)
    return true, tbInfo.szMsg, tbFinalAward
end

function RegressionPrivilege:OnGainEverydayTargetAward(pPlayer, nAwardIdx)
    if not self:IsInPrivilegeTime(pPlayer) then
        return
    end

    if not self:IsNewVersionPlayer(pPlayer) then
        return
    end

    local nLastTime = pPlayer.GetUserValue(self.GROUP, self.DayTargetEXT.nSaveKey)
    if nLastTime <= 0 then
        return
    end

    local tbAward = self.tbDayTargetAward[nAwardIdx]
    if not tbAward then
        return
    end

    nLastTime = nLastTime - 1
    pPlayer.SetUserValue(self.GROUP, self.DayTargetEXT.nSaveKey, nLastTime)
    pPlayer.SendAward(tbAward, true, false, Env.LogWay_RegressionPrivilege)
    pPlayer.CenterMsg("Tiền thưởng mục tiêu hàng ngày", true)
    Log("RegressionPrivilege OnGainEverydayTargetAward", pPlayer.dwID, nLastTime, nAwardIdx)
end

function RegressionPrivilege:OnNewServerActOpen(nVersion, nCreateTime, tbRechargeInfo)
    self.tbNewServerActInfo = {nVersion = nVersion, nCreateTime = nCreateTime, tbRechargeInfo = tbRechargeInfo}

    local tbAllPlayer = KPlayer.GetAllPlayer()
    for _, pPlayer in ipairs(tbAllPlayer) do
        if self:IsBeLock(pPlayer) then
            self:FreezePrivilege(pPlayer, nVersion)
            Log("RegressionPrivilege OnNewServerActOpen Freeze Privilege", pPlayer.dwID)
        end
    end
end

function RegressionPrivilege:OnNewServerActClose()
    self.tbNewServerActInfo = nil
    local tbAllPlayer = KPlayer.GetAllPlayer()
    for _, pPlayer in ipairs(tbAllPlayer) do
        self:RefreshBackPlayerData(pPlayer)
    end
end

function RegressionPrivilege:IsInPrivilegeCD(pPlayer)
    local nCurPrivilege = pPlayer.GetUserValue(self.GROUP, self.BEGIN_TIME)
    return nCurPrivilege + self.Privilege_CD > GetTime()
end

RegressionPrivilege.tbClientSafeCall = {
    TryBuyKinDonate      = 1,
    TryRefreshShop       = 1,
    TryRestoreChuanGong  = 1,
    TryRestoreMoneyTree  = 1,
    TryBuyDiscdTianJian  = 1,
    TryAddXiulianTime    = 1,
    TryGainFreeGift      = 1,
    TryRefreshKinStore   = 1,
}
function RegressionPrivilege:IsBeLock(pPlayer)
    if not self.tbNewServerActInfo or not self.tbNewServerActInfo.tbRechargeInfo[pPlayer.szAccount] then
        return
    end

    local nVersion     = pPlayer.GetUserValue(self.GROUP, self.ACTIVITY_TRIGGER)
    local nUseItemFlag = pPlayer.GetUserValue(self.GROUP, self.ITEM_USED_FLAG)
    return nVersion ~= self.tbNewServerActInfo.nVersion or nUseItemFlag == 0
end
function RegressionPrivilege:OnClientCall(pPlayer, szFunc, ...)
    if not szFunc or not self[szFunc] or not self.tbClientSafeCall[szFunc] then
        Log("RegressionPrivilege Try Call NotSafeFunc", pPlayer.dwID, szFunc)
        return
    end

    if not self:IsInPrivilegeTime(pPlayer) then
        pPlayer:CenterMsg("Không phải người chơi trở về, không thể thao tác")
        return
    end

    if self:IsBeLock(pPlayer) then
        return
    end

    self[szFunc](self, pPlayer, ...)
end

--根据离线天数获取当次可能能拿到的福利，真正算福利的时候不走该接口
function RegressionPrivilege:GetPrivilegeByOutDay(nOutDay, nVipLv)
    if nOutDay < self.Outline_Days then
        return
    end
    nOutDay = math.min(nOutDay, RegressionPrivilege.Max_OutlineDays)

    local tbPrivilege = {}
    local tbCan = {
        {1, "KinDonate"},
        {1/7, "RefreshShop"},
        {2, "ChuanGong"},
        {1800, "XiuLian"},
        {1, "MoneyTree"},
        {1, "KinStore"},
        {1/self.DayTargetEXT.nDayPer, "EveryDayTarget"},
    }
    for szKey, tbActInfo in pairs(self.DOUBLE_ACT) do
        table.insert(tbCan, {1/tbActInfo.nDayPer, "D_" .. szKey})
    end
    if nVipLv >= self.nRechargeVipLv then
        for nIdx, tbInfo in pairs(self.RECHARGE_AWARD) do
            table.insert(tbCan, {1/tbInfo.nDayPer, "Recharge_" .. nIdx})
        end
    end

    for _, tbInfo in pairs(tbCan) do
        tbPrivilege[tbInfo[2]] = math.ceil(nOutDay*tbInfo[1])
    end

    tbPrivilege.F_Title = 1
    tbPrivilege.F_YinLiang = nOutDay
    tbPrivilege.F_YuanBao = math.ceil(nOutDay/3)
    tbPrivilege.F_XiuWei = 360*nOutDay
    tbPrivilege.F_YuanQi = self:GetEnergy(nVipLv, nOutDay)
    if nVipLv >= self.nClearItemVipLv then
        tbPrivilege.F_WaiZhuang = 1
    end
    if nOutDay >= self.nDoubleCZLDay then
        tbPrivilege.F_ChongZhi = 1
    end
    return tbPrivilege
end