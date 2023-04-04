local tbAct           = Activity:GetClass("FathersDay")
tbAct.tbTrigger       = { Init = { }, Start = {{"StartTimerTrigger", 1}, {"StartTimerTrigger", 2}}, End = { }, RefreshFlowerState = {}}
tbAct.szScriptDataKey = "FathersDay_Act"

tbAct.NEED_IMITITY_LV = 1 --亲密度等级
tbAct.NEED_PLAYER_LV  = 20 --玩家等级
tbAct.ENTRY_NPC_TID   = 2204 --入口Npc
tbAct.MAX_CURE_TIMES  = 4
tbAct.Cure_ItemTID    = {{3945, 3944}, {3946, 3947}} --治疗对应的道具
tbAct.tbNpcPos        = { --npc坐标
{4780, 5668},
{4650, 5335},
{4744, 5032},
{5338, 4986},
{5047, 4950},
{5438, 5280},
{5411, 5632},
{5107, 5750},
{4610, 5798},
{4410, 5562},
{4429, 5174},
{4517, 4844},
{4853, 4729},
{5256, 4689},
{5698, 5486},
{5532, 5962},
{5271, 6059},
{4914, 5980},
{4171, 5383},
{4180, 4995},
{4668, 4577},
{5077, 4513},
}
tbAct.tbBlackMsg      = {
    "Cây đào tản mát ra một trận mùi thơm, lại đưa tới một đoàn ong độc",
    "Cây đào có chút đong đưa, ngươi thuận nó đong đưa phương hướng nhìn lại, trong đất lại chôn dấu một cái rương",
    "Cây đào có chút đong đưa, chung quanh vậy mà mọc ra một chút thực vật",
}
tbAct.tbNpcInfo       = { --生成的Npc
    {{2199, 2199, 2199, 2199}, {{"Item", 3957, 1}}, 1}, --怪1
    {{2200, 2200}, {{"Item", 3959, 1}}, 1}, --怪2
    {{2202}, {{"Item", 3958, 1}}, 2}, --宝箱
    {{2201, 2201}, {{"Item", 3959, 1}}, 3}, --采集物
}
tbAct.tbCureItem      = {{{"Item", 3944, 99}, {"Item", 3945, 99}, {"Item", 3911, 1, 30*24*60*60}, {"Item", 4879, 1, 30*24*60*60}}, {{"Item", 3946, 99}, {"Item", 3947, 99}, {"Item", 3911, 1, 30*24*60*60}, {"Item", 4879, 1, 30*24*60*60}}} --报名时的奖励
tbAct.nCureTime       = 3 * 60 --治疗的有效时间
tbAct.szNotifyLink    = string.format("[url=npc:text, %d, %d]", tbAct.ENTRY_NPC_TID, 999)
tbAct.nRandomIllMin   = 4
tbAct.nRandomIllMax   = 8
tbAct.tbCureAward     = {{"Item", 3910, 1}}

