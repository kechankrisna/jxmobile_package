local tbAct = Activity:GetClass("WorldCupAct")
tbAct.tbTimerTrigger = {
    [1] = {szType = "Day", Time = "10:00" , Trigger = "SendWorldNotify" },
    [2] = {szType = "Day", Time = "13:00" , Trigger = "SendWorldNotify" },
    [3] = {szType = "Day", Time = "20:00" , Trigger = "SendWorldNotify" },
}
tbAct.tbTrigger = {
	Init={},
	Start={
        {"StartTimerTrigger", 1},
        {"StartTimerTrigger", 2},
        {"StartTimerTrigger", 3},
    },
	End={},
    SendWorldNotify = { {"WorldMsg", "Các vị thiếu hiệp, thế giới bôi hoạt động bắt đầu, mọi người có thể thông qua xem xét tin tức mới nhất hiểu rõ trong hoạt động cho!", 20} },
    OpenAct = {},
    CloseAct = {},
}

function tbAct:OnTrigger(szTrigger)
    Log("WorldCupAct:OnTrigger", szTrigger)
    if szTrigger=="Init" then
        RankBoard:ClearRank(self.szMainKey)
    elseif szTrigger=="Start" then
        local _, nEndTime = self:GetOpenTimeInfo()
        self:RegisterDataInPlayer(nEndTime)

        Activity:RegisterPlayerEvent(self, "Act_OnPlayerLogin", "OnLogin")
        Activity:RegisterPlayerEvent(self, "Act_EverydayTargetGainAward", "OnEverydayTargetGainAward")
        Activity:RegisterPlayerEvent(self, "Act_DailyGift", "OnBuyDailyGift") 
        Activity:RegisterPlayerEvent(self, "Act_WorldCupReq", "OnClientReq")
    elseif szTrigger=="End" then
        self:SendRankReward()
	end
end

function tbAct:GainUnidentified(pPlayer, nCount)
    if not nCount or nCount<=0 then
        return
    end
    local _, nEndTime = self:GetOpenTimeInfo()
    self:GainItem(pPlayer, self.nMedalItemId, nCount, nEndTime)
end

function tbAct:GainItem(pPlayer, nItemId, nCount, nExpire)
    if not nCount or nCount<=0 then
        return
    end
    local tbAward = {{"item", nItemId, nCount}}
    tbAward = self:FormatAward(tbAward, nExpire)
    pPlayer.SendAward(tbAward, true, true, Env.LogWay_WorldCupAct)
    Log("WorldCupAct:GainItem", pPlayer.dwID, nCount)
end

function tbAct:OnLogin(pPlayer)
    self:UpdateRank(pPlayer)
end

function tbAct:GetRankAward(nRank, nScore)
    local tbAward = {}
    if nScore<=0 then
        return tbAward
    end
    for _, tbInfo in ipairs(self.tbRankAward) do
        if nRank <= tbInfo[1] then
            for i=2, #tbInfo do
                table.insert(tbAward, tbInfo[i])
            end
            break
        end
    end
    return tbAward
end

function tbAct:SendRankReward()
    RankBoard:Rank(self.szMainKey)

    local tbRankPlayer = RankBoard:GetRankBoardWithLength(self.szMainKey, 99999, 1)
    local tbMail = {Title = "Thế giới bôi", From = "Hệ thống", nLogReazon = Env.LogWay_WorldCupAct}
    local nSendNum = 0
    for nRank, tbRankInfo in ipairs(tbRankPlayer or {}) do
        local tbAward = self:GetRankAward(nRank, tonumber(tbRankInfo.szValue))
        if not tbAward or not next(tbAward) then
            break
        end
        local szMailText = string.format(self.szMailText, nRank)
        tbMail.Text = szMailText
        tbMail.To = tbRankInfo.dwUnitID
        tbMail.tbAttach = tbAward
        Mail:SendSystemMail(tbMail)
        nSendNum = nRank
        Log("WorldCupAct:SendRankReward, to player", tbRankInfo.dwUnitID, nRank, tbRankInfo.szValue)
    end
    Log("WorldCupAct:SendRankReward", nSendNum)
