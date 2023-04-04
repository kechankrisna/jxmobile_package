local tbDef = JueXue.Def
function JueXue:ActivateArea(pPlayer, item)
	local bRet, szMsg, nAreaId = self:CheckCanActivateArea(pPlayer, item)
	if not bRet then
		pPlayer.CenterMsg(szMsg or "")
		return
	end

	if pPlayer.ConsumeItemInAllPos(tbDef.nActivateTemplateId, tbDef.nActivateConsume, Env.LogWay_JueXue) ~= tbDef.nActivateConsume then
		pPlayer.CenterMsg("Tiêu hao thất bại")
		return
	end

	local nDataBegin = self:GetAreaDataBegin(nAreaId)
	pPlayer.SetUserValue(tbDef.nDataGroup, nDataBegin + tbDef.nActivateFlag, 1)
	pPlayer.SetUserValue(tbDef.nDataGroup, nDataBegin + tbDef.nXiuLianLv, 1)
	pPlayer.CenterMsg("Khu tuyệt học khởi động thành công")
	Log("JueXue ActivateArea", pPlayer.dwID, nAreaId)

	self:ActivateLaterArea(pPlayer)
	pPlayer.CallClientScript("Player:ServerSyncData", "Evolve")
end

function JueXue:ActivateLaterArea(pPlayer)
	for nAreaId, tbInfo in pairs(tbDef.tbAreaInfo) do
		if not self:IsAreaActivate(pPlayer, nAreaId) and tbInfo.tbChildArea and #tbInfo.tbChildArea > 0 then
			local bAllActivate = true
			for _, nChildAreaId in pairs(tbInfo.tbChildArea) do
				if not self:IsAreaActivate(pPlayer, nChildAreaId) then
					bAllActivate = false
					break
				end
			end
			if bAllActivate then
				local nDataBegin = self:GetAreaDataBegin(nAreaId)
				pPlayer.SetUserValue(tbDef.nDataGroup, nDataBegin + tbDef.nActivateFlag, 1)
				pPlayer.SetUserValue(tbDef.nDataGroup, nDataBegin + tbDef.nXiuLianLv, 1)
				pPlayer.CenterMsg("Tất cả khu trước đã khởi động, nên tự động khởi động khu")
				Log("JueXue ActivateArea", pPlayer.dwID, nAreaId)
			end
		end
	end
end

function JueXue:XiuLian(pPlayer, nAreaId)
	local bRet, szMsg, nNeedMoney = self:CheckCanXiuLian(pPlayer, nAreaId)
	if not bRet then
		pPlayer.CenterMsg(szMsg or "")
		return
	end

	if not pPlayer.CostMoney(tbDef.szMoneyType, nNeedMoney, Env.LogWay_JueXue) then
		pPlayer.CenterMsg("Tiêu hao thất bại")
		return
	end
	local nSaveKey = self:GetAreaDataBegin(nAreaId) + tbDef.nXiuLianLv
	local nLevel   = self:GetCurXiuLianLv(pPlayer, nAreaId) + 1
	pPlayer.SetUserValue(tbDef.nDataGroup, nSaveKey, nLevel)
	pPlayer.CallClientScript("Player:ServerSyncData", "XiuLian")
	Log("JueXue XiuLian", pPlayer.dwID, nAreaId, nLevel)

	FightPower:ChangeFightPower("JueXue", pPlayer)
	local nPos    = Item.EQUIPPOS_JUEXUE_BEGIN + (nAreaId - 1) * tbDef.nAreaEquipPos
	local pJuexue = pPlayer.GetEquipByPos(nPos)
	if pJuexue then
		self:RefreshJuexueAttrib(pPlayer, pJuexue, nAreaId)
	end
end

