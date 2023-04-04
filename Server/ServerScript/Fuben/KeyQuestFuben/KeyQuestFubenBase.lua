local KeyQuestFubenMgr = Fuben.KeyQuestFuben;
local DEFINE = KeyQuestFubenMgr.DEFINE

local tbFuben        = Fuben:CreateFubenClass("KeyQuestFubenBase")

function tbFuben:OnCreate(tbTeamPkIndex, nFloor)
	--  nFubenLevel --不同层不同值， 1，2，3
    self:Start() --锁
    self.tbPlayerGatherCount = {};
    self.tbTeamPkIndex = tbTeamPkIndex
    self.nFloor = nFloor
    self.tbTeamInfos = {};
    self.nKeyBuffId = DEFINE.HAVE_KEY_BUFF_ID[nFloor]
    self.nTitleId = DEFINE.HAVE_KEY_TITLE_ID[nFloor]
    self.tbRoleZoneIndex = {}
    self.tbCreateTeamChatRoomIds = {};
    self.tbPlayerDeathTimeRecord = {};
end

function tbFuben:OnLogin()
    me.CallClientScript("Fuben.KeyQuestFuben:EnterFightMap", self.nFloor, self.tbTeamInfos[me.dwTeamID])
    if self.tbCacheScoreTimerInfo then
    	local szLine1, nEndTime = unpack(self.tbCacheScoreTimerInfo)
    	me.CallClientScript("Map:DoCmdWhenMapLoadFinish", self.nMapId, "Fuben:SetScoreTimerInfo", szLine1, nEndTime)
    end
    self:CheckHorseEquip(me)
end

function tbFuben:CheckHorseEquip( pPlayer )
	local pEquip = pPlayer.GetEquipByPos(Item.EQUIPPOS_HORSE);
    if pEquip then
        return;
    end

    pPlayer.ResetAsyncExtEquip(Item.EQUIPPOS_HORSE);
end

function tbFuben:OnJoin(pPlayer)
	local nTeamPkIndex = self.tbTeamPkIndex[pPlayer.dwTeamID]
	self:CheckHorseEquip(pPlayer)
	self.tbRoleZoneIndex[pPlayer.dwID] = pPlayer.nZoneIndex

	pPlayer.bForbidChangePk = 1;
	pPlayer.nInBattleState = 1; --战场模式
	pPlayer.nFightMode = 0;
	pPlayer.SetPkMode(3, nTeamPkIndex)
	pPlayer.szNickName = "神秘人";
	Kin:SyncTitle(pPlayer.dwID, "");
	
	pPlayer.CallClientScript("Fuben.KeyQuestFuben:EnterFightMap", self.nFloor, self.tbTeamInfos[pPlayer.dwTeamID])

	self.tbCreateTeamChatRoomIds[pPlayer.dwTeamID] = 1;
	if ChatMgr:IsTeamHaveChatRoom(pPlayer.dwTeamID) then
        ChatMgr:JoinChatRoom(pPlayer, 1,ChatMgr.ChannelType.Team)        
    else
        ChatMgr:CreateTeamChatRoom(pPlayer.dwTeamID)
    end
    if self.nFloor == 3 then
    	Achievement:AddCount(pPlayer, "KeyQuest_Floor3", 1, true)
    end
end

function tbFuben:OnOut( pPlayer )
	if self.nKeyBuffId then
		pPlayer.RemoveSkillState(self.nKeyBuffId)	
		local nItemId = DEFINE.KEY_ITEM_ID[self.nFloor]
		if nItemId then
			pPlayer.ConsumeItemInBag(nItemId, 1, Env.LogWay_KeyQuestFuben)
		end
	end
	if self.nTitleId then
		pPlayer.DeleteTitle(self.nTitleId, true)
	end

	--进入下一层可能重新组队，已经退出并进入新的队伍了
	ChatMgr:LeaveKinChatRoom(pPlayer)
	if pPlayer.bKeyQuestFubenSend then
		CallZoneClientScript(self.tbRoleZoneIndex[pPlayer.dwID], "ChatMgr:LeaveKinChatRoomClientByRoleId", pPlayer.dwOrgPlayerId)
	end
end

--有钥匙的传入下层
function tbFuben:OnSendKeyTeamToNextFloor( )
	--多场的玩家同时取，这样分配场次一致些
	KeyQuestFubenMgr:SendKeyTeamToNextFloor(self.nMapId)
