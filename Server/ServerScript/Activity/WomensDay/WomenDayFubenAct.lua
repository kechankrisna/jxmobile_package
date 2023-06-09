local tbAct = Activity:GetClass("WomenDayFubenAct")
tbAct.tbTrigger = { 
    Init    = {}, 
    Start   = {}, 
    End     = {}, 
}

tbAct.nItemId = 7496    --npc给的任务道具id
tbAct.nFubenTime = 10*60    --副本持续时长，用于设置道具超时
tbAct.nFubenMapTID = 7003
tbAct.nJoinLevel = 20   --最小参与等级
tbAct.nJiguanNpcId = 2882 --使用道具生成机关npc id
tbAct.nJiguanNpcLock = 28  --机关npc死亡解锁s
tbAct.szJiguanNpcGroup = "jiguan" --机关npc组
tbAct.tbRewards = {    --闯关成功奖励，女，男
    {"OpenLevel39", {   --大于等于此时间轴
            {"BasicExp", 120},
            {"Coin", 10000},
            {"Contrib", 1500},
        },
    },
    {"OpenLevel89", {
            {"BasicExp", 120},
            {"Item", 7281, 5},
            {"Coin", 10000},
        },
    }
}
tbAct.szFreezeTrapName = "TrapLock3" --定住女玩家的trap点名字
tbAct.tbFreezeTrapBuffs = {{4704, 1, 6}, {3766, 1, 6}} --触发定住女玩家trap点给玩家加的buff，女，男;{buffid, level, seconds}
tbAct.nFreezeUnlock = 24   --触发定住女玩家trap点解锁的锁id
tbAct.nBossId = 2883 --最后一关boss id
tbAct.nMaxSkillDist = 2000 --最后一关机关使用最大距离
tbAct.nRewardTitleDays = 3  --得奖几天可获得称号道具
tbAct.tbRewardTitleItems = {7501, 7500}  --称号道具id  {女, 男}

function tbAct:OnTrigger(szTrigger)
    if szTrigger == "Start" then
        Activity:RegisterGlobalEvent(self, "Act_CompleteWomenDayFuben", "OnFubenComplete")
        Activity:RegisterGlobalEvent(self, "Act_LeaveWomenDayFuben", "OnLeaveFuben")

        Activity:RegisterPlayerEvent(self, "Act_UseWomensDayItem", "OnUseWomensDayItem")

        self:RegisterNpcDialog()
        local _, nEndTime = self:GetOpenTimeInfo()
        self:RegisterDataInPlayer(nEndTime)
    end
end

function tbAct:OnUseWomensDayItem(pPlayer)
    local tbFubenInst = Fuben:GetFubenInstance(pPlayer)
    if tbFubenInst and tbFubenInst.OnUseWomensDayItem then
        tbFubenInst:OnUseWomensDayItem(pPlayer)
    end
end

function tbAct:RegisterNpcDialog()
   	Activity:RegisterNpcDialog(self, 633, {
   		Text = "Tham gia nữ hiệp tiết hoạt động",
   		Callback = self.TryEnterFuben,
   		Param = {self},
   	})
end

local function fnAllMember(tbMember, fnSc, ...)
    for _, nPlayerId in pairs(tbMember or {}) do
        local pMember = KPlayer.GetPlayerObjById(nPlayerId);
        if pMember then
            fnSc(pMember, ...);
        end
    end
end

function tbAct:TryEnterFuben()
    local tbTeam = TeamMgr:GetTeamById(me.dwTeamID)
    if not tbTeam then
        Npc:ShowErrDlg(me, him, "Mời cùng một vị khác phái người chơi tổ đội đến đây tham gia")
        return
    end

    local tbMembers = tbTeam:GetMembers()
    if Lib:CountTB(tbMembers)~=2 then
        Npc:ShowErrDlg(me, him, "Đội ngũ nhất định phải vì hai người")
        return
    end

    local bOk, szErr = Npc:IsTeammateNearby(me, him, true)
    if not bOk then
        Npc:ShowErrDlg(me, him, szErr)
        return
    end

    if me.nSex ~= Gift.Sex.Girl then
        Npc:ShowErrDlg(me, him, "Đội trưởng nhất định phải là nữ tính")
        return
    end

    local nMyId = me.dwID
    local nOtherId = nil
    for _, nPlayerId in pairs(tbMembers) do
        if nPlayerId~=nMyId then
            nOtherId = nPlayerId
            break
        end
    end
    local pOther = KPlayer.GetPlayerObjById(nOtherId or 0)
    if not pOther then
        Npc:ShowErrDlg(me, him, "Đồng đội không tuyến bên trên")
        return
    end
    if pOther.nSex~=Gift.Sex.Boy then
        Npc:ShowErrDlg(me, him, "Đồng đội không phải nam tính")
        return
    end

    if me.nLevel<self.nJoinLevel or pOther.nLevel<self.nJoinLevel then
        Npc:ShowErrDlg(me, him, string.format("%d Cấp trở lên người chơi mới có thể tham dự", self.nJoinLevel))
        return
    end

    if self:HasGainRewardToday(nMyId) and self:HasGainRewardToday(nOtherId) then
        Npc:ShowErrDlg(me, him, "Các ngươi hôm nay đã đều đã tham gia")
        return
    end

    local function fnSuccessCallback(nMapId)
        local function fnSucess(pPlayer, nMapId)
            if pPlayer.dwID==nMyId then
                pPlayer.SendAward({{"Item", self.nItemId, 1, GetTime()+self.nFubenTime}}, false, true, Env.LogWay_WomensDay)
            end

            pPlayer.SetEntryPoint()
            pPlayer.SwitchMap(nMapId, 0, 0)
            pPlayer.SetTempRevivePos(nMapId, 0, 0)
        end
        fnAllMember(tbMembers, fnSucess, nMapId)
    end

    local function fnFailedCallback()
        local function fnMsg(pPlayer, szMsg)
            pPlayer.CenterMsg(szMsg)
        end
        fnAllMember(tbMembers, fnMsg, "Sáng tạo phó bản thất bại, xin sau nếm thử!")
    end

    me.MsgBox("Phải chăng xác nhận nhận lấy nhiệm vụ đạo cụ đồng tiến nhập phó bản?", {{"Xác nhận", function()
        Fuben:ApplyFuben(nMyId, self.nFubenMapTID, fnSuccessCallback, fnFailedCallback, nMyId, nOtherId)
        Log("WomenDayFubenAct:TryEnterFuben", nMyId, nOtherId)
    end}, {"Hủy bỏ"}})