function tbAct:OnTrigger(szTrigger)
    if szTrigger == "Init" then
        ScriptData:SaveValue(self.szScriptDataKey, {})
    elseif szTrigger == "Start" then
        self.tbMapList = {}
        self.tbCureInfo = {}
        Activity:RegisterNpcDialog(self, self.ENTRY_NPC_TID, {Text = "Báo danh tham dự hoạt động", Callback = self.TryApply, Param = {self}})
        Activity:RegisterNpcDialog(self, self.ENTRY_NPC_TID, {Text = "Tiến về mới lạ tiểu viện", Callback = self.TryEnter, Param = {self}})
        Activity:RegisterPlayerEvent(self, "Act_ArobrNpcEvent", "NpcEvent")
        Activity:RegisterPlayerEvent(self, "Act_OnPlayerLogin", "OnLogin")
        Activity:RegisterPlayerEvent(self, "Act_OnTryCure", "TryCure")
        Activity:RegisterPlayerEvent(self, "Act_OnEnterMap", "OnEnterMap")
        local tbNpc = Npc:GetClass("AroborFlower")
        tbNpc:OnChangeTitleActBegin(self.GetFlowerState, self)
        self.nIllTypeCount = #(self.tbIllType[1])

        local _, nEndTime = self:GetOpenTimeInfo()
        for _1, tbInfo1 in ipairs(self.tbCureItem) do
            for _2, tbInfo2 in ipairs(tbInfo1) do
                if Player.AwardType[tbInfo2[1]] == Player.award_type_item then
                    tbInfo2[4] = tbInfo2[4] and (tbInfo2[4]+nEndTime) or nEndTime
                end
            end
        end
        self.tbCureAward[1][4] = nEndTime
        self:CheckRefreshFlowerState()
    elseif szTrigger == "RefreshFlowerState" then
        self:RefreshFlowerState()
    elseif szTrigger  == "End" then
        local tbNpc = Npc:GetClass("AroborFlower")
        tbNpc:OnChangeTitleActEnd()

        for _, nMapId in pairs(self.tbMapList) do
            if GetMapInfoById(nMapId) then
                local tbPlayer = KPlayer.GetMapPlayer(nMapId)
                for _, pPlayer in ipairs(tbPlayer or {}) do
                    pPlayer.GotoEntryPoint()
                    pPlayer.CallClientScript("Ui:CloseWindow", "HomeScreenFuben")
                end
            end
        end
        self.tbMapList = {}

        for _, tbInfo in pairs(self.tbCureInfo) do
            Timer:Close(tbInfo.nCureTimer)
        end
        self.tbCureInfo = {}
        ScriptData:SaveValue(self.szScriptDataKey, nil)
    end
end

function tbAct:CheckRefreshFlowerState()
    local tbData = self:GetActivityData()
    local nLastRefreshTime = tbData.nRefreshTime
    if nLastRefreshTime and nLastRefreshTime > 0 then
        nLastRefreshTime = Lib:GetTodaySec(nLastRefreshTime)
        local nTodaySec = Lib:GetTodaySec()
        for _, tbInfo in ipairs(self.tbTimerTrigger) do
            local sHour, sMin = string.match(tbInfo.Time, "(%d+):(%d+)")
            local nTime = tonumber(sHour)*3600 + tonumber(sMin)*60
            if nLastRefreshTime < nTime and nTodaySec > nTime then
                self:RefreshFlowerState()
                break
            end
        end
    end
end

function tbAct:RefreshFlowerState()
    local tbData = self:GetActivityData()
    tbData.nRefreshTime = GetTime()
    tbData.nRefreshIdx = tbData.nRefreshIdx + 1
    ScriptData:AddModifyFlag(self.szScriptDataKey)

    local tbPlayer = KPlayer.GetAllPlayer()
    for _, pPlayer in ipairs(tbPlayer) do
        self:CheckPlayerData(pPlayer)
        if pPlayer.GetUserValue(self.GROUP, self.LOVER) > 0 then
            self:SendNotify2Player(pPlayer)
        end
    end

    -- local szDesc = self:GetRefreshDesc()
    for _, nMapId in pairs(self.tbMapList) do
        if GetMapInfoById(nMapId) then
            local tbPlayer = KPlayer.GetMapPlayer(nMapId)
            for _, pPlayer in ipairs(tbPlayer or {}) do
                self:RefreshPlayerDesc(pPlayer)
            end
        end
    end
    Log("FathersDay RefreshFlowerState", tbData.nRefreshTime, tbData.nRefreshIdx)
end

function tbAct:OnLogin(pPlayer)
    self:CheckPlayerData(pPlayer)
    local nLover = pPlayer.GetUserValue(self.GROUP, self.LOVER)
    if nLover == 0 then
        return
    end
    local tbStayInfo      = KPlayer.GetRoleStayInfo(pPlayer.dwID)
    local nLastOnlineTime = tbStayInfo and tbStayInfo.nLastOnlineTime or 0
    if nLastOnlineTime <= 0 then
        return
    end

    local nRefreshTime = self:GetActivityData().nRefreshTime
    if nRefreshTime <= nLastOnlineTime then
        return
    end

    self:SendNotify2Player(pPlayer)