end

function tbFuben:OnEndGame( )
	local tbPlayers = KPlayer.GetMapPlayer(self.nMapId)
	for i,pPlayer in ipairs(tbPlayers) do
		KeyQuestFubenMgr:SendAwardZ(pPlayer)
	    pPlayer.ZoneLogout()
	end

end

function tbFuben:OnClose(  )
	--ZoneLogout 是下一帧,所以这里是没有退队的
	if self.tbCreateTeamChatRoomIds then
		local bDeFaultClose = self.nFloor == #DEFINE.FIGHT_MAP_ID
		for dwTeamID,v in pairs(self.tbCreateTeamChatRoomIds) do
			local bClose = bDeFaultClose
			if not bClose then
				local teamData = TeamMgr:GetTeamById(dwTeamID);
				if not teamData then
					bClose = true
				end	
			end
			if bClose then
				ChatMgr:CloseTeamChatRoom(dwTeamID)
			end
		end
		self.tbCreateTeamChatRoomIds = nil;	
	end
end

function tbFuben:OnPlayerDeath(pKiller)
	me.Revive(1)
	me.nFightMode = 2;
	local nRevieTime = DEFINE.REVIVE_TIME[self.nFloor] * Env.GAME_FPS 
	local tbPlayerDeathTimeRecord = self.tbPlayerDeathTimeRecord[me.dwID] or {};
	self.tbPlayerDeathTimeRecord[me.dwID] = tbPlayerDeathTimeRecord
	table.insert(tbPlayerDeathTimeRecord, GetTime())
	if #tbPlayerDeathTimeRecord >= DEFINE.nRecordDeathTimeCount then
		local nGapTimeTotal = 0;
		for i=#tbPlayerDeathTimeRecord,2, -1 do
			nGapTimeTotal = nGapTimeTotal + tbPlayerDeathTimeRecord[i] - tbPlayerDeathTimeRecord[i-1]
		end
		if nGapTimeTotal <= DEFINE.nDeathProtectTotalTime then
			me.AddSkillState(DEFINE.nProtectBuffId, 1, 0, Env.GAME_FPS * DEFINE.nProtectBuffTime, 1, 1)
		end
		table.remove(tbPlayerDeathTimeRecord, 1)
	end

	local pKillerPlayer;
	if pKiller then
		pKillerPlayer = pKiller.GetPlayer()
	end

	me.AddSkillState(Fuben.RandomFuben.DEATH_SKILLID, 1, 0, nRevieTime);	 
	Timer:Register( nRevieTime , self.RevivePlayer, self, me.dwID)
	if self.nKeyBuffId and me.GetNpc().GetSkillState(self.nKeyBuffId) and MathRandom() <= DEFINE.DEATH_DROP_KEY_RATE then
		self:PlayerRemoveKey(me, pKillerPlayer)
	else
		if DEFINE.FLOOR_DEATH_DROP[self.nFloor] then
			local nRandItem = KeyQuestFubenMgr:GetRandDropItem()
			if nRandItem then
				local tbFinds = me.FindItemInBag(nRandItem)
				if #tbFinds > 0 then
					me.ConsumeItemInBag(nRandItem, 1, Env.LogWay_KeyQuestFuben)
					local szItemName = KItem.GetItemShowInfo(nRandItem)
					me.Msg(string.format(DEFINE.DEATH_DROP_MSG, szItemName))
					local _, nX, nY = me.GetWorldPos()
					local pNpc = KNpc.Add(DEFINE.DEATH_DROP_NPC_ID, 1, -1, self.nMapId, nX, nY, 0);
					if pNpc then
						pNpc.nDeathDropItemId = nRandItem
						pNpc.SetName(szItemName)
						if pKillerPlayer then
							pNpc.nKillerPlayerId = 	pKillerPlayer.dwID
						end
					end
				end
			end
		end		
	end

	
	if pKillerPlayer then
		self:OnPlayerKill(pKillerPlayer, me)
	end
end

function tbFuben:OnPlayerKill( pKillerPlayer, pDeathPlayer )
	pKillerPlayer.RemoveSkillState(DEFINE.nProtectBuffId)
end

function tbFuben:RevivePlayer(nPlayerId)
	if not self.nMapId then
		return
	end
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
	if not pPlayer then
		return
	end
	if pPlayer.nMapId ~= self.nMapId then
		return
	end
	pPlayer.nFightMode = 1;
