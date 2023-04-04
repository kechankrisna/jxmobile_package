local tbRentDef = DrinkHouse.tbRentDef
local tbDef = DrinkHouse.tbDef
local tbFuben        = Fuben:CreateFubenClass("DrinkRentFubenBase")

function tbFuben:OnCreate(dwKinId, dwMasterRoleId)
	self.bOpenFuben = true;
	self.dwKinId = dwKinId
	self.dwMasterRoleId = dwMasterRoleId
	self.nServerFoodCount = 0
	self.tbPlayerInfos = {};
	self.tbPlayerEatFoodCount = {};
	OpenAllDynamicObstacle(self.nMapId)
	self.fnRandomSelectNormalPos = Lib:GetRandomSelect(#tbRentDef.NORMAL_RAND_POS)

	self:Start() 
	Timer:Register(1, self.TimerInit, self)
end

function tbFuben:TimerInit(  )
	if not self.nMapId then
		return
	end
	for i,tbFurnitureInfo in ipairs(tbDef.AddFurnitureSetting) do
		Decoration:NewDecoration(self.nMapId, tbFurnitureInfo.nPosX, tbFurnitureInfo.nPosY, tbFurnitureInfo.nRotation, tbFurnitureInfo.nTemplate)
	end
	local tbTableNpcIds = {};
	for i,tbNpcInfo in ipairs(tbRentDef.AddNpcSetting) do
		local pNpc = KNpc.Add(tbNpcInfo.nTemplate, tbNpcInfo.nLevel, -1, self.nMapId, tbNpcInfo.nPosX, tbNpcInfo.nPosY, 0, tbNpcInfo.nDir);
		if pNpc then
			table.insert(tbTableNpcIds, pNpc.nId)
		end
	end
	self.tbTableNpcIds = tbTableNpcIds
end


function tbFuben:OnLogin()
	me.CallClientScript("DrinkHouse:OnEnterRentFuben")
end


function tbFuben:OnJoin(pPlayer)
	pPlayer.CallClientScript("DrinkHouse:OnEnterRentFuben")
	self.tbPlayerInfos[pPlayer.dwID] = self.tbPlayerInfos[pPlayer.dwID] or {}; 
	local tbInfo = self.tbPlayerInfos[pPlayer.dwID];
	tbInfo.nOnLeaveKinRegID = PlayerEvent:Register(pPlayer, "OnLeaveKin", self.OnPlayerLeaveKin, self);
	local nIndex = self.fnRandomSelectNormalPos()
	local x, y = unpack(tbRentDef.NORMAL_RAND_POS[nIndex])
	pPlayer.SetPosition(x, y)
end

function tbFuben:OnOut( pPlayer )
	local tbInfo = self.tbPlayerInfos[pPlayer.dwID]
	if tbInfo.nOnLeaveKinRegID then
		PlayerEvent:UnRegister(pPlayer, "OnLeaveKin", tbInfo.nOnLeaveKinRegID);
		tbInfo.nOnLeaveKinRegID = nil;
    end
end

function tbFuben:OnServeFood(  )
	self.nServerFoodCount = self.nServerFoodCount + 1;
	self.tbDiceData = {};
	if self.nServerFoodCount == 1 then
		local pRoleInfo = KPlayer.GetRoleStayInfo(self.dwMasterRoleId)
		ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, string.format("「%s」tổ chức yến hội đã bắt đầu, mọi người nhanh đi hưởng dụng món ngon đi.", pRoleInfo.szName), self.dwKinId)
	end
	local szName = tbRentDef.FOOD_NAME[self.nServerFoodCount] 
	for i,nNpcId in ipairs(self.tbTableNpcIds) do
		local pNpc = KNpc.GetById(nNpcId)
		if pNpc then
			pNpc.SetName(szName)
		end
	end
	local tbPlayers = KPlayer.GetMapPlayer(self.nMapId)
	for i,pPlayer in ipairs(tbPlayers) do
		for _,nNpcId in ipairs(self.tbTableNpcIds) do
			pPlayer.SyncNpc(nNpcId)
		end
	end
end

function tbFuben:OnKinMessage(szMsg)
	local pRoleInfo = KPlayer.GetRoleStayInfo(self.dwMasterRoleId)
	ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, string.format(szMsg, pRoleInfo.szName), self.dwKinId)
end

