local tbValidRequests = {
	Guess = true,
	CommitGather = true,
	CommitItem = true,
	AskHelp = true,
	DoHelp = true,
	GiveUpTask = true,
}

function KinDinnerParty:OnRequest(szFunc, ...)
	if self.bForceClose then
		me.CenterMsg("Bang phái liên hoan lâm thời quan bế")
		return
	end

	if not tbValidRequests[szFunc] then
		Log("[x] KinDinnerParty:OnRequest, invalid req", szFunc, ...)
		return
	end

	local func = self[szFunc]
	if not func then
		Log("[x] KinDinnerParty:OnRequest, unknown req", szFunc, ...)
		return
	end

	local bSuccess, szErr = func(self, me, ...)
	if not bSuccess then
		if szErr and szErr ~= "" then
			me.CenterMsg(szErr)
		end
		return
	end
end

function KinDinnerParty:OnCostGoldHelpCallback(nPlayerId, bSuccess, nTarPlayerId, nTaskId)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId);
	if not pPlayer then
		return false, "Hiệp trợ trong lúc đó offline, mời thử lại"
	end

	if not bSuccess then
		return false, "Thanh toán thất bại"
	end

	local bRet, szMsg = self:CheckHelpEnable(pPlayer, nTarPlayerId, nTaskId, true)
	if not bRet then
		if szMsg then
			pPlayer.CenterMsg(szMsg)
		end
		return false, szMsg
	end

	self:OnHelpSuccess(pPlayer, nTarPlayerId, nTaskId)
	Log("KinDinnerParty OnCostGoldHelpCallback", nPlayerId, nTarPlayerId, nTaskId)
	return true
end

function KinDinnerParty:CheckHelpEnable(pPlayer, nTarPlayerId, nTaskId, bCoin)
	if pPlayer.dwID == nTarPlayerId then
		return false, "Không cách nào trợ giúp tự mình hoàn thành nhiệm vụ"
	end

	if not Kin:PlayerAtSameKin(pPlayer.dwID, nTarPlayerId) then
		return false, "Không tại cùng một cái bang phái, không cách nào hiệp trợ";
	end

	local tbHelp = self:GetHelpData(nTarPlayerId)
	if tbHelp[nTaskId] == nil then
		return false, "Không có này hạng hiệp trợ"
	end

	if tbHelp[nTaskId] then
		return false, "Đã có người giúp hắn hoàn thành";
	end

	local tbTaskSetting = self:GetTaskSetting(nTaskId);
	local tbBaseInfo    = KItem.GetItemBaseProp(tbTaskSetting.nTemplateId);

	if tbTaskSetting.szType == "Item" then
		if not bCoin then
			local nHas = pPlayer.GetItemCountInAllPos(tbTaskSetting.nTemplateId);
			if nHas < tbTaskSetting.nCount then
				return false, string.format("Ngươi cũng không đủ %s", tbBaseInfo.szName or "")
			end
		end
	else
		return false, "Nhiệm vụ này vụ không cách nào hiệp trợ hoàn thành"
	end

	return true, nil, tbTaskSetting.nTemplateId, tbTaskSetting.nCount
end

function KinDinnerParty:SetHelped(nPlayerId, nTaskId)
	local tbKinData = Kin:GetKinByMemberId(nPlayerId)
	if not tbKinData then
		return
	end

	local tbDinnerParty = tbKinData:GetDinnerPartyData()
	if (tbDinnerParty.tbHelps[nPlayerId] or {})[nTaskId] == nil then
		return
	end

	tbDinnerParty.tbHelps[nPlayerId][nTaskId] = true
	tbKinData:Save()
	Log("KinDinnerParty:SetHelped", nPlayerId, nTaskId)
end

function KinDinnerParty:NotifyTargetPlayer(nTargetPlayerId)
	local pPlayer = KPlayer.GetPlayerObjById(nTargetPlayerId);
	if pPlayer then
		self:SyncTask(pPlayer);
	end
end

