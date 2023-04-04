if not MODULE_ZONESERVER then
	return
end

KinEncounter.tbFightMapLogic = KinEncounter.tbFightMapLogic or {}
local tbFightMapLogic = KinEncounter.tbFightMapLogic

--
--战斗地图
--
local tbFightMap = Map:GetClass(KinEncounter.Def.nFightMapId)
function tbFightMap:OnCreate(nMapId)
	local tbMapInfo = KinEncounter.tbFightMapInfo[nMapId]
	if not tbMapInfo then
		Log("[x] KinEncounter.tbFightMap:OnCreate", nMapId)
		return
	end

	local tbLogic = Lib:NewClass(tbFightMapLogic)
	local nKinA, nKinB, tbMembersA, tbMembersB = unpack(tbMapInfo)
	tbLogic:Init(nMapId, nKinA, nKinB, tbMembersA, tbMembersB)

	local function fnFrameCall(nPlayerId, nX, nY)
		local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
		if pPlayer then
			pPlayer.SwitchMap(nMapId, nX, nY)
		end
	end

	local nCountPerFrame = 15
	local nCurCount = 0
	for i, tbMembers in ipairs({tbMembersA, tbMembersB}) do
		local nX, nY = unpack(KinEncounter.Def.tbFightMapEnterPos[i])
		for nPlayerId in pairs(tbMembers) do
			nCurCount = nCurCount + 1
			Timer:Register(math.ceil(nCurCount / nCountPerFrame), fnFrameCall, nPlayerId, nX, nY)
		end
	end

	KinEncounter:SetFightMapLogic(nMapId, tbLogic)
	Log("KinEncounter.tbFightMap:OnCreate", nMapId, nKinA, nKinB, Lib:CountTB(tbMembersA), Lib:CountTB(tbMembersB))
end

function tbFightMap:OnDestroy(nMapId)
	KinEncounter:SetFightMapLogic(nMapId, nil)
	Log("KinEncounter.tbFightMap:OnDestroy", nMapId)
end

function tbFightMap:OnEnter(nMapId)
	local tbLogic = KinEncounter:GetFightMapLogic(nMapId)
	if not tbLogic then
		Log("[x] KinEncounter.tbFightMap:OnEnter", nMapId)
		return
	end
	tbLogic:OnEnterMap(me)
end

function tbFightMap:OnLeave(nMapId)
	local tbLogic = KinEncounter:GetFightMapLogic(nMapId)
	if not tbLogic then
		Log("[x] KinEncounter.tbFightMap:OnLeave", nMapId)
		return
	end
	tbLogic:OnLeaveMap(me)
end

function tbFightMap:OnLogin(nMapId)
	local tbLogic = KinEncounter:GetFightMapLogic(nMapId)
	if not tbLogic then
		Log("[x] KinEncounter.tbFightMap:OnLogin", nMapId, me.dwID)
		return
	end
	tbLogic:OnPlayerLogin(me)
end

function tbFightMap:OnPlayerTrap(nMapId, szTrapName)
	local tbLogic = KinEncounter:GetFightMapLogic(nMapId)
	if not tbLogic then
		Log("[x] KinEncounter.tbFightMap:OnPlayerTrap", nMapId, me.dwID)
		return
	end
	tbLogic:OnPlayerTrap(me, szTrapName)
end

--
--Logic
--
function tbFightMapLogic:Init(nMapId, nKinA, nKinB, tbMembersA, tbMembersB)
	self.nEndTime = GetTime() + KinEncounter.Def.nFightTime + KinEncounter.Def.nFightWaitTime

	self.bWaitFight = true
	self.nMapId = nMapId
	self.bOver = false
	self.tbKins = {nKinA, nKinB}
	self.tbMembers = {tbMembersA, tbMembersB}
	self.tbScores = {0, 0}
	self.tbWoods = {KinEncounter.Def.nInitWood, KinEncounter.Def.nInitWood}
	self.tbScoreIncV = {0, 0}
	self.tbWoodIncV = {0, 0}
	self.tbWoodOwner = {0, 0}
	self.tbFoodOwner = {0, 0}
	self.nDragonOwner = 0
	self.tbPlayerInfos = {}
	self.tbToolStocks = {{}, {}}	--已造好，未领取
	self.tbToolReady = {{}, {}}	--已领取，未使用
	self.tbToolUsing = {{}, {}}	--使用中

	self.tbKillRanks = {{}, {}}
	for i, tbMembers in ipairs(self.tbMembers) do
		for nPlayerId in pairs(tbMembers) do
			table.insert(self.tbKillRanks[i], nPlayerId)
		end
	end

	self:CreateNpcs()
	self:StartTimer()

	for _, nKinId in ipairs(self.tbKins) do
		KinEncounter:SetKinFightMapId(nKinId, nMapId)
		ChatMgr:CreateKinChatRoom(nKinId)
	end