function tbFuben:OnMapNotify(szNotify)
	KPlayer.MapBoardcastScript(self.nMapId, "Ui:OnWorldNotify", szNotify, 1, 1)	
end

function tbFuben:OnClose(  )
	if not self.bOpenFuben then
		return
	end
	self.bOpenFuben = nil; --DrinkHouse:OnCloseFuben不可多次掉不然会影响到连续多开场次的家族
	local tbAllPlayer = KPlayer.GetMapPlayer(self.nMapId);
	for _, pPlayer in pairs(tbAllPlayer) do
		pPlayer.GotoEntryPoint();
	end
	DrinkHouse:OnCloseFuben(self.dwKinId, self.nMapId)
end

function tbFuben:OnPlayerLeaveKin()
	me.GotoEntryPoint();
end

function tbFuben:PlayerEatFood( pPlayer, pTableNpc )
	if self.nServerFoodCount == 0 then
		return
	end
	local tbInfo = self.tbPlayerInfos[pPlayer.dwID]
	if not tbInfo then
		return
	end
	local nEatCount = tbInfo.nEatCount or 0
	if nEatCount >= self.nServerFoodCount then
		pPlayer.CenterMsg("Ngươi đã thưởng thức qua món ăn này", true)
		return
	end
	local pNpc = pPlayer.GetNpc()
	if pNpc then
		pNpc.DoCommonAct(tbRentDef.nDinnerActionID, tbRentDef.nDinnerActionEventID, 1, 0, 1);
	end
	GeneralProcess:StartProcessExt(pPlayer, tbRentDef.nDinnerWaitTime * Env.GAME_FPS, true, pTableNpc.nId, 300, "Đang dùng", {self.EndProcessEndEat, self, pPlayer.dwID, pTableNpc.nId} );
end

function tbFuben:EndProcessEndEat( dwRoleId, nTableNpcId )
	local tbInfo = self.tbPlayerInfos[dwRoleId]
	if not tbInfo then
		return
	end
	local pPlayer = KPlayer.GetPlayerObjById(dwRoleId)
	if not pPlayer then
		return
	end
	local pNpc = KNpc.GetById(nTableNpcId)
	if not pNpc then
		return
	end
	local nEatCount = tbInfo.nEatCount or 0
	if nEatCount >= self.nServerFoodCount then
		pPlayer.CenterMsg("Ngươi đã thưởng thức qua món ăn này", true)
		return
	end
	
	tbInfo.nEatCount = self.nServerFoodCount
	pPlayer.GetNpc().RestoreAction()
	pPlayer.SendAward(tbRentDef.FOOD_AWARD[self.nServerFoodCount], nil, nil, Env.LogWay_RentDrinkHouse)
end

