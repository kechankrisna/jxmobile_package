if not MODULE_ZONESERVER then
    return
end

local tbValidReqs = {
	UpdateRank = true,
	MakeTool = true,
	GetTool = true,
	UpdateToolInfo = true,
}
function KinEncounter:OnClientReq(pPlayer, szType, ...)
	Log("KinEncounterZ:OnClientReq", szType, ...)
	if not tbValidReqs[szType] then
		Log("[x] KinEncounter:OnClientReq", pPlayer.dwID, szType)
		return
	end

	local fn = self[szType]
	if not fn then
		Log("[x] KinEncounter:OnClientReq, not imp", pPlayer.dwID, szType)
		return
	end

	local bOk, szErr = fn(self, pPlayer, ...)
	if not bOk then
		if szErr and szErr ~= "" then
			pPlayer.CenterMsg(szErr)
		end
		return
	end
end

function KinEncounter:UpdateRank(pPlayer)
	local tbLogic = KinEncounter:GetFightMapLogic(pPlayer.nMapId)
	if not tbLogic then
		Log("[x] KinEncounter:UpdateRank", pPlayer.nMapId, pPlayer.dwID)
		return
	end

	local tbRank = tbLogic:GetShowRank(pPlayer)
	pPlayer.CallClientScript("KinEncounter:OnKillRankDataChange", tbRank)
end

function KinEncounter:MakeTool(pPlayer, nNpcTempId, nCount)
	local tbLogic = KinEncounter:GetFightMapLogic(pPlayer.nMapId)
	if not tbLogic then
		Log("[x] KinEncounter:MakeTool", pPlayer.nMapId, pPlayer.dwID, nNpcTempId, nCount)
		return
	end
	tbLogic:MakeTool(pPlayer, nNpcTempId, nCount)
	self:UpdateToolInfo(pPlayer)
end

function KinEncounter:GetTool(pPlayer, nNpcTempId)
	local tbLogic = KinEncounter:GetFightMapLogic(pPlayer.nMapId)
	if not tbLogic then
		Log("[x] KinEncounter:GetTool", pPlayer.nMapId, pPlayer.dwID, nNpcTempId)
		return
	end
	
	if not tbLogic:GetTool(pPlayer, nNpcTempId) then
		return
	end
	self:UpdateToolInfo(pPlayer)
end

function KinEncounter:UpdateToolInfo(pPlayer)
	local tbLogic = KinEncounter:GetFightMapLogic(pPlayer.nMapId)
	if not tbLogic then
		Log("[x] KinEncounter:UpdateToolInfo", pPlayer.nMapId, pPlayer.dwID, nNpcTempId)
		return
	end

	local tbInfo = tbLogic:GetToolInfo(pPlayer)
	if not tbInfo then
		return
	end
	pPlayer.CallClientScript("KinEncounter:OnUpdateToolInfo", tbInfo)
end

function KinEncounter:InitData()
	self.tbFightMapInfo = {}
	self.tbPrepareMapLogics = {}
	self.tbFightMapLogics = {}
	self.tbKinInfos = {}
end

function KinEncounter:OnNotifyZoneStart()
	local nNow = GetTime()
	Log("KinEncounter:OnNotifyZoneStart", nNow, tostring(self.nNotifyZoneStartDeadline))
	if nNow <= (self.nNotifyZoneStartDeadline or 0) then
		return
	end
	self.nNotifyZoneStartDeadline = nNow + self.Def.nPrepareTime + self.Def.nFightWaitTime + self.Def.nFightTime + self.Def.nDelayKickoutTime
	self:StartZone()
end

function KinEncounter:StartZone()
	self.nStartTime = GetTime()
	self.Def.nFightWaitTime = math.max(self.Def.nFightWaitTime, self.Def.nReadyGoWaitTime)
	self:InitData()
	CreateMap(self.Def.nPrepareMapId)

	CallZoneClientScript(-1, "KinEncounter:QueryMaxLevel")
	Log("KinEncounter:StartZone")
end

