Require("CommonScript/DomainBattle/define.lua");
Require("CommonScript/DomainBattle/cross_common.lua");
Require("ServerScript/DomainBattle/cross_with_throne.lua");

DomainBattle.tbCrossKing = DomainBattle.tbCrossKing or Lib:NewClass(DomainBattle.tbCrossWithThrone)

local tbCrossDef = DomainBattle.tbCrossDef
local tbCrossWithThrone = DomainBattle.tbCrossWithThrone
local tbCrossKing = DomainBattle.tbCrossKing
local tbCross = DomainBattle.tbCross

tbCrossKing.tbTrapFun = Lib:CopyTB(tbCrossWithThrone.tbTrapFun or {})
tbCrossKing.tbOnSpawnNpcFun = Lib:CopyTB(tbCrossWithThrone.tbOnSpawnNpcFun or {})
tbCrossKing.tbOnNpcDeathFun = Lib:CopyTB(tbCrossWithThrone.tbOnNpcDeathFun or {})

function  tbCrossKing:init()
	self.tbKinCamp = {}
	self.tbKinPlayerCount = {}
	self.tbCampCfg = Lib:CopyTB(tbCross:GetCampCfg(self.nMapTemplateId));
	self.nCampAssignCounter = 0;
	Log("[Info]", "DomainBattleCross", "tbCrossKing:init")
end

function tbCrossKing:OnMapEnter()
	tbCrossWithThrone.OnMapEnter(self)

	local nPlayerId = me.dwID
	local tbPlayerInfo = tbCross:GetPlayerInfo(nPlayerId)
	if not tbPlayerInfo then
		Log("[Error]", "DomainBattleCross", "tbCrossKing:OnMapEnter Not Found PlayerInfo", nPlayerId, me.szName)
		return
	end

	local nKinId = tbPlayerInfo.nKinId

	self.tbKinPlayerCount[nKinId] = self.tbKinPlayerCount[nKinId] or 0
	self.tbKinPlayerCount[nKinId] = self.tbKinPlayerCount[nKinId] + 1
end

function tbCrossKing:OnMapLeave()
	tbCrossWithThrone.OnMapLeave(self)

	local nPlayerId = me.dwID
	local tbPlayerInfo = tbCross:GetPlayerInfo(nPlayerId)
	if not tbPlayerInfo then
		Log("[Error]", "DomainBattleCross", "tbCrossKing:OnMapLeave Not Found PlayerInfo", nPlayerId, me.szName)
		return
	end

	local nKinId = tbPlayerInfo.nKinId

	self.tbKinPlayerCount[nKinId] = self.tbKinPlayerCount[nKinId] or 0
	self.tbKinPlayerCount[nKinId] = self.tbKinPlayerCount[nKinId] - 1
end

function tbCrossKing:OnPillarAddScore(tbNpcInfo)
	tbCross:AddKinScore(tbNpcInfo.nOwnerKinId, 40);
	return true
end

function tbCrossKing:GetKinCamp(nKinId)
	return self.tbKinCamp[nKinId]
end

function tbCrossKing:ChangeKinCamp(nPlayerId, nCampIndex)
	local tbPlayerInfo = tbCross:GetPlayerInfo(nPlayerId)
	if not tbPlayerInfo then
		return
	end

	local tbKinInfo = tbCross:GetKinInfo(tbPlayerInfo.nKinId)
	if not tbKinInfo then
		return
	end

	if not self:GetKinCamp(tbKinInfo.nKinId)  then
		--如果还没营地不能更改
		return false, "Bản bang phái tại trong vương thành chưa thu hoạch được doanh địa, tạm thời không thể sửa đổi"
	end

	local tbCampInfo = self.tbCampCfg[nCampIndex]
	if not tbCampInfo then
		return
	end

	self.tbKinCamp[tbKinInfo.nKinId] = nCampIndex

	local function _ChangeRevivePos(pPlayer)
		local tbTmpPlayerInfo = tbCross:GetPlayerInfo(pPlayer.dwID);
		if tbTmpPlayerInfo and tbTmpPlayerInfo.nKinId == tbKinInfo.nKinId then
			pPlayer.SetTempRevivePos(self.nMapId, tbCampInfo.nX, tbCampInfo.nY);
		end
	end

	self:ForEachInMap(_ChangeRevivePos)

	local pReqPlayer = KPlayer.GetPlayerObjById(nPlayerId);
	if pReqPlayer then
		pReqPlayer.CenterMsg(string.format("Bang phái trước mắt trong vương thành doanh địa đã thay đổi thành「Doanh địa %s」 !", Lib:Transfer4LenDigit2CnNum(nCampIndex)), true)
	end

	tbCross:CallZoneClientScriptByKinId(tbKinInfo.nKinId, "ChatMgr:SendSystemMsg", ChatMgr.SystemMsgType.Kin,
				string.format("Bang phái trước mắt trong vương thành doanh địa đã thay đổi thành「Doanh địa %s」 !", Lib:Transfer4LenDigit2CnNum(nCampIndex)),
				tbKinInfo.nOrgKinId);

	return true
