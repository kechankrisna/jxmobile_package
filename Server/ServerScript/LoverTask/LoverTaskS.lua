LoverTask.tbAllowClientCallFunc = 
{
	["RecommondLover"] = true;
	["GiveUpTask"] = true;
	["DoTask"] = true,
}
function LoverTask:OnClientCall(pPlayer, szFunc, ...)
	if not self.tbAllowClientCallFunc[szFunc] then
		Log("LoverTask fnOnClientCall Valid Call!!", pPlayer.dwID, pPlayer.szName, szFunc)
		return
	end
	self[szFunc](self, pPlayer, ...)
end

function LoverTask:AcceptTask(pPlayer)
	local bRet, szMsg, pMember = self:CheckAcceptTask(pPlayer)
	if not bRet then
		pPlayer.CenterMsg(szMsg, true)
		return 
	end

	bRet, szMsg = self:CheckFinishCount({pPlayer, pMember})
	if not bRet then
		pPlayer.CenterMsg(szMsg, true)
		return 
	end
	local nCancalType = LoverTask:GetCancelTaskType(pPlayer)
	local nTaskType = nCancalType or self:RandomTaskType(pPlayer)
	if not nTaskType then
		Log("[LoverTask] Random Task ERR!!!", pPlayer.dwID, pPlayer.szName, nCancalType or 0)
		return
	end
	pPlayer.SetUserValue(self.SAVE_GROUP, self.nTaskTypeIdx, nTaskType);
	pPlayer.SetUserValue(self.SAVE_GROUP, self.nTaskStepIdx, 1);
	pPlayer.SetUserValue(self.SAVE_GROUP, self.nTaskTeammateIdx, pMember.dwID);
	pPlayer.SetUserValue(self.SAVE_GROUP, self.nTaskStateIdx, LoverTask.TASK_STATE_ACCEPT);

	pMember.SetUserValue(self.SAVE_GROUP, self.nTaskTypeIdx, nTaskType);
	pMember.SetUserValue(self.SAVE_GROUP, self.nTaskStepIdx, 1);
	pMember.SetUserValue(self.SAVE_GROUP, self.nTaskTeammateIdx, pPlayer.dwID);
	pMember.SetUserValue(self.SAVE_GROUP, self.nTaskStateIdx, LoverTask.TASK_STATE_ACCEPT);
	pPlayer.CenterMsg("接取任務成功", true)
	pMember.CenterMsg("接取任務成功", true)
	pPlayer.CallClientScript("LoverTask:OnAcceptTask")
	pMember.CallClientScript("LoverTask:OnAcceptTask")
	Log("[LoverTask] fnAcceptTask ok", pPlayer.dwID, pPlayer.szName, pMember.dwID, pMember.szName, nCancalType or 0, nTaskType)
end

function LoverTask:RandomTaskType(pPlayer)
	local szMaxTimeFrame = Lib:GetMaxTimeFrame(LoverTask.tbTimeFrameRate)
	local tbRateInfo = LoverTask.tbTimeFrameRate[szMaxTimeFrame] or LoverTask.tbTimeFrameRate["OpenLevel39"]
	local tbRate = tbRateInfo.tbRate
	local nTotalRate = tbRateInfo.nTotalRate
	local nRandom = MathRandom(nTotalRate);
	for nTaskType, nRate in pairs(tbRate) do
		nRandom = nRandom - nRate
		if nRandom <= 0 then
			return nTaskType
		end
	end
end

function LoverTask:CheckFinishCount(tbPlayer)
	for _, pPlayer in pairs(tbPlayer) do
		local nFinishCount = self:GetFinishCount(pPlayer)
		 if nFinishCount >= self.MAX_FINISH_COUNT then
			return false, string.format("【%s】參加次數不足", pPlayer.szName)
		end
		local nTaskType = LoverTask:GetActiveTaskType(pPlayer)
		if nTaskType then
			return false, string.format("【%s】身上已有同類任務", pPlayer.szName)
		end
	end
	return true
end

