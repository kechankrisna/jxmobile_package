local tbValidRequests = {
	Use = true,
	Quit = true,
}

function Toy:OnClientReq(pPlayer, szFunc, ...)
	if self.bForceClose then
		pPlayer.CenterMsg("Tạm thời đóng")
		return
	end

	if not self:CanUse(pPlayer) then
		return
	end

	if not tbValidRequests[szFunc] then
		Log("[x] pPlayer:OnRequest, invalid req", szFunc, ...)
		return
	end

	local func = self[szFunc]
	if not func then
		Log("[x] pPlayer:OnRequest, unknown req", szFunc, ...)
		return
	end

	local bSuccess, szErr = func(self, pPlayer, ...)
	if not bSuccess then
		if szErr and szErr ~= "" then
			pPlayer.CenterMsg(szErr)
		end
		return
	end
end

function Toy:Use(pPlayer, nId, ...)
	if not self:IsUnlocked(pPlayer, nId) then
		return false, "Đồ chơi này chưa được mở khóa"
	end

	if not self:IsFree(pPlayer) then
		return false, "Trạng thái này không thể được thực hiện trong trạng thái hiện tại"
	end

	local szClass = self:GetClass(nId)
	local bOk, szErr = self:DoUse(pPlayer, nId, szClass, ...)
	if bOk then
		self:IncUseCount(pPlayer, nId)
		pPlayer.CallClientScript("Toy:OnUseSuccess", nId)
	else
		return false, szErr
	end

	return true
end

function Toy:Quit(pPlayer)
	local nId = self:GetUsing(pPlayer)
	if not nId or nId <= 0 then
		return false
	end

	if not self:IsUnlocked(pPlayer, nId) then
		return false, "Đồ chơi này chưa được mở khóa"
	end

	local szClass = self:GetClass(nId)
	local bOk, szErr = self:DoQuit(pPlayer, nId, szClass)
	if not bOk then
		return false, szErr
	end

	self:SetUsing(pPlayer, nil)
	pPlayer.CallClientScript("Toy:OnQuitSuccess", nId)

	return true
end

function Toy:DoQuit(pPlayer, nId, szClass)
	if not szClass or szClass == "" then
		Log("[x] Toy:DoQuit, no class", pPlayer.dwID, nId, szClass)
		return false, "Lỗi cài đặt đạo cụ"
	end

	local f = self["Quit_"..szClass]
	if not f then
		Log("[x] Toy:DoQuit, no impl", pPlayer.dwID, nId, szClass)
		return false
	end

	return f(self, pPlayer)	
end

function Toy:DoUse(pPlayer, nId, szClass, ...)
	if not szClass or szClass == "" then
		Log("[x] Toy:DoUse, no class", pPlayer.dwID, nId, szClass, ...)
		return false, "Lỗi cài đặt đạo cụ"
	end

	local f = self["Use_"..szClass]
	if not f then
		Log("[x] Toy:DoUse, no impl", pPlayer.dwID, nId, szClass, ...)
		return false
	end

	return f(self, pPlayer, nId, ...)
end

function Toy:Use_ToyWindmill(pPlayer, nId)
	self:ChangeFeature(pPlayer, self.Def.nWindmillResId)
	self:SetUsing(pPlayer, nId)
	return true
end

function Toy:Quit_ToyWindmill(pPlayer)
	self:RestoreFeature(pPlayer)
	return true
end

function Toy:Use_ToyChild(pPlayer, nId)
	self:ChangeFeature(pPlayer, self.Def.nChildResId)
	self:SetUsing(pPlayer, nId)
	return true
end

function Toy:Quit_ToyChild(pPlayer)
	self:RestoreFeature(pPlayer)
	return true
end