end

function tbCrossKing:TransferToKinCamp(nKinId, pPlayer)
	local nPlayerId = pPlayer.dwID
	local tbPlayerInfo = tbCross:GetPlayerInfo(nPlayerId)
	if not tbPlayerInfo then
		return
	end

	if tbPlayerInfo.bAid then
		pPlayer.CenterMsg("Trợ chiến hiệp sĩ không thể tiến về vương thành")
		return
	end

	local nPlayerCount = self.tbKinPlayerCount[nKinId] or 0
	if nPlayerCount >= tbCrossDef.nMaxKingPlayer then
		pPlayer.CenterMsg(string.format("Mỗi cái bang phái nhiều nhất %d Vị hiệp sĩ có thể tiến về vương thành", tbCrossDef.nMaxKingPlayer))
		return
	end

	local nCampIndex = self:GetKinCamp(nKinId)
	if not nCampIndex then
		nCampIndex = math.mod(self.nCampAssignCounter, Lib:CountTB(self.tbCampCfg)) + 1;
		self.tbKinCamp[nKinId] = nCampIndex
		self.nCampAssignCounter = self.nCampAssignCounter + 1
	end

	local nPosX, nPosY = self:GetCampPos(nCampIndex)
	if not nPosX then
		Log("[Error]", "DomainBattleCross", "TransferToKinCamp Failed Not Found Camp Pos", nCampIndex, nKinId, pPlayer.dwID)
		return
	end

	pPlayer.SwitchMap(self.nMapId, nPosX, nPosY)
end

function tbCrossKing:GetCampPos(nCampIndex)
	local tbCampInfo = self.tbCampCfg[nCampIndex]
	if not tbCampInfo then
		return
	end

	return tbCampInfo.nX, tbCampInfo.nY
end

function tbCrossKing:SyncKingTransferCountInfoReq(pPlayer, nVersion)
	local nPlayerId = pPlayer.dwID
	local tbPlayerInfo = tbCross:GetPlayerInfo(nPlayerId)
	if not tbPlayerInfo then
		return
	end

	local nKinId = tbPlayerInfo.nKinId
	local nCount = self.tbKinPlayerCount[nKinId] or 0
	if nVersion == nCount then
		return
	end

	pPlayer.CallClientScript("DomainBattle.tbCross:SyncKingTransferCountInfo", nCount)
end

function tbCrossKing:OnStartBattle()
	tbCrossWithThrone.OnStartBattle(self)
	local tbEnableTrap =
	{
		["ToOuter"] = true,
	}
	self:SetTrapEnableByTypeList(tbEnableTrap, true)
end

function tbCrossKing:OnInnerCityStart()
	self:SetTrapEnableByType("ToOuter", false)
end

function tbCrossKing:OnInnerCityEnd()
	self:SetTrapEnableByType("ToOuter", true)
end

function tbCrossKing:OnThroneAddScore()
	tbCrossWithThrone.OnThroneAddScore(self)
	tbCross:AddKinScore(self.nOccupyThroneKinId, 120);
	return true
end