function JueXue:OnUseEquip(pPlayer, pEquip)
	local bMiben
	if pEquip.szClass == "MibenBook" then
		self:OnUseMiben(pPlayer, pEquip)
		bMiben = true
	elseif pEquip.szClass == "DuanpianBook" then
		self:OnUseDuanpian(pPlayer, pEquip)
	else
		return
	end

	local nPos = self:TransforEquipPos(pEquip.nPos)
	if not nPos then
		Log("JueXue OnUseEquip, Use Equip In Error Pos",  pPlayer.dwID, pEquip.szClass, pEquip.dwTemplateId, pEquip.nPos)
		return
	end
	local nAreaId    = math.ceil(nPos/tbDef.nAreaEquipPos)
	local nJuexuePos = Item.EQUIPPOS_JUEXUE_BEGIN + (nAreaId - 1) * tbDef.nAreaEquipPos
	local pJuexue    = pPlayer.GetEquipByPos(nJuexuePos)
	if pJuexue then
		JueXue:RefreshJuexueAttrib(pPlayer, pJuexue, nAreaId)
	end
	if bMiben then
		self:RefreshParentArea(pPlayer, nAreaId)
	end
end

function JueXue:OnUseMiben(pPlayer, pMiben)
	local nPos = pMiben.nPos - Item.EQUIPPOS_JUEXUE_BEGIN + 1
	local tbDuanpian = tbDef.tbDpAroundMiben[nPos]
	if not tbDuanpian then
		return
	end

	for i, nDpPos in pairs(tbDuanpian) do
		local nAreaId = math.ceil(nDpPos/tbDef.nAreaEquipPos)
		if self:IsAreaActivate(pPlayer, nAreaId) then
			local nEquipPos = nDpPos + Item.EQUIPPOS_JUEXUE_BEGIN - 1
			local pDuanpian = pPlayer.GetEquipByPos(nEquipPos)
			if pDuanpian then
				local nAdd = pMiben.GetIntValue(tbDef.tbMibenItemData.nDuanpianAddBegin + i - 1)
				if nAdd ~= 0 then
					local nLastAdd = pDuanpian.GetIntValue(tbDef.tbDuanpianItemData.nMibenAdd) + nAdd
					pDuanpian.SetIntValue(tbDef.tbDuanpianItemData.nMibenAdd, nLastAdd)
					pDuanpian.ReInit()
				end
			end
		end
	end
end

function JueXue:OnUseDuanpian(pPlayer, pDuanpian)
	local nPos = self:TransforEquipPos(pDuanpian.nPos)
	if not nPos then
		return
	end

	local nAreaId = math.ceil(nPos/tbDef.nAreaEquipPos)
	if not tbDef.tbAreaInfo[nAreaId] or not tbDef.tbAreaInfo[nAreaId].bSuit then
		return
	end

	local nSuitId = pDuanpian.GetIntValue(tbDef.tbDuanpianItemData.nSuitSkillId)
	if nSuitId <= 0 then
		return
	end

	pPlayer.tbDuanpianEquipPos = pPlayer.tbDuanpianEquipPos or {}
	pPlayer.tbDuanpianEquipPos[nPos] = nSuitId

	local nLen = self:GetPosAroundSuitLen(pPlayer, nAreaId, nPos, nSuitId)
	local nLevel, nExternGroup = self:GetDuanpianSkillLv(nSuitId, nLen)
	if nLevel > 0 then
		pPlayer.tbDuanpianCurSkillLv = pPlayer.tbDuanpianCurSkillLv or {}
		if not pPlayer.tbDuanpianCurSkillLv[nSuitId] or pPlayer.tbDuanpianCurSkillLv[nSuitId] < nLevel then
			pPlayer.tbDuanpianCurSkillLv[nSuitId] = nLevel
			pPlayer.ApplyExternAttrib(nExternGroup, nLevel)
		end
	end
	pPlayer.CallClientScript("JueXue:OnUseDuanpian", nPos, nSuitId, nExternGroup, nLevel)
end

function JueXue:RefreshParentArea(pPlayer, nAreaId)
	local nParentArea = tbDef.tbAreaInfo[nAreaId].nParentArea
	if not nParentArea then
		return
	end

	local nJuexuePos = Item.EQUIPPOS_JUEXUE_BEGIN + (nParentArea - 1) * tbDef.nAreaEquipPos
	local pJueXue    = pPlayer.GetEquipByPos(nJuexuePos)
	if pJueXue then
		JueXue:RefreshJuexueAttrib(pPlayer, pJueXue, nParentArea)
	end