end

function tbFightMapLogic:CreateNpcs()
	local nMapId = self.nMapId
	for szMainType, tb in pairs(KinEncounter.Def.tbMapPeaceNpcs) do
		for szSubType, tbCfg in pairs(tb) do
			local pNpc = KNpc.Add(tbCfg.id, 1, -1, nMapId, tbCfg.x, tbCfg.y, 0, tbCfg.dir or 0)
			if not pNpc then
				Log("[x] tbFightMapLogic:CreateNpcs peace", nMapId, tostring(tbCfg.id), nMapId, tbCfg.x, tbCfg.y, tbCfg.dir)
			end
		end
	end
	
	local nAvgPlayers = math.ceil((Lib:CountTB(self.tbMembers[1]) + Lib:CountTB(self.tbMembers[2])) / 2)
	for szMainType, tb in pairs(KinEncounter.Def.tbMapResNpcs) do
		for szSubType, tbCfg in pairs(tb) do
			local nNpcTempId = 0
			for _, v in ipairs(tbCfg.id) do
				local nMaxPlayers, nId = unpack(v)
				if nAvgPlayers <= nMaxPlayers then
					nNpcTempId = nId
					break
				end
			end
			if not nNpcTempId or nNpcTempId <= 0 then
				nNpcTempId = 0
				Log("[x] tbFightMapLogic:CreateNpcs, res npc no nNpcTempId", szMainType, szSubType, Lib:CountTB(self.tbMembers[1]), Lib:CountTB(self.tbMembers[2]), nAvgPlayers)
			end

			local pNpc = KNpc.Add(nNpcTempId, KinEncounter.nNpcLevel, -1, nMapId, tbCfg.x, tbCfg.y, 0, tbCfg.dir or 0)
			if pNpc then
				pNpc.SetPkMode(Player.MODE_CUSTOM, 0)
				pNpc.tbCfgTypes = {szMainType, szSubType, nNpcTempId}
				pNpc.SetTitle("無人佔據")
			else
				Log("[x] tbFightMapLogic:CreateNpcs", nMapId, tostring(nNpcTempId), KinEncounter.nNpcLevel, nMapId, tbCfg.x, tbCfg.y, tbCfg.dir)
			end
		end
	end
end

function tbFightMapLogic:OnPlayerLogin(pPlayer)
	self:SyncFightData(pPlayer)

	if not self.bWaitFight then
		if pPlayer.nFightMode == 1 then
			pPlayer.CallClientScript("KinEncounter:CloseWay")
		elseif pPlayer.nFightMode == 0 then
			pPlayer.CallClinetScript("KinEncounter:OpenWay")
		end
	end
	Log("KinEncounter.tbFightMapLogic:OnPlayerLogin", pPlayer.dwID)
end

function tbFightMapLogic:OnEnterMap(pPlayer)
	pPlayer.nInBattleState = 1
	pPlayer.bForbidChangePk = 1
	pPlayer.SetPkMode(Player.MODE_CUSTOM, self:GetIdx(pPlayer.dwID))
	pPlayer.nFightMode = 0

	local nCurMapId, nPosX, nPosY = pPlayer.GetWorldPos()
	pPlayer.SetTempRevivePos(nCurMapId, nPosX, nPosY, 0)

	self.tbPlayerInfos[pPlayer.dwID] = {
		szName = pPlayer.szName,
		nOrgPlayerId = pPlayer.dwOrgPlayerId,
		nOnDeathRegID = PlayerEvent:Register(pPlayer, "OnDeath", function(pKiller) self:OnPlayerDeath(pKiller) end),
	}

	self:SyncFightData(pPlayer)

	Log("KinEncounter.tbFightMapLogic:OnEnterMap", pPlayer.dwKinId, pPlayer.dwID)
end