function tbCrossKing:OnAfterOccupy(tbNpcInfo, nOwnerKinId)
	tbCrossWithThrone.OnAfterOccupy(self, tbNpcInfo, nOwnerKinId)

	if not self:IsAllPillarOccupied() then
		return
	end

	local pThrone = self:GetThroneNpc()
	if not pThrone then
		return
	end

	pThrone.RemoveSkillState(tbCrossDef.nThroneLockBuffId)

	local function _ThroneMsg(pPlayer)
		pPlayer.SendBlackBoardMsg("Bát Long trụ đều bị chiếm lĩnh, đã mở ra [FFFE0D] Vương tọa [-] Tranh đoạt, mời hoả tốc tiến về!");
	end

	self:ForEachInMap(_ThroneMsg)
end

function tbCrossKing:IsCanOccupyThrone()
	return self:IsAllPillarOccupied()
end

function tbCrossKing.tbTrapFun:ToPeace(pPlayer, tbTrapInfo)
	if not tbTrapInfo.bEnable then
		return
	end

	local tbPlayerInfo = tbCross:GetPlayerInfo(pPlayer.dwID)
	if not tbPlayerInfo then
		Log("[Error]", "DomainBattleCross", "tbCrossKing.tbTrapFun:ToPeace Failed No Player Info", pPlayer.dwID, pPlayer.szName, pPlayer.nFightMode)
		Lib:Tree(tbTrapInfo)
		return
	end

	local nCampIndex = self.tbKinCamp[tbPlayerInfo.nKinId]

	if not nCampIndex then
		Log("[Error]", "DomainBattleCross", "tbCrossKing.tbTrapFun:ToPeace Failed No Kin Camp Index", pPlayer.dwID, pPlayer.szName, pPlayer.nFightMode)
		Lib:Tree(tbPlayerInfo)
		Lib:Tree(tbTrapInfo)
		return
	end

	if nCampIndex ~= tbTrapInfo.nIndex then
		return
	end

	self:TrapToPeace(pPlayer, tbTrapInfo)
end

function tbCrossKing.tbTrapFun:ToOuter(pPlayer, tbTrapInfo)
	if not tbTrapInfo.bEnable then
		return
	end

	local nPlayerId =pPlayer.dwID
	local tbPlayerInfo = tbCross:GetPlayerInfo(nPlayerId)
	if not tbPlayerInfo then
		Log("[Error]", "DomainBattleCross", "tbCrossKing.tbTrapFun:ToOuter Failed Not Found PlayerInfo", nPlayerId)
		Lib:Tree(tbTrapInfo)
		return
	end

	local tbKinInfo = tbCross:GetKinInfo(tbPlayerInfo.nKinId)
	if not tbKinInfo then
		Log("[Error]", "DomainBattleCross", "tbCrossKing.tbTrapFun:ToOuter Failed Not Found KinInfo")
		Lib:Tree(tbTrapInfo)
		Lib:Tree(tbPlayerInfo)
		return
	end

	local nOuterMapId = tbKinInfo.nOuterMapId
	if not nOuterMapId then
		Log("[Error]", "DomainBattleCross", "tbCrossKing.tbTrapFun:ToOuter Failed No nOuterMapId")
		Lib:Tree(tbTrapInfo)
		Lib:Tree(tbPlayerInfo)
		Lib:Tree(tbKinInfo)
		return
	end

	local tbInnerInst = tbCross.tbInstList[nOuterMapId]
	tbInnerInst:TransferToKinCamp(tbPlayerInfo.nKinId, pPlayer);
end

function tbCrossKing.tbOnSpawnNpcFun:cross_domain_throne(tbNpcInfo, pNpc)
	if self.bStopBattle then
		return
	end

	if not self:IsAllPillarOccupied() then
		pNpc.AddSkillState(tbCrossDef.nThroneLockBuffId, 1,  0 , 10000000)
	end
	self:_ThroneSpawnFix(pNpc)
	tbCross:OnUpdateOccupySyncInfo(self.nMapId, tbNpcInfo, nil)
	self:UpdateMiniMapInfo(tbNpcInfo.szMiniMapSyncKey, "")
end

