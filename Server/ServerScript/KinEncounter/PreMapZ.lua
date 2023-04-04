if not MODULE_ZONESERVER then
    return
end

KinEncounter.tbPrepareMapLogic = KinEncounter.tbPrepareMapLogic or {}
local tbPrepareMapLogic = KinEncounter.tbPrepareMapLogic

--
--准备地图
--
local tbPreMap = Map:GetClass(KinEncounter.Def.nPrepareMapId)
function tbPreMap:OnCreate(nMapId)
	local tbLogic = Lib:NewClass(tbPrepareMapLogic)
	tbLogic:Init(nMapId)

	KinEncounter:SetPrepareMapLogic(nMapId, tbLogic)
    Log("KinEncounter.tbPreMap:OnCreate", nMapId)
end

function tbPreMap:OnDestroy(nMapId)
	KinEncounter:SetPrepareMapLogic(nMapId, nil)
    Log("KinEncounter.tbPreMap:OnDestroy", nMapId)
end

function tbPreMap:OnEnter(nMapId)
	local tbLogic = KinEncounter:GetPrepareMapLogic(nMapId)
	if not tbLogic then
		Log("[x] KinEncounter.tbPreMap:OnEnter", nMapId)
		return
	end
	tbLogic:OnEnterMap(me)
end

function tbPreMap:OnLeave(nMapId)
	local tbLogic = KinEncounter:GetPrepareMapLogic(nMapId)
	if not tbLogic then
		Log("[x] KinEncounter.tbPreMap:OnLeave", nMapId)
		return
	end
	tbLogic:OnLeaveMap(me)
end

function tbPreMap:OnLogin(nMapId)
end