end



function tbFuben:CheckOpenBox( pPlayer, pNpc, szParam )
	local nTemplateId = pNpc.nTemplateId
	if  DEFINE.EXCEPT_OPEN_BOX_LIMIT_NPC_ID[nTemplateId] then
		return true
	end
	local nCurCount = self.tbPlayerGatherCount[pPlayer.dwID] or 0;
	if nCurCount >= DEFINE.GATHER_ITEM_MAX_COUNT[self.nFloor] then
		pPlayer.CenterMsg(string.format("該層最多採集%d個寶箱", DEFINE.GATHER_ITEM_MAX_COUNT[self.nFloor]))
		return
	end
	return true, nCurCount 
end

function tbFuben:OnOpenBox( pPlayer, pNpc, szParam )
	local bRet, nCurCount = self:CheckOpenBox(pPlayer, pNpc, szParam)
	if not bRet then
		return
	end

	local nRandomId = tonumber(szParam)
	if not nRandomId then
		Log(debug.traceback(), szParam)
		return
	end

	local nRet, szMsg, tbAward = Item:GetClass("RandomItem"):RandomItemAward(pPlayer, nRandomId, "")
	if nRet ~= 1 then
		Log(debug.traceback(), szParam)
		return
	end

	if nCurCount then
		self.tbPlayerGatherCount[pPlayer.dwID] = nCurCount + 1;
	end
	
	pPlayer.SendAward(tbAward, nil,nil, Env.LogWay_KeyQuestFuben)
	if pNpc.nTemplateId == self.nTarUpdateCountNpcID then
		self.nUpdateCountCur = self.nUpdateCountCur - 1;
		KPlayer.MapBoardcastScript(self.nMapId, "Fuben:SetScoreTxtInfo", self.szUpdateCountLine1, string.format("%d/%d", self.nUpdateCountCur, self.nUpdateCountTotal))	
	end
	pNpc.Delete()
end

function tbFuben:CheckOpenTeamBox( pPlayer, pNpc, szParam)
	return self:CheckOpenBox(pPlayer, pNpc, szParam)
end

function tbFuben:OnOpenTeamBox( pPlayer, pNpc, szParam )
	local bRet, nCurCount = self:CheckOpenTeamBox(pPlayer, pNpc, szParam)
	if not bRet then
		return
	end

	local nRandomId = tonumber(szParam)
	if not nRandomId then
		Log(debug.traceback(), szParam)
		return
	end

	local nRet, szMsg, tbAward = Item:GetClass("RandomItem"):RandomItemAward(pPlayer, nRandomId, "")
	if nRet ~= 1 then
		Log(debug.traceback(), szParam)
		return
	end
	if nCurCount then
		self.tbPlayerGatherCount[pPlayer.dwID] = nCurCount + 1;
	end

	local tbMembers = TeamMgr:GetMembers(pPlayer.dwTeamID)
	for i, nMemberId in ipairs(tbMembers) do
		local pMember = KPlayer.GetPlayerObjById(nMemberId)
		if pMember then
			pMember.SendAward(tbAward, nil,nil, Env.LogWay_KeyQuestFuben)
			Achievement:AddCount(pMember, "KeyQuest_BigBox", 1, true)
		end
	end
		
	if pNpc.nTemplateId == self.nTarUpdateCountNpcID then
		self.nUpdateCountCur = self.nUpdateCountCur - 1;
		KPlayer.MapBoardcastScript(self.nMapId, "Fuben:SetScoreTxtInfo", self.szUpdateCountLine1, string.format("%d/%d", self.nUpdateCountCur, self.nUpdateCountTotal))	
	end
	pNpc.Delete()
	local teamData = TeamMgr:GetTeamById(pPlayer.dwTeamID);
	local nCaptainID = teamData.nCaptainID
	local pLeader = KPlayer.GetPlayerObjById(nCaptainID)
	if pLeader then
		CallZoneClientScript(pLeader.nZoneIndex, "KPlayer.SendWorldNotify",1,999, string.format("恭喜本服的[FFFE0D]%s[-]帶領的小隊開啟了遺跡中的巨型寶箱，獲得了創世之劍", pLeader.szName),1,1)	
	end
end

