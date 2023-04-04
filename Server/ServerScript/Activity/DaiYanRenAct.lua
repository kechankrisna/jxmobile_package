local tbAct          = Activity:GetClass("DaiYanRenAct")
tbAct.tbTimerTrigger = {}
tbAct.tbTrigger      = { 
    Init    = { }, 
    Start   = { }, 
    End     = { }, 
    SendNews= { };
}
tbAct.LEVEL = 40
tbAct.IMITITY_LV = 5

tbAct.GROUP   = 73
tbAct.VERSION = 1
tbAct.LOVER   = 2

tbAct.tbNpcTask = {
    [2326] = {nTaskId = 6023, nMapTID = 1618},
    [89]   = {nTaskId = 6027, nMapTID = 1619},
    [99]   = {nTaskId = 6030, nMapTID = 1620},
    [625]  = {nTaskId = 6033, nMapTID = 1621},
    [2279] = {nTaskId = 6036, nMapTID = 1623},
}
tbAct.START_TASK = 6020

function tbAct:OnTrigger(szTrigger)
    local fn = self["On" .. szTrigger]
    if not fn then
        return
    end

    fn(self)
end

function tbAct:OnStart()
    self.tbMap4Task = {}
    for nNpcTID, tbInfo in pairs(self.tbNpcTask) do
        local nTaskId = tbInfo.nTaskId
        local nMapTID = tbInfo.nMapTID
        self.tbMap4Task[nMapTID] = nTaskId
        Activity:RegisterNpcDialog(self, nNpcTID, {Text = "Tiến về manh mối chỉ hướng chi địa", Callback = self.TryEnterFuben, Param = {self, nTaskId, nMapTID}})
    end
    Activity:RegisterNpcDialog(self, 99, {Text = "Báo danh tham gia ý hợp tâm đầu hoạt động", Callback = self.TryApply, Param = {self}})
    Activity:RegisterPlayerEvent(self, "DYRAct_TryAgreeApply", "TryAgreeApply")
    Activity:RegisterPlayerEvent(self, "DYRAct_TryAgreeEnterFuben", "TryAgreeEnterFuben")
    Activity:RegisterPlayerEvent(self, "Act_OnAcceptTask", "OnAcceptTask")
    Activity:RegisterGlobalEvent(self, "DYRAct_TryCompleteFuben", "OnFubenSuccess")
end

function tbAct:OnEnd()
    local tbPlayerList = KPlayer.GetAllPlayer()
    for _, pPlayer in ipairs(tbPlayerList) do
        Task:CheckTaskValidTime(pPlayer)
    end
end

function tbAct:OnAcceptTask(pPlayer, nTaskId)
    --第一次开活动时参数还没填，所以这里做个保护
    local nBeginTask = tonumber(self.tbParam[1]) or 6020
    local nEndTask = tonumber(self.tbParam[2]) or 6037
    if not nTaskId or nTaskId < nBeginTask or nTaskId > nEndTask then
        return
    end
    local _, nEndTime = self:GetOpenTimeInfo()
    Task:SetValidTime2Task(pPlayer, nTaskId, nEndTime)
end

function tbAct:CheckTeam(pPlayer)
    if not pPlayer.dwTeamID or pPlayer.dwTeamID == 0 then
        return false, "Ngươi còn không có đội ngũ"
    end

    local tbMember = TeamMgr:GetMembers(pPlayer.dwTeamID)
    if #tbMember ~= 2 then
        return false, "Nhất định phải cùng [FFFE0D] Báo danh lúc khác phái hảo hữu kết thành 2 Người tổ đội [-]"
    end

    local dwMember = tbMember[1] == pPlayer.dwID and tbMember[2] or tbMember[1]
    local pMember = KPlayer.GetPlayerObjById(dwMember)
    if not pMember then
        return false, "Không tìm được đồng đội"
    end

    if pPlayer.nSex == pMember.nSex or not FriendShip:IsFriend(pPlayer.dwID, dwMember) then
        return false, "Ngươi cùng đối phương cũng không phải là khác phái hảo hữu, xin xác nhận sau đang tiến hành nếm thử a"
    end

    if FriendShip:GetFriendImityLevel(pPlayer.dwID, pMember.dwID) < self.IMITITY_LV then
        return false, string.format("Song phương độ thân mật đẳng cấp cần đạt tới %d Cấp", self.IMITITY_LV)
    end

    local nMapId1 = pPlayer.GetWorldPos()
    local nMapId2 = pMember.GetWorldPos()
    if nMapId1 ~= nMapId2 or pPlayer.GetNpc().GetDistance(pMember.GetNpc().nId) > Npc.DIALOG_DISTANCE * 3 then
        return false, "Khoảng cách quá xa, cùng đội ngũ của ngươi thành viên nhất định phải tại trong phạm vi nhất định a"
    end

    return true, nil, pMember