function tbFightMapLogic:SyncFightData(pPlayer)
	local tbData = {}
	for _, nKinId in ipairs(self.tbKins) do
		table.insert(tbData, {
			nKinId = nKinId,
			szName = KinEncounter:GetKinName(nKinId),
		})
	end
	tbData.nTimeLeft = math.max(0, self.nEndTime - GetTime())
	pPlayer.CallClientScript("KinEncounter:OnEnterFightMap", tbData)

	for i, nKinId in ipairs(self.tbKins) do
		pPlayer.CallClientScript("KinEncounter:OnFightDataChange", nKinId, self:GetFightShowData(pPlayer, i))
	end
end

function tbFightMapLogic:GetFightShowData(pPlayer, nIdx)
	local tbRet = {
		nScore = self.tbScores[nIdx],
		nWood = self.tbWoods[nIdx],
	}
	tbRet.nFood = 0
	for _, nOwner in ipairs(self.tbFoodOwner) do
		if nOwner == self.tbKins[nIdx] then
			tbRet.nFood = tbRet.nFood + 1
		end
	end

	if pPlayer.dwKinId == self.tbKins[nIdx] then
		tbRet.nKillRank = self:GetKillRank(pPlayer, nIdx)
	end

	return tbRet
end

function tbFightMapLogic:GetKillRank(pPlayer, nIdx)
	for i, nPlayerId in ipairs(self.tbKillRanks[nIdx]) do
		if nPlayerId == pPlayer.dwID then
			return i
		end
	end
	return #self.tbKillRanks[nIdx]
end

function tbFightMapLogic:GetShowRank(pPlayer)
	local tbRank = {}
	local nIdx = self:GetIdx(pPlayer.dwID)
	local bMeIncluded = false
	local bShort = false
	for i=1, 10 do
		local nPlayerId = self.tbKillRanks[nIdx][i]
		if not nPlayerId then
			bShort = true
			break
		end

		local tbInfo = self.tbPlayerInfos[nPlayerId] or {}
		if nPlayerId == pPlayer.dwID then
			bMeIncluded = true
		end
		table.insert(tbRank, {
			tbInfo.szName or "",
			tbInfo.nKill or 0,
		})
	end

	if not bShort then
		local tbInfo = bMeIncluded and self.tbPlayerInfos[self.tbKillRanks[nIdx][11]] or self.tbPlayerInfos[pPlayer.dwID]
		tbInfo = tbInfo or {}
		local nLastRank = bMeIncluded and 11 or self:GetKillRank(pPlayer, nIdx)
		table.insert(tbRank, {
			tbInfo.szName or "",
			tbInfo.nKill or 0,
			nLastRank,
		})
	end

	return tbRank
end

function tbFightMapLogic:OnLeaveMap(pPlayer)
	pPlayer.nInBattleState = 0
	pPlayer.bForbidChangePk = 0
	pPlayer.SetPkMode(Player.MODE_PEACE)
	pPlayer.ClearTempRevivePos()

	pPlayer.RemoveSkillState(KinEncounter.Def.tbFoodBuff[1])

	local tbInfo = self.tbPlayerInfos[pPlayer.dwID] or {}
	if tbInfo.nOnDeathRegID then
		PlayerEvent:UnRegister(pPlayer, "OnDeath", tbInfo.nOnDeathRegID)
		tbInfo.nOnDeathRegID = nil
	end
	Log("KinEncounter.tbFightMapLogic:OnLeaveMap", pPlayer.dwID)
end

function tbFightMapLogic:OnPlayerTrap(pPlayer, szTrapName)
	local tbTargetPos = KinEncounter.Def.tbTraps[szTrapName]
	if not tbTargetPos then
		return
	end
	if self.bWaitFight then
		pPlayer.CenterMsg("請等待戰鬥開啟")
		return
	end	
	pPlayer.nFightMode = 1
	pPlayer.SetPosition(unpack(tbTargetPos))
	pPlayer.CallClientScript("KinEncounter:CloseWay")
end