function tbFuben:DiceShake(pPlayer)
	if not self.tbDiceData then
		return
	end
	local nDiceSoce = self.tbDiceData[pPlayer.dwID]
	if nDiceSoce then
		pPlayer.CenterMsg("Bạn đã nếm qua")
		return
	end
	local tbInfo = self.tbPlayerInfos[pPlayer.dwID]
	if not tbInfo then
		return
	end
	local nAllScore = 0;
	local tbScore = {};
	if tbInfo.bPoolGuy then
		local tbPoolDiceGroup = tbRentDef.tbPoolDiceGroup
		local nRandIndex = MathRandom(1, #tbPoolDiceGroup)
		local tbDiceNum = tbPoolDiceGroup[nRandIndex]
		for i,nScore in ipairs(tbDiceNum) do
			nAllScore = nAllScore + nScore;
			table.insert(tbScore, nScore);
		end
	else
		for i = 1, 3 do
			local nScore = MathRandom(6);
			nAllScore = nAllScore + nScore;
			table.insert(tbScore, nScore);
		end	
	end

	self.tbDiceData[pPlayer.dwID] = nAllScore
	local szMsg = string.format("Ta ném %s%s%s (Chung %d điểm)",
					ChatMgr.DiceEmtionMap[tbScore[1]],
					ChatMgr.DiceEmtionMap[tbScore[2]],
					ChatMgr.DiceEmtionMap[tbScore[3]],
					nAllScore);

	ChatMgr:SendPlayerMsg(ChatMgr.ChannelType.Kin, pPlayer.dwID, pPlayer.szName, pPlayer.nFaction, pPlayer.nPortrait, pPlayer.nSex, pPlayer.nLevel, szMsg)
	pPlayer.CallClientScript("Kin:OnSyncGatherDice", tbScore);
end

function tbFuben:OnOpenDice( )
	KPlayer.MapBoardcastScript(self.nMapId, "Ui:OpenWindow",  "KinDicePanel", GetTime() + tbRentDef.nDiceTimeOutTime, "DrinkHouse", string.format("Vòng %d", self.nServerFoodCount))
end

function tbFuben:OnEndDice( )
	local tbDiceData = self.tbDiceData
	if not tbDiceData then
		Log(debug.traceback())
		return
	end
	self.tbDiceData = nil;
	local tbSortData = {};
	for k,v in pairs(tbDiceData) do
		table.insert(tbSortData, {k,v})
	end
	table.sort( tbSortData, function (a, b)
		return a[2] > b[2]
	end )
	local nToTalNum = #tbSortData
	local nDiceTopShowNum = math.min(tbRentDef.nDiceTopShowNum, nToTalNum) 
	if nDiceTopShowNum == 0 then
		Log("tbFuben:OnEndDice nDiceTopShowNum == 0", self.nMapId, nDiceTopShowNum)
		return
	end
	local tbDicePriceMail = Lib:CopyTB(tbRentDef.DicePriceMail) 
	local szPriceMsg = string.format("Tổng quản Bang: Chúc mừng thiếu hiệp bang phái yến hội ném xúc xắc được hạng %d", nDiceTopShowNum) 
	for i=1,nDiceTopShowNum do
		local dwRoleId, nScore = unpack(tbSortData[i]);
		local tbRole = KPlayer.GetRoleStayInfo(dwRoleId)
		szPriceMsg = string.format("%s\n「%s」\t Xúc xắc %d điểm", szPriceMsg, tbRole.szName, nScore);
		tbDicePriceMail.To = dwRoleId
		tbDicePriceMail.tbAttach = tbRentDef.DicePriceMailtbAttach[i]
		Mail:SendSystemMail(tbDicePriceMail);
	end
	ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szPriceMsg, self.dwKinId );

	local nDiceBottomShowNum = math.min(tbRentDef.nDiceBottomShowNum, nToTalNum - nDiceTopShowNum) 
	if nDiceBottomShowNum > 0 then
		if self.nServerFoodCount == 1 then --选出一名潜规则玩家
			local nRandCount = MathRandom(1, nDiceBottomShowNum)
			local nPos = nToTalNum - nRandCount + 1;
			local dwRoleId, nScore = unpack(tbSortData[nPos]);
			self.tbPlayerInfos[dwRoleId].bPoolGuy = true;
		end
		local szPriceMsg = string.format("Tổng quản Bang: Thiếu hiệp tại ném xúc xắc thu được cuối cùng hạng %d phạt một chén rượu!", nDiceBottomShowNum) 
		local tbDrinkMsg = tbRentDef.tbDrinkMsg
		local tbSendDrinkMsgs = {};
		for i=nDiceBottomShowNum, 1, -1 do
			local nPos = nToTalNum - i + 1;
			local dwRoleId, nScore = unpack(tbSortData[nPos]);
			local tbRole = KPlayer.GetRoleStayInfo(dwRoleId)
			local tbInfo = self.tbPlayerInfos[dwRoleId]
			tbInfo.nDrinkCount = (tbInfo.nDrinkCount or 0) + 1;
			local szDrinkMsg = string.format(tbDrinkMsg[tbInfo.nDrinkCount], tbRole.szName)
			table.insert(tbSendDrinkMsgs, szDrinkMsg)
			szPriceMsg = string.format("%s\n「%s」\t Xúc xắc %d điểm", szPriceMsg, tbRole.szName, nScore);
		end
		ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szPriceMsg, self.dwKinId);
		for i,v in ipairs(tbSendDrinkMsgs) do
			ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, v, self.dwKinId);
		end
	end

	local nMaxFoodCount = #tbRentDef.FOOD_NAME
	if self.nServerFoodCount == nMaxFoodCount then
		local tbPunishRoleIds = {};
		for dwRoleId,tbInfo in pairs(self.tbPlayerInfos) do
			if tbInfo.nDrinkCount == nMaxFoodCount then
				table.insert(tbPunishRoleIds, dwRoleId)
			end
		end
		self:PunishPlayer(tbPunishRoleIds)
	end
end