function tbFuben:OnOpenDeathDropItem( pPlayer, pNpc )
	local nDeathDropItemId = pNpc.nDeathDropItemId
	pNpc.Delete()
	if not nDeathDropItemId then
		Log(debug.traceback())
		return
	end
	pPlayer.SendAward({ { "item", nDeathDropItemId, 1 } }, nil,nil, Env.LogWay_KeyQuestFuben)
	if pNpc.nKillerPlayerId and pPlayer.dwID == pNpc.nKillerPlayerId and nDeathDropItemId == 8377 then
		Achievement:AddCount(pPlayer, "KeyQuest_SwordRobber", 1, true)
	end
end

function tbFuben:ForEachPlayerInTeam( dwTeamID, fnFunction )
	local tbMembers = TeamMgr:GetMembers(dwTeamID)
	for _,dwID in pairs(tbMembers) do
		local pPlayer = KPlayer.GetPlayerObjById(dwID)
		if pPlayer and pPlayer.nMapId == self.nMapId then
			fnFunction(pPlayer)
		end
	end	
end

function tbFuben:PlayerGetKey(pPlayer)
	local nItemId = DEFINE.KEY_ITEM_ID[self.nFloor]
	pPlayer.SendAward({ { "item", nItemId, 1 } }, nil,nil, Env.LogWay_KeyQuestFuben)
	pPlayer.AddSkillState(self.nKeyBuffId, 1,0, 3600 * 15, 1) --死亡保留
	pPlayer.AddTitle(self.nTitleId, 3600, true, false, true)

	local dwTeamID = pPlayer.dwTeamID
	self.tbTeamInfos[dwTeamID] = self.tbTeamInfos[dwTeamID] or {};
	local tbTeamInfo = self.tbTeamInfos[dwTeamID]
	tbTeamInfo[pPlayer.dwID] = 1; --
	self:ForEachPlayerInTeam(dwTeamID, function (pMember)
		pMember.CallClientScript("Fuben.KeyQuestFuben:OnSynTeamKeyInfo", tbTeamInfo)
	end)
end

function tbFuben:PlayerRemoveKey( pPlayer , pKillerPlayer)
	local nItemId = DEFINE.KEY_ITEM_ID[self.nFloor]
	me.ConsumeItemInBag(nItemId, 1, Env.LogWay_KeyQuestFuben)
	me.RemoveSkillState(self.nKeyBuffId)
	me.DeleteTitle(self.nTitleId, true)

	local _, nX, nY = me.GetWorldPos()

	local pNpcKey = KNpc.Add(DEFINE.KEY_DROP_NPC_ID[self.nFloor], 1, -1, self.nMapId, nX, nY, 0);
	if pKillerPlayer and pNpcKey then
		pNpcKey.nKillerPlayerId = pKillerPlayer.dwID
	end

	local dwTeamID = pPlayer.dwTeamID
	self.tbTeamInfos[dwTeamID] = self.tbTeamInfos[dwTeamID] or {};
	local tbTeamInfo = self.tbTeamInfos[dwTeamID]
	tbTeamInfo[pPlayer.dwID] = nil; --
	self:ForEachPlayerInTeam(dwTeamID, function (pMember)
		pMember.CallClientScript("Fuben.KeyQuestFuben:OnSynTeamKeyInfo", tbTeamInfo)
	end)
	me.nKeyQuestRemoveKeyTime = GetTime()
end


--拾取key
function tbFuben:OnOpenKey( pPlayer, pNpc, szParam )
	if not self.nKeyBuffId then
		return
	end
	if pPlayer.GetNpc().GetSkillState(self.nKeyBuffId) then
		pPlayer.CenterMsg("你已經持有傳送符，無法拾取")
		return
	end
	self:PlayerGetKey(pPlayer)
	if pNpc.nKillerPlayerId == pPlayer.dwID then
		Achievement:AddCount(pPlayer, "KeyQuest_KeyRobber", 1, true)
	end
	pNpc.Delete()
end

