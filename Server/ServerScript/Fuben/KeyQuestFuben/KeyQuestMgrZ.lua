if not MODULE_ZONESERVER then
    return
end

Fuben.KeyQuestFuben = Fuben.KeyQuestFuben or {};
local KeyQuestFuben = Fuben.KeyQuestFuben;
local DEFINE = KeyQuestFuben.DEFINE


function KeyQuestFuben:StartSignUp(  )
    self:StopSignUp()
    CreateMap(DEFINE.READY_MAP_ID);

    self.nOpenMatchNum = 0; --只有申请创建战斗图之前的数据可以在停止报名时清除
    self.tbPreFloorMapIds = {};
    self.nCurFubenFoor = 0
    self.tbInGameTeamIds = {};
    self.tbRoleScore = {};
end

function KeyQuestFuben:StopSignUp( ... )
    if self.nReadyMapId then
        KPlayer.MapBoardcastScript(self.nReadyMapId, "Ui:OpenWindow", "QYHLeftInfo", "KeyQuestFubenClose")  
        local tbPlayers = KPlayer.GetMapPlayer(self.nReadyMapId)
        for i,pPlayer in ipairs(tbPlayers) do
            if pPlayer.dwTeamID == 0 or not self.tbInGameTeamIds[pPlayer.dwTeamID] then
                pPlayer.CenterMsg("未能匹配進活動，請下一場再來！", true)    
            end
        end 

        self.nReadyMapId = nil
        CallZoneClientScript(-1, "Fuben.KeyQuestFuben:StopSignUpS")
        -- 
    end
    if self.nTimerBeginMatch then
        Timer:Close(self.nTimerBeginMatch)
        self.nTimerBeginMatch = nil;
    end
    if self.nActiveTimerReady then
        Timer:Close(self.nActiveTimerReady)
        self.nActiveTimerReady = nil;
    end
    self.tbOldTeamInfo   = nil;
    self.tbInGameTeamIds = nil
end

function KeyQuestFuben:SendAwardZ( pPlayer )
    if pPlayer.bKeyQuestFubenSend then
        Log(debug.traceback(), pPlayer.dwID)
        return
    end
    pPlayer.bKeyQuestFubenSend = true

    local tbItems = pPlayer.GetItemListInBag()
    local nTotal1, nTotal2 = 0,0
    local DROP_AWARD_ITEM = DEFINE.DROP_AWARD_ITEM
    for i,pItem in ipairs(tbItems) do
        local tbScroe = DROP_AWARD_ITEM[pItem.dwTemplateId]
        if tbScroe then
            local nScroe1, nScroe2 = unpack(tbScroe)
            nTotal1 = nTotal1 + nScroe1 * pItem.nCount
            nTotal2 = nTotal2 + nScroe2 * pItem.nCount
        end
    end
    local nFloor = self:GetMapFloor(  pPlayer.nMapTemplateId )
    CallZoneClientScript(pPlayer.nZoneIndex, "Fuben.KeyQuestFuben:SendAwardS", pPlayer.dwOrgPlayerId, {nTotal1, nTotal2}, nFloor)

    pPlayer.TLogRoundFlow(Env.LogWay_KeyQuestFuben, pPlayer.nMapTemplateId, nTotal1 + nTotal2,  GetTime() - self.nBeginMatchTime, 0, 0, 0);
end