function KinDinnerParty:OnHelpSuccess(pPlayer, nTarPlayerId, nTaskId)
	self:SetHelped(nTarPlayerId, nTaskId)

	local kinData = Kin:GetKinById(pPlayer.dwKinId);
	kinData:SetCacheFlag("UpdateMemberInfoList", true);

	local pRoleStayInfo = KPlayer.GetRoleStayInfo(nTarPlayerId);
	local tbTaskSetting = self:GetTaskSetting(nTaskId);
	local tbBaseInfo = KItem.GetItemBaseProp(tbTaskSetting.nTemplateId);
	local szItemName = tbBaseInfo.szName;
	local szKinMsg = string.format("「%s」 Hiệp trợ 「%s」 Hoàn thành bang phái liên hoan nhiệm vụ nhu cầu: 【%s】", pPlayer.szName, pRoleStayInfo.szName, szItemName)
	self:NotifyTargetPlayer(nTarPlayerId);
	ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szKinMsg, pPlayer.dwKinId);

	if pPlayer.dwKinId ~= 0 then
		local nAddCount = self:GetAddContributionCount(tbTaskSetting.nTemplateId)
		pPlayer.AddMoney("Contrib", nAddCount, Env.LogWay_KinDinnerPartyHelp)
		pPlayer.CallClientScript("KinDinnerParty:OnRespondHelp", string.format("Thu hoạch được %d Cống hiến", nAddCount))
	end

	self:SyncTask(pPlayer)
	FriendShip:AddImitity(pPlayer.dwID, nTarPlayerId, self.Def.HELP_IMITITY, Env.LogWay_KinDinnerPartyHelp);
	Log("KinDinnerParty OnHelpSuccess", pPlayer.dwID, nTarPlayerId, nTaskId)
end

function KinDinnerParty:GiveUpTask(pPlayer)
	if not self:IsDoingTask(pPlayer) then
		return false
	end

	local tbTask = self:GetTaskInfo(pPlayer)
	tbTask.bGiveUp = true
	self:SyncTask(pPlayer)

	local tbKinData = Kin:GetKinById(pPlayer.dwKinId)
	if tbKinData then
		local tbDinnerParty = tbKinData:GetDinnerPartyData()
		tbDinnerParty.tbHelps[pPlayer.dwID] = nil
		tbKinData:Save()
		tbKinData:SetCacheFlag("UpdateMemberInfoList", true)
	end

	Log("KinDinnerParty:GiveUpTask", tostring(pPlayer.dwKinId), pPlayer.dwID)
	return true
end

function KinDinnerParty:DoHelp(pPlayer, nTarPlayerId, nTaskId, bCoin)
	local bRet, szMsg, nItemTemplateId, nCount = self:CheckHelpEnable(pPlayer, nTarPlayerId, nTaskId, bCoin)
	if not bRet then
		return false, szMsg
	end

	if not bCoin then
		local nConsumeCount = pPlayer.ConsumeItemInAllPos(nItemTemplateId, nCount, Env.LogWay_KinDinnerPartyHelp)
		if nConsumeCount < nCount then
			Log("KinDinnerParty:DoHelp Error", pPlayer.dwID, pPlayer.szName, nTaskId)
			return false, "Ngài cũng không đủ hiệp trợ vật phẩm"
		end

		self:OnHelpSuccess(pPlayer, nTarPlayerId, nTaskId)
	else
		local nConsume = self:GetHelpNeedCoin(nItemTemplateId)
		if not nConsume then
			return false, "Hiệp trợ thất bại, mời thử lại"
		end
		pPlayer.CostGold(nConsume, Env.LogWay_KinDinnerPartyHelp, nil,
			function (nPlayerId, bSuccess)
				local bRet, szMsg = self:OnCostGoldHelpCallback(nPlayerId, bSuccess, nTarPlayerId, nTaskId)
				return bRet, szMsg
			end)
	end
	return true
end

function KinDinnerParty:GetHelpData(nPlayerId)
	local tbKinData = Kin:GetKinByMemberId(nPlayerId)
	if not tbKinData then
		return
	end

	local tbDinnerParty = tbKinData:GetDinnerPartyData()
	return tbDinnerParty.tbHelps[nPlayerId] or {}
end

function KinDinnerParty:AskHelp(pPlayer, nRequestTaskId)
	local tbKinData = Kin:GetKinById(pPlayer.dwKinId)
	if not tbKinData then
		return false, "Không có bang phái"
	end

	local tbDinnerParty = tbKinData:GetDinnerPartyData()
	local tbHelps = tbDinnerParty.tbHelps[pPlayer.dwID] or {}

	local tbTaskData = self:GetTaskInfo(pPlayer)
	local bPass, szErr = self:CanAskHelp(tbHelps, tbTaskData.tbTask, nRequestTaskId)
	if not bPass then
		return false, szErr
	end

	tbKinData:SetCacheFlag("UpdateMemberInfoList", true)

	tbHelps[nRequestTaskId] = false
	tbDinnerParty.tbHelps[pPlayer.dwID] = tbHelps
	tbKinData:Save()

	pPlayer.CenterMsg("Thành công khởi xướng bang phái xin giúp đỡ");
	self:SyncTask(pPlayer);

	local tbTaskSetting = self:GetTaskSetting(nRequestTaskId);
	local tbBaseInfo = KItem.GetItemBaseProp(tbTaskSetting.nTemplateId);
	local szKinMsg = string.format("< Hiệp trợ hoàn thành >【%s】 Phát khởi [FFFE0D] Bang phái liên hoan [-] Nhiệm vụ hiệp trợ, đang tìm 【%s】×%d", pPlayer.szName, tbBaseInfo.szName, tbTaskSetting.nCount);
	ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szKinMsg, pPlayer.dwKinId, { nLinkType = ChatMgr.LinkType.KinDPTaskHelp, dwPlayerID = pPlayer.dwID });

	Log("KinDinnerParty:AskHelp", pPlayer.dwID, nRequestTaskId)
	return true