function tbFuben:PunishPlayer(tbPunishRoleIds)
	if not next(tbPunishRoleIds) then
		return
	end
	local tbPunishPlayers = {}
	local tbPunishRoleIdKey = {};
	for i,dwRoleId in ipairs(tbPunishRoleIds) do
		local pPlayer = KPlayer.GetPlayerObjById(dwRoleId)
		if pPlayer then
			table.insert(tbPunishPlayers, pPlayer)
			tbPunishRoleIdKey[dwRoleId] = 1;
		end
	end
	if not next(tbPunishPlayers) then
		return
	end
	--开启动态障碍
	local nUsedPunishIndex = 0;
	local tbPlayers = KPlayer.GetMapPlayer(self.nMapId)
	local nPunishDanceRadius2 = tbRentDef.nPunishDanceRadius * tbRentDef.nPunishDanceRadius
	for i,pPlayer in ipairs(tbPlayers) do
		if tbPunishRoleIdKey[pPlayer.dwID] then
			nUsedPunishIndex = nUsedPunishIndex + 1;
			CloseDynamicObstacle(self.nMapId, tbRentDef.PunishDancePosObstacle[nUsedPunishIndex])
			local tbPunishPos = tbRentDef.PunishDancePos[nUsedPunishIndex]
			pPlayer.SetPosition(unpack(tbPunishPos))
			--换外装，
			local pPlayerNpc = pPlayer.GetNpc()
			local nNpcResID, tbCurFeature = pPlayerNpc.GetFeature()
			local nResId = Item.tbChangeColor:GetWaiZhuanRes(tbRentDef.tbPunishWaiYiItemId_Body, pPlayer.nFaction, pPlayer.nSex)
		    if nResId ~= 0 then
		        pPlayerNpc.ChangeFeature(nNpcResID,Npc.NpcResPartsDef.npc_part_body, nResId) -- 换门派装
		    end
			local nResId = Item.tbChangeColor:GetWaiZhuanRes(tbRentDef.tbPunishWaiYiItemId_Body, pPlayer.nFaction, pPlayer.nSex)
		    if nResId ~= 0 then
		        pPlayerNpc.ChangeFeature(nNpcResID,Npc.NpcResPartsDef.npc_part_head, nResId) -- 换门派装
		    end
		    pPlayerNpc.DoCommonAct(tbRentDef.nPunishDanceActionID, tbRentDef.nPunishDanceActionEventID, 1, 0, 1);
		    pPlayer.CallClientScript("Ui:SetForbiddenOperation", true, true);
		    ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, string.format(tbRentDef.szPunishDanceMsg, pPlayer.szName), self.dwKinId);
		else
			local _,x,y = pPlayer.GetWorldPos()
			for _,tbPos in ipairs(tbRentDef.PunishDancePos) do
				if Lib:GetDistsSquare(x, y, tbPos[1], tbPos[2])	<= nPunishDanceRadius2 then
					pPlayer.SetPosition(unpack(tbRentDef.tbPunishDanceSafePos))
					 break;
				end
			end
			
		end
	end

	Timer:Register(Env.GAME_FPS * tbRentDef.nPunishDanceTime, self.EndDancePunish, self, tbPunishRoleIds)
end

function tbFuben:EndDancePunish( tbPunishRoleIds )
	if not self.nMapId then
		return
	end
	OpenAllDynamicObstacle(self.nMapId)
	for i,dwRoleId in ipairs(tbPunishRoleIds) do
		local pPlayer = KPlayer.GetPlayerObjById(dwRoleId)
		if pPlayer and pPlayer.nMapId == self.nMapId then
			pPlayer.CallClientScript("Ui:SetForbiddenOperation", false, false)
			pPlayer.GetNpc().RestoreAction()
			pPlayer.GetNpc().RestoreFeature()
		end
	end
end

function tbFuben:OnUpdateScoreTimerInfo( szLine1, nLockId )
	local nEndTime = 0;
	if self.tbLock[nLockId] then
		nEndTime = GetTime() + math.floor(Timer:GetRestTime(self.tbLock[nLockId].nTimerId) / Env.GAME_FPS);
	end
	self.tbCacheScoreTimerInfo = {szLine1, nEndTime}
	KPlayer.MapBoardcastScript(self.nMapId, "Map:DoCmdWhenMapLoadFinish", self.nMapId, "Fuben:SetScoreTimerInfo", szLine1, nEndTime);
end