end

function tbAct:SendNotify2Player(pPlayer)
    local tbNofityData = {
        szType = "FathersDayAct",
        nTimeOut = GetTime() + 60*10,
        szLink = self.szNotifyLink,
    }
    pPlayer.CallClientScript("Ui:SynNotifyMsg", tbNofityData)
end

function tbAct:CheckPlayerData(pPlayer)
    local nStartTime = self:GetOpenTimeInfo()
    if pPlayer.GetUserValue(self.GROUP, self.DATA_VERSION) == nStartTime then
        return
    end
    pPlayer.SetUserValue(self.GROUP, self.DATA_VERSION, nStartTime)
    pPlayer.SetUserValue(self.GROUP, self.SCORE, 0)
    for i = self.LOVER, self.FLOWER_STATE_E do
        pPlayer.SetUserValue(self.GROUP, i, 0)
    end
end

function tbAct:CheckCanApply(pPlayer, nApplyPlayer)
    self:CheckPlayerData(pPlayer)
    if pPlayer.GetUserValue(self.GROUP, self.LOVER) > 0 then
        return false, "Đã thành công báo danh hoạt động, không thể lặp lại báo danh"
    end

    if pPlayer.nLevel < self.NEED_PLAYER_LV then
        return false, "Cần [FFFE0D]20 Cấp [-] Mới có thể tham dự hoạt động"
    end

    if pPlayer.dwTeamID == 0 then
        return false, "Cần [FFFE0D] Sư đồ [-] Tạo thành [FFFE0D]2 Người [-] Đội ngũ a"
    end

    local tbMember = TeamMgr:GetMembers(pPlayer.dwTeamID)
    if #tbMember ~= 2 then
        return false, "Cần [FFFE0D] Sư đồ [-] Tạo thành [FFFE0D]2 Người [-] Đội ngũ a"
    end

    if not nApplyPlayer then
        local pTeamData = TeamMgr:GetTeamById(pPlayer.dwTeamID)
        if pTeamData.nCaptainID ~= pPlayer.dwID then
            return false, "Chỉ có đội trưởng mới có thể đi vào đi báo danh"
        end
    end

    local nPlayer = pPlayer.dwID
    local nLover = tbMember[1] == nPlayer and tbMember[2] or tbMember[1]
    local pLover = KPlayer.GetPlayerObjById(nLover)
    if not pLover then
        return false, "Không tìm được đồng đội"
    end

    if nApplyPlayer and nApplyPlayer ~= nLover then
        return false, "Xin đã qua kỳ"
    end

    self:CheckPlayerData(pLover)
    if pLover.GetUserValue(self.GROUP, self.LOVER) > 0 then
        return false, "Trước mắt đội ngũ thành viên đã lựa chọn cùng người khác cùng nhau trồng"
    end

    if pLover.nLevel < self.NEED_PLAYER_LV then
        return false, "Đồng đội cấp bậc chưa đủ [FFFE0D]20 Cấp [-], không cách nào tham gia hoạt động"
    end

    if not TeacherStudent:_IsConnected(pPlayer, pLover) then
        return false, "Ngươi cùng đối phương cũng không phải là quan hệ thầy trò, xin xác nhận sau đang tiến hành nếm thử a"
    end

    if FriendShip:GetFriendImityLevel(nPlayer, nLover) < self.NEED_IMITITY_LV then
        return false, "Độ thân mật nhất định phải ≥1 Cấp mới có thể tham dự a"
    end

    local nMyMapId, nMX, nMY = pPlayer.GetWorldPos()
    local pMemberNpc = pLover.GetNpc()
    local nCurMapId, nHX, nHY = pMemberNpc.GetWorldPos()
    if nMyMapId ~= nCurMapId then
        return false, "Hay là chờ tất cả đội viên đến đông đủ sau lại đến đi!"
    end 

    local fDists = Lib:GetDistsSquare(nHX, nHY, nMX, nMY)
    if fDists > (PunishTask.nMinDistance * PunishTask.nMinDistance) then
        return false, "Hay là chờ tất cả đội viên đến đông đủ sau lại đến đi"
    end    

    return true, "", pLover