end

tbAct.tbValidReqs = {
    UpdateData = true,
    CollectMedal = true,
    GainReward = true,
    Transfer = true,
}
function tbAct:OnClientReq(pPlayer, szType, ...)
    if not self.tbValidReqs[szType] then
        return
    end

    local fn = self["OnReq_"..szType]
    if not fn then
        return
    end

    local bOk, szErr = fn(self, pPlayer, ...)
    if not bOk then
        if szErr and szErr~="" then
            pPlayer.CenterMsg(szErr)
            return
        end
    end
end

function tbAct:OnReq_UpdateData(pPlayer)
    local tbData = {}
    local tbSaveData = self:GetDataFromPlayer(pPlayer.dwID) or {}
    tbData.tbItems = tbSaveData.tbItems or {}
    tbData.bGainReward = tbSaveData.bGainReward
    tbData.nPosition = 0
    tbData.nScore = self:GetTotalScore(tbSaveData)

    local pRank = KRank.GetRankBoard(self.szMainKey)
    if pRank then
        local tbInfo = pRank.GetRankInfoByID(pPlayer.dwID)
        if tbInfo then
            tbData.nPosition = tbInfo.nPosition
            tbData.nScore = tonumber(tbInfo.szValue)
        end
    end
    pPlayer.CallClientScript("Activity.WorldCupAct:OnUpdateData", tbData)
end

function tbAct:OnReq_GainReward(pPlayer)
    local tbSaveData = self:GetDataFromPlayer(pPlayer.dwID) or {}
    if tbSaveData.bGainReward then
        return false, "Ngươi đã lĩnh qua"
    end

    if Lib:CountTB(tbSaveData.tbItems)<Lib:CountTB(self.tbShowItems) then
        return false, "Chưa tập hợp đủ tất cả huy chương"
    end

    tbSaveData.bGainReward = true
    pPlayer.SendAward(self.tbCollect32Rewards, true, true, Env.LogWay_WorldCupAct)
    self:SaveDataToPlayer(pPlayer, tbSaveData)
    self:OnReq_UpdateData(pPlayer)
    return true
end

function tbAct:OnReq_CollectMedal(pPlayer, nItemId)
    local pItem = KItem.GetItemObj(nItemId)
    if not pItem then
        return false, "Đạo cụ không tồn tại"
    end
    local szName = pItem.szName
    local nTemplateId = pItem.dwTemplateId
    if pPlayer.ConsumeItem(pItem, 1, Env.LogWay_WorldCupAct)~=1 then
        Log("[x] WorldCupAct:OnReq_CollectMedal", nTemplateId, nItemId)
        return false, "Tiêu hao đạo cụ thất bại"
    end

    local tbSaveData = self:GetDataFromPlayer(pPlayer.dwID) or {}
    tbSaveData.tbItems = tbSaveData.tbItems or {}
    tbSaveData.tbItems[nTemplateId] = (tbSaveData.tbItems[nTemplateId] or 0)+1
    self:SaveDataToPlayer(pPlayer, tbSaveData)
    self:UpdateRank(pPlayer)

    if pPlayer.GetItemCountInAllPos(self.nBookId)<=0 then
        local _, nEndTime = self:GetOpenTimeInfo()
        pPlayer.SendAward({{"item", self.nBookId, 1, nEndTime}}, true, true, Env.LogWay_WorldCupAct)
    end
    pPlayer.CenterMsg(string.format("Thành công thu thập: %s", szName))

    if not tbSaveData.bGainReward and Lib:CountTB(tbSaveData.tbItems)>=32 then
        local szMsg = "Chúc mừng đại hiệp tập hợp đủ huy chương! Nhanh đi thu thập sách mở ra bảo rương đi!"
        pPlayer.CenterMsg(szMsg, true)
    end

    self:OnReq_UpdateData(pPlayer)
    Log("WorldCupAct:OnReq_CollectMedal", pPlayer.dwID, nTemplateId, nItemId)
    return true
