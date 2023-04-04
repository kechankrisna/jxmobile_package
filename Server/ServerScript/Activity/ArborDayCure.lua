local tbAct           = Activity:GetClass("ArborDayCure")
tbAct.tbTimerTrigger  =
{ 
    [1] = {szType = "Day", Time = "10:00", Trigger = "RefreshFlowerState"},
    [2] = {szType = "Day", Time = "16:00", Trigger = "RefreshFlowerState"},
}
tbAct.tbTrigger       = { Init = { }, Start = {{"StartTimerTrigger", 1}, {"StartTimerTrigger", 2}}, End = { }, RefreshFlowerState = {}}

tbAct.NEED_IMITITY_LV = 5 --亲密度等级
tbAct.NEED_PLAYER_LV  = 60 --玩家等级
tbAct.ENTRY_NPC_TID   = 2204 --入口Npc
tbAct.MAP_TID         = 1601 --地图
tbAct.MAX_CURE_TIMES  = 6
tbAct.Cure_ItemTID    = {{3945, 3944}, {3946, 3947}} --治疗对应的道具
tbAct.tbNpcPos        = { --npc坐标
{940, 1350},
{740, 1170},
{630, 820},
{800, 550},
{1160, 540},
{1340, 710},
{1480, 910},
{1730, 1120},
{850, 940},
{970, 710},
{1230, 900},
{1420, 1200},
}
tbAct.tbBlackMsg      = {
    "Nó tản mát ra một trận mùi thơm, lại đưa tới một đoàn ong độc, nhanh trấn an bọn chúng",
    "Nó có chút đong đưa, ngươi thuận nó đong đưa phương hướng nhìn lại, trong đất lại chôn dấu một cái rương",
    "Nó tản mát ra một trận nhàn nhạt bột phấn, chung quanh vậy mà mọc ra một chút thực vật",
}
tbAct.tbNpcInfo       = { --生成的Npc
    {{2200, 2200}, {{"Item", 3957, 1}}, 1}, --怪1
    {{2200, 2200}, {{"Item", 3957, 1}}, 1}, --怪2
    {{2202}, {{"Item", 3958, 1}}, 2}, --宝箱
    {{2201, 2201}, {{"Item", 3959, 1}}, 3}, --采集物
}
tbAct.tbCureItem      = {{{"Item", 3944, 99}, {"Item", 3945, 99}, {"Item", 3955, 1}, {"Item", 4619, 1}}, {{"Item", 3946, 99}, {"Item", 3947, 99},{"Item", 3955, 1}, {"Item", 4620, 1}}} --报名时的奖励
tbAct.nTitleItem      = 3955 --称号道具奖励
tbAct.nCureTime       = 3 * 60 --治疗的有效时间
--tbAct.szNotifyLink    = string.format("[url=npc:text, %d, %d]", tbAct.ENTRY_NPC_TID, 999)
tbAct.nRandomIllMin   = 4
tbAct.nRandomIllMax   = 8

tbAct.nTreeCount = 2                -- 有几棵树，提前随病的时候用到
-- 硬性规定自己家园的树的病为nIll % tbAct.nBaseRate的值
-- 对方家园的树为nIll / tbAct.nBaseRate的值
tbAct.MIN_DISTANCE = 1000
tbAct.nBaseRate = 10000