end

function KinDinnerParty:CommitGather(pPlayer, nIndex)
	if not self:IsDoingTask(pPlayer) then
		return false
	end
	local tbTaskData = self:GetTaskInfo(pPlayer);
	local tbAllTask = tbTaskData.tbTask;
	local tbTask = tbAllTask[nIndex];

	if not tbTask then
		return false
	end

	if tbTask.bFinish then
		return false
	end

	local tbSetting = self:GetTaskSetting(tbTask.nTaskId);
	if tbTask.nGain >= tbSetting.nCount then
		tbTask.bFinish = true;
	end

	self:SyncTask(pPlayer);
	pPlayer.CenterMsg("Thùng đựng hàng thành công");
	Log("KinDinnerParty:CommitGather", pPlayer.dwID, nIndex)
	return true
end

function KinDinnerParty:ConsumeBoxNeedItem(pPlayer, nTaskId)
	local tbTaskSetting = self:GetTaskSetting(nTaskId);
	if tbTaskSetting.szType == "Item" then
		local nHas = pPlayer.GetItemCountInAllPos(tbTaskSetting.nTemplateId);
		if nHas >= tbTaskSetting.nCount then
			pPlayer.ConsumeItemInAllPos(tbTaskSetting.nTemplateId, tbTaskSetting.nCount, Env.LogWay_KinDinnerParty);
			return true;
		end
	end
	return false;
end

function KinDinnerParty:GetBoxReward(nTaskId)
	local tbTaskSetting = self:GetTaskSetting(nTaskId);
	local tbGainReward = {};
	local szInfo = "";
	for i = 1, 2 do
		local szType = tbTaskSetting["szRewardType"..i];
		local nTemplateId = tbTaskSetting["nRewardId"..i];
		local nCount = tbTaskSetting["nRewardCount"..i];
		if szType and szType ~= "" then
			local tbReward = self:FormatReward(szType, nTemplateId, nCount);
			szInfo = szInfo .. " " .. self:FormatItem(szType, nTemplateId, nCount);
			table.insert(tbGainReward, tbReward);
		end
	end
	return tbGainReward, szInfo;
end

function KinDinnerParty:CommitItem(pPlayer, nIndex)
	if not self:IsDoingTask(pPlayer) then
		return false
	end
	local tbTaskData = self:GetTaskInfo(pPlayer);
	local tbAllTask = tbTaskData.tbTask;
	local tbTask = tbAllTask[nIndex];

	if not tbTask then
		Log("[x] KinDinnerParty:CommitItem Error, Task Is Nil", pPlayer.dwID, nIndex)
		return false
	end

	if tbTask.bFinish then
		return false
	end

	if not self:ConsumeBoxNeedItem(pPlayer, tbTask.nTaskId) then
		return false, "Đưa ra thất bại, đạo cụ không đủ"
	end

	self:SetHelped(pPlayer.dwID, tbTask.nTaskId)
	tbTask.bFinish = true;
	local tbGainReward, szInfo = self:GetBoxReward(tbTask.nTaskId);
	pPlayer.SendAward(tbGainReward, nil, nil, Env.LogWay_KinDinnerParty);

	self:SyncTask(pPlayer);

	pPlayer.CenterMsg(szInfo ~= "" and string.format("Thùng đựng hàng thành công, thu hoạch được ban thưởng %s", szInfo) or string.format("Thùng đựng hàng thành công"));
	Log("KinDinnerParty:CommitItem", pPlayer.dwID, nIndex)
	return true
end