function KinEncounter:OnQueryMaxLevelRsp(nNpcLevel, nBuffLevel)
	if nNpcLevel > (self.nNpcLevel or 0) then
		self.nNpcLevel = nNpcLevel
	end
	if nBuffLevel > (self.nBuffLevel or 0) then
		self.nBuffLevel = nBuffLevel
	end
	Log("KinEncounter:OnQueryMaxLevelRsp", nNpcLevel, nBuffLevel, self.nNpcLevel, self.nBuffLevel)
end

function KinEncounter:TransferToFightMap(nKinA, nKinB, tbMemberA, tbMemberB)
	local nMapId = CreateMap(self.Def.nFightMapId)
	self.tbFightMapInfo[nMapId] = {nKinA, nKinB, Lib:CopyTB(tbMemberA), Lib:CopyTB(tbMemberB)}
end

function KinEncounter:SetPrepareMapLogic(nMapId, tbLogic)
	self.tbPrepareMapLogics[nMapId] = tbLogic
end

function KinEncounter:SetFightMapLogic(nMapId, tbLogic)
	self.tbFightMapLogics[nMapId] = tbLogic
	if not tbLogic then
		self.tbFightMapInfo[nMapId] = nil
	end
end

function KinEncounter:GetPrepareMapLogic(nMapId)
	return self.tbPrepareMapLogics[nMapId]
end

function KinEncounter:GetFightMapLogic(nMapId)
	return self.tbFightMapLogics[nMapId]
end

function KinEncounter:QueryKinInfo(pPlayer, nZoneKinId)
	if self.tbKinInfos[nZoneKinId] then
		return
	end
	CallZoneClientScript(pPlayer.nZoneIndex, "KinEncounter:OnZoneQueryKinInfo", nZoneKinId, pPlayer.dwOrgKinId)
end

function KinEncounter:OnQueryKinInfoRsp(nKinId, tbInfo)
	self.tbKinInfos[nKinId] = {
		szName = tbInfo.szName,
		tbManagers = tbInfo.tbManagers,
		tbLastKins = tbInfo.tbLastKins,
	}
end

function KinEncounter:GetKinIdKey(nZoneKinId)
	local nServerId, nOrgKinId = KPlayer.GetOrgKinIdByZoneId(nZoneKinId)
	return string.format("%d-%d", nServerId, nOrgKinId)
end

function KinEncounter:IsMatchedBefore(nKinId1, nKinId2)
	local tbKinInfo = self.tbKinInfos[nKinId1]
	if not tbKinInfo then
		return false
	end

	local szKey = self:GetKinIdKey(nKinId2)
	return Lib:IsInArray(tbKinInfo.tbLastKins or {}, szKey)
end

function KinEncounter:SetKinFightMapId(nKinId, nMapId)
	self.tbKinInfos[nKinId] = self.tbKinInfos[nKinId] or {}
	self.tbKinInfos[nKinId].nFightMapId = nMapId
end

function KinEncounter:GetKinName(nKinId)
	local tbKin = self.tbKinInfos[nKinId]
	return tbKin and tbKin.szName or "-"
end

function KinEncounter:IsKinManager(nKinId, nOrgPlayerId)
	local tbKinInfo = self.tbKinInfos[nKinId] or {}
	local tbManagers = tbKinInfo.tbManagers or {}
	return Lib:IsInArray(tbManagers, nOrgPlayerId)
end

function KinEncounter:GetResNpcCfg(szMainType, szSubType)
	local tbMain = self.Def.tbMapResNpcs[szMainType]
	if not tbMain then
		return
	end
	return tbMain[szSubType]
end

function KinEncounter:OnCreateChatRoom(dwKinId)
	if not self:IsRunning() then
		return false
	end
	
	local tbKinInfo = self.tbKinInfos[dwKinId]
	if not tbKinInfo then
		Log("[x] KinEncounter:OnCreateChatRoom, no kininfo", dwKinId)
		return false
	end

	local tbLogic = self:GetFightMapLogic(tbKinInfo.nFightMapId or 0)
	if not tbLogic then
		Log("[x] KinEncounter:OnCreateChatRoom, no logic", dwKinId, tostring(tbKinInfo.nFightMapId))
		return false
	end
	return tbLogic:OnCreateChatRoom(dwKinId)
end