function tbAct:OnTrigger(szTrigger)
    if szTrigger == "Init" then
        ScriptData:SaveValue(self.szScriptDataKey, {})
    elseif szTrigger == "Start" then
       -- self.tbMapList = {}
        self.tbCureInfo = {}
        -- 所有已经创建树的家园地图id对应npcid
        self.tbAllMapNpc = {}
        -- 所有当前正在触发事件的家园地图id对应触发者玩家id
        self.tbEventMap = {}
        Activity:RegisterNpcDialog(self, self.ENTRY_NPC_TID, {Text = "Báo danh tham dự hoạt động", Callback = self.TryApply, Param = {self}})
        --Activity:RegisterNpcDialog(self, self.ENTRY_NPC_TID, {Text = "前往家园", Callback = self.TryEnter, Param = {self}})
        Activity:RegisterPlayerEvent(self, "Act_ArobrNpcEvent", "NpcEvent")
        Activity:RegisterPlayerEvent(self, "Act_OnPlayerLogin", "OnLogin")
        Activity:RegisterPlayerEvent(self, "Act_OnTryCure", "TryCure")
        --Activity:RegisterPlayerEvent(self, "Act_OnEnterMap", "OnEnterMap")
        Activity:RegisterPlayerEvent(self, "Act_UseArborItemNpc", "OnUseArborItemNpc")
        Activity:RegisterGlobalEvent(self, "Act_OnHouseMapEnter", "OnHouseMapEnter")
        Activity:RegisterGlobalEvent(self, "Act_OnHouseMapDestroy", "OnHouseMapDestroy")
        Activity:RegisterGlobalEvent(self, "Act_OnHouseMapLeave", "OnHouseMapLeave")
        Activity:RegisterGlobalEvent(self, "Act_OnTryGoHouse", "OnTryGoHouse")
        
        local tbNpc = Npc:GetClass("AroborFlower")
        tbNpc:OnChangeTitleActBegin(self.GetFlowerState, self)
        self.nIllTypeCount = #(self.tbIllType[1])

        local _, nEndTime = self:GetOpenTimeInfo()
        for _1, tbInfo1 in ipairs(self.tbCureItem) do
            for _2, tbInfo2 in ipairs(tbInfo1) do
                if Player.AwardType[tbInfo2[1]] == Player.award_type_item then
                    tbInfo2[4] = nEndTime
                    if tbInfo2[2] == self.nTitleItem then
                        tbInfo2[4] = nEndTime + 30*24*60*60
                    end
                end
            end
        end
        local _, nEndTime = self:GetOpenTimeInfo()
        -- 注册申请存库数据块,活动结束自动清掉
        self:RegisterDataInPlayer(nEndTime)
    elseif szTrigger == "RefreshFlowerState" then
        self:RefreshFlowerState()
    elseif szTrigger  == "End" then
        local tbNpc = Npc:GetClass("AroborFlower")
        tbNpc:OnChangeTitleActEnd()

        -- for _, nMapId in pairs(self.tbMapList) do
        --     if GetMapInfoById(nMapId) then
        --         local tbPlayer = KPlayer.GetMapPlayer(nMapId)
        --         for _, pPlayer in ipairs(tbPlayer or {}) do
        --             pPlayer.GotoEntryPoint()
        --             pPlayer.CallClientScript("Ui:CloseWindow", "HomeScreenFuben")
        --         end
        --     end
        -- end

        -- 遍历所有已经创建活动npc的家园地图
        -- for nMapId, _ in pairs(self.tbAllMapNpc) do
        --     if GetMapInfoById(nMapId) then
        --         local tbPlayer = KPlayer.GetMapPlayer(nMapId)
        --         for _, pPlayer in ipairs(tbPlayer or {}) do
        --             -- 由于家园不会用到HomeScreenFuben，强制关闭
        --             pPlayer.CallClientScript("Ui:CloseWindow", "HomeScreenFuben")
        --         end
        --     end
        -- end

        for _, tbInfo in pairs(self.tbCureInfo) do
            Timer:Close(tbInfo.nCureTimer)
        end
        self.tbCureInfo = {}
        ScriptData:SaveValue(self.szScriptDataKey, nil)

        for _, nNpcId in pairs(self.tbAllMapNpc) do
            local pNpc = KNpc.GetById(nNpcId)
            if pNpc then
                pNpc.Delete()
            end
        end
       -- self.tbMapList = {}
        self.tbEventMap = {}
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
        local tbTreeInfo = self:GetTreeInfo(pPlayer)
        local tbMyInfo = tbTreeInfo.tbMyInfo
        local tbLoverInfo = tbTreeInfo.tbLoverInfo

        if pPlayer.GetUserValue(self.GROUP, self.LOVER) > 0 and (tbMyInfo or tbLoverInfo)then
            self:SendNotify2Player(pPlayer)
        end
    end

    -- local szDesc = self:GetRefreshDesc()

    --[[    待解决, 状态更新及时通知在地图上的玩家
    for _, nMapId in pairs(self.tbMapList) do
        if GetMapInfoById(nMapId) then
            local tbPlayer = KPlayer.GetMapPlayer(nMapId)
            for _, pPlayer in ipairs(tbPlayer or {}) do
                self:RefreshPlayerDesc(pPlayer)
            end
        end
    end
    ]]

    -- 遍历所有已经创建活动npc的家园地图
    -- for nMapId, _ in pairs(self.tbAllMapNpc) do
    --     if GetMapInfoById(nMapId) then
    --         local tbPlayer = KPlayer.GetMapPlayer(nMapId)
    --         for _, pPlayer in ipairs(tbPlayer or {}) do
    --             local nMyHouseMapId = House:GetHouseMap(pPlayer.dwID);
    --             -- 如果玩家是这张家园地图的拥有者并且正在家园中
    --             if nMyHouseMapId and nMyHouseMapId == nMapId and pPlayer.nMapId == nMapId then
    --                 self:RefreshPlayerDesc(pPlayer)
    --             end

    --             local nLover = pPlayer.GetUserValue(self.GROUP, self.LOVER)
    --             local nLoverHouseMapId = House:GetHouseMap(nLover);
    --             -- 如果爱侣是这张家园地图的拥有者并且正在家园中
    --             if nLoverHouseMapId and nLoverHouseMapId == nMapId and pPlayer.nMapId == nMapId then
    --                 self:RefreshPlayerDesc(pPlayer)
    --             end
    --         end
    --     end
    -- end
    Log("ArborDayCure RefreshFlowerState", tbData.nRefreshTime, tbData.nRefreshIdx)
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

    local tbTreeInfo = self:GetTreeInfo(pPlayer)
    local tbMyInfo = tbTreeInfo.tbMyInfo
    local tbLoverInfo = tbTreeInfo.tbLoverInfo

    if tbMyInfo or tbLoverInfo then
        self:SendNotify2Player(pPlayer)
    end
    