function tbFightMapLogic:OnPlayerDeath(pKiller)
	me.Revive(0)
	me.GetNpc().ClearAllSkillCD()
	me.nFightMode = 0

	me.CallClientScript("KinEncounter:OnDeath")

	local tbMyInfo = self.tbPlayerInfos[me.dwID]
	if tbMyInfo then
		tbMyInfo.nMultKill = 0
	end
	local tbKillerInfo = self.tbPlayerInfos[pKiller and pKiller.dwPlayerID or 0]
	if tbKillerInfo then
		tbKillerInfo.nKill = (tbKillerInfo.nKill or 0) + 1
		tbKillerInfo.nMultKill = (tbKillerInfo.nMultKill or 0) + 1

		local pKillPlayer = pKiller.GetPlayer()
		if pKillPlayer then
			pKillPlayer.CallClientScript("Ui:ShowComboKillCount", tbKillerInfo.nMultKill)
		end

		if tbKillerInfo.nMultKill % KinEncounter.Def.nMultKillBroadcast == 0 then
			local szMsg = string.format("%s勢不可擋，在幫派遭遇戰中連殺%s人！", pKiller.szName, tbKillerInfo.nMultKill)
			self:SendBlackBoardMsg(pKiller.dwPlayerID, szMsg)
		end

		self:UpdateKillRankList(pKiller.dwPlayerID)
	end

	local nIdx = self:GetIdx(me.dwID)
	for nNpcTempId, tbUsing in pairs(self.tbToolUsing[nIdx]) do
		tbUsing[me.dwID] = nil
	end
end

function tbFightMapLogic:SendBlackBoardMsgToIdx(nIdx, szMsg)
	for nPlayerId in pairs(self.tbMembers[nIdx] or {}) do
    	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    	if pPlayer then
        	Dialog:SendBlackBoardMsg(pPlayer, szMsg)
        end
    end
end

function tbFightMapLogic:SendBlackBoardMsg(nTrigger, szMsg)
	local nIdx = self:GetIdx(nTrigger)
	self:SendBlackBoardMsgToIdx(nIdx, szMsg)
end

function tbFightMapLogic:GetIdx(nPlayerId)
	local nIdx = 0
	for i, tbMembers in ipairs(self.tbMembers) do
		if tbMembers[nPlayerId] then
			nIdx = i
			break
		end
	end
	return nIdx
end

function tbFightMapLogic:UpdateKillRankList(nKiller)
	local nIdx = self:GetIdx(nKiller)
	if nIdx <= 0 then
		return
	end
	table.sort(self.tbKillRanks[nIdx], function(nPlayer1, nPlayer2)
		if not self.tbPlayerInfos[nPlayer1] or not self.tbPlayerInfos[nPlayer2] then
			return nPlayer1 < nPlayer2
		end
		local nKill1 = self.tbPlayerInfos[nPlayer1].nKill or 0
		local nKill2 = self.tbPlayerInfos[nPlayer2].nKill or 0
		return nKill1 > nKill2 or (nKill1 == nKill2 and nPlayer1 < nPlayer2)
	end)

	for i, nPlayer in ipairs(self.tbKillRanks[nIdx]) do
		local pPlayer = KPlayer.GetPlayerObjById(nPlayer)
		if pPlayer then
			pPlayer.CallClientScript("KinEncounter:OnFightDataChange", self.tbKins[nIdx], {nKillRank = i})
		end
	end
end

function tbFightMapLogic:OnPlayerRevive()
end

function tbFightMapLogic:GameOver(nWinIdx)
	self.bOver = true
	self:CloseTimer()

	for i in ipairs(self.tbKins) do
		local tbRankOrgPlayerIds = {}
		local tbKillInfo = {}
		local tbPlayers = {}
		local nZoneIdx = nil
		for _, nPlayerId in ipairs(self.tbKillRanks[i]) do
			if not nZoneIdx then
				local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
				if pPlayer then
					nZoneIdx = pPlayer.nZoneIndex
				end
			end

			local tbInfo = self.tbPlayerInfos[nPlayerId] or {}
			table.insert(tbPlayers, {
				tbInfo.szName or "",
				tbInfo.nKill or 0,
			})
			table.insert(tbRankOrgPlayerIds, tbInfo.nOrgPlayerId)
			table.insert(tbKillInfo, tbInfo.nKill or 0)
		end
		if nZoneIdx then
			local nResult = 0
			if nWinIdx > 0 then
				nResult = nWinIdx == i and 1 or -1
			end
			CallZoneClientScript(nZoneIdx, "KinEncounter:OnGameOver", {
				nResult = nResult,
				tbPlayers = tbRankOrgPlayerIds,
				tbKills = tbKillInfo,
				szOtherKin = KinEncounter:GetKinIdKey(self.tbKins[i==1 and 2 or 1]),
			})
			Log("tbFightMapLogic:GameOver", i, nWinIdx, nZoneIdx, nResult, self.tbKins[1], self.tbKins[2])
		else
			Log("[x] tbFightMapLogic:GameOver", i, nWinIdx, self.tbKins[1], self.tbKins[2])
			Lib:LogTB(self.tbKillRanks[i])
		end
	end

	local tbPlayers = KPlayer.GetMapPlayer(self.nMapId) or {}
	for _, pPlayer in pairs(tbPlayers) do
		pPlayer.SetPkMode(Player.MODE_PEACE)
	end

	Timer:Register(Env.GAME_FPS * KinEncounter.Def.nDelayKickoutTime, self.KickoutAll, self)
	Log("tbFightMapLogic:GameOver", self.tbKins[1], self.tbKins[2], self.nEndTime, nWinIdx, self.tbScores[1], self.tbScores[2])
