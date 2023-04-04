Fuben.KeyQuestFuben = Fuben.KeyQuestFuben or {};
local KeyQuestFuben = Fuben.KeyQuestFuben;
local DEFINE = KeyQuestFuben.DEFINE

local tbWhiteFunc = {
    PlayerSignUp = 1;
    RequestReadyMapTime = 1;
}
function KeyQuestFuben:OnClientCall(pPlayer, szFunc, ...)
    if tbWhiteFunc[szFunc] then
        self[szFunc](self, pPlayer,...)
    end
end

function KeyQuestFuben:StopSignUpS()
    self.nReadyMapId = nil
    Calendar:OnActivityEnd(DEFINE.CALENDAR_KEY)
end

function KeyQuestFuben:OnReadyMapCreateS( nReadyMapId, nReadyLeftTime )
    if GetTimeFrameState(DEFINE.TIME_FRAME) ~= 1 then
        Log("KeyQuestFuben:OnReadyMapCreateS TimeFrameNot Open", nReadyMapId)
        return
    end
    self.nReadyMapId = nReadyMapId
    self.nReadyMapEndTime = GetTime() + nReadyLeftTime
    KPlayer.SendWorldNotify(DEFINE.MIN_LEVEL, 999, DEFINE.MSG_NOTIFY_SIGNUP, 1, 1)
    local tbMsgData = {
        szType = "StartKeyQuestFuben";
        nTimeOut = GetTime() + DEFINE.SIGNUP_TIME;
    };

    KPlayer.BoardcastScript(DEFINE.MIN_LEVEL, "Ui:SynNotifyMsg", tbMsgData);
    Calendar:OnActivityBegin(DEFINE.CALENDAR_KEY)
    if DEFINE.SupplementAwardKey then
        SupplementAward:OnActivityOpen(DEFINE.SupplementAwardKey)
    end 
    Timer:Register(Env.GAME_FPS * DEFINE.SIGNUP_TIME, function ()
        self:StopSignUpS()
    end);
end

function KeyQuestFuben:RequestReadyMapTime( pPlayer )
    if not self.nReadyMapEndTime then
        return
    end
    local nLeftTime = self.nReadyMapEndTime - GetTime()
    if nLeftTime <= 0 then
        return
    end
    pPlayer.CallClientScript("Player:ServerSyncData", "KeyQuestFubenlReadyMapTime", nLeftTime);
end