end

function tbAct:TryApply()
    local bRet, szMsg, pLover = self:CheckCanApply(me)
    if not bRet then
        me.CenterMsg(szMsg or "")
        return
    end

    local nApplyPlayer = me.dwID
    local szMsg = string.format("%s Mời ngươi cùng nhau đi tới mới lạ tiểu viện trồng cây đào, một khi xác định, hoạt động trong lúc đó [FFFE0D] Không thể thay người [-], phải chăng xác định?", me.szName)
    pLover.MsgBox(szMsg, {{"Xác định", function () self:TryAgreeApply(nApplyPlayer) end, nApplyPlayer}, {"Hủy bỏ"}})
end

function tbAct:TryAgreeApply(nApplyPlayer)
    local pPlayer = me
    local bRet, szMsg, pLover = self:CheckCanApply(pPlayer, nApplyPlayer)
    if not bRet then
        pPlayer.CenterMsg(szMsg or "")
        return
    end

    local nSex1 = TeacherStudent:IsMyStudent(pPlayer, pLover.dwID) and 1 or 2
    pPlayer.SetUserValue(self.GROUP, self.LOVER, pLover.dwID)
    pPlayer.SetUserValue(self.GROUP, self.SEX_INACT, nSex1)
    local nSex2 = nSex1 == 1 and 2 or 1
    pLover.SetUserValue(self.GROUP, self.LOVER, pPlayer.dwID)
    pLover.SetUserValue(self.GROUP, self.SEX_INACT, nSex2)
    for i = self.FLOWER_STATE_B, self.FLOWER_STATE_E do
        local nIllData1 = pPlayer.GetUserValue(self.GROUP, i)
        local nIllData2 = pLover.GetUserValue(self.GROUP, i)
        local nIllCount = MathRandom(self.nRandomIllMin, self.nRandomIllMax)
        for i = 1, nIllCount do
            local nIll = MathRandom(self.nIllTypeCount)
            local nAdd = nIll == 1 and 1 or 100
            if i%self.nIllTypeCount == 1 then
                nIllData1 = nIllData1 + nAdd
            else
                nIllData2 = nIllData2 + nAdd
            end
        end
        pPlayer.SetUserValue(self.GROUP, i, nIllData1)
        pLover.SetUserValue(self.GROUP, i, nIllData2)
    end

    local szMsg   = "    Chúc mừng hiệp sĩ thành công báo danh tham gia hoạt động, đây là đưa tặng cho hiệp sĩ bảo dưỡng công cụ, hiện tại nhanh đi tìm [c8ff00][url=npc: Chân nhi cô nương, 2204, 999][-] Tiến về mới lạ tiểu viện dưỡng dục các ngươi cây đào đi!"
    local szTitle = "Một khi đào lý khắp thiên hạ"
    local tbMail  = {Title = szTitle, Text = szMsg, tbAttach = self.tbCureItem[nSex1], To = pPlayer.dwID, nLogReazon = Env.LogWay_FathersDay}
    Mail:SendSystemMail(tbMail)


    local tbMail2 = {Title = szTitle, Text = szMsg, tbAttach = self.tbCureItem[nSex2], To = pLover.dwID, nLogReazon = Env.LogWay_FathersDay}
    Mail:SendSystemMail(tbMail2)

    pPlayer.CenterMsg("Đã thành công báo danh, nhanh đi mới lạ tiểu viện dưỡng dục các ngươi cây đào đi")
    pLover.CenterMsg("Đã thành công báo danh, nhanh đi mới lạ tiểu viện dưỡng dục các ngươi cây đào đi")
    Log("FathersDay TryAgreeApply Success", pPlayer.dwID, pLover.dwID)