function KinDinnerParty:Guess(pPlayer, nNpcId, szGuess)
	if not self.tbActivities or not self.tbActivities[nNpcId] then
		return false, "Liên hoan đã kết thúc"
	end

	local tbActivity = self.tbActivities[nNpcId]
	if tbActivity.nOwner ~= pPlayer.dwID then
		return false, "Ngươi không phải liên hoan người đề xuất"
	end

	if not tbActivity.bStarted then
		return false, "Liên hoan chưa chính thức bắt đầu"
	end

	if tbActivity.bGuessed then
		return false, "Này vòng đã đoán qua"
	end

	if szGuess == self.Def.tbIdioms[tbActivity.nIdiomIdx] then
		tbActivity.nGuessRight = (tbActivity.nGuessRight or 0) + 1
		tbActivity.bGuessed = true
		ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, 
			string.format("「%s」Thâu nhập chính xác thành ngữ, mọi người thu hoạch kinh nghiệm tăng lên 1 Lần!", pPlayer.szName), 
			tbActivity.nKinId)
		Log("KinDinnerParty:Guess, right", pPlayer.dwID, nNpcId, szGuess, tbActivity.nGuessRight)
	else
		pPlayer.CenterMsg("Lượt này không phải cái này thành ngữ, lại đi hỏi một chút bang phái thành viên đi", true)
	end
	return true
end