function KeyQuestFuben:RequestLeaveKeyQuestFuben( pPlayer )
    --第三层还有一个自动踢出去时领奖的 TODO

    if pPlayer.nMapTemplateId ~= DEFINE.FIGHT_MAP_ID[#DEFINE.FIGHT_MAP_ID] then
        pPlayer.CenterMsg("該地圖不可操作離開")
        return
    end
    self:SendAwardZ(pPlayer)
    pPlayer.ZoneLogout()
end

function KeyQuestFuben:SendKeyTeamToNextFloor( nMapId )
    table.insert(self.tbPreFloorMapIds, nMapId)
    if #self.tbPreFloorMapIds ~= self.nOpenMatchNum then
        Log("KeyQuestFuben:SendKeyTeamToNextFloor", #self.tbPreFloorMapIds, self.nOpenMatchNum)
        return
    end
    Log("KeyQuestFuben:SendKeyTeamToNextFloor OK!")

    local tbHasTeams = {};
    local nKeyBuffId = DEFINE.HAVE_KEY_BUFF_ID[self.nCurFubenFoor]
    local tbCanToNextPlayers = {}
    local nNow = GetTime()
    for _, nMapId in ipairs(self.tbPreFloorMapIds) do
        local tbPlayers = KPlayer.GetMapPlayer(nMapId)
        for _, pPlayer in ipairs(tbPlayers) do
            if pPlayer.GetNpc().GetSkillState(nKeyBuffId) then
                table.insert(tbCanToNextPlayers, pPlayer)
            else
                --离开场地和发奖的操作
                self:SendAwardZ(pPlayer)
                TeamMgr:QuiteTeam(pPlayer.dwTeamID, pPlayer.dwID);
                if self.nCurFubenFoor <= 2 and pPlayer.nKeyQuestRemoveKeyTime and nNow - pPlayer.nKeyQuestRemoveKeyTime <= 60 then
                    Achievement:AddCount(pPlayer, "KeyQuest_Unfortunate", 1, true)
                end
                pPlayer.ZoneLogout()
            end
        end
    end

    local nCurTotalTeamNum, tbHasTeams = Player:MapPlayerTeamUp(tbCanToNextPlayers, DEFINE.MAX_TEAM_ROLE_NUM, true)
    local tbSortTeams = {}; --teamId, nTotoalFightpower
    for dwTeamID, v in pairs(tbHasTeams) do
        local nTotoalFightpower = 0
        local nScoreVal = 0
        for i2,v2 in ipairs(v.tbRoles) do
            local pPlayer = KPlayer.GetPlayerObjById(v2)
            nScoreVal = nScoreVal + ( self.tbRoleScore[v2] or 0 )
            if pPlayer then
                nTotoalFightpower = nTotoalFightpower + pPlayer.GetFightPower()
            end
        end
        table.insert(tbSortTeams, {v.tbRoles, nTotoalFightpower / #v.tbRoles, dwTeamID, nScoreVal / #v.tbRoles } )
    end
    self:OpenMathBySortTeam(tbSortTeams) 
end

function KeyQuestFuben:OpenMathBySortTeam( tbSortTeams )
    local nCurFubenFoor = self.nCurFubenFoor + 1;
    self.tbPreFloorMapIds = {};
    self.nCurFubenFoor = nCurFubenFoor

    table.sort( tbSortTeams, function ( a, b )
        if a[4] == b[4] then
            return a[2] < b[2]
        else
            return a[4] > b[4]
        end
    end )

    local nCurTotalTeamNum = #tbSortTeams
    local nOpenNumFrom, nOpenNumTo = unpack(DEFINE.OPENM_MATCH_NUM_FROM[nCurFubenFoor])
    local nOpenMatchNum;
    for i=1,50 do
        local nAvarge = nCurTotalTeamNum / i
        if nAvarge < nOpenNumFrom then
            break;
        elseif nAvarge >= nOpenNumFrom and nAvarge <= nOpenNumTo then
            nOpenMatchNum = i
            break;
        end
    end
    if not nOpenMatchNum and nCurFubenFoor > 1 and nCurTotalTeamNum > 0   then
        nOpenMatchNum = 1; 
    end
    if not nOpenMatchNum then
        return
    end
    self.nOpenMatchNum = nOpenMatchNum;
    local tbRandPos = Lib:CopyTB(DEFINE.FIGHT_MAP_RAND_POS[nCurFubenFoor]) 
    local nTotalPosNum = #tbRandPos
    for i=1, nTotalPosNum - 1 do
        local nRand = MathRandom(nTotalPosNum)
        tbRandPos[i], tbRandPos[nRand] = tbRandPos[nRand], tbRandPos[i]
    end


    local thMathTeamNums = {}
    local tbPlayerGameIndexTeams = {}
    local tbPlayerGameIndexTeamPkIndex = {}
    for i = 1, nOpenMatchNum do
        table.insert(tbPlayerGameIndexTeams, {})
        table.insert(tbPlayerGameIndexTeamPkIndex, {})
        thMathTeamNums[i] = 0;
    end
	local fnAssignMatch = function (nPos)
        return math.floor(nPos - 1) % nOpenMatchNum + 1;
    end
    for nPos, v in ipairs(tbSortTeams) do
        local nGameIndex = fnAssignMatch(nPos)
        thMathTeamNums[nGameIndex] = thMathTeamNums[nGameIndex] + 1;
    end

    local nGap = DEFINE.OPENM_MATCH_GAP[nCurFubenFoor]
    local nAssignMatchFrom = 1
    local nAssignMatchTo = math.min(nGap, nOpenMatchNum) 
    if (nOpenMatchNum - nAssignMatchTo) < nGap then
        nAssignMatchTo = nOpenMatchNum
    end
    local nAssignMatcIndex = nAssignMatchFrom - 1

    local fnGetAssingMatchIndex = function ( nPos )
        for nTry = 1, nGap * 2  do
            nAssignMatcIndex = nAssignMatcIndex + 1;
            if nAssignMatcIndex > nAssignMatchTo then
                nAssignMatcIndex = nAssignMatchFrom
            end
            if #tbPlayerGameIndexTeams[nAssignMatcIndex] >= thMathTeamNums[nAssignMatcIndex] then
               nAssignMatchFrom = nAssignMatchFrom + 1;
               if nAssignMatchFrom > nAssignMatchTo then --第一段已经满，开始下一段
                    nAssignMatchFrom = nAssignMatchTo + 1;
                    nAssignMatchTo = math.min(nAssignMatchTo + nGap, nOpenMatchNum) 
                    if (nOpenMatchNum - nAssignMatchTo) < nGap then
                        nAssignMatchTo = nOpenMatchNum
                    end
                    nAssignMatcIndex = nAssignMatchFrom - 1
               end
            else
                return nAssignMatcIndex
            end
        end
    end

    for nPos, v in ipairs(tbSortTeams) do
        local nGameIndex = fnGetAssingMatchIndex(nPos)
        table.insert(tbPlayerGameIndexTeams[nGameIndex], v[1])
        tbPlayerGameIndexTeamPkIndex[nGameIndex][v[3]] = nPos
        if self.tbInGameTeamIds then
            self.tbInGameTeamIds[v[3]] = 1;
        end
    end

    local function fnFailedCallback()
        Log(debug.traceback())
    end
    for nGameIndex, tbRoleIdLists in ipairs(tbPlayerGameIndexTeams) do
        local function fnSucess(nMapId)
            local nUsePosIndex = 0
            for _, tbRoleIds in ipairs(tbRoleIdLists) do
                for i, dwRoleId in ipairs(tbRoleIds) do
                    local pPlayer = KPlayer.GetPlayerObjById(dwRoleId)
                    if pPlayer then
                        nUsePosIndex = nUsePosIndex + 1;
                        if nUsePosIndex > nTotalPosNum then
                            nUsePosIndex = 1;
                        end
                        local x,y = unpack(tbRandPos[nUsePosIndex])
                        pPlayer.SwitchMap(nMapId, x,y);       
                        if nCurFubenFoor == 1 then
                            CallZoneClientScript(pPlayer.nZoneIndex, "Fuben.KeyQuestFuben:OnPlayedGame", pPlayer.dwOrgPlayerId)
                        end
                    end
                end
            end
        end
        local tbTeamPkIndex = tbPlayerGameIndexTeamPkIndex[nGameIndex]
        Fuben:ApplyFubenUseLevel(0, DEFINE.FIGHT_MAP_ID[nCurFubenFoor], 1, fnSucess, fnFailedCallback, tbTeamPkIndex, nCurFubenFoor)
    end
end

function KeyQuestFuben:BeginMatch()
    self.tbOldTeamInfo = {}; --因为这里已经又做了自动组队操作了，所以之前同步过来的信息应该清掉
    if self.nTotalPlayerNum < DEFINE.MIN_OPEN_NUM then
        return
    end
    self.nBeginMatchTime = GetTime()

    local tbPlayers = KPlayer.GetMapPlayer(self.nReadyMapId)
    local nCurTotalTeamNum, tbHasTeams = Player:MapPlayerTeamUp(tbPlayers, DEFINE.MAX_TEAM_ROLE_NUM, true)

    local tbSortTeams = {}; --teamId, nTotoalFightpower
    for dwTeamID, v in pairs(tbHasTeams) do
        local nTotoalFightpower = 0
        local nScoreVal = 0
        for i2,v2 in ipairs(v.tbRoles) do
            local pPlayer = KPlayer.GetPlayerObjById(v2)
            nScoreVal = nScoreVal + ( self.tbRoleScore[v2] or 0 )
            if pPlayer then
                nTotoalFightpower = nTotoalFightpower + pPlayer.GetFightPower()
            end
        end
        table.insert(tbSortTeams, {v.tbRoles, nTotoalFightpower / #v.tbRoles, dwTeamID, nScoreVal / #v.tbRoles} )
    end

    self:OpenMathBySortTeam(tbSortTeams)
end

function KeyQuestFuben:OnReadyMapCreate( nMapId )
    self.tbOldTeamInfo   = {};
    self.tbOldTeamMembers = {};
    self.nTimerBeginMatch = Timer:Register(Env.GAME_FPS * DEFINE.SIGNUP_TIME, function ()
        KeyQuestFuben:BeginMatch()
        KeyQuestFuben:StopSignUp()
    end);

    self.nActiveTimerReady =  Timer:Register(Env.GAME_FPS * 3, self.UpdateReadyMapInfo, self)

    self.nReadyMapId = nMapId
    CallZoneClientScript(-1, "Fuben.KeyQuestFuben:OnReadyMapCreateS", nMapId, DEFINE.SIGNUP_TIME)
    self.nTotalPlayerNum = 0;
    
end

function KeyQuestFuben:UpdateReadyMapInfo(  )
    if self.bChangePlayerNum then
        self.bChangePlayerNum = nil;
        local nTime = math.floor(Timer:GetRestTime(self.nTimerBeginMatch) / Env.GAME_FPS);
        local szNumInfo = string.format("%d / %d", self.nTotalPlayerNum, DEFINE.MIN_OPEN_NUM)
        KPlayer.MapBoardcastScript(self.nReadyMapId , "Ui:DoLeftInfoUpdate", {nTime, szNumInfo})
    end
    return true
end

function KeyQuestFuben:UpdateReadyMapLeftInfo(pPlayer)
    local nTime = math.floor(Timer:GetRestTime(self.nTimerBeginMatch) / Env.GAME_FPS);
    pPlayer.CallClientScript("Battle:EnterReadyMap", "KeyQuestFuben", {nTime, string.format("%d / %d", self.nTotalPlayerNum, DEFINE.MIN_OPEN_NUM)})
end

function KeyQuestFuben:OnLoginReadyMap()
    self:UpdateReadyMapLeftInfo(me)
end

function KeyQuestFuben:OnLeaveReadyMap()
    self.nTotalPlayerNum = self.nTotalPlayerNum - 1;
    self.bChangePlayerNum = true
end

function KeyQuestFuben:OnEnterReadyMap(  )
    me.nCanLeaveMapId = self.nReadyMapId
    self.nTotalPlayerNum = self.nTotalPlayerNum + 1;
    self.bChangePlayerNum = true
    self:UpdateReadyMapLeftInfo(me)

    if not self.nTimerBeginMatch then --之前结束匹配到 地图全部创建完之间的时间内已有组队信息的进来这样还是会自动组上原来队会有可能超3人
        return
    end

    local nMyServerId = me.nZoneServerId
    local dwMyChangeRoleId = Server:GetServerRoleCombieId(me.dwOrgPlayerId, nMyServerId)
    local nOldCaptainId = self.tbOldTeamInfo[dwMyChangeRoleId]
    if nOldCaptainId then
        local tbMemeber = self.tbOldTeamMembers[nOldCaptainId]
        for i,nCombinePlayerId in ipairs(tbMemeber) do
            if nCombinePlayerId ~= dwMyChangeRoleId then
                local nServerId, dwOrgPlayerId = Server:GetServerRoleUnLinkId(nCombinePlayerId)
                local pPlayer = KPlayer.GetPlayerObjById(dwOrgPlayerId, nServerId);
                if pPlayer then
                    if pPlayer.dwTeamID <= 0 then
                        TeamMgr:Create(me.dwID, pPlayer.dwID, true);
                    else
                        local teamData = TeamMgr:GetTeamById(pPlayer.dwTeamID);
                        local nCurCount = teamData:GetMemberCount()
                        --队长出去再组人进来，之前的队员出去再进来，就会是同队长导致可能4人
                        if nCurCount >= DEFINE.MAX_TEAM_ROLE_NUM then 
                            return
                        end
                        teamData:AddMember(me.dwID, true);
                    end
                    local _, x, y = pPlayer.GetWorldPos()
                    me.SetPosition(x, y)
                    break;
                end
            end
        end
    end

end

function KeyQuestFuben:OnSyncPlayerScoreInfo( dwOrgRoleId, fScore )
    local nServerId = Server:GetServerId(Server.nCurConnectIdx)
    local dwRoleId = KPlayer.ForceGetZonePlayerIdByOrgId(dwOrgRoleId, nServerId)
    self.tbRoleScore[dwRoleId] = fScore
end

function KeyQuestFuben:OnSyncTeamInfo( dwCaptainID, tbMember ) --因为各个服的队伍id是自增加有可能重复的
    local nServerId = Server:GetServerId(Server.nCurConnectIdx)
    local nChangedwCaptainID = Server:GetServerRoleCombieId(dwCaptainID, nServerId)
    local tbChangedMemberIds = {};
    for i, nPlayerId in ipairs(tbMember) do
        local nChangePlayerId = Server:GetServerRoleCombieId(nPlayerId, nServerId)
        self.tbOldTeamInfo[nChangePlayerId] = nChangedwCaptainID;
        table.insert(tbChangedMemberIds, nChangePlayerId)
    end
    self.tbOldTeamMembers[nChangedwCaptainID] = tbChangedMemberIds
end

function KeyQuestFuben:GetRandDropItem(  )
    if not self.tbDROP_AWARD_ITEM_DEATH then
        self.tbDROP_AWARD_ITEM_DEATH = {}
        local nTotalRate = 0;
        for i,v in ipairs(DEFINE.DROP_AWARD_ITEM_DEATH) do
            nTotalRate = nTotalRate + v.nDropRate
            table.insert(self.tbDROP_AWARD_ITEM_DEATH, { v.nItemId , nTotalRate })
        end
    end
    local nRand = MathRandom()
    for i,v in ipairs(self.tbDROP_AWARD_ITEM_DEATH) do
        if nRand <= v[2] then
            return v[1]
        end
    end
end



function KeyQuestFuben:Setup()
    local fnOnCreate = function (tbMap, nMapId)
        self:OnReadyMapCreate(nMapId)
    end

    local fnOnEnter = function (tbMap, nMapId)
        self:OnEnterReadyMap(nMapId)
    end

    local fnOnLeave = function (tbMap, nMapId)
        self:OnLeaveReadyMap(nMapId)
    end

    local fnOnMapLogin = function (tbMap, nMapId)
        self:OnLoginReadyMap(nMapId)
    end

    local tbMapClass = Map:GetClass(DEFINE.READY_MAP_ID)
    assert(tbMapClass.OnCreate == fnOnCreate or tbMapClass.OnCreate == Map.tbMapBase.OnCreate)
    tbMapClass.OnCreate = fnOnCreate;
    tbMapClass.OnEnter = fnOnEnter;
    tbMapClass.OnLeave = fnOnLeave;
    tbMapClass.OnLogin = fnOnMapLogin;
end

KeyQuestFuben:Setup()