end

function tbAct:SendNotify2Player(pPlayer)
    local tbNofityData = {
        szType = "ArborDayCureAct",
        nTimeOut = GetTime() + 60*10,
        --szLink = self.szNotifyLink,
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
        return false, "Cần [FFFE0D]60 Cấp [-] Mới có thể tham dự hoạt động"
    end

    if pPlayer.dwTeamID == 0 then
        return false, "Cần cùng một [FFFE0D] Khác phái nhân vật [-] Tạo thành [FFFE0D]2 Người [-] Đội ngũ a"
    end

    local tbMember = TeamMgr:GetMembers(pPlayer.dwTeamID)
    if #tbMember ~= 2 then
        return false, "Cần cùng một [FFFE0D] Khác phái nhân vật [-] Tạo thành [FFFE0D]2 Người [-] Đội ngũ a"
    end

    if not nApplyPlayer then
        local pTeamData = TeamMgr:GetTeamById(pPlayer.dwTeamID)
        if pTeamData.nCaptainID ~= pPlayer.dwID then
            return false, "Chỉ có đội trưởng mới có thể báo danh"
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
        return false, "Trước mắt đội ngũ thành viên đã cùng người khác cùng nhau trồng"
    end

    if pLover.nLevel < self.NEED_PLAYER_LV then
        return false, "Đồng đội cấp bậc chưa đủ [FFFE0D]60 Cấp [-], không cách nào tham gia hoạt động"
    end

    if pPlayer.nSex == pLover.nSex or not FriendShip:IsFriend(nPlayer, nLover) then
        return false, "Ngươi cùng đối phương cũng không phải là khác phái hảo hữu, xin xác nhận sau đang tiến hành nếm thử a"
    end

    if FriendShip:GetFriendImityLevel(nPlayer, nLover) < self.NEED_IMITITY_LV then
        return false, "Độ thân mật nhất định phải ≥5 Cấp mới có thể tham dự a"
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

    local szName
    if pPlayer.nHouseState ~= 1 then
        szName = pPlayer.szName
    elseif pLover.nHouseState ~= 1 then
        szName = pLover.szName
    end

    if szName then
        return false, "Cần trong đội ngũ hai tên thành viên đều có được gia viên mới có thể báo danh"
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
    local szMsg = string.format("%s Mời ngươi cùng nhau đi tới gia viên trồng bỉ dực hoa / Tình vợ chồng, một khi xác định, hoạt động trong lúc đó [FFFE0D] Không thể thay người [-], phải chăng xác định?", me.szName)
    pLover.MsgBox(szMsg, {{"Xác nhận", function () self:TryAgreeApply(nApplyPlayer) end, nApplyPlayer}, {"Hủy bỏ"}})
end

function tbAct:TryAgreeApply(nApplyPlayer)
    local pPlayer = me
    local bRet, szMsg, pLover = self:CheckCanApply(pPlayer, nApplyPlayer)
    if not bRet then
        pPlayer.CenterMsg(szMsg or "")
        return
    end

    local nSex1 = pPlayer.nSex;
    pPlayer.SetUserValue(self.GROUP, self.LOVER, pLover.dwID)
    pPlayer.SetUserValue(self.GROUP, self.SEX_INACT, nSex1)
    local nSex2 = pLover.nSex;
    pLover.SetUserValue(self.GROUP, self.LOVER, pPlayer.dwID)
    pLover.SetUserValue(self.GROUP, self.SEX_INACT, nSex2)
    for i = self.FLOWER_STATE_B, self.FLOWER_STATE_E do
        for nC = 1, self.nTreeCount do                                             -- 为几棵树随病
           local nIllData1, nIllData2 = 0, 0
           local nOldIllData1 = pPlayer.GetUserValue(self.GROUP, i)
           local nOldIllData2 = pLover.GetUserValue(self.GROUP, i)
           local nIllCount = MathRandom(self.nRandomIllMin, self.nRandomIllMax)
           local nBaseRate = math.pow(self.nBaseRate, nC - 1)                               -- 为了将几棵树的病都存在一个int值里，用几率做区分
           local fnSelect = Lib:GetRandomSelect(self.nIllTypeCount)                -- 优先不随重复的病
           local nAvgIll = math.floor(nIllCount / 2)                               -- 平均分病到两个玩家 
            for i = 1, nIllCount do
                local nIll = fnSelect()
                local nAdd = nIll == 1 and 1 or 100
                if i <= nAvgIll then
                    nIllData1 = nIllData1 + nAdd
                else
                    nIllData2 = nIllData2 + nAdd
                end
            end
            pPlayer.SetUserValue(self.GROUP, i, nIllData1 * nBaseRate + nOldIllData1)
            pLover.SetUserValue(self.GROUP, i, nIllData2 * nBaseRate + nOldIllData2)
        end
       
    end
    local szMsg   = "    Chúc mừng hiệp sĩ thành công báo danh tham gia hoạt động, đây là đưa tặng cho hiệp sĩ bảo dưỡng công cụ, hiện tại nhanh tiến về gia viên dưỡng dục các ngươi bỉ dực hoa / Tình vợ chồng đi!"
    local szTitle = "Gió xuân đào lý hoa nở nhật"
    local tbMail  = {Title = szTitle, Text = szMsg, tbAttach = self.tbCureItem[nSex1], To = pPlayer.dwID, nLogReazon = Env.LogWay_ArborDayCure}
    Mail:SendSystemMail(tbMail)


    local tbMail2 = {Title = szTitle, Text = szMsg, tbAttach = self.tbCureItem[nSex2], To = pLover.dwID, nLogReazon = Env.LogWay_ArborDayCure}
    Mail:SendSystemMail(tbMail2)

    pPlayer.CenterMsg("Đã thành công báo danh, nhanh đi gia viên dưỡng dục các ngươi bỉ dực hoa/Tình vợ chồng đi")
    pLover.CenterMsg("Đã thành công báo danh, nhanh đi gia viên dưỡng dục các ngươi bỉ dực hoa/Tình vợ chồng đi")
    Log("ArborDayCure TryAgreeApply Success", pPlayer.dwID, pLover.dwID)
end

-- function tbAct:TryEnter()
--     local pPlayer = me
--     self:CheckPlayerData(pPlayer)
--     local nLover = pPlayer.GetUserValue(self.GROUP, self.LOVER)
--     if nLover == 0 then
--         pPlayer.CenterMsg("需先与一名[FFFE0D]异性角色[-]组成[FFFE0D]2人[-]队伍进行报名哦")
--         return
--     end

--     self:EnterMap(pPlayer, nLover)
-- end

-- function tbAct:EnterMap(pPlayer, nLover)
--     local tbMapId = {self.tbMapList[pPlayer.dwID], self.tbMapList[nLover]}
--     for _, nMapId in pairs(tbMapId or {}) do
--         if nMapId then
--             if GetMapInfoById(nMapId) then
--                 pPlayer.SetEntryPoint()
--                 pPlayer.SwitchMap(nMapId, 0, 0)
--                 pPlayer.nCanLeaveMapId = nMapId
--                 return
--             elseif Fuben.tbApply[nMapId] then
--                 return
--             end
--         end
--     end

--     local nPlayer = pPlayer.dwID
--     local fnSuccessCallback = function (nMapId)
--         local pPlayer = KPlayer.GetPlayerObjById(nPlayer)
--         if not pPlayer then
--             return
--         end
--         pPlayer.SetEntryPoint()
--         pPlayer.SwitchMap(nMapId, 0, 0)
--         pPlayer.nCanLeaveMapId = nMapId
--     end
    
--     local fnFailedCallback = function ()
--         self.tbMapList[nPlayer] = nil
--         local pPlayer = KPlayer.GetPlayerObjById(nPlayer)
--         if not pPlayer then
--             return
--         end
--         pPlayer.CenterMsg("进入失败，请重试")
--     end
--     Fuben:ApplyFuben(nPlayer, self.MAP_TID, fnSuccessCallback, fnFailedCallback)
--     self.tbMapList[nPlayer] = Fuben.tbPlayerIdToMapId[nPlayer]
-- end

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
        return false, "Nó sinh trưởng tốt đẹp, tạm thời không cần trị liệu"
    end
    local nCurState = self:GetMyTreeState(pPlayer)
    if nCurState == 0 then
        return false, "Nó trước mắt trạng thái rất tốt, không cần trị liệu"
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

    if pPlayer.ConsumeItemInAllPos(nItemTID, 1, Env.LogWay_ArborDayCure) < 1 then
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
    if nState == 0 then
        return tbState, pPlayer.GetUserValue(self.GROUP, self.SEX_INACT)
    end

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
    local nState = 0
    local nIll = pPlayer.GetUserValue(self.GROUP, nSaveIdx)
    local bInMyHouse = self:IsOwnHouse(pPlayer)
    if bInMyHouse then
        nState = math.max(nState, math.floor(nIll % self.nBaseRate))
    else
        nState = math.max(nState, math.floor(nIll / self.nBaseRate)) 
    end
    return nState, nSaveIdx, nIll, bInMyHouse and 1 or self.nBaseRate
end

function tbAct:TryCure(pPlayer, nCure)
    local bRet, szMsg, pLover = self:CheckCanCure(pPlayer, nCure)
    if not bRet then
        pPlayer.CenterMsg(szMsg)
        return
    end

    local nCurState, nSaveIdx, nIll, nBaseRate = self:GetMyTreeState(pPlayer)
    if nCurState == 0 then
        pPlayer.CenterMsg("Nó sinh trưởng tốt đẹp, tạm thời không cần trị liệu")
        return 
    end
    local bRight = (nCure == self.nIllTypeCount and nCurState >= 100) or (nCure == 1 and nCurState%100 > 0)
    if bRight then
        local nScore = pPlayer.GetUserValue(self.GROUP, self.SCORE)
        pPlayer.SetUserValue(self.GROUP, self.SCORE, nScore + 1)
        nScore = pLover.GetUserValue(self.GROUP, self.SCORE)
        pLover.SetUserValue(self.GROUP, self.SCORE, nScore + 1)

        local nSubState = nCure == 1 and 1 or 100
        nIll = nIll - (nSubState * nBaseRate)
        -- nCurState = nCurState - nSubState
        --pPlayer.SetUserValue(self.GROUP, nSaveIdx, nCurState)
        pPlayer.SetUserValue(self.GROUP, nSaveIdx, nIll)
        local szMsg = "Chúc mừng hiệp sĩ thành công đối với nó tiến hành trị liệu, nó nhẹ nhàng múa, tựa hồ tại cảm tạ trợ giúp của ngươi."
        pPlayer.CenterMsg(szMsg)
        Log("ArborDayCure TryCure Right", pPlayer.dwID, pLover.dwID, nScore, nCurState, nCure, nIll)
    else
        local szErr = "Tựa hồ chọn sai phương thức trị liệu, lần sau cần phải cẩn thận một chút xem xét trong lúc nói chuyện với nhau nhắc nhở a"
        pPlayer.CenterMsg(szErr)
    end
    local nCureTimes = pPlayer.GetUserValue(self.GROUP, self.CURE_TIMES) + 1
    pPlayer.SetUserValue(self.GROUP, self.CURE_TIMES, nCureTimes)

    local nMapId       = pPlayer.nMapId
    local nCreateIdx
    local nActSex = pPlayer.GetUserValue(self.GROUP, self.SEX_INACT)
    local tbCreateIdx = self.tbIllType[nActSex] and self.tbIllType[nActSex][nCure] and self.tbIllType[nActSex][nCure][3]
    if tbCreateIdx and #tbCreateIdx > 0 then
        nCreateIdx   = tbCreateIdx[MathRandom(#tbCreateIdx)]
    end

    --local nCreateIdx   = MathRandom(#self.tbNpcInfo)
    
    local nMapId1, nX1, nY1 = pPlayer.GetWorldPos()
    local nMapId2, nX2, nY2 = pLover.GetWorldPos()
    local tbPos = {{nX1, nY1}, {nX2, nY2}}
    local fnSelect = Lib:GetRandomSelect(#tbPos)

    local tbCreateInfo = self.tbNpcInfo[nCreateIdx]
    if tbCreateInfo then
        local tbCureInfo   = {nMapId = nMapId, nLover = pLover.dwID, nCreateIdx = nCreateIdx, tbCreateNpc = {}, tbGather = {}}
        for _, nNpdTID in ipairs(tbCreateInfo[1]) do
            local tbPosInfo = tbPos[fnSelect()]
            local pTempNpc = KNpc.Add(nNpdTID, 1, 0, nMapId, tbPosInfo[1], tbPosInfo[2], 0, 0)
            pTempNpc.nArborPlayer = pPlayer.dwID
            pTempNpc.nArborLover = pLover.dwID
            tbCureInfo.tbCreateNpc[pTempNpc.nId] = true
        end
        tbCureInfo.nCureTimer = Timer:Register(self.nCureTime * Env.GAME_FPS, self.OnCureTimeout, self, pPlayer.dwID)
        self.tbCureInfo[pPlayer.dwID] = tbCureInfo
        self.tbEventMap[nMapId] = pPlayer.dwID
        local szBlackMsg = self.tbBlackMsg[tbCreateInfo[3]]
        Dialog:SendBlackBoardMsg(pPlayer, szBlackMsg)
        Dialog:SendBlackBoardMsg(pLover, szBlackMsg)
        local tbIllType = self:GetFlowerState(pPlayer)
        pPlayer.CallClientScript("Activity.ArborDayCureAct:OnCureOk", tbIllType)
    else
        Log("ArborDayCure Begin Cure Flower no event", pPlayer.dwID, pLover.dwID, nCure, nCurState, tostring(bRight), nCreateIdx, nActSex)
    end
    Log("ArborDayCure Begin Cure Flower", pPlayer.dwID, pLover.dwID, nCure, nCurState, tostring(bRight), nCreateIdx, nActSex)
end

function tbAct:OnCureTimeout(nPlayer, szMsg)
    local tbInfo = self.tbCureInfo[nPlayer]
    if not tbInfo then
        return
    end

    if not GetMapInfoById(tbInfo.nMapId) then
        self.tbEventMap[tbInfo.nMapId] = nil
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
                pPlayer.CenterMsg(szMsg or "Bởi vì quá lâu chưa xử lý, đương lần trị liệu sự kiện đã kết thúc",true)
            end
        end
    end
    local nResTime = Timer:GetRestTime(tbInfo.nCureTimer)
    if nResTime > 0 then
        Timer:Close(tbInfo.nCureTimer)
    end

    self.tbEventMap[tbInfo.nMapId] = nil
    self.tbCureInfo[nPlayer] = nil
    Log("ArborDayCure OnCureTimeout ", nPlayer, szMsg and "Hand" or "Timer")
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
    self.tbEventMap[tbInfo.nMapId] = nil
    self.tbCureInfo[nSaveId] = nil
    Log("ArborDayCure CureSuccess", nPlayer, nLover, nSaveId, szFunc)
end

function tbAct:OnNpcDeath(nPlayer, nLover, bComplete, tbInfo)
    if not bComplete then
        return
    end

    self:SendCureAward(nPlayer, tbInfo.nCreateIdx)
    self:SendCureAward(nLover, tbInfo.nCreateIdx)
    Log("ArborDayCure OnNpcDeath", nPlayer, nLover)
end

function tbAct:OnBoxOpen(nPlayer, nLover, bComplete, tbInfo)
    self:SendCureAward(nPlayer, tbInfo.nCreateIdx)
    self:SendCureAward(nLover, tbInfo.nCreateIdx)
    Log("ArborDayCure OnBoxOpen", nPlayer, nLover)
end

function tbAct:OnGetGather(nPlayer, nLover, bComplete, tbInfo)
    local tbGather = tbInfo.tbGather
    if tbInfo.tbGather[nPlayer] then
        return "Mỗi người chỉ có thể mở ra một lần a"
    end
    tbInfo.tbGather[nPlayer] = true
    self:SendCureAward(nPlayer, tbInfo.nCreateIdx)
    Log("ArborDayCure OnGetGather", nPlayer, nLover, bComplete)
end

function tbAct:SendCureAward(nPlayer, nCreateIdx)
    local pPlayer = KPlayer.GetPlayerObjById(nPlayer)
    if not pPlayer then
        Log("ArborDayCure SendCureAward Player Not Online", nPlayer)
        return
    end
    local tbAward = self.tbNpcInfo[nCreateIdx][2]
    pPlayer.SendAward(tbAward, true, true, Env.LogWay_ArborDayCure)
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
    local szDesc = string.format("Lần sau đổi mới thời gian:%d Điểm", nRefresh)
    return szDesc
end

function tbAct:RefreshPlayerDesc(pPlayer)
    pPlayer.CallClientScript("Activity.ArborDayCure:OnSyncState")
end

function tbAct:CheckUseArborItemNpc(pPlayer)
    local nLover = pPlayer.GetUserValue(self.GROUP, self.LOVER)
    if nLover <= 0 then
        return false, "Mời trước báo danh hoạt động"
    end

    local pLover = KPlayer.GetPlayerObjById(nLover)
    if not pLover then
        return false, "Cần cùng [FFFE0D] Bạn lữ của ngươi [-] Tạo thành [FFFE0D]2 Người [-] Đội ngũ a"
    end

    if pPlayer.dwTeamID == 0 then
        return false,"Cần cùng [FFFE0D] Bạn lữ của ngươi [-] Tạo thành [FFFE0D]2 Người [-] Đội ngũ a"
    end

    local tbMember = TeamMgr:GetMembers(pPlayer.dwTeamID)
    if #tbMember ~= 2 then
        return false,"Cần cùng [FFFE0D] Bạn lữ của ngươi [-] Tạo thành [FFFE0D]2 Người [-] Đội ngũ a"
    end

    for _, dwID in pairs(tbMember) do
        if dwID ~= pPlayer.dwID and dwID ~= pLover.dwID then
            return false, "Cần cùng [FFFE0D] Bạn lữ của ngươi [-] Tạo thành [FFFE0D]2 Người [-] Đội ngũ a"
        end
    end

    local nMapId1, nX1, nY1 = pPlayer.GetWorldPos()
    local nMapId2, nX2, nY2 = pLover.GetWorldPos()
    local fDists = Lib:GetDistsSquare(nX1, nY1, nX2, nY2)
    if fDists > (self.MIN_DISTANCE * self.MIN_DISTANCE) or nMapId1 ~= nMapId2 then
        return false, "Đồng đội không tại phụ cận"
    end

    if not self:IsOwnHouse(pLover) then
        return false, "Chỉ có thể chủng tại đối phương quê hương a"
    end

    if House:IsIndoor(pPlayer) then
        return false, "Chỉ có thể chủng tại bên ngoài a"
    end

    local tbTreeInfo = self:GetTreeInfo(pLover)
    if tbTreeInfo.tbMyInfo then
        return false, "Đã có nhân chủng"
    end

    return true, "", pLover
end

function tbAct:IsOwnHouse(pPlayer)
    return House:IsInNormalHouse(pPlayer) and House:IsInOwnHouse(pPlayer)
end

function tbAct:GetTreeInfo(pPlayer)
    local tbSaveData = self:GetDataFromPlayer(pPlayer.dwID) or {}
    tbSaveData.tbTreeInfo = tbSaveData.tbTreeInfo or {}
    return tbSaveData.tbTreeInfo
end

function tbAct:OnUseArborItemNpc(pPlayer, nItemTID, nNpcTID)
    if not nItemTID or not nNpcTID then
        return
    end
    local bRet, szMsg = self:CheckUseArborItemNpc(pPlayer)
    if not bRet then
        pPlayer.CenterMsg(szMsg, true)
        return
    end
    local fnMakeSure = function (dwID)
        local pSurer = KPlayer.GetPlayerObjById(dwID)
        if not pSurer then
            return
        end
        local bRet, szMsg, pLover = self:CheckUseArborItemNpc(pSurer)
        if not bRet then
            pSurer.CenterMsg(szMsg, true)
            return 
        end
        local nConsume = pSurer.ConsumeItemInAllPos(nItemTID, 1, Env.LogWay_ArborDayCure);
        if nConsume < 1 then
            pSurer.CenterMsg("Khấu trừ đạo cụ thất bại", true);
            return
        end
        local nMapId1, nX, nY = pSurer.GetWorldPos()

        local tbMySaveData = self:GetDataFromPlayer(pSurer.dwID) or {}
        tbMySaveData.tbTreeInfo = tbMySaveData.tbTreeInfo or {}
        local tbMyTreeInfo = tbMySaveData.tbTreeInfo

        -- 是不是第一个种树的
        tbMySaveData.bFirstPlant = tbMyTreeInfo.tbMyInfo 

        tbMyTreeInfo.tbLoverInfo = {}
        tbMyTreeInfo.tbLoverInfo.tbPos = {nX, nY}
        tbMyTreeInfo.tbLoverInfo.nNpcTID = nNpcTID
        self:SaveDataToPlayer(pSurer, tbMySaveData)

        local tbLoverSaveData = self:GetDataFromPlayer(pLover.dwID) or {}
        tbLoverSaveData.tbTreeInfo = tbLoverSaveData.tbTreeInfo or {}
        local tbLoverTreeInfo = tbLoverSaveData.tbTreeInfo

         -- 是不是第一个种树的
        tbLoverSaveData.bFirstPlant = not tbMyTreeInfo.tbMyInfo 

        tbLoverTreeInfo.tbMyInfo = {}
        tbLoverTreeInfo.tbMyInfo.tbPos = {nX, nY}
        tbLoverTreeInfo.tbMyInfo.nNpcTID = nNpcTID
        self:SaveDataToPlayer(pLover, tbLoverSaveData)

        self:CreateTreeNpc(pSurer, nNpcTID, nX, nY)
    end

    pPlayer.MsgBox("Nhất định phải chủng tại nơi này sao", {{"Xác định", fnMakeSure, pPlayer.dwID}, {"Hủy bỏ"}})
end

function tbAct:CreateTreeNpc(pPlayer, nNpcTID, nX, nY)
    local nLover = pPlayer.GetUserValue(self.GROUP, self.LOVER)
    local pTree = KNpc.Add(nNpcTID, 1, 0, pPlayer.nMapId, nX, nY, 0 ,0);
    if pTree then
        pTree.tbTmp = {pPlayer.dwID, nLover}
        self.tbAllMapNpc[pPlayer.nMapId] = pTree.nId
        Log("[ArborDayCure] fnCreateTreeNpc ok", pPlayer.dwID, pPlayer.szName, nNpcTID, nX, nY)
    else
        Log("[ArborDayCure] fnCreateTreeNpc fail", pPlayer.dwID, pPlayer.szName, nNpcTID, nX, nY)
    end
end

function tbAct:OnHouseMapEnter(pPlayer, nMapID)
   -- self:TryRefreshPlayerDesc(pPlayer, nMapID)
    local nNpcId = self.tbAllMapNpc[nMapID]
    if nNpcId and KNpc.GetById(nNpcId) then
         return
    end
    local nLover = pPlayer.GetUserValue(self.GROUP, self.LOVER)
    if nLover <= 0 then
        return
    end

    local tbTreeInfo = self:GetTreeInfo(pPlayer)
    local tbMyInfo = tbTreeInfo.tbMyInfo
    local tbLoverInfo = tbTreeInfo.tbLoverInfo

    -- 进入自己的家园
    if self:IsOwnHouse(pPlayer) and tbMyInfo then
        self:CreateTreeNpc(pPlayer, tbMyInfo.nNpcTID, unpack(tbMyInfo.tbPos))
    end

    -- 进入爱侣的家园
    local nHouseMapId = House:GetHouseMap(nLover);
    if nHouseMapId and nHouseMapId == nMapID and tbLoverInfo then
        self:CreateTreeNpc(pPlayer, tbLoverInfo.nNpcTID, unpack(tbLoverInfo.tbPos))
    end
end

-- function tbAct:TryRefreshPlayerDesc(pPlayer, nMapID)
--     local nLover = pPlayer.GetUserValue(self.GROUP, self.LOVER)
--     if nLover <= 0 then
--         return
--     end
--     local tbTreeInfo = self:GetTreeInfo(pPlayer)
--     local tbMyInfo = tbTreeInfo.tbMyInfo
--     local tbLoverInfo = tbTreeInfo.tbLoverInfo

--      -- 进入自己的家园并且已经种过树
--     if self:IsOwnHouse(pPlayer) and tbMyInfo then
--         self:RefreshPlayerDesc(pPlayer)
--     end

--     -- 进入爱侣的家园并且已经种过树
--     local nHouseMapId = House:GetHouseMap(nLover);
--     if nHouseMapId and nHouseMapId == nMapID and tbLoverInfo then
--         self:RefreshPlayerDesc(pPlayer)
--     end
-- end

function tbAct:OnHouseMapDestroy(nMapID)
    self.tbAllMapNpc[nMapID] = nil
end

function tbAct:CheckMeOrLoverHouse(pPlayer)
    if self:IsOwnHouse(pPlayer) then
        return true
    end
    local nLover = pPlayer.GetUserValue(self.GROUP, self.LOVER)
    if nLover > 0 then
       local nHouseMapId = House:GetHouseMap(nLover);
       if nHouseMapId and nHouseMapId == pPlayer.nMapId then
          return true
       end
    end
    return false
end

-- 两人都离开家园取消正在进行的事件
function tbAct:OnHouseMapLeave(pPlayer, nMapId)
    pPlayer.CallClientScript("Activity.ArborDayCure:OnLeaveHouseMap")
    local nLover = pPlayer.GetUserValue(self.GROUP, self.LOVER)
    local nSaveId = self.tbEventMap[nMapId]
    -- 是否有爱侣或者该地图是否正在触发事件
    if nLover <= 0 or not nSaveId then
        return
    end
    if not self:CheckMeOrLoverHouse(pPlayer) then
        return
    end
    local pLover = KPlayer.GetPlayerObjById(nLover)
    if not pLover or pLover.nMapId ~= nMapId then
        self:OnCureTimeout(nSaveId, "Bởi vì song phương đều rời đi địa đồ đương lần trị liệu sự kiện đã kết thúc")
    end
end

function tbAct:OnTryGoHouse(pPlayer)
    local nLover = pPlayer.GetUserValue(self.GROUP, self.LOVER)
    if nLover <= 0 then
        pPlayer.CenterMsg("Mời trước báo danh!")
        return 
    end
    local tbSaveData = self:GetDataFromPlayer(pPlayer.dwID) or {}
    local nHouseOwnerId = tbSaveData.bFirstPlant and pPlayer.dwID or nLover
    local tbTreeInfo = self:GetTreeInfo(pPlayer)
    local tbInfo = tbSaveData.bFirstPlant and tbTreeInfo.tbMyInfo or tbTreeInfo.tbLoverInfo
    local tbPos = tbInfo and tbInfo.tbPos
    
    House:EnterHouse(pPlayer, nHouseOwnerId, tbPos, function (pPlayer, nMapId, nX, nY)
        pPlayer.CallClientScript("AutoPath:GotoAndCall", nMapId, nX, nY);
    end);
end