function KinDinnerParty:AssignTask()
	if self.bForceClose then
		return
	end
	
	local nWeekDay = Lib:GetLocalWeekDay(GetTime())
	if nWeekDay ~= 1 then
		return
	end

	local nNow = GetTime()
	Kin:TraverseKin(function(tbKinData)
		local tbPlayerIds = tbKinData:GetCareerMemberIds(Kin.Def.Career_Mascot)
		local tbPlayerIdMap = {}
		for _, nPlayerId in ipairs(tbPlayerIds) do
			local pPlayerStay = KPlayer.GetRoleStayInfo(nPlayerId)
			if pPlayerStay and pPlayerStay.nLevel >= self.Def.nMinTaskLevel then
				tbPlayerIdMap[nPlayerId] = false
				Mail:SendSystemMail({
			        To = nPlayerId,
			        Title = "Liên hoan nhiệm vụ",
			        Text = "Chúc mừng ngài thu được tuần này linh vật chức vị, làm linh vật, được hưởng mở ra liên hoan đặc quyền a, đến lão hủ nơi này[FFFE0D][url=npc:Bang phái tổng quản, 266,1004][-]Xác nhận liên hoan nhiệm vụ, hoàn thành nhiệm vụ liền có thể thu hoạch quyền trượng triệu hoán bàn ăn a!",
			        From = "Bang phái tổng quản",
			        tbAttach = self.Def.tbTaskMailAttaches,
			        nLogReazon = Env.LogWay_KinDinnerParty,
			    })
			    Log("KinDinnerParty:AssignTask", tbKinData.nKinId, nPlayerId)
			else
				Log("KinDinnerParty:AssignTask, cant assign", tbKinData.nKinId, nPlayerId, pPlayerStay and pPlayerStay.nLevel or -1)
			end
		end

		local tbDinnerParty = tbKinData:GetDinnerPartyData()
		tbDinnerParty.nResetTime = nNow
		tbDinnerParty.nCount = 0
		tbDinnerParty.tbTaskPlayers = tbPlayerIdMap
		Log("KinDinnerParty:AssignTask, end", tbKinData.nKinId, #tbPlayerIds)
	end)
end

function KinDinnerParty:OnPlayerLogin(pPlayer)
	self:SyncTask(pPlayer)
end

function KinDinnerParty:CanAcceptTask(pPlayer)
	if self.bForceClose then
		return false, "Bang phái liên hoan lâm thời quan bế"
	end

	local tbKinData = Kin:GetKinById(pPlayer.dwKinId)
	if not tbKinData then
		return false, "Không có bang phái"
	end

	local tbDinnerParty = tbKinData:GetDinnerPartyData()
	if tbDinnerParty.tbTaskPlayers[pPlayer.dwID] == nil then
		return false, "Không có thu hoạch được tiếp nhận nhiệm vụ này vụ tư cách"
	end
	if tbDinnerParty.tbTaskPlayers[pPlayer.dwID] then
		return false, "Ngươi đã lĩnh qua nhiệm vụ này vụ"
	end
	return true
end

function KinDinnerParty:AcceptTask(nPlayerId)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
	if not pPlayer then
		return
	end
	local tbKinData = Kin:GetKinById(pPlayer.dwKinId)
	if not tbKinData then
		pPlayer.CenterMsg("Không có bang phái")
		return
	end

	local tbDinnerParty = tbKinData:GetDinnerPartyData()
	if tbDinnerParty.tbTaskPlayers[pPlayer.dwID] == nil then
		pPlayer.CenterMsg("Không có thu hoạch được tiếp nhận nhiệm vụ này vụ tư cách")
		return
	end
	if tbDinnerParty.tbTaskPlayers[pPlayer.dwID] then
		pPlayer.CenterMsg("Ngươi đã lĩnh qua nhiệm vụ này")
		return
	end
	if self:IsDoingTask(pPlayer) then
		pPlayer.CenterMsg("Mời trước hoàn thành đang tiến hành nhiệm vụ")
		return
	end

	tbKinData:SetCacheFlag("UpdateMemberInfoList", true)

	tbDinnerParty.tbTaskPlayers[pPlayer.dwID] = true
	tbDinnerParty.tbHelps[pPlayer.dwID] = {}
	tbKinData:Save()

	local tbTask = pPlayer.GetScriptTable("KinDPTask")
	tbTask.tbTask = self:GetRandomTasks(pPlayer.nLevel)
	tbTask.bFinished = false
	tbTask.bGiveUp = false
	tbTask.nTime = GetTime()

	self:SyncTask(pPlayer)
	pPlayer.CenterMsg("Nhận lấy liên hoan nhiệm vụ thành công", true)
	Log("KinDinnerParty:AcceptTask", pPlayer.dwKinId, pPlayer.dwID)
end

function KinDinnerParty:CanUsePartyToken(pPlayer)
	if self.bForceClose then
		return false, "Bang phái liên hoan lâm thời quan bế"
	end

	local nPlayerId = pPlayer.dwID
	local tbKin = Kin:GetKinByMemberId(nPlayerId)
	if not tbKin then
		return false, "Chỉ có gia nhập bang phái mới có thể quyền sử dụng trượng"
	end

	local tbHouse = House:GetHouse(nPlayerId)
	if not tbHouse then
		return false, "Ngài không có gia viên, mời trước thu hoạch gia viên"
	end

	local tbPartyData = tbKin:GetDinnerPartyData()
	if tbPartyData.nCount >= self.Def.nMaxWeeklyCount and not Lib:IsDiffWeek(GetTime(), tbPartyData.nResetTime, 0) then
		return false, string.format("Ngài bang phái tuần này liên hoan số lần vượt qua[FFFE0D]%d[-]Lần, không cách nào sử dụng", self.Def.nMaxWeeklyCount)
	end

	return true
end

function KinDinnerParty:TryCallTable(pPlayer, pItem)
	if not pItem then
		Log("[x] KinDinnerParty:TryCallTable, pItem nil", pPlayer.dwID, tostring(pItem))
		return false, "Vật phẩm không tồn tại"
	end

	local nMapId, nX, nY = pPlayer.GetWorldPos()
	local nDir = pPlayer.GetNpc().GetDir()
	nX = nX + math.floor(g_DirCos(nDir) / 1024 * 200)
    nY = nY + math.floor(g_DirSin(nDir) / 1024 * 200)

	local bCanUse = CheckBarrier(nMapId, nX, nY)
	local bCanPut = Decoration:CheckCanUseDecoration(nMapId, nX, nY, nil, self.Def.nNpcFurnitureId)
	if not bCanUse or not bCanPut then
		return false, "Nơi này quá chật, đổi chỗ thử một chút đi"
	end

	if pPlayer.ConsumeItem(pItem, 1, Env.LogWay_KinDinnerParty) ~= 1 then
        return false, "Tiêu hao đạo cụ thất bại"
    end

	local pNpc = KNpc.Add(self.Def.nTableNpcId, 1, -1, nMapId, nX, nY, 0, 0)
    if not pNpc then
        return false, "Cất đặt thất bại"
    end

    self:CreateActivity(pPlayer, pNpc)

    return true
end

function KinDinnerParty:SetObstacle(pNpc, bRemove)
	local nMapId, nX, nY = pNpc.GetWorldPos()
	Decoration:SetObstacle(nMapId, nX, nY, 0, self.Def.nNpcFurnitureId, not not bRemove, true)
	KPlayer.MapBoardcastScriptByFuncName(nMapId, "Decoration:SetObstacle", nMapId, nX, nY,
		0, self.Def.nNpcFurnitureId, not not bRemove)
end

function KinDinnerParty:CreateActivity(pPlayer, pNpc)
	local tbKinData = Kin:GetKinByMemberId(pPlayer.dwID)
	if not tbKinData then
		Log("[x] KinDinnerParty:CreateActivity, no kin", pPlayer.dwID)
		return
	end

	self:SetObstacle(pNpc, false)

	tbKinData.tbDinnerParty = tbKinData.tbDinnerParty or {}
	local nNow = GetTime()
	tbKinData.tbDinnerParty.nResetTime = tbKinData.tbDinnerParty.nResetTime or nNow
	tbKinData.tbDinnerParty.nCount = (tbKinData.tbDinnerParty.nCount or 0) + 1
	if Lib:IsDiffWeek(nNow, tbKinData.tbDinnerParty.nResetTime, 0) then
		tbKinData.tbDinnerParty.nResetTime = nNow
		tbKinData.tbDinnerParty.nCount = 1
	end
	tbKinData:Save()

	local nMapId, nX, nY = pPlayer.GetWorldPos()
	self.tbActivities = self.tbActivities or {}
	self.tbActivities[pNpc.nId] = {
		fnRandom = Lib:GetRandomSelect(#self.Def.tbIdioms),
		nOwner = pPlayer.dwID,
		nMapId = nMapId,
		nKinId = pPlayer.dwKinId,
		nGuessRight = 0,	--猜对的次数
		bStarted = false,
		bGuessed = false,
		tbJoinPlayers = {},
		tbEatPlayers = {},
		tbGuessPlayers = {},	--随机选中玩家发送谜题邮件
		nIdiomIdx = 0,	--本轮成语idx
		nGuessRound = 0,	--第几轮猜成语
	}

	self.tbMap2NpcId = self.tbMap2NpcId or {}
	self.tbMap2NpcId[nMapId] = pNpc.nId

	local szMsg = string.format("「%s」 Tại gia viên bên trong phát khởi liên hoan, đem với [FFFE0D]%s[-] Phút sau chính thức bắt đầu, nhanh đi hưởng dụng mỹ thực đi <%s Quê hương >", pPlayer.szName, 
    	math.floor(self.Def.tbTimers[1][1] / 60), pPlayer.szName)
	ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szMsg, pPlayer.dwKinId, {
		nLinkType = ChatMgr.LinkType.Position, 
		linkParam = {nMapId, nX, nY, pPlayer.nMapTemplateId},
	})

	for _, tb in ipairs(self.Def.tbTimers) do
		local nSec, tbActions = unpack(tb)
		Timer:Register(Env.GAME_FPS * nSec, self.DoActions, self, pNpc.nId, tbActions)
	end
	Log("KinDinnerParty:CreateActivity", pPlayer.dwKinId, pPlayer.dwID)
end

function KinDinnerParty:IsRunning(nOwner)
	local nMapId = House:GetHouseMap(nOwner)
	if not nMapId then
		return false
	end
	return not not (self.tbMap2NpcId or {})[nMapId]
end

function KinDinnerParty:Sync(pPlayer)
	local nNpcId = (self.tbMap2NpcId or {})[pPlayer.nMapId]
	if not nNpcId then
		return
	end

	local pNpc = KNpc.GetById(nNpcId)
	if not pNpc then
		return
	end

	local nMapId, nX, nY = pNpc.GetWorldPos()
	pPlayer.CallClientScript("Decoration:SetObstacle", nMapId, nX, nY, 0, self.Def.nNpcFurnitureId, false)
end

function KinDinnerParty:DoActions(nNpcId, tbActions)
	local tbActivity = self.tbActivities[nNpcId]
	if not tbActivity then
		Log("[x] KinDinnerParty:DoActions, no activity", nNpcId)
		return
	end

	for _, szAction in ipairs(tbActions) do
		Log("KinDinnerParty:DoActions", tbActivity.nKinId, tbActivity.nOwner, szAction)
		if szAction == "start" then
			if tbActivity.bStarted then
				return
			end
			tbActivity.bStarted = true
			local tbNpc = Npc:GetClass("KinDinnerPartyTable")
			tbNpc:StartAddExpTimer(nNpcId)

			ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, "Bang phái liên hoan chính thức bắt đầu, bắt đầu dọn thức ăn lên![FFFE0D] Liên hoan đem tiếp tục 8 Phút[-]", tbActivity.nKinId)
		
		elseif szAction == "food" then
			tbActivity.tbEatPlayers = {}
			local pOwner = KPlayer.GetRoleStayInfo(tbActivity.nOwner or 0)
			local szName = pOwner and pOwner.szName or "Liên hoan người đề xuất"
			ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, 
				string.format("Mới lên một món ăn, xin mọi người nhấm nháp. Nếu như ăn vào thành ngữ bên trong chữ, nhớ kỹ nói cho mọi người.[FFFE0D]%s[-] Có thể điểm kích bàn ăn đưa vào thành ngữ, đối, kinh nghiệm ban thưởng đem gấp bội a!", szName),
					tbActivity.nKinId)
			self:CenterMsg(nNpcId, "Mới lên một món ăn, xin mọi người nhấm nháp")
		
		elseif szAction == "guess" then
			tbActivity.bGuessed = false
			tbActivity.nGuessRound = (tbActivity.nGuessRound or 0) + 1
			tbActivity.nIdiomIdx = tbActivity.fnRandom()
			tbActivity.tbGuessPlayers = {}
			if next(tbActivity.tbJoinPlayers) then
				local tbPlayers = {}
				for nPlayerId in pairs(tbActivity.tbJoinPlayers) do
					local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
					if pPlayer and self:CanPlayerJoin(pPlayer, nNpcId) then
						table.insert(tbPlayers, nPlayerId)
					end
				end
				local fnRandom = Lib:GetRandomSelect(#tbPlayers)
				local tbChars = Lib:GetUft8Chars(self.Def.tbIdioms[tbActivity.nIdiomIdx])
				for i=1, 4 do
					local nIdx = fnRandom()
					local nPlayerId = tbPlayers[nIdx]
					tbActivity.tbGuessPlayers[nPlayerId] = tbChars[i]
				end
			end
		
		elseif szAction == "stopwarning" then
			self:CenterMsg(nNpcId, "Còn có 2 Phút liên hoan kết thúc")

		elseif szAction == "stop" then
			tbActivity.bStarted = false
			local tbNpc = Npc:GetClass("KinDinnerPartyTable")
			tbNpc:StopAddExpTimer(nNpcId)

			local pOwner = KPlayer.GetRoleStayInfo(tbActivity.nOwner)
			local szName = pOwner and pOwner.szName or ""
			ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, string.format("「%s」 Bang phái liên hoan kết thúc!", szName), tbActivity.nKinId)

			local pNpc = KNpc.GetById(nNpcId)
			if pNpc then
				self:SetObstacle(pNpc, true)
				pNpc.Delete()
			end
			self.tbMap2NpcId[tbActivity.nMapId] = nil
			self.tbActivities[nNpcId] = nil

		else
			Log("[x] KinDinnerParty:DoActions, unknown", szAction)
		end
	end
