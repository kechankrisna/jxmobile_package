local tbFuben = Fuben:CreateFubenClass(Wedding.szFubenBase);

function tbFuben:OnCreate(nBoyPlayerId, nGirlPlayerId, nLevel)
	local nNowTime = GetTime() 
	local tbMapSetting = Wedding.tbWeddingLevelMapSetting[nLevel]
	assert(tbMapSetting)
	self.tbMapSetting = tbMapSetting
	self.tbMarryCeremonyStandPos = self.tbSetting.tbStartMarryCeremonyPlayerPos or {}
	self.tbCandyPos = self.tbSetting.tbCandyPos or {}
	self.fnSelect = Lib:GetRandomSelect(#self.tbMarryCeremonyStandPos);
	self.nProcess = Wedding.PROCESS_NONE
	self.tbRole = {[nBoyPlayerId] = true, [nGirlPlayerId] = true}
	self.tbMarryCeremonyPlayer = {}
	self.nBoyPlayerId = nBoyPlayerId
	self.nGirlPlayerId = nGirlPlayerId
	self.nWeddingLevel = nLevel
	self.nPlayerCount = 0 
	self.nMaxPlayer = tbMapSetting.nDefaultMaxPlayer or 2000
	self.nBoyBuffId = tbMapSetting.nBoyBuffId
	self.nGirlBuffId = tbMapSetting.nGirlBuffId
	self.tbWelcomeCount = {[nBoyPlayerId] = tbMapSetting.nDefaultWelcome, [nGirlPlayerId] = tbMapSetting.nDefaultWelcome} 		-- 可发出的请柬数
	self.tbHadWelcome = {} 																										-- 已经邀请的玩家
	self.tbApplyWelcome = {} 																									-- 申请进入婚礼数据
	self.tbPromise = {} 																										-- 已经宣誓的玩家
	self:InitRoleData()
	Wedding:OnCreateFuben(nBoyPlayerId, nGirlPlayerId, self.nMapId, nLevel, nNowTime)
	self:Start();
	self.nStartWeddingTime = nNowTime																							-- 开始婚礼时间，可用于奖励过期时间的计算
	self.tbFirecrackerAward = Wedding.tbFirecrackerAwardSetting[nLevel] 														-- 开心爆竹奖励
	self.tbCandySetting = Wedding.tbCandySetting[nLevel] 																		-- 喜糖相关配置
	self.nMaxFreeSendCandy = Wedding.tbCandySetting[nLevel].tbSendTimes[Wedding.Candy_Type_Free] 								-- 最多可免费派喜糖次数
	self.nMaxCostSendCandy = Wedding.tbCandySetting[nLevel].tbSendTimes[Wedding.Candy_Type_Pay] 								-- 最多可付费派喜糖次数
	self.nMaxCandyAwardTimes = Wedding.tbCandySetting[nLevel].nAwardCount														-- 最多可拾取喜糖数量				
	self.tbDinnerAward = Wedding.tbDinnerAwardSetting[nLevel]
	self.tbConcentricFruitAward = Wedding.tbConcentricFruitAwardSetting[nLevel] 												-- 同心果奖励
	self.tbCandyAwardTimes = {} 																								-- 玩家已经拾取喜糖次数
	self.tbWitness = {} 																										-- 证婚人
	Wedding:RemoveCashGiftData(nBoyPlayerId, nGirlPlayerId) 																	-- 清理礼金数据
	local fnStart = function (self, pPlayer)
		pPlayer.CallClientScript("Wedding:RoleStartWedding", tbMapSetting.nDefaultWelcome)
    end
    self:ForeachRoleNoCheckMap(fnStart)
	Log("WeddingFubenBase fnOnCreate ", self:GetLog())
end

-- 副本流程跑完和地图销毁的时候会调，会重复调
function tbFuben:OnClose()
	-- 多次调没问题
	Wedding:OnCloseFuben(self.nMapId)
	Log("WeddingFubenBase fnOnClose ", self:GetLog())
end

function tbFuben:OnJoin(pPlayer)
	self.nPlayerCount = self.nPlayerCount + 1
	self:SynState(pPlayer)
	if self.nProcess == Wedding.PROCESS_MARRYCEREMONY then
	    pPlayer.CallClientScript("Wedding:HideAllName", true)
		local tbPos = self.tbMarryCeremonyStandPos[self.fnSelect()]
        if tbPos then
       	   pPlayer.SetPosition(unpack(tbPos))
        end
        -- 为了强制广播同步NPC
       	local pNpc = pPlayer.GetNpc()
       	if pNpc then
    	   pNpc.RestoreAction()
    	end
        pPlayer.CenterMsg("Chính đang ở bái đường trong lúc đó, an tâm chớ vội ", true)
	end
	self:TrySynTableNpcData()
	pPlayer.CallClientScript("Wedding:OnJoinWedding", self.tbSetting.nMapTemplateId)
end

function tbFuben:OnFirstJoin(pPlayer)
	if self.tbRole[pPlayer.dwID] then
		Env:SetSystemSwitchOff(pPlayer, Env.SW_All) 
		local nPlayerSex = pPlayer.GetUserValue(Wedding.nSaveGrp, Wedding.nSaveKeyGender)
		local szLoliMsg = Wedding.tbLoliMsg[pPlayer.nFaction]
		if szLoliMsg and nPlayerSex == Gift.Sex.Girl then
			pPlayer.SendBlackBoardMsg(szLoliMsg, true)
		end
		pPlayer.TLogRoundFlow(Env.LogWay_Wedding, pPlayer.nMapTemplateId, self.nWeddingLevel, GetTime(), self.nBoyPlayerId, 0, self.nGirlPlayerId);
	else
		pPlayer.TLogRoundFlow(Env.LogWay_Wedding, pPlayer.nMapTemplateId, self.nWeddingLevel, GetTime(), self.nBoyPlayerId, 1, self.nGirlPlayerId);
	end
	Log("WeddingFubenBase OnFirstJoin ok", pPlayer.dwID, pPlayer.szName, self.tbRole[pPlayer.dwID] and 1 or 0, self:GetLog())
end

function tbFuben:OnLogin()
	self:SynState(me)
	self:TrySynTableNpcData()
end

function tbFuben:OnLeaveMap(pPlayer)
	self.nPlayerCount = self.nPlayerCount - 1
	self.tbMarryCeremonyPlayer[pPlayer.dwID] = nil
	pPlayer.RemoveSkillState(Wedding.nNoMoveBuffId)
	pPlayer.CallClientScript("Wedding:HideAllName", false)
	-- 强制显示
	self:SetHide(pPlayer, 0)
	local pNpc = pPlayer.GetNpc();
	if self.nBoyPlayerId == pPlayer.dwID then
		pNpc.RemoveSkillState(self.nBoyBuffId)
	elseif self.nGirlPlayerId == pPlayer.dwID then
		pNpc.RemoveSkillState(self.nGirlBuffId);
	end
	pPlayer.CallClientScript("Wedding:OnLeaveMap");
	local nWitnessTitle = self.tbMapSetting.nWitnessTitle
	if nWitnessTitle and PlayerTitle:GetPlayerTitleByID(pPlayer, nWitnessTitle) then 
		pPlayer.DeleteTitle(nWitnessTitle, true)
	end
end

function tbFuben:WeddingEndTime()
	return self.nStartWeddingTime + self.tbMapSetting.nWholeTime
end

-- 将奖励加上至婚礼结束的过期时间
function tbFuben:FormatTimeReward(tbAllAward)
	local tbCopyAward = Lib:CopyTB(tbAllAward or {})
	local tbFormatReward = {}
	for _,tbReward in ipairs(tbCopyAward) do
		if tbReward[1] == "item" then
			tbReward[4] = self:WeddingEndTime()
		end
		table.insert(tbFormatReward,tbReward)
	end

	return tbFormatReward
end

function tbFuben:OnBlackMsgWithRole(szMsg)
	self:BlackMsg(string.format(szMsg, self:ManName(), self:FemaleName()))
end

function tbFuben:OnSendWorldNotice(szMsg)
	local szNotice = string.format(szMsg, self:ManName(), self:FemaleName())
	KPlayer.SendWorldNotify(1, 999, szNotice, 1, 1)
end

function tbFuben:ManName()
	return self.tbRoleData[1] and self.tbRoleData[1].szName or "Tân Lang"
end

function tbFuben:FemaleName()
	return self.tbRoleData[2] and self.tbRoleData[2].szName or "Tân Nương"
end

function tbFuben:SynState(pPlayer)
	local nNowTime = GetTime()
	pPlayer.nCanLeaveMapId = self.nMapId;
	local bRole = self.tbRole[pPlayer.dwID]
	local bShowCandy = (self.nProcess == Wedding.PROCESS_CANDY and bRole) and true or false
	if bRole then
		pPlayer.CallClientScript("Ui:OpenWindow", "HomeScreenFuben", "WeddingFubenRole", {bWeddingCandy = bShowCandy});
		self:SynWelcome(pPlayer)
	else
		pPlayer.CallClientScript("Ui:OpenWindow", "HomeScreenFuben", "WeddingFuben");
	end

	pPlayer.CallClientScript("Fuben:SetBtnCandy", bShowCandy)
	pPlayer.CallClientScript("Fuben:SetBtnBless", not bRole)
	
	self:ShowEndTime(pPlayer)
	-- 为非主角或者已经结束婚礼的主角或者婚礼结束显示离开按钮
	if not bRole or (self.bClose == 1 and bRole) or self.nProcess == Wedding.PROCESS_END then
		pPlayer.CallClientScript("Fuben:ShowLeave");
	end

	-- 各阶段控制
	if self.nProcess == Wedding.PROCESS_MARRYCEREMONY then
		self:StartMarryCeremonyState(pPlayer)
		if bRole then
    		pPlayer.CallClientScript("Wedding:OnRoleStartMarryCeremonyState")
		end
	elseif self.nProcess == Wedding.PROCESS_PROMISE then
		pPlayer.CallClientScript("Wedding:OnRolePromiseState", self.nShowEndTime and self.nShowEndTime - nNowTime or 0)
	elseif self.nProcess == Wedding.PROCESS_CANDY then

	end
	if self.nProcess ~= Wedding.PROCESS_MARRYCEREMONY then
		pPlayer.CallClientScript("Wedding:TryDestroyUi", "WeddingInterludePanel")
	end

	if self.nBoyPlayerId == pPlayer.dwID then
		if not pPlayer.GetNpc().GetSkillState(self.nBoyBuffId) then
			pPlayer.AddSkillState(self.nBoyBuffId, 1,  0 , Wedding.nBuffTime * Env.GAME_FPS)
		end
	elseif self.nGirlPlayerId == pPlayer.dwID then
		if not pPlayer.GetNpc().GetSkillState(self.nGirlBuffId) then
			pPlayer.AddSkillState(self.nGirlBuffId, 1,  0 , Wedding.nBuffTime * Env.GAME_FPS)
		end
	end
	local nWitnessTitle = self.tbMapSetting.nWitnessTitle
	if self.tbWitness[pPlayer.dwID] and nWitnessTitle and not PlayerTitle:GetPlayerTitleByID(pPlayer, nWitnessTitle) then
		pPlayer.AddTitle(self.tbMapSetting.nWitnessTitle, self.tbMapSetting.nWholeTime, true, false, nil, true)
	end
	self:ForceShowRoleNpc(pPlayer, self.tbRole)
end

function tbFuben:ForceShowRoleNpc(pPlayer, tbPlayer)
	local tbNpcId = {}
	for dwID in pairs(tbPlayer or {}) do
		local pPlayer = KPlayer.GetPlayerObjById(dwID)
		if pPlayer then
			local pNpc = pPlayer.GetNpc()
			if pNpc then
				table.insert(tbNpcId, pNpc.nId)
			end
		end
	end
	pPlayer.CallClientScript("Wedding:OnForceShowNpc", tbNpcId)
end

function tbFuben:ShowEndTime(pPlayer)
	if self.nShowEndTime and self.nShowEndTime > 0 then
		pPlayer.CallClientScript("Fuben:SetEndTime", self.bClose == 1 and 0 or self.nShowEndTime, self.szShowTimeTitle);
	end
	if self.tbCacheTargetInfo then
		local szInfo = self.tbCacheTargetInfo[1]
		local nLockId = self.tbCacheTargetInfo[2]
		local nEndTime = 0;
		if self.tbLock[nLockId] then
			nEndTime = GetTime() + math.floor(Timer:GetRestTime(self.tbLock[nLockId].nTimerId) / Env.GAME_FPS);
		end
		pPlayer.CallClientScript("Fuben:SetTargetInfo", szInfo, nEndTime);
	end
end

-- 强制同步时间
function tbFuben:OnSynEndTime()
	local fnSyn = function (pPlayer)
		if self.nShowEndTime and self.nShowEndTime > 0 then
			pPlayer.CallClientScript("Fuben:SetEndTime", self.bClose == 1 and 0 or self.nShowEndTime, self.szShowTimeTitle);
		end
	end 
	self:AllPlayerExcute(fnSyn)
end

function tbFuben:StartMarryCeremonyState(pPlayer)
	--pPlayer.AddSkillState(Wedding.nHideHeadUiBuff, 1,  0 , Wedding.nHideHeadUiBuffTime * Env.GAME_FPS)
	pPlayer.CallClientScript("Wedding:HideAllName", true)
	local bChangeUiState = self.tbMarryCeremonyPlayer[pPlayer.dwID]
	pPlayer.CallClientScript("Wedding:OnStateMarryCeremonyState", bChangeUiState)
	pPlayer.AddSkillState(Wedding.nNoMoveBuffId, 1, 0, -1, 1, 1);
	-- 正在观看动画的玩家关闭主界面
	if bChangeUiState then
		pPlayer.CallClientScript("Ui:CloseWindow", "HomeScreenFuben");
	end

	if not self.tbRole[pPlayer.dwID] then
		-- 关闭正在观看动画的非主角玩家的离开按钮
		if self.tbMarryCeremonyPlayer[pPlayer.dwID] then
			pPlayer.CallClientScript("Fuben:HideLeave");
		else
			pPlayer.CallClientScript("Fuben:ShowLeave");
		end
	end
end

function tbFuben:EndMarryCeremonyState(pPlayer)
	--pPlayer.RemoveSkillState(Wedding.nHideHeadUiBuff)
	pPlayer.CallClientScript("Wedding:HideAllName", false)
	pPlayer.CallClientScript("Wedding:OnEndMarryCeremonyState")
	pPlayer.RemoveSkillState(Wedding.nNoMoveBuffId)
	local bWatch = self.tbMarryCeremonyPlayer[pPlayer.dwID]
	local bRole = self.tbRole[pPlayer.dwID]
	if bWatch then
		if bRole then
			pPlayer.CallClientScript("Ui:OpenWindow", "HomeScreenFuben", "WeddingFubenRole");
		else
			pPlayer.CallClientScript("Ui:OpenWindow", "HomeScreenFuben", "WeddingFuben");
		end
	end
	if bWatch and not bRole then
		pPlayer.CallClientScript("Fuben:ShowLeave");
	end
	self:ShowEndTime(pPlayer)
end

function tbFuben:PlayMarryCeremonySceneAnim(pPlayer)
	pPlayer.CallClientScript("Wedding:OnPlayMarryCeremonySceneAnim", self.tbRoleData, self.nWeddingLevel)
end

function tbFuben:StopMarryCeremonySceneAnim(pPlayer)
	pPlayer.CallClientScript("Wedding:OnStopMarryCeremonySceneAnim", self.nWeddingLevel)
end

function tbFuben:InitRoleData()
	local tbRoleData = {}
	local tbRole = {self.nBoyPlayerId, self.nGirlPlayerId}
	for i, dwID in ipairs(tbRole) do
		tbRoleData[i] = {}
		local pStayInfo = KPlayer.GetPlayerObjById(dwID) or KPlayer.GetRoleStayInfo(dwID)
		local szName = pStayInfo and pStayInfo.szName or ""
		tbRoleData[i].szName = szName
	end
	self.tbRoleData = tbRoleData
end

function tbFuben:OnSetMarryCeremonyPlayerPos()
	local fnExcute = function (self, pPlayer)
		local tbPos = self.tbMarryCeremonyStandPos[self.fnSelect()]
        if tbPos then
       	   pPlayer.AddSkillState(Wedding.nNoMoveBuffId, 1, 0, -1, 1, 1);
       	   pPlayer.CallClientScript("Wedding:HideAllName", true)
       	   Decoration:ExitPlayerActState(pPlayer.dwID)
       	   pPlayer.SetPosition(unpack(tbPos))
       	   -- 为了强制广播同步NPC
       	--    local pNpc = pPlayer.GetNpc()
       	--    if pNpc then
    		  -- pNpc.RestoreAction()
    	   -- end
        end
    end
    self:ForeachExceptRole(fnExcute)

    local tbStartMarryCeremonyPos = self.tbSetting.tbStartMarryCeremonyPos or {}
    local fnRoleSelect = Lib:GetRandomSelect(#tbStartMarryCeremonyPos);
    local fnRoleExcute = function (self, pPlayer)
    	local tbRolePos = tbStartMarryCeremonyPos[fnRoleSelect()]
    	if tbRolePos then
    		-- 隐藏主角
    		self:SetHide(pPlayer, 1)
    		pPlayer.AddSkillState(Wedding.nNoMoveBuffId, 1, 0, -1, 1, 1);
    		pPlayer.CallClientScript("Wedding:HideAllName", true)
    		Decoration:ExitPlayerActState(pPlayer.dwID)
    		pPlayer.SetPosition(unpack(tbRolePos))
    		-- 为了强制广播同步NPC
    		-- local pNpc = pPlayer.GetNpc()
    		-- if pNpc then
    		-- 	pNpc.RestoreAction()
    		-- end
    	end
    end
    self:ForeachRole(fnRoleExcute)
end

-- 确定证婚人
function tbFuben:ChooseWitness()
	self.tbWitness = {}
	local tbWitness = {}
	local tbRank = Wedding:GetCashGiveRank(self.nBoyPlayerId, self.nGirlPlayerId, -1)
	if #tbRank < 1 then
		return
	end
	for i = #tbRank, #tbRank, -1 do
		local nPlayerId = tbRank[i].nGuest
		local pPlayer = KPlayer.GetPlayerObjById(nPlayerId or 0)
		-- 排除不在线和不在婚礼现场
		if not pPlayer or pPlayer.nMapId ~= self.nMapId or self.tbRole[nPlayerId] then
			table.remove(tbRank, i)
		end
	end
	local nWitness = self.tbMapSetting.nWitness
	local nWitnessTitle = self.tbMapSetting.nWitnessTitle
	if nWitness then
		for i = 1, nWitness do
			if tbRank[i] then
				local pWitness = KPlayer.GetPlayerObjById(tbRank[i].nGuest)
				if nWitnessTitle and pWitness then
					pWitness.AddTitle(nWitnessTitle, self.tbMapSetting.nWholeTime, true, false, nil, true)
				end
				table.insert(tbWitness, tbRank[i])
				self.tbWitness[tbRank[i].nGuest] = tbRank[i]
				Log("WeddingFubenBase fnChooseWitness ok", i, tbRank[i].nGuest, tbRank[i].nGold, tbRank[i].nGiveTime, self:GetLog())
			end
		end
	end
	local tbWitnessInfo = self.tbSetting.tbWitnessInfo or {}
	local tbWitnessPos = tbWitnessInfo.tbPos
	local tbFurnitureId = self.tbFurnitureGroup[tbWitnessInfo.szGroup] or {}
	if tbWitnessPos then
		for i, v in ipairs(tbWitness) do
			local pWitness = KPlayer.GetPlayerObjById(v.nGuest)
			if pWitness and tbWitnessPos[i] then
				pWitness.SetPosition(unpack(tbWitnessPos[i]))
				local nId = tbFurnitureId[i]
				if nId then
					Decoration:EnterPlayerActState(pWitness, nId, pWitness.GetNpc().nId, 0);
				end
			end
		end
	end
end

-- 》》开始拜堂仪式
function tbFuben:OnStartMarryCeremony()
	self.nProcess = Wedding.PROCESS_MARRYCEREMONY
	self:ChooseWitness()
	local fnExcute = function (self, pPlayer)
		self.tbMarryCeremonyPlayer[pPlayer.dwID] = true
    	self:StartMarryCeremonyState(pPlayer)
    	self:PlayMarryCeremonySceneAnim(pPlayer)
    end
    self:ForeachExceptRole(fnExcute)

    local fnRoleExcute = function (self, pPlayer)
  		self.tbMarryCeremonyPlayer[pPlayer.dwID] = true
    	self:StartMarryCeremonyState(pPlayer)
    	-- 隐藏主角
    	self:SetHide(pPlayer, 1)
    	pPlayer.CallClientScript("Wedding:OnRoleStartMarryCeremonyState")
    	self:PlayMarryCeremonySceneAnim(pPlayer)
    end
    self:ForeachRole(fnRoleExcute)

    -- 镜头动画
    self:PlayCameraAnimation(1)
    Log("WeddingFubenBase fnOnStartMarryCeremony ok >>", self:GetLog())
end

-- 拜堂结束
function tbFuben:OnEndMarryCeremony()
	self.nProcess = Wedding.PROCESS_NONE
	local fnExcute = function (self, pPlayer)
    	self:EndMarryCeremonyState(pPlayer)
    	self:StopMarryCeremonySceneAnim(pPlayer)
    end
    self:ForeachExceptRole(fnExcute)
    local tbEndMarryCeremonyPos = self.tbSetting.tbEndMarryCeremonyPos or {}
    local fnRoleExcute = function (self, pPlayer)
	    -- 强制显示
		self:SetHide(pPlayer, 0)
    	self:EndMarryCeremonyState(pPlayer)
    	local tbPos
    	if pPlayer.dwID == self.nBoyPlayerId then
    		tbPos = tbEndMarryCeremonyPos[1]
    	elseif pPlayer.dwID == self.nGirlPlayerId then
    		tbPos = tbEndMarryCeremonyPos[2]
    	end
    	if tbPos and next(tbPos) then
			pPlayer.SetPosition(unpack(tbPos))
		end
    	pPlayer.CallClientScript("Wedding:OnRoleEndMarryCeremonyState")
    	self:StopMarryCeremonySceneAnim(pPlayer)
    	local nMarryTitle = Wedding:GetTitleId(pPlayer)
    	if nMarryTitle then
    		pPlayer.ActiveTitle(nMarryTitle)
    	end
    end
    self:ForeachRole(fnRoleExcute)

    -- 重置镜头
    local fnReset = function (self, pPlayer)
   		pPlayer.CallClientScript("Ui.CameraMgr.LeaveCameraAnimationState");
		pPlayer.CallClientScript("Ui.CameraMgr.RestoreCameraRotation");
   	end
   	self:ForeachMarryCeremony(fnReset)
   	self.tbMarryCeremonyPlayer = {}
   	-- 为了防止策划配错，强制恢复游戏速度为1
   	self:SetGameWorldScale(1)
   	local bRet, szMsg = FriendShip:AddImitity(self.nBoyPlayerId, self.nGirlPlayerId, Wedding.nMarryCeremonyAddImitity, Env.LogWay_Wedding)
   	Log("WeddingFubenBase fnOnEndMarryCeremony ok >>", self:GetLog(), bRet and 1 or szMsg)
end

-- 遍历主角
function tbFuben:ForeachRoleNoCheckMap(fnFunc, ...)
	for dwID in pairs(self.tbRole or {}) do
		local pPlayer = KPlayer.GetPlayerObjById(dwID)
		if pPlayer then
			Lib:CallBack({fnFunc, self, pPlayer, ...});
		end
	end
end

-- 遍历主角
function tbFuben:ForeachRole(fnFunc, ...)
	for dwID in pairs(self.tbRole or {}) do
		local pPlayer = KPlayer.GetPlayerObjById(dwID)
		if pPlayer and pPlayer.nMapId == self.nMapId then
			Lib:CallBack({fnFunc, self, pPlayer, ...});
		end
	end
end

-- 地图上除了主角的玩家
function tbFuben:ForeachExceptRole(fnExc)
	local fnExcute = function (pPlayer)
		if not self.tbRole[pPlayer.dwID] and pPlayer.nMapId == self.nMapId then
			fnExc(self, pPlayer)
		end
    end
    self:AllPlayerExcute(fnExcute)
end

-- 播放拜堂动画的玩家
function tbFuben:ForeachMarryCeremony(fnExc, bExceptRole, ...)
	for dwID in pairs(self.tbMarryCeremonyPlayer or {}) do
		local pPlayer = KPlayer.GetPlayerObjById(dwID)
		if pPlayer and pPlayer.nMapId == self.nMapId and (not bExceptRole or not self.tbRole[pPlayer.dwID]) then
			Lib:CallBack({fnExc, self, pPlayer, ...});
		end
	end
end

-- 1 隐藏 0 显示
function tbFuben:SetHide(pPlayer, nHide)
	local pNpc = pPlayer.GetNpc()
	if pNpc then
		pNpc.SetHideNpc(nHide)
	end
end

function tbFuben:GetLog()
	return self.nBoyPlayerId, self.nGirlPlayerId, self.nProcess, self.nWeddingLevel, self.nMaxPlayer, self.nPlayerCount, self.nBoyBuffId, self.nGirlBuffId
end

function tbFuben:OnMarryCeremonyPlayerBlackMsg(szMsg)
	local fnMsg = function (self, pPlayer)
		pPlayer.CallClientScript("Ui:OpenWindow", "WeddingTxtPanel", szMsg)
   	end
   	self:ForeachMarryCeremony(fnMsg)
end

function tbFuben:OnMarryCeremonyPlayerFadeAnim(...)
	local fnFade = function (self, pPlayer, ...)
    	pPlayer.CallClientScript("Ui:OpenWindow", "StoryBlackBg", ...)
   	end
   	self:ForeachMarryCeremony(fnFade, nil, ...)
end

function tbFuben:OnDestroyUi(szUiName)
	local fnExcute = function (pPlayer)
		pPlayer.CallClientScript("Wedding:TryDestroyUi", szUiName)
    end
    self:AllPlayerExcute(fnExcute)
end

function tbFuben:OnOut(pPlayer)
	if self.tbRole[pPlayer.dwID] then
		Env:SetSystemSwitchOn(pPlayer, Env.SW_All);
		pPlayer.CallClientScript("Fuben:ShowLeave");
	end
end

function tbFuben:OnOpenWeddingInterludePanel(szMsg, szContent)
	local szBoyName = self:ManName()
	local szGirlName =self:FemaleName()
	if szMsg then
		szMsg = string.format(szMsg, szBoyName, szGirlName)
	end
	local tbInfo
	if szContent then
		tbInfo = {}
		tbInfo.szManName = szBoyName
		tbInfo.szFemanName = szGirlName
		tbInfo.szContent = szContent
	end
	local fnExcute = function (pPlayer)
		pPlayer.CallClientScript("Ui:OpenWindow", "WeddingInterludePanel", szMsg, tbInfo)
    end
    self:AllPlayerExcute(fnExcute)
end

function tbFuben:OnDialogYueLao(pPlayer, pYueLao)
	local bRole = self.tbRole[pPlayer.dwID]
	if self.nProcess == Wedding.PROCESS_WELCOME and bRole then
		Dialog:Show(
        {
            Text = "Khách mời tân lang tân nương đã đến dự đầy đủ chưa?",
            OptList = {
                { Text = "Đã đến đầy đủ", Callback = self.JumpOverWelcome, Param = {self, me.dwID} };
            },
        }, pPlayer, pYueLao)
    elseif self.nProcess == Wedding.PROCESS_STARTWEDDING and bRole then
    	Dialog:Show(
        {
            Text = "Tân lang tân nương đã chuẩn bị xong chưa?",
            OptList = {
                { Text = "Đã chuẩn bị xong, bắt đầu hôn lễ", Callback = self.BeginWedding, Param = {self, me.dwID} };
            },
        }, pPlayer, pYueLao)
    else
    	Dialog:Show(
        {
            Text = "Trai anh hùng, gái thuyền quyên",
            OptList = {},
        }, pPlayer, pYueLao)
	end
end

-- 》》迎宾
function tbFuben:OnStartWelcome()
	self.nProcess = Wedding.PROCESS_WELCOME
	Log("WeddingFubenBase fnOnStartWelcome ok >>", self:GetLog())
end

function tbFuben:GetOtherPlayerId(dwID)
	if dwID == self.nBoyPlayerId then
		return self.nGirlPlayerId
	elseif dwID == self.nGirlPlayerId then
		return self.nBoyPlayerId
	end
end

-- 跳过迎宾
function tbFuben:JumpOverWelcome(dwID)
	local pPlayer = KPlayer.GetPlayerObjById(dwID)
	if not pPlayer then
		return
	end
	if not self.tbRole[dwID] then
		pPlayer.CenterMsg("Ngươi không có quyền thao tác", true)
		return
	end
	if self.nProcess ~= Wedding.PROCESS_WELCOME then
		pPlayer.CenterMsg("Nghênh tân đã kết thúc", true)
		return
	end
	if not self:CheckJumpOverWelcomeTime(pPlayer) then
		pPlayer.CenterMsg("Bạn đã yêu cầu bỏ qua", true)
		return
	end
	local nNotifyId = self:GetOtherPlayerId(dwID) or 0
	local pNotifyer = KPlayer.GetPlayerObjById(nNotifyId)
	if pNotifyer then
		if not self:CheckJumpOverWelcomeTime(pNotifyer) then
			pPlayer.CenterMsg("Đối phương đang ở thân thỉnh khiêu quá", true)
			return
		end
		local fnJump = function ()
			self:OnEndWelcome()
		end

		local fnRefuse = function (nPlayerId)
			local pRequester = KPlayer.GetPlayerObjById(nPlayerId)
			if pRequester then
				pRequester.nRequestJumpWelcomeTime = nil
				pRequester.CenterMsg("Hiệp lữ chưa sẵn sàng, cự tuyệt tiến vào giai đoạn kế tiếp ", true)
				GameSetting:SetGlobalObj(pRequester)
				Dialog:OnMsgBoxSelect(1, true)
				GameSetting:RestoreGlobalObj()
			end
		end
		local fnAgree = function (nPlayerId)
			self:OnEndWelcome()
			local pRequester = KPlayer.GetPlayerObjById(nPlayerId)
			if pRequester then
				GameSetting:SetGlobalObj(pRequester)
				Dialog:OnMsgBoxSelect(1, true)
				GameSetting:RestoreGlobalObj()
			end
		end
		local function fnClose()
			me.CallClientScript("Ui:CloseWindow", "MessageBox")
		end
		local szTip = string.format("Khách mời đã đến dự đầy đủ, [FFFE0D]%s[-] đã chuẩn bị xong, ngươi có đồng ý chuyển sang giai đoạn sau hay không?", pPlayer.szName)
		pNotifyer.MsgBox(szTip .. "\n(%d giây sau tự động đồng ý)", {{"Đồng ý", fnAgree, pPlayer.dwID}, {"Hủy", fnRefuse, pPlayer.dwID}}, nil, Wedding.nRequestJumpWelcomeTime, fnJump)
		pPlayer.MsgBox("Đợi bạn đời xác nhận: %d", {{"Xác nhận", fnClose}}, nil, Wedding.nRequestJumpWelcomeTime, function () 
			me.CallClientScript("Ui:CloseWindow", "MessageBox")
		 end)
		pPlayer.nRequestJumpWelcomeTime = GetTime()
	else
		self:OnEndWelcome()
	end
end

function tbFuben:CheckJumpOverWelcomeTime(pPlayer)
	local nNowTime = GetTime()
	if pPlayer.nRequestJumpWelcomeTime and nNowTime - pPlayer.nRequestJumpWelcomeTime < Wedding.nRequestJumpWelcomeTime then
		return
	end
	return true
end

function tbFuben:OnEndWelcome()
	if self.nProcess ~= Wedding.PROCESS_WELCOME then
		return 
	end
	self.nProcess = Wedding.PROCESS_NONE
	Log("WeddingFubenBase fnOnEndWelcome ok >>", self:GetLog())
	if self.tbSetting.nCancelWelcomeUnlockId then
   		self:UnLock(self.tbSetting.nCancelWelcomeUnlockId);
   	end
end

function tbFuben:ClearApplyData(pClear)
	if not self.tbRole[pClear.dwID] then
		pClear.CenterMsg("Ngươi không có quyền thao tác", true)
		return
	end
	if not next(self.tbApplyWelcome) then
		pClear.CenterMsg("Không có thông tin ứng dụng dọn dẹp", true)
		return
	end
	self.tbApplyWelcome = {}
	local fnClear = function (self, pPlayer)
    	Wedding:SynWelcome(pPlayer)
    	pPlayer.CallClientScript("Wedding:OnClearApply")
    end
    self:ForeachRole(fnClear)
    Log("WeddingFubenBase fnClearApplyData ok", pClear.dwID, pClear.szName)
end

function tbFuben:GetWelcomePlayer(pPlayer, nType, nInviteId)
	local tbPlayer = {}
	local szNoBody = ""
	local tbHadWelcome = self.tbHadWelcome
	if nType == Wedding.Welcome_Onekey_Frined then
		szNoBody = "Không có bạn bè mời"
		local tbAllFriend = KFriendShip.GetFriendList(pPlayer.dwID) or {}
		for nFriendId in pairs(tbAllFriend) do
			if not self.tbRole[nFriendId] and not tbHadWelcome[nFriendId] then
	      		local pFriend = KPlayer.GetPlayerObjById(nFriendId)
	      		if pFriend then
	      			table.insert(tbPlayer, nFriendId)
	      		end
	      	end
		end
	elseif nType == Wedding.Welcome_Onekey_Kin then
		szNoBody = "Không có thành viên băng hội nào để mời"
		local tbMember = Kin:GetKinMembers(pPlayer.dwKinId) or {}
  		for dwMemberId in pairs(tbMember) do
  			if not self.tbRole[dwMemberId] and not tbHadWelcome[dwMemberId] then
	      		local pMember = KPlayer.GetPlayerObjById(dwMemberId)
	      		if pMember then
	   				table.insert(tbPlayer, dwMemberId)
	      		end
	      	end
      	end
    elseif nType == Wedding.Welcome_Onekey_Apply then
    	szNoBody = "Không có yêu cầu để đồng ý"
    	for nApplyId in pairs(self.tbApplyWelcome) do
    	 	local pApply = KPlayer.GetPlayerObjById(nApplyId)
    	 	if pApply and not tbHadWelcome[nApplyId] then
    	 		table.insert(tbPlayer, nApplyId)
    	 	end
    	 end 
	elseif nInviteId then
		local bRet, szMsg = self:CheckPersonApply(pPlayer, nType, nInviteId)
		if not bRet then
			return false, szMsg
		end
		table.insert(tbPlayer, nInviteId)
	else
		return false, "Hoạt động không chính xác"
	end
	return tbPlayer, szNoBody
end

function tbFuben:CheckPersonApply(pPlayer, nType, nInviteId)
	local pInviter = KPlayer.GetPlayerObjById(nInviteId)
	if not pInviter then
		return false, "Bên kia đang ngoại tuyến"   
	end
	if self.tbHadWelcome[nInviteId] then
		return false, "Đã mời qua đối phương "   
	end
	if nType == Wedding.Welcome_PersonalFriend then
		if not FriendShip:IsFriend(pPlayer.dwID, nInviteId) then
			return false, "Đối phương không phải hảo hữu của ngươi "   
		end
	elseif nType == Wedding.Welcome_PersonalKin then
		if pPlayer.dwKinId <= 0 then
			return false, "Hãy gia nhập bang hội trước"  
		end
		if pPlayer.dwKinId ~= pInviter.dwKinId then
			return false, "Đối phương không phải là thành viên bang hội" 
		end
	elseif nType == Wedding.Welcome_PersonalApply then
		local bRet, szMsg = self:CheckApplyWelcome(pPlayer, nInviteId)
		if not bRet then
			return false, szMsg
		end
	else
		return false, "Hoạt động không chính xác"
	end
	return true
end

-- 全程皆可操作
function tbFuben:TrySendWelcome(pPlayer, nType, nInviteId)
	if not self.tbRole[pPlayer.dwID] then
		pPlayer.CenterMsg("Ngươi không có quyền thao tác", true)
		return
	end
	-- 请柬数
	local nWelcomeCount = self.tbWelcomeCount[pPlayer.dwID] or 0 
	-- 双方已经邀请的玩家
	local tbHadWelcome = self.tbHadWelcome
	local tbPlayer, szTip = self:GetWelcomePlayer(pPlayer, nType, nInviteId)
	if not tbPlayer or #tbPlayer <= 0 then
		pPlayer.CenterMsg(szTip, true)
		return 
	end
  	if nWelcomeCount < #tbPlayer then
		local nLack = (#tbPlayer - nWelcomeCount)
		local nCost = self.tbMapSetting.nInviteCost * nLack
  		pPlayer.MsgBox(string.format("Số lượng lời mời của bạn không đủ. Có tốn [FFFE0D]%d Nguyên bảo[-] để mua [FFFE0D]%d lần mời [-] và gửi lời mời không?", nCost, nLack), 
  			{{"確定", self.DoBuyWelcome, self, pPlayer.dwID, nCost, nLack, tbPlayer, nType, nInviteId}, {"取消"}}, "WeddingSendWeldome_Once")
  		return
  	end
  	self:_DoSendWelcome(pPlayer, tbPlayer, nType, nInviteId)
end

function tbFuben:_DoSendWelcome(pPlayer, tbPlayer, nType, nInviteId)
	local bOneKey = not nInviteId
	self.tbWelcomeCount[pPlayer.dwID] = self.tbWelcomeCount[pPlayer.dwID] or 0
	local nSendBefore = self.tbWelcomeCount[pPlayer.dwID]
	if self.tbWelcomeCount[pPlayer.dwID] <= 0 then
		return
	end
	if not tbPlayer or not next(tbPlayer) then
		return
	end
	local szLoveName = self:FemaleName()
  	if pPlayer.dwID == self.nGirlPlayerId then
  		szLoveName = self:ManName()
  	end
  	local nNowTime = GetTime()
  	local tbChange = {}
	for _, nPlayerId in ipairs(tbPlayer) do
		if self.tbWelcomeCount[pPlayer.dwID] > 0 then
			local pWelcomer = KPlayer.GetPlayerObjById(nPlayerId)
			-- 因为是双方都可操作的，存在一种情况，a和b同时邀请，a先付费邀请
			-- 还没回包b直接邀请了，所以这里要检查是否邀请过了
			if pWelcomer and not self.tbHadWelcome[pWelcomer.dwID] then
				self.tbWelcomeCount[pPlayer.dwID] = self.tbWelcomeCount[pPlayer.dwID] - 1
				self.tbHadWelcome[nPlayerId] = pPlayer.dwID
				tbChange[nPlayerId] = pPlayer.dwID
				local nOverdueTime = self:WeddingEndTime()
				-- 发请柬的时候过期了？？
				if nOverdueTime > nNowTime then
					local pItem = pWelcomer.AddItem(Wedding.nWelcomeItemTId, 1, nOverdueTime, Env.LogWay_Wedding)
					pItem.SetIntValue(1, self.nMapId)
					pItem.SetStrValue(1, self:ManName() ..";" ..self:FemaleName())
					pWelcomer.CallClientScript("Ui:NotfifyGetAward", {{"item", Wedding.nWelcomeItemTId, 1}}, nil, true, Env.LogWay_Wedding)
				else
					Log("WeddingFubenBase fn_DoSendWelcome item overdue?? ", pPlayer.dwID, pPlayer.szName, nPlayerId, nOverdueTime, self.nStartWeddingTime)
				end
				local tbAward = self.tbMapSetting.tbInviteAward
				local tbMail = {
					To = nPlayerId;
					Title = "Mời Hôn Lễ";
					From = pPlayer.szName;
					Text = string.format("    Ta sắp cùng「%s」 cử hành [FFFE0D]%s[-] Hôn lễ, mau tới chúc phúc chúng ta đi![FFFE0D] Thiệp mời đã đưa đến trong túi của ngươi, sử dụng sau có thể đến đây tham gia hôn lễ của chúng tôi.[-]", szLoveName, self.tbMapSetting.szWeddingName or "婚禮");
					tbAttach = tbAward;
					nLogReazon = Env.LogWay_Wedding;
				};
				Mail:SendSystemMail(tbMail);
				if not bOneKey then
					pPlayer.CenterMsg(string.format("Đã gửi cho 「%s」 thiệp mời", pWelcomer.szName), true)
				end
				Log("WeddingFubenBase fn_DoSendWelcome Send ", pPlayer.dwID, pPlayer.szName, pWelcomer.dwID, pWelcomer.szName)
			else
				Log("WeddingFubenBase fn_DoSendWelcome Player Offline ", pPlayer.dwID, pPlayer.szName, nPlayerId)
			end
		end 
  	end
  	if bOneKey then
  		pPlayer.CenterMsg("Mời thành công người chơi trong danh sách")
  	end
  	self:SynWelcome(pPlayer, tbChange)
  	local nSendAfter = nSendBefore - self.tbWelcomeCount[pPlayer.dwID]
  	Log("WeddingFubenBase fn_DoSendWelcome ok ", pPlayer.dwID, pPlayer.szName, nSendBefore, nSendAfter, self:GetLogWelcomePlayer(tbPlayer))
end

function tbFuben:GetLogWelcomePlayer(tbPlayer)
	local szLog = ""
	for _, dwID in ipairs(tbPlayer) do
		szLog = string.format("%s_%s", szLog, tostring(dwID))
	end
	return szLog
end

-- 购买请柬的统一接口
function tbFuben:DoBuyWelcome(dwID, nCost, nAddWelcome, tbPlayer, nType, nInviteId)
	local pPlayer = KPlayer.GetPlayerObjById(dwID)
	if not pPlayer or not nCost or nCost <= 0 or not nAddWelcome or nAddWelcome <= 0 then
		return
	end
	-- 群邀
	if not nInviteId then
		local tbSurePlayer = self:GetWelcomePlayer(pPlayer, nType, nInviteId)
		if not tbSurePlayer or #tbSurePlayer ~= #tbPlayer then
			Wedding:SynWelcome(pPlayer)
			pPlayer.CenterMsg("Thành viên đã thay đổi, vui lòng mời lại", true)
			return
		end
	else
		-- 单独邀请
		for _, dwID in ipairs(tbPlayer) do
			local bRet, szMsg = self:CheckPersonApply(pPlayer, nType, dwID)
			if not bRet then
				Wedding:SynWelcome(pPlayer)
				pPlayer.CenterMsg("Thành viên đã thay đổi, vui lòng mời lại", true)
				return
			end
		end
	end
	if pPlayer.GetMoney("Gold") < nCost then
		pPlayer.CenterMsg("Nguyên bảo không đủ ", true)
		pPlayer.CallClientScript("Ui:OpenWindow", "CommonShop", "Recharge", "Recharge");
		return
	end
	local function fnCostCallback(nPlayerId, bSuccess, szBillNo, nCost, nAddWelcome, tbPlayer, nType, nInviteId)
		return self:DoBuyWelcomeAfterCost(nPlayerId, bSuccess, nCost, nAddWelcome, tbPlayer, nType, nInviteId)
	end
	local bRet = pPlayer.CostGold(nCost, Env.LogWay_Wedding, nil, fnCostCallback, nCost, nAddWelcome, tbPlayer, nType, nInviteId);
	if not bRet then
		pPlayer.CenterMsg("Thanh toán thất bại xin sau thử lại!");
	end
end

function tbFuben:DoBuyWelcomeAfterCost(nPlayerId, bSuccess, nCost, nAddWelcome, tbPlayer, nType, nInviteId)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
	if not pPlayer then
    	return false, "Đang phí xử lý, bạn đang offline!";
	end
	if not bSuccess then
		return false, "Thanh toán thất bại xin sau thử lại!";
	end
	if not self.tbRole[nPlayerId] then
		return false, "Ngươi không có quyền thao tác"
	end
	self.tbWelcomeCount[pPlayer.dwID] = (self.tbWelcomeCount[pPlayer.dwID] or 0) + nAddWelcome
	if tbPlayer then
		self:_DoSendWelcome(pPlayer, tbPlayer, nType, nInviteId)
	end
	self:SynWelcomeCount(pPlayer)
	Log("WeddingFubenBase fnDoBuyWelcomeAfterCost ok ", pPlayer.dwID, pPlayer.szName, nCost, nAddWelcome, tbPlayer and "yes" or "no")
end

-- 玩家申请进入婚礼
function tbFuben:ApplyWelcome(pPlayer)
	if self.tbRole[pPlayer.dwID] then
		pPlayer.CenterMsg("Chủ nhà không thể xin ")
		return
	end
	if self.tbHadWelcome[pPlayer.dwID] then
		pPlayer.CenterMsg("Bạn đã nhận được lời mời, xin vui lòng kiểm tra túi")
		return
	end
	if self.tbApplyWelcome[pPlayer.dwID] then
		pPlayer.CenterMsg("Ngươi đã xin qua ")
		return
	end
	local nNowTime = GetTime()
	local pKinData = Kin:GetKinById(pPlayer.dwKinId or 0) or {};
	local tbApplyInfo = 
	{
		nApplyTime = nNowTime;
	}
	self.tbApplyWelcome[pPlayer.dwID] = tbApplyInfo
	local tbSynApplyWdlcome = {
		[pPlayer.dwID] = tbApplyInfo;
	}
	pPlayer.CenterMsg(string.format("Thành công xin tham gia Hôn lễ「%s」 và「%s」, xin chờ đợi xác nhận ", self:ManName(), self:FemaleName()), true)
	local fnSyn = function (self, pPlayer)
		Wedding:SynWeddingApply(pPlayer, tbSynApplyWdlcome, true)
		pPlayer.CallClientScript("Wedding:OnNewApply")
    end
    self:ForeachRole(fnSyn)
end

-- 返回申请信息
function tbFuben:GetApplyWelcome(pPlayer)
	return self.tbRole[pPlayer.dwID] and (self.tbApplyWelcome or {})
end

-- 同意玩家进入婚礼的申请
function tbFuben:CheckApplyWelcome(pPlayer, nWelcomeId)
	if not self.tbRole[pPlayer.dwID] then
		return false, "Ngươi không có quyền thao tác"
	end
	if self.tbRole[nWelcomeId] then
		return false, "Không thể mời gia đình chủ nhà"
	end
	if self.tbHadWelcome[nWelcomeId] then
		return false, "Đã mời người chơi"
	end
	local pRoleStay = KPlayer.GetRoleStayInfo(nWelcomeId or 0)
	if not pRoleStay then
		return false, "Người chơi không tồn tại"
	end
	if not self.tbApplyWelcome[nWelcomeId] then
		return false, "Người chơi chưa đăng ký"
	end
	local pWelcomer = KPlayer.GetPlayerObjById(nWelcomeId)
	if not pWelcomer then
		-- 直接清掉邀请数据
		self.tbApplyWelcome[nWelcomeId] = nil
		Wedding:SynWelcome(pPlayer)
		return false, "Người chơi không trực tuyến"
	end
	return true
end

function tbFuben:SynWelcomeCount(pPlayer)
	local nWelcomeCount = self.tbWelcomeCount[pPlayer.dwID] or 0
	pPlayer.CallClientScript("Wedding:OnSynWelcomeCount", nWelcomeCount)
end

function tbFuben:SynHadWelcome(pPlayer, tbHadWelcome) 
	pPlayer.CallClientScript("Wedding:OnSynHadWelcome", tbHadWelcome or self.tbHadWelcome)
end

function tbFuben:SynWelcome(pPlayer, tbHadWelcome)
	if not self.tbRole[pPlayer.dwID] then
		return 
	end
	self:SynWelcomeCount(pPlayer)
	self:SynHadWelcome(pPlayer, tbHadWelcome)
	pPlayer.CallClientScript("Wedding:OnSynWelcome")
end

function tbFuben:SynWelcomeInfo(pPlayer)
	local tbWelcomeInfo = {}
	tbWelcomeInfo.nMapId = self.nMapId
	tbWelcomeInfo.nLevel = self.nWeddingLevel
	local pBoyInfo = KPlayer.GetRoleStayInfo(self.nBoyPlayerId) or {};
	local pGirlInfo = KPlayer.GetRoleStayInfo(self.nGirlPlayerId) or {};
	tbWelcomeInfo.tbPlayer = {
		[Gift.Sex.Boy] = {
			nPlayerId = self.nBoyPlayerId;
			szName = self:ManName();
		};
		[Gift.Sex.Girl] = {
			nPlayerId = self.nGirlPlayerId;
			szName = self:FemaleName();
		};
	}
	pPlayer.CallClientScript("Wedding:OnSynWelcomeInfo", tbWelcomeInfo)
end


-- 》》开始婚礼
function tbFuben:OnStartWedding()
	self.nProcess = Wedding.PROCESS_STARTWEDDING
	Log("WeddingFubenBase fnOnStartWedding ok >>", self:GetLog())
end

function tbFuben:OnEndWedding()
	if self.nProcess ~= Wedding.PROCESS_STARTWEDDING then
		return 
	end
	self.nProcess = Wedding.PROCESS_NONE
	Log("WeddingFubenBase fnOnEndWedding ok >>", self:GetLog())
	if self.tbSetting.nStartWeddingUnlockId then
   		self:UnLock(self.tbSetting.nStartWeddingUnlockId);
   	end
end

function tbFuben:BeginWedding(dwID)
	local pPlayer = KPlayer.GetPlayerObjById(dwID)
	if not pPlayer then
		return
	end
	if not self.tbRole[dwID] then
		pPlayer.CenterMsg("Ngươi không có quyền thao tác", true)
		return
	end 
	if self.nProcess ~= Wedding.PROCESS_STARTWEDDING then
		pPlayer.CenterMsg("Đám cưới đã bắt đầu", true)
		return
	end

	if not self:CheckStartWeddingTime(pPlayer) then
		pPlayer.CenterMsg("Bạn đã yêu cầu bắt đầu", true)
		return
	end
	local nNotifyId = self:GetOtherPlayerId(dwID) or 0
	local pNotifyer = KPlayer.GetPlayerObjById(nNotifyId)
	if pNotifyer then
		if not self:CheckStartWeddingTime(pNotifyer) then
			pPlayer.CenterMsg("Đối phương đang ở trong quá trình xác nhận", true)
			return
		end
		local fnStart = function ()
			self:OnEndWedding()
		end
		local fnRefuse = function (nPlayerId)
			local pRequester = KPlayer.GetPlayerObjById(nPlayerId)
			if pRequester then
				pRequester.nRequestStartWeddingTime = nil
				pRequester.CenterMsg("Bạn đời của ngươi chưa chuẩn bị xong, hủy bỏ tiến sang giai đoạn sau", true)
				GameSetting:SetGlobalObj(pRequester)
				Dialog:OnMsgBoxSelect(1, true)
				GameSetting:RestoreGlobalObj()
			end
		end
		local fnAgree = function (nPlayerId)
			self:OnEndWedding()
			local pRequester = KPlayer.GetPlayerObjById(nPlayerId)
			if pRequester then
				GameSetting:SetGlobalObj(pRequester)
				Dialog:OnMsgBoxSelect(1, true)
				GameSetting:RestoreGlobalObj()
			end
		end
		local function fnClose()
			me.CallClientScript("Ui:CloseWindow", "MessageBox")
		end
		local szTip = string.format("[FFFE0D]%s[-] đã chuẩn bị xong rồi, nếu ngươi cũng đã chuẩn bị xong thì bắt đầu hôn lễ.", pPlayer.szName)
		pNotifyer.MsgBox(szTip .. "\n(%d giây sau tự động đồng ý)", {{"Bắt đầu hôn lễ", fnAgree, pPlayer.dwID}, {"Hủy", fnRefuse, pPlayer.dwID}}, nil, Wedding.nRequestStartWeddingTime, fnStart)
		pPlayer.MsgBox("Đợi bạn đời xác nhận: %d", {{"Xác nhận", fnClose}}, nil, Wedding.nRequestStartWeddingTime, function () 
			me.CallClientScript("Ui:CloseWindow", "MessageBox")
		 end)
		pPlayer.nRequestStartWeddingTime = GetTime()
	else
		self:OnEndWedding()
	end
end

function tbFuben:CheckStartWeddingTime(pPlayer)
	local nNowTime = GetTime()
	if pPlayer.nRequestStartWeddingTime and nNowTime - pPlayer.nRequestStartWeddingTime < Wedding.nRequestStartWeddingTime then
		return
	end
	return true
end

-- 》》山盟海誓
function tbFuben:OnStartPromise()
	local nNowTime = GetTime()
	self.nProcess = Wedding.PROCESS_PROMISE
	local fnStart = function (self, pPlayer)
    	pPlayer.CallClientScript("Wedding:OnRolePromiseState")
    end
    self:ForeachRole(fnStart)
    self:OnBlackMsgWithRole(Wedding.szPromiseStartTip)
    Log("WeddingFubenBase fnOnStartPromise ok >>", self:GetLog())
end

function tbFuben:OnEndPromise()
	if self.nProcess ~= Wedding.PROCESS_PROMISE then
		return 
	end
	for dwID in pairs(self.tbRole) do
		if not self.tbPromise[dwID] then
			self:TryPromise(dwID, Wedding.szPromiseDefault, true)
		end
	end
	self.nProcess = Wedding.PROCESS_NONE
	local pBoy = KPlayer.GetPlayerObjById(self.nBoyPlayerId)
	local pGirl = KPlayer.GetPlayerObjById(self.nGirlPlayerId)
	if pBoy and pGirl then
		local szBoyPromise = self.tbPromise[self.nBoyPlayerId] and self.tbPromise[self.nBoyPlayerId].szMsg
		local szGirlPromise = self.tbPromise[self.nGirlPlayerId] and self.tbPromise[self.nGirlPlayerId].szMsg
		local nLove, nWeddingTime = Wedding:GetLover(pBoy.dwID)
		if szBoyPromise and szGirlPromise and nWeddingTime and nWeddingTime > 0 then
			Wedding:AddMarriagePaper(pBoy, pGirl, szBoyPromise, szGirlPromise, nWeddingTime, self.nWeddingLevel)
		else
			Log("WeddingFubenBase AddPromiseItem Fail ", pBoy.dwID, pGirl.dwID, szBoyPromise, szGirlPromise, nWeddingTime, self:GetLog())
		end
	else
		Log("WeddingFubenBase fnOnEndPromise Player Offline >>", pBoy and 1 or 0, pGirl and 1 or 0, self:GetLog())
	end
	
	if self.tbSetting.nEndPromiseUnlockId then
    	self:UnLock(self.tbSetting.nEndPromiseUnlockId);
   	end
	Log("WeddingFubenBase fnOnEndPromise ok >>", self:GetLog())
end

function tbFuben:TryPromise(dwID, szMsg, bSystem)
	local pPlayer = KPlayer.GetPlayerObjById(dwID)
	if not self.tbRole[dwID] then
		if pPlayer then
			pPlayer.CenterMsg("Bạn không có quyền tuyên thệ", true)
		end
		return
	end
	if self.tbPromise[dwID] then
		if pPlayer then
			pPlayer.CenterMsg("Ngài đã tuyên thệ", true)
		end
		return
	end
	if self.nProcess ~= Wedding.PROCESS_PROMISE then
		if pPlayer then
			pPlayer.CenterMsg("Giai đoạn tuyên thệ đã kết thúc", true)
		end
		return 
	end
	if not bSystem then
		if version_kor then
			local nKorLen = string.len(szMsg);
			if nKorLen > Wedding.nKorPromiseMax or nKorLen < Wedding.nKorPromiseMin then
				if pPlayer then
					pPlayer.CenterMsg(string.format("Độ dài của lời thề cần phải là %d~%d ký tự", Wedding.nVNPromiseMin, Wedding.nVNPromiseMax), true)
				end
				return 
			end
		elseif version_vn then
			local nVNLen = string.len(szMsg);
			if nVNLen > Wedding.nVNPromiseMax or nVNLen < Wedding.nVNPromiseMin then
				if pPlayer then
					pPlayer.CenterMsg(string.format("Độ dài của lời thề cần phải là %d~%d ký tự", Wedding.nVNPromiseMin, Wedding.nVNPromiseMax), true)
				end
				return 
			end
		elseif version_th then
			local nNameLen = Lib:Utf8Len(szMsg);
			if nNameLen > Wedding.nTHPromiseMax or nNameLen < Wedding.nTHPromiseMin then
				if pPlayer then
					pPlayer.CenterMsg(string.format("Độ dài của lời thề cần phải là %d~%d ký tự", Wedding.nTHPromiseMin, Wedding.nTHPromiseMax), true)
				end
				return 
			end
		else
			local nNameLen = Lib:Utf8Len(szMsg);
			if nNameLen > Wedding.nPromiseMax or nNameLen < Wedding.nPromiseMin then
				if pPlayer then
					pPlayer.CenterMsg(string.format("Độ dài của lời thề cần phải là %d~%d ký tự", Wedding.nPromiseMin, Wedding.nPromiseMax), true)
				end
				return
			end
			if Lib:HasNonChineseChars(szMsg) then
				if pPlayer then
					pPlayer.CenterMsg("Lời thề chỉ có thể sử dụng các ký tự Trung Quốc, vui lòng sửa đổi và thử lại!", true)
				end
		        return
		    end
		end
		if ReplaceLimitWords(szMsg) then
			if pPlayer then
				pPlayer.CenterMsg("Lời thề chứa các từ nhạy cảm, xin vui lòng sửa đổi và thử lại!", true)
			end
			return
		end
	end
	
	self.tbPromise[dwID] = {szMsg = szMsg}
	local szMeTitle = self.nBoyPlayerId == dwID and "Tân Lang" or "Tân Nương"
	local szMeName = self.nBoyPlayerId == dwID and self:ManName() or self:FemaleName()
	local szOtherTitle = self.nBoyPlayerId == dwID and "Tân Nương" or "Tân Lang"
	local szOtherName = self.nBoyPlayerId == dwID and self:FemaleName() or self:ManName()

	local szNotice = string.format(Wedding.szPromiseNotice, szMeTitle, szMeName, self.tbMapSetting.szWeddingName, szOtherTitle, szOtherName, szMsg)
	KPlayer.SendWorldNotify(1, 999, szNotice, 1, 1)
	if pPlayer then
		pPlayer.CallClientScript("Wedding:OnFinishPromise")
	end
	local bEnd = self.tbPromise[self.nBoyPlayerId] and self.tbPromise[self.nGirlPlayerId]
	if bEnd and not bSystem then
		self:OnEndPromise()
	end
	Log("WeddingFubenBase fnTryPromise ok ", dwID, szNotice, pPlayer and 1 or 0, bEnd and 1 or 0)
end

-- 》》开心爆竹
function tbFuben:OnAddFirecracker(nX, nY)
	if not nX or not nY then
		return
	end
	self.nProcess = Wedding.PROCESS_FIRECRACKER
	local pNpc = KNpc.Add(Wedding.nFirecrackerNpcTId, 1, 0, self.nMapId, nX, nY, 0, 0);
	if pNpc then
		pNpc.tbTmp = pNpc.tbTmp or {}
		pNpc.tbTmp.nBoomTime = 0
		Timer:Register(Env.GAME_FPS, self.FirecrackerBoom, self, pNpc.nId);
	else
		Log("WeddingFubenBase fnOnAddFirecracker fail ", self:GetLog(), nX, nY)
	end
	Log("WeddingFubenBase fnOnAddFirecracker ok >>", self:GetLog())
end

function tbFuben:OnEndFirecracker()
	if self.nProcess ~= Wedding.PROCESS_FIRECRACKER then
		return 
	end
	self.nProcess = Wedding.PROCESS_NONE
	Log("WeddingFubenBase fnOnEndFirecracker ok >>", self:GetLog())
end

function tbFuben:FirecrackerBoom(nNpcId)
	local pNpc = KNpc.GetById(nNpcId)
	if not pNpc then
		return false
	end
	local nBoomTime = pNpc.tbTmp and pNpc.tbTmp.nBoomTime
	if not nBoomTime or nBoomTime > Wedding.nFirecrackerBoomTime then
		return false
	end
	nBoomTime = nBoomTime + 1
	pNpc.tbTmp.nBoomTime = nBoomTime
	local nRemainTime = Wedding.nFirecrackerBoomTime - nBoomTime
	local szMsg = Wedding.tbFirecrackerMsg[nBoomTime]
	local fnMsg = function (pPlayer)
		Dialog:SendBlackBoardMsg(pPlayer, string.format(szMsg, nRemainTime));
	end;
	if szMsg then
		self:AllPlayerExcute(fnMsg);
	end
	local nNowTime = GetTime()
	if (nBoomTime == Wedding.nFirecrackerBoomTime and not pNpc.tbTmp.bSendAward) then
		pNpc.tbTmp.bSendAward = true
		local tbPlayer = KNpc.GetAroundPlayerList(nNpcId, Wedding.nFirecrackerDis) or {}
		local tbTitlePlayer = {}
		for _, pPlayer in pairs(tbPlayer) do
			pPlayer.SendAward(self.tbFirecrackerAward, nil, true, Env.LogWay_Wedding)
			ChatMgr:SendPlayerMsg(ChatMgr.ChannelType.Nearby, pPlayer.dwID, pPlayer.szName, pPlayer.nFaction, pPlayer.nPortrait, pPlayer.nSex, pPlayer.nLevel, Wedding.szFirecrackerBoomMsg)
			local bRole = self.tbRole[pPlayer.dwID]
			local pNpc = pPlayer.GetNpc()
			if pNpc then
				if bRole then
					pNpc.DoCommonAct(Wedding.nFirecrackerRoleActionID, 10002, 1, 0, 1);
				else
					pNpc.DoCommonAct(Wedding.nFirecrackerActionID, 10002, 1, 0, 1);
				end
			end
			-- 排除主角
			if not self.tbRole[pPlayer.dwID] then
				table.insert(tbTitlePlayer, pPlayer)
			end
		end
		local fnRand = Lib:GetRandomSelect(#tbTitlePlayer)
		local pHitPlayer = tbTitlePlayer[fnRand()]
		if pHitPlayer then
			pHitPlayer.SendAward({{"AddTimeTitle", Wedding.nFirecrackerTitle, Wedding.nFirecrackerTitleOverdueTime + nNowTime, true}}, nil, true, Env.LogWay_Wedding)
			local szNotice = string.format(Wedding.nFirecrackerTitleMsg, pHitPlayer.szName, self:ManName(), self:FemaleName())
			KPlayer.SendWorldNotify(1, 999, szNotice, 1, 1)
		end
		
	end
	if nBoomTime >= Wedding.nFirecrackerBoomTime then
		pNpc.Delete();
		return false
	end
	return true
end

-- 》》 同心果
function tbFuben:OnAddConcentricFruit(nX, nY)
	if not nX or not nY or self.nConcentricFruitNpc then
		return
	end
	self.nProcess = Wedding.PROCESS_CONCENTRIC
	local pNpc = KNpc.Add(Wedding.nConcentricFruitNpcTId, 1, 0, self.nMapId, nX, nY, 0, 0);
	if pNpc then
		pNpc.tbTmp = pNpc.tbTmp or {}
		pNpc.tbTmp.tbPlayer = {[self.nBoyPlayerId] = true, [self.nGirlPlayerId] = true}
		self.nConcentricFruitNpc = pNpc.nId
		self:BlackMsg(string.format("Các ngươi đã thử %d giây nhưng chưa đồng lòng? Các ngươi hãy cố gắng lên!", Wedding.nConcentricFruitHitTime))
	else
		Log("WeddingFubenBase fnOnAddConcentricFruit fail ", self:GetLog(), nX, nY)
	end
	Log("WeddingFubenBase fnOnAddConcentricFruit ok >>", self:GetLog())
end

function tbFuben:OnEndConcentricFruit()
	if self.nProcess ~= Wedding.PROCESS_CONCENTRIC then
		return 
	end
	local pNpc = KNpc.GetById(self.nConcentricFruitNpc)
	if not pNpc then
		Log("WeddingFubenBase fnOnEndConcentricFruit no npc", self.nConcentricFruitNpc, self:GetLog())
		return
	end
	self.nProcess = Wedding.PROCESS_NONE
	self.nConcentricFruitNpc = nil
	self:ConcentricFruitSuccess(pNpc, true)
	Log("WeddingFubenBase fnOnEndConcentricFruit ok >>", self:GetLog())
end

-- 失败
function tbFuben:ConcentricFruitFail(pPlayer)
	self:BlackMsg(Wedding.szConcentricFruitFailMsg)
end

-- 成功
function tbFuben:ConcentricFruitSuccess(pNpc, bDefault)
	pNpc.tbTmp = pNpc.tbTmp or {}
	if pNpc.tbTmp.bAward then
		return
	end
	pNpc.tbTmp.bAward = true
	for dwID in pairs(self.tbRole) do
		local pPlayer = KPlayer.GetPlayerObjById(dwID)
		if pPlayer then
			pPlayer.CenterMsg("Chúc mừng thu được quả đồng tâm, các ngươi thực sự là một đôi hiểu nhau!", true)
			pPlayer.SendAward(self.tbConcentricFruitAward, nil, true, Env.LogWay_Wedding)
		else
			Log("WeddingFubenBase fnConcentricFruitSuccess player offline ", self:GetLog(), dwID)
		end
	end
	self:BlackMsg(Wedding.szConcentricFruitSuccessMsg)
	pNpc.Delete()
	if self.tbSetting.nEndConcentricFruitUnlockId then
   		self:UnLock(self.tbSetting.nEndConcentricFruitUnlockId);
   	end
	Log("WeddingFubenBase fnConcentricFruitSuccess ok ", bDefault and 1 or 0, self:GetLog())
end

-- 》》宴席
function tbFuben:OnStartTableFood()
	self.nProcess = Wedding.PROCESS_WEDDINGTABLE
	self.nFoodCount = (self.nFoodCount or 0) + 1
	self.tbEatPlayer = self.tbEatPlayer or {}
	self.tbEatPlayer[self.nFoodCount] = {}
	Log("WeddingFubenBase fnOnStartTableFood ok >>", self:GetLog())
end

function tbFuben:OnEndTableFood()
	if self.nProcess ~= Wedding.PROCESS_WEDDINGTABLE then
		return 
	end
	self.nProcess = Wedding.PROCESS_NONE
	self.nFoodCount = 0
	self.tbEatPlayer = {}
	Log("WeddingFubenBase fnOnEndTableFood ok >>", self:GetLog())
end

function tbFuben:TryEat(pPlayer)
	if self.nProcess ~= Wedding.PROCESS_WEDDINGTABLE then
		pPlayer.CenterMsg("Không ăn được ở giai đoạn hiện tại", true)
		return
	end
	local nEatCount = self.tbEatPlayer[self.nFoodCount][pPlayer.dwID] or 0
	if nEatCount >= Wedding.nMaxDinnerEat then
		pPlayer.CenterMsg("Bạn đã nếm thử món ăn này.", true)
		return
	end
	self.tbEatPlayer[self.nFoodCount][pPlayer.dwID] = nEatCount + 1
	pPlayer.SendAward(self.tbDinnerAward, nil, true, Env.LogWay_Wedding)
	pPlayer.GetNpc().RestoreAction()
end
-- 先屏蔽
-- function tbFuben:OnAddNpc(pNpc)
-- 	if pNpc.szClass == "WeddingTableNpc" then
-- 		local nCountDown = tonumber(pNpc.szScriptParam) or 0
-- 		local nNowTime = GetTime()
-- 		local nCountDownEnd = nNowTime + nCountDown
-- 		if nCountDownEnd > nNowTime then
-- 			self.tbWeddingTableNpc = self.tbWeddingTableNpc or {}
-- 			self.tbWeddingTableNpc[pNpc.nId] = {nCountDownEnd, pNpc.szName}
-- 			self:TrySynTableNpcData()
-- 		end
-- 	end
-- end
-- 同步宴会倒计时NPC
function tbFuben:TrySynTableNpcData()
	-- 先屏蔽
	if 1 then
		return
	end
	local nNowTime = GetTime()
	local tbData = {}
	for nNpcId, v in pairs(self.tbWeddingTableNpc or {}) do
		local pNpc = KNpc.GetById(nNpcId)
		if pNpc then
			local nCountDownEnd = v[1]
			if nCountDownEnd > nNowTime then
				tbData[nNpcId] = v
			else
				self.tbWeddingTableNpc[nNpcId] = nil
			end
		else
			self.tbWeddingTableNpc[nNpcId] = nil
		end
	end
	local fnSyn = function (pPlayer)
		pPlayer.CallClientScript("Wedding:OnSynTableNpcData", tbData)
	end
	if next(tbData) then
		self:AllPlayerInMapExcute(fnSyn);
	end
end

-- 》》撒喜糖
function tbFuben:OnStartCandy()
	self.nProcess = Wedding.PROCESS_CANDY
	local fnCandy = function (self, pPlayer)
		pPlayer.CallClientScript("Fuben:SetBtnCandy", true)
	end
	self:ForeachRole(fnCandy)
	Log("WeddingFubenBase fnOnStartCandy ok >>", self:GetLog())
end

function tbFuben:OnEndCandy()
	if self.nProcess ~= Wedding.PROCESS_CANDY then
		return 
	end
	self.nProcess = Wedding.PROCESS_NONE
	local fnCandy = function (self, pPlayer)
		pPlayer.CallClientScript("Fuben:SetBtnCandy", false)
	end
	self:ForeachRole(fnCandy)
	--self:ClearAllCandy()
	Log("WeddingFubenBase fnOnEndCandy ok >>", self:GetLog())
end

-- 主动刷喜糖
function tbFuben:OnThrowCandy()
	local tbNpc = Wedding:AddCandy(Wedding.szFubenCandy, self.tbCandySetting.nCandyCount, self.tbCandyPos, self.nMapId, self.tbRole)
	self:OnAddCandyNpc(tbNpc)
	self:BlackMsg(Wedding.szCandyFubenThrowMsg)
end

-- 付费扔喜糖
function tbFuben:SendCandy(pPlayer)
	local bRet, szMsg, nSendType = self:CheckSendCandy(pPlayer)
	if not bRet then
		pPlayer.CenterMsg(szMsg, true)
		return
	end
	if not nSendType or (nSendType ~= Wedding.Candy_Type_Free and nSendType ~= Wedding.Candy_Type_Pay) then
		return
	end

	local fnSend = function ()
		local tbNpc = Wedding:AddCandy(Wedding.szFubenCandy, self.tbCandySetting.nCandyCount, self.tbCandyPos, self.nMapId, self.tbRole)
		self:OnAddCandyNpc(tbNpc)
		self:OnBlackMsgWithRole(Wedding.szCandyFubenSendMsg)
	end;
	self.tbCandyTimes = self.tbCandyTimes or {}
	self.tbCandyTimes[pPlayer.dwID] = self.tbCandyTimes[pPlayer.dwID] or {}
	if nSendType == Wedding.Candy_Type_Free then
		self.tbCandyTimes[pPlayer.dwID][Wedding.Candy_Type_Free] = (self.tbCandyTimes[pPlayer.dwID][Wedding.Candy_Type_Free] or 0) + 1
		fnSend()
		pPlayer.nSendWeddingCandyTime = GetTime()
		Log("WeddingFubenBase fnSendCandy Free", pPlayer.dwID, pPlayer.szName, self.tbCandyTimes[pPlayer.dwID][Wedding.Candy_Type_Free])
		return
	end
	if pPlayer.GetMoney("Gold") < self.tbCandySetting.nPayCost then
		pPlayer.CallClientScript("Ui:OpenWindow", "CommonShop", "Recharge", "Recharge");
		pPlayer.CenterMsg("Nguyên bảo không đủ ", true)
		return
	end
	-- CostGold谨慎调用, 调用前请搜索 _LuaPlayer.CostGold 查看使用说明, 它处调用时请保留本注释
	pPlayer.CostGold(self.tbCandySetting.nPayCost, Env.LogWay_Wedding, string.format("%s,%s", self.nBoyPlayerId or "", self.nGirlPlayerId or ""),
			function (nPlayerId, bSuccess, szBilloNo)
				local szFailMsg = ""
				local pPlayer = KPlayer.GetPlayerObjById(nPlayerId);
				if not pPlayer then
					szFailMsg = "Đang mua số lần, ngày Offline"
					return false, szFailMsg;
				end
				if not bSuccess then
					szFailMsg = "Thanh toán thất bại xin sau thử lại "
					pPlayer.CenterMsg(szFailMsg, true)
					return false, szFailMsg;
				end
				local bRet, szMsg, nSendType = self:CheckSendCandy(pPlayer)
				if not bRet then
					szFailMsg = szMsg
					pPlayer.CenterMsg(szFailMsg, true)
					return false, szFailMsg;
				end
				if nSendType ~= Wedding.Candy_Type_Pay then
					szFailMsg = "Dữ liệu thay đổi?"
					pPlayer.CenterMsg(szFailMsg, true)
					return false, szFailMsg
				end;
				self.tbCandyTimes[pPlayer.dwID][Wedding.Candy_Type_Pay] = (self.tbCandyTimes[pPlayer.dwID][Wedding.Candy_Type_Pay] or 0) + 1
				fnSend()
				pPlayer.nSendWeddingCandyTime = GetTime()
				Log("WeddingFubenBase fnSendCandy pay", pPlayer.dwID, pPlayer.szName, self.tbCandyTimes[pPlayer.dwID][Wedding.Candy_Type_Pay])
				return true;
			end);	
end

function tbFuben:OnAddCandyNpc(tbNpc)
	self.tbAllCandyNpc = self.tbAllCandyNpc or {}
	for _, nNpcId in ipairs(tbNpc) do
		table.insert(self.tbAllCandyNpc, nNpcId)
	end
end

-- 清理喜糖
function tbFuben:ClearAllCandy()
	for _, nNpcId in ipairs(self.tbAllCandyNpc or {}) do
		local pNpc = KNpc.GetById(nNpcId);
		if pNpc then
			pNpc.Delete()
		end
	end
	self.tbAllCandyNpc = nil
end

function tbFuben:CheckSendCandy(pPlayer)
	if not self.tbRole[pPlayer.dwID] then
		return false, "Ngươi không có quyền thao tác"
	end
	if self.nProcess ~= Wedding.PROCESS_CANDY then
		return false, "Giai đoạn này không thể phát kẹo cưới"
	end
	self.tbCandyTimes = self.tbCandyTimes or {}
	self.tbCandyTimes[pPlayer.dwID] = self.tbCandyTimes[pPlayer.dwID] or {}
	local nCandyFreeTimes = self.tbCandyTimes[pPlayer.dwID][Wedding.Candy_Type_Free] or 0
	if nCandyFreeTimes < self.nMaxFreeSendCandy then
		return true, nil, Wedding.Candy_Type_Free
	end
	local nCandyCostTimes = self.tbCandyTimes[pPlayer.dwID][Wedding.Candy_Type_Pay] or 0
	if nCandyCostTimes < self.nMaxCostSendCandy then
		return true, nil, Wedding.Candy_Type_Pay
	end
	return false, "Kẹo cưới đã phát xong"
end

-- 》》祝福
function tbFuben:TryBless(pPlayer, nIdx)
	if pPlayer.nMapId ~= self.nMapId then
		pPlayer.CenterMsg("Chỉ có thể gửi lời chúc phúc tại cảnh đám cưới", true)
		return
	end
	if self.tbRole[pPlayer.dwID] then
		pPlayer.CenterMsg("Không thể chúc phúc mình ", true)
		return
	end
	local tbBlessMsg = Wedding.tbBlessMsg[nIdx]
	if not tbBlessMsg then
		pPlayer.CenterMsg("Vui lòng chọn lời chúc được đưa ra bởi hệ thống.", true)
		return
	end
	ChatMgr:SendPlayerMsg(ChatMgr.ChannelType.Nearby, pPlayer.dwID, pPlayer.szName, pPlayer.nFaction, pPlayer.nPortrait, pPlayer.nSex, pPlayer.nLevel, string.format(tbBlessMsg[2], self:ManName(), self:FemaleName()))
	pPlayer.CallClientScript("Wedding:OnBlessEnd");
end

--》》送礼金
function tbFuben:OpenCashPanel(pPlayer)
	if self.nProcess == Wedding.PROCESS_END or self.bClose == 1 then
		pPlayer.CenterMsg("Hôn lễ đã kết thúc, không cách nào đưa tặng tiền biếu ")
		return
	end
	pPlayer.CallClientScript("Ui:OpenWindow", "WeddingCashGiftPanel", self.nBoyPlayerId, self.nGirlPlayerId)
end

-- 》》放烟花
function tbFuben:OnPlayWeddingFirework(nId)
	local fnExcute = function (pPlayer)
		pPlayer.CallClientScript("Wedding:PlayWeddingFubenFirework", nId)
    end
    self:AllPlayerExcute(fnExcute)
end

-- 》》婚礼结束
function tbFuben:OnWeddingEnd()
	self.nProcess = Wedding.PROCESS_END
	-- 保证只调一次(发礼金)
	if not self.bSendCash then
		Wedding:CashGiftSendToHost(self.nBoyPlayerId, self.nGirlPlayerId)
		self.bSendCash = true
		Log("WeddingFubenBase fnCashGiftSendToHost ok >>", self:GetLog())
	end
	local fnEnd = function (self, pPlayer)
    	pPlayer.CallClientScript("Fuben:ShowLeave");
    end
    self:ForeachRole(fnEnd)
    Log("WeddingFubenBase fnOnWeddingEnd ok >>", self:GetLog())
end

function tbFuben:OnSendKinNotice(szMsg)
	local pBoyInfo = KPlayer.GetPlayerObjById(self.nBoyPlayerId) or KPlayer.GetRoleStayInfo(self.nBoyPlayerId)
	local nBoyKinId = pBoyInfo and pBoyInfo.dwKinId or 0
	local pGirlInfo = KPlayer.GetPlayerObjById(self.nGirlPlayerId) or KPlayer.GetRoleStayInfo(self.nGirlPlayerId)
	local nGirlKinId = pGirlInfo and pGirlInfo.dwKinId or 0
	local tbKinId = {}
	if nBoyKinId > 0 then
		table.insert(tbKinId, nBoyKinId)
	end
	if nGirlKinId > 0 and nGirlKinId ~= nBoyKinId then
		table.insert(tbKinId, nGirlKinId)
	end
	for _, nKinId in ipairs(tbKinId) do
		ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, string.format(szMsg, self:ManName(), self:FemaleName()), nKinId);
	end
end

function tbFuben:OnPlayerTrap(pPlayer, szTrapName)
	if not self.tbRole[pPlayer.dwID] then
		return
	end
	local tbTrapInfo = self.tbMapSetting.tbTrapInfo
	local tbTrap = tbTrapInfo and tbTrapInfo[szTrapName]
	local tbPos = tbTrap and tbTrap.tbPos
	if not tbPos then
		Log("WeddingFubenBase fnOnPlayerTrap fail ", pPlayer.dwID, pPlayer.szName, szTrapName, self:GetLog())
		return
	end
	pPlayer.SetPosition(unpack(tbPos))
end
	