end

function JueXue:OnUnuseEquip(pPlayer, nEquipPos, pItem)
	local bMiben
	local nPos = self:TransforEquipPos(nEquipPos)
	if not nPos then
		return
	end
	if tbDef.tbJuexuePos[nPos] then
		FightPower:ChangeFightPower("JueXue", pPlayer)
		return
	end
	if tbDef.tbDpAroundMiben[nPos] then
		self:OnUnuseMiben(pPlayer, nPos, pItem)
		bMiben = true
	else
		if pItem.GetIntValue(tbDef.tbDuanpianItemData.nMibenAdd) ~= 0 then
			pItem.SetIntValue(tbDef.tbDuanpianItemData.nMibenAdd, 0)
			pItem.ReInit()
		end
		self:OnUnuseDuanpian(pPlayer, nPos)
	end
	local nAreaId    = math.ceil(nPos/tbDef.nAreaEquipPos)
	local nJuexuePos = Item.EQUIPPOS_JUEXUE_BEGIN + (nAreaId - 1) * tbDef.nAreaEquipPos
	local pJueXue    = pPlayer.GetEquipByPos(nJuexuePos)
	if pJueXue then
		JueXue:RefreshJuexueAttrib(pPlayer, pJueXue, nAreaId)
	end
	if bMiben then
		self:RefreshParentArea(pPlayer, nAreaId)
	end
end

function JueXue:OnUnuseMiben(pPlayer, nPos, pMiben)
	for i, nDpPos in pairs(tbDef.tbDpAroundMiben[nPos] or {}) do
		local nAreaId = math.ceil(nDpPos/tbDef.nAreaEquipPos)
		if self:IsAreaActivate(pPlayer, nAreaId) then
			local nEquipPos = nDpPos + Item.EQUIPPOS_JUEXUE_BEGIN - 1
			local pDuanpian = pPlayer.GetEquipByPos(nEquipPos)
			if pDuanpian then
				local nAdd = pMiben.GetIntValue(tbDef.tbMibenItemData.nDuanpianAddBegin + i - 1)
				if nAdd ~= 0 then
					local nLastAdd = pDuanpian.GetIntValue(tbDef.tbDuanpianItemData.nMibenAdd) - nAdd
					pDuanpian.SetIntValue(tbDef.tbDuanpianItemData.nMibenAdd, nLastAdd)
					pDuanpian.ReInit()
				end
			end
		end
	end
end

function JueXue:GetSuitMaxLen(pPlayer, nSuitId)
	local nMaxLen = 0
	for nAreaId, tbInfo in pairs(tbDef.tbAreaInfo) do
		if tbInfo.bSuit and self:IsAreaActivate(pPlayer, nAreaId) then
			for i = tbDef.nDuanPianEquipStartPos, tbDef.nAreaEquipPos do
				local nPosSuit = pPlayer.tbDuanpianEquipPos[(nAreaId - 1) * tbDef.nAreaEquipPos + i]
				if nPosSuit == nSuitId then
					nMaxLen = nMaxLen + 1
				else
					nMaxLen = 0
				end
			end
		end
	end
	return nMaxLen
end