end

function tbAct:TryEnter()
    local pPlayer = me
    self:CheckPlayerData(pPlayer)
    local nLover = pPlayer.GetUserValue(self.GROUP, self.LOVER)
    if nLover == 0 then
        pPlayer.CenterMsg("Cần [FFFE0D] Sư đồ [-] Tạo thành [FFFE0D]2 Người [-] Đội ngũ tiến hành báo danh a")
        return
    end

    self:EnterMap(pPlayer, nLover)
end

function tbAct:EnterMap(pPlayer, nLover)
    local tbMapId = {self.tbMapList[pPlayer.dwID], self.tbMapList[nLover]}
    for _, nMapId in pairs(tbMapId or {}) do
        if nMapId then
            if GetMapInfoById(nMapId) then
                pPlayer.SetEntryPoint()
                pPlayer.SwitchMap(nMapId, 0, 0)
                pPlayer.nCanLeaveMapId = nMapId
                return
            elseif Fuben.tbApply[nMapId] then
                return
            end
        end
    end

    local nPlayer = pPlayer.dwID
    local fnSuccessCallback = function (nMapId)
        local pPlayer = KPlayer.GetPlayerObjById(nPlayer)
        if not pPlayer then
            return
        end
        pPlayer.SetEntryPoint()
        pPlayer.SwitchMap(nMapId, 0, 0)
        pPlayer.nCanLeaveMapId = nMapId
    end
    
    local fnFailedCallback = function ()
        self.tbMapList[nPlayer] = nil
        local pPlayer = KPlayer.GetPlayerObjById(nPlayer)
        if not pPlayer then
            return
        end
        pPlayer.CenterMsg("Tiến vào thất bại, mời thử lại")
    end
    Fuben:ApplyFuben(nPlayer, self.MAP_TID, fnSuccessCallback, fnFailedCallback)
    self.tbMapList[nPlayer] = Fuben.tbPlayerIdToMapId[nPlayer]
end

function tbAct:GetActivityData()
    local tbData = ScriptData:GetValue(self.szScriptDataKey)
    tbData.nRefreshIdx = tbData.nRefreshIdx or 0
    tbData.nRefreshTime = tbData.nRefreshTime or 0
    return tbData
end