function LoverTask:GetFinishCount(pPlayer)
	local nNowTime = GetTime()
	local nFinishTime = pPlayer.GetUserValue(self.SAVE_GROUP, self.nUpdateTimeIdx);
	if Lib:IsDiffWeek(nNowTime, nFinishTime) then
		pPlayer.SetUserValue(self.SAVE_GROUP, self.nFinishCountIdx, 0);
		pPlayer.SetUserValue(self.SAVE_GROUP, self.nUpdateTimeIdx, nNowTime);
	end
	local nFinishCount = pPlayer.GetUserValue(self.SAVE_GROUP, self.nFinishCountIdx);
	return nFinishCount
end

function LoverTask:GetFinishAward(pPlayer)
	local tbFinishAward = {}
	local tbTaskAward, tbAllExtAward = LoverTask:GetTaskAward(pPlayer)
	tbFinishAward = Lib:CopyTB(tbTaskAward or {})
	tbAllExtAward = tbAllExtAward or {}
	if next(tbAllExtAward) then
		local tbExtAward = tbAllExtAward[MathRandom(#tbAllExtAward)]
		Lib:MergeTable(tbFinishAward, tbExtAward)
	end
	
	return tbFinishAward
end

function LoverTask:DoTask(pPlayer, nFinishProcess)
	local bRet, szMsg, pMember = self:CheckDoTask(pPlayer)
	local nTaskState = pPlayer.GetUserValue(self.SAVE_GROUP, self.nTaskStateIdx);
	local nTaskType = pPlayer.GetUserValue(self.SAVE_GROUP, self.nTaskTypeIdx);
	if nTaskState == self.TASK_STATE_CAN_FINISH then
		local nPreFinishDialogId = LoverTask:GetTaskPreFinishDialog(nTaskType)
		if not nFinishProcess and nPreFinishDialogId then
			pPlayer.CallClientScript("LoverTask:ShowDialog", nPreFinishDialogId)
			return
		end
		if not nFinishProcess or nFinishProcess == LoverTask.PROCESS_SHOW_TASK_PANEL then
			pPlayer.CallClientScript("Ui:OpenWindow", "TaskFinish", LoverTask.nLoveTaskFakeId)
			return
		end
		-- 保证组队获得的是同一份奖励
		local tbFinishAward = LoverTask:GetFinishAward(pPlayer)
		self:FinishTask(pPlayer, tbFinishAward)
		if pMember then
			local nMemberTaskState = pMember.GetUserValue(self.SAVE_GROUP, self.nTaskStateIdx);
			if nMemberTaskState == self.TASK_STATE_CAN_FINISH then
				self:FinishTask(pMember, tbFinishAward)
			end
			FriendShip:AddImitity(pPlayer.dwID, pMember.dwID, LoverTask.nAddImitity, Env.LogWay_LoverTask)
		end
		Log("[LoverTask] fnFinishTask ok", pPlayer.dwID, pPlayer.szName, pMember and pMember.dwID or 0, pMember and pMember.szName or "-", nTaskType)
		return
	end
	if not bRet then
		pPlayer.CenterMsg(szMsg, true)
		return 
	end
	local tbStep = LoverTask:GetTaskStep(pPlayer) or {}
	local nTaskStep = pPlayer.GetUserValue(self.SAVE_GROUP, self.nTaskStepIdx);
	local tbStepInfo = tbStep[nTaskStep]
	if not tbStepInfo then
		pPlayer.CenterMsg("沒有可進行的任務", true)
		return 
	end
	local szStepType = tbStepInfo.szType
	local tbParam = tbStepInfo.tbParam or {}
	if szStepType == "Dialog" then
		pPlayer.CallClientScript("LoverTask:PlayTaskDialog", unpack(tbParam))
		pMember.CallClientScript("LoverTask:PlayTaskDialog", unpack(tbParam))
		LoverTask:NextTaskStep(pPlayer)
		LoverTask:NextTaskStep(pMember)
	elseif szStepType == "Fuben" then
		local nPlayerId = pPlayer.dwID
		local nMemberId = pMember.dwID
		local function fnSuccessCallback(nMapId)
			local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
			local pMember = KPlayer.GetPlayerObjById(nMemberId)
			if pPlayer and pMember then
			   pPlayer.SetEntryPoint()
			   pMember.SetEntryPoint()
               pPlayer.SwitchMap(nMapId, 0, 0);
               pMember.SwitchMap(nMapId, 0, 0);
			end
		end
		local function fnFailedCallback()
			local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
			if pPlayer then
               pPlayer.CenterMsg("進入副本失敗，請稍後再試", true)
			end
			local pMember = KPlayer.GetPlayerObjById(nMemberId)
			if pMember then
				pMember.CenterMsg("進入副本失敗，請稍後再試", true)
			end
		end
		Fuben:ApplyFuben(nPlayerId, tbParam[1], fnSuccessCallback, fnFailedCallback);
	end
end

function LoverTask:NextTaskStep(pPlayer)
	local tbStep = LoverTask:GetTaskStep(pPlayer)
	if not tbStep then
		return
	end
	local nTaskStep = pPlayer.GetUserValue(self.SAVE_GROUP, self.nTaskStepIdx);
	
	local nNextStep = nTaskStep + 1
	if tbStep[nNextStep] then
		pPlayer.SetUserValue(self.SAVE_GROUP, self.nTaskStepIdx, nNextStep);
	else
		pPlayer.SetUserValue(self.SAVE_GROUP, self.nTaskStateIdx, LoverTask.TASK_STATE_CAN_FINISH);
	end
	pPlayer.CallClientScript("LoverTask:OnNextTaskStep")
end 

function LoverTask:FinishTask(pPlayer, tbFinishAward)
	local nFinishCount = LoverTask:GetFinishCount(pPlayer)
	local bAward = next(tbFinishAward) and nFinishCount == 0
	local nTeammateId = pPlayer.GetUserValue(self.SAVE_GROUP, self.nTaskTeammateIdx)
	local nTaskType = pPlayer.GetUserValue(self.SAVE_GROUP, self.nTaskTypeIdx);
	local nTaskStep = pPlayer.GetUserValue(self.SAVE_GROUP, self.nTaskStepIdx);
	-- 首次完成任务才有奖励
	if bAward then
		pPlayer.SendAward(tbFinishAward, nil, true, Env.LogWay_LoverTask);
		self:SendTitle(pPlayer, nTeammateId)
	end
	pPlayer.SetUserValue(self.SAVE_GROUP, self.nFinishCountIdx, nFinishCount + 1);
	self:ClearTaskData(pPlayer)
	pPlayer.CallClientScript("LoverTask:OnFinishTask")
	local szMsg = bAward and "交任務成功！" or "交任務成功，本周第一次完成任務才有獎勵！"
	pPlayer.CenterMsg(szMsg, true)
	Log("[LoverTask] fnFinishTask ok ", pPlayer.dwID, pPlayer.szName, nFinishCount, nTaskType, nTeammateId, nTaskStep, tbTaskAward and 1 or 0)
end

function LoverTask:SendTitle(pPlayer, nTeammateId)
	if GetTimeFrameState(LoverTask.szTitleFrame) == 1 then
		return
	end
	local pStayInfo = KPlayer.GetPlayerObjById(nTeammateId) or KPlayer.GetRoleStayInfo(nTeammateId)
	local szName = pStayInfo and pStayInfo.szName
	local nMySex = pPlayer.nSex
	local szTitleName = nMySex == Player.SEX_MALE and string.format("%s的藍顏", szName) or string.format("%s的紅顏", szName)
	if szName then
		pPlayer.AddTitle(LoverTask.nAddTitleId, LoverTask.nTitleTime, true, false, szTitleName)
	end
	Log("[LoverTask] fnSendTitle ", pPlayer.dwID, pPlayer.szName, nTeammateId, szName or "nil", nMySex, szTitleName)
end

function LoverTask:ClearTaskData(pPlayer)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.nTaskTypeIdx, 0);
	pPlayer.SetUserValue(self.SAVE_GROUP, self.nTaskStepIdx, 0);
	pPlayer.SetUserValue(self.SAVE_GROUP, self.nTaskTeammateIdx, 0);
	pPlayer.SetUserValue(self.SAVE_GROUP, self.nTaskStateIdx, 0);
end

function LoverTask:RecommondLover(pPlayer)
	local tbRecommondPlayer = {}
	local tbBack = {}
	local tbAllPlayer = KPlayer.GetAllPlayer()
	local nLoverSex = pPlayer.nSex == Player.SEX_MALE and Player.SEX_FEMALE or Player.SEX_MALE
	local nMyLevel = pPlayer.nLevel
	local nMyId = pPlayer.dwID
	local nNowTime = GetTime()
	for _, pPlayer in pairs(tbAllPlayer) do
		if pPlayer.nSex == nLoverSex then
			local nFinishCount = LoverTask:GetFinishCount(pPlayer)
			local nLover = Wedding:GetLover(pPlayer.dwID)
			local nEngaged = Wedding:GetEngaged(pPlayer.dwID)
			if not nLover and not nEngaged and nFinishCount < LoverTask.MAX_FINISH_COUNT then
				local nPlayerId = pPlayer.dwID
				pPlayer.tbRecommondData = pPlayer.tbRecommondData or {}
				local tbCacheRecommondData = pPlayer.tbRecommondData[nMyId]
				local nRecommondTime = tbCacheRecommondData and tbCacheRecommondData.nRecommondTime
				local tbPlayerInfo = {}
				tbPlayerInfo.pPlayer = pPlayer
				local nRecommondTime = nRecommondTime or 0
				local nDiffLevel = math.abs(nMyLevel - pPlayer.nLevel)
				tbPlayerInfo.nSort = 0
				if nRecommondTime == 0 then
					tbPlayerInfo.nSort = tbPlayerInfo.nSort - 10000000 										-- 没推荐过的保底权重
					tbPlayerInfo.nSort = tbPlayerInfo.nSort + nDiffLevel * 10000 + nFinishCount * 100  	-- 等级差优先级 》 次数优先级
				else
					tbPlayerInfo.nSort = nRecommondTime
				end
				table.insert(tbBack, tbPlayerInfo)
			end
		end
	end
	Lib:SortTable(tbBack, function (a, b)
		return a.nSort < b.nSort
	end )
	for i = 1, LoverTask.nRecommondLoverCount do
		if tbBack[i] then
			local pPlayer = tbBack[i].pPlayer
			local tbInfo = {}
			tbInfo.nLevel = pPlayer.nLevel
			tbInfo.nFaction = pPlayer.nFaction
			tbInfo.szName = pPlayer.szName
			tbInfo.nPortrait = pPlayer.nPortrait
			tbInfo.dwID = pPlayer.dwID
			tbInfo.nSort = tbBack[i].nSort
			pPlayer.tbRecommondData = Player.tbRecommondData or {}
			pPlayer.tbRecommondData[nMyId] = pPlayer.tbRecommondData[nMyId] or {}
			pPlayer.tbRecommondData[nMyId].nRecommondTime = nNowTime
			table.insert(tbRecommondPlayer, tbInfo)
		end
	end
	pPlayer.CallClientScript("LoverTask:OnRecommondLover", tbRecommondPlayer)
end

function LoverTask:GiveUpTask(pPlayer)
	local bRet, szMsg = LoverTask:CheckGiveUpTask(pPlayer)
    if not bRet then
        pPlayer.CenterMsg(szMsg, true)
        return 
    end
    local nTeammateId = pPlayer.GetUserValue(self.SAVE_GROUP, self.nTaskTeammateIdx)
	local nTaskType = pPlayer.GetUserValue(self.SAVE_GROUP, self.nTaskTypeIdx);
	local nTaskStep = pPlayer.GetUserValue(self.SAVE_GROUP, self.nTaskStepIdx);
    pPlayer.SetUserValue(self.SAVE_GROUP, self.nTaskStateIdx, self.TASK_STATE_CANCEL);
    pPlayer.CenterMsg("放棄成功", true)
    pPlayer.CallClientScript("LoverTask:OnGiveUpTask")
    Log("LoverTask fnGiveUpTask ok", pPlayer.dwID, pPlayer.szName, nTeammateId, nTaskType, nTaskStep)
end