end

function tbFightMapLogic:KickoutAll()
	for _, nKinId in ipairs(self.tbKins) do
		ChatMgr:CloseKinChatRoom(nKinId)
	end

	local tbPlayers = KPlayer.GetMapPlayer(self.nMapId) or {}
	for _, pPlayer in pairs(tbPlayers) do
		pPlayer.ZoneLogout()
	end
	return false
end

function tbFightMapLogic:OnTimeout()
	local nScore1 = math.floor(self.tbScores[1])
	local nScore2 = math.floor(self.tbScores[2])
	local nWinIdx = 0
	if nScore1 > nScore2 then
		nWinIdx = 1
	elseif nScore1 < nScore2 then
		nWinIdx = 2
	end
	self:GameOver(nWinIdx)
	Log("tbFightMapLogic:OnTimeout", nWinIdx, self.tbScores[1], self.tbScores[2], nScore1, nScore2)
	return false
end

function tbFightMapLogic:OnWaitTimeout()
	self.bWaitFight = false

	KPlayer.MapBoardcastScript(self.nMapId, "KinEncounter:OpenWay")

	return false
end

function tbFightMapLogic:OnReadyGoWaitTimeout()
	local tbPlayers = KPlayer.GetMapPlayer(self.nMapId) or {}
	for _, pPlayer in pairs(tbPlayers) do
		pPlayer.CallClientScript("Ui:OpenWindow", "ReadyGo")
	end
	return false
end

function tbFightMapLogic:StartTimer()
	Timer:Register(Env.GAME_FPS * KinEncounter.Def.nReadyGoWaitTime, self.OnReadyGoWaitTimeout, self)
	Timer:Register(Env.GAME_FPS * KinEncounter.Def.nFightWaitTime, self.OnWaitTimeout, self)
	self.nFightTimer = Timer:Register(Env.GAME_FPS * (KinEncounter.Def.nFightTime + KinEncounter.Def.nFightWaitTime), self.OnTimeout, self)
	self.nActiveTimer = Timer:Register(Env.GAME_FPS * KinEncounter.Def.nActiveInterval, self.OnActive, self)
end

function tbFightMapLogic:CloseTimer()
	if self.nFightTimer and self.nFightTimer > 0 then
		Timer:Close(self.nFightTimer)
		self.nFightTimer = nil
	end
	if self.nActiveTimer and self.nActiveTimer > 0 then
		Timer:Close(self.nActiveTimer)
		self.nActiveTimer = nil
	end
end

function tbFightMapLogic:OnActive()
	if self.bOver then
		return false
	end

	for i=1, 2 do
		self.tbScores[i] = math.min(self.tbScores[i] + self.tbScoreIncV[i] * KinEncounter.Def.nActiveInterval, KinEncounter.Def.nMaxScore)
		self.tbWoods[i] = math.min(self.tbWoods[i] + self.tbWoodIncV[i] * KinEncounter.Def.nActiveInterval, KinEncounter.Def.nMaxScore)

		KPlayer.MapBoardcastScriptByFuncName(self.nMapId, "KinEncounter:OnFightDataChange", self.tbKins[i], {
			nScore = math.floor(self.tbScores[i]),
			nWood = math.floor(self.tbWoods[i]),
		})

		if self.tbScores[i] >= KinEncounter.Def.nMaxScore then
			self:GameOver(i)
			return false
		end
	end
	return true
end