--
--Logic
--
function tbPrepareMapLogic:Init(nMapId)
	self.nMapId = nMapId
	self.nCreateTime = GetTime()
	self.tbKins = {}
	self.tbMembers = {}
	self.fnEnterPos = Lib:GetRandomSelect(#KinEncounter.Def.tbPreMapEnterPos)
	Timer:Register(Env.GAME_FPS * KinEncounter.Def.nPrepareTime, self.OnTimeout, self)

	CallZoneClientScript(-1, "KinEncounter:OnPrepareMapCreated", self.nMapId)
end

function tbPrepareMapLogic:OnEnterMap(pPlayer)
    pPlayer.nInBattleState = 1
    pPlayer.nCanLeaveMapId = self.nMapId
    pPlayer.SetPosition(unpack(self:GetEnterPos()))

    local nKinId = pPlayer.dwKinId
	if not nKinId or nKinId <= 0 then
		Log("[x] KinEncounter.tbPrepareMapLogic:OnEnterMap", pPlayer.dwID, tostring(nKinId))
		return
	end

	KinEncounter:QueryKinInfo(pPlayer, nKinId)

	self.tbKins[nKinId] = self.tbKins[nKinId] or {}
	self.tbKins[nKinId][pPlayer.dwID] = true
	self.tbMembers[pPlayer.dwID] = nKinId

	self:UpdatePlayerInfo({pPlayer})
	if not self.nInfoTimerId then
		self.nInfoTimerId = Timer:Register(Env.GAME_FPS * KinEncounter.Def.nPrepareMapUpdateInfoTime, function() return self:UpdatePlayerInfo() end)
	end

	Log("KinEncounter.tbPrepareMapLogic:OnEnterMap", nKinId, pPlayer.dwID)
end

function tbPrepareMapLogic:OnLeaveMap(pPlayer)
    pPlayer.nInBattleState = 0

    local nKinId = pPlayer.dwKinId
	if not nKinId or nKinId <= 0 then
		Log("[x] KinEncounter.tbPrepareMapLogic:OnLeaveMap", pPlayer.dwID, tostring(nKinId))
		return
	end

	self.tbKins[nKinId] = self.tbKins[nKinId] or {}
	self.tbKins[nKinId][pPlayer.dwID] = nil
	if not next(self.tbKins[nKinId]) then
		self.tbKins[nKinId] = nil
	end
	self.tbMembers[pPlayer.dwID] = nil

	Log("KinEncounter.tbPrepareMapLogic:OnLeaveMap", nKinId, pPlayer.dwID)
end

function tbPrepareMapLogic:UpdatePlayerInfo(tbPlayer)
	local nTimeLeft = math.max(self.nCreateTime + KinEncounter.Def.nPrepareTime - GetTime(), 0)
	if nTimeLeft <= 0 then
		self.nInfoTimerId = nil
		return
	end

	tbPlayer = tbPlayer or KPlayer.GetMapPlayer(self.nMapId)
	if #tbPlayer <= 0 then
		self.nInfoTimerId = nil
		return
	end

	local nKinCount = Lib:CountTB(self.tbKins)
	for _, pPlayer in ipairs(tbPlayer) do
		local nKinId = pPlayer.dwKinId
		local nKinMemberCount = Lib:CountTB(self.tbKins[nKinId] or {})
		pPlayer.CallClientScript("KinEncounter:UpdatePreLeftInfo", {nTimeLeft, nKinCount, nKinMemberCount})
	end
	
	return true
end

function tbPrepareMapLogic:GetEnterPos()
	return KinEncounter.Def.tbPreMapEnterPos[self.fnEnterPos()]
end

function tbPrepareMapLogic:GetMatches(tbSortedKins)
	local tbMatches = {}
	local tbUsed = {}
	for _, nKinId in ipairs(tbSortedKins) do
		if not tbUsed[nKinId] then
			tbUsed[nKinId] = true
			local bFound = false
			local nFirstMatchedKin = nil
			for _, nKinId2 in ipairs(tbSortedKins) do
				if not tbUsed[nKinId2] then
					local bMatched = KinEncounter:IsMatchedBefore(nKinId, nKinId2)
					if not bMatched then
						tbUsed[nKinId2] = true
						table.insert(tbMatches, {nKinId, nKinId2})
						bFound = true
						break
					else
						Log("tbPrepareMapLogic:GetMatches, matched before", nKinId, nKinId2)
						nFirstMatchedKin = nFirstMatchedKin or nKinId2
					end
				end
			end
			if not bFound then
				if nFirstMatchedKin and nFirstMatchedKin > 0 then
					tbUsed[nFirstMatchedKin] = true
					table.insert(tbMatches, {nKinId, nFirstMatchedKin})
					Log("tbPrepareMapLogic:GetMatches, rematch", nKinId, nFirstMatchedKin)
				else
					Log("[x] tbPrepareMapLogic:GetMatches, nFirstMatchedKin nil", nKinId, tostring(nFirstMatchedKin))
				end
			end
		end
	end
	return tbMatches
end

function tbPrepareMapLogic:OnTimeout()
	local tbPlayer = KPlayer.GetMapPlayer(self.nMapId)
	for _, pPlayer in ipairs(tbPlayer or {}) do
		pPlayer.nCanLeaveMapId = nil
	end

	CallZoneClientScript(-1, "KinEncounter:OnPrepareOver")
	local tbSortedKins, nSingleKin, tbInvalidKins = self:GetSortedKins()
	local tbMatches = self:GetMatches(tbSortedKins)
	Log("tbPrepareMapLogic:OnTimeout", #tbMatches)
	Lib:LogTB(tbMatches)

	local nCountPerFrame = 1
	local nCount = 0
	for _, tbMatch in pairs(tbMatches) do
		local nKinA, nKinB = unpack(tbMatch)
		local function fnTransfer(nKinA, nKinB)
			local tbMembersA = self.tbKins[nKinA]
			local tbMembersB = self.tbKins[nKinB]
			KinEncounter:TransferToFightMap(nKinA, nKinB, tbMembersA, tbMembersB)
		end
		nCount = nCount + 1
		Timer:Register(math.ceil(nCount / nCountPerFrame), fnTransfer, nKinA, nKinB)
	end

	self:DealWithSingleKin(nSingleKin)
	self:DealWithInvalidKins(tbInvalidKins)
end

function tbPrepareMapLogic:DealWithInvalidKins(tbKins)
	if not next(tbKins or {}) then
		return
	end

	for _, nKin in ipairs(tbKins) do
		local nZoneIdx = nil
		local tbPlayers = self.tbKins[nKin] or {}
		local tbPlayerOrgIds = {}
		for nPlayerId in pairs(tbPlayers) do
			local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
			if pPlayer then
				table.insert(tbPlayerOrgIds, pPlayer.dwOrgPlayerId)
				if not nZoneIdx then
					nZoneIdx = pPlayer.nZoneIndex
				end
				pPlayer.ZoneLogout()
			else
				Log("[x] KinEncounter.tbPrepareMapLogic:DealWithInvalidKins", nKin, nPlayerId)
			end
		end

		if nZoneIdx then
			CallZoneClientScript(nZoneIdx, "KinEncounter:OnInvalid", tbPlayerOrgIds)
		end
		Log("KinEncounter.tbPrepareMapLogic:DealWithInvalidKins", nKin)
	end
end

function tbPrepareMapLogic:DealWithSingleKin(nKin)
	if not nKin or nKin <= 0 then
		return
	end

	local nZoneIdx = nil
	local tbPlayers = self.tbKins[nKin] or {}
	local tbPlayerOrgIds = {}
	for nPlayerId in pairs(tbPlayers) do
		local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
		if pPlayer then
			table.insert(tbPlayerOrgIds, pPlayer.dwOrgPlayerId)
			if not nZoneIdx then
				nZoneIdx = pPlayer.nZoneIndex
			end
			pPlayer.ZoneLogout()
		else
			Log("[x] KinEncounter.tbPrepareMapLogic:DealWithSingleKin", nKin, nPlayerId)
		end
	end

	if nZoneIdx then
		CallZoneClientScript(nZoneIdx, "KinEncounter:OnSingle", tbPlayerOrgIds)
	end
	Log("KinEncounter.tbPrepareMapLogic:DealWithSingleKin", nKin)
end

function tbPrepareMapLogic:GetSortedKins()
	local tbKinIds = {}
	local tbAvgFightPowers = {}
	local tbMemberCounts = {}
	local tbInvalidKins = {}
	for nKinId, tbMembers in pairs(self.tbKins) do
		local nMemberCount = 0
		local nTotalFightPower = 0
		for nPlayerId in pairs(tbMembers) do
			local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
			if pPlayer then
				nTotalFightPower = nTotalFightPower + pPlayer.GetFightPower()
				nMemberCount = nMemberCount + 1
			end
		end

		if nMemberCount >= KinEncounter.Def.nMinKinMemberCount then
			table.insert(tbKinIds, nKinId)
			tbMemberCounts[nKinId] = nMemberCount
			tbAvgFightPowers[nKinId] = nTotalFightPower/nMemberCount
		else
			table.insert(tbInvalidKins, nKinId)
		end
	end
	Log("KinEncounter.tbPrepareMapLogic:GetSortedKins tbAvgFightPowers")
	Lib:LogTB(tbAvgFightPowers)
	Log("KinEncounter.tbPrepareMapLogic:GetSortedKins tbMemberCounts")
	Lib:LogTB(tbMemberCounts)
	Log("KinEncounter.tbPrepareMapLogic:GetSortedKins tbInvalidKins")
	Lib:LogTB(tbInvalidKins)

	table.sort(tbKinIds, function(nKin1, nKin2)
		local nFight1 = tbAvgFightPowers[nKin1]
		local nFight2 = tbAvgFightPowers[nKin2]
		return nFight1 > nFight2 or (nFight1 == nFight2 and nKin1 < nKin2)
	end)
	local tbFightPowerRank = {}
	for nRank, nKin in ipairs(tbKinIds) do
		tbFightPowerRank[nKin] = nRank
	end
	Log("KinEncounter.tbPrepareMapLogic:GetSortedKins tbFightPowerRank")
	Lib:LogTB(tbFightPowerRank)

	table.sort(tbKinIds, function(nKin1, nKin2)
		local nCount1 = tbMemberCounts[nKin1]
		local nCount2 = tbMemberCounts[nKin2]
		return nCount1 > nCount2 or (nCount1 == nCount2 and nKin1 < nKin2)
	end)
	local tbMemberCountRank = {}
	for nRank, nKin in ipairs(tbKinIds) do
		tbMemberCountRank[nKin] = nRank
	end
	Log("KinEncounter.tbPrepareMapLogic:GetSortedKins tbMemberCountRank")
	Lib:LogTB(tbMemberCountRank)

	table.sort(tbKinIds, function(nKin1, nKin2)
		local nTotalRank1 = tbFightPowerRank[nKin1] + tbMemberCountRank[nKin1]
		local nTotalRank2 = tbFightPowerRank[nKin2] + tbMemberCountRank[nKin2]
		return nTotalRank1 < nTotalRank2 or (nTotalRank1 == nTotalRank2 and nKin1 < nKin2)
	end)
	Log("KinEncounter.tbPrepareMapLogic:GetSortedKins tbKinIds", #tbKinIds)
	Lib:LogTB(tbKinIds)

	if #tbKinIds % 2 == 0 then
		return tbKinIds, nil, tbInvalidKins
	end
	local nSingle = table.remove(tbKinIds)
	Log("KinEncounter.tbPrepareMapLogic:GetSortedKins, single", nSingle)
	return tbKinIds, nSingle, tbInvalidKins
end