function JueXue:OnUnuseDuanpian(pPlayer, nPos)
	local nAreaId = math.ceil(nPos/tbDef.nAreaEquipPos)
	if not tbDef.tbAreaInfo[nAreaId] or not tbDef.tbAreaInfo[nAreaId].bSuit then
		nAreaId = nil
	end

	local nSuitId         = pPlayer.tbDuanpianEquipPos[nPos]
	local nCurSuitSkillLv = nSuitId and pPlayer.tbDuanpianCurSkillLv[nSuitId] or 0
	pPlayer.tbDuanpianEquipPos[nPos] = nil

	if nAreaId and nSuitId and nSuitId > 0 and nCurSuitSkillLv > 0 then
		local nLen   = self:GetPosAroundSuitLen(pPlayer, nAreaId, nPos, nSuitId)
		local nLevel = self:GetDuanpianSkillLv(nSuitId, nLen)
		if nLevel >= nCurSuitSkillLv then
			local nMaxLen = self:GetSuitMaxLen(pPlayer, nSuitId)
			local nThisLevel, nExternGroup = self:GetDuanpianSkillLv(nSuitId, nMaxLen)
			if nThisLevel ~= nCurSuitSkillLv then
				pPlayer.tbDuanpianCurSkillLv[nSuitId] = nThisLevel
				if nThisLevel > 0 then
					pPlayer.ApplyExternAttrib(nExternGroup, nThisLevel)
				else
					pPlayer.RemoveExternAttrib(nExternGroup)
				end
				pPlayer.CallClientScript("JueXue:OnUnuseDuanpian", nPos, nSuitId, nExternGroup, nThisLevel)
				return
			end
		end
	end
	pPlayer.CallClientScript("JueXue:OnUnuseDuanpian", nPos)
end

function JueXue:CheckChangeFaction(nOrgItem, nFaction)
	local nSoleTag = self:GetSoleTag(nOrgItem)
	if not nSoleTag then
		return
	end
	if nSoleTag == 0 then
		return nOrgItem
	end
	self.tbFaction = self.tbFaction or {}
	if not self.tbFaction[nSoleTag] then
		self.tbFaction[nSoleTag] = {} 
		for nTemplateId, tbTmp in pairs(self.tbJuexue) do
			if tbTmp.SoleTag == nSoleTag then
				self.tbFaction[nSoleTag][tbTmp.Faction] = nTemplateId
			end
		end
	end

	return self.tbFaction[nSoleTag][nFaction]
end

function JueXue:OnChangeFaction(pPlayer, nOrgFaction, nNewFaction)
	if nOrgFaction == nNewFaction then
		return
	end
	for nAreaId, _ in ipairs(tbDef.tbAreaInfo) do
		if self:IsAreaActivate(pPlayer, nAreaId) then
			local nPos  = Item.EQUIPPOS_JUEXUE_BEGIN + (nAreaId - 1) * tbDef.nAreaEquipPos
			local pItem = pPlayer.GetEquipByPos(nPos)
			if pItem then
				local nNewItem = self:CheckChangeFaction(pItem.dwTemplateId, nNewFaction)
				if nNewItem then
					if nNewItem ~= pItem.dwTemplateId then
						pItem.ReInit(nNewItem)
					end
				else
					Log("JueXue OnChangeFaction Err", pPlayer.dwID, pItem.dwTemplateId, nNewFaction)
				end
			end
		end
	end

	Log("JueXue OnChangeFaction", pPlayer.dwID, nOrgFaction, nNewFaction)
end

function JueXue:GetAllFightPower(pPlayer)
	local nStrength = 0
	for nAreaId, _ in pairs(tbDef.tbAreaInfo) do
		if self:IsAreaActivate(pPlayer, nAreaId) then
			local nBeginPos = Item.EQUIPPOS_JUEXUE_BEGIN - 1 + (nAreaId - 1) * tbDef.nAreaEquipPos
			for nEquipPos = 1, tbDef.nAreaEquipPos do
				local pEquip = pPlayer.GetEquipByPos(nBeginPos + nEquipPos)
				if pEquip then
					if nEquipPos == 1 then
						local nDataBegin = self:GetAreaDataBegin(nAreaId)
						local nLevel     = pPlayer.GetUserValue(tbDef.nDataGroup, nDataBegin + tbDef.nXiuLianLv)
						nStrength = nStrength + self:GetXiulianFightPower(nLevel)
					end
					nStrength = nStrength + pEquip.nFightPower
				end
			end
		end
	end
	return nStrength
end

JueXue.tbSafeFunc = {
	ActivateArea = true,
	XiuLian      = true,
}
function JueXue:OnClientCall(pPlayer, szFunc, ...)
	if not self.tbSafeFunc[szFunc] then
		return
	end
	self[szFunc](self, pPlayer, ...)
end