function Toy:Use_ToyLight(pPlayer)
	local nMapId, nX, nY = pPlayer.GetWorldPos()
	local pNpc = KNpc.Add(self.Def.nLightNpcId, 1, -1, nMapId, nX, nY)
	if not pNpc then
		Log("[x] Toy:Use_ToyLight, add npc failed", pPlayer.dwID, nMapId, nX, nY)
		return false, "Sử dụng thất bại"
	end
	Timer:Register(self.Def.nLightDuration * Env.GAME_FPS, self._RemoveLight, self, pNpc.nId)
	return true
end

function Toy:_RemoveLight(nNpcId)
	local pNpc = KNpc.GetById(nNpcId)
	if not pNpc then
		Log("[x] Toy:_RemoveLight, npc nil", nNpcId)
		return
	end
	pNpc.Delete()
end

function Toy:Use_ToyFreeze(pPlayer, nId)
	if not self:AddStatue(pPlayer) then
		return false, "Tạo tượng thất bại"
	end

	pPlayer.AddSkillState(self.Def.nHideBuffId, 1, 0, 10000000)
	self:SetUsing(pPlayer, nId)
	return true
end

function Toy:Quit_ToyFreeze(pPlayer)
	self:RemoveStatue(pPlayer)
	pPlayer.RemoveSkillState(self.Def.nHideBuffId)
	return true
end

function Toy:Use_ToyHat(pPlayer, nId, nTarget)
	local bOk, szErr, pTarget = self:SelectCommonCheck(pPlayer, nTarget)
	if not bOk then
		return false, szErr
	end

	if pPlayer.ConsumeItemInBag(self.Def.nGreenHatId, 1, Env.LogWay_Toy) ~= 1 then
		return false, "Thiếu công cụ"
	end

	Mail:SendSystemMail({
		To = nTarget,
		Title = "Thanh Phong",
		Text = string.format("%s tặng cho ngươi một Diệp Thanh Phong, nguyện nó thường bạn ngươi tả hữu, mang cho ngươi đến từng tia từng tia thanh lương.", pPlayer.szName),
		From = "Hệ thống",
		tbAttach = {
			{"item", self.Def.nGreenHatGivenId, 1},
		},
		nLogReazon = Env.LogWay_Toy,
	})
	Log("Toy:Use_ToyHat", pPlayer.dwID, nId, nTarget)

	return true
end

function Toy:Use_ToyDance(pPlayer)
	local tbPlayer = KNpc.GetAroundPlayerList(pPlayer.GetNpc().nId, self.Def.nDanceRange) or {}
    for _, pTarget in ipairs(tbPlayer) do
    	if pTarget.dwID ~= pPlayer.dwID then
    		if self:IsFree(pTarget) then
				pTarget.CallClientScript("Toy:OnForceDance", pPlayer.szName)
			end
    	end
    end
    return true
end

function Toy:SelectCommonCheck(pPlayer, nTarget)
	if not nTarget or pPlayer.dwID == nTarget then
		return false, "Mời lựa chọn mục tiêu người chơi"
	end
	local pTarget = KPlayer.GetPlayerObjById(nTarget)
	if not pTarget then
		return false, "Mục tiêu người chơi không trực tuyến"
	end
	if pPlayer.nMapId ~= pTarget.nMapId then
		return false, "Mục tiêu không ở gần"
	end
	if not self:IsFree(pTarget) then
		return false, "Đối phương trước mắt không thể chấp hành thao tác này"
	end
	return true, "", pTarget
end

function Toy:Use_ToyLaugh(pPlayer, nId, nTarget)
	local bOk, szErr, pTarget = self:SelectCommonCheck(pPlayer, nTarget)
	if not bOk then
		return false, szErr
	end
	pTarget.CallClientScript("Toy:OnForceLaugh", pPlayer.szName)
	return true
end

function Toy:IsLoli(pPlayer)
	return pPlayer.nFaction == 3 or pPlayer.nFaction == 12 or
		(pPlayer.nFaction == 16 and pPlayer.nSex == Player.SEX_FEMALE)
end