end

function tbAct:HasGainRewardToday(nPlayerId)
    local tbData = self:GetDataFromPlayer(nPlayerId) or {}
    return not Lib:IsDiffDay(4*3600, GetTime(), tbData["nLastGainRewardTime"] or 0)
end

function tbAct:GetRewardDays(nPlayerId)
    local tbData = self:GetDataFromPlayer(nPlayerId) or {}
    return tbData.nRewardDays or 0
end

function tbAct:SetHasGainRewardToday(pPlayer)
    local nPlayerId = pPlayer.dwID
    local tbData = self:GetDataFromPlayer(nPlayerId) or {}
    tbData["nLastGainRewardTime"] = GetTime()
    tbData["nRewardDays"] = (tbData["nRewardDays"] or 0)+1
    self:SaveDataToPlayer(pPlayer, tbData)
end

function tbAct:GetTimeframeRewards()
    local tbRet = nil
    for _, tb in ipairs(self.tbRewards) do
        local szTimeframe, tbReward = unpack(tb)
        if GetTimeFrameState(szTimeframe)~=1 then
            break
        end
        tbRet = tbReward
    end
    return tbRet
end

function tbAct:OnFubenComplete(nGirlId, nBoyId)
    if not nGirlId or not nBoyId then
        return
    end

    local tbRewards = self:GetTimeframeRewards()
    if not next(tbRewards or {}) then
        Log("[x] WomenDayFubenAct:OnFubenComplete, rewards nil", nGirlId, nBoyId)
        return
    end

    if not self:HasGainRewardToday(nGirlId) then
        local pPlayer = KPlayer.GetPlayerObjById(nGirlId)
        if pPlayer then
            self:SetHasGainRewardToday(pPlayer)
            pPlayer.SendAward(tbRewards, true, true, Env.LogWay_WomensDay)
            Log("WomenDayFubenAct:OnFubenComplete, reward girl", nGirlId)

            self:CheckRewardTitle(pPlayer, true)
        end
    end
    if not self:HasGainRewardToday(nBoyId) then
        local pPlayer = KPlayer.GetPlayerObjById(nBoyId)
        if pPlayer then
            self:SetHasGainRewardToday(pPlayer)
            pPlayer.SendAward(tbRewards, true, true, Env.LogWay_WomensDay)
            Log("WomenDayFubenAct:OnFubenComplete, reward boy", nBoyId)

            self:CheckRewardTitle(pPlayer, false)
        end
    end
    Log("WomenDayFubenAct:OnFubenComplete", nGirlId, nBoyId)
end

function tbAct:CheckRewardTitle(pPlayer, bGirl)
    local nRewardDays = self:GetRewardDays(pPlayer.dwID)
    if nRewardDays~=self.nRewardTitleDays then
        return
    end

    local nItemId = bGirl and self.tbRewardTitleItems[1] or self.tbRewardTitleItems[2]
    Mail:SendSystemMail({
        To = pPlayer.dwID,
        Title = "Nữ hiệp tiết hoạt động",
        Text = "Tôn kính hiệp sĩ! Chúc mừng ngài liên tục ba ngày tham gia nữ hiệp tiết hoa lá hai tướng cùng hoạt động, đây là ngài ban thưởng! Chúc đại hiệp cùng mình khác phái tri kỷ quan hệ thêm gần một bước!",
        tbAttach = {{"Item", nItemId, 1}},
        nLogReazon = Env.LogWay_WomensDay,
    })
    Log("WomenDayFubenAct:CheckRewardTitle", pPlayer.dwID, bGirl, nItemId)
end

function tbAct:OnLeaveFuben(nPlayerId)
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId or 0)
    if not pPlayer then
        return
    end

    local nCount = pPlayer.GetItemCountInBags(self.nItemId)
    if nCount<=0 then
        return
    end
    pPlayer.ConsumeItemInBag(self.nItemId, nCount, Env.LogWay_WomensDay)
end