end

function KinDinnerParty:CenterMsg(nNpcId, szMsg)
	local tbActivity = self.tbActivities[nNpcId]
	if not tbActivity then
		Log("[x] KinDinnerParty:CenterMsg, no activity", nNpcId, szMsg)
		return
	end

	for nPlayerId in pairs(tbActivity.tbJoinPlayers) do
		local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
		if pPlayer and self:CanPlayerJoin(pPlayer, nNpcId) then
			pPlayer.CenterMsg(szMsg)
		end
	end
end

function KinDinnerParty:IsPlayerJoinCountValid(pPlayer)
	local nLastJoinTime = pPlayer.GetUserValue(self.Def.nSaveGroup, self.Def.nKeyWeekJoinTime)
	local nJoinCount = pPlayer.GetUserValue(self.Def.nSaveGroup, self.Def.nKeyJoinCount)
	return Lib:IsDiffWeek(GetTime(), nLastJoinTime, 0) or nJoinCount < self.Def.nMaxPlayerJoinCount
end

function KinDinnerParty:CanPlayerJoin(pPlayer, nNpcId)
	if self.bForceClose then
		return false, false, "Bang phái liên hoan lâm thời quan bế"
	end
	
	local tbActivity = KinDinnerParty.tbActivities[nNpcId]
	if not tbActivity then
		return false
	end

	if not (pPlayer.dwKinId == tbActivity.nKinId and House:IsIndoor(pPlayer)) then
		return false, false, "Ngươi không tại cái này bang phái"
	end

	if not tbActivity.tbJoinPlayers[pPlayer.dwID] then
		if not self:IsPlayerJoinCountValid(pPlayer) then
			return false, true
		end
	end

	return true