function tbFightMapLogic:OnNpcDeath(pKiller, szMainType, szSubType, nNpcTempId)
	local pKillPlayer = pKiller.GetPlayer()
	if pKillPlayer then
		local tbTeam = TeamMgr:GetTeamById(pKillPlayer.dwTeamID)
		if tbTeam then
			local nCaptain = tbTeam:GetCaptainId()
			if nCaptain ~= pKillPlayer.dwID and self:GetIdx(nCaptain) ~= self:GetIdx(pKillPlayer.dwID) then
				local pCap = KPlayer.GetPlayerObjById(nCaptain)
				if pCap then
					pKiller = pCap.GetNpc()
					Log("tbFightMapLogic:OnNpcDeath, cap grab", pKillPlayer.dwTeamID, pKillPlayer.dwID, nCaptain)
				end
			end
		end
	end

	local tbCfg = KinEncounter:GetResNpcCfg(szMainType, szSubType)
	if not tbCfg then
		Log("[x] KinEncounter.tbFightMapLogic:OnNpcDeath", pKiller.dwPlayerID, szMainType, szSubType)
		return
	end

	local szMsg = string.format("Bang phái thành viên %s Lực phấn thần uy, thành công chiếm lĩnh %s！", pKiller.szName, tbCfg.name)
	self:SendBlackBoardMsg(pKiller.dwPlayerID, szMsg)

	local nOwnerIdx = self:GetIdx(pKiller.dwPlayerID)
	local pNpc = KNpc.Add(nNpcTempId, KinEncounter.nNpcLevel, -1, pKiller.nMapId, tbCfg.x, tbCfg.y, 0, tbCfg.dir or 0)
	pNpc.tbCfgTypes = {szMainType, szSubType, nNpcTempId}
	pNpc.nOwner = nOwnerIdx
	pNpc.SetPkMode(Player.MODE_CUSTOM, nOwnerIdx)
	local szTitle = "Không người chiếm cứ"
	if nOwnerIdx and nOwnerIdx > 0 then
		szTitle = string.format("「%s」 Chiếm cứ", KinEncounter:GetKinName(self.tbKins[nOwnerIdx]))
	end
	pNpc.SetTitle(szTitle)

	local nOldOwner = 0
	if szMainType == "dragon" then
		nOldOwner = self:OnDragonOwnerChange(nOwnerIdx)
	elseif szMainType == "food" then
		local nIdx = szSubType == "t" and 1 or 2
		nOldOwner = self:OnFoodOwnerChange(nIdx, nOwnerIdx)
	elseif szMainType == "wood" then
		local nIdx = szSubType == "t" and 1 or 2
		nOldOwner = self:OnWoodOwnerChange(nIdx, nOwnerIdx)
	end

	if nOldOwner and nOldOwner > 0 then
		local szMsg = string.format("Bên ta %s Bị quân địch công chiếm！", tbCfg.name)
		self:SendBlackBoardMsgToIdx(nOldOwner, szMsg)
	end

	Log("KinEncounter.tbFightMapLogic:OnNpcDeath", pKiller.dwPlayerID, szMainType, szSubType)
end

function tbFightMapLogic:OnDragonOwnerChange(nNewOwner)
	local nOldOwner = self.nDragonOwner
	self.nDragonOwner = nNewOwner

	local nNow = GetTime()
	self.tbScoreIncV = {0, 0}
	self.tbScoreIncV[nNewOwner] = math.max(0, (KinEncounter.Def.nMaxScore - self.tbScores[nNewOwner]) / math.max(KinEncounter.Def.nKeepTime, self.nEndTime - nNow))
	Log("tbFightMapLogic:OnDragonOwnerChange", nOldOwner, nNewOwner, nNow, self.nEndTime, self.tbScores[nNewOwner], self.tbScoreIncV[nNewOwner])
	return nOldOwner
end

function tbFightMapLogic:OnFoodOwnerChange(nIdx, nNewOwner)
	local nOldOwner = self.tbFoodOwner[nIdx]
	self.tbFoodOwner[nIdx] = nNewOwner

	local tbKinFoodCount = {}
	for i, nKinId in ipairs(self.tbKins) do
		local nCount = 0
		for _, nOwner in ipairs(self.tbFoodOwner) do
			if nOwner == i then
				nCount = nCount + 1
			end
		end
		tbKinFoodCount[nKinId] = nCount
		KPlayer.MapBoardcastScriptByFuncName(self.nMapId, "KinEncounter:OnFightDataChange", nKinId, {nFood = nCount})
	end

	local tbPlayer = KPlayer.GetMapPlayer(self.nMapId)
	local nBuffId, nBuffLvl = unpack(KinEncounter.Def.tbFoodBuff)
	local nBuffEndTime = GetTime() + 25 * 60
	for _, pPlayer in ipairs(tbPlayer or {}) do
		local tbState = pPlayer.GetNpc().GetSkillState(nBuffId)
		if tbKinFoodCount[pPlayer.dwKinId] <= 0 then
			if tbState then
				pPlayer.RemoveSkillState(nBuffId)
			end
		else
			if not tbState then
				pPlayer.AddSkillState(nBuffId, nBuffLvl, 2, nBuffEndTime, 1, 1)
			end
		end
	end
	Log("tbFightMapLogic:OnFoodOwnerChange", nIdx, nOldOwner, nNewOwner, self.tbFoodOwner[1], self.tbFoodOwner[2])
	return nOldOwner