function tbAct:CheckCanCure(pPlayer, nCure)
    if nCure <= 0 or nCure > self.nIllTypeCount then
        return false, "Không có loại bệnh này"
    end

    local nRefreshIdx = self:GetActivityData().nRefreshIdx
    if nRefreshIdx == 0 then
        return false, "Cây đào sinh trưởng tốt đẹp, tạm thời không cần trị liệu"
    end
    local nCurState = self:GetMyTreeState(pPlayer)
    if nCurState == 0 then
        return false, "Cây đào trước mắt trạng thái rất tốt, không cần trị liệu"
    end

    if pPlayer.GetUserValue(self.GROUP, self.CURE_IDX) ~= nRefreshIdx then
        pPlayer.SetUserValue(self.GROUP, self.CURE_IDX, nRefreshIdx)
        pPlayer.SetUserValue(self.GROUP, self.CURE_TIMES, 0)
    end
    if pPlayer.GetUserValue(self.GROUP, self.CURE_TIMES) >= self.MAX_CURE_TIMES then
        return false, "Không có trị liệu số lần"
    end

    local nActSex = pPlayer.GetUserValue(self.GROUP, self.SEX_INACT)
    local nItemTID = self.Cure_ItemTID[nActSex][nCure]
    if pPlayer.GetItemCountInAllPos(nItemTID) <= 0 then
        return false, "Khuyết thiếu trị liệu đạo cụ, không cách nào tiến hành trị liệu"
    end

    local tbMember = TeamMgr:GetMembers(pPlayer.dwTeamID)
    if #tbMember ~= 2 then
        return false, "Cần [FFFE0D] Hai người tổ đội [-] Lại [FFFE0D] Đồng đều ở vào trước mắt địa đồ [-] Mới có thể trị liệu"
    end

    local nPlayer = pPlayer.dwID
    local nLover = tbMember[1] == nPlayer and tbMember[2] or tbMember[1]
    if pPlayer.GetUserValue(self.GROUP, self.LOVER) ~= nLover then
        return false, "Hắn không phải ngươi ước định cẩn thận hiệp trợ đồng bạn"
    end

    local pLover = KPlayer.GetPlayerObjById(nLover)
    if not pLover then
        return false, "Hiệp trợ đồng bạn không tuyến bên trên"
    end

    local tbInfo = self.tbCureInfo[nPlayer] or self.tbCureInfo[nLover]
    if tbInfo then
        return false, "Đã nếm thử tiến hành trị liệu, mời trước xử lý xong lần này trị liệu"
    end

    local nMyMapId, nMX, nMY = me.GetWorldPos()
    local pMemberNpc = pLover.GetNpc()
    local nCurMapId, nHX, nHY = pMemberNpc.GetWorldPos()
    if nMyMapId ~= nCurMapId then
        return false, "Hiệp trợ đồng bạn cần tại phụ cận mới có thể tiến hành trị liệu"
    end 

    local fDists = Lib:GetDistsSquare(nHX, nHY, nMX, nMY)
    if fDists > (PunishTask.nMinDistance * PunishTask.nMinDistance) then
        return false, "Hiệp trợ đồng bạn cần tại phụ cận mới có thể tiến hành trị liệu"
    end    

    if pPlayer.ConsumeItemInAllPos(nItemTID, 1, Env.LogWay_FathersDay) < 1 then
        return false, "Đạo cụ tiêu hao thất bại, mời thử lại"
    end

    return true, "", pLover
end

function tbAct:GetFlowerState(pPlayer)
    local tbState = {}
    local nRefreshIdx = self:GetActivityData().nRefreshIdx
    if nRefreshIdx == 0 then
        return tbState, pPlayer.GetUserValue(self.GROUP, self.SEX_INACT)
    end

    local nState = self:GetMyTreeState(pPlayer)
    if nState%100 > 0 then
        table.insert(tbState, 1)
    end
    if math.floor(nState/100) > 0 then
        table.insert(tbState, 2)
    end
    return tbState, pPlayer.GetUserValue(self.GROUP, self.SEX_INACT)
end

function tbAct:GetMyTreeState(pPlayer)
    local nRefreshIdx = self:GetActivityData().nRefreshIdx
    local nSaveIdx = self.FLOWER_STATE_B + nRefreshIdx - 1
    return pPlayer.GetUserValue(self.GROUP, nSaveIdx), nSaveIdx
end