end

function KinDinnerParty:OnPlayerJoin(nNpcId, pPlayer)
	local tbActivity = self.tbActivities[nNpcId]
	if not tbActivity then
		Log("[x] KinDinnerParty:OnPlayerJoin", nNpcId, pPlayer.dwID)
		return
	end

	if tbActivity.tbJoinPlayers[pPlayer.dwID] then
		return
	end
	tbActivity.tbJoinPlayers[pPlayer.dwID] = true

	local nLastJoinTime = pPlayer.GetUserValue(self.Def.nSaveGroup, self.Def.nKeyWeekJoinTime)
	local nNow = GetTime()
	if Lib:IsDiffWeek(nNow, nLastJoinTime, 0) then
		pPlayer.SetUserValue(self.Def.nSaveGroup, self.Def.nKeyWeekJoinTime, nNow)
		pPlayer.SetUserValue(self.Def.nSaveGroup, self.Def.nKeyJoinCount, 1)
	else
		local nJoinCount = pPlayer.GetUserValue(self.Def.nSaveGroup, self.Def.nKeyJoinCount)
		pPlayer.SetUserValue(self.Def.nSaveGroup, self.Def.nKeyJoinCount, nJoinCount + 1)
	end
end

--
-- 任务相关
--
function KinDinnerParty:GetRandomTasks(nPlayerLevel)
	local tbRet = {}
	for nTaskId, tb in pairs(self.tbTaskSetting) do
		if tb.nMinLevel <= nPlayerLevel then
			table.insert(tbRet, {
				nTaskId = nTaskId,
				bFinish = false,
				nGain = 0,
			})
			if #tbRet >= self.Def.nTaskCount then
				break
			end
		end
	end
	return tbRet