end

function tbAct:CheckApply(pPlayer)
    if pPlayer.nLevel < self.LEVEL then
        return false, "Ngươi đẳng cấp không đủ"
    end
    self:CheckPlayerData(pPlayer)
    if pPlayer.GetUserValue(self.GROUP, self.LOVER) > 0 then
        return false, "Ngươi đã báo danh"
    end

    local bRet, szMsg, pTeammate = self:CheckTeam(pPlayer)
    if not bRet then
        return false, szMsg
    end

    if pTeammate.nLevel < self.LEVEL then
        return false, "Đồng đội cấp bậc chưa đủ"
    end
    self:CheckPlayerData(pTeammate)
    if pTeammate.GetUserValue(self.GROUP, self.LOVER) > 0 then
        return false, "Đồng đội đã cùng người khác báo danh"
    end
    return true, nil, pTeammate
end

function tbAct:CheckPlayerData(pPlayer)
    local nGroup     = self.GROUP
    local nVersion   = self.VERSION
    local nStartTime = self:GetOpenTimeInfo()
    if pPlayer.GetUserValue(nGroup, nVersion) == nStartTime then
        return
    end

    pPlayer.SetUserValue(nGroup, nVersion, nStartTime)
    pPlayer.SetUserValue(nGroup, self.LOVER, 0)
end

function tbAct:TryApply()
    local pPlayer = me
    local bRet, szMsg, pTeammate = self:CheckApply(pPlayer)
    if not bRet then
        pPlayer.CenterMsg(szMsg or "")
        return
    end

    pTeammate.CallClientScript("Activity.DaiYanRen:OnGetInvite", "DYRAct_TryAgreeApply", pPlayer.dwID, pPlayer.szName)
end

function tbAct:TryAgreeApply(pPlayer, dwApply, bAgree)
    if not bAgree then
        local pTeammate = KPlayer.GetPlayerObjById(dwApply)
        if pTeammate then
            pTeammate.CenterMsg("Đối phương cự tuyệt lời mời của ngươi")
        end
        return
    end

    local bRet, szMsg, pTeammate = self:CheckApply(pPlayer)
    if not bRet then
        pPlayer.CenterMsg(szMsg or "")
        return
    end

    if pTeammate.dwID ~= dwApply then
        pPlayer.CenterMsg("Mời đã qua kỳ")
        return
    end

    pPlayer.SetUserValue(self.GROUP, self.LOVER, dwApply)
    pTeammate.SetUserValue(self.GROUP, self.LOVER, pPlayer.dwID)

    Task:ForceAcceptTask(pPlayer, self.START_TASK)
    Task:ForceAcceptTask(pTeammate, self.START_TASK)
    pPlayer.CallClientScript("Activity:CheckRedPoint")
    pTeammate.CallClientScript("Activity:CheckRedPoint")
    local szMsg = "Đã thành công báo danh tham gia hoạt động, xin đem [FFFE0D] Bên trái nút bấm [-] Hoán đổi đến [FFFE0D] Nhiệm vụ [-] Bắt đầu tiến hành hoạt động"
    pPlayer.CenterMsg(szMsg)
    pTeammate.CenterMsg(szMsg)
    Log("DaiYanRenAct MakeTeam:", pPlayer.dwID, pTeammate.dwID)
end

local function fnAllMember(tbMember, fnSc, ...)
    for _, nPlayerId in ipairs(tbMember or {}) do
        local pMember = KPlayer.GetPlayerObjById(nPlayerId)
        if pMember then
            fnSc(pMember, ...);
        end
    end
end