function tbFuben:OnKillNpc(pNpc, pKiller)
	--现在里面只有宝箱怪
	local nTemplateId = pNpc.nTemplateId
	if DEFINE.DROP_KEY_NPC[nTemplateId] then
		local _, nX, nY = pNpc.GetWorldPos()
		self:AddSimpleNpc( DEFINE.KEY_DROP_NPC_ID[self.nFloor], nX, nY)
		return
	end
	local tbBossDropSetting = DEFINE.BOSS_DROP_SETTING[nTemplateId]
	if tbBossDropSetting then
		local tbDmgInfo = pNpc.GetDamageInfo()
		if not tbDmgInfo or #tbDmgInfo <= 0 then
			return
		end
		table.sort( tbDmgInfo, function (a, b)
			return a.nTotalDamage > b.nTotalDamage
		end )
		for i,tbAward in ipairs(tbBossDropSetting) do
			local tbDmTeam = tbDmgInfo[i]
			if not tbDmTeam then
				return
			end
			local nTeamId = tbDmTeam.nTeamId
			local tbMembers = TeamMgr:GetMembers(nTeamId)
			for _, dwRoleId in ipairs(tbMembers) do
				local pPlayer = KPlayer.GetPlayerObjById(dwRoleId)
				if pPlayer then
					local tbAwardReal = {};
					for i2,v2 in ipairs(tbAward) do
						local nItemCount = v2[3]
						local nLeft = nItemCount - math.floor(nItemCount)
						if nLeft > 0.01 then
							if MathRandom() <= nLeft then
								nItemCount = math.ceil(nItemCount)
							else
								nItemCount = math.floor(nItemCount)
							end
						end
						if nItemCount > 0 then
							local tbRealV = Lib:CopyTB(v2)
							tbRealV[3] = nItemCount
							table.insert(tbAwardReal, tbRealV)
						end
					end
					if next(tbAwardReal) then
						pPlayer.SendAward(tbAwardReal, nil,nil, Env.LogWay_KeyQuestFuben)
					end
				end
			end
		end
	end
end

function tbFuben:OnWorldNotify(szNotify)
	KPlayer.MapBoardcastScript(self.nMapId, "Ui:OnWorldNotify", szNotify, 1, 1)	
end

function tbFuben:OnAddPercetnNpc( nIndex, nPercent, nLock, szGroup, szPointName, bRevive, nDir, nDealyTime, nEffectId, nEffectTime )
	local tbPlayers, nPlayerNum = KPlayer.GetMapPlayer(self.nMapId)
	local nNum = math.max(1, math.floor(nPlayerNum * nPercent)) 
	self:AddNpc(nIndex, nNum, nLock, szGroup, szPointName, bRevive, nDir, nDealyTime, nEffectId, nEffectTime)
end

function tbFuben:OnAddNpc( pNpc )
	local szNotifyMsg = DEFINE.MAP_NOTIFY_POS_NPCID[pNpc.nTemplateId]
	if not szNotifyMsg then
		return
	end

	local nMapId,x, y = pNpc.GetWorldPos()
	ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Map, szNotifyMsg, nMapId,{nLinkType =ChatMgr.LinkType.Position, nMapId = nMapId, nX = x, nY = y })
	KPlayer.MapBoardcastScript(self.nMapId, "Ui:OnWorldNotify", szNotifyMsg , 0)	
end

function tbFuben:OnAddPercetnNpcAndUpdateCount( szLine1, nIndex, nPercent, nLock, szGroup, szPointName, bRevive, nDir, nDealyTime, nEffectId, nEffectTime )
	local tbNpcInfo = self.tbSetting.NPC[nIndex];
	self.nTarUpdateCountNpcID = tbNpcInfo.nTemplate
	self.szUpdateCountLine1 = szLine1
	local tbPlayers, nPlayerNum = KPlayer.GetMapPlayer(self.nMapId)
	local nNum = math.max(1, math.floor(nPlayerNum * nPercent)) 
	self.nUpdateCountTotal = nNum
	self.nUpdateCountCur = nNum
	self:AddNpc(nIndex, nNum, nLock, szGroup, szPointName, bRevive, nDir, nDealyTime, nEffectId, nEffectTime)
	KPlayer.MapBoardcastScript(self.nMapId, "Fuben:SetScoreTxtInfo", self.szUpdateCountLine1, string.format("%d/%d", self.nUpdateCountCur, self.nUpdateCountTotal))	
end

function tbFuben:OnUpdateScoreTimerInfo( szLine1, nLockId )
	local nEndTime = 0;
	if self.tbLock[nLockId] then
		nEndTime = GetTime() + math.floor(Timer:GetRestTime(self.tbLock[nLockId].nTimerId) / Env.GAME_FPS);
	end
	self.tbCacheScoreTimerInfo = {szLine1, nEndTime}
	KPlayer.MapBoardcastScript(self.nMapId, "Map:DoCmdWhenMapLoadFinish", self.nMapId, "Fuben:SetScoreTimerInfo", szLine1, nEndTime);
end