end

function tbFightMapLogic:OnWoodOwnerChange(nIdx, nNewOwner)
	local nOldOwner = self.tbWoodOwner[nIdx]
	self.tbWoodOwner[nIdx] = nNewOwner

	self.tbWoodIncV = {0, 0}
	for _, nOwner in ipairs(self.tbWoodOwner) do
		if nOwner > 0 then
			self.tbWoodIncV[nOwner] = self.tbWoodIncV[nOwner] + KinEncounter.Def.nWoodIncSpeed
			self.tbWoods[nOwner] = self.tbWoods[nOwner] + KinEncounter.Def.nWoodReward
		end
	end
	Log("tbFightMapLogic:OnWoodOwnerChange", nIdx, nOldOwner, nNewOwner, self.tbWoodIncV[1], self.tbWoodIncV[2])
	return nOldOwner
end

function tbFightMapLogic:MakeTool(pPlayer, nNpcTempId, nCount)
	if not nCount or nCount <= 0 then
		Log("[x] tbFightMapLogic:MakeTool, count err", pPlayer.dwID, nNpcTempId, tostring(nCount))
		return
	end

	local nIdx = self:GetIdx(pPlayer.dwID)
	if nIdx <= 0 then
		Log("[x] tbFightMapLogic:MakeTool, no idx", pPlayer.dwID, nNpcTempId)
		return
	end

	local tbCfg = KinEncounter.Def.tbToolCfgs[nNpcTempId]
	if not tbCfg then
		Log("[x] tbFightMapLogic:MakeTool, no cfg", pPlayer.dwID, nNpcTempId)
		return
	end

	if not KinEncounter:IsKinManager(pPlayer.dwKinId, pPlayer.dwOrgPlayerId) then
		pPlayer.CenterMsg("Cho phép quyền không đủ")
		return
	end

	local nTotalPrice = tbCfg.nPrice * nCount
	if self.tbWoods[nIdx] < nTotalPrice then
		pPlayer.CenterMsg("Trước mắt cũng không đủ vật liệu gỗ！")
		return
	end
	self.tbWoods[nIdx] = self.tbWoods[nIdx] - nTotalPrice
	self.tbToolStocks[nIdx][nNpcTempId] = (self.tbToolStocks[nIdx][nNpcTempId] or 0) + nCount

	pPlayer.CenterMsg(string.format("Thành công kiến tạo %s Cái %s！", nCount, KNpc.GetNameByTemplateId(nNpcTempId)))
	Log("tbFightMapLogic:MakeTool", pPlayer.dwID, nNpcTempId, nCount, nIdx, nTotalPrice, self.tbWoods[nIdx], self.tbToolStocks[nIdx][nNpcTempId])
end