function tbAct:CheckFuben(pPlayer, nTaskId)
    self:CheckPlayerData(pPlayer)
    if pPlayer.GetUserValue(self.GROUP, self.LOVER) == 0 then
        return false, "Trong đội ngũ có người chưa báo danh"
    end

    local bRet, szMsg, pTeammate = self:CheckTeam(pPlayer)
    if not bRet then
        return bRet, szMsg
    end

    for _, pCheck in ipairs({pPlayer, pTeammate}) do
        local nState = Task:GetTaskState(pCheck, nTaskId)
        if nState ~= Task.STATE_ON_DING then
            return false, "Nhất định phải hai người đồng đều tiến hành đến nhiệm vụ cùng một trình tự mới có thể tiếp tục tiến hành"
        end
    end

    self:CheckPlayerData(pTeammate)
    if pTeammate.GetUserValue(self.GROUP, self.LOVER) == 0 then
        return false, "Đồng đội chưa báo danh"
    end

    if pPlayer.GetUserValue(self.GROUP, self.LOVER) ~= pTeammate.dwID or 
        pTeammate.GetUserValue(self.GROUP, self.LOVER) ~= pPlayer.dwID then
        return false, "Đội ngũ thành viên cũng không phải là cùng ngươi cùng nhau báo danh khác phái hảo hữu"
    end

    for _, pCheck in ipairs({pPlayer, pTeammate}) do
        if not Env:CheckSystemSwitch(pCheck, Env.SW_SwitchMap) then
            return false, "Trước mắt trạng thái không cho phép hoán đổi địa đồ"
        end

        if not Fuben.tbSafeMap[pCheck.nMapTemplateId] and Map:GetClassDesc(pCheck.nMapTemplateId) ~= "fight" then
            return false, "Sở tại địa đồ không cho phép tiến vào phó bản!";
        end

        if Map:GetClassDesc(pCheck.nMapTemplateId) == "fight" and pCheck.nFightMode ~= 0 then
            return false, "Không phải khu vực an toàn không cho phép tiến vào phó bản!";
        end
    end
    return true, nil, pTeammate
end

function tbAct:TryEnterFuben(nTaskId, nMapTID)
    local pPlayer = me
    if not nTaskId then
        return
    end

    local bRet, szMsg, pTeammate = self:CheckFuben(pPlayer, nTaskId)
    if not bRet then
        pPlayer.CenterMsg(szMsg)
        return
    end

    pTeammate.CallClientScript("Activity.DaiYanRen:OnGetInvite", "DYRAct_TryAgreeEnterFuben", pPlayer.dwID, pPlayer.szName, nTaskId, nMapTID)
end

function tbAct:TryAgreeEnterFuben(pPlayer, dwApply, bAgree, tbParam)
    if not bAgree then
        local pTeammate = KPlayer.GetPlayerObjById(dwApply)
        if pTeammate then
            pTeammate.CenterMsg("Đối phương cự tuyệt lời mời của ngươi")
        end
        return
    end

    local nTaskId, nMapTID = unpack(tbParam)
    local bRet, szMsg, pTeammate = self:CheckFuben(pPlayer, nTaskId)
    if not bRet then
        pPlayer.CenterMsg(szMsg)
        return
    end

    if pTeammate.dwID ~= dwApply then
        pPlayer.CenterMsg("Mời đã qua kỳ")
        return
    end


    local nP1ID, nP2ID = pPlayer.dwID, pTeammate.dwID
    local tbMember = {nP1ID, nP2ID}
    local function fnSuccessCallback(nMapId)
        local function fnSucess(pPlayer, nMapId)
            pPlayer.SetEntryPoint()
            pPlayer.SwitchMap(nMapId, 0, 0)
        end
        fnAllMember(tbMember, fnSucess, nMapId)
    end

    local function fnFailedCallback()
        fnAllMember(tbMember, function (pPlayer)
            pPlayer.CenterMsg("Sáng tạo phó bản thất bại, xin sau nếm thử!")
        end)
    end

    Fuben:ApplyFuben(nP1ID, nMapTID, fnSuccessCallback, fnFailedCallback, nP1ID, nP2ID, nMapTID)
end

function tbAct:OnFubenSuccess(tbPlayer, nMapTID)
    local dwPlayer1, dwPlayer2 = unpack(tbPlayer or {})
    if not dwPlayer1 or not dwPlayer2 then
        return
    end

    local pPlayer1 = KPlayer.GetPlayerObjById(dwPlayer1)
    local pPlayer2 = KPlayer.GetPlayerObjById(dwPlayer2)
    if not pPlayer1 or not pPlayer2 then
        return
    end

    Task:OnTaskExtInfo(pPlayer1, Task.ExtInfo_DaiYanRenAct)
    Task:OnTaskExtInfo(pPlayer2, Task.ExtInfo_DaiYanRenAct)
    Log("DaiYanRenAct CompleteFuben:", dwPlayer1, dwPlayer2, nMapTID)
end