end

function KinDinnerParty:SyncTask(pPlayer)
	local tbTaskData = self:GetTaskInfo(pPlayer)
	if not tbTaskData then
		return
	end
	local tbHelp = self:GetHelpData(pPlayer.dwID)
	pPlayer.CallClientScript("KinDinnerParty:OnSyncTask", tbTaskData, tbHelp)
end

function KinDinnerParty:GetTaskInfo(pPlayer)
	local tbTaskData = pPlayer.GetScriptTable("KinDPTask");
	local tbKinData = Kin:GetKinByMemberId(pPlayer.dwID)
	if not tbKinData then
		Log("KinDinnerParty:GetTaskInfo", pPlayer.dwKinId, pPlayer.dwID)
		return
	end

	local bChanged = false
	local tbData = tbKinData:GetDinnerPartyData()
	for nTaskId, bHelped in pairs(tbData.tbHelps[pPlayer.dwID] or {}) do
		if bHelped then
			for _, v in ipairs(tbTaskData.tbTask) do
				if v.nTaskId == nTaskId then
					v.bFinish = true
					tbData.tbHelps[pPlayer.dwID][nTaskId] = nil
					bChanged = true
					break
				end
			end
		end
	end
	if not next(tbData.tbHelps[pPlayer.dwID] or {}) then
		tbData.tbHelps[pPlayer.dwID] = nil
	end
	if bChanged then
		tbKinData:Save()
	end

	return tbTaskData
end

function KinDinnerParty:AddGatherTing(pPlayer, nTemplateId)
	local tbCommerceData = self:GetTaskInfo(pPlayer);
	if tbCommerceData.tbTask then
		for k,v in pairs(tbCommerceData.tbTask) do
			local nTaskId = v.nTaskId;
			local tbSetting = self:GetTaskSetting(nTaskId);

			if not v.bFinish and tbSetting.szType == "Gather" and
			 tbSetting.nTemplateId == nTemplateId and v.nGain < tbSetting.nCount then
				v.nGain = v.nGain + 1;
				if v.nGain == tbSetting.nCount then
					return true;
				end
				break;
			end
		end
	end
	Log("KinDinnerParty:AddGatherTing", pPlayer.dwID, nTemplateId)
end

function KinDinnerParty:FinishTask(nPlayerId)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
	if not pPlayer then
		return
	end

	if not KinDinnerParty:IsDoingTask(me) or not KinDinnerParty:IsFinishedTask(me) then
		return
	end

	local tbTask = self:GetTaskInfo(pPlayer)
	tbTask.bFinished = true
	self:SyncTask(pPlayer)
	pPlayer.CenterMsg("Chúc mừng ngài, hoàn thành nhiệm vụ")

	pPlayer.SendAward({{"item", self.Def.nPartyTokenId, 1, GetTime() + self.Def.nTokenExpireTime}}, nil, nil, Env.LogWay_KinDinnerParty);

	Log("KinDinnerParty:FinishTask", nPlayerId)
end

function KinDinnerParty:OnMemberLeave(nKinId, nPlayerId)
	local tbKinData = Kin:GetKinById(nKinId)
	if not tbKinData then
		return
	end

	local tbDinnerParty = tbKinData:GetDinnerPartyData()
	tbDinnerParty.tbHelps[nPlayerId] = nil
	tbDinnerParty.tbTaskPlayers[nPlayerId] = nil
	Log("KinDinnerParty:OnMemberLeave", nKinId, nPlayerId)
end