function Toy:Use_ToyStick(pPlayer, nId, nTarget)
	local bOk, szErr, pTarget = self:SelectCommonCheck(pPlayer, nTarget)
	if not bOk then
		return false, szErr
	end

	if pPlayer.ConsumeItemInBag(self.Def.nStickId, 1, Env.LogWay_Toy) ~= 1 then
		return false, "Thiếu công cụ"
	end

	pTarget.CallClientScript("Toy:OnForceStick", pPlayer.szName)

	local nBuffId, nLevel, nTimeout = unpack(self.Def.tbStickBuff)
	pTarget.AddSkillState(nBuffId, nLevel, 0, nTimeout * Env.GAME_FPS)

	if self:IsLoli(pTarget) then
		local szMsg = ""
		if MathRandom(10) < 5 then
			szMsg = string.format("Tạ ơn %s%s", pPlayer.szName, pPlayer.nSex == Player.SEX_FEMALE and "Tỷ tỷ" or "Ca ca")
		else
			szMsg = string.format("%s%s là người tốt", pPlayer.szName, pPlayer.nSex == Player.SEX_FEMALE and "A di" or "Thúc thúc")
		end
		self:_BubbleTalk(pTarget, szMsg, 5, self.Def.nStickRange)
	end
	
	return true
end

function Toy:_BubbleTalk(pPlayer, szMsg, nDuration, nRange)
	local nNpcId = pPlayer.GetNpc().nId
	local tbPlayers = KNpc.GetAroundPlayerList(nNpcId, nRange) or {}
	for _, p in pairs(tbPlayers) do
		p.CallClientScript("Ui:NpcBubbleTalk", {nNpcId}, szMsg, nDuration)
	end
end