function tbAct:TryCure(pPlayer, nCure)
    local bRet, szMsg, pLover = self:CheckCanCure(pPlayer, nCure)
    if not bRet then
        pPlayer.CenterMsg(szMsg)
        return
    end

    local nCurState, nSaveIdx = self:GetMyTreeState(pPlayer)
    local bRight = (nCure == self.nIllTypeCount and nCurState >= 100) or (nCure == 1 and nCurState%100 > 0)
    if bRight then
        local nScore = pPlayer.GetUserValue(self.GROUP, self.SCORE)
        pPlayer.SetUserValue(self.GROUP, self.SCORE, nScore + 1)
        nScore = pLover.GetUserValue(self.GROUP, self.SCORE)
        pLover.SetUserValue(self.GROUP, self.SCORE, nScore + 1)

        local szMsg = "Thành công trị liệu suy yếu cây đào, nó nhẹ nhàng múa, tựa hồ tại cảm tạ trợ giúp của ngươi"
        pPlayer.CenterMsg(szMsg)
        Log("FathersDay TryCure Right", pPlayer.dwID, pLover.dwID, nScore, nCurState, nCure)
    else
        local szErr = "Tựa hồ chọn sai phương thức trị liệu, lần sau cần phải cẩn thận một chút xem xét trong lúc nói chuyện với nhau nhắc nhở a"
        pPlayer.CenterMsg(szErr)
    end
    local nCureTimes = pPlayer.GetUserValue(self.GROUP, self.CURE_TIMES) + 1
    pPlayer.SetUserValue(self.GROUP, self.CURE_TIMES, nCureTimes)

    local nSubState = 0
    if bRight then
        nSubState = nCure == 1 and 1 or 100
    else
        nSubState = nCure == 1 and 100 or 1
    end
    nCurState = nCurState - nSubState
    pPlayer.SetUserValue(self.GROUP, nSaveIdx, nCurState)
    if nCurState == 0 and pLover.GetUserValue(self.GROUP, nSaveIdx) == 0 then
        local szMsg   = "Chúc mừng hiệp sĩ thành công trị hết cây đào, võ Lint lấy hoa đào chế thành chúc phúc văn kiện đem tặng, hiệp sĩ có thể dùng để bày tỏ đạt đối sư phụ ý cảm tạ."
        local szTitle = "Một khi đào lý khắp thiên hạ"
        local tbMail  = {Title = szTitle, Text = szMsg, tbAttach = self.tbCureAward, To = pPlayer.dwID, nLogReazon = Env.LogWay_FathersDay}
        tbMail.To = (pPlayer.GetUserValue(self.GROUP, self.SEX_INACT) == 1) and pLover.dwID or pPlayer.dwID
        Mail:SendSystemMail(tbMail)
    end

    local nMapId       = pPlayer.nMapId
    local nCreateIdx   = MathRandom(#self.tbNpcInfo)
    local tbCreateInfo = self.tbNpcInfo[nCreateIdx]
    local tbCureInfo   = {nMapId = nMapId, nLover = pLover.dwID, nCreateIdx = nCreateIdx, tbCreateNpc = {}, tbGather = {}}
    for _, nNpdTID in ipairs(tbCreateInfo[1]) do
        local tbPosInfo = self.tbNpcPos[MathRandom(#self.tbNpcPos)]
        local pTempNpc = KNpc.Add(nNpdTID, 1, 0, nMapId, tbPosInfo[1], tbPosInfo[2], 0, 0)
        pTempNpc.nArborPlayer = pPlayer.dwID
        pTempNpc.nArborLover = pLover.dwID
        tbCureInfo.tbCreateNpc[pTempNpc.nId] = true
    end
    tbCureInfo.nCureTimer = Timer:Register(self.nCureTime * Env.GAME_FPS, self.OnCureTimeout, self, pPlayer.dwID)
    self.tbCureInfo[pPlayer.dwID] = tbCureInfo
    local szBlackMsg = self.tbBlackMsg[tbCreateInfo[3]]
    Dialog:SendBlackBoardMsg(pPlayer, szBlackMsg)
    Dialog:SendBlackBoardMsg(pLover, szBlackMsg)
    pPlayer.CallClientScript("Ui:CloseWindow", "GrowFlowersPanel")
    Log("FathersDay Begin Cure Flower", pPlayer.dwID, pLover.dwID, nCure, nCurState, tostring(bRight))
end

function tbAct:OnCureTimeout(nPlayer)
    local tbInfo = self.tbCureInfo[nPlayer]
    if not tbInfo then
        return
    end

    if not GetMapInfoById(tbInfo.nMapId) then
        self.tbCureInfo[nPlayer] = nil
        return
    end

    local bTimeout = false
    for nNpcId, _ in pairs(tbInfo.tbCreateNpc or {}) do
        local pNpc = KNpc.GetById(nNpcId)
        if pNpc then
            pNpc.Delete()
            bTimeout = true
        end
    end
    if bTimeout then
        for _, nId in ipairs({nPlayer, tbInfo.nLover}) do
            local pPlayer = KPlayer.GetPlayerObjById(nId)
            if pPlayer then
                pPlayer.CenterMsg("Bởi vì quá lâu chưa xử lý, đương lần trị liệu sự kiện đã kết thúc")
            end
        end
    end
    self.tbCureInfo[nPlayer] = nil
end

function tbAct:NpcEvent(pPlayer, szFunc, pNpc)
    local nPlayer = pPlayer.dwID
    local nLover = pPlayer.GetUserValue(self.GROUP, self.LOVER)
    local tbInfo = self.tbCureInfo[nPlayer] or self.tbCureInfo[nLover]
    if not tbInfo then
        return
    end

    tbInfo.tbCreateNpc[pNpc.nId] = nil
    local bComplete = not next(tbInfo.tbCreateNpc)
    local szErrMsg = self[szFunc](self, nPlayer, nLover, bComplete, tbInfo)
    if szErrMsg then
        tbInfo.tbCreateNpc[pNpc.nId] = true
        pPlayer.CenterMsg(szErrMsg)
        return
    else
        pNpc.Delete()
    end
    if not bComplete then
        return
    end

    Timer:Close(tbInfo.nCureTimer)
    local nSaveId = self.tbCureInfo[nPlayer] and nPlayer or nLover
    self.tbCureInfo[nSaveId] = nil
    Log("FathersDay CureSuccess", nPlayer, nLover, nSaveId, szFunc)
end

function tbAct:OnNpcDeath(nPlayer, nLover, bComplete, tbInfo)
    if not bComplete then
        return
    end

    self:SendCureAward(nPlayer, tbInfo.nCreateIdx)
    self:SendCureAward(nLover, tbInfo.nCreateIdx)
    Log("FathersDay OnNpcDeath", nPlayer, nLover)
end

function tbAct:OnBoxOpen(nPlayer, nLover, bComplete, tbInfo)
    self:SendCureAward(nPlayer, tbInfo.nCreateIdx)
    self:SendCureAward(nLover, tbInfo.nCreateIdx)
    Log("FathersDay OnBoxOpen", nPlayer, nLover)
end

function tbAct:OnGetGather(nPlayer, nLover, bComplete, tbInfo)
    local tbGather = tbInfo.tbGather
    if tbInfo.tbGather[nPlayer] then
        return "Mỗi người chỉ có thể mở ra một lần a"
    end
    tbInfo.tbGather[nPlayer] = true
    self:SendCureAward(nPlayer, tbInfo.nCreateIdx)
    Log("FathersDay OnGetGather", nPlayer, nLover, bComplete)
end

function tbAct:SendCureAward(nPlayer, nCreateIdx)
    local pPlayer = KPlayer.GetPlayerObjById(nPlayer)
    if not pPlayer then
        Log("FathersDay SendCureAward Player Not Online", nPlayer)
        return
    end
    local tbAward = self.tbNpcInfo[nCreateIdx][2]
    pPlayer.SendAward(tbAward, true, true, Env.LogWay_FathersDay)
end

function tbAct:OnEnterMap(pPlayer, nMapTID)
    if nMapTID ~= self.MAP_TID then
        return
    end

    -- local szDesc = self:GetRefreshDesc()
    self:RefreshPlayerDesc(pPlayer)
end

function tbAct:GetRefreshDesc()
    local nRefresh = string.match(self.tbTimerTrigger[1].Time, "(%d+):(%d+)")
    local nCurHour = Lib:GetLocalDayHour()
    for _, tbInfo in ipairs(self.tbTimerTrigger) do
        local _, szHour1 = string.match(tbInfo.Time, "(%d%d):(%d+)")
        if tonumber(szHour1) > nCurHour then
            nRefresh = nHour
            break
        end
    end
    local szDesc = string.format("Lần sau đổi mới thời gian: %d Điểm", nRefresh)
    return szDesc
end

function tbAct:RefreshPlayerDesc(pPlayer)
    pPlayer.CallClientScript("Activity.FathersDay:OnSyncState")
end