function tbFightMapLogic:GetTool(pPlayer, nNpcTempId)
	local nIdx = self:GetIdx(pPlayer.dwID)
	if nIdx <= 0 then
		Log("[x] tbFightMapLogic:GetTool, no idx", pPlayer.dwID, nNpcTempId)
		return
	end

	local tbCfg = KinEncounter.Def.tbToolCfgs[nNpcTempId]
	if not tbCfg then
		Log("[x] tbFightMapLogic:GetTool, no cfg", pPlayer.dwID, nNpcTempId)
		return
	end

	if not KinEncounter:IsKinManager(pPlayer.dwKinId, pPlayer.dwOrgPlayerId) then
		pPlayer.CenterMsg("Cho phép quyền không đủ")
		return
	end

	local szNpcName = KNpc.GetNameByTemplateId(nNpcTempId)
	if (self.tbToolStocks[nIdx][nNpcTempId] or 0) < 1 then
		pPlayer.CenterMsg(string.format("Trước mắt cũng không đủ số lượng %s！", szNpcName))
		return
	end

	if self:GetToolAliveCount(nIdx, nNpcTempId) >= tbCfg.nMaxAlive then
		pPlayer.CenterMsg(string.format("Trước mắt bang phái có được %s Đã đạt về số lượng hạn!", szNpcName))
		return
	end

	local nMapId, nX, nY = pPlayer.GetWorldPos()
	local pNpc = KNpc.Add(nNpcTempId, 1, 0, nMapId, nX, nY, 0, 0)
	if not pNpc then
		Log("[x] tbFightMapLogic:GetTool, add fail", pPlayer.dwID, nNpcTempId, nIdx, nMapId, nX, nY)
		return
	end

	self.tbToolReady[nIdx][nNpcTempId] = (self.tbToolReady[nIdx][nNpcTempId] or 0) + 1
	self.tbToolStocks[nIdx][nNpcTempId] = self.tbToolStocks[nIdx][nNpcTempId] - 1
	pNpc.nOwner = nIdx
	pNpc.SetTitle(KinEncounter:GetKinName(self.tbKins[nIdx]))
	pPlayer.CenterMsg(string.format("Thành công nhận lấy %s, nhanh đi sử dụng đi!", szNpcName))

	Log("tbFightMapLogic:GetTool", pPlayer.dwID, nNpcTempId, nIdx)
	return true
end

function tbFightMapLogic:OnUseTool(pPlayer, nNpcTempId)
	local nIdx = self:GetIdx(pPlayer.dwID)
	if nIdx <= 0 then
		Log("[x] tbFightMapLogic:OnUseTool", pPlayer.dwID, nNpcTempId, nIdx)
		return
	end

	self.tbToolReady[nIdx][nNpcTempId] = self.tbToolReady[nIdx][nNpcTempId] - 1
	self.tbToolUsing[nIdx][nNpcTempId] = self.tbToolUsing[nIdx][nNpcTempId] or {}
	self.tbToolUsing[nIdx][nNpcTempId][pPlayer.dwID] = true
	Log("tbFightMapLogic:OnUseTool", pPlayer.dwID, nNpcTempId, nIdx, self.tbToolReady[nIdx][nNpcTempId], Lib:CountTB(self.tbToolUsing[nIdx][nNpcTempId]))
end

function tbFightMapLogic:GetToolAliveCount(nIdx, nNpcTempId)
	for nPlayerId in pairs(self.tbToolUsing[nIdx][nNpcTempId] or {}) do
		local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
		if pPlayer and pPlayer.GetNpc().nShapeShiftNpcTID == 0 then
			self.tbToolUsing[nIdx][nNpcTempId][nPlayerId] = nil
		end
	end
	return (self.tbToolReady[nIdx][nNpcTempId] or 0) + (Lib:CountTB(self.tbToolUsing[nIdx][nNpcTempId] or {}))
end

function tbFightMapLogic:GetToolInfo(pPlayer)
	local nIdx = self:GetIdx(pPlayer.dwID)
	if nIdx <= 0 then
		Log("[x] tbFightMapLogic:GetToolInfo", pPlayer.dwID)
		return
	end

	local tbRet = {}
	for nNpcTempId in pairs(KinEncounter.Def.tbToolCfgs) do
		tbRet[nNpcTempId] = {self.tbToolStocks[nIdx][nNpcTempId] or 0, self:GetToolAliveCount(nIdx, nNpcTempId)}	--库存, in use
	end
	return tbRet
end

function tbFightMapLogic:OnCreateChatRoom(dwKinId)
	local nIdx = 0
	for i, nKinId in ipairs(self.tbKins) do
		if nKinId == dwKinId then
			nIdx = i
			break
		end
	end
	if nIdx <= 0 then
		Log("[x] tbFightMapLogic:OnCreateChatRoom, idx 0", tostring(dwKinId), tostring(nIdx), self.tbKins[1], self.tbKins[2])
		return false
	end

	for nPlayerId in pairs(self.tbMembers[nIdx]) do
		local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
		if pPlayer then
			local nPrivilege = KinEncounter:IsKinManager(dwKinId, pPlayer.dwOrgPlayerId) and ChatMgr.RoomPrivilege.emSpeaker or ChatMgr.RoomPrivilege.emAudience
			Kin:JoinChatRoom(pPlayer, nPrivilege)
		end
	end
	return true
end