end

function tbAct:OnReq_Transfer(pPlayer, bNormal, nFromItemId, nToItemId)
    bNormal = not not bNormal

    if not nFromItemId or nFromItemId <= 0 then
        return false, "Mời lựa chọn muốn chuyển đổi huy chương"
    end

    if nFromItemId == nToItemId then
        return false, "Đợi chuyển đổi huy chương không được cùng mục tiêu huy chương giống nhau!"
    end

    local tbSaveData = self:GetDataFromPlayer(pPlayer.dwID) or {tbItems = {}}
    local nCount = tbSaveData.tbItems[nFromItemId] or 0
    if nCount <= 0 then
        return false, "Chưa thu hoạch được lựa chọn huy chương"
    end

    if bNormal then
        local nToItemId = 0
        while true do
            local nIdx = MathRandom(#self.tbShowItems)
            nToItemId = self.tbShowItems[nIdx]
            if nToItemId ~= nFromItemId then
                break
            end
        end
        return self:Transfer(pPlayer, bNormal, tbSaveData, nFromItemId, nToItemId)
    end

    if not nToItemId or nToItemId <= 0 then
        return false, "Mời lựa chọn muốn chuyển đổi mục tiêu huy chương"
    end
    local nCount = tbSaveData.tbItems[nToItemId] or 0
    if nCount <= 0 then
        return false, "Chưa thu hoạch được lựa chọn mục tiêu huy chương"
    end
    return self:Transfer(pPlayer, bNormal, tbSaveData, nFromItemId, nToItemId)
end

function tbAct:Transfer(pPlayer, bNormal, tbSaveData, nFromItemId, nToItemId)
    local nItemId = bNormal and self.nTransferItemNormal or self.nTransferItemAdvance
    if pPlayer.ConsumeItemInBag(nItemId, 1, Env.LogWay_WorldCupAct) ~= 1 then
        Log("[x] tbAct:OnReq_Transfer, ConsumeItemInBag failed", nItemId, pPlayer.dwID)
        return false, "Tiêu hao đạo cụ thất bại"
    end

    tbSaveData.tbItems[nFromItemId] = tbSaveData.tbItems[nFromItemId] - 1
    if tbSaveData.tbItems[nFromItemId] <= 0 then
        tbSaveData.tbItems[nFromItemId] = nil
    end
    self:SaveDataToPlayer(pPlayer, tbSaveData)
    self:UpdateRank(pPlayer)
    self:GainItem(pPlayer, nToItemId, 1, self.nTransferExpire)
    local szName = KItem.GetItemShowInfo(nToItemId, pPlayer.nFaction, pPlayer.nSex)
    me.CallClientScript("Ui:CloseWindow", "WorldCupTransferPanel")
    Log("WorldCupAct:Transfer", pPlayer.dwID, tostring(bNormal), nFromItemId, nToItemId)
    return true
end

function tbAct:GetTotalScore(tbSaveData)
    local nTotalScore = 0
    for nItemId, nCount in pairs(tbSaveData.tbItems or {}) do
        local nScore = self.tbScoreCfg[nItemId] or 1
        nTotalScore = nTotalScore+nScore*nCount
    end
    return nTotalScore
end

function tbAct:UpdateRank(pPlayer)
    if not self:CheckPlayer(pPlayer) then
        return
    end
    
    local pRank = KRank.GetRankBoard(self.szMainKey)
    if not pRank then
        return
    end

    local tbSaveData = self:GetDataFromPlayer(pPlayer.dwID) or {}
    local nTotalScore = self:GetTotalScore(tbSaveData)
    if nTotalScore<=0 then
        return
    end
    local tbInfo = pRank.GetRankInfoByID(pPlayer.dwID)
    if tbInfo and nTotalScore==tonumber(tbInfo.szValue) then
        return
    end
    RankBoard:UpdateRankVal(self.szMainKey, pPlayer.dwID, nTotalScore)
end

-- 1,3,6元礼包nGroupIndex分别对应1,2,3 nBuyCount购买数量
function tbAct:OnBuyDailyGift(pPlayer, nGroupIndex, nBuyCount)
    if not self:CheckPlayer(pPlayer) then
        return
    end
    local nCount = self.tbDailyGiftAward[nGroupIndex]
    if not nCount or nCount <= 0 then
        return
    end

    self.tbLastTakeTime = self.tbLastTakeTime or {}
    self.tbLastTakeTime[pPlayer.dwID] = self.tbLastTakeTime[pPlayer.dwID] or {}
    local nLastTime = self.tbLastTakeTime[pPlayer.dwID][nGroupIndex] or 0
    local nNow = GetTime()
    if not Lib:IsDiffDay(4 * 3600, nLastTime, nNow) then
        Log("WorldCupAct:OnBuyDailyGift, repurchase", pPlayer.dwID, nGroupIndex, nBuyCount, nLastTime, nNow)
        return
    end
    self.tbLastTakeTime[pPlayer.dwID][nGroupIndex] = nNow

    self:GainUnidentified(pPlayer, nCount*nBuyCount)
    Log("WorldCupAct:OnBuyDailyGift", pPlayer.dwID, nGroupIndex, nCount, nBuyCount)
end

function tbAct:OnEverydayTargetGainAward(pPlayer, nAwardIdx)
    if not self:CheckPlayer(pPlayer) then
        return
    end
    local nCount = self.tbActiveAward[nAwardIdx]
    if not nCount or nCount<=0 then
        return
    end
    self:GainUnidentified(pPlayer, nCount)
    Log("WorldCupAct:OnEverydayTargetGainAward", pPlayer.dwID, nAwardIdx, nCount)
end

function tbAct:FormatAward(tbAward, nEndTime)
    if not MODULE_GAMESERVER or not Activity:__IsActInProcessByType("WorldCupAct") or not nEndTime then
        return tbAward
    end
    local tbFormatAward = Lib:CopyTB(tbAward or {})
    for _, v in ipairs(tbFormatAward) do
        if v[1] == "item" or v[1] == "Item" then
            v[4] = nEndTime
        end
    end
    return tbFormatAward
end

function tbAct:GetUiData()
    if not self.tbUiData then
        local tbData = {}
        tbData.nShowLevel = 20
        tbData.szTitle = "Thế giới bôi hoạt động"
        tbData.nBottomAnchor = 0

        local nStartTime, nEndTime = self:GetOpenTimeInfo()
        local tbTime1 = os.date("*t", nStartTime)
        local tbTime2 = os.date("*t", nEndTime)
        tbData.szContent = string.format([[Thời gian hoạt động: [c8ff00]%s Năm %s Nguyệt %s Nhật %d Điểm -%s Năm %s Nguyệt %s Nhật %s Điểm [-]
2018 Thế giới bôi bắt đầu!
]], tbTime1.year, tbTime1.month, tbTime1.day, tbTime1.hour, tbTime2.year, tbTime2.month, tbTime2.day, tbTime2.hour)
        tbData.tbSubInfo = {}
        table.insert(tbData.tbSubInfo, {szType = "Item2", szInfo = [[[FFFE0D] Thu hoạch huy chương Giám định thu thập [-]
Hoạt động trong lúc đó đại hiệp sinh động độ đạt tới [FFFE0D]60[-], [FFFE0D]80[-], [FFFE0D]100[-], mở ra đối ứng [FFFE0D] Sinh động bảo rương [-], hoặc là nhận lấy [FFFE0D] Mỗi ngày gói quà [-] Đều sẽ đạt được [ff578c][url=openwnd: Chưa giám định huy chương, ItemTips, "Item", nil, 8217][-], đại hiệp có thể tiêu hao [FFFE0D]60 Cống hiến [-] Đối giám định, có thể giám định ra năm nay thế giới bôi 32 Chi đội dự thi ngũ bên trong ngẫu nhiên một chi đội ngũ huy chương, sử dụng nên huy chương có thể đem để vào [e6d012][url=openwnd:2018 Thế giới bôi huy chương thu thập sách, ItemTips, "Item", nil, 8216][-] Bên trong.
[ff578c] Chú [-]: Mỗi ngày đại hiệp nhiều nhất từ [FFFE0D] Mỗi ngày gói quà [-] Đường tắt thu hoạch được [FFFE0D]3[-] Cái [ff578c][url=openwnd: Chưa giám định huy chương, ItemTips, "Item", nil, 8217][-].
[FFFE0D] Thu thập đầy sách Mở ra bảo rương [-]
Đương đại hiệp thu thập đầy thu thập sách bên trong tất cả khác biệt đội tuyển quốc gia ngũ huy chương sau, có thể mở ra thu thập sách bên trong bảo rương, thu hoạch được 6 Cái [aa62fc][url=openwnd: Tử thủy tinh, ItemTips, "Item", nil, 224][-]!
[FFFE0D] Giá trị xếp hạng Xếp hạng lĩnh thưởng [-]
Đại hiệp thu tập được khác biệt huy chương mở đầu giá trị đều là [FFFE0D]1[-], theo thế giới bôi tranh tài tiến hành, khác biệt huy chương giá trị cũng sẽ tùy theo cải biến. Tiểu tổ ra biên giá trị biến thành [FFFE0D]2[-], xâm nhập bát cường giá trị biến thành [FFFE0D]4[-], đưa thân tứ cường giá trị biến thành [FFFE0D]8[-], lực đoạt quý quân giá trị biến thành [FFFE0D]12[-], dũng lấy á quân giá trị biến thành [FFFE0D]16[-], nâng lên Đại lực thần chén giá trị biến thành [FFFE0D]32[-].
Cuối cùng hoạt động kết thúc lúc ([ff578c]2018 Năm 7 Nguyệt 16 Nhật 23:59[-]) Dựa theo các đại hiệp thu tập được tất cả huy chương giá trị xếp hạng cấp cho ban thưởng, ban thưởng như sau:
Thứ 1 Tên ----------------------------------100 Cái [ff8f06][url=openwnd: Hòa Thị Bích, ItemTips, "Item", nil, 2804][-]
Thứ 2 Đến thứ 5 Tên -----------------------------60 Cái [ff8f06][url=openwnd: Hòa Thị Bích, ItemTips, "Item", nil, 2804][-]
Thứ 6 Đến thứ 10 Tên ----------------------------40 Cái [ff8f06][url=openwnd: Hòa Thị Bích, ItemTips, "Item", nil, 2804][-]
Thứ 11 Đến thứ 20 Tên ---------------------------30 Cái [ff8f06][url=openwnd: Hòa Thị Bích, ItemTips, "Item", nil, 2804][-]
Thứ 21 Đến thứ 50 Tên ---------------------------20 Cái [ff8f06][url=openwnd: Hòa Thị Bích, ItemTips, "Item", nil, 2804][-]
Thứ 51 Đến thứ 200 Tên --------------------------10 Cái [ff8f06][url=openwnd: Hòa Thị Bích, ItemTips, "Item", nil, 2804][-]
Thứ 201 Đến thứ 500 Tên -------------------------5 Cái [ff8f06][url=openwnd: Hòa Thị Bích, ItemTips, "Item", nil, 2804][-]
Ngoài ra thứ 1 Tên sẽ còn thu hoạch được [ff8f06][url=openwnd: Xưng hào · Thế giới bóng đá tiên sinh, ItemTips, "Item", nil, 8274][-], [e6d012][url=openwnd:< Huyết đồng · Rít gào sương > Tọa kỵ thời trang, ItemTips, "Item", nil, 8254][-]
Thứ 2 Đến thứ 5 Tên sẽ thu hoạch được [ff578c][url=openwnd: Xưng hào · Hiểu cầu đế, ItemTips, "Item", nil, 8275][-], [e6d012][url=openwnd:< Huyết đồng · Hoang bụi > Tọa kỵ thời trang, ItemTips, "Item", nil, 8255][-]
]]})

        self.tbUiData = tbData
    end
    return self.tbUiData
end