function Toy:Use_ToyMask(pPlayer, nId)
	local tbSetting = self.Def.tbMasks[pPlayer.nSex]
	if not tbSetting then
		Log("[x] Toy:Use_ToyMask, no setting", pPlayer.dwID, nId, pPlayer.nSex)
		return false
	end

	local nIdx = MathRandom(#tbSetting)
	tbSetting = tbSetting[nIdx]
	local nResId = tbSetting.nResId
	self:ChangeFeature(pPlayer, nResId)
	self:SetUsing(pPlayer, nId)
	pPlayer.nMaskResId = nResId

	Timer:Register(self.Def.nMaskLastTime * Env.GAME_FPS, self.OnMaskTimeout, self, pPlayer.dwID)

	local nNpcId = pPlayer.GetNpc().nId
	local tbPlayers = KNpc.GetAroundPlayerList(nNpcId, self.Def.nMaskRange) or {}
	-- special talk
	for _, p in pairs(tbPlayers) do
		local tbTalks = tbSetting.tbSpecialTalk[p.nMaskResId or 0]
		if p.dwID ~= pPlayer.dwID and tbTalks then
			self:_BubbleTalk(pPlayer, tbTalks[MathRandom(#tbTalks)], 5, self.Def.nMaskRange)
			break
		end
	end

	-- other normal talk
	local tbTalks = tbSetting.tbOtherTalk
	for _, p in pairs(tbPlayers) do
		if p.dwID ~= pPlayer.dwID and (p.nMaskResId or 0) <= 0 then
			self:_BubbleTalk(p, tbTalks[MathRandom(#tbTalks)], 5, self.Def.nMaskRange)
		end
	end

	-- self talk
	local nSec = MathRandom(tbSetting.tbTalkSelfInterval[1], tbSetting.tbTalkSelfInterval[2])
	Timer:Register(nSec * Env.GAME_FPS, self.OnSelfTalkTimeout, self, pPlayer.dwID, nIdx)

	return true
end

function Toy:OnSelfTalkTimeout(nPlayerId, nIdx)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
	if not pPlayer then
		return
	end
	local nUsing = self:GetUsing(pPlayer)
	if not nUsing or self:GetClass(nUsing) ~= "ToyMask" then
		return
	end
	
	local tbSetting = self.Def.tbMasks[pPlayer.nSex]
	if not tbSetting then
		Log("[x] Toy:OnSelfTalkTimeout, no setting", nPlayerId, nIdx, pPlayer.nSex)
		return
	end
	tbSetting = tbSetting[nIdx]
	local tbTalks = tbSetting.tbTalkSelf
	self:_BubbleTalk(pPlayer, tbTalks[MathRandom(#tbTalks)], 5, self.Def.nMaskRange)
	local nSec = MathRandom(tbSetting.tbTalkSelfInterval[1], tbSetting.tbTalkSelfInterval[2])
	Timer:Register(nSec * Env.GAME_FPS, self.OnSelfTalkTimeout, self, pPlayer.dwID, nIdx)
end

function Toy:OnMaskTimeout(nPlayerId)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
	if not pPlayer then
		return
	end
	local nUsing = self:GetUsing(pPlayer)
	if not nUsing or self:GetClass(nUsing) ~= "ToyMask" then
		return
	end
	pPlayer.CallClientScript("Toy:OnClickCancel")
end

function Toy:Quit_ToyMask(pPlayer)
	self:RestoreFeature(pPlayer)
	pPlayer.nMaskResId = nil
	return true
end

function Toy:Use_ToyLabel(pPlayer)
	-- do nothing
	return true
end
function Toy:Use_ToyBook(pPlayer)
	-- do nothing
	return true
end

function Toy:AddStatue(pPlayer)
	local tbStatueId = self.Def.tbStatueId[pPlayer.nFaction]
	if not tbStatueId then
		Log("[x] Toy:AddStatue, no statueId1", pPlayer.dwID, pPlayer.nFaction)
		return false
	end
	local nStatusId = tbStatueId[pPlayer.nSex]
	if not nStatusId or nStatusId <= 0 then
		Log("[x] Toy:AddStatue, no statueId2", pPlayer.dwID, pPlayer.nFaction, pPlayer.nSex)
		return false
	end

	local nMapId, nX, nY = pPlayer.GetWorldPos()
	local nDir = pPlayer.GetNpc().GetDir()
	local pNpc = KNpc.Add(nStatusId, 1, -1, nMapId, nX, nY, false, nDir)
	if not pNpc then
		Log("[x] Toy:AddStatue, npc nil", pPlayer.dwID, nX, nY, nDir)
		return false
	end

	self.tbStatues = self.tbStatues or {}
	self.tbStatues[pPlayer.dwID] = pNpc.nId

	pNpc.SetName(pPlayer.szName)
	pNpc.SetTitleID(0)
	return true
end

function Toy:RemoveStatue(pPlayer)
	self.tbStatues = self.tbStatues or {}
	local nNpcId = self.tbStatues[pPlayer.dwID]
	if not nNpcId or nNpcId <= 0 then
		return
	end

	local pNpc = KNpc.GetById(nNpcId)
	if pNpc then
		pNpc.Delete()
	end
	self.tbStatues[pPlayer.dwID] = nil
end

function Toy:Unlock(pPlayer, nId)
	if self:IsUnlocked(pPlayer, nId) then
		return false
	end
	pPlayer.SetUserValue(self.Def.nUnlockSaveGrp, nId, 1)
	pPlayer.SetUserValue(self.Def.nUseCountSaveGrp, nId, 0)
	pPlayer.CallClientScript("Toy:OnUnlock", nId)
	Log("Toy:Unlock", pPlayer.dwID, nId)
	return true
end

function Toy:UnlockByClass(pPlayer, szClass)
	local nId = self:GetId(szClass)
	if not nId then
		Log("[x] Toy:UnlockByClass, id nil", pPlayer.dwID, szClass)
		return false
	end
	return self:Unlock(pPlayer, nId)
end

function Toy:IncUseCount(pPlayer, nId)
	if not self:IsUnlocked(pPlayer, nId) then
		Log("[x] Toy:IncUseCount, not unlocked", pPlayer.dwID, nId)
		return
	end

	local nCount = self:GetUseCount(pPlayer, nId) + 1
	pPlayer.SetUserValue(self.Def.nUseCountSaveGrp, nId, nCount)
	Log("Toy:IncUseCount", pPlayer.dwID, nId, nCount)
end

function Toy:SetUsing(pPlayer, nId)
	self.tbUsing = self.tbUsing or {}
	self.tbUsing[pPlayer.dwID] = nId
	if nId then
		Env:SetSystemSwitchOff(pPlayer, Env.SW_All)
	else
		Env:SetSystemSwitchOn(pPlayer, Env.SW_All)
	end
end

function Toy:GetUsing(pPlayer)
	self.tbUsing = self.tbUsing or {}
	return self.tbUsing[pPlayer.dwID]
end

function Toy:IsFree(pPlayer)
	if ActionInteract:IsInteract(pPlayer) then
        return false
    end
	return not self:GetUsing(pPlayer)
end

function Toy:Free(pPlayer)
	local nId = self:GetUsing(pPlayer)
	if not nId or nId <= 0 then
		return
	end

	self:Quit(pPlayer, nId)
end

function Toy:OnLeaveMap(pPlayer, nMapTemplateId, nMapId)
	self:Free(pPlayer)
end

function Toy:OnLogout(pPlayer)
	self:Free(pPlayer)
end

function Toy:OnLogin(pPlayer, bReconnected)
	self:Free(pPlayer)

	self:CheckPreComplete(pPlayer)
end

function Toy:CheckPreComplete(pPlayer)
	local tbUnlocked = {}
	-- 小风车	登录第8天登录领奖获取
	local nFlag = pPlayer.GetUserValue(LoginAwards.LOGIN_AWARDS_GROUP, LoginAwards.RECEIVE_FLAG)
	if Lib:LoadBits(nFlag, 7, 7) ~= 0 or (Lib:LoadBits(nFlag, 6, 6) ~= 0 and GetTimeFrameState(self.Def.szOpenTimeframe) == 1) then
		if self:UnlockByClass(pPlayer, "ToyWindmill") then
			table.insert(tbUnlocked, "ToyWindmill")
		end
	end

	-- 琉璃灯	V10礼包
	local nBuyedVal = pPlayer.GetUserValue(Recharge.SAVE_GROUP, Recharge.KEY_VIP_AWARD)
	if KLib.GetBit(nBuyedVal, 11) == 1 then
		if self:UnlockByClass(pPlayer, "ToyLight") then
			table.insert(tbUnlocked, "ToyLight")
		end
	end

	for i, szClass in ipairs(tbUnlocked) do
		local nId = self:GetId(szClass) or 0
		local tbSetting = self:GetSetting(nId) or {}
		tbUnlocked[i] = tbSetting.szName or ""
	end
	if next(tbUnlocked) then
		Mail:SendSystemMail({
			To = pPlayer.dwID,
			Title = "Thiên Công Hạp",
			Text = string.format("Thiên Công Hạp đã mở, vì cảm tạ đại hiệp vì giang hồ làm ra cống hiến to lớn, riêng đại hiệp giải tỏa [FFFE0D]%s[-], có thể mở ra khung chat phía trên Thiên Công Hạp nút bấm sử dụng, hi vọng có thể cho đại hiệp mang đến càng Đắc Lắc hơn thú.", table.concat(tbUnlocked, "、")),
			From = "Hệ thống",
			nLogReazon = Env.LogWay_Toy,
		})
	end
end

function Toy:ChangeFeature(pPlayer, nNpcResID)
    pPlayer.GetNpc().ChangeFeature(nNpcResID)
end

function Toy:RestoreFeature(pPlayer)
	pPlayer.GetNpc().RestoreFeature()
end