function KeyQuestFuben:PlayerSignUp(pPlayer)
    if not self.nReadyMapId then
        pPlayer.CenterMsg(string.format("%s活動尚未開始！" , DEFINE.NAME))
        return
    end

    local tbPlayers = {};
    local dwTeamID = pPlayer.dwTeamID
    if dwTeamID ~= 0 then
        local tbMember = TeamMgr:GetMembers(dwTeamID);
        for _, nPlayerId in pairs(tbMember) do
            local pMember = KPlayer.GetPlayerObjById(nPlayerId)
            if pMember then
                table.insert(tbPlayers, pMember)
            end
        end
    else
        table.insert(tbPlayers, pPlayer)
    end

    if  #tbPlayers == 1 then
        local bRet, szMsg = self:CanSignUp(pPlayer) 
        if not bRet then
            ChatMgr:SendTeamAndCenterMsg(pPlayer, szMsg)
            return
        end 
    else
        local bRet, szMsg = self:CanSignUp(pPlayer) 
        if not bRet then
            ChatMgr:SendTeamAndCenterMsg(pPlayer, szMsg)
            return
        end
        local bRet, szMsg = self:CheckTeamSignUp(pPlayer)
        if not bRet then
            ChatMgr:SendTeamAndCenterMsg(pPlayer, szMsg)
            return
        end
        local tbMemberIds = {}
        for i,v in ipairs(tbPlayers) do
            table.insert(tbMemberIds, v.dwID)
        end
        CallZoneServerScript("Fuben.KeyQuestFuben:OnSyncTeamInfo", pPlayer.dwID, tbMemberIds);
        --组队信息， 拆队
        for _, nPlayerId in pairs(tbMemberIds) do
            TeamMgr:QuiteTeam(dwTeamID, nPlayerId)
        end
    end
    local x, y = unpack(DEFINE.READY_MAP_POS[MathRandom(#DEFINE.READY_MAP_POS)])
    for i,pPlayer in ipairs(tbPlayers) do
        local nOldScore = pPlayer.GetUserValue(DEFINE.SAVE_GROUP, DEFINE.KEY_PLAY_SCORE)
        local nOldCount = pPlayer.GetUserValue(DEFINE.SAVE_GROUP, DEFINE.KEY_PLAY_COUNT)
        local nVal = nOldCount == 0 and 0 or nOldScore / nOldCount
        CallZoneServerScript("Fuben.KeyQuestFuben:OnSyncPlayerScoreInfo", pPlayer.dwID, nVal);
        if not pPlayer.SwitchZoneMap(self.nReadyMapId, x, y) then
            pPlayer.CenterMsg("暫時無法進入準備場")
        end
    end 
end

function KeyQuestFuben:CheckTeamSignUp( pPlayer )
    local tbMember = TeamMgr:GetMembers(pPlayer.dwTeamID);
    if not tbMember then
        return false, "無效的隊伍"
    end 

    local teamData = TeamMgr:GetTeamById(pPlayer.dwTeamID);
    if not teamData or teamData.nCaptainID ~= pPlayer.dwID then
        return false, "只有隊長才可以進行報名"
    end

    if #tbMember > DEFINE.MAX_TEAM_ROLE_NUM then
        return false, string.format("請以單人或隊伍人數不超過%d人前來報名", DEFINE.MAX_TEAM_ROLE_NUM);        
    end

    for _, nPlayerId in pairs(tbMember) do
        if nPlayerId ~= pPlayer.dwID then
            local pPlayer2 = KPlayer.GetPlayerObjById(nPlayerId);
            if not pPlayer2 then
                return false, "未知隊伍成員，無法報名！";
            end 
            local bRet, szMsg = self:CanSignUp(pPlayer2)
            if not bRet then
                return false, (szMsg or "")
            end
        end
    end
    return true;
end

function KeyQuestFuben:OnPlayedGame( dwRoleId )
    local pPlayer = KPlayer.GetPlayerObjById(dwRoleId)
    if not pPlayer then
        Log(debug.traceback(), dwRoleId)
        return
    end
    DegreeCtrl:ReduceDegree(pPlayer, "KeyQuestFuben", 1)
    Achievement:AddCount(pPlayer, "KeyQuest_1", 1)
    if DEFINE.SupplementAwardKey then
        SupplementAward:OnJoinActivity(pPlayer, DEFINE.SupplementAwardKey)
    end
    if DEFINE.EverydayTargetKey then
        EverydayTarget:AddCount(pPlayer, DEFINE.EverydayTargetKey);
    end
end

function KeyQuestFuben:SendAwardS(dwRoleId, tbScores, nFloor)
    local pPlayer = KPlayer.GetPlayerObjById(dwRoleId)
    if not pPlayer then
        Log(debug.traceback(), dwRoleId, tbScores[1], tbScores[2])
    else
        local nOldScore = pPlayer.GetUserValue(DEFINE.SAVE_GROUP, DEFINE.KEY_PLAY_SCORE)
        local nOldCount = pPlayer.GetUserValue(DEFINE.SAVE_GROUP, DEFINE.KEY_PLAY_COUNT)
        pPlayer.SetUserValue(DEFINE.SAVE_GROUP, DEFINE.KEY_PLAY_SCORE, nOldScore + nFloor)
        pPlayer.SetUserValue(DEFINE.SAVE_GROUP, DEFINE.KEY_PLAY_COUNT, nOldCount + 1)

        local tbAwardList = {};
        for i, nHonor in ipairs(tbScores) do
            local nSaveKey = DEFINE.KEY_AWARD_SCORE[i]
            local nGiveItemId, nCostHonorPer, szItemDesc = unpack( DEFINE.EX_CHANGE_BOX_INFO[i] )
            local nCurHonor = pPlayer.GetUserValue(DEFINE.SAVE_GROUP, nSaveKey);    
            nCurHonor = nCurHonor + nHonor;
            local nCanChangeNum = math.floor(nCurHonor / nCostHonorPer)
            if nCanChangeNum > 0 then
                nCurHonor = nCurHonor - nCanChangeNum * nCostHonorPer
                table.insert(tbAwardList, {"item", nGiveItemId, nCanChangeNum })
            end
            pPlayer.SetUserValue(DEFINE.SAVE_GROUP, nSaveKey, nCurHonor);
        end

        Mail:SendSystemMail({
            To = dwRoleId,
            Title =  DEFINE.NAME ..  "獎勵",
            Text = string.format(DEFINE.AWARD_MAIL_TXT,  tbScores[1],tbScores[2]),
            tbAttach = tbAwardList,
            nLogReazon = Env.LogWay_KeyQuestFuben,
        })

    end
end

function KeyQuestFuben:OnCreateChatRoom(dwTeamID, uRoomHighId, uRoomLowId) 
    local tbMembers = TeamMgr:GetMembers(dwTeamID)
    local nMemberId = tbMembers[1]
    if not nMemberId then
        return
    end
    local pMember = KPlayer.GetPlayerObjById(nMemberId)
    if not pMember then
        return
    end
    local tbInst = Fuben.tbFubenInstance[pMember.nMapId]
    if tbInst then
        for i,nMemberId in ipairs(tbMembers) do
            local pMember = KPlayer.GetPlayerObjById(nMemberId)
            if pMember then
                ChatMgr:JoinChatRoom(pMember, 1,ChatMgr.ChannelType.Team) 
            end
        end
        return true
    end
end